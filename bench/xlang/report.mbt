///|
/// The column every other column is compared with.
const Baseline : String = "moonbit-native"

///|
/// One measurement printed by a harness.
priv struct Row {
  /// The peer, followed by the library when the peer measures several.
  column : String
  /// `group/operation/input`.
  name : String
  ns : Double
  /// Code points processed per call; 1 for per-call cases.
  units : Int
  /// A value every implementation must agree on, or `-` when none applies.
  check : String
}

///|
/// Parse the `library<TAB>case<TAB>ns<TAB>units<TAB>check` lines of a harness.
/// Anything else it printed is ignored.
fn parse_rows(peer : String, output : String) -> Array[Row] {
  let rows = []
  for line in output.split("\n") {
    guard line.split("\t").collect() is [library, name, ns, units, check] else {
      continue
    }
    let ns = @string.parse_double(ns) catch { _ => continue }
    let units = @string.parse_int(units) catch { _ => continue }
    let column = if library.is_empty() { peer } else { "\{peer} \{library}" }
    rows.push({
      column,
      name: name.to_owned(),
      ns,
      units,
      check: check.trim().to_owned(),
    })
  }
  rows
}

///|
/// The rounds of one case in one column.
priv struct Cell {
  mut fastest : Double
  mut slowest : Double
  units : Int
  check : String
}

///|
/// Time per unit of the fastest round.
fn Cell::cost(self : Cell) -> Double {
  self.fastest / self.units.to_double()
}

///|
/// Every measurement, as column -> case -> cell, in first-seen order.
priv struct Results(Map[String, Map[String, Cell]])

///|
fn Results::add(self : Results, row : Row) -> Unit {
  let cases = self.0.get_or_init(row.column, () => Map([]))
  match cases.get(row.name) {
    Some(cell) => {
      if row.ns < cell.fastest {
        cell.fastest = row.ns
      }
      if row.ns > cell.slowest {
        cell.slowest = row.ns
      }
    }
    None =>
      cases[row.name] = {
        fastest: row.ns,
        slowest: row.ns,
        units: row.units,
        check: row.check,
      }
  }
}

///|
fn Results::cell(self : Results, column : String, name : String) -> Cell? {
  self.0.get(column).bind(cases => cases.get(name))
}

///|
/// The cases grouped as group -> operation -> case names, in first-seen order.
fn Results::groups(self : Results) -> Map[String, Map[String, Array[String]]] {
  let groups : Map[String, Map[String, Array[String]]] = Map([])
  for _, cases in self.0 {
    for name, _ in cases {
      guard name.split("/").collect() is [group, operation, ..] else {
        continue
      }
      let names = groups
        .get_or_init(group.to_owned(), () => Map([]))
        .get_or_init(operation.to_owned(), () => [])
      if !names.contains(name) {
        names.push(name)
      }
    }
  }
  groups
}

///|
fn geometric_mean(values : Array[Double]) -> Double? {
  guard values.length() > 0 else { return None }
  let mut sum = 0.0
  for value in values {
    sum += @math.ln(value)
  }
  Some(@math.exp(sum / values.length().to_double()))
}

///|
/// Two decimals below 100, none from there on.
fn format_number(value : Double) -> String {
  if value >= 100.0 {
    return value.round().to_int().to_string()
  }
  let hundredths = (value * 100.0).round().to_int()
  let fraction = (hundredths % 100).to_string().pad_start(2, '0')
  "\{hundredths / 100}.\{fraction}"
}

