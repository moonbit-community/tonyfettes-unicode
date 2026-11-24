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
/// Return the Word_Break class of the first non-(Extend|Format|ZWJ) code point
/// at or after `pos`, or 0 (`Other`) when none exists.
fn wb_peek_next_non_ignored(
  text : StringView,
  pos : Int32,
  length : Int32,
) -> Int32 {
  let mut cursor = pos
  while cursor < length {
    let cp = code_point_at(text, cursor, length)
    let cls = word_break_value(cp) & WbClassMask
    if !word_ignored(cls) {
      return cls
    }
    cursor += if cp >= 0x10000 { 2 } else { 1 }
  }
  0
}

///|
/// Find the end offset of the word segment starting at `start < length`,
/// setting `self.word_like` from the packed `WbWordLikeBit` of its characters.
fn WordSegments::next_word_boundary(
  self : WordSegments,
  start : Int32,
  length : Int32,
) -> Int32 {
  let text = self.text
  // SAFETY: caller guarantees start < length.
  let first = text.unsafe_get(start).to_int()
  // Fast path: ASCII space run (no ASCII char is Extend/Format/ZWJ, so a
  // following ASCII char other than space always breaks immediately).
  if first == 0x20 {
    let mut pos = start + 1
    while pos < length && text.unsafe_get(pos) == ' ' {
      pos += 1
    }
    if pos == length || text.unsafe_get(pos) < 0x80 {
      self.word_like = false
      return pos
    }
  }
  // Fast path: ASCII alphanumeric word run. Adjacent ASCII letters and digits
  // never break (WB5, WB8, WB9, WB10) and are always word-like.
  let mut pos = start + 1
  let mut raw_left = 0
  let mut left = -1
  let mut previous = 0
  let mut flags = 0
  let mut regional_count = 0
  if ((first | 32) - 97).reinterpret_as_uint() < 26 {
    raw_left = WbALetter
    left = WbALetter
    flags = WbWordLikeBit
    while pos < length {
      let u = text.unsafe_get(pos).to_int()
      if ((u | 32) - 97).reinterpret_as_uint() < 26 {
        previous = left
        left = WbALetter
        raw_left = WbALetter
        pos += 1
      } else if (u - 48).reinterpret_as_uint() < 10 {
        previous = left
        left = WbNumeric
        raw_left = WbNumeric
        pos += 1
      } else if u == 0x20 || u == 0x0A {
        // Space (WSegSpace) and LF never join after ALetter/Numeric.
        self.word_like = true
        return pos
      } else {
        break
      }
    }
    if pos == length {
      self.word_like = true
      return length
    }
  } else if (first - 48).reinterpret_as_uint() < 10 {
    raw_left = WbNumeric
    left = WbNumeric
    flags = WbWordLikeBit
    while pos < length {
      let u = text.unsafe_get(pos).to_int()
      if (u - 48).reinterpret_as_uint() < 10 {
        previous = left
        left = WbNumeric
        raw_left = WbNumeric
        pos += 1
      } else if ((u | 32) - 97).reinterpret_as_uint() < 26 {
        previous = left
        left = WbALetter
        raw_left = WbALetter
        pos += 1
      } else if u == 0x20 || u == 0x0A {
        self.word_like = true
        return pos
      } else {
        break
      }
    }
    if pos == length {
      self.word_like = true
      return length
    }
  } else {
    let mut cp0 = first
    if first >= 0xD800 && first <= 0xDBFF && pos < length {
      let second = text.unsafe_get(pos).to_int()
      if second >= 0xDC00 && second <= 0xDFFF {
        cp0 = 0x10000 + ((first - 0xD800) << 10) + second - 0xDC00
        pos += 1
      }
    }
    let val0 = word_break_value(cp0)
    flags = val0
    raw_left = val0 & WbClassMask
    if !word_ignored(raw_left) {
      left = raw_left
      if raw_left == WbRegionalIndicator {
        regional_count = 1
      }
    }
  }
  while pos < length {
    // SAFETY: pos < length; trail surrogate is checked before reading.
    let unit = text.unsafe_get(pos).to_int()
    let mut cp = unit
    let mut next_pos = pos + 1
    if unit >= 0xD800 && unit <= 0xDBFF && next_pos < length {
      let second = text.unsafe_get(next_pos).to_int()
      if second >= 0xDC00 && second <= 0xDFFF {
        cp = 0x10000 + ((unit - 0xD800) << 10) + second - 0xDC00
        next_pos += 1
      }
    }
    let right_val = word_break_value(cp)
    let right = right_val & WbClassMask
    // Fast path for WB5 inside non-ASCII alphabetic runs (Russian, Latin, etc.).
    if raw_left == WbALetter && right == WbALetter {
      flags = flags | right_val
      previous = WbALetter
      pos = next_pos
      continue
    }
    // Fast path for WB999 when `right` is Other (0): only WB3c (ZWJ × EP) can
    // join before Other, so break immediately for CJK, Thai, and symbols.
    if right == 0 && raw_left != WbZWJ {
      self.word_like = (flags & WbWordLikeBit) != 0
      return pos
    }
    // WB3, WB3a, WB3b: newlines precede WB4.
    let joined = if raw_left == WbCR && right == WbLF {
      true
    } else if word_newline(raw_left) || word_newline(right) {
      false
    } else if raw_left == WbZWJ && (right_val & WbExtendedPictographicBit) != 0 {
      // WB3c
      true
    } else if raw_left == WbWSegSpace && right == WbWSegSpace {
      // WB3d
      true
    } else if word_ignored(right) {
      // WB4
      true
    } else if left < 0 {
      // Leading ignored characters form their own segment.
      false
    } else if word_letter(left) && word_letter(right) {
      // WB5
      true
    } else if word_letter(left) &&
      right is (WbMidLetter | WbMidNumLet | WbSingleQuote) &&
      word_letter(wb_peek_next_non_ignored(text, next_pos, length)) {
      // WB6
      true
    } else if word_letter(previous) &&
      left is (WbMidLetter | WbMidNumLet | WbSingleQuote) &&
      word_letter(right) {
      // WB7
      true
    } else if left == WbHebrewLetter && right == WbSingleQuote {
      // WB7a
      true
    } else if left == WbHebrewLetter &&
      right == WbDoubleQuote &&
      wb_peek_next_non_ignored(text, next_pos, length) == WbHebrewLetter {
      // WB7b
      true
    } else if previous == WbHebrewLetter &&
      left == WbDoubleQuote &&
      right == WbHebrewLetter {
      // WB7c
      true
    } else if left == WbNumeric && right == WbNumeric {
      // WB8
      true
    } else if (word_letter(left) && right == WbNumeric) ||
      (left == WbNumeric && word_letter(right)) {
      // WB9, WB10
      true
    } else if previous == WbNumeric &&
      left is (WbMidNum | WbMidNumLet | WbSingleQuote) &&
      right == WbNumeric {
      // WB11
      true
    } else if left == WbNumeric &&
      right is (WbMidNum | WbMidNumLet | WbSingleQuote) &&
      wb_peek_next_non_ignored(text, next_pos, length) == WbNumeric {
      // WB12
      true
    } else if left == WbKatakana && right == WbKatakana {
      // WB13
      true
    } else if left
      is (WbALetter | WbHebrewLetter | WbNumeric | WbKatakana | WbExtendNumLet) &&
      right == WbExtendNumLet {
      // WB13a
      true
    } else if left == WbExtendNumLet &&
      right is (WbALetter | WbHebrewLetter | WbNumeric | WbKatakana) {
      // WB13b
      true
    } else if left == WbRegionalIndicator &&
      right == WbRegionalIndicator &&
      regional_count % 2 == 1 {
      // WB15, WB16
      true
    } else {
      // WB999
      false
    }
    if !joined {
      self.word_like = (flags & WbWordLikeBit) != 0
      return pos
    }
    flags = flags | right_val
    raw_left = right
    if !word_ignored(right) {
      previous = if left < 0 { 0 } else { left }
      left = right
      regional_count = if right == WbRegionalIndicator {
        regional_count + 1
      } else {
        0
      }
    }
    pos = next_pos
  }
  self.word_like = (flags & WbWordLikeBit) != 0
  length
}
