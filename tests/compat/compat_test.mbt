///|
test "legacy UCD package surface" {
  let category : @unicode.GeneralCategory = @unicode.Lu
  inspect(category, content="Lu")
  inspect(category.group(), content="L")
  inspect(@unicode.general_category('A'), content="Lu")
  inspect(@unicode.is_xid_start('A'), content="true")
  inspect(@unicode.is_xid_continue('0'), content="true")
}

///|
test "legacy normalization package surface" {
  let form : @unicode/normalization.NormalizationForm = @unicode/normalization.NFC
  inspect(@unicode/normalization.normalize("e\u{0301}", form), content="é")
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
