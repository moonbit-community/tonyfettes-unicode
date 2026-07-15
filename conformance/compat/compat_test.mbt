///|
test "legacy UCD package surface" {
  let category : @unicode.GeneralCategory = @unicode.Lu
  inspect(category, content="Lu")
  inspect(category.group(), content="L")
  inspect(@unicode.general_category('A'), content="Lu")
}

///|
test "legacy normalization package surface" {
  let form : @legacy_normalization.NormalizationForm = @legacy_normalization.NFC
  inspect(@legacy_normalization.normalize("e\u{0301}", form), content="é")
}

///|
test "legacy Punycode package surface" {
  let error : @legacy_punycode.PunycodeError = @legacy_punycode.BadInput
  inspect(error, content="BadInput")
  inspect(@legacy_punycode.encode("bücher"), content="bcher-kva")
}

///|
test "legacy Bidi package surface" {
  let direction : @legacy_bidi.Direction = @legacy_bidi.LTR
  let _ : @legacy_bidi.BidiClass = @legacy_bidi.bidi_class('A')
  inspect(direction.level(), content="0")
  let paragraph = @legacy_bidi.process("abc", direction~)
  inspect(paragraph.base_level, content="0")
  inspect(@legacy_bidi.reorder_string(paragraph), content="abc")
}

///|
test "legacy IDNA package surface" {
  let error : @legacy_idna.IdnaError = @legacy_idna.EmptyLabel
  inspect(error, content="EmptyLabel")
  inspect(@legacy_idna.to_ascii("example.com"), content="example.com")
}
