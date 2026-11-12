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

///|
test "folding copies unchanged runs and keeps unpaired surrogates" {
  let text = "abc中文"
  inspect(@casefold.case_fold(text), content="abc中文")
  inspect(@casefold.case_fold("Hello, WORLD"), content="hello, world")
  inspect(@casefold.case_fold("x\u{00DF}y\u{0130}Z"), content="xssyi\u{0307}z")
  let lone = [0x41, 0xD800, 0x42, 0xDC00, 0x10428].map(Int32::unsafe_to_char)
  inspect(
    @casefold.case_fold(String::from_array(lone)) ==
    String::from_array(
      [0x61, 0xD800, 0x62, 0xDC00, 0x10428].map(Int32::unsafe_to_char),
    ),
    content="true",
  )
  inspect(@casefold.case_fold("ABCDEF"[2:5]), content="cde")
}

///|
test "matching compares the rest folded after a longer mapping" {
  inspect(@casefold.caseless_match("ΣΑΣ", "σας"), content="true")
  inspect(@casefold.caseless_match("\u{10400}x", "\u{10428}X"), content="true")
  inspect(@casefold.caseless_match("ss", "ß"), content="true")
  inspect(@casefold.caseless_match("ßa", "SSA"), content="true")
  inspect(@casefold.caseless_match("aßb", "ASSC"), content="false")
  inspect(@casefold.caseless_match("ﬃ", "FFI"), content="true")
  inspect(@casefold.caseless_match("abc", "ab"), content="false")
  inspect(@casefold.caseless_match("ab", "abc"), content="false")
  inspect(@casefold.caseless_match("abc", "abd"), content="false")
  inspect(@casefold.caseless_match("Straße"[0:5], "strass"), content="true")
}

///|
test "NFKC_Casefold maps compatibility forms and removes ignorables" {
  inspect(@casefold.nfkc_casefold("ＡＢＣ"), content="abc")
  inspect(@casefold.nfkc_casefold("a\u{00AD}B"), content="ab")
  inspect(@casefold.nfkc_casefold("already folded"), content="already folded")
}
