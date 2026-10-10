///|
async fn with_directory(f : async (String) -> Unit) -> Unit {
  @async.with_task_group(group => {
    let directory = @fs.tmpdir(prefix="normperf-test-")
    group.add_defer(() => {
      @async.protect_from_cancel(() => @fs.rmdir(directory, recursive=true))
    })
    f(directory)
  })
}

///|
async fn put(directory : String, name : String, text : String) -> Unit {
  @fs.write_file("\{directory}/\{name}", text, create_mode=CreateOrTruncate)
}

///|
async fn samples(directory : String) -> Unit {
  let environment : Json = {
    "source_revision": "test",
    "icu": "77.1",
    "unicode": "16.0.0.0",
    "repeats": 2,
  }
  put(directory, "environment.json", environment.stringify())
  let inputs : Json = [
    {
      "name": "sample",
      "state": "orig",
      "utf16_units": 1,
      "codepoints": 1,
      "sha256": "test",
      "is_nfc": true,
      "is_nfd": true,
    },
  ]
  put(directory, "inputs.json", inputs.stringify())
  for engine in ["icu", "native"] {
    for index in 1..<=2 {
      let values = if index == 1 {
        [8.0, 4.0, 6.0, 10.0, 2.0]
      } else {
        [3.0, 9.0, 5.0, 7.0, 1.0]
      }
      let values = values.map(x => if engine == "icu" { x } else { x * 2.0 })
      let lines : Array[String] = []
      let operations = if engine == "icu" {
        ["normalize", "normalize_reuse", "check"]
      } else {
        ["normalize", "check"]
      }
      for form in ["NFC", "NFD"] {
        for operation in operations {
          let row : Json = {
            "name": "sample/orig/\{form}/\{operation}",
            "iterations": 10,
            "samples_us": values.to_json(),
          }
          lines.push(row.stringify())
        }
      }
      put(directory, "\{engine}-\{index}.jsonl", lines.join("\n") + "\n")
    }
  }
}

///|
async test "reject nonempty result directory before preparation and preserve every backend" {
  with_directory(directory => {
    let names = [
      "environment.json", "icu-1.jsonl", "native-1.jsonl", "wasm-1.jsonl", "wasm-gc-1.jsonl",
      ".hidden",
    ]
    for name in names {
      put(directory, name, "previous result")
    }
    let error = try {
      @normperf.run(
        root="/nonexistent-normperf-root",
        icu_prefix="/unused",
        output=directory,
        targets=["native"],
        repeats=1,
      )
      ""
    } catch {
      error => error.to_string()
    }
    inspect(error.contains("choose a new --output directory"), content="true")
    for name in names {
      inspect(
        @fs.read_file("\{directory}/\{name}").text(),
        content="previous result",
      )
    }
    inspect(@fs.readdir(directory, include_hidden=true).length(), content="6")
  })
}

///|
async test "prepare-only bypasses result directory and leaves it untouched even if preparation fails" {
  with_directory(directory => {
    put(directory, "environment.json", "previous result")
    let error = try {
      @normperf.run(
        root="\{directory}/missing-root",
        icu_prefix="/unused",
        output=directory,
        targets=["native"],
        repeats=1,
        prepare_only=true,
      )
      ""
    } catch {
      error => error.to_string()
    }
    inspect(error.is_empty(), content="false")
    inspect(error.contains("Results directory is not empty"), content="false")
    inspect(
      @fs.read_file("\{directory}/environment.json").text(),
      content="previous result",
    )
  })
}

///|
async test "fastest sample, mean of medians, ratios and selected backend report" {
  with_directory(directory => {
    samples(directory)
    @normperf.summarize(directory)
    let csv = @fs.read_file("\{directory}/comparison.csv").text()
    inspect(csv.split("\n").count(), content="6")
    inspect(csv.contains("wasm"), content="false")
    inspect(
      csv.contains("\"1\",\"5.5\",\"1\",\"2\",\"11\",\"2\""),
      content="true",
    )
    let groups = @fs.read_file("\{directory}/groups.json").json()
    json_inspect(groups, content=[
      {
        "operation": "normalize",
        "form": "NFC",
        "already_normalized": true,
        "cases": 1,
        "ratios": { "native": 2 },
      },
      {
        "operation": "normalize",
        "form": "NFD",
        "already_normalized": true,
        "cases": 1,
        "ratios": { "native": 2 },
      },
      {
        "operation": "check",
        "form": "NFC",
        "already_normalized": true,
        "cases": 1,
        "ratios": { "native": 2 },
      },
      {
        "operation": "check",
        "form": "NFD",
        "already_normalized": true,
        "cases": 1,
        "ratios": { "native": 2 },
      },
    ])
    inspect(
      @fs.read_file("\{directory}/summary.md")
      .text()
      .contains("fastest of 10 samples across 2 processes"),
      content="true",
    )
  })
}

///|
async test "reject missing runs, incomplete matrix, duplicate cases and malformed samples without replacing reports" {
  with_directory(directory => {
    for kind in ["missing", "incomplete", "duplicate", "invalid"] {
      samples(directory)
      put(directory, "comparison.csv", "previous report")
      let path = "\{directory}/native-2.jsonl"
      let original = @fs.read_file(path).text()
      match kind {
        "missing" => @fs.remove(path)
        "incomplete" =>
          put(
            directory,
            "native-2.jsonl",
            original
            .split("\n")
            .take(3)
            .map(x => x.to_owned())
            .to_array()
            .join("\n"),
          )
        "duplicate" => put(directory, "native-2.jsonl", original + original)
        _ =>
          put(
            directory, "native-2.jsonl", "{\"name\":\"sample/orig/NFC/check\",\"iterations\":10,\"samples_us\":[1,2,3]}\n",
          )
      }
      let error = try {
        @normperf.summarize(directory)
        ""
      } catch {
        error => error.to_string()
      }
      let expected = match kind {
        "missing" => "Missing results"
        "incomplete" => "Incomplete output"
        "duplicate" => "Duplicate cases"
        _ => "Invalid samples"
      }
      inspect(error.contains(expected), content="true")
      inspect(
        @fs.read_file("\{directory}/comparison.csv").text(),
        content="previous report",
      )
    }
  })
}
