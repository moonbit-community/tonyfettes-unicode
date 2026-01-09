///|
test "general_category: ASCII letters" {
  // Uppercase letters
  inspect(general_category(0x41), content="Lu") // 'A'
  inspect(general_category(0x5A), content="Lu") // 'Z'
  // Lowercase letters
  inspect(general_category(0x61), content="Ll") // 'a'
  inspect(general_category(0x7A), content="Ll") // 'z'
}

///|
test "general_category: digits" {
  inspect(general_category(0x30), content="Nd") // '0'
  inspect(general_category(0x39), content="Nd") // '9'
}

///|
test "general_category: punctuation" {
  inspect(general_category(0x21), content="Po") // '!'
  inspect(general_category(0x28), content="Ps") // '('
  inspect(general_category(0x29), content="Pe") // ')'
  inspect(general_category(0x2D), content="Pd") // '-'
}

///|
test "general_category: symbols" {
  inspect(general_category(0x24), content="Sc") // '$'
  inspect(general_category(0x2B), content="Sm") // '+'
  inspect(general_category(0x3C), content="Sm") // '<'
}

///|
test "general_category: control characters" {
  inspect(general_category(0x00), content="Cc") // NUL
  inspect(general_category(0x09), content="Cc") // TAB
  inspect(general_category(0x0A), content="Cc") // LF
  inspect(general_category(0x0D), content="Cc") // CR
}

///|
test "general_category: space" {
  inspect(general_category(0x20), content="Zs") // SPACE
}

///|
test "general_category: CJK ideographs" {
  inspect(general_category(0x4E00), content="Lo") // First CJK Unified Ideograph
  inspect(general_category(0x9FFF), content="Lo") // Last CJK Unified Ideograph (approx)
}

///|
test "general_category: marks" {
  inspect(general_category(0x0300), content="Mn") // COMBINING GRAVE ACCENT
  inspect(general_category(0x0301), content="Mn") // COMBINING ACUTE ACCENT
  inspect(general_category(0x0903), content="Mc") // DEVANAGARI SIGN VISARGA
}

///|
test "general_category: surrogates" {
  inspect(general_category(0xD800), content="Cs") // High surrogate start
  inspect(general_category(0xDFFF), content="Cs") // Low surrogate end
}

///|
test "general_category: private use" {
  inspect(general_category(0xE000), content="Co") // Private Use Area start
}

///|
test "general_category: unassigned" {
  // Code points beyond Unicode range should be Cn
  inspect(general_category(0x110000), content="Cn")
  inspect(general_category(-1), content="Cn")
}

///|
test "GeneralCategory::is_letter" {
  assert_true(general_category(0x41).is_letter()) // 'A'
  assert_true(general_category(0x61).is_letter()) // 'a'
  assert_false(general_category(0x30).is_letter()) // '0'
  assert_false(general_category(0x20).is_letter()) // space
}

///|
test "GeneralCategory::is_mark" {
  assert_true(general_category(0x0300).is_mark()) // COMBINING GRAVE ACCENT
  assert_false(general_category(0x41).is_mark()) // 'A'
}

///|
test "GeneralCategory::is_number" {
  assert_true(general_category(0x30).is_number()) // '0'
  assert_true(general_category(0x39).is_number()) // '9'
  assert_false(general_category(0x41).is_number()) // 'A'
}

///|
test "to_simple_uppercase: basic" {
  inspect(to_simple_uppercase(0x61), content="65") // 'a' -> 'A'
  inspect(to_simple_uppercase(0x7A), content="90") // 'z' -> 'Z'
  inspect(to_simple_uppercase(0x41), content="65") // 'A' -> 'A' (unchanged)
  inspect(to_simple_uppercase(0x30), content="48") // '0' -> '0' (unchanged)
}

///|
test "to_simple_lowercase: basic" {
  inspect(to_simple_lowercase(0x41), content="97") // 'A' -> 'a'
  inspect(to_simple_lowercase(0x5A), content="122") // 'Z' -> 'z'
  inspect(to_simple_lowercase(0x61), content="97") // 'a' -> 'a' (unchanged)
  inspect(to_simple_lowercase(0x30), content="48") // '0' -> '0' (unchanged)
}

///|
test "to_simple_titlecase: basic" {
  // For most characters, titlecase == uppercase
  inspect(to_simple_titlecase(0x61), content="65") // 'a' -> 'A'
  inspect(to_simple_titlecase(0x41), content="65") // 'A' -> 'A' (unchanged)
}

///|
test "case mapping: Greek letters" {
  inspect(to_simple_uppercase(0x03B1), content="913") // alpha -> ALPHA
  inspect(to_simple_lowercase(0x0391), content="945") // ALPHA -> alpha
}

///|
test "case mapping: German sharp s" {
  // LATIN SMALL LETTER SHARP S has simple uppercase to itself
  // (full uppercase is "SS" but simple mapping is same)
  inspect(to_simple_uppercase(0x00DF), content="223") // sharp s -> sharp s
}

///|
test "case mapping: roundtrip for ASCII" {
  for cp = 0x41; cp <= 0x5A; cp = cp + 1 {
    // Uppercase letters
    let lower = to_simple_lowercase(cp)
    let back_to_upper = to_simple_uppercase(lower)
    assert_eq(back_to_upper, cp)
  }
  for cp = 0x61; cp <= 0x7A; cp = cp + 1 {
    // Lowercase letters
    let upper = to_simple_uppercase(cp)
    let back_to_lower = to_simple_lowercase(upper)
    assert_eq(back_to_lower, cp)
  }
}
