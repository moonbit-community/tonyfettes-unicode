///|
test "decomposition kinds stay distinct" {
  assert_eq(
    @decomposition.get_canonical_decomposition('\u{00C0}'),
    Some(['A', '\u{0300}']),
  )
  assert_eq(@decomposition.get_compat_decomposition('\u{00C0}'), None)
  // The first mapping is compatibility-only.
  assert_eq(@decomposition.get_compat_decomposition('\u{00A0}'), Some([' ']))
  assert_eq(@decomposition.get_canonical_decomposition('\u{00A0}'), None)
}

///|
test "decomposition lookup boundaries and missing mappings" {
  // The last mapping needs the final offset sentinel and has a non-BMP result.
  assert_eq(
    @decomposition.get_canonical_decomposition('\u{2FA1D}'),
    Some(['\u{2A600}']),
  )
  assert_eq(@decomposition.get_compat_decomposition('\u{2FA1D}'), None)
  for c in ['\u{0000}', 'A', '\u{00A1}', '\u{2FA1E}', '\u{10FFFF}'] {
    assert_eq(@decomposition.get_canonical_decomposition(c), None)
    assert_eq(@decomposition.get_compat_decomposition(c), None)
  }
}

///|
test "long compatibility decomposition" {
  assert_eq(
    @decomposition.get_compat_decomposition('\u{FDFA}'),
    Some([
      '\u{0635}', '\u{0644}', '\u{0649}', ' ', '\u{0627}', '\u{0644}', '\u{0644}',
      '\u{0647}', ' ', '\u{0639}', '\u{0644}', '\u{064A}', '\u{0647}', ' ', '\u{0648}',
      '\u{0633}', '\u{0644}', '\u{0645}',
    ]),
  )
  assert_eq(@decomposition.get_canonical_decomposition('\u{FDFA}'), None)
}
