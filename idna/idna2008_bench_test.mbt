///|
/// Benchmark the public conversion pipeline with both optional IDNA2008
/// checks enabled. Inputs and their A-label forms are validated before timing.
/// Run with moon bench idna/idna2008_bench_test.mbt --target native --release
/// (also --target js, --target wasm-gc, and --target wasm).
test "IDNA2008 domain conversion" (b : @bench.T) {
  for
    (name, input) in [
      ("ASCII", "www.example.com"),
      ("Latin", "bücher.münchen.example"),
      ("middle dot", "l·l.example"),
      ("Greek", "\u{0375}α.example"),
      ("Hebrew", "א\u{05F3}.example"),
      ("Japanese early", "カ・abcdefghijklmnopqrstuvwx.example"),
      ("Japanese late", "abcdefghijklmnopqrstuvwx・カ.example"),
      ("Arabic digits", "ا١٢٣٤٥٦٧٨٩٠.example"),
      (
        "long middle dots", "l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l·l.example",
      ),
    ] {
    let ascii = @idna.to_ascii(input, check_idna2008=true, check_contexto=true)
    ignore(@idna.to_unicode(ascii, check_idna2008=true, check_contexto=true))
    b.bench(name="to_ascii/\{name}", fn() {
      b.keep(
        @idna.to_ascii(input, check_idna2008=true, check_contexto=true) catch {
          _ => input
        },
      )
    })
    b.bench(name="to_unicode/\{name}", fn() {
      b.keep(
        @idna.to_unicode(ascii, check_idna2008=true, check_contexto=true) catch {
          _ => ascii
        },
      )
    })
  }
}
