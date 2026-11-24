///|
/// Regional_Indicator lookup data
/// Generated from PropList.txt

///|
/// Check whether a character has the Unicode Regional_Indicator property
pub fn is_regional_indicator(c : Char) -> Bool {
  let cp = c.to_int()
  cp >= 0x1F1E6 && cp <= 0x1F1FF
}
