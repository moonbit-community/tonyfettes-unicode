///|
test "default full case folding expands and is locale independent" {
  inspect(@casefold.case_fold("Straße ẞ ﬃ"), content="strasse ss ffi")
  inspect(@casefold.case_fold("Σσς"), content="σσσ")
  inspect(@casefold.case_fold("Iİıi"), content="ii\u{0307}ıi")
  inspect(@casefold.case_fold("Ꭰꭰ"), content="ᎠᎠ")
  inspect(
    @casefold.case_fold("\u{10400}\u{10428}"),
    content="\u{10428}\u{10428}",
  )
  inspect(@casefold.case_fold(""), content="")
  inspect(
    @casefold.case_fold("中文😀\u{10FFFF}"),
    content="中文😀\u{10FFFF}",
  )
}

///|
test "default matching preserves normalization and ignorable differences" {
  inspect(@casefold.caseless_match("Straße", "STRASSE"), content="true")
  inspect(@casefold.caseless_match("Å", "A\u{030A}"), content="false")
  inspect(@casefold.caseless_match("a\u{00AD}", "a"), content="false")
  inspect(@casefold.caseless_match("I", "ı"), content="false")
  inspect(@casefold.caseless_match("İ", "i"), content="false")
  inspect(@casefold.caseless_match("", ""), content="true")
}
