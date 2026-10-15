///|
test "canonical caseless matching normalizes before and after folding" {
  inspect(@casefold.canonical_caseless_match("Å", "a\u{030A}"), content="true")
  inspect(@casefold.canonical_case_fold("Å"), content="a\u{030A}")
  inspect(
    @casefold.canonical_caseless_match("Straße", "STRASSE"),
    content="true",
  )
  // Initial NFD moves iota subscript after the accent before it becomes a letter.
  inspect(
    @casefold.canonical_caseless_match("α\u{0345}\u{0301}", "άι"),
    content="true",
  )
  // Final NFD reorders the accent introduced by folding U+0390.
  inspect(
    @casefold.canonical_caseless_match(
      "\u{0390}\u{0323}", "ι\u{0323}\u{0308}\u{0301}",
    ),
    content="true",
  )
  inspect(@casefold.canonical_caseless_match("Ａ", "a"), content="false")
  inspect(@casefold.canonical_caseless_match("é", "e"), content="false")
  inspect(@casefold.canonical_caseless_match("a\u{00AD}", "a"), content="false")
  inspect(@casefold.canonical_case_fold(""), content="")
}

///|
test "NFKC_Casefold maps compatibility characters and removes ignorables" {
  inspect(
    @casefold.nfkc_casefold("ＡKﬃ Straße ㎒"),
    content="akffi strasse mhz",
  )
  inspect(
    @casefold.nfkc_casefold("A\u{00AD}\u{200D}\u{FE0F}\u{E0100}"),
    content="a",
  )
  inspect(@casefold.nfkc_casefold("\u{034F}\u{E0000}\u{E0FFF}"), content="")
  inspect(@casefold.nfkc_casefold("A\u{00AD}\u{030A}"), content="å")
  inspect(@casefold.nfkc_casefold("\u{1100}\u{1161}"), content="가")
  inspect(
    @casefold.nfkc_casefold("Iİıi Ꭰꭰ"),
    content="ii\u{0307}ıi ᎠᎠ",
  )
  inspect(@casefold.nfkc_casefold(""), content="")
  inspect(
    @casefold.nfkc_casefold("中文😀\u{10FFFF}"),
    content="中文😀\u{10FFFF}",
  )
}

///|
test "identifier matching includes initial canonical decomposition" {
  inspect(
    @casefold.identifier_caseless_match("Ａ\u{00AD}", "a"),
    content="true",
  )
  inspect(
    @casefold.identifier_caseless_match("α\u{0345}\u{0301}", "άι"),
    content="true",
  )
  inspect(@casefold.identifier_caseless_match("é", "e"), content="false")
  inspect(@casefold.identifier_caseless_match("\u{00AD}", ""), content="true")
}
