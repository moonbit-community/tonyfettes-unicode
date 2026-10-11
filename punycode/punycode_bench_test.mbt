///|
/// Keep input preparation outside the timed closures. Run with:
/// moon bench punycode --target native --release
/// (also --target wasm and --target wasm-gc).
test "encode and decode" (b : @bench.T) {
  for
    (name, input) in [
      ("ASCII", "example"),
      ("Latin", "bücher"),
      ("Arabic", "مثال"),
      ("CJK", "日本語テスト例え"),
      ("supplementary", "😀😃😄𝒜"),
      (
        "long", "ünïcödé-ünïcödé-ünïcödé-ünïcödé-ünïcödé-ünïcödé",
      ),
    ] {
    // Every input round-trips, so the closures time successful calls only.
    let encoded = @punycode.encode(input)
    assert_eq(@punycode.decode(encoded), input)
    b.bench(name="encode/\{name}", fn() {
      b.keep(@punycode.encode(input) catch { _ => input })
    })
    b.bench(name="decode/\{name}", fn() {
      b.keep(@punycode.decode(encoded) catch { _ => encoded })
    })
  }
}
