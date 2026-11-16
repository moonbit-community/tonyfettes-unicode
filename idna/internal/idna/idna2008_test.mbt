///|
test "IDNA2008 accepts PVALID and contextual characters" {
  for
    c in [
      '-', '0', 'a', 'é', 'ß', 'ς', '\u{00B7}', '\u{0375}', '\u{05F3}', '\u{05F4}',
      '\u{0660}', '\u{06F9}', '\u{200C}', '\u{200D}', '\u{30FB}', '\u{20000}', '\u{31350}',
    ] {
    guard @idna.is_idna2008_allowed(c) else {
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
    guard !@idna.is_idna2008_allowed(c) else {
      fail("Unexpected allowed IDNA2008 character: \{c.to_int()}")
    }
  }
}

///|
test "CONTEXTO uses Script rather than blocks or Script_Extensions" {
  inspect(@idna.is_greek('α'), content="true")
  inspect(@idna.is_greek('\u{1D200}'), content="true")
  // A Coptic character in the Greek and Coptic block is not Greek.
  inspect(@idna.is_greek('\u{03E2}'), content="false")
  inspect(@idna.is_hebrew('א'), content="true")
  inspect(@idna.is_hebrew('\u{05F3}'), content="true")
  inspect(@idna.is_hebrew('α'), content="false")
  inspect(@idna.is_japanese('あ'), content="true")
  inspect(@idna.is_japanese('カ'), content="true")
  inspect(@idna.is_japanese('漢'), content="true")
  inspect(@idna.is_japanese('\u{31350}'), content="true")
  // Both have Japanese Script_Extensions but Script=Common.
  inspect(@idna.is_japanese('\u{30FB}'), content="false")
  inspect(@idna.is_japanese('\u{30FC}'), content="false")
  inspect(@idna.is_japanese('\u{40000}'), content="false")
}
