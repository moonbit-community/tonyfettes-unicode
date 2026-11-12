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
  fail("Cannot find the normperf corpora; run moon bench ./bench/casefoldperf")
}

///|
fn uppercase(text : String) -> String {
  let out = StringBuilder(size_hint=text.length())
  for c in text {
    out.write_string(@ucd.to_uppercase(c))
  }
  out.to_string()
}

///|
// Keep the matrix in one block so bare moon bench runs every case sequentially.
test "case folding corpus matrix" (b : @bench.T) {
  let directory = data_directory()
  for name in corpora {
    let raw = @fs.read_file_to_bytes("\{directory}/\{name}.txt")
    let text = @utf8.decode(raw, ignore_bom=true)
    let upper = uppercase(text)
    let folded = @casefold.case_fold(text)
    assert_true(@casefold.caseless_match(text, upper))
    assert_true(@casefold.caseless_match(folded, text))
    b.bench(name="\{name}/case_fold", () => b.keep(@casefold.case_fold(text)))
    b.bench(name="\{name}/case_fold/folded", () => {
      b.keep(@casefold.case_fold(folded))
    })
    b.bench(name="\{name}/nfkc_casefold", () => {
      b.keep(@casefold.nfkc_casefold(text))
    })
    b.bench(name="\{name}/caseless_match/same", () => {
      b.keep(@casefold.caseless_match(text, text))
    })
    b.bench(name="\{name}/caseless_match/upper", () => {
      b.keep(@casefold.caseless_match(text, upper))
    })
  }
}
