///|
priv struct CorpusFile {
  name : String
  url : String
  bytes : Int
  sha256 : String
} derive(@json.FromJson)

///|
priv struct Corpus {
  revision : String
  files : Array[CorpusFile]
} derive(@json.FromJson)

///|
priv struct Input {
  name : String
  state : String
  utf16_units : Int
  codepoints : Int
  sha256 : String
  is_nfc : Bool
  is_nfd : Bool
} derive(ToJson, @json.FromJson)

///|
async fn mkdir(path : String) -> Unit {
  @fs.mkdir(path, recursive=true) catch {
    @os_error.OSError(_) as error if error.is_EEXIST() => ()
    error => raise error
  }
}

///|
async fn write(path : String, text : String) -> Unit {
  @fs.write_file(path, text, create_mode=CreateOrTruncate)
}

///|
async fn capture(
  command : String,
  args : Array[String],
  cwd~ : String,
  extra_env? : Map[String, String] = Map([]),
) -> String {
  let (status, out, err) = @process.collect_output(
    command,
    args,
    cwd~,
    extra_env~,
  )
  guard status == 0 else {
    fail("\{command} failed (\{status}): \{err.text()}")
  }
  out.text().trim().to_owned()
}

///|
fn digest(bytes : Bytes) -> String {
  @crypto.bytes_to_hex_string(@crypto.sha256(bytes))
}

///|
fn decode_corpus(raw : Bytes) -> String raise {
  match raw[:] {
    [0xff, 0xfe, .. rest] => @utf16.decode(rest, endianness=Little)
    [0xfe, 0xff, .. rest] => @utf16.decode(rest, endianness=Big)
    _ => @utf8.decode(raw, ignore_bom=true)
  }
}

///|
/// Chunk by Unicode scalar, not UTF-16 offset: never split a surrogate pair.
fn literals(text : String) -> String {
  let chunks : Array[String] = []
  let mut chunk = StringBuilder()
  let mut count = 0
  chunk.write_char('"')
  for c in text.iter() {
    if count == 4096 {
      chunk.write_char('"')
      chunks.push(chunk.to_string())
      chunk = StringBuilder()
      chunk.write_char('"')
      count = 0
    }
    match c {
      '"' | '\\' => {
        chunk.write_char('\\')
        chunk.write_char(c)
      }
      _ if c.to_int() < 32 || c == '\u{2028}' || c == '\u{2029}' =>
        chunk.write_string("\\u{\{c.to_int().to_string(radix=16)}}")
      _ => chunk.write_char(c)
    }
    count += 1
  }
  chunk.write_char('"')
  chunks.push(chunk.to_string())
  chunks.join(",\n")
}

///|
async fn prepare(root : String, prefix : String) -> (String, Json) {
  let here = "\{root}/benchmarks/normperf"
  let work = "\{here}/.work"
  let runner = "\{work}/runner"
  let fixtures = "\{work}/fixtures"
  mkdir(runner)
  mkdir(fixtures)
  mkdir("\{here}/.cache")
  let corpus : Corpus = @json.from_json(
    @fs.read_file("\{here}/corpus.json").json(),
  )
  let names = corpus.files.map(f => f.name)
  write("\{fixtures}/names.txt", names.join("\n") + "\n")
  for file in corpus.files {
    let path = "\{here}/.cache/\{file.name}.txt"
    if !@fs.exists(path) {
      let raw = @async.with_timeout(60000, async fn() {
        // Hash the original file bytes; no HTTP content decoding is needed.
        let (response, body) = @http.get(file.url, headers={
          "Accept-Encoding": "identity",
        })
        guard response.code == 200 else {
          fail("Download \{file.url}: HTTP \{response.code}")
        }
        body.binary()
      })
      guard raw.length() == file.bytes && digest(raw) == file.sha256 else {
        fail("Checksum mismatch: \{path}")
      }
      @fs.write_file(path, raw, create_mode=CreateNew)
    }
    let raw = @fs.read_file(path).binary()
    guard raw.length() == file.bytes && digest(raw) == file.sha256 else {
      fail("Checksum mismatch: \{path}")
    }
    @fs.write_file(
      "\{fixtures}/\{file.name}.orig.bin",
      @utf16.encode(decode_corpus(raw), endianness=Little),
      create_mode=CreateOrTruncate,
    )
  }
  let extra_env = {
    "PKG_CONFIG_PATH": "\{prefix}/lib/pkgconfig:" +
    @env.get_env_var("PKG_CONFIG_PATH").unwrap_or(""),
  }
  // Query directories individually so paths containing spaces remain single argv entries.
  let include_dir = capture(
    "pkg-config",
    ["--variable=includedir", "icu-uc"],
    cwd=root,
    extra_env~,
  )
  let lib_dir = capture(
    "pkg-config",
    ["--variable=libdir", "icu-uc"],
    cwd=root,
    extra_env~,
  )
  ignore(
    capture(
      "c++",
      [
        "-std=c++17",
        "-O3",
        "\{here}/icu.cpp",
        "-I\{include_dir}",
        "-L\{lib_dir}",
        "-Wl,-rpath,\{lib_dir}",
        "-licuuc",
        "-licudata",
        "-o",
        "\{work}/icu",
      ],
      cwd=root,
    ),
  )
  let versions = @json.parse(
    capture("\{work}/icu", ["prepare", fixtures], cwd=root),
  )
  guard versions
    is { "icu": String(icu_version), "unicode": String(unicode_version), .. } else {
    fail("Invalid ICU version response")
  }
  write(
    "\{work}/moon.work",
    "members = " +
    ["\{root}/ucd", "\{root}/normalization", runner].to_json().stringify() +
    "\n",
  )
  write(
    "\{runner}/moon.mod",
    "name = \"local/normperf\"\nversion = \"0.0.0\"\nimport { \"moonbit-community/normalization@0.5.2\", }\n",
  )
  write(
    "\{runner}/moon.pkg",
    "import { \"moonbit-community/normalization\", \"moonbitlang/core/bench\", }\noptions(\"is-main\": true)\n",
  )
  write("\{runner}/main.mbt", @fs.read_file("\{here}/moon_main.mbt.in").text())
  let metadata : Array[Input] = []
  let rows : Array[String] = []
  for index, name in names {
    let variants : Map[String, String] = Map([])
    for state in ["orig", "nfc", "nfd"] {
      variants[state] = @utf16.decode(
        @fs.read_file("\{fixtures}/\{name}.\{state}.bin").binary(),
        endianness=Little,
      )
    }
    let unique : Map[String, String] = Map([])
    let references : Map[String, String] = Map([])
    let declarations : Array[String] = []
    for state in ["orig", "nfc", "nfd"] {
      let text = variants.get(state).unwrap()
      let variable = match unique.get(text) {
        Some(v) => v
        None => {
          let v = "fixture_\{index}_\{state}"
          declarations.push(
            "///|\nlet \{v} : String = [\n\{literals(text)}\n].join(\"\")\n",
          )
          unique[text] = v
          v
        }
      }
      references[state] = variable
      let raw = @utf16.encode(text, endianness=Little)
      metadata.push({
        name,
        state,
        utf16_units: raw.length() / 2,
        codepoints: text.iter().count(),
        sha256: digest(raw),
        is_nfc: text == variants.get("nfc").unwrap(),
        is_nfd: text == variants.get("nfd").unwrap(),
      })
    }
    write("\{runner}/fixture_\{index}.mbt", declarations.join("\n"))
    rows.push(
      "{ name: \{literals(name)}, original: \{references.get("orig").unwrap()}, nfc: \{references.get("nfc").unwrap()}, nfd: \{references.get("nfd").unwrap()} }",
    )
  }
  write(
    "\{runner}/fixtures.mbt",
    "///|\nfn fixtures() -> Array[Fixture] {\n[" + rows.join(",\n") + "]\n}\n",
  )
  write("\{work}/inputs.json", metadata.to_json().stringify(indent=2) + "\n")
  let environment : Json = {
    "icu": icu_version,
    "unicode": unicode_version,
    "corpus_revision": corpus.revision,
    "source_revision": capture("git", ["rev-parse", "HEAD"], cwd=root),
    "moon": capture("moon", ["version"], cwd=root),
    "machine": capture("uname", ["-srm"], cwd=root),
    "compiler": capture("c++", ["--version"], cwd=root).split("\n").to_array()[0],
  }
  (work, environment)
}