///|
/// One Markdown table: a row per `(label, cases)`, a column per harness that
/// measured any of the cases. A cell is the geometric mean over the row's
/// cases; other columns also show that mean relative to the baseline's, taken
/// over the cases both measured.
fn Results::write_table(
  self : Results,
  out : StringBuilder,
  title : String,
  label_header : String,
  rows : Array[(String, Array[String])],
) -> Unit {
  let columns = []
  let mut per_call = true
  for column, cases in self.0 {
    let mut used = false
    for row in rows {
      for name in row.1 {
        if cases.get(name) is Some(cell) {
          used = true
          per_call = per_call && cell.units == 1
        }
      }
    }
    if used {
      columns.push(column)
    }
  }
  guard columns.length() > 0 else { return }
  let unit = if per_call { "ns per call" } else { "ns per code point" }
  out.write_string("\n### \{title} (\{unit})\n\n| \{label_header} |")
  for column in columns {
    out.write_string(" \{column} |")
  }
  out.write_string("\n|---|")
  for _ in columns {
    out.write_string("---|")
  }
  out.write_string("\n")
  for row in rows {
    let (label, names) = row
    out.write_string("| \{label} |")
    for column in columns {
      let costs = []
      let baseline_costs = []
      for name in names {
        guard self.cell(column, name) is Some(cell) else { continue }
        costs.push(cell.cost())
        if self.cell(Baseline, name) is Some(baseline) {
          baseline_costs.push(baseline.cost())
        }
      }
      guard geometric_mean(costs) is Some(cost) else {
        out.write_string(" – |")
        continue
      }
      out.write_string(" \{format_number(cost)}")
      if column != Baseline &&
        baseline_costs.length() == costs.length() &&
        geometric_mean(baseline_costs) is Some(baseline) {
        out.write_string(" (\{format_number(cost / baseline)}x)")
      }
      out.write_string(" |")
    }
    out.write_string("\n")
  }
}

///|
/// The cases whose check values differ between columns, one line each.
fn Results::check_mismatches(self : Results) -> Array[String] {
  let by_case : Map[String, Map[String, Array[String]]] = Map([])
  for column, cases in self.0 {
    for name, cell in cases {
      guard cell.check != "-" else { continue }
      by_case
      .get_or_init(name, () => Map([]))
      .get_or_init(cell.check, () => [])
      .push(column)
    }
  }
  let mismatches = []
  for name, values in by_case {
    guard values.length() > 1 else { continue }
    let parts = []
    for value, columns in values {
      parts.push("\{value} from \{columns.join(", ")}")
    }
    mismatches.push("\{name}: \{parts.join("; ")}")
  }
  mismatches
}

///|
/// The median over a column's cases of slowest round / fastest round.
fn Results::spread(self : Results, column : String) -> Double? {
  guard self.0.get(column) is Some(cases) else { return None }
  let ratios = []
  for _, cell in cases {
    ratios.push(cell.slowest / cell.fastest)
  }
  guard ratios.length() > 0 else { return None }
  ratios.sort_by((a, b) => a.compare(b))
  Some(ratios[ratios.length() / 2])
}

///|
/// The Markdown report: per group, the geometric mean of every operation over
/// its inputs, then (with `detail`) every case; the check mismatches; and how
/// much the rounds disagreed.
fn Results::report(self : Results, rounds~ : Int, detail~ : Bool) -> String {
  let out = StringBuilder()
  out.write_string(
    (
      #|# Cross-language Unicode benchmark
      #|
      #|Each cell is the fastest of $rounds round(s). In parentheses: the time
      #|relative to `moonbit-native` on the same cases, so above 1 means slower
      #|than MoonBit native and below 1 means faster.
      #|
    ).replace(old="$rounds", new=rounds.to_string()),
  )
  for group, operations in self.groups() {
    let summary = []
    for operation, names in operations {
      summary.push((operation, names))
    }
    self.write_table(
      out,
      "\{group}: geometric mean over inputs",
      "operation",
      summary,
    )
    if detail {
      for operation, names in operations {
        self.write_table(
          out,
          "\{group}/\{operation}",
          "input",
          names.map(name => (name.split("/").collect()[2:].join("/"), [name])),
        )
      }
    }
  }
  out.write_string("\n### Checks\n\n")
  let mismatches = self.check_mismatches()
  if mismatches.is_empty() {
    out.write_string("Every implementation agrees on every case.\n")
  } else {
    out.write_string("Implementations disagree on these cases:\n\n")
    for mismatch in mismatches {
      out.write_string("- \{mismatch}\n")
    }
  }
  if rounds > 1 {
    out.write_string(
      "\n### Noise (median of slowest round / fastest round)\n\n| column | spread |\n|---|---|\n",
    )
    for column, _ in self.0 {
      if self.spread(column) is Some(spread) {
        out.write_string("| \{column} | \{format_number(spread)}x |\n")
      }
    }
  }
  out.to_string()
}
