///|
/// Keep input construction outside the timed closures. Run with:
/// moon bench normalization --target native --release
/// (also --target wasm and --target wasm-gc).
test "normalization spans" (b : @bench.T) {
  for
    (name, input) in [
      ("changed prefix ASCII tail", "e\u{0301}" + "Hello world! ".repeat(256)),
      ("Maybe prefix ASCII tail", "x\u{0301}" + "Hello world! ".repeat(256)),
      (
        "separated changes",
        ("e\u{0301}" + "Hello world! ".repeat(64)).repeat(4),
      ),
      ("ASCII", "Hello world! ".repeat(256)),
      ("normalized mixed", "Café 世界 😀 한글 ".repeat(128)),
      ("decomposed mixed", "Cafe\u{0301} 世界 😀 한글 ".repeat(128)),
      ("dense composition", "e\u{0301}".repeat(256)),
      ("dense unchanged Maybe", "x\u{0301}".repeat(256)),
      ("NFC compatibility characters", "ﬃＡ\u{030A}".repeat(256)),
      ("Hangul Jamo", "각".repeat(256)),
      ("long combining run", "a" + "\u{0315}\u{0300}".repeat(64)),
    ] {
    b.bench(name="NFC/\{name}", fn() { b.keep(@normalization.nfc(input)) })
    b.bench(name="is_normalized/\{name}", fn() {
      b.keep(@normalization.is_normalized(input, @normalization.NFC))
    })
  }
}
