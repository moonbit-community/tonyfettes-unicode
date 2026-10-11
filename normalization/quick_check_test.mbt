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

///|
test "fast runs retain boundaries across ordered marks and surrogate pairs" {
  for
    prefix in [
      "",
      "ASCII",
      "世界",
      "😀",
      "\u{10000}",
      "\u{10FFFF}",
      "世界😀".repeat(16),
    ] {
    for
      (tail, expected) in [
        ("A\u{0316}\u{0301}", "Á\u{0316}"),
        ("\u{0316}\u{0315}", "\u{0316}\u{0315}"),
        ("\u{0315}\u{0316}", "\u{0316}\u{0315}"),
        ("\u{0315}😀\u{0316}", "\u{0315}😀\u{0316}"),
        ("\u{0315}A\u{0301}", "\u{0315}Á"),
        ("\u{16D63}\u{16D68}", "\u{16D6A}"),
      ] {
      let input = prefix + tail
      let normalized = prefix + expected
      assert_eq(@normalization.nfc(input), normalized)
      assert_eq(
        @normalization.is_normalized(input, @normalization.NFC),
        input == normalized,
      )
    }
  }
}

///|
test "resume fast runs between suspect segments and at the end" {
  for
    gap in [
      "",
      "A",
      "AA",
      "AAA",
      "Hello world! ".repeat(256),
      "世界😀".repeat(64),
    ] {
    for
      (form, input_part, normalized_part) in [
        (@normalization.NFC, "e\u{0301}", "é"),
        (@normalization.NFC, "x\u{0301}", "x\u{0301}"),
        (@normalization.NFC, "각", "각"),
        (@normalization.NFC, "\u{16D63}\u{16D68}", "\u{16D6A}"),
        (@normalization.NFD, "é", "e\u{0301}"),
        (@normalization.NFKC, "ﬃＡ\u{030A}", "ffiÅ"),
        (@normalization.NFKD, "ﬃÅ", "ffiA\u{030A}"),
      ] {
      for tail in ["", "\u{0315}\u{0316}", "😀\u{0315}\u{0316}"] {
        let ordered_tail = if tail == "" {
          ""
        } else if tail == "\u{0315}\u{0316}" {
          "\u{0316}\u{0315}"
        } else {
          "😀\u{0316}\u{0315}"
        }
        // Separators prevent the expected pieces from interacting; the final
        // gap + marks also checks recovery of the last skipped starter.
        let input = input_part + "|" + gap + "|" + input_part + "|" + gap + tail
        let expected = normalized_part +
          "|" +
          gap +
          "|" +
          normalized_part +
          "|" +
          gap +
          ordered_tail
        assert_eq(@normalization.normalize(input, form), expected)
        assert_eq(@normalization.is_normalized(input, form), input == expected)
        assert_true(@normalization.is_normalized(expected, form))
      }
    }
  }
  // After an unchanged Maybe segment, recover A as the next composing starter.
  assert_eq(@normalization.nfc("x\u{0301}AAA\u{0301}"), "x\u{0301}AAÁ")
  assert_false(
    @normalization.is_normalized("x\u{0301}AAA\u{0301}", @normalization.NFC),
  )
}

