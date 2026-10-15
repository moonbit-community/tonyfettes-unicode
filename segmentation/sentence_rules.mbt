///|
fn sentence_paragraph(property : Int32) -> Bool {
  property is (SbSep | SbCR | SbLF)
}

///|
fn sentence_segment_ends(text : StringView) -> Array[Int32] {
  let input = text_break_input(text, sentence_break_value)
  let properties = input.properties
  let length = properties.length()
  // SB8 looks past any number of characters outside its exclusion set.
  // Cache whether the first character in that set is Lower, for O(n) work
  // even on long runs of punctuation and ignored characters.
  let lower_ahead = Array::make(length + 1, false)
  for i in length>..0 {
    lower_ahead[i] = match properties[i] {
      SbLower => true
      SbOLetter | SbUpper | SbSep | SbCR | SbLF | SbATerm | SbSTerm => false
      _ => lower_ahead[i + 1]
    }
  }
  let ends = []
  let mut previous = 0
  let mut previous_previous = 0
  // Terminator at the start of a suffix matching SATerm Close* or
  // SATerm Close* Sp*, respectively. Zero means there is no such suffix.
  let mut close_term = 0
  let mut space_term = 0
  for i in 1..<length {
    let left = properties[i - 1]
    let right = properties[i]
    if !(left is (SbExtend | SbFormat)) {
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
    let boundary = if left == SbCR && right == SbLF {
      false // SB3
    } else if sentence_paragraph(left) {
      true // SB4
    } else if right is (SbExtend | SbFormat) {
      false // SB5
    } else if previous == SbATerm && right == SbNumeric {
      false // SB6
    } else if previous_previous is (SbUpper | SbLower) &&
      previous == SbATerm &&
      right == SbUpper {
      false // SB7
    } else if space_term == SbATerm && lower_ahead[i] {
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
      ends.push(input.ends[i - 1])
    }
  }
  if length > 0 {
    ends.push(text.length())
  }
  ends
}
