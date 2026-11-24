///|
/// Parse the expected Mandatory/Allowed break kinds from the `#` comment of a
/// LineBreakTest.txt line, where every `÷` is followed by `[rule]`.
/// Rules LB3 (EOT), LB4 (BK !), and LB5 (CR/LF/NL !) are Mandatory; all other
/// break rules are Allowed.
fn parse_expected_kinds(
  comment : StringView,
  line_number : Int32,
) -> Array[@segmentation.BreakOpportunity] raise {
  let kinds : Array[@segmentation.BreakOpportunity] = []
  let mut first = true
  for part in comment.split("÷") {
    if first {
      first = false
      continue
    }
    let trimmed = part.trim()
    guard trimmed.strip_prefix("[") is Some(after_open) &&
      after_open.split_once("]") is Some((rule, _)) else {
      fail("Missing rule number after ÷ on line \{line_number + 1}")
    }
    let kind : @segmentation.BreakOpportunity = match rule {
      "3.0" | "4.0" | "5.02" | "5.03" | "5.04" => Mandatory
      "8.0" | "15.3" | "18.0" | "20.01" | "20.02" | "30.13" | "31.01" => Allowed
      _ =>
        fail("Unknown UAX #14 break rule [\{rule}] on line \{line_number + 1}")
    }
    kinds.push(kind)
  }
  kinds
}

///|
/// Default UAX #14 conformance, Unicode 18.0.0:
/// https://www.unicode.org/Public/18.0.0/ucd/auxiliary/LineBreakTest.txt
/// Every non-comment line is executed; no failing or surrogate cases are
/// silently skipped. Offsets in the fixture are converted to UTF-16, and every
/// boundary's Mandatory vs Allowed kind is checked against the fixture's rule
/// numbers.
async test "LineBreakTest.txt conformance" {
  let content = @support.read_data_file("LineBreakTest.txt")
  assert_true(content.has_prefix("# LineBreakTest-18.0.0.txt"))
  let mut cases = 0
  let mut total_breaks = 0
  for line_number, raw_line in content.split("\n") {
    let (data_part, comment_part) = match raw_line.split_once("#") {
      Some((before, after)) => (before.trim(), after)
      None => (raw_line.trim(), "".to_string_view())
    }
    if data_part.is_empty() {
      continue
    }
    let out = StringBuilder()
    let expected : Array[Int32] = []
    let mut offset = 0
    let mut expect_marker = true
    for token in data_part.split(" ") {
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
    let expected_kinds = parse_expected_kinds(comment_part, line_number)
    assert_eq(
      expected_kinds.length(),
      expected.length(),
      msg="Mismatched ÷ count in comment on line \{line_number + 1}",
    )
    let text = out.to_string().to_string_view()
    let breaks = @segmentation.line_breaks(text)
    let actual = []
    let kinds = []
    let mut previous_end = text.start_offset()
    for segment in breaks {
      assert_eq(segment.start_offset(), previous_end)
      assert_false(segment.is_empty())
      previous_end += segment.length()
      actual.push(previous_end - text.start_offset())
      kinds.push(breaks.opportunity())
    }
    assert_eq(previous_end, text.start_offset() + text.length())
    @debug.assert_eq(
      actual,
      expected,
      msg="LineBreakTest.txt line \{line_number + 1}: \{data_part}",
    )
    @debug.assert_eq(
      kinds,
      expected_kinds,
      msg="Break kind mismatch on LineBreakTest.txt line \{line_number + 1}: \{data_part}",
    )
    // The combined cursor must expose exactly the default opportunities at
    // complete UAX #29 cluster ends, without changing either segmentation.
    let graphemes = @segmentation.graphemes(text)
    let mut point = 0
    for grapheme in graphemes {
      let end = grapheme.start_offset() -
        text.start_offset() +
        grapheme.length()
      while point < expected.length() && expected[point] < end {
        point += 1
      }
      let kind = if point < expected.length() && expected[point] == end {
        expected_kinds[point]
      } else {
        @segmentation.Prohibited
      }
      @debug.assert_eq(
        graphemes.line_break(),
        kind,
        msg="Grapheme ending at \{end}, LineBreakTest.txt line \{line_number + 1}",
      )
    }
    cases += 1
    total_breaks += expected.length()
  }
  // Exact fixture counts: deleting/skipping any test must fail.
  assert_eq(cases, 19346)
  assert_eq(total_breaks, 32021)
}
