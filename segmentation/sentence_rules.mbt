///|
fn sentence_paragraph(property : Int32) -> Bool {
  property is (SbSep | SbCR | SbLF)
}

///|
/// Return whether the first character at or after `pos` outside SB8's skipped
/// set is `SbLower`. Results are cached on `self` so repeated SB8 checks never
/// rescan the same positions, preserving O(n) total time.
fn Sentences::sb8_lower_ahead(
  self : Sentences,
  pos : Int32,
  length : Int32,
) -> Bool {
  if pos <= self.sb8_end {
    return self.sb8_lower
  }
  let text = self.text
  let mut cursor = pos
  while cursor < length {
    let cp = code_point_at(text, cursor, length)
    match sentence_break_value(cp) {
      SbLower => {
        self.sb8_end = cursor
        self.sb8_lower = true
        return true
      }
      SbOLetter | SbUpper | SbSep | SbCR | SbLF | SbATerm | SbSTerm => {
        self.sb8_end = cursor
        self.sb8_lower = false
        return false
      }
      _ => cursor += if cp >= 0x10000 { 2 } else { 1 }
    }
  }
  self.sb8_end = length
  self.sb8_lower = false
  false
}

///|
/// Find the end offset of the sentence starting at `start < length`.
fn Sentences::next_sentence_boundary(
  self : Sentences,
  start : Int32,
  length : Int32,
) -> Int32 {
  let text = self.text
  let first = text.unsafe_get(start).to_int()
  let mut cp0 = first
  let mut pos = start + 1
  if first >= 0xD800 && first <= 0xDBFF && pos < length {
    let second = text.unsafe_get(pos).to_int()
    if second >= 0xDC00 && second <= 0xDFFF {
      cp0 = 0x10000 + ((first - 0xD800) << 10) + second - 0xDC00
      pos += 1
    }
  }
  let mut left = sentence_break_value(cp0)
  let mut previous = 0
  let mut previous_previous = 0
  // Terminator at the start of a suffix matching SATerm Close* or
  // SATerm Close* Sp*, respectively. Zero means there is no such suffix.
  let mut close_term = 0
  let mut space_term = 0
  while pos < length {
    // Fast scan when no terminator is active and `left` is not one of the
    // five break-triggering classes (CR=1, LF=2, Sep=3, ATerm=4, STerm=5):
    // no rule SB3..SB11 can trigger a break after `left`.
    if space_term == 0 && (left - 1).reinterpret_as_uint() >= 5 {
      if left != SbExtend && left != SbFormat {
        previous_previous = previous
        previous = left
      }
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
      left = sentence_break_value(cp)
      pos = next_pos
      continue
    }
    if left != SbExtend && left != SbFormat {
      previous_previous = previous
      previous = left
      close_term = match left {
        SbATerm | SbSTerm => left
        SbClose => close_term
        _ => 0
      }
      if left != SbSp {
        space_term = close_term
      }
    }
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
    let right = sentence_break_value(cp)
    let boundary = if left == SbCR && right == SbLF {
      false // SB3
    } else if sentence_paragraph(left) {
      true // SB4
    } else if right == SbExtend || right == SbFormat {
      false // SB5
    } else if previous == SbATerm && right == SbNumeric {
      false // SB6
    } else if previous_previous is (SbUpper | SbLower) &&
      previous == SbATerm &&
      right == SbUpper {
      false // SB7
    } else if space_term == SbATerm && self.sb8_lower_ahead(pos, length) {
      false // SB8
    } else if space_term != 0 && right is (SbSContinue | SbATerm | SbSTerm) {
      false // SB8a
    } else if close_term != 0 &&
      (right is (SbClose | SbSp) || sentence_paragraph(right)) {
      false // SB9
    } else if space_term != 0 && (right == SbSp || sentence_paragraph(right)) {
      false // SB10
    } else {
      space_term != 0 // SB11, otherwise SB998
    }
    if boundary {
      return pos
    }
    left = right
    pos = next_pos
  }
  length
}
