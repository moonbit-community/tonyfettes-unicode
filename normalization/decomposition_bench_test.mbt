///|
/// Keep input construction outside the timed closures. Run with:
/// moon bench normalization --target native --release
/// (also --target wasm and --target wasm-gc).
test "decomposition" (b : @bench.T) {
  for
    (name, input) in [
      ("accented Latin", "Ünïcödé Çàfé Dragiša Đorđević ".repeat(64)),
      ("Vietnamese", "Việt Nam ngữ pháp tiếng Việt ".repeat(64)),
      ("dense precomposed", "éèêëàâîïôûç".repeat(128)),
      ("compatibility characters", "ﬃ①½ｱ㍿".repeat(128)),
      ("Hangul syllables", "한국어 정규화 ".repeat(128)),
      ("unchanged CJK", "中文日本語".repeat(256)),
    ] {
    for form in [@normalization.NFD, @normalization.NFKD] {
      b.bench(name="\{form}/\{name}", fn() {
        b.keep(@normalization.normalize(input, form))
      })
    }
  }
}
