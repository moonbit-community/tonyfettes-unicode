///|
test "lookup_simple: unmapped characters are returned as they are" {
  inspect(@case_mapping.lookup_simple_uppercase('1'), content="1")
  inspect(@case_mapping.lookup_simple_lowercase('a'), content="a")
  inspect(@case_mapping.lookup_simple_titlecase('\u{4E2D}'), content="中")
}

///|
test "lookup_simple: supplementary planes" {
  // Deseret and Adlam have case pairs in plane 1.
  inspect(
    @case_mapping.lookup_simple_uppercase('\u{10428}').to_int(),
    content="66560",
  )
  inspect(
    @case_mapping.lookup_simple_lowercase('\u{1E921}').to_int(),
    content="125251",
  )
  // The last code point in the trie, then code points beyond it.
  inspect(
    @case_mapping.lookup_simple_uppercase('\u{1FFFF}').to_int(),
    content="131071",
  )
  inspect(
    @case_mapping.lookup_simple_uppercase('\u{20000}').to_int(),
    content="131072",
  )
  inspect(
    @case_mapping.lookup_simple_lowercase('\u{10FFFF}').to_int(),
    content="1114111",
  )
}

///|
test "lookup_full: None without a mapping, the simple target otherwise" {
  debug_inspect(@case_mapping.lookup_full_uppercase('1'), content="None")
  debug_inspect(@case_mapping.lookup_full_uppercase('A'), content="None")
  debug_inspect(@case_mapping.lookup_full_uppercase('a'), content="Some(['A'])")
  debug_inspect(
    @case_mapping.lookup_full_lowercase('\u{00C9}'),
    content="Some(['é'])",
  )
  debug_inspect(
    @case_mapping.lookup_full_titlecase('\u{20000}'),
    content="None",
  )
}

///|
test "lookup_full: special mappings replace the simple one" {
  debug_inspect(
    @case_mapping.lookup_full_uppercase('\u{00DF}'),
    content="Some(['S', 'S'])",
  )
  debug_inspect(
    @case_mapping.lookup_full_titlecase('\u{00DF}'),
    content="Some(['S', 's'])",
  )
  // U+00DF is its own lowercase, so nothing is listed for it.
  debug_inspect(@case_mapping.lookup_full_lowercase('\u{00DF}'), content="None")
  guard @case_mapping.lookup_full_lowercase('\u{0130}')
    is Some(['i', '\u{0307}']) else {
    fail("U+0130 should lowercase to i followed by U+0307")
  }
  // U+1F80 has a simple uppercase (U+1F88) and a different full one.
  inspect(
    @case_mapping.lookup_simple_uppercase('\u{1F80}').to_int(),
    content="8072",
  )
  debug_inspect(
    @case_mapping.lookup_full_uppercase('\u{1F80}'),
    content="Some(['Ἀ', 'Ι'])",
  )
}

///|
test "full strings: the character itself, the simple target or the special mapping" {
  inspect(@case_mapping.full_uppercase('1'), content="1")
  inspect(@case_mapping.full_uppercase('a'), content="A")
  inspect(@case_mapping.full_lowercase('Z'), content="z")
  inspect(@case_mapping.full_titlecase('\u{00E9}'), content="É")
  inspect(@case_mapping.full_uppercase('\u{4E2D}'), content="中")
  inspect(@case_mapping.full_uppercase('\u{00DF}'), content="SS")
  inspect(@case_mapping.full_titlecase('\u{FB03}'), content="Ffi")
  inspect(@case_mapping.full_lowercase('\u{0130}'), content="i\u{0307}")
  inspect(
    @case_mapping.full_lowercase('\u{10400}') == "\u{10428}",
    content="true",
  )
  inspect(
    @case_mapping.full_uppercase('\u{10FFFF}') == "\u{10FFFF}",
    content="true",
  )
}

///|
test "uppercase and lowercase: whole strings" {
  inspect(@case_mapping.uppercase(""), content="")
  inspect(
    @case_mapping.uppercase("Hello, World 123"),
    content="HELLO, WORLD 123",
  )
  inspect(
    @case_mapping.lowercase("Hello, World 123"),
    content="hello, world 123",
  )
  inspect(
    @case_mapping.uppercase("Ünïcödé Çàfé"),
    content="ÜNÏCÖDÉ ÇÀFÉ",
  )
  inspect(
    @case_mapping.lowercase("ΟΔΥΣΣΕΥΣ"),
    content="οδυσσευσ",
  )
  inspect(
    @case_mapping.uppercase("世界こんにちは"),
    content="世界こんにちは",
  )
}

