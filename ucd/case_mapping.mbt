///|
/// Get the simple uppercase mapping for a character
/// Returns the character itself if no mapping exists
pub fn to_simple_uppercase(c : Char) -> Char {
  @case_mapping.lookup_simple_uppercase(c)
}

///|
/// Get the simple lowercase mapping for a character
/// Returns the character itself if no mapping exists
pub fn to_simple_lowercase(c : Char) -> Char {
  @case_mapping.lookup_simple_lowercase(c)
}

///|
/// Get the simple titlecase mapping for a character
/// Returns the character itself if no mapping exists
pub fn to_simple_titlecase(c : Char) -> Char {
  @case_mapping.lookup_simple_titlecase(c)
}

///|
/// Get the full uppercase mapping for a character
/// Returns a String containing one or more uppercase characters
/// For example, 'ß' (U+00DF) maps to "SS", and 'ﬃ' (U+FB03) maps to "FFI"
pub fn to_uppercase(c : Char) -> String {
  @case_mapping.full_uppercase(c)
}

///|
/// Get the full lowercase mapping for a character
/// Returns a String containing one or more lowercase characters
/// For example, 'İ' (U+0130) maps to "i\u{0307}" (i with combining dot above)
pub fn to_lowercase(c : Char) -> String {
  @case_mapping.full_lowercase(c)
}

///|
/// Get the full titlecase mapping for a character
/// Returns a String containing one or more titlecase characters
/// For example, 'ß' (U+00DF) maps to "Ss", and 'ﬃ' (U+FB03) maps to "Ffi"
pub fn to_titlecase(c : Char) -> String {
  @case_mapping.full_titlecase(c)
}

///|
/// Get the full uppercase mapping of a string, with every character replaced
/// by its full uppercase mapping. For example, "Straße" maps to "STRASSE".
/// Unlike calling `to_uppercase` on each character, this builds one string
/// and allocates nothing per character.
///
/// The mapping is context-free: the conditional mappings of
/// SpecialCasing.txt, which depend on the surrounding text or the language,
/// are not applied. Unpaired surrogates are copied as they are.
pub fn uppercase(s : StringView) -> String {
  @case_mapping.uppercase(s)
}

///|
/// Get the full lowercase mapping of a string, with every character replaced
/// by its full lowercase mapping. For example, "İSTANBUL" maps to
/// "i\u{0307}stanbul". Unlike calling `to_lowercase` on each character, this
/// builds one string and allocates nothing per character.
///
/// The mapping is context-free: the conditional mappings of
/// SpecialCasing.txt, which depend on the surrounding text or the language,
/// are not applied, so Σ always maps to σ and never to the final form ς.
/// Unpaired surrogates are copied as they are.
pub fn lowercase(s : StringView) -> String {
  @case_mapping.lowercase(s)
}
