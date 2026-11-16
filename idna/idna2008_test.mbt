///|
fn expect_idna2008_rejection(
  domain : String,
  expected_cp : Int32,
) -> Unit raise {
  for ascii in [true, false] {
    try {
      if ascii {
        @idna.to_ascii(domain, use_std3_ascii_rules=false, check_idna2008=true)
      } else {
        @idna.to_unicode(
          domain,
          use_std3_ascii_rules=false,
          check_idna2008=true,
        )
      }
    } catch {
      @idna.DisallowedCodePoint(cp~) => @test.assert_eq(cp, expected_cp)
      error => raise error
    } noraise {
      _ => fail("Expected IDNA2008 repertoire rejection for \{domain}")
    }
  }
}

///|
fn expect_contexto_rejection(
  domain : String,
  expected_cp? : Int32,
) -> Unit raise {
  for ascii in [true, false] {
    try {
      if ascii {
        @idna.to_ascii(domain, check_contexto=true, check_bidi=false)
      } else {
        @idna.to_unicode(domain, check_contexto=true, check_bidi=false)
      }
    } catch {
      @idna.InvalidContextO(cp~) =>
        if expected_cp is Some(expected) {
          @test.assert_eq(cp, expected)
        }
      error => raise error
    } noraise {
      _ => fail("Expected CONTEXTO rejection for \{domain}")
    }
  }
}

///|
test "IDNA2008 repertoire: default preserves UTS46 symbols" {
  inspect(@idna.to_ascii("☕.example"), content="xn--53h.example")
  inspect(@idna.to_unicode("xn--53h.example"), content="☕.example")
  inspect(@idna.to_ascii("♥.example"), content="xn--g6h.example")
  inspect(@idna.to_unicode("xn--g6h.example"), content="♥.example")
  for
    (input, cp) in [
      ("☕.example", 0x2615),
      ("xn--53h.example", 0x2615),
      ("♥.example", 0x2665),
      ("xn--g6h.example", 0x2665),
    ] {
    expect_idna2008_rejection(input, cp)
  }
}

///|
test "IDNA2008 repertoire: mapping and NFC still precede validation" {
  for input in ["BÜCHER.DE", "ｂüｃｈｅｒ．ｄｅ", "bu\u{0308}cher.de"] {
    inspect(
      @idna.to_ascii(input, check_idna2008=true, check_contexto=true),
      content="xn--bcher-kva.de",
    )
    inspect(
      @idna.to_unicode(input, check_idna2008=true, check_contexto=true),
      content="bücher.de",
    )
  }
  inspect(
    @idna.to_ascii("EXAM\u{00AD}PLE.COM", check_idna2008=true),
    content="example.com",
  )
  inspect(
    @idna.to_unicode("EXAM\u{00AD}PLE.COM", check_idna2008=true),
    content="example.com",
  )
}

///|
test "IDNA2008 repertoire: unchanged labels and decoded ACE are checked" {
  for
    input in [
      "☕.example", "☕.EXAMPLE", "xn--53h.example", "XN--53H.EXAMPLE",
    ] {
    expect_idna2008_rejection(input, 0x2615)
  }
  inspect(
    @idna.to_ascii("faß.de", check_idna2008=true),
    content="xn--fa-hia.de",
  )
  inspect(
    @idna.to_unicode("xn--fa-hia.de", check_idna2008=true),
    content="faß.de",
  )
}

///|
test "IDNA2008 repertoire: ASCII fast path respects independent STD3 flag" {
  inspect(
    @idna.to_ascii("under_score.example", use_std3_ascii_rules=false),
    content="under_score.example",
  )
  inspect(
    @idna.to_unicode("under_score.example", use_std3_ascii_rules=false),
    content="under_score.example",
  )
  expect_idna2008_rejection("under_score.example", 0x005F)
  expect_idna2008_rejection("UNDER_SCORE.EXAMPLE", 0x005F)
  for input in ["example.com", "EXAMPLE.COM"] {
    inspect(@idna.to_ascii(input, check_idna2008=true), content="example.com")
    inspect(@idna.to_unicode(input, check_idna2008=true), content="example.com")
  }
}

///|
test "CONTEXTO: valid contexts survive Unicode and ACE conversion" {
  for
    label in [
      "l·l", "\u{0375}α", "\u{0375}\u{1F00}", "א\u{05F3}", "א\u{05F4}", "・カ",
      "カ・", "・あ", "・中", "・\u{20000}", "\u{0660}\u{0669}", "\u{06F0}\u{06F9}",
    ] {
    // Pure digit labels test CONTEXTO independently of RFC 5893.
    let ace = @idna.to_ascii(label, check_bidi=false)
    for input in [label, ace] {
      @test.assert_eq(
        @idna.to_ascii(
          input,
          check_idna2008=true,
          check_contexto=true,
          check_bidi=false,
        ),
        ace,
      )
      @test.assert_eq(
        @idna.to_unicode(
          input,
          check_idna2008=true,
          check_contexto=true,
          check_bidi=false,
        ),
        label,
      )
    }
  }
}

