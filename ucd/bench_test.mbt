///|
/// Micro-benchmarks for ucd case-mapping hot paths (A2 optimization targets).
/// to_*case allocates per character; full mappings additionally copy the
/// static table slice into a fresh Array[Char] on every call.

///|
fn repeat_str(s : String, n : Int) -> String {
  let sb = StringBuilder()
  for _ in 0..<n {
    sb.write_string(s)
  }
  sb.to_string()
}

///|
fn lower_all(s : String) -> String {
  let sb = StringBuilder()
  for c in s {
    sb.write_string(to_lowercase(c))
  }
  sb.to_string()
}

///|
fn upper_all(s : String) -> String {
  let sb = StringBuilder()
  for c in s {
    sb.write_string(to_uppercase(c))
  }
  sb.to_string()
}

///|
let upper_ascii : String = repeat_str(
  "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG. ", 40,
)

///|
let sharp_s : String = repeat_str("ß", 256) // full uppercase mapping -> "SS"

///|
let dotted_i : String = repeat_str("İ", 256) // full lowercase mapping -> "i\u{0307}"

///|
test (b : @bench.T) {
  b.bench(name="lower/ascii-no-mapping", fn() { b.keep(lower_all(upper_ascii)) })
  b.bench(name="upper/full-mapping-ß", fn() { b.keep(upper_all(sharp_s)) })
  b.bench(name="lower/full-mapping-İ", fn() { b.keep(lower_all(dotted_i)) })
}
