///|
const MaxCodePoint : Int32 = 0x10FFFF

///|
/// Number of low bits holding the status code in a packed trie value or range.
const IdnaStatusBits : Int32 = 3

///|
/// Status code of code points the mapping table does not list.
const IdnaDisallowed : Int32 = 4

///|
/// The trie covers planes 0-3; the higher planes hold a few long ranges
/// without mappings and are looked up as packed ranges instead.
const IdnaTrieLimit : Int32 = 0x40000

///|
/// Each top-level trie entry covers `1 << IdnaTrieTopShift` code points.
const IdnaTrieTopShift : Int32 = 8

///|
/// Each leaf block holds `1 << IdnaTrieLeafShift` packed values.
const IdnaTrieLeafShift : Int32 = 4

///|
priv struct MappingEntry {
  start : Int32
  end : Int32
  status : String
  mapping : Array[Int32]
}

///|
priv struct JoiningEntry {
  start : Int32
  end : Int32
  joining_type : String
}

///|
fn parse_mapping_table(content : String) -> Array[MappingEntry] raise {
  let entries : Array[MappingEntry] = []
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() < 2 {
      continue
    }
    let range = @parsing.parse_code_point_range(fields[0])
    let status = fields[1]
      .trim()
      .to_owned()
      .to_lower()
      .replace_all(old=" ", new="_")
    let mapping = if fields.length() > 2 {
      @parsing.parse_code_point_sequence(fields[2])
    } else {
      []
    }
    entries.push({ start: range.start, end: range.end, status, mapping, })
  }
  entries
}

///|
fn parse_joining_table(content : String) -> Array[JoiningEntry] raise {
  let entries : Array[JoiningEntry] = []
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() < 2 {
      continue
    }
    let range = @parsing.parse_code_point_range(fields[0])
    entries.push({
      start: range.start,
      end: range.end,
      joining_type: fields[1].trim().to_owned(),
    })
  }
  entries
}

///|
fn status_code(status : StringView) -> Int32 {
  match status {
    "valid" => 0
    "ignored" => 1
    "mapped" => 2
    "deviation" => 3
    "disallowed" => 4
    "disallowed_std3_valid" => 5
    "disallowed_std3_mapped" => 6
    _ => 4
  }
}

///|
/// Append a packed range unless it continues the status of the previous one.
fn push_high_range(
  ranges : Array[Int32],
  start : Int32,
  status : Int32,
) -> Unit {
  let status_mask = (1 << IdnaStatusBits) - 1
  if ranges.last() is Some(previous) && (previous & status_mask) == status {
    return
  }
  ranges.push((start << IdnaStatusBits) | status)
}

