///|
/// Check whether a character has the Unicode Emoji_Presentation property.
///
/// Emoji_Presentation covers the characters displayed as emoji by default.
/// It is narrower than the Emoji property: U+2764 HEAVY BLACK HEART and the
/// ASCII digits are emoji only when followed by U+FE0F VARIATION SELECTOR-16.
/// See UTS #51: https://www.unicode.org/reports/tr51/
pub fn is_emoji_presentation(c : Char) -> Bool {
  @emoji.is_emoji_presentation(c)
}

///|
/// Check whether a character has the Unicode Emoji_Modifier property.
///
/// Emoji_Modifier covers the five skin tone modifiers U+1F3FB to U+1F3FF.
pub fn is_emoji_modifier(c : Char) -> Bool {
  @emoji.is_emoji_modifier(c)
}

///|
/// Check whether a character has the Unicode Emoji_Modifier_Base property.
///
/// Emoji_Modifier_Base covers the characters whose appearance a following
/// Emoji_Modifier changes, such as U+1F44D THUMBS UP SIGN.
pub fn is_emoji_modifier_base(c : Char) -> Bool {
  @emoji.is_emoji_modifier_base(c)
}
