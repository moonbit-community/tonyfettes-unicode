///|
/// Results of one harness from the given outputs, one per round.
fn results_of(column : String, outputs : Array[String]) -> Results {
  let results = Results(Map([]))
  for output in outputs {
    for row in parse_rows(column, output) {
      results.add(row)
    }
  }
  results
}

///|
/// Two runs of the same harness: head halves the cost of `norm/nfc/a`, keeps
/// `norm/nfc/b`, and measures `norm/nfd/new` only.
fn sample_pair() -> (Results, Results) {
  let base = results_of("moonbit-native", [
    (
      #|	norm/nfc/a	200	100	7
      #|	norm/nfc/b	800	100	9
      #|	idna/to_ascii/x	50	1	15
    ),
    (
      #|	norm/nfc/a	220	100	7
      #|	norm/nfc/b	840	100	9
      #|	idna/to_ascii/x	55	1	15
    ),
  ])
  let head = results_of("moonbit-native", [
    (
      #|	norm/nfc/a	100	100	7
      #|	norm/nfc/b	800	100	9
      #|	norm/nfd/new	300	100	9
      #|	idna/to_ascii/x	52.5	1	15
    ),
  ])
  (base, head)
}

///|
test "numbers keep five significant digits" {
  inspect(round_significant(0.296612345, 5), content="0.29661")
  inspect(round_significant(1002.34567, 5), content="1002.3")
  inspect(round_significant(123456.7, 5), content="123460")
  inspect(round_significant(0.0, 5), content="0")
}

///|
test "changes are signed percentages" {
  inspect(format_change(1.034), content="+3.4%")
  inspect(format_change(0.5), content="-50.0%")
  inspect(format_change(1.0), content="0.0%")
  inspect(format_change(0.99996), content="0.0%")
}

///|
test "operations compare the cases both runs measured" {
  let (base, head) = sample_pair()
  let operations = compare_operations(base, head)
  let ratio = (operation : String) => {
    operations
    .get(operation)
    .bind(columns => columns.get("moonbit-native"))
    .unwrap_or(-1.0)
  }
  // norm/nfc: sqrt(0.5 * 1.0); norm/nfd has no base case.
  inspect(ratio("norm/nfc"), content="0.7071067811865475")
  inspect(operations.get("norm/nfd") is None, content="true")
  inspect(ratio("idna/to_ascii"), content="1.05")
}

///|
test "comparison as JSON" {
  let (base, head) = sample_pair()
  let json = compare_json(base, head, { "rounds": Json::number(2.0) })
  inspect(
    json.stringify(),
    content=(
      #|{"about":{"rounds":2},"operations":{"norm/nfc":{"moonbit-native":0.70711},"idna/to_ascii":{"moonbit-native":1.05}},"spread":{"moonbit-native":1.1},"cases":{"norm/nfc/a":{"moonbit-native":[2,1]},"norm/nfc/b":{"moonbit-native":[8,8]},"idna/to_ascii/x":{"moonbit-native":[50,52.5]}}}
    ),
  )
}

///|
test "comparison report" {
  let (base, head) = sample_pair()
  inspect(
    compare_report(base, head, base_label="aaa", head_label="bbb", rounds=2),
    content=(
      #|# MoonBit benchmark: bbb against aaa
      #|
      #|Each cell is the change in time from the base to the head commit,
      #|the geometric mean over the operation's inputs of the fastest of
      #|2 round(s) on each side. Negative is faster. Changes of 5% or
      #|more are in bold; compare them with the noise below.
      #|
      #|| operation | moonbit-native |
      #||---|---|
      #|| norm/nfc | **-29.3%** |
      #|| idna/to_ascii | **+5.0%** |
      #|
      #|Noise, the median over cases of slowest round / fastest round: moonbit-native +10.0%.
      #|
    ),
  )
}

///|
test "snapshot as JSON" {
  let (_, head) = sample_pair()
  inspect(
    head.snapshot_json({ "rounds": Json::number(1.0) }).stringify(),
    content=(
      #|{"about":{"rounds":1},"cases":{"norm/nfc/a":{"moonbit-native":1},"norm/nfc/b":{"moonbit-native":8},"norm/nfd/new":{"moonbit-native":3},"idna/to_ascii/x":{"moonbit-native":52.5}}}
    ),
  )
}
