///|
test "code points below SimpleLimit only take part in the control rules" {
  // The fast path in `next_grapheme_boundary` relies on this; it must be
  // revisited if a Unicode update changes the properties of these code
  // points.
  for code_point in 0..<SimpleLimit {
    let value = grapheme_break_value(code_point)
    guard (value & GcbMask) is (0 | GcbCR | GcbLF | GcbControl) &&
      ((value >> InCBShift) & InCBMask) == 0 else {
      fail("U+\{code_point.to_string(radix=16)} has packed value \{value}")
    }
  }
}
