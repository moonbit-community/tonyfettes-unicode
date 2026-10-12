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
/// Print one result row: `library<TAB>case<TAB>ns<TAB>units<TAB>check`.
///
/// Every harness in `bench/xlang` follows the same protocol: double the
/// iteration count until one sample takes at least 10 ms, then report the
/// fastest of 12 samples. `units` is the number of code points processed per
/// call (1 for per-call cases) and `check` is a value every implementation
/// must agree on. The library column is empty: this harness has one library.
fn measure(
  name : String,
  units : Int32,
  check : Int32,
  f : () -> Int32,
) -> Unit {
  let mut iterations = 1
  while run(iterations, f).0 < 10000.0 {
    iterations = iterations * 2
  }
  let mut best = run(iterations, f).0
  for _ in 1..<12 {
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
        () => @normalization.normalize(original, form).length(),
      )
    }
    measure(
      "norm/nfd>nfc/\{name}",
      decomposed.char_length(),
      @normalization.normalize(decomposed, NFC).char_length(),
      () => @normalization.normalize(decomposed, NFC).length(),
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
    let count = () => {
      let cursor = @segmentation.graphemes(text)
      let mut clusters = 0
      while cursor.next().length() > 0 {
        clusters += 1
      }
      clusters
    }
    measure("seg/graphemes/\{name}", text.char_length(), count(), count)
  }
}

///|
fn bench_bidi(inputs : String) -> Unit raise {
  for name in names("\{inputs}/bidi") {
    let text = read("\{inputs}/bidi/\{name}.txt")
    let mut level_sum = 0
    for level in @bidi.process(text).levels {
      level_sum += level
    }
    measure("bidi/process/\{name}", text.char_length(), level_sum, () => {
      @bidi.process(text).levels.length()
    })
  }
}

///|
fn bench_idna(inputs : String) -> Unit raise {
  for (name, domain) in pairs("\{inputs}/idna.tsv") {
    // Every input converts successfully without STD3 rules, so the closures
    // time successful conversions only.
    let ascii = @idna.to_ascii(domain, use_std3_ascii_rules=false)
    let unicode = @idna.to_unicode(domain, use_std3_ascii_rules=false)
    measure("idna/to_ascii/\{name}", 1, ascii.char_length(), () => {
      (@idna.to_ascii(domain, use_std3_ascii_rules=false) catch { _ => domain }).length()
    })
    measure("idna/to_unicode/\{name}", 1, unicode.char_length(), () => {
      (@idna.to_unicode(domain, use_std3_ascii_rules=false) catch {
        _ => domain
      }).length()
    })
  }
}

///|
fn bench_punycode(inputs : String) -> Unit raise {
  for (name, input) in pairs("\{inputs}/puny.tsv") {
    let encoded = @punycode.encode(input)
    measure("puny/encode/\{name}", 1, encoded.length(), () => {
      (@punycode.encode(input) catch { _ => input }).length()
    })
    measure("puny/decode/\{name}", 1, input.char_length(), () => {
      (@punycode.decode(encoded) catch { _ => encoded }).length()
    })
  }
}

///|
fn bench_properties(inputs : String) -> Unit raise {
  for name in names("\{inputs}/case") {
    let text = read("\{inputs}/case/\{name}.txt")
    let units = text.char_length()
    let simple_upper = () => {
      let mut sum = 0
      for c in text {
        sum = sum ^ @ucd.to_simple_uppercase(c).to_int()
      }
      sum
    }
    let full_upper = () => {
      let mut length = 0
      for c in text {
        length += @ucd.to_uppercase(c).char_length()
      }
      length
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
    measure("case/simple_upper/\{name}", units, simple_upper(), simple_upper)
    measure("case/full_upper/\{name}", units, full_upper(), full_upper)
    measure(
      "prop/general_category_Ll/\{name}",
      units,
      lowercase_letters(),
      lowercase_letters,
    )
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
