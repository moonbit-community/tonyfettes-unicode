///|
fn word_ignored(property : Int32) -> Bool {
  property is (WbExtend | WbFormat | WbZWJ)
}

///|
fn word_letter(property : Int32) -> Bool {
  property is (WbALetter | WbHebrewLetter)
}

///|
fn word_newline(property : Int32) -> Bool {
  property is (WbCR | WbLF | WbNewline)
}

///|
fn word_segment_ends(text : StringView) -> Array[Int32] {
  let input = text_break_input(text, word_break_value)
  let properties = input.properties
  let length = properties.length()
  // Nearest non-ignored characters on each side of a position (WB4).
  // Preparing these once avoids rescanning arbitrarily long Extend runs.
  let before = Array::make(length + 1, -1)
  let after = Array::make(length + 1, length)
  for i in 0..<length {
    before[i + 1] = if word_ignored(properties[i]) { before[i] } else { i }
  }
  for i in length>..0 {
    after[i] = if word_ignored(properties[i]) { after[i + 1] } else { i }
  }
  let ends = []
  let mut regional_count = 0
  for i in 1..<length {
    let left = properties[i - 1]
    if !word_ignored(left) {
      regional_count = if left == WbRegionalIndicator {
        regional_count + 1
      } else {
        0
      }
    }
    if word_boundary(input, before, after, i, regional_count) {
      ends.push(input.ends[i - 1])
    }
  }
  if length > 0 {
    ends.push(text.length())
  }
  ends
}

///|
/// Apply WB3-WB999 in order at an interior code point boundary.
fn word_boundary(
  input : TextBreakInput,
  before : Array[Int32],
  after : Array[Int32],
  index : Int32,
  regional_count : Int32,
) -> Bool {
  let properties = input.properties
  let raw_left = properties[index - 1]
  let right = properties[index]
  // WB3, WB3a, WB3b: these precede the ignore rule.
  if raw_left == WbCR && right == WbLF {
    return false
  }
  if word_newline(raw_left) || word_newline(right) {
    return true
  }
  // WB3c and WB3d use adjacent characters, not WB4's reduced context.
  if raw_left == WbZWJ &&
    (grapheme_break_value(input.points[index]) & ExtendedPictographicBit) != 0 {
    return false
  }
  if raw_left == WbWSegSpace && right == WbWSegSpace {
    return false
  }
  // WB4: leading ignored characters form their own segment.
  if word_ignored(right) {
    return false
  }
  let left_index = before[index]
  if left_index < 0 {
    return true
  }
  let left = properties[left_index]
  let previous_index = before[left_index]
  let previous = if previous_index < 0 { 0 } else { properties[previous_index] }
  let following_index = after[index + 1]
  let following = if following_index == properties.length() {
    0
  } else {
    properties[following_index]
  }
  // WB5-WB7: letters and medial punctuation.
  if word_letter(left) && word_letter(right) {
    return false
  }
  if word_letter(left) &&
    right is (WbMidLetter | WbMidNumLet | WbSingleQuote) &&
    word_letter(following) {
    return false
  }
  if word_letter(previous) &&
    left is (WbMidLetter | WbMidNumLet | WbSingleQuote) &&
    word_letter(right) {
    return false
  }
  // WB7a-WB7c: Hebrew quotes.
  if left == WbHebrewLetter && right == WbSingleQuote {
    return false
  }
  if left == WbHebrewLetter &&
    right == WbDoubleQuote &&
    following == WbHebrewLetter {
    return false
  }
  if previous == WbHebrewLetter &&
    left == WbDoubleQuote &&
    right == WbHebrewLetter {
    return false
  }
  // WB8-WB12: numbers, adjoining letters, and numeric punctuation.
  if left == WbNumeric && right == WbNumeric {
    return false
  }
  if (word_letter(left) && right == WbNumeric) ||
    (left == WbNumeric && word_letter(right)) {
    return false
  }
  if previous == WbNumeric &&
    left is (WbMidNum | WbMidNumLet | WbSingleQuote) &&
    right == WbNumeric {
    return false
  }
  if left == WbNumeric &&
    right is (WbMidNum | WbMidNumLet | WbSingleQuote) &&
    following == WbNumeric {
    return false
  }
  // WB13-WB13b: Katakana and connector punctuation.
  if left == WbKatakana && right == WbKatakana {
    return false
  }
  if left
    is (WbALetter | WbHebrewLetter | WbNumeric | WbKatakana | WbExtendNumLet) &&
    right == WbExtendNumLet {
    return false
  }
  if left == WbExtendNumLet &&
    right is (WbALetter | WbHebrewLetter | WbNumeric | WbKatakana) {
    return false
  }
  // WB15-WB16: pair regional indicators, ignoring WB4 characters.
  if left == WbRegionalIndicator &&
    right == WbRegionalIndicator &&
    regional_count % 2 == 1 {
    return false
  }
  true // WB999
}
