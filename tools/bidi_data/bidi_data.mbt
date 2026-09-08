///|
const MaxCodePoint : Int = 0x10FFFF

///|
priv struct BidiRange {
  start : Int
  end : Int
  bidi_class : String
}

///|
priv struct MirrorEntry {
  code_point : Int
  mirrored : Int
}

///|
priv struct BracketEntry {
  code_point : Int
  paired : Int
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
  range : @support.CodePointRange,
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
        let range = @support.parse_code_point_range(fields[0])
        fill_class_range(classes, range, normalize_bidi_class(fields[1].trim()))
      }
      continue
    }
    let line = @support.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() < 2 {
      continue
    }
    let range = @support.parse_code_point_range(fields[0])
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
    let line = @support.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() >= 2 {
      entries.push({
        code_point: @support.parse_hex_int(fields[0]),
        mirrored: @support.parse_hex_int(fields[1]),
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
    let line = @support.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    if fields.length() >= 3 {
      entries.push({
        code_point: @support.parse_hex_int(fields[0]),
        paired: @support.parse_hex_int(fields[1]),
        bracket_type: fields[2].trim().to_owned().to_lower(),
      })
    }
  }
  entries.sort_by((left, right) => left.code_point - right.code_point)
  entries
}

///|
fn bidi_class_code(name : StringView) -> Int? {
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
pub fn generate_bidi_class_source(content : String) -> String raise {
  let ranges = parse_bidi_ranges(content)
  let filtered : Array[(Int, Int, Int)] = []
  for range in ranges {
    if bidi_class_code(range.bidi_class) is Some(code) {
      filtered.push((range.start, range.end, code))
    }
  }
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
  out.write_int_array(
    "Range start code points",
    "bidi_range_starts",
    filtered.map(entry => entry.0),
    hex=true,
  )
  out.write_int_array(
    "Range end code points (inclusive)",
    "bidi_range_ends",
    filtered.map(entry => entry.1),
    hex=true,
  )
  out.write_int_array(
    "Bidi class codes for each range",
    "bidi_range_classes",
    filtered.map(entry => entry.2),
    hex=false,
  )
  out.write(bidi_class_implementation)
  out.finish()
}

///|
let bidi_class_implementation : String =
  #|///|
  #|fn find_bidi_range(c : Char) -> Int {
  #|  let cp = c.to_int()
  #|  let mut left = 0
  #|  let mut right = bidi_range_starts.length() - 1
  #|  while left <= right {
  #|    let mid = (left + right) / 2
  #|    let start = bidi_range_starts[mid]
  #|    let end = bidi_range_ends[mid]
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
  #|  let idx = find_bidi_range(c)
  #|  if idx < 0 { L } else { bidi_from_code(bidi_range_classes[idx]) }
  #|}
  #|
  #|fn is_strong_rtl(c : Char) -> Bool {
  #|  lookup_bidi_class(c) is (R | AL)
  #|}
  #|
  #|///|
  #|fn is_explicit_formatting(c : Char) -> Bool {
  #|  lookup_bidi_class(c) is (LRE | LRO | RLE | RLO | PDF | LRI | RLI | FSI | PDI)
  #|}
  #|
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