///|
test "CONTEXTO: middle dot requires an immediate l on both sides" {
  for label in ["·", "·l", "l·", "a·l", "l·a", "l·\u{0301}l"] {
    expect_contexto_rejection(label, expected_cp=0x00B7)
    let ace = @idna.to_ascii(label, check_bidi=false)
    expect_contexto_rejection(ace, expected_cp=0x00B7)
  }
  inspect(
    @idna.to_unicode("L·L", check_idna2008=true, check_contexto=true),
    content="l·l",
  )
}

///|
test "CONTEXTO: Greek numeral sign checks following Script not block" {
  // U+03E3 is Coptic despite belonging to the Greek and Coptic block.
  for label in ["\u{0375}", "\u{0375}a", "α\u{0375}", "\u{0375}\u{03E3}"] {
    expect_contexto_rejection(label, expected_cp=0x0375)
    let ace = @idna.to_ascii(label, check_bidi=false)
    expect_contexto_rejection(ace, expected_cp=0x0375)
  }
}

///|
test "CONTEXTO: Hebrew punctuation requires preceding Hebrew Script" {
  for
    (label, cp) in [
      ("\u{05F3}", 0x05F3),
      ("\u{05F4}", 0x05F4),
      ("\u{05F3}א", 0x05F3),
      ("a\u{05F3}", 0x05F3),
      ("a\u{05F4}", 0x05F4),
    ] {
    expect_contexto_rejection(label, expected_cp=cp)
    let ace = @idna.to_ascii(label, check_bidi=false)
    expect_contexto_rejection(ace, expected_cp=cp)
  }
}

///|
test "CONTEXTO: Katakana middle dot needs a qualifying Script in its label" {
  // U+30FC has Script=Common, even though its Script_Extensions are Japanese.
  for label in ["・", "a・", "・ー", "カ.a・", "a・.カ"] {
    expect_contexto_rejection(label, expected_cp=0x30FB)
    let ace = @idna.to_ascii(label, check_bidi=false)
    expect_contexto_rejection(ace, expected_cp=0x30FB)
  }
}

///|
test "CONTEXTO: Arabic digit sets cannot mix within one label" {
  for label in ["\u{0660}\u{06F0}", "\u{06F9}\u{0669}"] {
    expect_contexto_rejection(label)
    let ace = @idna.to_ascii(label, check_bidi=false)
    expect_contexto_rejection(ace)
  }
  let separate_labels = "\u{0660}.\u{06F0}"
  let ace = @idna.to_ascii(
    separate_labels,
    check_idna2008=true,
    check_contexto=true,
    check_bidi=false,
  )
  @test.assert_eq(
    @idna.to_unicode(
      ace,
      check_idna2008=true,
      check_contexto=true,
      check_bidi=false,
    ),
    separate_labels,
  )
}

///|
test "CONTEXTO: adjacent labels cannot supply immediate context" {
  for
    (domain, cp) in [
      ("l.·l", 0x00B7),
      ("l·.l", 0x00B7),
      ("\u{0375}.α", 0x0375),
      ("א.\u{05F3}", 0x05F3),
      ("א.\u{05F4}", 0x05F4),
    ] {
    expect_contexto_rejection(domain, expected_cp=cp)
  }
}

///|
test "IDNA2008 repertoire and CONTEXTO flags are independent" {
  inspect(@idna.to_unicode("a·b", check_idna2008=true), content="a·b")
  expect_contexto_rejection("a·b", expected_cp=0x00B7)
  inspect(
    @idna.to_ascii("☕.example", check_contexto=true),
    content="xn--53h.example",
  )
  inspect(
    @idna.to_unicode("xn--53h.example", check_contexto=true),
    content="☕.example",
  )
  inspect(
    @idna.to_ascii("-example", check_idna2008=true, check_hyphens=false),
    content="-example",
  )
  inspect(
    @idna.to_unicode("-example", check_idna2008=true, check_hyphens=false),
    content="-example",
  )
}

///|
test "IDNA2008 repertoire: CONTEXTJ still obeys check_joiners" {
  for ascii in [true, false] {
    try {
      if ascii {
        @idna.to_ascii("a\u{200C}b", check_idna2008=true)
      } else {
        @idna.to_unicode("a\u{200C}b", check_idna2008=true)
      }
    } catch {
      @idna.InvalidJoiner => ()
      error => raise error
    } noraise {
      _ => fail("Expected existing CONTEXTJ validation")
    }
  }
  let ace = @idna.to_ascii(
    "a\u{200C}b",
    check_idna2008=true,
    check_contexto=true,
    check_joiners=false,
  )
  inspect(
    @idna.to_unicode(
      ace,
      check_idna2008=true,
      check_contexto=true,
      check_joiners=false,
    ),
    content="a\u{200C}b",
  )
}
