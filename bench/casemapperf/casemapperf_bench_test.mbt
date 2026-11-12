///|
/// Corpora of `bench/normperf` used here: English prose and personal names in
/// Latin, Cyrillic and Han script.
let corpora : Array[String] = [
  "vfear11a", "TestNames_Latin", "TestNames_Russian", "TestNames_Chinese",
]

///|
fn data_directory() -> String raise {
  for path in ["../normperf/data", "normperf/data", "bench/normperf/data"] {
    if @fs.path_exists("\{path}/vfear11a.txt") {
      return path
    }
  }
  fail("Cannot find the normperf corpora; run moon bench ./bench/casemapperf")
}

///|
/// Uppercase `text` one character at a time, as callers had to before the
/// string-level functions.
fn uppercase_by_char(text : String) -> String {
  let out = StringBuilder(size_hint=text.length())
  for c in text {
    out.write_string(@ucd.to_uppercase(c))
  }
  out.to_string()
}

///|
// Keep the matrix in one block so bare moon bench runs every case sequentially.
test "case mapping matrix" (b : @bench.T) {
  let directory = data_directory()
  let inputs = [
    ("ASCII", "Hello world, this is a Test. ".repeat(32)),
    ("Latin", "Ünïcödé Çàfé Straße ".repeat(32)),
    ("Greek", "Ὀδυσσεύς καὶ ᾈχιλλεύς ".repeat(32)),
    ("CJK", "世界こんにちは、テスト。".repeat(64)),
  ]
  for name in corpora {
    let raw = @fs.read_file_to_bytes("\{directory}/\{name}.txt")
    inputs.push((name, @utf8.decode(raw, ignore_bom=true)))
  }
  for item in inputs {
    let (name, text) = item
    let upper = @ucd.uppercase(text)
    assert_true(upper == uppercase_by_char(text))
    b.bench(name="\{name}/uppercase", () => b.keep(@ucd.uppercase(text)))
    b.bench(name="\{name}/uppercase/upper", () => b.keep(@ucd.uppercase(upper)))
    b.bench(name="\{name}/lowercase", () => b.keep(@ucd.lowercase(text)))
    b.bench(name="\{name}/uppercase_by_char", () => {
      b.keep(uppercase_by_char(text))
    })
  }
}
