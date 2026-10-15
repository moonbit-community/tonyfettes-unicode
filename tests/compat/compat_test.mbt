///|
test "legacy UCD package surface" {
  let category : @unicode.GeneralCategory = @unicode.GeneralCategory::Lu
  inspect(category, content="Lu")
  inspect(category.group(), content="L")
  inspect(@unicode.general_category('A'), content="Lu")
  inspect(@unicode.is_xid_start('A'), content="true")
  inspect(@unicode.is_xid_continue('0'), content="true")
  inspect(@unicode.is_white_space(' '), content="true")
  inspect(@unicode.is_alphabetic('A'), content="true")
  inspect(@unicode.is_lowercase('a'), content="true")
  inspect(@unicode.is_uppercase('A'), content="true")
  let width : @unicode.EastAsianWidth = @unicode.east_asian_width('\u{4E2D}')
  inspect(width, content="W")
}

///|
test "legacy normalization package surface" {
  let form : @unicode/normalization.NormalizationForm = @unicode/normalization.NFC
  inspect(@unicode/normalization.normalize("e\u{0301}", form), content="é")
}

///|
test "case folding through compatibility packages" {
  inspect(@unicode/casefold.case_fold("Straße"), content="strasse")
  inspect(@unicode/casefold.caseless_match("Σ", "ς"), content="true")
  inspect(@unicode/casefold.canonical_case_fold("Å"), content="a\u{030A}")
  inspect(
    @unicode/casefold.canonical_caseless_match("Å", "a\u{030A}"),
    content="true",
  )
  inspect(@unicode/casefold.nfkc_casefold("Ａ\u{00AD}"), content="a")
  inspect(
    @unicode/casefold.identifier_caseless_match("Ａ", "a"),
    content="true",
  )
}

///|
test "legacy Punycode package surface" {
  let error : @unicode/punycode.PunycodeError = @unicode/punycode.BadInput
  inspect(error, content="BadInput")
  inspect(@unicode/punycode.encode("bücher"), content="bcher-kva")
}

///|
test "legacy Bidi package surface" {
  let direction : @unicode/bidi.Direction = @unicode/bidi.LTR
  let _ : @unicode/bidi.BidiClass = @unicode/bidi.bidi_class('A')
  inspect(direction.level(), content="0")
  let paragraph = @unicode/bidi.process("abc", direction~)
  inspect(paragraph.base_level, content="0")
  inspect(@unicode/bidi.reorder_string(paragraph), content="abc")
}

///|
test "legacy IDNA package surface" {
  let error : @unicode/idna.IdnaError = @unicode/idna.EmptyLabel
  inspect(error, content="EmptyLabel")
  inspect(@unicode/idna.to_ascii("example.com"), content="example.com")
}

///|
test "normalization and casefold facades accept string views" {
  let view = "!e\u{0301}?"[1:3]
  inspect(@unicode/normalization.nfc(view), content="é")
  inspect(@unicode/normalization.nfd(view), content="e\u{0301}")
  inspect(@unicode/normalization.nfkc(view), content="é")
  inspect(@unicode/normalization.nfkd(view), content="e\u{0301}")
  inspect(
    @unicode/normalization.normalize(view, @unicode/normalization.NFC),
    content="é",
  )
  assert_true(
    @unicode/normalization.is_normalized(view, @unicode/normalization.NFD),
  )
  inspect(@unicode/casefold.case_fold(view), content="e\u{0301}")
  inspect(@unicode/casefold.canonical_case_fold(view), content="e\u{0301}")
  inspect(@unicode/casefold.nfkc_casefold(view), content="é")
  assert_true(@unicode/casefold.caseless_match(view, "!E\u{0301}?"[1:3]))
  assert_true(@unicode/casefold.canonical_caseless_match(view, "!É?"[1:2]))
  assert_true(@unicode/casefold.identifier_caseless_match(view, "!É?"[1:2]))
}
