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
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line).trim()
    if line.is_empty() {
      continue
    }
    guard line.split(";").collect() is [range, status, .. fields] else {
      fail("Invalid folding record: \{line}")
    }
    let status = status.trim()
    if nfkc {
      if status != "NFKC_CF" {
        continue
      }
    } else if status != "C" && status != "F" {
      // S is simple folding; T is Turkic tailoring, neither is default full folding.
      continue
    }
    guard fields is [mapping, ..] else {
      fail("Missing folding target: \{line}")
    }
    let range = @parsing.parse_code_point_range(range)
    guard range.start > previous_end &&
      range.start <= range.end &&
      range.end <= 0x10FFFF else {
      fail("Folding ranges must be valid, sorted and non-overlapping")
    }
    let targets = @parsing.parse_code_point_sequence(mapping)
    guard targets
      .iter()
      .all(cp => cp >= 0 && cp <= 0x10FFFF && !(cp >= 0xD800 && cp <= 0xDFFF)) else {
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
fn emit_fold_mappings(
  entries : Array[FoldMapping],
  prefix : String,
  source : String,
) -> String {
  let out = @emitter.Emitter::new()
  out.write_file_header("\{prefix} mapping data", source)
  out.write_int_array(
    "Sorted inclusive range starts",
    "\{prefix}_starts",
    entries.map(e => e.start),
    hex=true,
  )
  out.write_int_array(
    "Inclusive range ends",
    "\{prefix}_ends",
    entries.map(e => e.end),
    hex=true,
  )
  out.write("///|\nlet \{prefix}_mappings : ReadOnlyArray[String] = [\n")
  for entry in entries {
    out.write("  \{string_literal(entry.targets)},\n")
  }
  out.write(
    (
      $|]
      $|
      $|///|
      $|/// None means identity; Some("") means removal.
      $|fn lookup_\{prefix}(c : Char) -> String? {
      $|  let cp = c.to_int()
      $|  let mut low = 0
      $|  let mut high = \{prefix}_starts.length()
      $|  while low < high {
      $|    let mid = (low + high) / 2
      $|    if cp < \{prefix}_starts[mid] {
      $|      high = mid
      $|    } else if cp > \{prefix}_ends[mid] {
      $|      low = mid + 1
      $|    } else {
      $|      return Some(\{prefix}_mappings[mid])
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
