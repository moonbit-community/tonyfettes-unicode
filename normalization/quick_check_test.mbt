///|
test "quick check handles Yes No and contextual Maybe" {
  for
    form in [
      @normalization.NFC,
      @normalization.NFD,
      @normalization.NFKC,
      @normalization.NFKD,
    ] {
    assert_true(@normalization.is_normalized("", form))
    assert_true(@normalization.is_normalized("Hello 世界 😀", form))
    assert_true(@normalization.is_normalized("\u{0301}", form))
  }
  assert_true(@normalization.is_normalized("é", @normalization.NFC))
  assert_false(@normalization.is_normalized("é", @normalization.NFD))
  assert_false(@normalization.is_normalized("e\u{0301}", @normalization.NFC))
  // Maybe does not imply that a composition is possible in this context.
  assert_true(@normalization.is_normalized("x\u{0301}", @normalization.NFC))
  assert_true(
    @normalization.is_normalized("a\u{0305}\u{0301}", @normalization.NFC),
  )
  assert_false(
    @normalization.is_normalized("x\u{0301}ﬃ", @normalization.NFKC),
  )
}

///|
test "quick check verifies order and resets at starters" {
  for
    form in [
      @normalization.NFC,
      @normalization.NFD,
      @normalization.NFKC,
      @normalization.NFKD,
    ] {
    // These non-composing marks individually have Quick_Check=Yes.
    assert_false(@normalization.is_normalized("\u{0315}\u{0316}", form))
    assert_eq(
      @normalization.normalize("\u{0315}\u{0316}", form),
      "\u{0316}\u{0315}",
    )
    assert_true(@normalization.is_normalized("\u{0315}x\u{0316}", form))
  }
}

///|
test "spans retain precomposed starters and supplementary offsets" {
  assert_eq(
    @normalization.nfc("😀abcă\u{0328}世界😀e\u{0301}!"),
    "😀abcą\u{0306}世界😀é!",
  )
  assert_eq(@normalization.nfd("😀é|Å😀"), "😀e\u{0301}|A\u{030A}😀")
  assert_eq(@normalization.nfkc("😀Ａ\u{030A}|ﬃ😀"), "😀Å|ffi😀")
  assert_eq(
    @normalization.nfkd("😀Ａ\u{030A}|ﬃ😀"),
    "😀A\u{030A}|ffi😀",
  )
}

///|
test "CCC zero Maybe characters do not split Hangul composition" {
  for form in [@normalization.NFC, @normalization.NFKC] {
    assert_eq(
      @normalization.normalize("😀각|각😀", form),
      "😀각|각😀",
    )
    assert_true(@normalization.is_normalized("ᅡ", form))
    assert_false(@normalization.is_normalized("가", form))
    assert_eq(
      @normalization.normalize("ᄀ\u{0301}ᅡ", form),
      "ᄀ\u{0301}ᅡ",
    )
  }
}

///|
test "Unicode 16 composite Maybe characters keep their preceding context" {
  // Kirat Rai: AA + AI must decompose AI before composing with AA.
  for form in [@normalization.NFC, @normalization.NFKC] {
    assert_true(@normalization.is_normalized("\u{16D68}", form))
    assert_false(@normalization.is_normalized("\u{16D63}\u{16D68}", form))
    assert_eq(
      @normalization.normalize("😀\u{16D63}\u{16D68}|", form),
      "😀\u{16D6A}|",
    )
  }
}

///|
test "local segments preserve short and long copied runs" {
  for gap_length in [0, 1, 15, 16, 17, 40] {
    let gap = "-".repeat(gap_length)
    let prefix = "😀prefix".repeat(8)
    let suffix = "suffix😀".repeat(8)
    let decomposed = "\{prefix}e\u{0301}\{gap}a\u{030A}\{suffix}"
    let composed = "\{prefix}é\{gap}å\{suffix}"
    for form in [@normalization.NFC, @normalization.NFKC] {
      assert_eq(@normalization.normalize(decomposed, form), composed)
    }
    for form in [@normalization.NFD, @normalization.NFKD] {
      assert_eq(@normalization.normalize(composed, form), decomposed)
    }
  }
}

///|
test "local checking continues after unchanged Maybe segments" {
  let prefix = "x\u{0301}😀".repeat(32)
  for form in [@normalization.NFC, @normalization.NFKC] {
    assert_true(@normalization.is_normalized(prefix, form))
    for
      (tail, expected) in [
        ("e\u{0301}", "é"),
        ("ă\u{0328}", "ą\u{0306}"),
        ("\u{0315}\u{0316}", "\u{0316}\u{0315}"),
        ("각", "각"),
        ("\u{16D63}\u{16D68}", "\u{16D6A}"),
      ] {
      let input = prefix + tail
      assert_false(@normalization.is_normalized(input, form))
      assert_eq(@normalization.normalize(input, form), prefix + expected)
      // Also exercise a changed segment followed by unchanged Maybe segments.
      assert_eq(
        @normalization.normalize(tail + prefix, form),
        expected + prefix,
      )
    }
  }
}

///|
test "scratch reuse after expansion composition and long combining runs" {
  let marks = "\u{0315}".repeat(64) + "\u{0316}".repeat(64)
  let ordered = "\u{0316}".repeat(64) + "\u{0315}".repeat(64)
  let input = "ﬃ|\{marks}|e\u{0301}|x\u{0301}|😀Ａ\u{030A}"
  for
    (form, expected) in [
      (@normalization.NFC, "ﬃ|\{ordered}|é|x\u{0301}|😀Ａ\u{030A}"),
      (@normalization.NFKC, "ffi|\{ordered}|é|x\u{0301}|😀Å"),
      (@normalization.NFD, "ﬃ|\{ordered}|e\u{0301}|x\u{0301}|😀Ａ\u{030A}"),
      (@normalization.NFKD, "ffi|\{ordered}|e\u{0301}|x\u{0301}|😀A\u{030A}"),
    ] {
    assert_eq(@normalization.normalize(input, form), expected)
    assert_false(@normalization.is_normalized(input, form))
    assert_true(@normalization.is_normalized(expected, form))
  }
}
