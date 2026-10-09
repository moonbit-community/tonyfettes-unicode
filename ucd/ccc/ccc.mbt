///|
/// Canonical Combining Class (CCC) lookup
/// Generated from UnicodeData.txt

///|
pub using @normalization_data {lookup_normalization_properties}

///|
/// Look up Canonical Combining Class; 0 denotes a starter.
pub fn lookup_ccc(c : Char) -> Int {
  @normalization_data.lookup_normalization_properties(c) & 255
}
