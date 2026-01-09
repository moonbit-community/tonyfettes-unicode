///|
/// Get the simple uppercase mapping for a code point
/// Returns the code point itself if no mapping exists
pub fn to_simple_uppercase(cp : Int) -> Int {
  @ucd_data.lookup_simple_uppercase(cp)
}

///|
/// Get the simple lowercase mapping for a code point
/// Returns the code point itself if no mapping exists
pub fn to_simple_lowercase(cp : Int) -> Int {
  @ucd_data.lookup_simple_lowercase(cp)
}

///|
/// Get the simple titlecase mapping for a code point
/// Returns the code point itself if no mapping exists
pub fn to_simple_titlecase(cp : Int) -> Int {
  @ucd_data.lookup_simple_titlecase(cp)
}
