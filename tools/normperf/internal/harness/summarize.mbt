///|
priv struct Sample {
  name : String
  iterations : Int
  samples_us : Array[Double]
} derive(@json.FromJson)

///|
priv struct Environment {
  source_revision : String
  icu : String
  unicode : String
  repeats : Int
} derive(@json.FromJson)

///|
priv struct Timing {
  fastest : Double
  mean_median : Double
}

///|
priv struct Row {
  name : String
  state : String
  form : String
  operation : String
  normalized : Bool
  input : Input
  times : Map[String, Timing]
  reuse : Double?
}

///|
async fn read_samples(path : String) -> Map[String, Array[Double]] {
  let rows : Map[String, Array[Double]] = Map([])
  for line in @fs.read_file(path).text().split("\n") {
    if line.is_empty() {
      continue
    }
    let sample : Sample = @json.from_json(@json.parse(line))
    guard !rows.contains(sample.name) else {
      fail("Duplicate cases: \{path}: \{sample.name}")
    }
    guard sample.iterations > 0 &&
      sample.samples_us.length() == 5 &&
      sample.samples_us.all(x => x > 0.0 && !x.is_inf() && !x.is_nan()) else {
      fail("Invalid samples: \{path}: \{sample.name}")
    }
    rows[sample.name] = sample.samples_us
  }
  rows
}

///|
fn validate_cases(
  rows : Map[String, Array[Double]],
  inputs : Array[Input],
  engine : String,
) -> Unit raise {
  let operations = if engine == "icu" {
    ["normalize", "normalize_reuse", "check"]
  } else {
    ["normalize", "check"]
  }
  guard rows.length() == inputs.length() * 2 * operations.length() else {
    fail("Incomplete output: \{engine}")
  }
  for input in inputs {
    for form in ["NFC", "NFD"] {
      for operation in operations {
        let key = "\{input.name}/\{input.state}/\{form}/\{operation}"
        guard rows.contains(key) else {
          fail("Missing case: \{engine}: \{key}")
        }
      }
    }
  }
}

///|
fn fixed(value : Double) -> String {
  let hundredths = (value * 100.0).round().to_int64()
  let fraction = (hundredths % 100L).to_string()
  "\{hundredths / 100L}." +
  (if fraction.length() == 1 { "0" } else { "" }) +
  fraction
}

///|
fn csv_cell(value : String) -> String {
  "\"" + value.replace(old="\"", new="\"\"") + "\""
}

