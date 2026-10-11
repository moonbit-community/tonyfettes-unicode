///|
/// Keep input validation outside the timed closures. Run with:
/// moon bench idna --target native --release
/// (also --target wasm and --target wasm-gc).
test "domain conversion" (b : @bench.T) {
  for
    (name, input) in [
      ("ASCII", "www.example.com"),
      ("long ASCII", "the-quick-brown-fox.jumps-over-the-lazy-dog.example.org"),
      ("mixed-case ASCII", "WWW.Example.COM"),
      ("ASCII underscore", "_dmarc.example.com"),
      ("Latin", "bücher.münchen.example"),
      ("mixed-case Latin", "Bücher.München.Example"),
      ("CJK", "例え.テスト.日本語"),
      ("Arabic", "مثال.إختبار"),
      ("A-labels", "xn--bcher-kva.xn--mnchen-3ya.example"),
    ] {
    // Every input is valid without STD3 rules, so the closures time
    // successful conversions only.
    ignore(@idna.to_ascii(input, use_std3_ascii_rules=false))
    ignore(@idna.to_unicode(input, use_std3_ascii_rules=false))
    b.bench(name="to_ascii/\{name}", fn() {
      b.keep(
        @idna.to_ascii(input, use_std3_ascii_rules=false) catch {
          _ => input
        },
      )
    })
    b.bench(name="to_unicode/\{name}", fn() {
      b.keep(
        @idna.to_unicode(input, use_std3_ascii_rules=false) catch {
          _ => input
        },
      )
    })
  }
}
