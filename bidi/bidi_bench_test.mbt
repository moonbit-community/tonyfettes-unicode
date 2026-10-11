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
      (
        "explicit formatting",
        "abc \u{2067}\u{05E9}\u{05DC}\u{05D5}\u{05DD} (x) 12\u{2069} def \u{202B}\u{05E2}\u{05D1}\u{05E8}\u{05D9}\u{05EA}\u{202C} ".repeat(
          32,
        ),
      ),
      ("nested brackets", "a (b [c {d} \u{05D0}] 1) \u{05D1} ".repeat(48)),
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
