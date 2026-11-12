///|
test "Emitter writes source fragments and literals" {
  let out = Emitter::new()
  out.write("let answer = ")
  out.write_line(hex_literal(42, min_width=4))
  out.write_line("let text = \{string_literal([0x41, 0x1F600])}")
  inspect(
    out.finish(),
    content=(
      #|let answer = 0x002A
      #|let text = "\u{0041}\u{1F600}"
      #|
    ),
  )
  inspect(hex_upper(0), content="0")
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

///|
test "value trie stores wide values in two bytes and narrow high ranges" {
  let values = FixedArray::make(MaxCodePoint + 1, 0)
  values[0x41] = 0x123
  values[0xE0001] = 2
  let out = Emitter::new()
  out.write_value_trie(
    property="Test",
    prefix="test",
    lookup="fn lookup_test",
    lookup_doc=[],
    value_bits=12,
    range_value_bits=3,
    values,
  )
  let source = out.finish()
  for
    expected in [
      // `A` is the second value of its block, the high half of the first
      // pair: 0x123 << 16.
      "let test_trie_leaf : ReadOnlyArray[Int] = [\n  0,\n".repeat(1) +
      "  0,\n".repeat(7) +
      "  19070976,\n",
      "let test_high_ranges : ReadOnlyArray[Int] = [\n  0x200000,\n  0x70000A,\n  0x700010,\n]",
      // One leaf block index per entry: U+0040 starts leaf block 1.
      "let test_trie_mid : ReadOnlyArray[Int] = [\n" +
      "  0,\n".repeat(4) +
      "  1,\n",
      "  let leaf = test_trie_mid[mid]\n",
      "(test_trie_leaf[offset >> 1] >> ((offset & 1) << 4)) & 0xFFFF",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
  values[0xE0001] = 8
  try
    Emitter::new().write_value_trie(
      property="Test",
      prefix="test",
      lookup="fn lookup_test",
      lookup_doc=[],
      value_bits=12,
      range_value_bits=3,
      values,
    )
  catch {
    error =>
      inspect(
        error
        .to_string()
        .contains("Test value at 0xE0001 does not fit in 3 bits"),
        content="true",
      )
  } noraise {
    _ => fail("expected a wide value above the trie to be rejected")
  }
}

///|
test "enum converts ordinals with identity" {
  let values = [
    { name: "Open", comment: "opening", },
    { name: "Close", comment: "closing", },
    { name: "None", comment: "neither", },
  ]
  let out = Emitter::new()
  out.write_enum(
    type_name="Kind",
    doc=["Kinds"],
    converter="kind_from_ordinal",
    values~,
  )
  let source = out.finish()
  for
    expected in [
      "/// Kinds\n#derive(Debug, Eq)\npub(all) enum Kind {\n  Open // opening\n",
      "      Close => \"Close\"\n", "/// Convert a Kind ordinal, below 3, to the enum value.\n",
      "fn kind_from_ordinal(ordinal : Int) -> Kind = \"%identity\"\n",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
  try
    Emitter::new().write_enum(
      type_name="Kind",
      doc=[],
      converter="kind_from_ordinal",
      values=[],
    )
  catch {
    error =>
      inspect(
        error.to_string().contains("Kind has no constructors"),
        content="true",
      )
  } noraise {
    _ => fail("expected an enum without constructors to be rejected")
  }
}
