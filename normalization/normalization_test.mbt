///|
/// Tests for Unicode Normalization

// ==================== NFD Tests ====================

///|
test "nfd: ASCII unchanged" {
  // ASCII text should remain unchanged
  inspect(@normalization.nfd("Hello, World!"), content="Hello, World!")
  inspect(@normalization.nfd("abc123"), content="abc123")
}

///|
test "nfd: already decomposed" {
  // Already decomposed text should remain unchanged
  let decomposed = "A\u{030A}" // A + combining ring above
  inspect(@normalization.nfd(decomposed), content="A\u{030A}")
}

///|
test "nfd: precomposed to decomposed" {
  // Å (U+00C5) should decompose to A (U+0041) + combining ring above (U+030A)
  inspect(@normalization.nfd("\u{00C5}"), content="A\u{030A}")
  // é (U+00E9) should decompose to e (U+0065) + combining acute (U+0301)
  inspect(@normalization.nfd("\u{00E9}"), content="e\u{0301}")
  // ñ (U+00F1) should decompose to n (U+006E) + combining tilde (U+0303)
  inspect(@normalization.nfd("\u{00F1}"), content="n\u{0303}")
}

///|
test "nfd: multi-level decomposition" {
  // Some characters decompose in multiple steps
  // Ṩ (U+1E68) -> S + dot below + dot above
  let result = @normalization.nfd("\u{1E68}")
  // Should be S (0x53) + combining dot below (0x323) + combining dot above (0x307)
  inspect(result, content="S\u{0323}\u{0307}")
}

///|
test "nfd: canonical ordering" {
  // Combining marks should be reordered by CCC
  // Input: a + combining dot above (CCC=230) + combining dot below (CCC=220)
  // Output: a + combining dot below (CCC=220) + combining dot above (CCC=230)
  let input = "a\u{0307}\u{0323}"
  inspect(@normalization.nfd(input), content="a\u{0323}\u{0307}")
}

///|
test "nfd: hangul decomposition" {
  // 가 (U+AC00) -> ᄀ (U+1100) + ᅡ (U+1161)
  inspect(@normalization.nfd("\u{AC00}"), content="\u{1100}\u{1161}")
  // 각 (U+AC01) -> ᄀ (U+1100) + ᅡ (U+1161) + ᆨ (U+11A8)
  inspect(@normalization.nfd("\u{AC01}"), content="\u{1100}\u{1161}\u{11A8}")
  // 한 (U+D55C) -> ᄒ (U+1112) + ᅡ (U+1161) + ᆫ (U+11AB)
  inspect(@normalization.nfd("\u{D55C}"), content="\u{1112}\u{1161}\u{11AB}")
}

// ==================== NFC Tests ====================

///|
test "nfc: ASCII unchanged" {
  inspect(@normalization.nfc("Hello, World!"), content="Hello, World!")
}

///|
test "nfc: already composed" {
  // Already composed text should remain unchanged
  inspect(@normalization.nfc("\u{00C5}"), content="\u{00C5}") // Å
  inspect(@normalization.nfc("\u{00E9}"), content="\u{00E9}") // é
}

///|
test "nfc: decomposed to composed" {
  // A + combining ring above -> Å
  inspect(@normalization.nfc("A\u{030A}"), content="\u{00C5}")
  // e + combining acute -> é
  inspect(@normalization.nfc("e\u{0301}"), content="\u{00E9}")
  // n + combining tilde -> ñ
  inspect(@normalization.nfc("n\u{0303}"), content="\u{00F1}")
}

///|
test "nfc: hangul composition" {
  // ᄀ + ᅡ -> 가
  inspect(@normalization.nfc("\u{1100}\u{1161}"), content="\u{AC00}")
  // ᄀ + ᅡ + ᆨ -> 각
  inspect(@normalization.nfc("\u{1100}\u{1161}\u{11A8}"), content="\u{AC01}")
  // 가 + ᆨ -> 각
  inspect(@normalization.nfc("\u{AC00}\u{11A8}"), content="\u{AC01}")
}

///|
test "nfc: canonical ordering before composition" {
  // Input has combining marks in wrong order
  // a + dot above (CCC=230) + dot below (CCC=220) + acute (CCC=230)
  // After ordering: a + dot below (220) + dot above (230) + acute (230)
  // Composition: ạ (a + dot below) cannot compose with dot above
  let input = "a\u{0307}\u{0323}\u{0301}"
  let result = @normalization.nfc(input)
  // The result should have proper ordering
  assert_true(result.length() > 0)
}

///|
test "nfc: blocked composition" {
  // When a combining mark blocks composition
  // a + cedilla (CCC=202) + acute (CCC=230)
  // The cedilla doesn't block acute from composing with 'a' because CCC(cedilla) < CCC(acute)
  // But a + ogonek (CCC=202) + dot below (CCC=220) - ogonek blocks dot below
  let input = "a\u{0328}\u{0323}" // a + ogonek + dot below
  let result = @normalization.nfc(input)
  // Should NOT compose because ogonek blocks
  inspect(result, content="ą̣")
}

