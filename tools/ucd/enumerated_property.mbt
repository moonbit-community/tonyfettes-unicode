///|
/// Write the trie of an enumerated property whose ordinals are
/// `values`, looked up by `lookup_<property in lowercase>`. The ordinals
/// number the constructors of the enum `enum_name`, which has `value_count`
/// of them.
fn write_enumerated_trie(
  out : @emitter.Emitter,
  property~ : String,
  prefix~ : String,
  enum_name~ : String,
  value_count~ : Int32,
  value_bits~ : Int32,
  values : FixedArray[Int32],
) -> Unit raise {
  out.write_value_trie(
    property~,
    prefix~,
    lookup="pub fn lookup_\{property.to_lower()}",
    lookup_doc=[
      "Look up \{property} ordinal for a character",
      "Returns ordinal value (0-\{value_count - 1}) corresponding to \{enum_name} enum",
    ],
    value_bits~,
    values,
  )
}

///|
/// Emit the trie of a small enumerated property from its UCD file `content`,
/// whose name is `source`. `aliases` lists the short and long name of every
/// value in the order of the enum `enum_name`; the file writes short names,
/// and its `@missing` lines may spell out long ones.
fn emit_small_enumerated_property(
  content : String,
  property~ : String,
  source~ : String,
  prefix~ : String,
  enum_name~ : String,
  default~ : String,
  aliases : Array[(String, String)],
) -> String raise {
  let values = @parsing.parse_enumerated_ordinals(
    content,
    property~,
    default~,
    name => aliases.search_by(entry => name == entry.0 || name == entry.1),
  )
  let out = @emitter.Emitter::new()
  out.write_file_header("\{property} lookup data", source)
  write_enumerated_trie(
    out,
    property~,
    prefix~,
    enum_name~,
    value_count=aliases.length(),
    value_bits=3,
    values,
  )
  out.finish()
}

///|
pub fn emit_east_asian_width(content : String) -> String raise {
  emit_small_enumerated_property(
    content,
    property="East_Asian_Width",
    source="EastAsianWidth.txt",
    prefix="eaw",
    enum_name="EastAsianWidth",
    default="N",
    [
      ("A", "Ambiguous"),
      ("F", "Fullwidth"),
      ("H", "Halfwidth"),
      ("N", "Neutral"),
      ("Na", "Narrow"),
      ("W", "Wide"),
    ],
  )
}

///|
pub fn emit_joining_type(content : String) -> String raise {
  emit_small_enumerated_property(
    content,
    property="Joining_Type",
    source="DerivedJoiningType.txt",
    prefix="joining_type",
    enum_name="JoiningType",
    default="U",
    [
      ("U", "Non_Joining"),
      ("C", "Join_Causing"),
      ("D", "Dual_Joining"),
      ("L", "Left_Joining"),
      ("R", "Right_Joining"),
      ("T", "Transparent"),
    ],
  )
}

///|
pub fn emit_hangul_syllable_type(content : String) -> String raise {
  emit_small_enumerated_property(
    content,
    property="Hangul_Syllable_Type",
    source="HangulSyllableType.txt",
    prefix="hangul_syllable_type",
    enum_name="HangulSyllableType",
    default="NA",
    [
      ("NA", "Not_Applicable"),
      ("L", "Leading_Jamo"),
      ("V", "Vowel_Jamo"),
      ("T", "Trailing_Jamo"),
      ("LV", "LV_Syllable"),
      ("LVT", "LVT_Syllable"),
    ],
  )
}
