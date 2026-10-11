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

///|
/// The full decomposition of one character.
fn decompose(c : Char, compatibility~ : Bool) -> Array[Char] {
  let dest : Array[Char] = []
  @decomposition.append_decomposition(c, dest, compatibility~)
  dest
}

///|
test "append_decomposition: characters without a mapping are appended as they are" {
  for c in ['\u{0000}', 'A', '\u{009F}', '\u{00A1}', '\u{4E2D}', '\u{10FFFF}'] {
    assert_eq(decompose(c, compatibility=false), [c])
    assert_eq(decompose(c, compatibility=true), [c])
  }
  // Hangul syllables are decomposed algorithmically, not from this table.
  assert_eq(decompose('\u{AC00}', compatibility=false), ['\u{AC00}'])
}

///|
test "append_decomposition: canonical and compatibility mappings" {
  assert_eq(decompose('\u{00C0}', compatibility=false), ['A', '\u{0300}'])
  // Without a compatibility mapping, the canonical one applies.
  assert_eq(decompose('\u{00C0}', compatibility=true), ['A', '\u{0300}'])
  // U+00A0 is the first character with a mapping; it is compatibility-only.
  assert_eq(decompose('\u{00A0}', compatibility=false), ['\u{00A0}'])
  assert_eq(decompose('\u{00A0}', compatibility=true), [' '])
  assert_eq(decompose('\u{FB03}', compatibility=true), ['f', 'f', 'i'])
  assert_eq(decompose('\u{2FA1D}', compatibility=false), ['\u{2A600}'])
}

///|
test "append_decomposition: mappings apply recursively" {
  // U+1EC7 maps to U+1EB9 U+0302, and U+1EB9 to U+0065 U+0323.
  assert_eq(decompose('\u{1EC7}', compatibility=false), [
    'e', '\u{0323}', '\u{0302}',
  ])
  // U+01C4 maps to U+0044 U+017D under compatibility, and U+017D
  // canonically to U+005A U+030C.
  assert_eq(decompose('\u{01C4}', compatibility=true), ['D', 'Z', '\u{030C}'])
  assert_eq(decompose('\u{01C4}', compatibility=false), ['\u{01C4}'])
}

///|
test "append_decomposition: appends after existing elements" {
  let dest = ['x']
  @decomposition.append_decomposition('\u{00E9}', dest, compatibility=false)
  @decomposition.append_decomposition('y', dest, compatibility=false)
  assert_eq(dest, ['x', 'e', '\u{0301}', 'y'])
}
