///|
const MaxCodePoint : Int32 = 0x10FFFF

///|
/// Number of low bits holding the Bidi_Class code in a packed range.
const BidiValueBits : Int32 = 5

///|
/// The trie covers planes 0-3; the higher planes are almost entirely L or BN
/// and are looked up as packed ranges instead.
const BidiTrieLimit : Int32 = 0x40000

///|
/// Each top-level trie entry covers `1 << BidiTrieTopShift` code points.
const BidiTrieTopShift : Int32 = 8

///|
/// Each leaf block holds `1 << BidiTrieLeafShift` Bidi_Class codes.
const BidiTrieLeafShift : Int32 = 4

///|
priv struct BidiRange {
  start : Int32
  end : Int32
  bidi_class : String
}

///|
priv struct MirrorEntry {
  code_point : Int32
  mirrored : Int32
}

///|
priv struct BracketEntry {
  code_point : Int32
  paired : Int32
  bracket_type : String
}

///|
fn normalize_bidi_class(name : StringView) -> String {
  match name {
    "Left_To_Right" => "L"
    "Right_To_Left" => "R"
    "Arabic_Letter" => "AL"
    "European_Terminator" => "ET"
    _ => name.to_owned()
  }
}

///|
fn fill_class_range(
  classes : FixedArray[String],
  range : @parsing.CodePointRange,
  bidi_class : String,
) -> Unit {
  for code_point in range.start..<=range.end {
    classes[code_point] = bidi_class
  }
}

///|
fn parse_bidi_ranges(content : String) -> Array[BidiRange] raise {
  let classes = FixedArray::make(MaxCodePoint + 1, "L")
  let explicit : Array[BidiRange] = []
  for raw_line in content.split("\n") {
    let stripped = raw_line.trim()
    if stripped.strip_prefix("# @missing:") is Some(declaration) {
      let fields = declaration.trim().split(";").collect()
      if fields.length() >= 2 {
        let range = @parsing.parse_code_point_range(fields[0])
        fill_class_range(classes, range, normalize_bidi_class(fields[1].trim()))
      }
      continue
    }
    let line = @parsing.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() < 2 {
      continue
    }
    let range = @parsing.parse_code_point_range(fields[0])
    explicit.push({
      start: range.start,
      end: range.end,
      bidi_class: fields[1].trim().to_owned(),
    })
  }
  for entry in explicit {
    fill_class_range(
      classes,
      { start: entry.start, end: entry.end, },
      entry.bidi_class,
    )
  }
  let result : Array[BidiRange] = []
  let mut start = 0
  let mut previous = classes[0]
  for code_point in 1..<=MaxCodePoint {
    let current = classes[code_point]
    if current != previous {
      result.push({ start, end: code_point - 1, bidi_class: previous, })
      start = code_point
      previous = current
    }
  }
  result.push({ start, end: MaxCodePoint, bidi_class: previous, })
  result
}

///|
fn parse_mirroring(content : String) -> Array[MirrorEntry] raise {
  let entries : Array[MirrorEntry] = []
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() >= 2 {
      entries.push({
        code_point: @parsing.parse_hex_int(fields[0]),
        mirrored: @parsing.parse_hex_int(fields[1]),
      })
    }
  }
  entries.sort_by((left, right) => left.code_point - right.code_point)
  entries
}

///|
fn parse_brackets(content : String) -> Array[BracketEntry] raise {
  let entries : Array[BracketEntry] = []
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() >= 3 {
      entries.push({
        code_point: @parsing.parse_hex_int(fields[0]),
        paired: @parsing.parse_hex_int(fields[1]),
        bracket_type: fields[2].trim().to_owned().to_lower(),
      })
    }
  }
  entries.sort_by((left, right) => left.code_point - right.code_point)
  entries
}

///|
fn bidi_class_code(name : StringView) -> Int32? {
  match name {
    "L" => Some(0)
    "R" => Some(1)
    "AL" => Some(2)
    "EN" => Some(3)
    "ES" => Some(4)
    "ET" => Some(5)
    "AN" => Some(6)
    "CS" => Some(7)
    "NSM" => Some(8)
    "BN" => Some(9)
    "B" => Some(10)
    "S" => Some(11)
    "WS" => Some(12)
    "ON" => Some(13)
    "LRE" => Some(14)
    "LRO" => Some(15)
    "RLE" => Some(16)
    "RLO" => Some(17)
    "PDF" => Some(18)
    "LRI" => Some(19)
    "RLI" => Some(20)
    "FSI" => Some(21)
    "PDI" => Some(22)
    _ => None
  }
}

