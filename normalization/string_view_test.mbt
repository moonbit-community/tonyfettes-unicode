///|
test "normalization accepts bounded and nested string views" {
  let source = "😀!Ａ\u{030A}ﬃé!😀"
  let view = source[2:source.length() - 2][1:5]
  inspect(@normalization.nfd(view), content="Ａ\u{030A}ﬃe\u{0301}")
  inspect(@normalization.nfc(view), content="Ａ\u{030A}ﬃé")
  inspect(@normalization.nfkd(view), content="A\u{030A}ffie\u{0301}")
  inspect(@normalization.nfkc(view), content="Åffié")
  // Neither a preceding starter nor a following mark belongs to the view.
  inspect(@normalization.nfc("A\u{030A}"[1:]), content="\u{030A}")
  inspect(@normalization.nfc("A\u{030A}"[:1]), content="A")
  assert_true(@normalization.is_normalized("A\u{030A}"[1:], @normalization.NFC))
  assert_true(@normalization.is_normalized("é"[1:1], @normalization.NFD))
  inspect(@normalization.nfd("é"[1:1]), content="")
}

///|
test "normalization scanners respect view offsets and ends" {
  for prefix_length in 1..<20 {
    let prefix = "é".repeat(prefix_length)
    for gap_length in [0, 1, 15, 16, 17, 23, 24, 25, 64] {
      let gap = "x".repeat(gap_length)
      for
        sample in [
          "",
          "ASCII",
          "é",
          "e\u{0301}",
          "Ａﬃ",
          "x\u{0301}",
          "\u{0315}\u{0316}",
          "각",
          "😀",
          "\u{1D15E}",
          "\u{16D63}\u{16D68}",
          // Resume absolute scanning between suspect segments, then recover
          // the preceding starter inside a view with a nonzero start.
          "e\u{0301}\{gap}😀e\u{0301}",
          "x\u{0315}\u{0316}\{gap}\u{1D15E}",
        ] {
        let input = "\{gap}\{sample}\{gap}"
        let source = "\{prefix}\{input}é\u{0301}😀"
        let view = source[prefix.length():prefix.length() + input.length()]
        for
          form in [
            @normalization.NFD,
            @normalization.NFC,
            @normalization.NFKD,
            @normalization.NFKC,
          ] {
          assert_eq(
            @normalization.normalize(view, form),
            @normalization.normalize(input, form),
          )
          assert_eq(
            @normalization.is_normalized(view, form),
            @normalization.is_normalized(input, form),
          )
        }
      }
    }
  }
}