///|
/// Emit the IDNA mapping table as a three-level trie for planes 0-3, with
/// packed ranges for the remaining planes.
///
/// Every code point has a packed value `mapping << 3 | status`, where
/// `mapping` numbers the distinct mappings (0 is the empty mapping). The top
/// level maps `cp >> 8` to a mid block, the mid level maps the next four bits
/// to a leaf block, and the leaf level stores one 16-bit value per code
/// point. Identical blocks are shared at both levels.
pub fn generate_mapping_source(content : String) -> String raise {
  // Mapping `i` is `mapping_data[mapping_offsets[i]:mapping_offsets[i + 1]]`.
  let mapping_ids : Map[Array[Int32], Int32] = Map([([], 0)])
  let mapping_offsets : Array[Int32] = [0, 0]
  let mapping_data : Array[Int32] = []
  let values = Array::make(IdnaTrieLimit, IdnaDisallowed)
  // `start << IdnaStatusBits | status`, sorted by start code point.
  let high_ranges : Array[Int32] = []
  let mut high_next = IdnaTrieLimit
  for entry in parse_mapping_table(content) {
    let status = status_code(entry.status)
    let mapping = match mapping_ids.get(entry.mapping) {
      Some(id) => id
      None => {
        let id = mapping_ids.length()
        mapping_ids[entry.mapping] = id
        mapping_data.append(entry.mapping)
        mapping_offsets.push(mapping_data.length())
        id
      }
    }
    let value = (mapping << IdnaStatusBits) | status
    for code_point in entry.start..<=Int32::min(entry.end, IdnaTrieLimit - 1) {
      values[code_point] = value
    }
    if entry.end >= IdnaTrieLimit {
      guard mapping == 0 else {
        fail(
          "IDNA mapping at or above \{@emitter.hex_upper(IdnaTrieLimit)} needs trie coverage",
        )
      }
      let start = Int32::max(entry.start, IdnaTrieLimit)
      guard start >= high_next else {
        fail("IDNA ranges above the trie must be sorted and disjoint")
      }
      // Unlisted code points between two ranges are disallowed.
      if start > high_next {
        push_high_range(high_ranges, high_next, IdnaDisallowed)
      }
      push_high_range(high_ranges, start, status)
      high_next = entry.end + 1
    }
  }
  if high_next <= MaxCodePoint {
    push_high_range(high_ranges, high_next, IdnaDisallowed)
  }
  guard values.iter().all(value => value < 0x10000) else {
    fail("IDNA trie has too many distinct mappings for 16-bit values")
  }
  // Leaf level: blocks of packed values.
  let leaf = @trie.deduplicate_blocks(values, 1 << IdnaTrieLeafShift)
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = @trie.deduplicate_blocks(
    leaf.ids,
    1 << (IdnaTrieTopShift - IdnaTrieLeafShift),
  )
  guard mid.ids.iter().all(id => id < 0x100) else {
    fail("IDNA trie has too many mid blocks for one byte")
  }
  guard mid.blocks.iter().all(id => id < 0x10000) else {
    fail("IDNA trie has too many leaf blocks for two bytes")
  }
  let trie_limit = "0x\{@emitter.hex_upper(IdnaTrieLimit)}"
  let mid_mask = (1 << (IdnaTrieTopShift - IdnaTrieLeafShift)) - 1
  let leaf_mask = (1 << IdnaTrieLeafShift) - 1
  let status_mask = (1 << IdnaStatusBits) - 1
  let out = @emitter.Emitter::new()
  out.write(
    (
      #|///|
      #|/// IDNA Mapping Table (UTS #46)
      #|/// Generated from IdnaMappingTable.txt
      #|
      #|///|
      #|/// IDNA status values
      #|pub(all) enum IdnaStatus {
      #|  Valid             // 0: Valid character
      #|  Ignored           // 1: Character is removed
      #|  Mapped            // 2: Character is replaced by its mapping
      #|  Deviation         // 3: Treated as valid in nontransitional mode
      #|  Disallowed        // 4: Character is not allowed
      #|  DisallowedSTD3Valid  // 5: Valid only without UseSTD3ASCIIRules
      #|  DisallowedSTD3Mapped // 6: Mapped only without UseSTD3ASCIIRules
      #|} derive(Eq)
      #|
      #|///|
      #|pub extend IdnaStatus with Eq::{not_equal, equal}
      #|
      #|///|
      #|pub extend IdnaStatus with Show::{to_string, output}
      #|
      #|///|
      #|pub impl Show for IdnaStatus with fn output(self, logger) {
      #|  match self {
      #|    Valid => logger.write_string("Valid")
      #|    Ignored => logger.write_string("Ignored")
      #|    Mapped => logger.write_string("Mapped")
      #|    Deviation => logger.write_string("Deviation")
      #|    Disallowed => logger.write_string("Disallowed")
      #|    DisallowedSTD3Valid => logger.write_string("DisallowedSTD3Valid")
      #|    DisallowedSTD3Mapped => logger.write_string("DisallowedSTD3Mapped")
      #|  }
      #|}
      #|
    ),
  )
  out.write_byte_array(
    "IDNA trie top level: `cp >> \{IdnaTrieTopShift}` to mid block index",
    "idna_trie_top",
    mid.ids,
  )
  out.write_byte_array(
    "IDNA trie mid level: big-endian 16-bit leaf block indices",
    "idna_trie_mid",
    big_endian_16(mid.blocks),
  )
  out.write_byte_array(
    "IDNA trie leaf level: big-endian 16-bit `mapping << \{IdnaStatusBits} | status` in blocks of \{1 << IdnaTrieLeafShift}",
    "idna_trie_leaf",
    big_endian_16(leaf.blocks),
  )
  out.write_int_array(
    "IDNA ranges from \{trie_limit} packed as `start << \{IdnaStatusBits} | status`",
    "idna_high_ranges",
    high_ranges,
    hex=true,
  )
  out.write_int_array(
    "Mapping `i` is `idna_mapping_data[idna_mapping_offsets[i]:idna_mapping_offsets[i + 1]]`",
    "idna_mapping_offsets",
    mapping_offsets,
    hex=false,
  )
  out.write_int_array(
    "Mapping data (flattened code points)",
    "idna_mapping_data",
    mapping_data,
    hex=true,
  )
  out.write(
    (
      $|///|
      $|/// Mapping table entry of a character, packed as
      $|/// `mapping << \{IdnaStatusBits} | status`. Looking one up allocates nothing.
      $|struct IdnaEntry(Int)
      $|
      $|///|
      $|/// Look up the mapping table entry of a character.
      $|pub fn lookup_idna_entry(c : Char) -> IdnaEntry {
      $|  let cp = c.to_int()
      $|  if cp >= \{trie_limit} {
      $|    // Binary search for the last range starting at or before `cp`.
      $|    let key = (cp << \{IdnaStatusBits}) | \{status_mask}
      $|    let mut low = 0
      $|    let mut high = idna_high_ranges.length()
      $|    while high - low > 1 {
      $|      let mid = (low + high) / 2
      $|      if idna_high_ranges[mid] <= key {
      $|        low = mid
      $|      } else {
      $|        high = mid
      $|      }
      $|    }
      $|    return IdnaEntry(idna_high_ranges[low] & \{status_mask})
      $|  }
      $|  let mid = (idna_trie_top[cp >> \{IdnaTrieTopShift}].to_int() << \{IdnaTrieTopShift - IdnaTrieLeafShift}) |
      $|    ((cp >> \{IdnaTrieLeafShift}) & \{mid_mask})
      $|  let leaf = (idna_trie_mid[2 * mid].to_int() << 8) |
      $|    idna_trie_mid[2 * mid + 1].to_int()
      $|  let offset = 2 * ((leaf << \{IdnaTrieLeafShift}) | (cp & \{leaf_mask}))
      $|  IdnaEntry(
      $|    (idna_trie_leaf[offset].to_int() << 8) | idna_trie_leaf[offset + 1].to_int(),
      $|  )
      $|}
      $|
      $|///|
      $|pub fn IdnaEntry::status(self : IdnaEntry) -> IdnaStatus {
      $|  match self.0 & \{status_mask} {
      $|    0 => Valid
      $|    1 => Ignored
      $|    2 => Mapped
      $|    3 => Deviation
      $|    4 => Disallowed
      $|    5 => DisallowedSTD3Valid
      $|    6 => DisallowedSTD3Mapped
      $|    _ => Disallowed
      $|  }
      $|}
      $|
      $|///|
      $|/// Append the entry's mapping, which is empty unless the status is
      $|/// `Mapped`, `Deviation` or `DisallowedSTD3Mapped`.
      $|pub fn IdnaEntry::write_mapping(self : IdnaEntry, output : StringBuilder) -> Unit {
      $|  let index = self.0 >> \{IdnaStatusBits}
      $|  for code_point in idna_mapping_data.exact_view(
      $|    start=idna_mapping_offsets[index],
      $|    end=idna_mapping_offsets[index + 1],
      $|  ) {
      $|    output.write_char(code_point.unsafe_to_char())
      $|  }
      $|}
      $|
    ),
  )
  out.finish()
}

