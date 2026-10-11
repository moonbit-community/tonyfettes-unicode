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
