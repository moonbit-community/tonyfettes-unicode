///|
/// Ordinal of a Hangul_Syllable_Type value in the `HangulSyllableType` enum.
/// `@missing` lines spell out the long alias.
fn hangul_syllable_type_ordinal(value : StringView) -> Int32? {
  match value {
    "NA" | "Not_Applicable" => Some(0)
    "L" | "Leading_Jamo" => Some(1)
    "V" | "Vowel_Jamo" => Some(2)
    "T" | "Trailing_Jamo" => Some(3)
    "LV" | "LV_Syllable" => Some(4)
    "LVT" | "LVT_Syllable" => Some(5)
    _ => None
  }
}

///|
/// Emit Hangul_Syllable_Type data from `HangulSyllableType.txt` as a
/// three-level trie for planes 0-3, with packed ranges for the remaining
/// planes.
pub fn emit_hangul_syllable_type(content : String) -> String raise {
  let values = property_ordinals(
    property="Hangul_Syllable_Type",
    @parsing.parse_enumerated_property(content, default="NA"),
    hangul_syllable_type_ordinal,
  )
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Hangul_Syllable_Type lookup data", "HangulSyllableType.txt",
  )
  out.write_value_trie(
    property="Hangul_Syllable_Type",
    prefix="hangul_syllable_type",
    lookup="pub fn lookup_hangul_syllable_type",
    lookup_doc=[
      "Look up Hangul_Syllable_Type ordinal for a character", "Returns ordinal value (0-5) corresponding to HangulSyllableType enum",
    ],
    value_bits=3,
    values,
  )
  out.finish()
}