///|
/// Prepare full ICU corpora, then run all selected engines sequentially.
/// Output must be empty, except when only preparing fixtures.
pub async fn run(
  root~ : String,
  icu_prefix~ : String,
  output~ : String,
  targets~ : Array[String],
  repeats~ : Int,
  prepare_only? : Bool = false,
) -> Unit {
  guard repeats > 0 else { fail("--repeats must be positive") }
  guard !targets.is_empty() else { fail("Select at least one target") }
  let seen : Map[String, Bool] = Map([])
  for target in targets {
    guard ["native", "wasm", "wasm-gc"].contains(target) &&
      !seen.contains(target) else {
      fail("Invalid or duplicate target: \{target}")
    }
    seen[target] = true
  }
  if !prepare_only &&
    @fs.exists(output) &&
    !@fs.readdir(output, include_hidden=true).is_empty() {
    fail(
      "Results directory is not empty: \{output}; choose a new --output directory",
    )
  }
  let root = @fs.realpath(root)
  let (work, environment) = prepare(root, icu_prefix)
  if prepare_only {
    println("Prepared corpora in \{work}")
    return
  }
  mkdir(output)
  let environment = match environment {
    Object(fields) => {
      fields["repeats"] = repeats.to_json()
      fields["samples_per_case"] = 5
      fields["sample_target_us"] = 20000
      fields["calibration_min_us"] = 10000
      fields.to_json()
    }
    _ => fail("Invalid environment metadata")
  }
  write("\{output}/environment.json", environment.stringify(indent=2) + "\n")
  write("\{output}/inputs.json", @fs.read_file("\{work}/inputs.json").text())
  for target in targets {
    let status = @process.run(
      "moon",
      ["-C", work, "build", "runner", "--target", target, "--release"],
      cwd=root,
    )
    guard status == 0 else { fail("Build failed: \{target}") }
  }
  let engines = ["icu"] + targets
  for index in 0..<repeats {
    for offset in 0..<engines.length() {
      let engine = engines[(index + offset) % engines.length()]
      let path = "\{output}/\{engine}-\{index + 1}.jsonl"
      println("Running \{engine} \{index + 1}/\{repeats}")
      let out = @process.redirect_to_file(path, create_mode=CreateNew)
      let status = if engine == "icu" {
        @process.run("\{work}/icu", ["\{work}/fixtures"], cwd=root, stdout=out)
      } else {
        @process.run(
          "moon",
          ["-C", work, "run", "runner", "--target", engine, "--release"],
          cwd=root,
          stdout=out,
        )
      }
      guard status == 0 else { fail("Benchmark failed: \{engine}") }
      let records = read_samples(path)
      let inputs : Array[Input] = @json.from_json(
        @fs.read_file("\{work}/inputs.json").json(),
      )
      validate_cases(records, inputs, engine)
      println("Completed \{engine}: \{records.length()} cases")
    }
  }
  println("Raw measurements saved in \{output}")
}