///|
test "surrogate summaries respect form masks and recover complete boundaries" {
  for gap in ["😀", "\u{10FFFD}", "\u{10000}", "\u{1D400}"] {
    for
      (form, changed, fixed, normalized_gap) in [
        (@normalization.NFC, "e\u{0301}", "é", gap),
        (@normalization.NFD, "é", "e\u{0301}", gap),
        (
          @normalization.NFKC,
          "e\u{0301}",
          "é",
          if gap == "\u{1D400}" {
            "A"
          } else {
            gap
          },
        ),
        (
          @normalization.NFKD,
          "é",
          "e\u{0301}",
          if gap == "\u{1D400}" {
            "A"
          } else {
            gap
          },
        ),
      ] {
      // No separator before the marks: recovery must retain the full pair,
      // including when a changed prefix has already allocated scratch storage.
      for prefix in ["", changed + "|"] {
        let fixed_prefix = if prefix == "" { "" } else { fixed + "|" }
        let input = prefix + gap.repeat(8) + "\u{0315}\u{0316}|" + changed
        let expected = fixed_prefix +
          normalized_gap.repeat(8) +
          "\u{0316}\u{0315}|" +
          fixed
        assert_eq(@normalization.normalize(input, form), expected)
        assert_false(@normalization.is_normalized(input, form))
        assert_true(@normalization.is_normalized(expected, form))
      }
    }
  }
  // Active groups still decode mappings, combining marks and backward composition.
  assert_eq(@normalization.nfd("\u{1D15E}"), "\u{1D157}\u{1D165}")
  assert_eq(@normalization.nfc("\u{11099}\u{110BA}"), "\u{1109A}")
  assert_eq(
    @normalization.nfc("😀\u{1D165}\u{1D167}"),
    "😀\u{1D167}\u{1D165}",
  )
}

///|
test "surrogate summaries keep isolated code units unchanged" {
  for cp in [0xD800, 0xD835, 0xDBFF, 0xDC00, 0xDFFF] {
    let lone = String::from_array([cp.unsafe_to_char()])
    for input in [lone, lone + "A", "A" + lone] {
      for
        form in [
          @normalization.NFC,
          @normalization.NFD,
          @normalization.NFKC,
          @normalization.NFKD,
        ] {
        assert_eq(@normalization.normalize(input, form), input)
        assert_true(@normalization.is_normalized(input, form))
      }
    }
  }
}

///|
test "unpaired surrogates stay clean next to suspect characters" {
  // U+D835 leads a group of 1024 code points that has flagged characters.
  let lead = String::from_array([(0xD835).unsafe_to_char()])
  let trail = String::from_array([(0xDC00).unsafe_to_char()])
  for
    (input, expected) in [
      (lead + "e\u{0301}", lead + "é"),
      ("e\u{0301}" + lead, "é" + lead),
      (trail + lead + "e\u{0301}", trail + lead + "é"),
      (lead + "\u{0301}", lead + "\u{0301}"),
      (lead + "\u{0315}\u{0316}", lead + "\u{0316}\u{0315}"),
      // The second unit pairs with the trailing one; the first stays alone.
      (
        lead + lead + trail + "\u{0315}\u{0316}",
        lead + lead + trail + "\u{0316}\u{0315}",
      ),
      (
        "e\u{0301}|" + lead + lead + trail + lead,
        "é|" + lead + lead + trail + lead,
      ),
    ] {
    assert_eq(@normalization.nfc(input), expected)
    assert_eq(
      @normalization.is_normalized(input, @normalization.NFC),
      input == expected,
    )
    assert_true(@normalization.is_normalized(expected, @normalization.NFC))
  }
}

///|
test "clean pairs in flagged groups become the safe boundary" {
  // U+1D400 is clean for NFC and NFD, but shares its group with U+1D15E.
  let pair = "\u{1D400}"
  for prefix in ["", "世界", "e\u{0301}|"] {
    let fixed = if prefix == "e\u{0301}|" { "é|" } else { prefix }
    for count in [1, 2, 64] {
      let run = pair.repeat(count)
      // Marks attach to the last pair, so only they are reordered.
      assert_eq(
        @normalization.nfc(prefix + run + "\u{0315}\u{0316}"),
        fixed + run + "\u{0316}\u{0315}",
      )
      // A starter after the run composes without disturbing it.
      assert_eq(
        @normalization.nfc(prefix + run + "e\u{0301}"),
        fixed + run + "é",
      )
      assert_eq(
        @normalization.is_normalized(prefix + run, @normalization.NFC),
        prefix == fixed,
      )
    }
  }
}
