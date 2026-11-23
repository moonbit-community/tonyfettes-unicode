///|
fn read(path : String) -> String raise {
  @utf8.decode(@fs.read_file_to_bytes(path))
}

///|
/// Input names in `directory`: the `.txt` files without their extension.
fn names(directory : String) -> Array[String] raise {
  let result = []
  for file in @fs.read_dir(directory) {
    if file.strip_suffix(".txt") is Some(name) {
      result.push(name.to_owned())
    }
  }
  result.sort()
  result
}

///|
/// The `name<TAB>value` lines of a `.tsv` input.
fn pairs(path : String) -> Array[(String, String)] raise {
  let result = []
  for line in read(path).split("\n") {
    if line.split_once("\t") is Some((name, value)) {
      result.push((name.to_owned(), value.to_owned()))
    }
  }
  result
}

///|
/// Elapsed microseconds for `iterations` calls. The results are folded into
/// the returned sink so that the calls cannot be optimized away.
fn run(iterations : Int32, f : () -> Int32) -> (Double, Int32) {
  let mut sink = 0
  let start = @bench.monotonic_clock_start()
  for _ in 0..<iterations {
    sink = sink ^ f()
  }
  (@bench.monotonic_clock_end(start), sink)
}

///|
/// The latest string a case built. Every result is stored here, where it can
/// be read later, so that the optimizer cannot drop the work that builds it:
/// V8 drops a string that only has its length read, as it can compute the
/// length without the string.
let kept_string : Ref[String] = Ref("")

///|
/// Keep `result` and return its length.
fn keep_string(result : String) -> Int32 {
  kept_string.val = result
  result.length()
}

///|
/// The latest bidi levels a case built, kept as `kept_string` keeps strings.
let kept_levels : Ref[Array[Int32]] = Ref([])

///|
/// Keep `levels` and return their number.
fn keep_levels(levels : Array[Int32]) -> Int32 {
  kept_levels.val = levels
  levels.length()
}

///|
/// Print one result row: `library<TAB>case<TAB>ns<TAB>units<TAB>check`.
///
/// Every harness in `bench/xlang` follows the same protocol: double the
/// iteration count until one sample takes at least 5 ms, then report the
/// fastest of 5 samples, the first of which is that one. `units` is the
/// number of code points processed per call (1 for per-call cases) and
/// `check` is a value every implementation must agree on. The library column
/// is empty: this harness has one library.
fn measure(
  name : String,
  units : Int32,
  check : Int32,
  f : () -> Int32,
) -> Unit {
  let mut iterations = 1
  let mut best = run(iterations, f).0
  while best < 5000.0 {
    iterations = iterations * 2
    best = run(iterations, f).0
  }
  for _ in 1..<5 {
    let elapsed = run(iterations, f).0
    if elapsed < best {
      best = elapsed
    }
  }
  let ns = best * 1000.0 / iterations.to_double()
  println("\t\{name}\t\{ns}\t\{units}\t\{check}")
}

///|
fn bench_normalization(inputs : String) -> Unit raise {
  for name in names("\{inputs}/norm") {
    let original = read("\{inputs}/norm/\{name}.txt")
    let decomposed = read("\{inputs}/normd/\{name}.txt")
    let units = original.char_length()
    for
      (label, form) in [
        ("nfc", @normalization.NFC),
        ("nfd", @normalization.NFD),
        ("nfkc", @normalization.NFKC),
        ("nfkd", @normalization.NFKD),
      ] {
      measure(
        "norm/\{label}/\{name}",
        units,
        @normalization.normalize(original, form).char_length(),
        () => keep_string(@normalization.normalize(original, form)),
      )
    }
    measure(
      "norm/nfd>nfc/\{name}",
      decomposed.char_length(),
      @normalization.normalize(decomposed, NFC).char_length(),
      () => keep_string(@normalization.normalize(decomposed, NFC)),
    )
    let is_nfc = () => {
      if @normalization.is_normalized(original, NFC) {
        1
      } else {
        0
      }
    }
    measure("norm/is_nfc/\{name}", units, is_nfc(), is_nfc)
  }
}

