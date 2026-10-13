///|
/// Check whether a character has the Unicode White_Space property.
///
/// White_Space covers the ASCII controls TAB, LF, VT, FF, and CR, the
/// space separators (General_Category Zs), U+0085 NEXT LINE, and the line
/// and paragraph separators U+2028 and U+2029. It does not include
/// U+200B ZERO WIDTH SPACE or U+FEFF ZERO WIDTH NO-BREAK SPACE.
pub fn is_white_space(c : Char) -> Bool {
  @white_space.is_white_space(c)
}

///|
/// Check whether a character has the Unicode Alphabetic property.
///
/// Alphabetic covers the letters (General_Category L), letter numbers (Nl),
/// and Other_Alphabetic characters such as the vowel signs of Indic scripts.
/// Decimal digits are not Alphabetic.
pub fn is_alphabetic(c : Char) -> Bool {
  @alphabetic.is_alphabetic(c)
}

///|
/// Check whether a character has the Unicode Lowercase property.
///
/// Lowercase is broader than General_Category Ll: it also covers
/// Other_Lowercase characters such as U+00AA FEMININE ORDINAL INDICATOR,
/// modifier letters like U+02B0, and the small Roman numerals.
/// Titlecase letters (Lt) are neither Lowercase nor Uppercase.
pub fn is_lowercase(c : Char) -> Bool {
  @lowercase.is_lowercase(c)
}

///|
/// Check whether a character has the Unicode Uppercase property.
///
/// Uppercase is broader than General_Category Lu: it also covers
/// Other_Uppercase characters such as the capital Roman numerals and the
/// circled capital Latin letters. Titlecase letters (Lt) are neither
/// Lowercase nor Uppercase.
pub fn is_uppercase(c : Char) -> Bool {
  @uppercase.is_uppercase(c)
}

///|
/// Check whether a character has the Unicode Default_Ignorable_Code_Point
/// property.
///
/// Default_Ignorable_Code_Point covers characters that should not be
/// displayed when a font has no glyph for them, such as U+00AD SOFT HYPHEN,
/// the zero width joiners, the bidirectional controls, the variation
/// selectors, and the tag characters. It also covers some unassigned code
/// points reserved for future characters of this kind.
pub fn is_default_ignorable_code_point(c : Char) -> Bool {
  @default_ignorable_code_point.is_default_ignorable_code_point(c)
}

///|
/// Check whether a character has the Unicode Grapheme_Extend property.
///
/// Grapheme_Extend covers the nonspacing and enclosing marks
/// (General_Category Mn and Me) and Other_Grapheme_Extend characters such as
/// U+200C ZERO WIDTH NON-JOINER and a few spacing marks. U+200D ZERO WIDTH
/// JOINER is not Grapheme_Extend.
pub fn is_grapheme_extend(c : Char) -> Bool {
  @grapheme_extend.is_grapheme_extend(c)
}

///|
/// Check whether a character has the Unicode Regional_Indicator property.
///
/// Regional_Indicator covers the 26 regional indicator symbols U+1F1E6 to
/// U+1F1FF, which pair up to form emoji flags.
pub fn is_regional_indicator(c : Char) -> Bool {
  @regional_indicator.is_regional_indicator(c)
}

///|
/// Check whether a character has the Unicode Prepended_Concatenation_Mark
/// property.
///
/// Prepended_Concatenation_Mark covers format characters that enclose or
/// extend under the digits or letters following them, such as U+0600 ARABIC
/// NUMBER SIGN and U+06DD ARABIC END OF AYAH. Unlike most format characters
/// they are visible.
pub fn is_prepended_concatenation_mark(c : Char) -> Bool {
  @prepended_concatenation_mark.is_prepended_concatenation_mark(c)
}
