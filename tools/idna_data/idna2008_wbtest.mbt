///|
test "IDNA2008 properties preserve allowed categories and Script boundaries" {
  let values = parse_idna2008_properties(
    (
      #|0041; DISALLOWED
      #|0061..007A; PVALID
      #|00B7; CONTEXTO
      #|0378..0379; UNASSIGNED
      #|03B1; PVALID
      #|05D0; PVALID
      #|200C..200D; CONTEXTJ
      #|3042; PVALID
      #|30A2; PVALID
      #|30FB; CONTEXTO
      #|4E00..4E01; PVALID
      #|40000; PVALID
      #|
    ),
    (
      #|# @missing: 0000..10FFFF; Unknown
      #|03B1..03B2; Greek
      #|05D0; Hebrew
      #|3042; Hiragana
      #|30A2; Katakana
      #|30FB..30FC; Common
      #|4E00..4E01; Han
      #|
    ),
  )
  inspect(values[0x41], content="0")
  inspect(values[0x60], content="0")
  inspect(values[0x61], content="1")
  inspect(values[0x7A], content="1")
  inspect(values[0x7B], content="0")
  inspect(values[0xB7], content="1")
  inspect(values[0x378], content="0")
  inspect(values[0x3B1], content="3")
  inspect(values[0x3B2], content="2")
  inspect(values[0x5D0], content="5")
  inspect(values[0x200B], content="0")
  inspect(values[0x200C], content="1")
  inspect(values[0x200D], content="1")
  inspect(values[0x200E], content="0")
  inspect(values[0x3042], content="9")
  inspect(values[0x30A2], content="9")
  inspect(values[0x30FB], content="1")
  inspect(values[0x30FC], content="0")
  inspect(values[0x4E00], content="9")
  inspect(values[0x4E01], content="9")
  inspect(values[0x4E02], content="0")
  inspect(values[0x40000], content="1")
  inspect(values[0x40001], content="0")
  inspect(values[0x10FFFF], content="0")
}

///|
test "unknown IDNA2008 categories fail generation" {
  try emit_idna2008("0061; UNKNOWN_CATEGORY\n", "") catch {
    Failure::Failure(message) =>
      assert_true(
        message.contains("Unknown IDNA2008 category: UNKNOWN_CATEGORY"),
      )
    error => raise error
  } noraise {
    _ => fail("expected an unknown IDNA2008 category to fail generation")
  }
}
