///|
/// Micro-benchmarks for the normalization hot paths (A1 optimization targets).
/// Baseline: every form decomposes -> orders -> composes -> re-serializes even
/// for already-normalized / pure-ASCII input.

///|
fn repeat_str(s : String, n : Int) -> String {
  let sb = StringBuilder()
  for _ in 0..<n {
    sb.write_string(s)
  }
  sb.to_string()
}

///|
let ascii_text : String = repeat_str(
  "The Quick Brown Fox 0123456789 jumps over the lazy dog. Pack my box. ", 40,
)

///|
let cjk_text : String = repeat_str(
  "中文规范文本测试，汉字不需要分解，也不参与组合，是已规范文本。",
  30,
)

///|
let latin_nfc_text : String = repeat_str(
  "Café déjà vu naïve résumé, Zürich façade œil cœur. ", 40,
)

///|
let compat_text : String = repeat_str(
  "ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ０１２３４５６７８９",
  20,
)

///|
test (b : @bench.T) {
  b.bench(name="nfc/ascii", fn() { b.keep(@normalization.nfc(ascii_text)) })
  b.bench(name="nfc/cjk-already-normal", fn() {
    b.keep(@normalization.nfc(cjk_text))
  })
  b.bench(name="nfc/latin-decompose-compose", fn() {
    b.keep(@normalization.nfc(latin_nfc_text))
  })
  b.bench(name="nfkc/compat-fullwidth", fn() {
    b.keep(@normalization.nfkc(compat_text))
  })
}

///|
test (b : @bench.T) {
  b.bench(name="is_normalized/ascii", fn() {
    b.keep(@normalization.is_normalized(ascii_text, NFC))
  })
  b.bench(name="is_normalized/cjk", fn() {
    b.keep(@normalization.is_normalized(cjk_text, NFC))
  })
}