///|
fn bench_segmentation(inputs : String) -> Unit raise {
  for name in names("\{inputs}/seg") {
    let text = read("\{inputs}/seg/\{name}.txt")
    let units = text.char_length()
    let count_graphemes = () => {
      let cursor = @segmentation.graphemes(text)
      let mut clusters = 0
      while cursor.next().length() > 0 {
        clusters += 1
      }
      clusters
    }
    let count_word_segments = () => {
      let cursor = @segmentation.word_segments(text)
      let mut segments = 0
      while cursor.next().length() > 0 {
        segments += 1
      }
      segments
    }
    let count_words = () => {
      let cursor = @segmentation.words(text)
      let mut segments = 0
      while cursor.next().length() > 0 {
        segments += 1
      }
      segments
    }
    let count_sentences = () => {
      let cursor = @segmentation.sentences(text)
      let mut segments = 0
      while cursor.next().length() > 0 {
        segments += 1
      }
      segments
    }
    let count_line_breaks = () => {
      let cursor = @segmentation.line_breaks(text)
      let mut segments = 0
      while cursor.next().length() > 0 {
        segments += 1
      }
      segments
    }
    measure("seg/graphemes/\{name}", units, count_graphemes(), count_graphemes)
    measure(
      "seg/word_segments/\{name}",
      units,
      count_word_segments(),
      count_word_segments,
    )
    measure("seg/words/\{name}", units, count_words(), count_words)
    measure("seg/sentences/\{name}", units, count_sentences(), count_sentences)
    measure(
      "seg/line_breaks/\{name}",
      units,
      count_line_breaks(),
      count_line_breaks,
    )
  }
}

///|
fn bench_bidi(inputs : String) -> Unit raise {
  for name in names("\{inputs}/bidi") {
    let text = read("\{inputs}/bidi/\{name}.txt")
    let units = text.char_length()
    let para = @bidi.process(text)
    let mut level_sum = 0
    for level in para.levels {
      level_sum += level
    }
    measure("bidi/process/\{name}", units, level_sum, () => {
      keep_levels(@bidi.process(text).levels)
    })
    let reordered = @bidi.reorder_string(para)
    measure("bidi/reorder/\{name}", units, reordered.char_length(), () => {
      keep_string(@bidi.reorder_string(para))
    })
    let requires_bidi = () => if @bidi.requires_bidi(text) { 1 } else { 0 }
    measure("bidi/requires_bidi/\{name}", units, requires_bidi(), requires_bidi)
  }
}

///|
fn bench_idna(inputs : String) -> Unit raise {
  for (name, domain) in pairs("\{inputs}/idna.tsv") {
    // Every input converts successfully without STD3 rules, so the closures
    // time successful conversions only.
    let ascii = @idna.to_ascii(domain, use_std3_ascii_rules=false)
    let ascii_2008 = @idna.to_ascii(
      domain,
      use_std3_ascii_rules=false,
      check_idna2008=true,
      check_contexto=true,
    )
    let unicode = @idna.to_unicode(domain, use_std3_ascii_rules=false)
    measure("idna/to_ascii/\{name}", 1, ascii.char_length(), () => {
      keep_string(
        @idna.to_ascii(domain, use_std3_ascii_rules=false) catch {
          _ => domain
        },
      )
    })
    measure("idna/to_ascii_2008/\{name}", 1, ascii_2008.char_length(), () => {
      keep_string(
        @idna.to_ascii(
          domain,
          use_std3_ascii_rules=false,
          check_idna2008=true,
          check_contexto=true,
        ) catch {
          _ => domain
        },
      )
    })
    measure("idna/to_unicode/\{name}", 1, unicode.char_length(), () => {
      keep_string(
        @idna.to_unicode(domain, use_std3_ascii_rules=false) catch {
          _ => domain
        },
      )
    })
  }
}

