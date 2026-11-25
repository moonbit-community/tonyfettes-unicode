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
/// Number of distinct deltas a folding trie can encode: kinds 0 and 1 are
/// taken, and bit 7 holds the normalization quick-check flag (`0x80`).
const FoldDeltaLimit : Int32 = 126

///|
/// Bit 7 of a folding trie entry:
/// - For `case_folding`: set when the code point or any code point in its
///   folding has `CCC != 0` or `NFD_QC != Yes`.
/// - For `nfkc_casefold`: set when any code point in the NFKC_CF output
///   (the code point itself when unchanged) has `CCC != 0` or `NFC_QC != Yes`.
const FoldNormFlagBit : Int32 = 0x80

///|
/// Mask for the folding kind in bits 0..6.
const FoldKindMask : Int32 = 0x7F

///|
/// Emit folding data in two parts.
///
/// `<prefix>_kind` is a byte-valued trie giving every code point a 7-bit kind
/// in bits 0..6 and a normalization flag in bit 7 (`0x80`):
/// - kind 0: the code point folds to itself
/// - kind 1: its mapping must be looked up with `lookup_<prefix>`
/// - kind >= 2: single-code-point mapping `cp + <prefix>_deltas[kind]`
///
/// The generator guarantees that every BMP code point with `kind >= 2` maps to
/// a BMP code point, so BMP delta folding preserves UTF-16 length.
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
  norm_props : Array[Int32],
  nfkc~ : Bool,
) -> String raise {
  let counts : Map[Int32, Int32] = Map([])
  for entry in entries {
    if entry.targets is [target] {
      for cp in entry.start..<=entry.end {
        // Keep BMP-to-supplementary mappings in the searched table so BMP
        // delta folding always writes a single UTF-16 code unit.
        if cp < 0x10000 && target >= 0x10000 {
          continue
        }
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
  let delta_limit = if ranked.length() < FoldDeltaLimit {
    ranked.length()
  } else {
    FoldDeltaLimit
  }
  for pair in ranked[:delta_limit] {
    kinds.set(pair.0, deltas.length())
    deltas.push(pair.0)
  }
  // Normalization quick-check mask:
  // - NFKC_Casefold ends with NFC: CCC != 0 or NFC_QC != Yes (bits 8..9)
  // - Canonical case fold uses NFD: CCC != 0 or NFD_QC != Yes (bit 12)
  let norm_mask = if nfkc { 255 | (3 << 8) } else { 255 | (1 << 12) }
  let values = FixedArray::make(@emitter.MaxCodePoint + 1, 0)
  for cp in 0..<=@emitter.MaxCodePoint {
    if (norm_props[cp] & norm_mask) != 0 {
      values[cp] = FoldNormFlagBit
    }
  }
  let searched = []
  for entry in entries {
    let target_needs_norm = entry.targets.any(t => {
      (norm_props[t] & norm_mask) != 0
    })
    let mut found = false
    for cp in entry.start..<=entry.end {
      let kind = if entry.targets is [target] &&
        !(cp < 0x10000 && target >= 0x10000) {
        kinds.get(target - cp).unwrap_or(1)
      } else {
        1
      }
      let flag = if nfkc {
        if target_needs_norm {
          FoldNormFlagBit
        } else {
          0
        }
      } else if target_needs_norm || (norm_props[cp] & norm_mask) != 0 {
        FoldNormFlagBit
      } else {
        0
      }
      values[cp] = kind | flag
      found = found || kind == 1
    }
    if found {
      searched.push(entry)
    }
  }
  // The folding code maps ASCII without the tables, A-Z to a-z only, and
  // relies on ASCII never needing normalization.
  for cp in 0..<0x80 {
    let delta = if cp >= 'A' && cp <= 'Z' { 32 } else { 0 }
    let val = values[cp]
    let kind = val & FoldKindMask
    guard (val & FoldNormFlagBit) == 0 else {
      fail(
        "\{prefix} marks ASCII \{@emitter.hex_literal(cp)} as needing normalization",
      )
    }
    guard kind != 1 && deltas[kind] == delta else {
      fail(
        "\{prefix} folds ASCII \{@emitter.hex_literal(cp)} other than A-Z to a-z",
      )
    }
  }
  // Exhaustively verify delta indices and BMP preservation so runtime lookups
  // can read `<prefix>_deltas` unchecked and write BMP deltas as one unit.
  for cp in 0..<=@emitter.MaxCodePoint {
    let kind = values[cp] & FoldKindMask
    guard kind < deltas.length() else {
      fail("\{prefix} kind out of bounds at \{@emitter.hex_literal(cp)}")
    }
    if cp < 0x10000 && kind >= 2 {
      let target = cp + deltas[kind]
      guard target >= 0 &&
        target < 0x10000 &&
        !(target >= 0xD800 && target <= 0xDFFF) else {
        fail("\{prefix} BMP delta leaves BMP at \{@emitter.hex_literal(cp)}")
      }
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
  let flag_doc = if nfkc {
    "Bit 7 (`0x80`) is set when any code point in the NFKC_CF output has CCC != 0 or NFC_QC != Yes."
  } else {
    "Bit 7 (`0x80`) is set when `cp` or any code point in its folding has CCC != 0 or NFD_QC != Yes."
  }
  out.write_value_trie(
    property="\{prefix} kind",
    prefix="\{prefix}_kind",
    lookup="fn \{prefix}_kind",
    lookup_doc=[
      "How `cp` folds in bits 0..6: 0 to itself, 1 to `lookup_\{prefix}`,",
      "and from 2 on to `cp + \{prefix}_deltas[kind]`.",
      flag_doc,
    ],
    value_bits=8,
    takes_code_point=true,
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
        $|    } else if cp > \{prefix}_ends.unsafe_get(mid) {
      ),
      "the range holding `cp`",
    )
  } else {
    (
      (
        $|    } else if cp > \{prefix}_starts.unsafe_get(mid) {
      ),
      "`cp`",
    )
  }
  out.write(
    (
      $|///|
      $|/// The mapping of \{found_doc}, as a view of `\{prefix}_text`, for
      $|/// a code point of kind 1. None means identity; an empty view means
      $|/// removal.
      $|fn lookup_\{prefix}(cp : Int32) -> StringView? {
      $|  let mut low = 0
      $|  let mut high = \{prefix}_starts.length()
      $|  while low < high {
      $|    let mid = (low + high) / 2
      $|    // SAFETY: 0 <= low <= mid < high <= starts.length(), and offsets has starts.length() + 1 entries.
      $|    if cp < \{prefix}_starts.unsafe_get(mid) {
      $|      high = mid
      $|\{found_test}
      $|      low = mid + 1
      $|    } else {
      $|      return Some(
      $|        \{prefix}_text.unsafe_view(
      $|          start=\{prefix}_offsets.unsafe_get(mid).to_int(),
      $|          end=\{prefix}_offsets.unsafe_get(mid + 1).to_int(),
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
pub fn emit_case_folding(
  content : String,
  unicode_data : UnicodeData,
  derived_properties : String,
) -> String raise {
  let norm_props = normalization_values(unicode_data.ccc, derived_properties)
  emit_fold_mappings(
    parse_fold_mappings(content, nfkc=false),
    "case_folding",
    "CaseFolding.txt (C and F mappings), UnicodeData.txt, and DerivedNormalizationProps.txt",
    norm_props,
    nfkc=false,
  )
}

///|
pub fn emit_nfkc_casefold(
  unicode_data : UnicodeData,
  derived_properties : String,
) -> String raise {
  let norm_props = normalization_values(unicode_data.ccc, derived_properties)
  emit_fold_mappings(
    parse_fold_mappings(derived_properties, nfkc=true),
    "nfkc_casefold",
    "DerivedNormalizationProps.txt (NFKC_CF) and UnicodeData.txt",
    norm_props,
    nfkc=true,
  )
}
