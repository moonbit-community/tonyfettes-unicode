///|
priv struct MappingEntry {
  start : Int
  end : Int
  status : String
  mapping : Array[Int]
}

///|
priv struct JoiningEntry {
  start : Int
  end : Int
  joining_type : String
}

///|
fn parse_mapping_table(content : String) -> Array[MappingEntry] raise {
  let entries : Array[MappingEntry] = []
  for raw_line in content.split("\n") {
    let line = @support.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() < 2 {
      continue
    }
    let range = @support.parse_code_point_range(fields[0])
    let status = fields[1]
      .trim()
      .to_owned()
      .to_lower()
      .replace_all(old=" ", new="_")
    let mapping = if fields.length() > 2 {
      @support.parse_code_point_sequence(fields[2])
    } else {
      []
    }
    entries.push({ start: range.start, end: range.end, status, mapping })
  }
  entries
}

///|
fn parse_joining_table(content : String) -> Array[JoiningEntry] raise {
  let entries : Array[JoiningEntry] = []
  for raw_line in content.split("\n") {
    let line = @support.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() < 2 {
      continue
    }
    let range = @support.parse_code_point_range(fields[0])
    entries.push({
      start: range.start,
      end: range.end,
      joining_type: fields[1].trim().to_owned(),
    })
  }
  entries
}

///|
fn status_code(status : StringView) -> Int {
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
pub fn generate_mapping_source(content : String) -> String raise {
  let entries = parse_mapping_table(content)
  let range_starts : Array[Int] = []
  let range_ends : Array[Int] = []
  let range_statuses : Array[Int] = []
  let mapping_starts : Array[Int] = []
  let mapping_lens : Array[Int] = []
  let mapping_data : Array[Int] = []
  for entry in entries {
    range_starts.push(entry.start)
    range_ends.push(entry.end)
    range_statuses.push(status_code(entry.status))
    mapping_starts.push(mapping_data.length())
    mapping_lens.push(entry.mapping.length())
    mapping_data.append(entry.mapping)
  }
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
      #|  Mapped            // 2: Character is mapped to other characters
      #|  Deviation         // 3: Treated as valid in nontransitional mode
      #|  Disallowed        // 4: Character is not allowed
      #|  DisallowedSTD3Valid  // 5: Valid only without UseSTD3ASCIIRules
      #|  DisallowedSTD3Mapped // 6: Mapped only without UseSTD3ASCIIRules
      #|} derive(Eq)
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
  out.write_int_array(
    "Range start code points",
    "idna_range_starts",
    range_starts,
    hex=true,
  )
  out.write_int_array(
    "Range end code points (inclusive)",
    "idna_range_ends",
    range_ends,
    hex=true,
  )
  out.write_int_array(
    "Status codes for each range",
    "idna_range_statuses",
    range_statuses,
    hex=false,
  )
  out.write_int_array(
    "Mapping data start indices",
    "idna_mapping_starts",
    mapping_starts,
    hex=false,
  )
  out.write_int_array(
    "Mapping data lengths",
    "idna_mapping_lens",
    mapping_lens,
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
      #|///|
      #|/// Binary search for character in IDNA ranges
      #|fn find_idna_range(c : Char) -> Int {
      #|  let cp = c.to_int()
      #|  let mut left = 0
      #|  let mut right = idna_range_starts.length() - 1
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let start = idna_range_starts[mid]
      #|    let end = idna_range_ends[mid]
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
      #|fn status_from_code(code : Int) -> IdnaStatus {
      #|  match code {
      #|    0 => Valid
      #|    1 => Ignored
      #|    2 => Mapped
      #|    3 => Deviation
      #|    4 => Disallowed
      #|    5 => DisallowedSTD3Valid
      #|    6 => DisallowedSTD3Mapped
      #|    _ => Disallowed
      #|  }
      #|}
      #|
      #|///|
      #|/// Look up IDNA status and mapping for a character
      #|pub fn lookup_idna_mapping(c : Char) -> (IdnaStatus, Array[Char]) {
      #|  let idx = find_idna_range(c)
      #|  if idx < 0 {
      #|    return (Disallowed, [])
      #|  }
      #|  let status = status_from_code(idna_range_statuses[idx])
      #|  let mapping_start = idna_mapping_starts[idx]
      #|  let mapping_len = idna_mapping_lens[idx]
      #|  let mapping : Array[Char] = []
    #|  for code_point in idna_mapping_data.view(
    #|    start=mapping_start,
    #|    end=mapping_start + mapping_len,
    #|  ) {
    #|    mapping.push(code_point.unsafe_to_char())
      #|  }
      #|  (status, mapping)
      #|}
      #|
    ),
  )
  out.finish()
}

///|
fn joining_code(joining_type : StringView) -> Int? {
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
  let filtered : Array[(Int, Int, Int)] = []
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