///|
/// Emit Bidi_Class data as a three-level trie for planes 0-3, with packed
/// ranges for the remaining planes.
///
/// The top level maps `cp >> 8` to a mid block, the mid level maps the next
/// four bits to a leaf block, and the leaf level stores one class code per
/// code point. Identical blocks are shared at both levels.
pub fn generate_bidi_class_source(content : String) -> String raise {
  let values = Array::make(BidiTrieLimit, 0)
  // `start << BidiValueBits | code`, so the packed values sort by start code
  // point. The parsed ranges cover every code point without gaps.
  let high_ranges : Array[Int32] = []
  for range in parse_bidi_ranges(content) {
    guard bidi_class_code(range.bidi_class) is Some(code) else {
      fail("Unknown Bidi_Class: \{range.bidi_class}")
    }
    for code_point in range.start..<=Int32::min(range.end, BidiTrieLimit - 1) {
      values[code_point] = code
    }
    if range.end >= BidiTrieLimit {
      let start = Int32::max(range.start, BidiTrieLimit)
      high_ranges.push((start << BidiValueBits) | code)
    }
  }
  // Leaf level: blocks of class codes.
  let leaf = @trie.deduplicate_blocks(values, 1 << BidiTrieLeafShift)
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = @trie.deduplicate_blocks(
    leaf.ids,
    1 << (BidiTrieTopShift - BidiTrieLeafShift),
  )
  guard mid.ids.iter().all(id => id < 0x100) else {
    fail("Bidi_Class trie has too many mid blocks for one byte")
  }
  guard mid.blocks.iter().all(id => id < 0x10000) else {
    fail("Bidi_Class trie has too many leaf blocks for two bytes")
  }
  let mid_bytes = []
  for id in mid.blocks {
    mid_bytes.push(id >> 8)
    mid_bytes.push(id & 0xFF)
  }
  let trie_limit = "0x\{@emitter.hex_upper(BidiTrieLimit)}"
  let mid_mask = (1 << (BidiTrieTopShift - BidiTrieLeafShift)) - 1
  let leaf_mask = (1 << BidiTrieLeafShift) - 1
  let value_mask = (1 << BidiValueBits) - 1
  let out = @emitter.Emitter::new()
  out.write(
    (
      #|///|
      #|/// Full Bidi_Class lookup for Unicode Bidirectional Algorithm (UAX #9)
      #|/// Generated from DerivedBidiClass.txt
      #|
      #|///|
      #|/// All 23 Bidi_Class values from UAX #9
      #|pub(all) enum BidiClass {
      #|  L
      #|  R
      #|  AL
      #|  EN
      #|  ES
      #|  ET
      #|  AN
      #|  CS
      #|  NSM
      #|  BN
      #|  B
      #|  S
      #|  WS
      #|  ON
      #|  LRE
      #|  LRO
      #|  RLE
      #|  RLO
      #|  PDF
      #|  LRI
      #|  RLI
      #|  FSI
      #|  PDI
      #|} derive(Eq)
      #|
      #|///|
      #|pub extend BidiClass with Eq::{not_equal, equal}
      #|
      #|///|
      #|pub extend BidiClass with Show::{to_string, output}
      #|
      #|///|
      #|pub impl Show for BidiClass with fn output(self, logger) {
      #|  match self {
      #|    L => logger.write_string("L")
      #|    R => logger.write_string("R")
      #|    AL => logger.write_string("AL")
      #|    EN => logger.write_string("EN")
      #|    ES => logger.write_string("ES")
      #|    ET => logger.write_string("ET")
      #|    AN => logger.write_string("AN")
      #|    CS => logger.write_string("CS")
      #|    NSM => logger.write_string("NSM")
      #|    BN => logger.write_string("BN")
      #|    B => logger.write_string("B")
      #|    S => logger.write_string("S")
      #|    WS => logger.write_string("WS")
      #|    ON => logger.write_string("ON")
      #|    LRE => logger.write_string("LRE")
      #|    LRO => logger.write_string("LRO")
      #|    RLE => logger.write_string("RLE")
      #|    RLO => logger.write_string("RLO")
      #|    PDF => logger.write_string("PDF")
      #|    LRI => logger.write_string("LRI")
      #|    RLI => logger.write_string("RLI")
      #|    FSI => logger.write_string("FSI")
      #|    PDI => logger.write_string("PDI")
      #|  }
      #|}
      #|
    ),
  )
  out.write_byte_array(
    "Bidi_Class trie top level: `cp >> \{BidiTrieTopShift}` to mid block index",
    "bidi_trie_top",
    mid.ids,
  )
  out.write_byte_array(
    "Bidi_Class trie mid level: big-endian 16-bit leaf block indices", "bidi_trie_mid",
    mid_bytes,
  )
  out.write_byte_array(
    "Bidi_Class trie leaf level: class codes in blocks of \{1 << BidiTrieLeafShift}",
    "bidi_trie_leaf",
    leaf.blocks,
  )
  out.write_int_array(
    "Bidi_Class ranges from \{trie_limit} packed as `start << \{BidiValueBits} | code`",
    "bidi_high_ranges",
    high_ranges,
    hex=true,
  )
  out.write(
    (
      $|///|
      $|/// Look up the Bidi_Class code (the `BidiClass` constructor index).
      $|fn lookup_bidi_class_code(c : Char) -> Int {
      $|  let cp = c.to_int()
      $|  if cp >= \{trie_limit} {
      $|    // Binary search for the last range starting at or before `cp`.
      $|    let key = (cp << \{BidiValueBits}) | \{value_mask}
      $|    let mut low = 0
      $|    let mut high = bidi_high_ranges.length()
      $|    while high - low > 1 {
      $|      let mid = (low + high) / 2
      $|      if bidi_high_ranges[mid] <= key {
      $|        low = mid
      $|      } else {
      $|        high = mid
      $|      }
      $|    }
      $|    return bidi_high_ranges[low] & \{value_mask}
      $|  }
      $|  let mid = (bidi_trie_top[cp >> \{BidiTrieTopShift}].to_int() << \{BidiTrieTopShift - BidiTrieLeafShift}) |
      $|    ((cp >> \{BidiTrieLeafShift}) & \{mid_mask})
      $|  let leaf = (bidi_trie_mid[2 * mid].to_int() << 8) |
      $|    bidi_trie_mid[2 * mid + 1].to_int()
      $|  bidi_trie_leaf[(leaf << \{BidiTrieLeafShift}) | (cp & \{leaf_mask})].to_int()
      $|}
      $|
    ),
  )
  out.write(bidi_class_implementation)
  out.finish()
}

