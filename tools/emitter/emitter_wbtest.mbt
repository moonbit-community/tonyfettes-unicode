///|
test "Emitter writes source fragments and typed values" {
  let out = Emitter::new()
  out.write("let answer = ")
  out.write_int(42)
  out.write_char('\n')
  out.write_line("test \"generated\" {}")
  inspect(
    out.finish(),
    content=(
      #|let answer = 42
      #|test "generated" {}
      #|
    ),
  )
}

///|
test "value trie shares blocks and packs the higher planes" {
  let values = FixedArray::make(MaxCodePoint + 1, 0)
  values[0x41] = 1
  values[0xE0001] = 2
  let out = Emitter::new()
  out.write_value_trie(
    property="Test",
    prefix="test",
    lookup="fn lookup_test",
    lookup_doc=["Look up the test value", "of a character"],
    value_bits=3,
    values,
  )
  let source = out.finish()
  for
    expected in [
      // One leaf block holds `A`; every other block is the shared zero block.
      "let test_trie_leaf : Bytes = [\n" +
      "  0,\n".repeat(16) +
      "  0,\n  1,\n" +
      "  0,\n".repeat(14) +
      "]",
      // Planes 4 and up: 0 from U+40000, 2 at U+E0001, 0 again from U+E0002.
      "let test_high_ranges : ReadOnlyArray[Int] = [\n  0x200000,\n  0x70000A,\n  0x700010,\n]",
      "/// Look up the test value\n/// of a character\nfn lookup_test(c : Char) -> Int {",
      "let key = (cp << 3) | 7",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "value trie rejects values wider than value_bits" {
  let values = FixedArray::make(MaxCodePoint + 1, 0)
  values[0x41] = 8
  try
    Emitter::new().write_value_trie(
      property="Test",
      prefix="test",
      lookup="fn lookup_test",
      lookup_doc=[],
      value_bits=3,
      values,
    )
  catch {
    error =>
      inspect(
        error.to_string().contains("Test value does not fit in 3 bits"),
        content="true",
      )
  } noraise {
    _ => fail("expected an oversized value to be rejected")
  }
}
