///|
/// Keep input construction outside the timed closures. Run with:
/// moon bench ucd --target native --release
/// (also --target wasm and --target wasm-gc).
test "case mapping" (b : @bench.T) {
  for
    (name, input) in [
      ("ASCII", "Hello world, this is a Test. ".repeat(32)),
      ("Latin", "Ünïcödé Çàfé Straße ".repeat(32)),
      ("Greek", "Ὀδυσσεύς καὶ ᾈχιλλεύς ".repeat(32)),
      ("CJK", "世界こんにちは、テスト。".repeat(64)),
    ] {
    b.bench(name="to_simple_uppercase/\{name}", fn() {
      let mut sum = 0
      for c in input {
        sum = sum ^ @ucd.to_simple_uppercase(c).to_int()
      }
      b.keep(sum)
    })
    b.bench(name="to_simple_lowercase/\{name}", fn() {
      let mut sum = 0
      for c in input {
        sum = sum ^ @ucd.to_simple_lowercase(c).to_int()
      }
      b.keep(sum)
    })
    b.bench(name="to_uppercase/\{name}", fn() {
      let mut length = 0
      for c in input {
        length += @ucd.to_uppercase(c).length()
      }
      b.keep(length)
    })
    b.bench(name="to_lowercase/\{name}", fn() {
      let mut length = 0
      for c in input {
        length += @ucd.to_lowercase(c).length()
      }
      b.keep(length)
    })
  }
}
