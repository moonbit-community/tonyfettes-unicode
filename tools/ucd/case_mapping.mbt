///|
/// The trie covers planes 0-1, which hold every case mapping.
const CaseTrieLimit : Int32 = 0x20000

///|
/// Each top-level trie entry covers `1 << CaseTrieTopShift` code points.
const CaseTrieTopShift : Int32 = 8

///|
/// Each leaf block holds `1 << CaseTrieLeafShift` record indices.
const CaseTrieLeafShift : Int32 = 4

///|
/// One case conversion: its simple mappings as per-code-point deltas, and
/// the full mappings that differ from the simple one.
priv struct CaseTable {
  /// "upper", "lower" or "title": the prefix of generated table names.
  name : String
  /// `target - code_point` of the simple mapping, 0 where there is none.
  deltas : Array[Int32]
  /// Full mappings other than the single simple target, by code point.
  special : Map[Int32, Array[Int32]]
}

///|
fn CaseTable::new(
  name : String,
  simple : Array[SimpleMappingEntry],
  special_casing : Array[FullMappingEntry],
) -> CaseTable raise {
  let deltas = Array::make(CaseTrieLimit, 0)
  for entry in simple {
    guard entry.code_point < CaseTrieLimit else {
      fail(
        "Case mapping at or above \{hex_literal(CaseTrieLimit)} needs trie coverage",
      )
    }
    deltas[entry.code_point] = entry.target - entry.code_point
  }
  let special : Map[Int32, Array[Int32]] = Map([])
  for entry in special_casing {
    guard entry.code_point < CaseTrieLimit else {
      fail(
        "Case mapping at or above \{hex_literal(CaseTrieLimit)} needs trie coverage",
      )
    }
    // A full mapping overrides the simple one. When they agree, the simple
    // delta already describes it.
    let simple_target = entry.code_point + deltas[entry.code_point]
    if entry.targets == [simple_target] {
      special.remove(entry.code_point)
    } else {
      special[entry.code_point] = entry.targets
    }
  }
  { name, deltas, special, }
}

///|
/// A MoonBit string literal of the given code points.
fn string_literal(code_points : Array[Int32]) -> String {
  let literal = StringBuilder()
  literal.write_char('"')
  for code_point in code_points {
    literal.write_string("\\u{\{@emitter.hex_upper(code_point, min_width=4)}}")
  }
  literal.write_char('"')
  literal.to_string()
}