///|
/// Summarize complete independent runs, retaining fastest samples and process medians.
pub async fn summarize(directory : String) -> Unit {
  let environment : Environment = @json.from_json(
    @fs.read_file("\{directory}/environment.json").json(),
  )
  guard environment.repeats > 0 else { fail("Invalid repeat count") }
  let inputs : Array[Input] = @json.from_json(
    @fs.read_file("\{directory}/inputs.json").json(),
  )
  guard !inputs.is_empty() else { fail("Empty input metadata") }
  let metadata : Map[String, Input] = Map([])
  for input in inputs {
    let key = "\{input.name}/\{input.state}"
    guard !metadata.contains(key) else {
      fail("Duplicate input metadata: \{key}")
    }
    metadata[key] = input
  }
  let measurements : Map[String, Map[String, Timing]] = Map([])
  let engines : Array[String] = []
  for engine in ["icu", "native", "wasm", "wasm-gc"] {
    let runs : Array[Map[String, Array[Double]]] = []
    for index in 1..<=environment.repeats {
      let path = "\{directory}/\{engine}-\{index}.jsonl"
      if !@fs.exists(path) {
        if engine == "icu" || index > 1 {
          fail("Missing results: \{path}")
        }
        break
      }
      let rows = read_samples(path)
      validate_cases(rows, inputs, engine)
      runs.push(rows)
    }
    if runs.is_empty() {
      continue
    }
    let times : Map[String, Timing] = Map([])
    for key, samples in runs[0] {
      let mut fastest = samples[0]
      let mut median_sum = 0.0
      for run in runs {
        let values = run.get(key).unwrap().copy()
        values.sort()
        fastest = fastest.min(values[0])
        median_sum += values[2]
      }
      times[key] = {
        fastest,
        mean_median: median_sum / runs.length().to_double(),
      }
    }
    measurements[engine] = times
    if engine != "icu" {
      engines.push(engine)
    }
  }
  let icu = measurements.get("icu").unwrap()
  let keys = icu.keys().to_array()
  keys.sort_by((a, b) => a.lexical_compare(b))
  let rows : Array[Row] = []
  let header = [
    "corpus", "input", "form", "operation", "already_normalized", "utf16_units",
    "codepoints", "icu_us", "icu_mean_median_us", "icu_reuse_us",
  ]
  for engine in engines {
    header.append([
      engine + "_us",
      engine + "_mean_median_us",
      engine + "_over_icu",
    ])
  }
  let csv = [header.join(",")]
  for key in keys {
    guard key.split("/").to_array() is [name, state, form, operation] else {
      fail("Invalid case name: \{key}")
    }
    if operation == "normalize_reuse" {
      continue
    }
    let input = metadata.get("\{name}/\{state}").unwrap()
    let normalized = if form == "NFC" { input.is_nfc } else { input.is_nfd }
    let times : Map[String, Timing] = { "icu": icu.get(key).unwrap() }
    for engine in engines {
      times[engine] = measurements.get(engine).unwrap().get(key).unwrap()
    }
    let reuse = if operation == "normalize" {
      Some(icu.get("\{name}/\{state}/\{form}/normalize_reuse").unwrap().fastest)
    } else {
      None
    }
    let row : Row = {
      name: name.to_owned(),
      state: state.to_owned(),
      form: form.to_owned(),
      operation: operation.to_owned(),
      normalized,
      input,
      times,
      reuse,
    }
    rows.push(row)
    let icu_time = times.get("icu").unwrap()
    let fields = [
      row.name,
      row.state,
      row.form,
      row.operation,
      if normalized {
        "True"
      } else {
        "False"
      },
      input.utf16_units.to_string(),
      input.codepoints.to_string(),
      icu_time.fastest.to_string(),
      icu_time.mean_median.to_string(),
      reuse.map(x => x.to_string()).unwrap_or(""),
    ]
    for engine in engines {
      let time = times.get(engine).unwrap()
      fields.append([
        time.fastest.to_string(),
        time.mean_median.to_string(),
        (time.fastest / icu_time.fastest).to_string(),
      ])
    }
    csv.push(fields.map(csv_cell).join(","))
  }
  let lines = [
    "# ICU normperf corpus comparison",
    "",
    "Normalization source: `\{environment.source_revision}`. ICU \{environment.icu}, Unicode \{environment.unicode}.",
    "",
    "Full-file/bulk inputs; \{inputs.length() / 3} corpora × original/NFC/NFD input × NFC/NFD target × normalize/check.",
    "Times are microseconds per complete API call. Primary results use the fastest of \{environment.repeats * 5} samples across \{environment.repeats} processes, following the ICU perf fastest-pass convention. CSV also includes means of process medians.",
    "Inspect raw sample variation before interpreting small differences.",
    "Ratios > 1 mean MoonBit takes longer. Wasm and Wasm-GC columns compare against **native ICU**, so include backend/runtime differences.",
    "",
    "## Geometric mean of per-case time ratios",
    "",
    "| Operation | Input status | Cases | " + engines.join(" | ") + " |",
    "| --- | --- | ---: | " + engines.map(_ => "---:").join(" | ") + " |",
  ]
  // Preserve optional annotations on archived measurements.
  match @fs.read_file("\{directory}/environment.json").json() {
    { "load_note": String(note), .. } =>
      lines[6] = "**Measurement limitation:** " + note
    _ => ()
  }
  let groups : Array[Json] = []
  for operation in ["normalize", "check"] {
    for form in ["NFC", "NFD"] {
      for normalized in [true, false] {
        let subset = rows.filter(r => {
          r.operation == operation &&
          r.form == form &&
          r.normalized == normalized
        })
        if subset.is_empty() {
          continue
        }
        let values : Map[String, Double] = Map([])
        let cells : Array[String] = []
        for engine in engines {
          let sum = subset.fold(init=0.0, (sum, row) => {
            sum +
            @math.ln(
              row.times.get(engine).unwrap().fastest /
              row.times.get("icu").unwrap().fastest,
            )
          })
          let value = @math.exp(sum / subset.length().to_double())
          values[engine] = value
          cells.push(fixed(value) + "×")
        }
        let status = if normalized {
          "already normalized"
        } else if operation == "normalize" {
          "requires change"
        } else {
          "false / may exit early"
        }
        lines.push(
          "| \{operation} \{form} | \{status} | \{subset.length()} | " +
          cells.join(" | ") +
          " |",
        )
        groups.push({
          "operation": operation,
          "form": form,
          "already_normalized": normalized,
          "cases": subset.length(),
          "ratios": values.to_json(),
        })
      }
    }
  }
  lines.append([
    "",
    "Cases are equally weighted, including duplicate content across input states. These are corpus-specific aggregates, not universal speed factors.",
    "False checks may stop near the beginning; their whole-input size is **not** processed throughput. Their sub-microsecond ratios also include harness overhead.",
    "",
    "## NFC conversion from NFD input",
    "",
    "| Corpus | UTF-16 units | Changes? | ICU fresh µs | ICU reuse µs | " +
    engines.map(e => e + " µs (ratio)").join(" | ") +
    " |",
    "| --- | ---: | --- | ---: | ---: | " +
    engines.map(_ => "---:").join(" | ") +
    " |",
  ])
  for row in rows {
    if row.operation != "normalize" || row.form != "NFC" || row.state != "nfd" {
      continue
    }
    let icu_time = row.times.get("icu").unwrap().fastest
    let cells = engines.map(engine => {
      let time = row.times.get(engine).unwrap().fastest
      "\{fixed(time)} (\{fixed(time / icu_time)}×)"
    })
    lines.push(
      "| \{row.name} | \{row.input.utf16_units} | \{!row.normalized} | \{fixed(icu_time)} | \{fixed(row.reuse.unwrap_or(0.0))} | " +
      cells.join(" | ") +
      " |",
    )
  }
  lines.append([
    "",
    "## Interpretation and reproducibility",
    "",
    "- ICU `normalize` uses a fresh C++ `UnicodeString` per call. `normalize_reuse` uses `unorm2_normalize` with a buffer allocated before timing, as in normperf. Both are validated against the same complete expected output.",
    "- MoonBit uses the public `normalize` / `is_normalized` APIs and `@bench.keep` to retain results. Its unchanged-string path can return the original string; fresh ICU output may copy it. This API/ownership distinction is part of the measured result.",
    "- Corpus download, BOM decoding, creation of normalized variants, initialization, and correctness comparisons are outside the timer. Every MoonBit result and predicate is checked against ICU before measurement on every target and run.",
    "- Five samples target 20 ms each after adaptive calibration of at least 10 ms. Engines run sequentially; order rotates between executions.",
    "- Only NFC/NFD are included, the shared forms in the original normperf matrix. This is a standalone harness reusing its full corpora and bulk input matrix, not the upstream executable or its five-second/ten-pass timing configuration.",
    "- The fastest-sample convention follows [ICU perf methodology](https://github.com/unicode-org/icu-perf#performance-test-methodology); timing duration differs. Mean-of-median columns expose how much loaded-machine timings diverged.",
    "- Raw samples: `*-1.jsonl` through `*-\{environment.repeats}.jsonl`; every case: [comparison.csv](comparison.csv). Toolchain details: [environment.json](environment.json). Input lengths and hashes: [inputs.json](inputs.json).",
    "- Reproduce from repository root: `moon run --target native tools/normperf -- run --icu-prefix /path/to/icu77 --output /tmp/normperf-results`, then `moon run --target native tools/normperf -- summarize /tmp/normperf-results`.",
    "",
  ])
  // Validate all inputs before replacing any report.
  write("\{directory}/comparison.csv", csv.join("\n") + "\n")
  write("\{directory}/groups.json", groups.to_json().stringify(indent=2) + "\n")
  write("\{directory}/summary.md", lines.join("\n"))
  println("Reports saved in \{directory}")
}
