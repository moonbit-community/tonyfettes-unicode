///|
/// Run `step` with extra arguments, returning its exit status and its output
/// (stdout only, or stdout and stderr merged for builds). `@shell` cannot
/// merge the two streams at the descriptor level, so a build's captured
/// streams are concatenated for the failure diagnostics below, and the
/// capture limit is raised above its 8 MiB default because build logs are
/// chatty.
async fn run_step(
  step : Step,
  extra~ : Array[String] = [],
  merge_stderr~ : Bool = false,
) -> (Int32, String) {
  let arguments = [..step.arguments, ..extra]
  let output = @shell.Cmd(
    step.program,
    arguments,
    cwd=step.cwd,
    stderr=if merge_stderr { Capture } else { Inherit },
  ).output(max_output_bytes=64 * 1024 * 1024)
  let text = if merge_stderr {
    "\{output.stdout()}\{output.stderr()}"
  } else {
    output.stdout()
  }
  (output.exit_code(), text)
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
/// The first line that `command` prints through `sh` in `cwd`, or `None`
/// when it fails or prints nothing. Its errors are discarded.
async fn first_line(command : String, cwd : String) -> String? {
  let step = {
    program: "sh",
    arguments: ["-c", "\{command} 2>/dev/null"],
    cwd,
  }
  let (status, output) = run_step(step) catch {
    error if @async.is_being_cancelled() => raise error
    _ => return None
  }
  guard status == 0 else { return None }
  let line = match output.trim().split_once("\n") {
    Some((first, _)) => first.trim()
    None => output.trim()
  }
  if line.is_empty() {
    None
  } else {
    Some(line.to_owned())
  }
}

///|
/// The processor and the operating system, for the record of a run.
async fn machine(root : String) -> String {
  let cpu = match first_line("sysctl -n machdep.cpu.brand_string", root) {
    Some(cpu) => cpu
    None =>
      first_line("sed -n 's/^model name[[:space:]]*: //p' /proc/cpuinfo", root).unwrap_or(
        "unknown processor",
      )
  }
  match first_line("uname -sm", root) {
    Some(system) => "\{cpu}, \{system}"
    None => cpu
  }
}

///|
/// The commit checked out in `root`: its hash, subject, first line of the
/// body and commit date, and whether the checkout has uncommitted changes.
async fn commit_json(root : String) -> Json {
  let fields : Map[String, Json] = Map([])
  for
    (key, command) in [
      ("commit", "git log -1 --format=%H"),
      ("subject", "git log -1 --format=%s"),
      // For a merge commit of a pull request, its title.
      ("title", "git log -1 --format=%b"),
      ("date", "git log -1 --format=%cI"),
    ] {
    if first_line(command, root) is Some(value) {
      fields[key] = Json::string(value)
    }
  }
  fields["dirty"] = Json::boolean(
    first_line("git status --porcelain --untracked-files=no", root) is Some(_),
  )
  Json::object(fields)
}

///|
/// A commit as `abc1234 (subject)` for the Markdown report.
fn commit_label(commit : Json) -> String {
  guard commit is Object(fields) else { return "unknown commit" }
  let hash = match fields.get("commit") {
    Some(String(hash)) if hash.length() > 7 => hash[:7].to_owned()
    Some(String(hash)) => hash
    _ => "unknown commit"
  }
  match fields.get("subject") {
    Some(String(subject)) => "\{hash} (\{subject})"
    _ => hash
  }
}

///|
/// The versions of what the peers measure, one per label.
async fn versions(peers : Array[Peer], root : String) -> Json {
  let result : Map[String, Json] = Map([])
  for peer in peers {
    for version in peer.versions {
      let (label, command) = version
      if !result.contains(label) && first_line(command, root) is Some(text) {
        result[label] = Json::string(text)
      }
    }
  }
  Json::object(result)
}

///|
/// The rows `peer` prints, or `None` when it fails; the failure is reported.
async fn run_peer(peer : Peer, extra : Array[String]) -> Array[Row]? {
  let (status, output) = run_step(peer.run, extra~) catch {
    error if @async.is_being_cancelled() => raise error
    error => {
      println("    Failed: \{error}")
      return None
    }
  }
  if status != 0 {
    println("    Failed: exit status \{status}; its results are dropped")
    return None
  }
  Some(parse_rows(peer.name, output))
}

///|
/// Check `revision` out in `directory` as a detached worktree of the checkout
/// in `root`, replacing any worktree left there by an earlier run. The MoonBit
/// harness is then copied from `root`, so that both commits run the same
/// harness and a change to it does not show up as a change to the library.
/// The bench module's `moon.mod` goes with it, so that a harness importing a
/// module the base did not import yet still builds there.
async fn check_out(
  root : String,
  revision : String,
  directory : String,
) -> Unit {
  let git = (arguments : Array[String]) => {
    ({ program: "git", arguments, cwd: root, } : Step)
  }
  ignore(
    run_step(
      git(["worktree", "remove", "--force", directory]),
      merge_stderr=true,
    ),
  )
  ignore(run_step(git(["worktree", "prune"]), merge_stderr=true))
  let (status, output) = run_step(
    git(["worktree", "add", "--detach", directory, revision]),
    merge_stderr=true,
  )
  guard status == 0 else {
    fail("Cannot check out \{revision}: \{output.trim()}")
  }
  let harness = "bench/xlang/moonbit"
  let (status, output) = run_step(
    {
      program: "sh",
      arguments: [
        "-c", "rm -rf \"$2/$3\" && cp -R \"$1/$3\" \"$2/$3\" && cp \"$1/$4\" \"$2/$4\"",
        "sh", root, directory, harness, "bench/moon.mod",
      ],
      cwd: root,
    },
    merge_stderr=true,
  )
  guard status == 0 else {
    fail("Cannot copy the harness into \{directory}: \{output.trim()}")
  }
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
      @argparse.OptionArg(
        "base",
        long="base",
        about="Instead, compare the MoonBit harnesses with those of this commit, alternating the two",
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
  let base = matches.values.get("base").map(values => values[0])
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
    // A comparison of two commits only concerns this repository's code.
    _ if base is Some(_) =>
      peers.filter(peer => peer.name.has_prefix("moonbit-"))
    _ => peers
  }
  if base is Some(_) {
    for peer in selected {
      guard peer.name.has_prefix("moonbit-") else {
        fail("--base compares MoonBit harnesses only, not \{peer.name}")
      }
    }
  }
  let inputs = "\{work}/inputs"
  println("==> Preparing inputs in \{inputs}")
  prepare_inputs(root, inputs)
  let base_root = "\{work}/base"
  if base is Some(revision) {
    println("==> Checking out \{revision} in \{base_root}")
    check_out(root, revision, base_root)
  }
  // Pairs of the harness for this checkout and, with --base, the same harness
  // for the base commit, measuring the same cases.
  let ready : Array[(Peer, Peer?)] = []
  for peer in selected {
    println("==> Setting up \{peer.name}")
    if setup_failure(peer) is Some(reason) {
      println("    Skipped: \{reason}")
      continue
    }
    guard base is Some(_) else {
      ready.push((peer, None))
      continue
    }
    let target = peer.name.strip_prefix("moonbit-").unwrap().to_owned()
    let base_peer = moonbit_peer(base_root, target)
    println("==> Setting up \{peer.name} at the base commit")
    match setup_failure(base_peer) {
      Some(reason) => println("    Skipped: \{reason}")
      None => ready.push((peer, Some(base_peer)))
    }
  }
  guard !ready.is_empty() else { fail("None of the harnesses could be set up") }
  let extra = if group is Some(group) { [inputs, group] } else { [inputs] }
  let results = Results(Map([]))
  let base_results = Results(Map([]))
  let raw = StringBuilder()
  raw.write_string("round\tcommit\tcolumn\tcase\tns\tunits\tcheck\n")
  // One harness at a time, so that they do not compete for the machine, and
  // round by round, so that a noisy period does not hit one harness only.
  // The two commits of a comparison take turns going first.
  for round in 1..<=rounds {
    for pair in ready {
      let (peer, base_peer) = pair
      let sides = match base_peer {
        None => [("head", peer, results)]
        Some(base_peer) if round % 2 == 1 =>
          [("base", base_peer, base_results), ("head", peer, results)]
        Some(base_peer) =>
          [("head", peer, results), ("base", base_peer, base_results)]
      }
      for side in sides {
        let (commit, peer, into) = side
        let label = if base_peer is Some(_) { " (\{commit})" } else { "" }
        println("==> Round \{round}/\{rounds}: \{peer.name}\{label}")
        guard run_peer(peer, extra) is Some(rows) else { continue }
        for row in rows {
          into.add(row)
          raw.write_string(
            "\{round}\t\{commit}\t\{row.column}\t\{row.name}\t\{row.ns}\t\{row.units}\t\{row.check}\n",
          )
        }
      }
    }
  }
  // A report without measurements would claim that every implementation agrees.
  guard !results.0.is_empty() else { fail("No harness produced any result") }
  let about : Map[String, Json] = {
    "date": Json::string(
      first_line("date -u +%Y-%m-%dT%H:%M:%SZ", root).unwrap_or(""),
    ),
    "rounds": Json::number(rounds.to_double()),
    "machine": Json::string(machine(root)),
    "versions": versions(ready.map(pair => pair.0), root),
  }
  write_text("\{work}/results.tsv", raw.to_string())
  match base {
    None => {
      about["commit"] = commit_json(root)
      let report = results.report(rounds~, detail~)
      write_text("\{work}/report.md", report)
      write_text(
        "\{work}/results.json",
        results.snapshot_json(about).stringify() + "\n",
      )
      println("")
      println(report)
      println(
        "Raw results: \{work}/results.tsv; this report: \{work}/report.md; for the dashboard: \{work}/results.json",
      )
    }
    Some(_) => {
      guard !base_results.0.is_empty() else {
        fail("The base commit produced no result")
      }
      let base_commit = commit_json(base_root)
      let head_commit = commit_json(root)
      about["base"] = base_commit
      about["head"] = head_commit
      let report = compare_report(
        base_results,
        results,
        base_label=commit_label(base_commit),
        head_label=commit_label(head_commit),
        rounds~,
      )
      write_text("\{work}/compare.md", report)
      write_text(
        "\{work}/compare.json",
        compare_json(base_results, results, about).stringify() + "\n",
      )
      println("")
      println(report)
      println(
        "Raw results: \{work}/results.tsv; this report: \{work}/compare.md; for the dashboard: \{work}/compare.json",
      )
    }
  }
}
