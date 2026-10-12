///|
/// Write `text` as UTF-8, without a BOM and without touching line endings.
async fn write_text(path : String, text : String) -> Unit {
  @fs.write_file(
    path,
    @utf8.encode(text),
    create_mode=CreateOrTruncate,
    permission=0o644,
  )
}

///|
/// Write the inputs every harness reads into `directory`:
///
/// - `norm/<corpus>.txt`: the ICU normperf corpora of `bench/normperf`, without
///   their BOM, and `normd/<corpus>.txt`: the same text in NFD
/// - `seg/`, `bidi/`, `case/`: one text per file
/// - `idna.tsv`, `puny.tsv`: `name<TAB>value` lines
///
/// The harnesses list these directories, so the inputs are defined only here.
async fn prepare_inputs(root : String, directory : String) -> Unit {
  if @fs.exists(directory) {
    @fs.rmdir(directory, recursive=true)
  }
  for group in ["norm", "normd", "seg", "bidi", "case"] {
    @fs.mkdir("\{directory}/\{group}", permission=0o755, recursive=true)
  }
  let corpora : Map[String, String] = Map([])
  let data = "\{root}/bench/normperf/data"
  for file in @fs.readdir(data, sort=true) {
    guard file.strip_suffix(".txt") is Some(name) else { continue }
    let text = @utf8.decode(
      @fs.read_file("\{data}/\{file}").binary(),
      ignore_bom=true,
    )
    corpora[name.to_owned()] = text
    write_text("\{directory}/norm/\{file}", text)
    write_text(
      "\{directory}/normd/\{file}",
      @normalization.normalize(text, NFD),
    )
  }
  let corpus = (name : String) => {
    guard corpora.get(name) is Some(text) else {
      fail("Missing corpus \{name} in \{data}")
    }
    text
  }
  let texts : Array[(String, String)] = [
    ("seg/Latin", corpus("TestNames_Latin")),
    ("seg/Russian", corpus("TestNames_Russian")),
    ("seg/Chinese", corpus("TestNames_Chinese")),
    ("seg/Korean", corpus("TestNames_Korean")),
    (
      "seg/KoreanJamo",
      @normalization.normalize(corpus("TestNames_Korean"), NFD),
    ),
    ("seg/Thai", corpus("TestNames_Thai")),
    ("seg/English", corpus("vfear11a")),
    (
      "seg/emoji",
      "👨‍👩‍👧‍👦 🇯🇵🇺🇸 👍🏽 🏳️‍🌈 ❤️ 😀 text 🧑🏿‍🚀 ".repeat(
        400,
      ),
    ),
    (
      "seg/Hindi",
      "हिन्दी भाषा में क्षत्रिय और विद्यार्थी शब्द संयुक्ताक्षर के उदाहरण हैं। ".repeat(
        300,
      ),
    ),
    (
      "bidi/ASCII",
      "Hello world, this is a test (of brackets) 12345. ".repeat(32),
    ),
    ("bidi/Arabic", "مرحبا بالعالم (اختبار) 123 ".repeat(32)),
    (
      "bidi/mixed",
      "Hello مرحبا world بالعالم [test] 12,345.67 ".repeat(32),
    ),
    ("bidi/CJK", "世界こんにちは、テスト。".repeat(64)),
    ("bidi/supplementary", "𐤀𐤁𐤂 😀 𝒜𝒷 ".repeat(64)),
    (
      "bidi/explicit",
      "abc \u{2067}\u{05E9}\u{05DC}\u{05D5}\u{05DD} (x) 12\u{2069} def \u{202B}\u{05E2}\u{05D1}\u{05E8}\u{05D9}\u{05EA}\u{202C} ".repeat(
        32,
      ),
    ),
    ("bidi/brackets", "a (b [c {d} \u{05D0}] 1) \u{05D1} ".repeat(48)),
    ("case/ASCII", "Hello world, this is a Test. ".repeat(32)),
    ("case/Latin", "Ünïcödé Çàfé Straße ".repeat(32)),
    ("case/Greek", "Ὀδυσσεύς καὶ ᾈχιλλεύς ".repeat(32)),
    ("case/CJK", "世界こんにちは、テスト。".repeat(64)),
  ]
  for (name, text) in texts {
    write_text("\{directory}/\{name}.txt", text)
  }
  let tables : Array[(String, Array[(String, String)])] = [
    (
      "idna",
      [
        ("ASCII", "www.example.com"),
        ("longASCII", "the-quick-brown-fox.jumps-over-the-lazy-dog.example.org"),
        ("mixedcaseASCII", "WWW.Example.COM"),
        ("Latin", "bücher.münchen.example"),
        ("mixedcaseLatin", "Bücher.München.Example"),
        ("CJK", "例え.テスト.日本語"),
        ("Arabic", "مثال.إختبار"),
        ("Alabels", "xn--bcher-kva.xn--mnchen-3ya.example"),
      ],
    ),
    (
      "puny",
      [
        ("ASCII", "example"),
        ("Latin", "bücher"),
        ("Arabic", "مثال"),
        ("CJK", "日本語テスト例え"),
        ("supplementary", "😀😃😄𝒜"),
        (
          "long", "ünïcödé-ünïcödé-ünïcödé-ünïcödé-ünïcödé-ünïcödé",
        ),
      ],
    ),
  ]
  for (name, pairs) in tables {
    let lines = StringBuilder()
    for (key, value) in pairs {
      lines.write_string("\{key}\t\{value}\n")
    }
    write_text("\{directory}/\{name}.tsv", lines.to_string())
  }
}