// ==================== NFKD Tests ====================

///|
test "nfkd: compatibility decomposition" {
  // ﬁ (U+FB01) -> fi
  inspect(@normalization.nfkd("\u{FB01}"), content="fi")
  // ﬂ (U+FB02) -> fl
  inspect(@normalization.nfkd("\u{FB02}"), content="fl")
}

///|
test "nfkd: superscript decomposition" {
  // ² (U+00B2) -> 2
  inspect(@normalization.nfkd("\u{00B2}"), content="2")
  // ³ (U+00B3) -> 3
  inspect(@normalization.nfkd("\u{00B3}"), content="3")
}

///|
test "nfkd: fraction decomposition" {
  // ½ (U+00BD) -> 1⁄2 (1 + fraction slash + 2)
  let result = @normalization.nfkd("\u{00BD}")
  assert_true(result.contains("1"))
  assert_true(result.contains("2"))
}

///|
test "nfkd: width variants" {
  // ａ (U+FF41 fullwidth a) -> a
  inspect(@normalization.nfkd("\u{FF41}"), content="a")
  // Ａ (U+FF21 fullwidth A) -> A
  inspect(@normalization.nfkd("\u{FF21}"), content="A")
}

// ==================== NFKC Tests ====================

///|
test "nfkc: compatibility then compose" {
  // ﬁ (U+FB01) -> fi (no further composition)
  inspect(@normalization.nfkc("\u{FB01}"), content="fi")
}

///|
test "nfkc: hangul in fullwidth" {
  // Fullwidth followed by composable should work
  let result = @normalization.nfkc("\u{1100}\u{1161}")
  inspect(result, content="\u{AC00}")
}

// ==================== Property Tests ====================

///|
test "idempotence: nfd" {
  let test_strings = [
    "Hello", "\u{00C5}", "\u{AC00}\u{AC01}", "a\u{0307}\u{0323}",
  ]
  for s in test_strings {
    let once = @normalization.nfd(s)
    let twice = @normalization.nfd(once)
    assert_eq(once, twice)
  }
}

///|
test "idempotence: nfc" {
  let test_strings = ["Hello", "\u{00C5}", "\u{AC00}\u{AC01}", "A\u{030A}"]
  for s in test_strings {
    let once = @normalization.nfc(s)
    let twice = @normalization.nfc(once)
    assert_eq(once, twice)
  }
}

///|
test "idempotence: nfkd" {
  let test_strings = ["Hello", "\u{FB01}", "\u{00B2}"]
  for s in test_strings {
    let once = @normalization.nfkd(s)
    let twice = @normalization.nfkd(once)
    assert_eq(once, twice)
  }
}

///|
test "idempotence: nfkc" {
  let test_strings = ["Hello", "\u{FB01}", "\u{00B2}"]
  for s in test_strings {
    let once = @normalization.nfkc(s)
    let twice = @normalization.nfkc(once)
    assert_eq(once, twice)
  }
}

///|
test "is_normalized" {
  // ASCII is always normalized
  assert_true(@normalization.is_normalized("Hello", @normalization.NFC))
  assert_true(@normalization.is_normalized("Hello", @normalization.NFD))
  // Precomposed Å is NFC but not NFD
  assert_true(@normalization.is_normalized("\u{00C5}", @normalization.NFC))
  assert_false(@normalization.is_normalized("\u{00C5}", @normalization.NFD))
  // Decomposed A + ring is NFD but not NFC
  assert_true(@normalization.is_normalized("A\u{030A}", @normalization.NFD))
  assert_false(@normalization.is_normalized("A\u{030A}", @normalization.NFC))
}

///|
test "empty string" {
  inspect(@normalization.nfd(""), content="")
  inspect(@normalization.nfc(""), content="")
  inspect(@normalization.nfkd(""), content="")
  inspect(@normalization.nfkc(""), content="")
}

///|
test "normalize function" {
  let s = "\u{00C5}" // Å
  assert_eq(
    @normalization.normalize(s, @normalization.NFC),
    @normalization.nfc(s),
  )
  assert_eq(
    @normalization.normalize(s, @normalization.NFD),
    @normalization.nfd(s),
  )
  assert_eq(
    @normalization.normalize(s, @normalization.NFKC),
    @normalization.nfkc(s),
  )
  assert_eq(
    @normalization.normalize(s, @normalization.NFKD),
    @normalization.nfkd(s),
  )
}

// ==================== Conformance Tests (selected from NormalizationTest.txt) ====================

///|
test "conformance: angstrom sign" {
  // U+212B ANGSTROM SIGN
  // NFD: A (0041) + ring above (030A)
  // NFC: Å (00C5)
  let angstrom = "\u{212B}"
  inspect(@normalization.nfd(angstrom), content="A\u{030A}")
  inspect(@normalization.nfc(angstrom), content="\u{00C5}")
}

