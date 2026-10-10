///|
fn value(matches : @argparse.Matches, name : String) -> String raise {
  guard matches.values.get(name) is Some([first, ..]) else {
    fail("Missing argument: \{name}")
  }
  first
}

///|
async fn main {
  let command = @argparse.Command("normperf", subcommand_required=true, subcommands=[
    @argparse.Command(
      "run",
      flags=[@argparse.FlagArg("prepare-only", long="prepare-only")],
      options=[
        @argparse.OptionArg("icu-prefix", long="icu-prefix", default_values=[
          "/opt/homebrew/opt/icu4c@77",
        ]),
        @argparse.OptionArg("output", long="output", default_values=[
          "benchmarks/normperf/.work/results",
        ]),
        @argparse.OptionArg(
          "targets",
          long="targets",
          default_values=["native,wasm,wasm-gc"],
          about="Comma-separated backends",
        ),
        @argparse.OptionArg("repeats", long="repeats", default_values=["3"]),
      ],
    ),
    @argparse.Command("summarize", positionals=[
      @argparse.PositionArg(
        "directory",
        num_args=@argparse.ValueRange::single(),
      ),
    ]),
  ])
  let matches = command.parse() catch { error => fail(error.to_string()) }
  match matches.subcommand {
    Some(("run", options)) => {
      guard @fs.exists("benchmarks/normperf/corpus.json") else {
        fail("Run from the repository root")
      }
      @harness.run(
        root=".",
        icu_prefix=value(options, "icu-prefix"),
        output=value(options, "output"),
        targets=value(options, "targets")
          .split(",")
          .map(v => v.to_owned())
          .to_array(),
        repeats=@string.parse_int(value(options, "repeats")),
        prepare_only=options.flags.get("prepare-only").unwrap_or(false),
      )
    }
    Some(("summarize", options)) =>
      @harness.summarize(value(options, "directory"))
    _ => fail("Expected run or summarize")
  }
}