///|
let bidi_class_implementation : String =
  #|///|
  #|fn bidi_from_code(code : Int) -> BidiClass {
  #|  match code {
  #|    0 => L
  #|    1 => R
  #|    2 => AL
  #|    3 => EN
  #|    4 => ES
  #|    5 => ET
  #|    6 => AN
  #|    7 => CS
  #|    8 => NSM
  #|    9 => BN
  #|    10 => B
  #|    11 => S
  #|    12 => WS
  #|    13 => ON
  #|    14 => LRE
  #|    15 => LRO
  #|    16 => RLE
  #|    17 => RLO
  #|    18 => PDF
  #|    19 => LRI
  #|    20 => RLI
  #|    21 => FSI
  #|    22 => PDI
  #|    _ => L
  #|  }
  #|}
  #|
  #|///|
  #|fn lookup_bidi_class(c : Char) -> BidiClass {
  #|  bidi_from_code(lookup_bidi_class_code(c))
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_strong(self : BidiClass) -> Bool {
  #|  self is (L | R | AL)
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_strong_rtl(self : BidiClass) -> Bool {
  #|  self is (R | AL)
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_weak(self : BidiClass) -> Bool {
  #|  self is (EN | ES | ET | AN | CS | NSM | BN)
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_neutral(self : BidiClass) -> Bool {
  #|  self is (B | S | WS | ON)
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_explicit(self : BidiClass) -> Bool {
  #|  self is (LRE | LRO | RLE | RLO | PDF | LRI | RLI | FSI | PDI)
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_isolate_initiator(self : BidiClass) -> Bool {
  #|  self is (LRI | RLI | FSI)
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_x9_removed(self : BidiClass) -> Bool {
  #|  self is (LRE | RLE | LRO | RLO | PDF | BN)
  #|}
  #|
  #|///|
  #|pub fn BidiClass::is_neutral_or_isolate(self : BidiClass) -> Bool {
  #|  self is (B | S | WS | ON | FSI | LRI | RLI | PDI)
  #|}
  #|

///|
pub fn generate_mirrored_source(content : String) -> String raise {
  let entries = parse_mirroring(content)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Bidi_Mirrored and Bidi_Mirroring_Glyph lookup for UAX #9", "BidiMirroring.txt",
  )
  out.write_int_array(
    "Code points with mirroring property",
    "mirrored_code_points",
    entries.map(entry => entry.code_point),
    hex=true,
  )
  out.write_int_array(
    "Corresponding mirrored glyphs",
    "mirrored_glyphs",
    entries.map(entry => entry.mirrored),
    hex=true,
  )
  out.write(
    (
      #|///|
      #|fn find_mirrored_index(c : Char) -> Int {
      #|  let cp = c.to_int()
      #|  let mut left = 0
      #|  let mut right = mirrored_code_points.length() - 1
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let mid_cp = mirrored_code_points[mid]
      #|    if cp < mid_cp {
      #|      right = mid - 1
      #|    } else if cp > mid_cp {
      #|      left = mid + 1
      #|    } else {
      #|      return mid
      #|    }
      #|  }
      #|  -1
      #|}
      #|
      #|///|
      #|pub fn is_bidi_mirrored(c : Char) -> Bool {
      #|  find_mirrored_index(c) >= 0
      #|}
      #|
      #|///|
      #|pub fn bidi_mirroring_glyph(c : Char) -> Char {
      #|  let idx = find_mirrored_index(c)
      #|  if idx < 0 { c } else { mirrored_glyphs[idx].unsafe_to_char() }
      #|}
      #|
    ),
  )
  out.finish()
}

///|
pub fn generate_bracket_source(content : String) -> String raise {
  let entries = parse_brackets(content)
  let out = @emitter.Emitter::new()
  out.write(
    (
      #|///|
      #|/// Bidi_Paired_Bracket lookup for UAX #9 N0 rule
      #|/// Generated from BidiBrackets.txt
      #|
      #|///|
      #|pub(all) enum BracketType {
      #|  Open
      #|  Close
      #|  None
      #|} derive(Eq)
      #|
      #|///|
      #|pub extend BracketType with Eq::{not_equal, equal}
      #|
      #|///|
      #|pub extend BracketType with Show::{to_string, output}
      #|
      #|///|
      #|pub impl Show for BracketType with fn output(self, logger) {
      #|  match self {
      #|    Open => logger.write_string("Open")
      #|    Close => logger.write_string("Close")
      #|    None => logger.write_string("None")
      #|  }
      #|}
      #|
    ),
  )
  out.write_int_array(
    "Code points of paired brackets",
    "bracket_code_points",
    entries.map(entry => entry.code_point),
    hex=true,
  )
  out.write_int_array(
    "Paired bracket for each code point",
    "paired_brackets",
    entries.map(entry => entry.paired),
    hex=true,
  )
  out.write_int_array(
    "Bracket types (0 = open, 1 = close)",
    "bracket_types",
    entries.map(entry => if entry.bracket_type == "o" { 0 } else { 1 }),
    hex=false,
  )
  out.write(
    (
      #|///|
      #|fn find_bracket_index(c : Char) -> Int {
      #|  let cp = c.to_int()
      #|  let mut left = 0
      #|  let mut right = bracket_code_points.length() - 1
      #|  while left <= right {
      #|    let mid = (left + right) / 2
      #|    let mid_cp = bracket_code_points[mid]
      #|    if cp < mid_cp {
      #|      right = mid - 1
      #|    } else if cp > mid_cp {
      #|      left = mid + 1
      #|    } else {
      #|      return mid
      #|    }
      #|  }
      #|  -1
      #|}
      #|
      #|///|
      #|pub fn bracket_type(c : Char) -> BracketType {
      #|  let idx = find_bracket_index(c)
      #|  if idx < 0 { None } else if bracket_types[idx] == 0 { Open } else { Close }
      #|}
      #|
      #|///|
      #|pub fn paired_bracket(c : Char) -> Char? {
      #|  let idx = find_bracket_index(c)
      #|  if idx < 0 { Option::None } else { Some(paired_brackets[idx].unsafe_to_char()) }
      #|}
      #|
      #|///|
      #|pub fn is_open_bracket(c : Char) -> Bool {
      #|  bracket_type(c) == Open
      #|}
      #|
      #|///|
      #|pub fn is_close_bracket(c : Char) -> Bool {
      #|  bracket_type(c) == Close
      #|}
      #|
      #|///|
      #|pub fn is_bracket_pair(open : Char, close : Char) -> Bool {
      #|  if paired_bracket(open) is Some(pair) {
      #|    pair == close && bracket_type(open) == Open
      #|  } else {
      #|    false
      #|  }
      #|}
      #|
    ),
  )
  out.finish()
}