///|
test "uppercase and lowercase: expansions" {
  inspect(@case_mapping.uppercase("Straße"), content="STRASSE")
  inspect(@case_mapping.uppercase("\u{FB03}x"), content="FFIX")
  inspect(@case_mapping.uppercase("ŉ"), content="ʼN")
  // U+1F80 has a simple uppercase, U+1F88, and a different full one.
  inspect(@case_mapping.uppercase("\u{1F80}"), content="ἈΙ")
  inspect(@case_mapping.lowercase("İSTANBUL"), content="i\u{0307}stanbul")
  // Each mapping is the same as for the character alone.
  let text = "aßb\u{FB03}c\u{0130}dǅe\u{10428}f"
  let upper = StringBuilder()
  let lower = StringBuilder()
  for c in text {
    upper.write_string(@case_mapping.full_uppercase(c))
    lower.write_string(@case_mapping.full_lowercase(c))
  }
  @debug.assert_eq(@case_mapping.uppercase(text), upper.to_string())
  @debug.assert_eq(@case_mapping.lowercase(text), lower.to_string())
}

///|
test "uppercase and lowercase: context-free" {
  // A final capital sigma becomes σ, not ς.
  inspect(@case_mapping.lowercase("ΣΑΣ"), content="σασ")
  // Language-specific mappings are not applied.
  inspect(@case_mapping.uppercase("i"), content="I")
  inspect(@case_mapping.lowercase("I"), content="i")
}

///|
test "uppercase and lowercase: supplementary planes and surrogates" {
  @debug.assert_eq(@case_mapping.uppercase("a\u{10428}b"), "A\u{10400}B")
  @debug.assert_eq(
    @case_mapping.lowercase("\u{1E900}\u{1E901}"),
    "\u{1E922}\u{1E923}",
  )
  @debug.assert_eq(@case_mapping.uppercase("\u{20000}a"), "\u{20000}A")
  // Unpaired surrogates are copied as they are, mapped or not around them.
  let lone = String::from_array([
    'a',
    (0xD800).unsafe_to_char(),
    'b',
    (0xDC00).unsafe_to_char(),
    'ß',
    (0xD801).unsafe_to_char(),
  ])
  let mapped = @case_mapping.uppercase(lone)
  @debug.assert_eq(mapped.length(), 7)
  @debug.assert_eq(mapped.code_unit_at(1), (0xD800 : UInt16))
  @debug.assert_eq(mapped.code_unit_at(3), (0xDC00 : UInt16))
  @debug.assert_eq(mapped.code_unit_at(6), (0xD801 : UInt16))
  inspect(mapped[0:1], content="A")
  inspect(mapped[2:3], content="B")
  inspect(mapped[4:6], content="SS")
}

///|
test "uppercase and lowercase: views" {
  let text = "xx Straße Ünï yy"
  inspect(@case_mapping.uppercase(text[3:13]), content="STRASSE ÜNÏ")
  inspect(@case_mapping.lowercase(text[3:9]), content="straße")
  // Nothing to change in a view of part of a string.
  inspect(@case_mapping.uppercase(text[3:4].to_upper()), content="S")
  inspect(@case_mapping.lowercase(text[0:3]), content="xx ")
}

///|
test "uppercase and lowercase: every scalar maps as it does alone" {
  // Also checks that ASCII maps as `AsciiCase` says: only letters change.
  let all = StringBuilder()
  let all_upper = StringBuilder()
  let all_lower = StringBuilder()
  for cp in 0..<=0x10FFFF {
    if cp >= 0xD800 && cp <= 0xDFFF {
      continue
    }
    let c = cp.unsafe_to_char()
    let upper = @case_mapping.full_uppercase(c)
    let lower = @case_mapping.full_lowercase(c)
    let input = c.to_string()
    @debug.assert_eq(@case_mapping.uppercase(input), upper, msg="at \{cp}")
    @debug.assert_eq(@case_mapping.lowercase(input), lower, msg="at \{cp}")
    all.write_string(input)
    all_upper.write_string(upper)
    all_lower.write_string(lower)
  }
  let all = all.to_string()
  assert_true(@case_mapping.uppercase(all) == all_upper.to_string())
  assert_true(@case_mapping.lowercase(all) == all_lower.to_string())
}