///|
/// Emit case mapping data as a three-level trie from code points to shared
/// records, plus the few full mappings that are not a single character.
///
/// A record holds the simple uppercase, lowercase and titlecase deltas of a
/// code point and one flag per case telling whether the code point also has
/// a special full mapping. Most cased characters share a record, so record
/// indices fit in one byte and identical trie blocks are shared.
pub fn emit_case_mapping(
  data : UnicodeData,
  special_casing : SpecialCasingData,
) -> String raise {
  let cases = [
    CaseTable::new("upper", data.simple_uppercase, special_casing.upper_mapping),
    CaseTable::new("lower", data.simple_lowercase, special_casing.lower_mapping),
    CaseTable::new("title", data.simple_titlecase, special_casing.title_mapping),
  ]
  // A record is one delta per case followed by the special-mapping flags.
  // Record 0 is a code point without any case mapping.
  let record_ids : Map[Array[Int32], Int32] = Map([([0, 0, 0, 0], 0)])
  let records : Array[Array[Int32]] = [[0, 0, 0, 0]]
  let values = Array::make(CaseTrieLimit, 0)
  for code_point in 0..<CaseTrieLimit {
    let record = cases.map(table => table.deltas[code_point])
    let mut flags = 0
    for bit, table in cases {
      if table.special.contains(code_point) {
        flags = flags | (1 << bit)
      }
    }
    record.push(flags)
    values[code_point] = match record_ids.get(record) {
      Some(id) => id
      None => {
        let id = records.length()
        record_ids[record] = id
        records.push(record)
        id
      }
    }
  }
  guard records.length() <= 0x100 else {
    fail("Case mapping has too many distinct records for one byte")
  }
  // Leaf level: blocks of record indices.
  let leaf = @trie.deduplicate_blocks(values, 1 << CaseTrieLeafShift)
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = @trie.deduplicate_blocks(
    leaf.ids,
    1 << (CaseTrieTopShift - CaseTrieLeafShift),
  )
  guard mid.ids.iter().all(id => id < 0x100) else {
    fail("Case mapping trie has too many mid blocks for one byte")
  }
  guard mid.blocks.iter().all(id => id < 0x100) else {
    fail("Case mapping trie has too many leaf blocks for one byte")
  }
  let mid_mask = (1 << (CaseTrieTopShift - CaseTrieLeafShift)) - 1
  let leaf_mask = (1 << CaseTrieLeafShift) - 1
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Case mapping lookup data", "UnicodeData.txt and SpecialCasing.txt",
  )
  out.write_byte_array(
    "Case mapping trie top level: `cp >> \{CaseTrieTopShift}` to mid block index",
    "case_trie_top",
    mid.ids,
  )
  out.write_byte_array(
    "Case mapping trie mid level: leaf block indices",
    "case_trie_mid",
    mid.blocks,
  )
  out.write_byte_array(
    "Case mapping trie leaf level: record indices in blocks of \{1 << CaseTrieLeafShift}",
    "case_trie_leaf",
    leaf.blocks,
  )
  for index, table in cases {
    out.write_int_array(
      "Simple \{table.name}case mapping of each record as `target - code point`",
      "case_\{table.name}_deltas",
      records.map(record => record[index]),
      hex=false,
    )
  }
  out.write_byte_array(
    "Special full mappings of each record: bit 0 upper, bit 1 lower, bit 2 title",
    "case_special_flags",
    records.map(record => record[cases.length()]),
  )
  for table in cases {
    let code_points = table.special.keys().collect()
    code_points.sort()
    out.write_int_array(
      "Code points whose full \{table.name}case mapping is not their simple one (sorted for binary search)",
      "special_\{table.name}_cps",
      code_points,
      hex=true,
    )
    out.write("///|\n")
    out.write("/// Full \{table.name}case mapping of each such code point\n")
    out.write("let special_\{table.name}_strings : ReadOnlyArray[String] = [\n")
    for code_point in code_points {
      if table.special.get(code_point) is Some(targets) {
        out.write("  \{string_literal(targets)},\n")
      }
    }
    out.write("]\n\n")
  }
  out.write("///|\n")
  out.write(
    "/// One-character strings of the ASCII characters, so that mapping to one allocates nothing\n",
  )
  out.write("let ascii_strings : ReadOnlyArray[String] = [\n")
  for code_point in 0..<0x80 {
    out.write("  \{string_literal([code_point])},\n")
  }
  out.write("]\n\n")
  out.write(
    (
      $|///|
      $|/// Index of the record holding a character's case mappings
      $|fn lookup_case_record(c : Char) -> Int {
      $|  let cp = c.to_int()
      $|  if cp >= \{hex_literal(CaseTrieLimit)} {
      $|    return 0
      $|  }
      $|  let mid = (case_trie_top[cp >> \{CaseTrieTopShift}].to_int() << \{CaseTrieTopShift - CaseTrieLeafShift}) |
      $|    ((cp >> \{CaseTrieLeafShift}) & \{mid_mask})
      $|  let leaf = case_trie_mid[mid].to_int()
      $|  case_trie_leaf[(leaf << \{CaseTrieLeafShift}) | (cp & \{leaf_mask})].to_int()
      $|}
      $|
      $|///|
      $|/// Binary search helper - returns index if found, -1 otherwise
      $|fn binary_search_case(arr : ReadOnlyArray[Int], cp : Int) -> Int {
      $|  let mut left = 0
      $|  let mut right = arr.length() - 1
      $|
      $|  while left <= right {
      $|    let mid = (left + right) / 2
      $|    let mid_cp = arr[mid]
      $|
      $|    if cp < mid_cp {
      $|      right = mid - 1
      $|    } else if cp > mid_cp {
      $|      left = mid + 1
      $|    } else {
      $|      return mid
      $|    }
      $|  }
      $|
      $|  -1
      $|}
      $|
    ),
  )
  for bit, table in cases {
    let name = table.name
    let flag = 1 << bit
    out.write(
      (
        $|///|
        $|/// Look up simple \{name}case mapping for a character
        $|/// Returns the character itself if no mapping exists
        $|pub fn lookup_simple_\{name}case(c : Char) -> Char {
        $|  (c.to_int() + case_\{name}_deltas[lookup_case_record(c)]).unsafe_to_char()
        $|}
        $|
        $|///|
        $|/// Full \{name}case mapping of a character as a string
        $|/// Returns the character itself if no mapping exists
        $|pub fn full_\{name}case(c : Char) -> String {
        $|  let record = lookup_case_record(c)
        $|  if (case_special_flags[record].to_int() & \{flag}) != 0 {
        $|    let index = binary_search_case(special_\{name}_cps, c.to_int())
        $|    if index >= 0 {
        $|      return special_\{name}_strings[index]
        $|    }
        $|  }
        $|  let target = c.to_int() + case_\{name}_deltas[record]
        $|  if target < 0x80 {
        $|    ascii_strings[target]
        $|  } else {
        $|    target.unsafe_to_char().to_string()
        $|  }
        $|}
        $|
        $|///|
        $|/// Look up full \{name}case mapping for a character
        $|/// Returns Some(array of chars) if a mapping exists, None otherwise
        $|pub fn lookup_full_\{name}case(c : Char) -> Array[Char]? {
        $|  let record = lookup_case_record(c)
        $|  if (case_special_flags[record].to_int() & \{flag}) != 0 {
        $|    let index = binary_search_case(special_\{name}_cps, c.to_int())
        $|    if index >= 0 {
        $|      return Some(special_\{name}_strings[index].to_array())
        $|    }
        $|  }
        $|  let delta = case_\{name}_deltas[record]
        $|  if delta == 0 {
        $|    None
        $|  } else {
        $|    Some([(c.to_int() + delta).unsafe_to_char()])
        $|  }
        $|}
        $|
      ),
    )
  }
  out.finish()
}
