///|
/// Keep input construction outside the timed closures. Run with:
/// moon bench bidi --target native --release
/// (also --target wasm and --target wasm-gc).
test "bidi classes and paragraphs" (b : @bench.T) {
  for
    (name, input) in [
      ("ASCII", "Hello world, this is a test (of brackets) 12345. ".repeat(32)),
      ("Arabic", "مرحبا بالعالم (اختبار) 123 ".repeat(32)),
      (
        "mixed",
        "Hello مرحبا world بالعالم [test] 12,345.67 ".repeat(32),
      ),
      ("CJK", "世界こんにちは、テスト。".repeat(64)),
      ("supplementary", "𐤀𐤁𐤂 😀 𝒜𝒷 ".repeat(64)),
    ] {
    b.bench(name="bidi_class/\{name}", fn() {
      let mut strong_ltr = 0
      for c in input {
        if @bidi.bidi_class(c) is L {
          strong_ltr += 1
        }
      }
      b.keep(strong_ltr)
    })
    b.bench(name="requires_bidi/\{name}", fn() {
      b.keep(@bidi.requires_bidi(input))
    })
    b.bench(name="process/\{name}", fn() { b.keep(@bidi.process(input)) })
  }
}