///|
fn bench_punycode(inputs : String) -> Unit raise {
  for (name, input) in pairs("\{inputs}/puny.tsv") {
    let encoded = @punycode.encode(input)
    measure("puny/encode/\{name}", 1, encoded.length(), () => {
      keep_string(@punycode.encode(input) catch { _ => input })
    })
    measure("puny/decode/\{name}", 1, input.char_length(), () => {
      keep_string(@punycode.decode(encoded) catch { _ => encoded })
    })
  }
}

///|
fn bench_properties(inputs : String) -> Unit raise {
  for name in names("\{inputs}/case") {
    let text = read("\{inputs}/case/\{name}.txt")
    let units = text.char_length()
    let folded = @casefold.case_fold(text)
    let simple_upper = () => {
      let mut sum = 0
      for c in text {
        sum = sum ^ @ucd.to_simple_uppercase(c).to_int()
      }
      sum
    }
    let caseless_match = () => {
      if @casefold.caseless_match(text, folded) {
        1
      } else {
        0
      }
    }
    let lowercase_letters = () => {
      let mut count = 0
      for c in text {
        if @ucd.general_category(c) is Ll {
          count += 1
        }
      }
      count
    }
    let alphabetic = () => {
      let mut count = 0
      for c in text {
        if @ucd.is_alphabetic(c) {
          count += 1
        }
      }
      count
    }
    let line_break_al = () => {
      let mut count = 0
      for c in text {
        if @ucd.line_break(c) is AL {
          count += 1
        }
      }
      count
    }
    measure("case/simple_upper/\{name}", units, simple_upper(), simple_upper)
    measure(
      "case/full_upper/\{name}",
      units,
      @ucd.uppercase(text).char_length(),
      () => keep_string(@ucd.uppercase(text)),
    )
    measure(
      "case/full_lower/\{name}",
      units,
      @ucd.lowercase(text).char_length(),
      () => keep_string(@ucd.lowercase(text)),
    )
    for
      (label, fold) in [
        ("fold", @casefold.case_fold),
        ("canonical_fold", @casefold.canonical_case_fold),
        ("nfkc_casefold", @casefold.nfkc_casefold),
      ] {
      measure("case/\{label}/\{name}", units, fold(text).char_length(), () => {
        keep_string(fold(text))
      })
    }
    measure(
      "case/caseless_match/\{name}",
      units,
      caseless_match(),
      caseless_match,
    )
    measure(
      "prop/general_category_Ll/\{name}",
      units,
      lowercase_letters(),
      lowercase_letters,
    )
    measure("prop/alphabetic/\{name}", units, alphabetic(), alphabetic)
    measure("prop/line_break_AL/\{name}", units, line_break_al(), line_break_al)
  }
}

///|
fn main raise {
  let command = @argparse.Command(
    "xlang-moonbit",
    about="Time this repository's Unicode modules on the shared xlang inputs",
    positionals=[
      @argparse.PositionArg("inputs", about="Directory of prepared inputs"),
      @argparse.PositionArg(
        "group",
        about="Only run this group: norm, seg, bidi, idna, puny or case",
        num_args=@argparse.ValueRange(lower=0, upper=1),
      ),
    ],
  )
  let matches = command.parse()
  guard matches.values.get("inputs") is Some([inputs, ..]) else {
    fail(command.render_help())
  }
  let group = matches.values.get("group").map(values => values[0])
  let groups : Array[(String, (String) -> Unit raise)] = [
    ("norm", bench_normalization),
    ("seg", bench_segmentation),
    ("bidi", bench_bidi),
    ("idna", bench_idna),
    ("puny", bench_punycode),
    ("case", bench_properties),
  ]
  for (name, bench) in groups {
    if group is Some(selected) && selected != name {
      continue
    }
    bench(inputs)
  }
}