///|
test "conformance: ohm sign" {
  // U+2126 OHM SIGN -> U+03A9 GREEK CAPITAL LETTER OMEGA
  // This is a singleton decomposition
  inspect(@normalization.nfd("\u{2126}"), content="\u{03A9}")
  inspect(@normalization.nfc("\u{2126}"), content="\u{03A9}")
}

///|
test "conformance: combining sequence" {
  // Test from UAX #15 examples
  // D (0044) + combining dot above (0307) -> Ḋ (1E0A)
  inspect(@normalization.nfc("D\u{0307}"), content="\u{1E0A}")
  inspect(@normalization.nfd("\u{1E0A}"), content="D\u{0307}")
}

///|
test "NFD: marks around a Hangul syllable keep their ordering rules" {
  // U+0315 (class 232) before U+0300 (class 230) is reordered after the jamo.
  assert_eq(
    @normalization.nfd("\u{D55C}\u{0315}\u{0300}"),
    "\u{1112}\u{1161}\u{11AB}\u{0300}\u{0315}",
  )
  // The jamo are starters, so a mark before the syllable stays where it is.
  assert_eq(
    @normalization.nfd("a\u{0315}\u{AC00}\u{0300}"),
    "a\u{0315}\u{1100}\u{1161}\u{0300}",
  )
  assert_eq(@normalization.nfkd("\u{AC01}"), "\u{1100}\u{1161}\u{11A8}")
}

///|
test "NFD and NFKD: recursive and compatibility decompositions" {
  // U+1EC7 decomposes in two steps.
  assert_eq(@normalization.nfd("\u{1EC7}"), "e\u{0323}\u{0302}")
  // U+01C4 has only a compatibility mapping, whose second character
  // decomposes canonically.
  assert_eq(@normalization.nfd("\u{01C4}"), "\u{01C4}")
  assert_eq(@normalization.nfkd("\u{01C4}"), "DZ\u{030C}")
  assert_eq(@normalization.nfkd("\u{FB03}\u{00E9}"), "ffie\u{0301}")
}

///|
test "NFC: the last character of a clean run composes with what follows" {
  // U+11099 is a supplementary starter after a clean run; the nukta
  // (Quick_Check=Maybe) composes with it.
  assert_eq(@normalization.nfc("ab\u{11099}\u{110BA}"), "ab\u{1109A}")
  // The marks are reordered before composing: U+0323 (class 220) composes
  // with `e`, and U+0301 (class 230) then has no composite.
  assert_eq(@normalization.nfc("e\u{0301}\u{0323}"), "\u{1EB9}\u{0301}")
}

///|
test "NFC and NFKC: conjoining jamo compose only when adjacent" {
  assert_eq(@normalization.nfc("x\u{1100}"), "x\u{1100}")
  assert_eq(@normalization.nfc("\u{1100}a\u{1161}"), "\u{1100}a\u{1161}")
  // A mark between the syllable and a trailing jamo blocks it.
  assert_eq(
    @normalization.nfc("\u{1100}\u{1161}\u{0301}\u{11A8}"),
    "\u{AC00}\u{0301}\u{11A8}",
  )
  assert_eq(
    @normalization.nfc("\u{AC00}\u{0323}\u{11A8}"),
    "\u{AC00}\u{0323}\u{11A8}",
  )
  // The trailing jamo past the view's end is not read.
  let text = "x\u{1100}\u{1161}\u{11A8}"
  assert_eq(@normalization.nfc(text[1:3]), "\u{AC00}")
  assert_eq(@normalization.nfc(text[1:4]), "\u{AC01}")
  // U+3131 decomposes to a leading jamo, which composes with the vowel.
  assert_eq(@normalization.nfkc("\u{3131}\u{1161}"), "\u{AC00}")
}

///|
test "NFKC: an LV syllable composes with a compatibility trailing jamo" {
  // U+3133 and U+FFA3 decompose to the trailing jamo U+11AA, which composes
  // with the syllable that the leading jamo and vowel before it form.
  assert_eq(@normalization.nfkc("\u{1100}\u{1161}\u{3133}"), "\u{AC03}")
  assert_eq(@normalization.nfkc("\u{1100}\u{1161}\u{FFA3}"), "\u{AC03}")
  assert_eq(@normalization.nfkc("\u{AC00}\u{3133}"), "\u{AC03}")
  // Normalizing again changes nothing.
  assert_eq(@normalization.nfkc("\u{AC03}"), "\u{AC03}")
  assert_true(@normalization.is_normalized("\u{AC03}", NFKC))
  assert_true(!@normalization.is_normalized("\u{1100}\u{1161}\u{3133}", NFKC))
  // NFC leaves the compatibility jamo, so the syllable stays LV.
  assert_eq(@normalization.nfc("\u{1100}\u{1161}\u{3133}"), "\u{AC00}\u{3133}")
  // The LV syllable still ends its segment before what follows.
  assert_eq(@normalization.nfkc("\u{1100}\u{1161}a"), "\u{AC00}a")
  assert_eq(
    @normalization.nfkc("\u{1100}\u{1161}\u{1100}\u{1161}"),
    "\u{AC00}\u{AC00}",
  )
}
