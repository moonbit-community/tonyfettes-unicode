///|
/// Default UAX #14 conformance, Unicode 18.0.0:
/// https://www.unicode.org/Public/18.0.0/ucd/auxiliary/LineBreakTest.txt
/// Every non-comment line is executed; no failing or surrogate cases are
/// silently skipped. Offsets in the fixture are converted to UTF-16.
async test "LineBreakTest.txt conformance" {
  let content = @support.read_data_file("LineBreakTest.txt")
  assert_true(content.has_prefix("# LineBreakTest-18.0.0.txt"))
  let mut cases = 0
  for line_number, raw_line in content.split("\n") {
    let line = raw_line.split_once("#").map(p => p.0).unwrap_or(raw_line).trim()
    if line.is_empty() {
      continue
    }
    let out = StringBuilder()
    let expected : Array[Int32] = []
    let mut offset = 0
    let mut expect_marker = true
    for token in line.split(" ") {
      let token = token.trim()
      if token.is_empty() {
        continue
      }
      if expect_marker {
        match token {
          "÷" => expected.push(offset)
          "×" => ()
          _ => fail("Expected boundary marker on line \{line_number + 1}")
        }
      } else {
        let cp = @support.parse_hex_int(token)
        guard cp >= 0 && cp <= 0x10FFFF && !(cp >= 0xD800 && cp <= 0xDFFF) else {
          fail(
            "Unsupported test code point on line \{line_number + 1}: \{token}",
          )
        }
        out.write_char(cp.unsafe_to_char())
        offset += if cp >= 0x10000 { 2 } else { 1 }
      }
      expect_marker = !expect_marker
    }
    assert_false(expect_marker, msg="Missing final boundary marker")
    let actual = @linebreak.line_breaks(out.to_string())
      .iter()
      .map(p => p.0)
      .collect()
    @debug.assert_eq(
      actual,
      expected,
      msg="LineBreakTest.txt line \{line_number + 1}: \{line}",
    )
    cases += 1
  }
  // Exact fixture count: deleting/skipping any test must fail.
  assert_eq(cases, 19346)
}
