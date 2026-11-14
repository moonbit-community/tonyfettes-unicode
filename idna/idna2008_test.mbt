///|
/// RFC 5892 derived-property and contextual-rule tests, run through the
/// `check_idna2008` opt-in of `to_ascii` / `to_unicode`.

///|
test "idna2008: default stays UTS #46 only" {
  // U+00A1 is `valid` in the UTS #46 mapping table and DISALLOWED in RFC 5892,
  // so the two contracts have to stay separable.
  inspect(@idna.to_ascii("\u{00A1}.com"), content="xn--7a.com")
  @test.assert_raise(() => @idna.to_ascii("\u{00A1}.com", check_idna2008=true))
}

///|
test "idna2008: PVALID labels are unaffected" {
  inspect(
    @idna.to_ascii("münchen.de", check_idna2008=true),
    content="xn--mnchen-3ya.de",
  )
  inspect(
    @idna.to_ascii("中文.com", check_idna2008=true),
    content="xn--fiq228c.com",
  )
  inspect(
    @idna.to_ascii("example.com", check_idna2008=true),
    content="example.com",
  )
}

///|
test "idna2008: 2.6 exception code points that are DISALLOWED" {
  // U+0640 ARABIC TATWEEL, U+302E HANGUL SINGLE DOT TONE MARK, U+303B VERTICAL
  // IDEOGRAPHIC ITERATION MARK: `valid` for UTS #46, DISALLOWED for RFC 5892.
  @test.assert_raise(() => @idna.to_ascii("\u{0640}.com", check_idna2008=true))
  @test.assert_raise(() => {
    @idna.to_ascii("실\u{302E}례.com", check_idna2008=true)
  })
  @test.assert_raise(() => @idna.to_ascii("\u{303B}.com", check_idna2008=true))
}

///|
test "idna2008: 2.4 ignorable blocks are DISALLOWED" {
  // U+20D0 COMBINING LEFT HARPOON ABOVE is LetterDigits by category but sits in
  // the Combining Diacritical Marks for Symbols block, which 2.4 excludes.
  @test.assert_raise(() => @idna.to_ascii("\u{20D0}.com", check_idna2008=true))
}

///|
test "idna2008: 2.9 old Hangul Jamo never reach the check" {
  // NFC composes the conjoining Jamo before the derived property is computed,
  // so the label is the PVALID precomposed syllable. The 2.9 rule only rejects
  // Jamo sequences that keep a conjoining Jamo after normalisation.
  inspect(
    @idna.to_ascii("\u{1100}\u{1161}.com", check_idna2008=true),
    content="xn--o39a.com",
  )
}

///|
test "idna2008: A.3 MIDDLE DOT needs surrounding 'l'" {
  inspect(
    @idna.to_ascii("l\u{00B7}l.com", check_idna2008=true),
    content="xn--ll-0ea.com",
  )
  let error = @test.expect_error(() => {
    @idna.to_ascii("a\u{00B7}l.com", check_idna2008=true)
  })
  guard error is @idna.InvalidContextO else { fail("Expected InvalidContextO") }
}

///|
test "idna2008: A.4 GREEK KERAIA must be followed by Greek" {
  inspect(
    @idna.to_ascii("\u{03B1}\u{0375}\u{03B2}.com", check_idna2008=true),
    content="xn--wva3je.com",
  )
  for domain in ["\u{03B1}\u{0375}S.com", "\u{03B1}\u{0375}.com"] {
    let error = @test.expect_error(() => {
      @idna.to_ascii(domain, check_idna2008=true)
    })
    guard error is @idna.InvalidContextO else {
      fail("Expected InvalidContextO")
    }
  }
}

///|
test "idna2008: A.5/A.6 GERESH and GERSHAYIM must follow Hebrew" {
  inspect(
    @idna.to_ascii("\u{05D0}\u{05F3}\u{05D1}.com", check_idna2008=true),
    content="xn--4dbc5h.com",
  )
  for domain in ["A\u{05F3}\u{05D1}.com", "\u{05F3}\u{05D1}.com"] {
    let error = @test.expect_error(() => {
      @idna.to_ascii(domain, check_idna2008=true)
    })
    guard error is @idna.InvalidContextO else {
      fail("Expected InvalidContextO")
    }
  }
}

///|
test "idna2008: A.7 KATAKANA MIDDLE DOT needs Kana or Han in the label" {
  for
    domain in [
      "\u{30FB}\u{3041}.com", "\u{30FB}\u{30A1}.com", "\u{30FB}\u{4E08}.com",
    ] {
    ignore(@idna.to_ascii(domain, check_idna2008=true))
  }
  for domain in ["\u{30FB}.com", "def\u{30FB}abc.com"] {
    let error = @test.expect_error(() => {
      @idna.to_ascii(domain, check_idna2008=true)
    })
    guard error is @idna.InvalidContextO else {
      fail("Expected InvalidContextO")
    }
  }
}

///|
test "idna2008: A.8/A.9 Arabic-Indic digit blocks must not be mixed" {
  inspect(
    @idna.to_ascii("\u{0628}\u{0660}.com", check_idna2008=true),
    content="xn--ngb6i.com",
  )
  // The rule is per label, so the two blocks may meet in different labels.
  inspect(
    @idna.to_ascii("\u{0628}\u{0660}.\u{0628}\u{06F0}.com", check_idna2008=true),
    content="xn--ngb6i.xn--ngb41b.com",
  )
  let error = @test.expect_error(() => {
    @idna.to_ascii("\u{0628}\u{0660}\u{06F0}.com", check_idna2008=true)
  })
  guard error is @idna.InvalidContextO else { fail("Expected InvalidContextO") }
}

///|
test "idna2008: A-labels are validated on their decoded form" {
  inspect(
    @idna.to_ascii("xn--ll-0ea.com", check_idna2008=true),
    content="xn--ll-0ea.com",
  )
  let error = @test.expect_error(() => {
    @idna.to_ascii("xn--al-0ea.com", check_idna2008=true)
  })
  guard error is @idna.InvalidContextO else { fail("Expected InvalidContextO") }
  @test.assert_raise(() => @idna.to_ascii("xn--7a.com", check_idna2008=true))
}

///|
test "idna2008: the ASCII fast path is skipped when the check is on" {
  // U+005F LOW LINE passes UTS #46 without STD3 rules, and the fast path answers
  // such domains without per-label validation.
  try
    inspect(
      @idna.to_ascii("a_b.com", use_std3_ascii_rules=false, check_idna2008=true),
      content="a_b.com",
    )
  catch {
    _ => ()
  } noraise {
    _ => fail("U+005F should be rejected by RFC 5892")
  }
}

///|
test "idna2008: to_unicode applies the same rules" {
  inspect(
    @idna.to_unicode("xn--ll-0ea.com", check_idna2008=true),
    content="l\u{00B7}l.com",
  )
  let error = @test.expect_error(() => {
    @idna.to_unicode("xn--al-0ea.com", check_idna2008=true)
  })
  guard error is @idna.InvalidContextO else { fail("Expected InvalidContextO") }
}
