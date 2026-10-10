///|
priv struct CorpusFile {
  name : String
  bytes : Int
  sha256 : String
  encoding : String
} derive(@json.FromJson)

///|
priv struct Corpus {
  files : Array[CorpusFile]
} derive(@json.FromJson)

///|
priv struct Fixture {
  name : String
  original : String
  nfc : String
  nfd : String
}

///|
fn corpus_directory() -> String raise {
  for path in [".", "normperf", "benchmarks/normperf"] {
    if @fs.path_exists("\{path}/corpus.json") {
      return path
    }
  }
  fail("Cannot find corpus.json; run moon -C benchmarks/normperf bench")
}

///|
/// Read and validate original bytes before decoding; preserve all line endings.
/// NFC/NFD variants are benchmark inputs, not independent correctness oracles.
fn fixtures() -> Array[Fixture] raise {
  let directory = corpus_directory()
  let corpus : Corpus = @json.from_json(
    @json.parse(@fs.read_file_to_string("\{directory}/corpus.json")),
  )
  corpus.files.map(file => {
    let raw = @fs.read_file_to_bytes("\{directory}/data/\{file.name}.txt")
    guard raw.length() == file.bytes &&
      @crypto.bytes_to_hex_string(@crypto.sha256(raw)) == file.sha256 else {
      fail("Corpus checksum mismatch: \{file.name}")
    }
    guard file.encoding == "utf-8-sig" else {
      fail("Unsupported corpus encoding: \{file.encoding}")
    }
    let original = @utf8.decode(raw, ignore_bom=true)
    {
      name: file.name,
      original,
      nfc: @normalization.normalize(original, NFC),
      nfd: @normalization.normalize(original, NFD),
    }
  })
}

///|
/// Exercise file IO and the complete input matrix without running timers.
test "corpus integrity and normalization consistency" {
  let inputs = fixtures()
  inspect(inputs.length(), content="14")
  for fixture in inputs {
    for input in [fixture.original, fixture.nfc, fixture.nfd] {
      assert_eq(@normalization.normalize(input, NFC), fixture.nfc)
      assert_eq(@normalization.normalize(input, NFD), fixture.nfd)
      assert_eq(@normalization.is_normalized(input, NFC), input == fixture.nfc)
      assert_eq(@normalization.is_normalized(input, NFD), input == fixture.nfd)
    }
  }
}
