///|
/// `value` rounded to `digits` significant digits. More digits than the noise
/// allows only make the JSON larger.
fn round_significant(value : Double, digits : Int32) -> Double {
  guard value > 0.0 else { return value }
  let exponent = digits - 1 - @math.log10(value).floor().to_int()
  let scale = @math.pow(10.0, exponent.to_double())
  (value * scale).round() / scale
}

///|
fn number(value : Double) -> Json {
  Json::number(round_significant(value, 5))
}

///|
/// The `group/operation` part of a case name.
fn operation_of(name : String) -> String? {
  guard name.split("/").collect() is [group, operation, ..] else { return None }
  Some("\{group}/\{operation}")
}

///|
/// One run as JSON: `about` describes it, and `cases` maps every case to its
/// cost in each column, in ns per unit of the fastest round.
fn Results::snapshot_json(self : Results, about : Map[String, Json]) -> Json {
  let cases : Map[String, Map[String, Json]] = Map([])
  for column, by_name in self.0 {
    for name, cell in by_name {
      cases.get_or_init(name, () => Map([]))[column] = number(cell.cost())
    }
  }
  let cases_json : Map[String, Json] = Map([])
  for name, columns in cases {
    cases_json[name] = Json::object(columns)
  }
  Json::object({
    "about": Json::object(about),
    "cases": Json::object(cases_json),
  })
}

///|
/// For every operation and column measured by both runs, the geometric mean
/// over the operation's cases of head cost / base cost. Below 1, head is
/// faster. Cases only one of the runs measured are left out.
fn compare_operations(
  base : Results,
  head : Results,
) -> Map[String, Map[String, Double]] {
  let ratios : Map[String, Map[String, Array[Double]]] = Map([])
  for column, by_name in head.0 {
    for name, head_cell in by_name {
      guard base.cell(column, name) is Some(base_cell) else { continue }
      guard operation_of(name) is Some(operation) else { continue }
      ratios
      .get_or_init(operation, () => Map([]))
      .get_or_init(column, () => [])
      .push(head_cell.cost() / base_cell.cost())
    }
  }
  let result : Map[String, Map[String, Double]] = Map([])
  for operation, columns in ratios {
    let means : Map[String, Double] = Map([])
    for column, values in columns {
      if geometric_mean(values) is Some(mean) {
        means[column] = mean
      }
    }
    result[operation] = means
  }
  result
}

///|
/// The larger of the two runs' spreads in each column: how much rounds of the
/// same code disagreed, so how large a change has to be to mean anything.
fn compare_spreads(base : Results, head : Results) -> Map[String, Double] {
  let spreads : Map[String, Double] = Map([])
  for column, _ in head.0 {
    match (base.spread(column), head.spread(column)) {
      (Some(a), Some(b)) => spreads[column] = if a > b { a } else { b }
      (Some(spread), None) | (None, Some(spread)) => spreads[column] = spread
      (None, None) => ()
    }
  }
  spreads
}

///|
/// An A/B comparison as JSON: `about` describes it; `operations` holds the
/// ratios of `compare_operations`, `spread` those of `compare_spreads`, and
/// `cases` both costs of every case in each column, base first.
fn compare_json(
  base : Results,
  head : Results,
  about : Map[String, Json],
) -> Json {
  let operations : Map[String, Json] = Map([])
  for operation, columns in compare_operations(base, head) {
    let ratios : Map[String, Json] = Map([])
    for column, ratio in columns {
      ratios[column] = number(ratio)
    }
    operations[operation] = Json::object(ratios)
  }
  let spreads : Map[String, Json] = Map([])
  for column, spread in compare_spreads(base, head) {
    spreads[column] = number(spread)
  }
  let cases : Map[String, Map[String, Json]] = Map([])
  for column, by_name in head.0 {
    for name, head_cell in by_name {
      guard base.cell(column, name) is Some(base_cell) else { continue }
      cases.get_or_init(name, () => Map([]))[column] = Json::array([
        number(base_cell.cost()),
        number(head_cell.cost()),
      ])
    }
  }
  let cases_json : Map[String, Json] = Map([])
  for name, columns in cases {
    cases_json[name] = Json::object(columns)
  }
  Json::object({
    "about": Json::object(about),
    "operations": Json::object(operations),
    "spread": Json::object(spreads),
    "cases": Json::object(cases_json),
  })
}

///|
/// A ratio as a signed percentage with one decimal: 1.034 is `+3.4%`.
fn format_change(ratio : Double) -> String {
  let tenths = ((ratio - 1.0) * 1000.0).round().to_int()
  let sign = if tenths > 0 { "+" } else if tenths < 0 { "-" } else { "" }
  let magnitude = tenths.abs()
  "\{sign}\{magnitude / 10}.\{magnitude % 10}%"
}

///|
/// Changes at least this large are shown in bold in the Markdown report.
const Notable : Double = 0.05

///|
/// The A/B comparison as Markdown: a table with a row per operation and a
/// column per harness, each cell the change from base to head.
fn compare_report(
  base : Results,
  head : Results,
  base_label~ : String,
  head_label~ : String,
  rounds~ : Int32,
) -> String {
  let out = StringBuilder()
  out.write_string(
    "# MoonBit benchmark: \{head_label} against \{base_label}\n\n",
  )
  out.write_string(
    (
      #|Each cell is the change in time from the base to the head commit,
      #|the geometric mean over the operation's inputs of the fastest of
      #|$rounds round(s) on each side. Negative is faster. Changes of 5% or
      #|more are in bold; compare them with the noise below.
      #|
    ).replace(old="$rounds", new=rounds.to_string()),
  )
  let operations = compare_operations(base, head)
  let columns = []
  for column, _ in head.0 {
    if operations.values().any(ratios => ratios.contains(column)) {
      columns.push(column)
    }
  }
  if columns.is_empty() {
    out.write_string("\nThe two runs have no case in common.\n")
    return out.to_string()
  }
  out.write_string("\n| operation |")
  for column in columns {
    out.write_string(" \{column} |")
  }
  out.write_string("\n|---|")
  for _ in columns {
    out.write_string("---|")
  }
  out.write_string("\n")
  for operation, ratios in operations {
    out.write_string("| \{operation} |")
    for column in columns {
      match ratios.get(column) {
        Some(ratio) => {
          let change = format_change(ratio)
          let notable = ratio >= 1.0 + Notable || ratio <= 1.0 - Notable
          out.write_string(
            if notable {
              " **\{change}** |"
            } else {
              " \{change} |"
            },
          )
        }
        None => out.write_string(" – |")
      }
    }
    out.write_string("\n")
  }
  let spreads = compare_spreads(base, head)
  // A single round cannot tell how noisy the machine is.
  if rounds > 1 && !spreads.is_empty() {
    out.write_string(
      "\nNoise, the median over cases of slowest round / fastest round:",
    )
    let parts = [
      for column in columns => {
        if spreads.get(column) is Some(spread) {
          "\{column} \{format_change(spread)}"
        } else {
          "\{column} –"
        }
      }
    ]
    out.write_string(" \{parts.join(", ")}.\n")
  }
  out.to_string()
}
