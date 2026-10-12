///|
/// Run `step` with extra arguments, returning its exit status and its output
/// (stdout only, or stdout and stderr merged for builds).
async fn run_step(
  step : Step,
  extra~ : Array[String] = [],
  merge_stderr~ : Bool = false,
) -> (Int32, String) {
  let arguments = [..step.arguments, ..extra]
  let (status, output) = if merge_stderr {
    @process.collect_output_merged(step.program, arguments, cwd=step.cwd)
  } else {
    @process.collect_stdout(step.program, arguments, cwd=step.cwd)
  }
  (status, output.text())
}

///|
/// Set `peer` up; `Some(reason)` when it cannot take part in the comparison,
/// typically because its toolchain, runtime or library is not installed.
async fn setup_failure(peer : Peer) -> String? {
  for step in peer.setup {
    let (status, output) = run_step(step, merge_stderr=true) catch {
      error if @async.is_being_cancelled() => raise error
      error => return Some("cannot run \{step.program}: \{error}")
    }
    if status != 0 {
      return Some("\{step.program} exited with \{status}\n\{output.trim()}")
    }
  }
  None
}

///|
async fn main {
  let command = @argparse.Command(
    "xlang",
    about="Compare this repository's Unicode modules with other languages' libraries",
    flags=[
      @argparse.FlagArg(
        "detail",
        long="detail",
        about="Also report every case, not only the mean per operation",
      ),
    ],
    options=[
      @argparse.OptionArg(
        "rounds",
        long="rounds",
        about="Run every harness this many times and keep the fastest result",
        default_values=["3"],
      ),
      @argparse.OptionArg(
        "impl",
        long="impl",
        about="Comma-separated harnesses to run (default: all that can be set up)",
      ),
      @argparse.OptionArg(
        "group",
        long="group",
        about="Only run this group: \{groups.join(", ")}",
      ),
    ],
  )
  let matches = command.parse()
  let detail = matches.flags.get("detail").unwrap_or(false)
  let rounds = match matches.values.get("rounds") {
    Some([value, ..]) => @string.parse_int(value)
    _ => 3
  }
  guard rounds >= 1 else { fail("--rounds must be at least 1, not \{rounds}") }
  let group = matches.values.get("group").map(values => values[0])
  if group is Some(group) && !groups.contains(group) {
    fail("Unknown group \{group}; choose from \{groups.join(", ")}")
  }
  guard @fs.exists("moon.work") && @fs.exists("bench/xlang/moon.pkg") else {
    fail("Run this from the repository root")
  }
  let root = @fs.realpath(".")
  let work = "\{root}/_build/xlang"
  let peers = all_peers(root, work)
  let selected = match matches.values.get("impl") {
    Some([names, ..]) => {
      let names = names.split(",").map(name => name.trim().to_owned()).collect()
      for name in names {
        guard peers.any(peer => peer.name == name) else {
          let known = peers.map(peer => peer.name).join(", ")
          fail("Unknown harness \{name}; choose from \{known}")
        }
      }
      peers.filter(peer => names.contains(peer.name))
    }
    _ => peers
  }
  let inputs = "\{work}/inputs"
  println("==> Preparing inputs in \{inputs}")
  prepare_inputs(root, inputs)
  let ready = []
  for peer in selected {
    println("==> Setting up \{peer.name}")
    match setup_failure(peer) {
      Some(reason) => println("    Skipped: \{reason}")
      None => ready.push(peer)
    }
  }
  guard !ready.is_empty() else { fail("None of the harnesses could be set up") }
  let extra = if group is Some(group) { [inputs, group] } else { [inputs] }
  let results = Results(Map([]))
  let raw = StringBuilder()
  raw.write_string("round\tcolumn\tcase\tns\tunits\tcheck\n")
  // One harness at a time, so that they do not compete for the machine, and
  // round by round, so that a noisy period does not hit one harness only.
  for round in 1..<=rounds {
    for peer in ready {
      println("==> Round \{round}/\{rounds}: \{peer.name}")
      let (status, output) = run_step(peer.run, extra~) catch {
        error if @async.is_being_cancelled() => raise error
        error => {
          println("    Failed: \{error}")
          continue
        }
      }
      if status != 0 {
        println("    Failed: exit status \{status}; its results are dropped")
        continue
      }
      for row in parse_rows(peer.name, output) {
        results.add(row)
        raw.write_string(
          "\{round}\t\{row.column}\t\{row.name}\t\{row.ns}\t\{row.units}\t\{row.check}\n",
        )
      }
    }
  }
  // A report without measurements would claim that every implementation agrees.
  guard !results.0.is_empty() else { fail("No harness produced any result") }
  let report = results.report(rounds~, detail~)
  write_text("\{work}/results.tsv", raw.to_string())
  write_text("\{work}/report.md", report)
  println("")
  println(report)
  println("Raw results: \{work}/results.tsv; this report: \{work}/report.md")
}
