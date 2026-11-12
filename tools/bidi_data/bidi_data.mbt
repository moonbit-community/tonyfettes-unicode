///|
priv struct MirrorEntry {
  code_point : Int32
  mirrored : Int32
}

///|
priv struct BracketEntry {
  code_point : Int32
  paired : Int32
  /// Index of the bracket type in `bracket_type_values`.
  bracket_type : Int32
}

///|
/// Bidi_Paired_Bracket_Type values in the order of the `BracketType` enum:
/// the constructor, the value BidiBrackets.txt writes, and a description.
let bracket_type_values : ReadOnlyArray[(String, String, String)] = [
  ("Open", "o", "Opening paired bracket"),
  ("Close", "c", "Closing paired bracket"),
  ("None", "n", "Not a paired bracket"),
]

///|
fn parse_mirroring(content : String) -> Array[MirrorEntry] raise {
  let entries : Array[MirrorEntry] = []
  for fields in @parsing.data_lines(content) {
    if fields is [code_point, mirrored, ..] {
      entries.push({
        code_point: @parsing.parse_hex_int(code_point),
        mirrored: @parsing.parse_hex_int(mirrored),
      })
    }
  }
  entries.sort_by((left, right) => left.code_point - right.code_point)
  entries
}

///|
fn parse_brackets(content : String) -> Array[BracketEntry] raise {
  let entries : Array[BracketEntry] = []
  for fields in @parsing.data_lines(content) {
    if fields is [code_point, paired, bracket_type, ..] {
      let name = bracket_type.to_owned().to_lower()
      guard bracket_type_values.search_by(entry => entry.1 == name)
        is Some(bracket_type) else {
        fail("Unknown Bidi_Paired_Bracket_Type \{name}")
      }
      entries.push({
        code_point: @parsing.parse_hex_int(code_point),
        paired: @parsing.parse_hex_int(paired),
        bracket_type,
      })
    }
  }
  entries.sort_by((left, right) => left.code_point - right.code_point)
  entries
}

///|
/// Bidi_Class values in the order of the `BidiClass` enum: the short alias,
/// which DerivedBidiClass.txt writes and which names the constructor, and the
/// long alias, which `@missing` lines spell out.
let bidi_classes : ReadOnlyArray[(String, String)] = [
  ("L", "Left_To_Right"),
  ("R", "Right_To_Left"),
  ("AL", "Arabic_Letter"),
  ("EN", "European_Number"),
  ("ES", "European_Separator"),
  ("ET", "European_Terminator"),
  ("AN", "Arabic_Number"),
  ("CS", "Common_Separator"),
  ("NSM", "Nonspacing_Mark"),
  ("BN", "Boundary_Neutral"),
  ("B", "Paragraph_Separator"),
  ("S", "Segment_Separator"),
  ("WS", "White_Space"),
  ("ON", "Other_Neutral"),
  ("LRE", "Left_To_Right_Embedding"),
  ("LRO", "Left_To_Right_Override"),
  ("RLE", "Right_To_Left_Embedding"),
  ("RLO", "Right_To_Left_Override"),
  ("PDF", "Pop_Directional_Format"),
  ("LRI", "Left_To_Right_Isolate"),
  ("RLI", "Right_To_Left_Isolate"),
  ("FSI", "First_Strong_Isolate"),
  ("PDI", "Pop_Directional_Isolate"),
]

///|
/// Emit the `BidiClass` enum and Bidi_Class data from `DerivedBidiClass.txt`
/// as a three-level trie for planes 0-3, with packed ranges for the remaining
/// planes.
pub fn emit_bidi_class(content : String) -> String raise {
  let values = @parsing.parse_enumerated_ordinals(
    content,
    property="Bidi_Class",
    default="L",
    name => bidi_classes.search_by(entry => name == entry.0 || name == entry.1),
  )
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Full Bidi_Class lookup for Unicode Bidirectional Algorithm (UAX #9)", "DerivedBidiClass.txt",
  )
  out.write_enum(
    type_name="BidiClass",
    doc=["All \{bidi_classes.length()} Bidi_Class values from UAX #9"],
    converter="bidi_from_code",
    values=bidi_classes
      .iter()
      .map(entry => @emitter.EnumValue::{ name: entry.0, comment: entry.1, })
      .collect(),
  )
  out.write_value_trie(
    property="Bidi_Class",
    prefix="bidi",
    lookup="fn lookup_bidi_class_code",
    lookup_doc=[
      "Look up the Bidi_Class code (the `BidiClass` constructor index).",
    ],
    value_bits=5,
    values,
  )
  out.write(bidi_class_implementation)
  out.finish()
}

///|
let bidi_class_implementation : String =
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
pub fn emit_mirrored(content : String) -> String raise {
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
      #|pub fn is_bidi_mirrored(c : Char) -> Bool {
      #|  find_mirrored_index(c.to_int()) >= 0
      #|}
      #|
      #|///|
      #|pub fn bidi_mirroring_glyph(c : Char) -> Char {
      #|  let idx = find_mirrored_index(c.to_int())
      #|  if idx < 0 { c } else { mirrored_glyphs[idx].unsafe_to_char() }
      #|}
      #|
    ),
  )
  out.write_sorted_search(
    name="find_mirrored_index",
    values="mirrored_code_points",
  )
  out.finish()
}

///|
pub fn emit_bracket(content : String) -> String raise {
  let entries = parse_brackets(content)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Bidi_Paired_Bracket lookup for UAX #9 N0 rule", "BidiBrackets.txt",
  )
  out.write_enum(
    type_name="BracketType",
    doc=["Bidi_Paired_Bracket_Type values"],
    converter="bracket_type_from_ordinal",
    values=bracket_type_values
      .iter()
      .map(entry => @emitter.EnumValue::{ name: entry.0, comment: entry.2, })
      .collect(),
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
    "`BracketType` ordinal of each code point",
    "bracket_types",
    entries.map(entry => entry.bracket_type),
    hex=false,
  )
  out.write(
    (
      #|///|
      #|pub fn bracket_type(c : Char) -> BracketType {
      #|  let idx = find_bracket_index(c.to_int())
      #|  if idx < 0 { None } else { bracket_type_from_ordinal(bracket_types[idx]) }
      #|}
      #|
      #|///|
      #|pub fn paired_bracket(c : Char) -> Char? {
      #|  let idx = find_bracket_index(c.to_int())
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
  out.write_sorted_search(
    name="find_bracket_index",
    values="bracket_code_points",
  )
  out.finish()
}
