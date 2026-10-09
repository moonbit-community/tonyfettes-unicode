///|
test "packed normalization properties keep all four Quick_Check values" {
  // Bits 8..11 hold NFC/NFKC (Yes=0, No=1, Maybe=2), then NFD/NFKD.
  inspect(@ccc.lookup_normalization_properties('A'), content="0")
  inspect(@ccc.lookup_normalization_properties('é'), content="12288")
  inspect(@ccc.lookup_normalization_properties('ﬃ'), content="9216")
  inspect(@ccc.lookup_normalization_properties('Å'), content="13568")
  inspect(@ccc.lookup_normalization_properties('\u{0301}'), content="2790")
  inspect(@ccc.lookup_normalization_properties('\u{0323}'), content="2780")
}

///|
test "CCC lookup masks out Quick_Check flags" {
  inspect(@ccc.lookup_ccc('é'), content="0")
  inspect(@ccc.lookup_ccc('\u{0301}'), content="230")
  inspect(@ccc.lookup_ccc('\u{0323}'), content="220")
  inspect(@ccc.lookup_ccc('\u{1D165}'), content="216")
}

///|
test "normalization trie covers supplementary characters and default tail" {
  inspect(@ccc.lookup_normalization_properties('\u{1D15E}'), content="13568")
  inspect(@ccc.lookup_normalization_properties('\u{2FA1D}'), content="13568")
  inspect(@ccc.lookup_normalization_properties('\u{2FA1E}'), content="0")
  inspect(@ccc.lookup_normalization_properties('\u{2FA7F}'), content="0")
  inspect(@ccc.lookup_normalization_properties('\u{2FA80}'), content="0")
  inspect(@ccc.lookup_normalization_properties('\u{10FFFF}'), content="0")
}

///|
test "Hangul Quick_Check is independent of decomposition table mappings" {
  // UnicodeData represents syllables as a range with no explicit mappings.
  for cp in 0xAC00..<=0xD7A3 {
    assert_true(
      @ccc.lookup_normalization_properties(cp.unsafe_to_char()) == 0x3000,
    )
  }
  // A vowel/trailing jamo may compose with preceding Hangul; a leading jamo cannot.
  inspect(@ccc.lookup_normalization_properties('\u{1100}'), content="0")
  inspect(@ccc.lookup_normalization_properties('\u{1161}'), content="2560")
  inspect(@ccc.lookup_normalization_properties('\u{11A8}'), content="2560")
}

///|
test "norm16 distinguishes direct properties from composition-only records" {
  for c in ['!', 'A', '\u{0301}', '\u{10FFFF}'] {
    assert_true(@decomposition.get_canonical_decomposition(c) == None)
    assert_true(@decomposition.get_compat_decomposition(c) == None)
  }
  assert_true(@composition.lookup_composition('A', '\u{030A}') == Some('Å'))
  assert_true(@composition.lookup_composition('!', '\u{030A}') == None)
}

///|
test "norm16 supports decomposition and composition on the same character" {
  assert_true(
    @decomposition.get_canonical_decomposition('Å') == Some(['A', '\u{030A}']),
  )
  assert_true(@decomposition.get_compat_decomposition('Å') == None)
  assert_true(@composition.lookup_composition('Å', '\u{0301}') == Some('Ǻ'))
  inspect(@ccc.lookup_normalization_properties('Å'), content="12288")
  assert_true(@decomposition.get_canonical_decomposition('ﬃ') == None)
  assert_true(
    @decomposition.get_compat_decomposition('ﬃ') == Some(['f', 'f', 'i']),
  )
}

///|
test "composition searches stay within each starter group" {
  // A's first and last candidates, and values outside its candidate range.
  assert_true(@composition.lookup_composition('A', '\u{0300}') == Some('À'))
  assert_true(@composition.lookup_composition('A', '\u{0328}') == Some('Ą'))
  assert_true(@composition.lookup_composition('A', '\u{0000}') == None)
  assert_true(@composition.lookup_composition('A', '\u{10FFFF}') == None)
  assert_true(@composition.lookup_composition('B', '\u{0300}') == None)
  // Devanagari QA is excluded even though its decomposition has two characters.
  assert_true(@composition.lookup_composition('\u{0915}', '\u{093C}') == None)
  assert_true(
    @composition.lookup_composition('\u{11099}', '\u{110BA}') ==
    Some('\u{1109A}'),
  )
}
