///|
/// Two rounds of two harnesses: the report keeps the fastest round, compares
/// per unit with the baseline and averages geometrically over the inputs.
fn sample_results() -> Results {
  let results = Results(Map([]))
  let outputs = [
    (
      "moonbit-native",
      (
        #|	norm/nfc/a	200	100	7
        #|	norm/nfc/b	800	100	9
        #|	idna/to_ascii/x	50	1	15
        #|not a result row
      ),
    ),
    (
      "moonbit-native",
      (
        #|	norm/nfc/a	100	100	7
        #|	norm/nfc/b	1000	100	9
        #|	idna/to_ascii/x	55	1	15
      ),
    ),
    (
      "rust",
      (
        #|fast	norm/nfc/a	50	100	7
        #|fast	norm/nfc/b	400	100	9
        #|slow	norm/nfc/a	4e2	100	8
        #|idna	idna/to_ascii/x	25000	1	-
      ),
    ),
  ]
  for output in outputs {
    for row in parse_rows(output.0, output.1) {
      results.add(row)
    }
  }
  results
}

///|
test "rows are parsed and the fastest round is kept" {
  let results = sample_results()
  guard results.cell("moonbit-native", "norm/nfc/a") is Some(cell) else {
    fail("missing cell")
  }
  inspect(cell.fastest, content="100")
  inspect(cell.slowest, content="200")
  inspect(cell.cost(), content="1")
  inspect(results.cell("rust slow", "norm/nfc/b") is None, content="true")
}

///|
test "numbers keep two decimals below 100" {
  inspect(format_number(0.004), content="0.00")
  inspect(format_number(1.0), content="1.00")
  inspect(format_number(12.345), content="12.35")
  inspect(format_number(99.999), content="100.00")
  inspect(format_number(1234.5), content="1235")
}

///|
test "report" {
  inspect(
    sample_results().report(rounds=2, detail=true),
    content=(
      #|# Cross-language Unicode benchmark
      #|
      #|Each cell is the fastest of 2 round(s). In parentheses: the time
      #|relative to `moonbit-native` on the same cases, so above 1 means slower
      #|than MoonBit native and below 1 means faster.
      #|
      #|### norm: geometric mean over inputs (ns per code point)
      #|
      #|| operation | moonbit-native | rust fast | rust slow |
      #||---|---|---|---|
      #|| nfc | 2.83 | 1.41 (0.50x) | 4.00 (4.00x) |
      #|
      #|### norm/nfc (ns per code point)
      #|
      #|| input | moonbit-native | rust fast | rust slow |
      #||---|---|---|---|
      #|| a | 1.00 | 0.50 (0.50x) | 4.00 (4.00x) |
      #|| b | 8.00 | 4.00 (0.50x) | – |
      #|
      #|### idna: geometric mean over inputs (ns per call)
      #|
      #|| operation | moonbit-native | rust idna |
      #||---|---|---|
      #|| to_ascii | 50.00 | 25000 (500x) |
      #|
      #|### idna/to_ascii (ns per call)
      #|
      #|| input | moonbit-native | rust idna |
      #||---|---|---|
      #|| x | 50.00 | 25000 (500x) |
      #|
      #|### Checks
      #|
      #|Implementations disagree on these cases:
      #|
      #|- norm/nfc/a: 7 from moonbit-native, rust fast; 8 from rust slow
      #|
      #|### Noise (median of slowest round / fastest round)
      #|
      #|| column | spread |
      #||---|---|
      #|| moonbit-native | 1.25x |
      #|| rust fast | 1.00x |
      #|| rust slow | 1.00x |
      #|| rust idna | 1.00x |
      #|
    ),
  )
}
