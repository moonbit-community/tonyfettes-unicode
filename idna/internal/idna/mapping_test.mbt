///|
test "lookup_idna_mapping: ASCII" {
  assert_true(@idna.lookup_idna_mapping('a') == Valid)
  assert_true(@idna.lookup_idna_mapping('-') == Valid)
  assert_true(@idna.lookup_idna_mapping('A') == Mapped(['a']))
  assert_true(@idna.lookup_idna_mapping('Z') == Mapped(['z']))
}

///|
test "lookup_idna_mapping: every status" {
  assert_true(@idna.lookup_idna_mapping('\u{00E9}') == Valid)
  assert_true(@idna.lookup_idna_mapping('\u{00AD}') == Ignored)
  assert_true(@idna.lookup_idna_mapping('\u{00C9}') == Mapped(['\u{00E9}']))
  assert_true(@idna.lookup_idna_mapping('\u{00DF}') == Deviation(['s', 's']))
  assert_true(@idna.lookup_idna_mapping('\u{200C}') == Deviation([]))
  assert_true(@idna.lookup_idna_mapping('\u{0080}') == Disallowed)
}

///|
test "lookup_idna_mapping: shared and long mappings" {
  // U+017F maps to the same "s" as U+0053.
  assert_true(@idna.lookup_idna_mapping('S') == Mapped(['s']))
  assert_true(@idna.lookup_idna_mapping('\u{017F}') == Mapped(['s']))
  guard @idna.lookup_idna_mapping('\u{FDFA}') is Mapped(mapping) else {
    fail("U+FDFA should be mapped")
  }
  inspect(mapping.length(), content="18")
  assert_true(@idna.lookup_idna_mapping('\u{2F800}') == Mapped(['\u{4E3D}']))
}

///|
test "lookup_idna_mapping: supplementary planes" {
  assert_true(@idna.lookup_idna_mapping('\u{20000}') == Valid)
  // The last code points looked up in the trie, then the packed ranges.
  assert_true(@idna.lookup_idna_mapping('\u{3FFFF}') == Disallowed)
  assert_true(@idna.lookup_idna_mapping('\u{40000}') == Disallowed)
  assert_true(@idna.lookup_idna_mapping('\u{E00FF}') == Disallowed)
  assert_true(@idna.lookup_idna_mapping('\u{E0100}') == Ignored)
  assert_true(@idna.lookup_idna_mapping('\u{E01EF}') == Ignored)
  assert_true(@idna.lookup_idna_mapping('\u{E01F0}') == Disallowed)
  assert_true(@idna.lookup_idna_mapping('\u{10FFFF}') == Disallowed)
}