///|
/// Split each value into its high and low byte.
fn big_endian_16(values : Array[Int32]) -> Array[Int32] {
  let bytes = []
  for value in values {
    bytes.push(value >> 8)
    bytes.push(value & 0xFF)
  }
  bytes
}

///|
fn joining_code(joining_type : StringView) -> Int32? {
  match joining_type {
    "L" => Some(0)
    "R" => Some(1)
    "D" => Some(2)
    "C" => Some(3)
    "T" => Some(4)
    "U" => Some(5)
    _ => None
  }
}

///|
pub fn generate_joining_source(content : String) -> String raise {
  let entries = parse_joining_table(content)
  let filtered : Array[(Int32, Int32, Int32)] = []
  for entry in entries {
    if joining_code(entry.joining_type) is Some(code) {
      filtered.push((entry.start, entry.end, code))
    }
  }
  filtered.sort_by((left, right) => left.0 - right.0)
  let out = @emitter.Emitter::new()
  out.write(
    (
      #|///|
      #|/// Joining_Type lookup for IDNA ContextJ validation (RFC 5892)
      #|/// Generated from DerivedJoiningType.txt
      #|
      #|///|
      #|/// Joining type values
      #|pub(all) enum JoiningType {
      #|  LeftJoining
      #|  RightJoining
      #|  DualJoining
      #|  JoinCausing
      #|  Transparent
      #|  NonJoining
      #|} derive(Eq)
      #|
      #|///|
      #|pub extend JoiningType with Eq::{not_equal, equal}
      #|
      #|///|
      #|pub extend JoiningType with Show::{to_string, output}
      #|
      #|///|
      #|pub impl Show for JoiningType with fn output(self, logger) {
      #|  match self {
      #|    LeftJoining => logger.write_string("LeftJoining")
      #|    RightJoining => logger.write_string("RightJoining")
      #|    DualJoining => logger.write_string("DualJoining")
      #|    JoinCausing => logger.write_string("JoinCausing")
      #|    Transparent => logger.write_string("Transparent")
      #|    NonJoining => logger.write_string("NonJoining")
      #|  }
      #|}
      #|
    ),
  )
  out.write_int_array(
    "Range start code points",
    "joining_range_starts",
    filtered.map(entry => entry.0),
    hex=true,
  )
  out.write_int_array(
    "Range end code points (inclusive)",
    "joining_range_ends",
    filtered.map(entry => entry.1),
    hex=true,
  )
  out.write_int_array(
    "Joining type codes for each range",
    "joining_range_types",
    filtered.map(entry => entry.2),
    hex=false,
  )
  out.write(
    (
      #|///|
      #|fn find_joining_range(c : Char) -> Int {
      #|  let cp = c.to_int()
      #|  let mut left = 0
      #|  let mut right = joining_range_starts.length() - 1
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let start = joining_range_starts[mid]
      #|    let end = joining_range_ends[mid]
      #|    if cp < start {
      #|      right = mid - 1
      #|    } else if cp > end {
      #|      left = mid + 1
      #|    } else {
      #|      return mid
      #|    }
      #|  }
      #|  -1
      #|}
      #|
      #|///|
      #|fn joining_from_code(code : Int) -> JoiningType {
      #|  match code {
      #|    0 => LeftJoining
      #|    1 => RightJoining
      #|    2 => DualJoining
      #|    3 => JoinCausing
      #|    4 => Transparent
      #|    _ => NonJoining
      #|  }
      #|}
      #|
      #|///|
      #|pub fn lookup_joining_type(c : Char) -> JoiningType {
      #|  let idx = find_joining_range(c)
      #|  if idx < 0 {
      #|    return NonJoining
      #|  }
      #|  joining_from_code(joining_range_types[idx])
      #|}
      #|
    ),
  )
  out.finish()
}
