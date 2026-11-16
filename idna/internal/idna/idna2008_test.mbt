///|
test "IDNA2008 accepts PVALID and contextual characters" {
  for
    c in [
      '-', '0', 'a', 'é', 'ß', 'ς', '\u{00B7}', '\u{0375}', '\u{05F3}', '\u{05F4}',
      '\u{0660}', '\u{06F9}', '\u{200C}', '\u{200D}', '\u{30FB}', '\u{20000}', '\u{31350}',
    ] {
    guard @idna.lookup_idna_properties(c).is_idna2008_allowed() else {
      fail("Unexpected disallowed IDNA2008 character: \{c.to_int()}")
    }
  }
}

///|
test "IDNA2008 rejects mapped symbols unassigned and high plane characters" {
  for
    c in [
      'A', 'É', '♥', '😀', '\u{00AD}', '\u{0378}', '\u{FF41}', '\u{1D200}',
      '\u{3FFFF}', '\u{40000}', '\u{E0100}', '\u{10FFFF}',
    ] {
    guard !@idna.lookup_idna_properties(c).is_idna2008_allowed() else {
      fail("Unexpected allowed IDNA2008 character: \{c.to_int()}")
    }
  }
}

///|
test "CONTEXTO uses Script rather than blocks or Script_Extensions" {
  inspect(@idna.lookup_idna_properties('α').is_greek(), content="true")
  inspect(@idna.lookup_idna_properties('\u{1D200}').is_greek(), content="true")
  // A Coptic character in the Greek and Coptic block is not Greek.
  inspect(@idna.lookup_idna_properties('\u{03E2}').is_greek(), content="false")
  inspect(@idna.lookup_idna_properties('א').is_hebrew(), content="true")
  inspect(@idna.lookup_idna_properties('\u{05F3}').is_hebrew(), content="true")
  inspect(@idna.lookup_idna_properties('α').is_hebrew(), content="false")
  inspect(@idna.lookup_idna_properties('あ').is_japanese(), content="true")
  inspect(@idna.lookup_idna_properties('カ').is_japanese(), content="true")
  inspect(@idna.lookup_idna_properties('漢').is_japanese(), content="true")
  inspect(
    @idna.lookup_idna_properties('\u{31350}').is_japanese(),
    content="true",
  )
  // Both have Japanese Script_Extensions but Script=Common.
  inspect(
    @idna.lookup_idna_properties('\u{30FB}').is_japanese(),
    content="false",
  )
  inspect(
    @idna.lookup_idna_properties('\u{30FC}').is_japanese(),
    content="false",
  )
  inspect(
    @idna.lookup_idna_properties('\u{40000}').is_japanese(),
    content="false",
  )
}
