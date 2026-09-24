///|
/// Check whether a character has the Unicode White_Space property.
///
/// White_Space covers the ASCII controls TAB, LF, VT, FF, and CR, the
/// space separators (General_Category Zs), U+0085 NEXT LINE, and the line
/// and paragraph separators U+2028 and U+2029. It does not include
/// U+200B ZERO WIDTH SPACE or U+FEFF ZERO WIDTH NO-BREAK SPACE.
pub fn is_white_space(c : Char) -> Bool {
  @ucd_data.is_white_space(c)
}

///|
/// Check whether a character has the Unicode Alphabetic property.
///
/// Alphabetic covers the letters (General_Category L), letter numbers (Nl),
/// and Other_Alphabetic characters such as the vowel signs of Indic scripts.
/// Decimal digits are not Alphabetic.
pub fn is_alphabetic(c : Char) -> Bool {
  @ucd_data.is_alphabetic(c)
}

///|
/// Check whether a character has the Unicode Lowercase property.
///
/// Lowercase is broader than General_Category Ll: it also covers
/// Other_Lowercase characters such as U+00AA FEMININE ORDINAL INDICATOR,
/// modifier letters like U+02B0, and the small Roman numerals.
/// Titlecase letters (Lt) are neither Lowercase nor Uppercase.
pub fn is_lowercase(c : Char) -> Bool {
  @ucd_data.is_lowercase(c)
}

///|
/// Check whether a character has the Unicode Uppercase property.
///
/// Uppercase is broader than General_Category Lu: it also covers
/// Other_Uppercase characters such as the capital Roman numerals and the
/// circled capital Latin letters. Titlecase letters (Lt) are neither
/// Lowercase nor Uppercase.
pub fn is_uppercase(c : Char) -> Bool {
  @ucd_data.is_uppercase(c)
}
