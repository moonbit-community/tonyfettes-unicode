///|
/// BMP lookups use a two-level trie with 64-entry blocks.
const CaseTrieBmpLimit : Int32 = 0x10000

///|
const CaseTrieBmpShift : Int32 = 6

///|
/// The trie covers planes 0-1, which hold every case mapping.
const CaseTrieLimit : Int32 = 0x20000

///|
/// Each supplementary top-level trie entry covers `1 << CaseTrieTopShift` code points.
const CaseTrieTopShift : Int32 = 8

///|
/// Each supplementary leaf block holds `1 << CaseTrieLeafShift` record indices.
const CaseTrieLeafShift : Int32 = 4

///|
/// Sentinel stored in `case_full_upper_deltas` / `case_full_lower_deltas` for
/// records whose full mapping needs special handling (multi-character mapping
/// or Final_Sigma on U+03A3). Strictly larger than any valid code point delta.
const CaseSpecialSentinel : Int32 = 0x4000_0000

///|
/// Internal flag bit marking U+03A3 (Final_Sigma) so it gets a dedicated
/// record with `CaseSpecialSentinel` in `case_full_lower_deltas` without
/// changing its simple lowercase delta or `case_special_flags` bits 0..2.
const CaseFinalSigmaFlag : Int32 = 8

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
        "Case mapping at or above \{@emitter.hex_literal(CaseTrieLimit)} needs trie coverage",
      )
    }
    deltas[entry.code_point] = entry.target - entry.code_point
  }
  let special : Map[Int32, Array[Int32]] = Map([])
  for entry in special_casing {
    guard entry.code_point < CaseTrieLimit else {
      fail(
        "Case mapping at or above \{@emitter.hex_literal(CaseTrieLimit)} needs trie coverage",
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
    for index, table in cases {
      let delta = record[index]
      if delta != 0 {
        let target = code_point + delta
        if code_point < CaseTrieBmpLimit {
          guard target >= 0 && target < CaseTrieBmpLimit else {
            fail(
              "BMP simple \{table.name}case mapping crosses BMP at \{@emitter.hex_literal(code_point)}",
            )
          }
        } else {
          guard target >= CaseTrieBmpLimit && target <= 0x10FFFF else {
            fail(
              "Supplementary simple \{table.name}case mapping leaves supplementary plane at \{@emitter.hex_literal(code_point)}",
            )
          }
        }
      }
    }
    let mut flags = 0
    for bit, table in cases {
      if table.special.contains(code_point) {
        flags = flags | (1 << bit)
      }
    }
    if code_point == 0x03A3 && cases[1].deltas[code_point] != 0 {
      flags = flags | CaseFinalSigmaFlag
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
  // BMP two-level trie: 64-entry blocks -> 1024-entry Bytes index.
  let bmp = @emitter.deduplicate_blocks(
    values[:CaseTrieBmpLimit].to_owned(),
    1 << CaseTrieBmpShift,
  )
  guard bmp.ids.all(id => id < 0x100) else {
    fail("Case mapping BMP trie has too many blocks for one byte")
  }
  // Plane 1 three-level trie: 16-entry leaf blocks.
  let supp_leaf = @emitter.deduplicate_blocks(
    values[CaseTrieBmpLimit:CaseTrieLimit].to_owned(),
    1 << CaseTrieLeafShift,
  )
  let supp_mid = @emitter.deduplicate_blocks(
    supp_leaf.ids,
    1 << (CaseTrieTopShift - CaseTrieLeafShift),
  )
  guard supp_mid.ids.all(id => id < 0x100) else {
    fail("Case mapping plane-1 trie has too many mid blocks for one byte")
  }
  guard supp_mid.blocks.all(id => id < 0x100) else {
    fail("Case mapping plane-1 trie has too many leaf blocks for one byte")
  }
  let bmp_mask = (1 << CaseTrieBmpShift) - 1
  let mid_shift = CaseTrieTopShift - CaseTrieLeafShift
  let mid_mask = (1 << mid_shift) - 1
  let leaf_mask = (1 << CaseTrieLeafShift) - 1
  // Validate every index and decoded record before emitting unsafe_get.
  for cp in 0..<CaseTrieBmpLimit {
    let idx = cp >> CaseTrieBmpShift
    let off = (bmp.ids[idx] << CaseTrieBmpShift) | (cp & bmp_mask)
    guard idx >= 0 &&
      idx < bmp.ids.length() &&
      off >= 0 &&
      off < bmp.blocks.length() else {
      fail(
        "Case mapping BMP index out of bounds at \{@emitter.hex_literal(cp)}",
      )
    }
    let rec = bmp.blocks[off]
    guard rec == values[cp] && rec >= 0 && rec < records.length() else {
      fail("Case mapping BMP mismatch at \{@emitter.hex_literal(cp)}")
    }
  }
  for cp in CaseTrieBmpLimit..<CaseTrieLimit {
    let top_idx = (cp - CaseTrieBmpLimit) >> CaseTrieTopShift
    let mid_idx = (supp_mid.ids[top_idx] << mid_shift) |
      ((cp >> CaseTrieLeafShift) & mid_mask)
    let off = (supp_mid.blocks[mid_idx] << CaseTrieLeafShift) | (cp & leaf_mask)
    guard top_idx >= 0 &&
      top_idx < supp_mid.ids.length() &&
      mid_idx >= 0 &&
      mid_idx < supp_mid.blocks.length() &&
      off >= 0 &&
      off < supp_leaf.blocks.length() else {
      fail(
        "Case mapping plane-1 index out of bounds at \{@emitter.hex_literal(cp)}",
      )
    }
    let rec = supp_leaf.blocks[off]
    guard rec == values[cp] && rec >= 0 && rec < records.length() else {
      fail("Case mapping plane-1 mismatch at \{@emitter.hex_literal(cp)}")
    }
  }
  let bmp_limit = @emitter.hex_literal(CaseTrieBmpLimit)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Case mapping lookup data", "UnicodeData.txt and SpecialCasing.txt",
  )
  out.write_byte_array(
    "Case mapping BMP trie index: `cp >> \{CaseTrieBmpShift}` to leaf block index",
    "case_bmp_index",
    bmp.ids,
  )
  out.write_byte_array(
    "Case mapping BMP trie leaf: record indices in blocks of \{1 << CaseTrieBmpShift}",
    "case_bmp_leaf",
    bmp.blocks,
  )
  out.write_byte_array(
    "Case mapping plane-1 trie top level: `(cp - \{bmp_limit}) >> \{CaseTrieTopShift}` to mid block index",
    "case_supp_top",
    supp_mid.ids,
  )
  out.write_byte_array(
    "Case mapping plane-1 trie mid level: leaf block indices",
    "case_supp_mid",
    supp_mid.blocks,
  )
  out.write_byte_array(
    "Case mapping plane-1 trie leaf level: record indices in blocks of \{1 << CaseTrieLeafShift}",
    "case_supp_leaf",
    supp_leaf.blocks,
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
    records.map(record => record[cases.length()] & 7),
  )
  out.write(
    (
      $|///|
      $|/// Sentinel in `case_full_upper_deltas` and `case_full_lower_deltas`
      $|/// indicating that the character needs special full mapping or Final_Sigma.
      $|const CaseSpecialSentinel : Int = \{@emitter.hex_literal(CaseSpecialSentinel)}
      $|
    ),
  )
  out.write_int_array(
    "Full uppercase mapping of each record: `target - code point`, or `CaseSpecialSentinel` for special mappings",
    "case_full_upper_deltas",
    records.map(record => {
      if (record[cases.length()] & 1) != 0 {
        CaseSpecialSentinel
      } else {
        record[0]
      }
    }),
    hex=false,
  )
  out.write_int_array(
    "Full lowercase mapping of each record: `target - code point`, or `CaseSpecialSentinel` for special mappings or Final_Sigma",
    "case_full_lower_deltas",
    records.map(record => {
      if (record[cases.length()] & (2 | CaseFinalSigmaFlag)) != 0 {
        CaseSpecialSentinel
      } else {
        record[1]
      }
    }),
    hex=false,
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
    out.write_string_array(
      "Full \{table.name}case mapping of each such code point",
      "special_\{table.name}_strings",
      code_points.map(code_point => table.special[code_point]),
    )
  }
  out.write_string_array(
    "One-character strings of the ASCII characters, so that mapping to one allocates nothing",
    "ascii_strings",
    Array::makei(0x80, code_point => [code_point]),
  )
  out.write(
    (
      $|///|
      $|/// Cold supplementary case record lookup for `cp >= \{bmp_limit}`.
      $|#inline(never)
      $|fn lookup_case_record_supp(cp : Int) -> Int {
      $|  if cp >= \{@emitter.hex_literal(CaseTrieLimit)} {
      $|    return 0
      $|  }
      $|  // SAFETY: cp is in [\{bmp_limit}, \{@emitter.hex_literal(CaseTrieLimit)}); generator validated all indices.
      $|  let mid = (case_supp_top.unsafe_get((cp - \{bmp_limit}) >> \{CaseTrieTopShift}).to_int() << \{mid_shift}) |
      $|    ((cp >> \{CaseTrieLeafShift}) & \{mid_mask})
      $|  let leaf = case_supp_mid.unsafe_get(mid).to_int()
      $|  case_supp_leaf.unsafe_get((leaf << \{CaseTrieLeafShift}) | (cp & \{leaf_mask})).to_int()
      $|}
      $|
      $|///|
      $|/// Index of the record holding a BMP code point's case mappings (`0 <= cp < \{bmp_limit}`).
      $|fn lookup_case_record_bmp(cp : Int) -> Int {
      $|  // SAFETY: callers guarantee cp is in [0, \{bmp_limit}); generator validated all indices.
      $|  let block = case_bmp_index.unsafe_get(cp >> \{CaseTrieBmpShift}).to_int()
      $|  case_bmp_leaf.unsafe_get((block << \{CaseTrieBmpShift}) | (cp & \{bmp_mask})).to_int()
      $|}
      $|
      $|///|
      $|/// Index of the record holding a character's case mappings
      $|fn lookup_case_record(c : Char) -> Int {
      $|  let cp = c.to_int()
      $|  if cp >= \{bmp_limit} {
      $|    return lookup_case_record_supp(cp)
      $|  }
      $|  // SAFETY: cp is in [0, \{bmp_limit}); generator validated all indices.
      $|  let block = case_bmp_index.unsafe_get(cp >> \{CaseTrieBmpShift}).to_int()
      $|  case_bmp_leaf.unsafe_get((block << \{CaseTrieBmpShift}) | (cp & \{bmp_mask})).to_int()
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
        $|  (c.to_int() + case_\{name}_deltas.unsafe_get(lookup_case_record(c))).unsafe_to_char()
        $|}
        $|
        $|///|
        $|/// Full \{name}case mapping of a character as a string
        $|/// Returns the character itself if no mapping exists
        $|pub fn full_\{name}case(c : Char) -> String {
        $|  let record = lookup_case_record(c)
        $|  if (case_special_flags.unsafe_get(record).to_int() & \{flag}) != 0 {
        $|    let index = find_special_\{name}(c.to_int())
        $|    if index >= 0 {
        $|      return special_\{name}_strings[index]
        $|    }
        $|  }
        $|  let target = c.to_int() + case_\{name}_deltas.unsafe_get(record)
        $|  if target < 0x80 {
        $|    ascii_strings.unsafe_get(target)
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
        $|  if (case_special_flags.unsafe_get(record).to_int() & \{flag}) != 0 {
        $|    let index = find_special_\{name}(c.to_int())
        $|    if index >= 0 {
        $|      return Some(special_\{name}_strings[index].to_array())
        $|    }
        $|  }
        $|  let delta = case_\{name}_deltas.unsafe_get(record)
        $|  if delta == 0 {
        $|    None
        $|  } else {
        $|    Some([(c.to_int() + delta).unsafe_to_char()])
        $|  }
        $|}
        $|
      ),
    )
    out.write_sorted_search(
      name="find_special_\{name}",
      values="special_\{name}_cps",
    )
  }
  out.finish()
}
