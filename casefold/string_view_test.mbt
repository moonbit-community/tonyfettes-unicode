///|
test "folding and matching accept bounded string views" {
  let source = "😀!Straße!😀"
  let view = source[2:source.length() - 2][1:7]
  inspect(@casefold.case_fold(view), content="strasse")
  assert_true(@casefold.caseless_match(view, "?STRASSE!"[1:8]))
  let canonical = "!α\u{0345}\u{0301}?"[1:4]
  inspect(@casefold.canonical_case_fold(canonical), content="α\u{0301}ι")
  assert_true(@casefold.canonical_caseless_match(canonical, "!άι?"[1:3]))
  let identifier = "!Ａ\u{00AD}?"[1:3]
  inspect(@casefold.nfkc_casefold(identifier), content="a")
  assert_true(@casefold.identifier_caseless_match(identifier, "!a?"[1:2]))
  inspect(@casefold.case_fold("!𐐀?"[1:3]), content="𐐨")
  let empty = source[3:3]
  inspect(@casefold.case_fold(empty), content="")
  inspect(@casefold.canonical_case_fold(empty), content="")
  inspect(@casefold.nfkc_casefold(empty), content="")
  assert_true(@casefold.caseless_match(empty, empty))
  assert_true(@casefold.canonical_caseless_match(empty, empty))
  assert_true(@casefold.identifier_caseless_match(empty, empty))
}
