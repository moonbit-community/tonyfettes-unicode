///|
/// Get the simple uppercase mapping for a character
/// Returns the character itself if no mapping exists
pub fn to_simple_uppercase(c : Char) -> Char {
  @ucd_data.lookup_simple_uppercase(c)
}

///|
/// Get the simple lowercase mapping for a character
/// Returns the character itself if no mapping exists
pub fn to_simple_lowercase(c : Char) -> Char {
  @ucd_data.lookup_simple_lowercase(c)
}

///|
/// Get the simple titlecase mapping for a character
/// Returns the character itself if no mapping exists
pub fn to_simple_titlecase(c : Char) -> Char {
  @ucd_data.lookup_simple_titlecase(c)
}
