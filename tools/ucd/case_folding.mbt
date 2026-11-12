///|
priv struct FoldMapping {
  start : Int32
  end : Int32
  targets : Array[Int32]
}

///|
fn parse_fold_mappings(
  content : String,
  nfkc~ : Bool,
) -> Array[FoldMapping] raise {
  let entries : Array[FoldMapping] = []
  let mut previous_end = -1
  for record in @parsing.data_lines(content) {
    guard record is [range, status, .. fields] else {
      fail("Invalid folding record: \{record[0]}")
    }
    if nfkc {
      if status != "NFKC_CF" {
        continue
      }
    } else if status != "C" && status != "F" {
      // S is simple folding; T is Turkic tailoring, neither is default full folding.
      continue
    }
    guard fields is [mapping, ..] else {
      fail("Missing folding target: \{range}")
    }
    let range = @parsing.parse_code_point_range(range)
    guard range.start > previous_end &&
      range.start <= range.end &&
      range.end <= 0x10FFFF else {
      fail("Folding ranges must be valid, sorted and non-overlapping")
    }
    let targets = @parsing.parse_code_point_sequence(mapping)
    guard targets.all(cp => {
      cp >= 0 && cp <= 0x10FFFF && !(cp >= 0xD800 && cp <= 0xDFFF)
    }) else {
      fail("Invalid folding target")
    }
    if !nfkc && (range.start != range.end || targets.is_empty()) {
      fail("Invalid full case folding mapping")
    }
    entries.push({ start: range.start, end: range.end, targets, })
    previous_end = range.end
  }
  guard !entries.is_empty() else { fail("Missing folding mappings") }
  entries
}

///|
/// Number of distinct deltas a folding trie can encode: its values fit in a
/// byte, and kinds 0 and 1 are taken.
const FoldDeltaLimit : Int32 = 254

///|
/// Emit folding data in two parts.
///
/// `<prefix>_kind` is a byte-valued trie giving every code point a kind:
/// 0 when the code point folds to itself, 1 when its mapping must be looked up
/// with `lookup_<prefix>`, and from 2 on an index into `<prefix>_deltas`, for
/// a mapping to the single code point `cp + <prefix>_deltas[kind]`. The most
/// frequent deltas get a kind, so nearly every cased letter is folded without
/// a search.
///
/// `lookup_<prefix>` searches the entries holding a code point of kind 1:
/// sorted range starts (plus range ends when some range covers more than one
/// code point), with all targets packed into one string and sliced by 16-bit
/// offsets. One string instead of a string per mapping keeps the table free of
/// pointers and per-literal headers.
fn emit_fold_mappings(
  entries : Array[FoldMapping],
  prefix : String,
  source : String,
) -> String raise {
  let counts : Map[Int32, Int32] = Map([])
  for entry in entries {
    if entry.targets is [target] {
      for cp in entry.start..<=entry.end {
        counts.set(target - cp, counts.get(target - cp).unwrap_or(0) + 1)
      }
    }
  }
  // Most frequent first; equal counts by delta, so the output is stable.
  let ranked = counts.to_array()
  ranked.sort_by((a, b) => {
    if a.1 != b.1 {
      b.1.compare(a.1)
    } else {
      a.0.compare(b.0)
    }
  })
  let deltas = [0, 0]
  let kinds : Map[Int32, Int32] = Map([])
  for pair in ranked[:FoldDeltaLimit] {
    kinds.set(pair.0, deltas.length())
    deltas.push(pair.0)
  }
  let values = FixedArray::make(@emitter.MaxCodePoint + 1, 0)
  let searched = []
  for entry in entries {
    let mut found = false
    for cp in entry.start..<=entry.end {
      let kind = if entry.targets is [target] {
        kinds.get(target - cp).unwrap_or(1)
      } else {
        1
      }
      values[cp] = kind
      found = found || kind == 1
    }
    if found {
      searched.push(entry)
    }
  }
  let has_ranges = searched.any(e => e.start != e.end)
  let text : Array[Int32] = []
  let offsets = [0]
  let mut units = 0
  for entry in searched {
    for target in entry.targets {
      text.push(target)
      units += if target > 0xFFFF { 2 } else { 1 }
    }
    offsets.push(units)
  }
  let out = @emitter.Emitter::new()
  out.write_file_header("\{prefix} mapping data", source)
  out.write_value_trie(
    property="\{prefix} kind",
    prefix="\{prefix}_kind",
    lookup="fn \{prefix}_kind",
    lookup_doc=[
      "How `c` folds: 0 to itself, 1 to the mapping `lookup_\{prefix}` finds,",
      "and from 2 on to the code point `c + \{prefix}_deltas[kind]`.",
    ],
    value_bits=8,
    values,
  )
  out.write_int_array(
    "Code point deltas by kind; kinds 0 and 1 have none",
    "\{prefix}_deltas",
    deltas,
    hex=false,
  )
  out.write_int_array(
    if has_ranges {
      "Sorted inclusive range starts of the entries with a code point of kind 1"
    } else {
      "Sorted code points of kind 1"
    },
    "\{prefix}_starts",
    searched.map(e => e.start),
    hex=true,
  )
  if has_ranges {
    out.write_int_array(
      "Inclusive range ends",
      "\{prefix}_ends",
      searched.map(e => e.end),
      hex=true,
    )
  }
  out.write_uint16_array(
    "UTF-16 offsets into `\{prefix}_text`: entry `i` maps to `[offsets[i], offsets[i + 1])`",
    "\{prefix}_offsets",
    offsets,
  )
  out.write("///|\n/// Targets of all entries, concatenated\n")
  out.write(
    "let \{prefix}_text : String = \{@emitter.string_literal(text)}\n\n",
  )
  let (found_test, found_doc) = if has_ranges {
    (
      (
        $|    } else if cp > \{prefix}_ends[mid] {
      ),
      "the range holding `c`",
    )
  } else {
    (
      (
        $|    } else if cp > \{prefix}_starts[mid] {
      ),
      "`c`",
    )
  }
  out.write(
    (
      $|///|
      $|/// The mapping of \{found_doc}, as a view of `\{prefix}_text`, for
      $|/// a code point of kind 1. None means identity; an empty view means
      $|/// removal.
      $|fn lookup_\{prefix}(c : Char) -> StringView? {
      $|  let cp = c.to_int()
      $|  let mut low = 0
      $|  let mut high = \{prefix}_starts.length()
      $|  while low < high {
      $|    let mid = (low + high) / 2
      $|    if cp < \{prefix}_starts[mid] {
      $|      high = mid
      $|\{found_test}
      $|      low = mid + 1
      $|    } else {
      $|      return Some(
      $|        \{prefix}_text.unsafe_view(
      $|          start=\{prefix}_offsets[mid].to_int(),
      $|          end=\{prefix}_offsets[mid + 1].to_int(),
      $|        ),
      $|      )
      $|    }
      $|  }
      $|  None
      $|}
      $|
    ),
  )
  out.finish()
}

///|
pub fn emit_case_folding(content : String) -> String raise {
  emit_fold_mappings(
    parse_fold_mappings(content, nfkc=false),
    "case_folding",
    "CaseFolding.txt (C and F mappings)",
  )
}

///|
pub fn emit_nfkc_casefold(content : String) -> String raise {
  emit_fold_mappings(
    parse_fold_mappings(content, nfkc=true),
    "nfkc_casefold",
    "DerivedNormalizationProps.txt (NFKC_CF)",
  )
}
