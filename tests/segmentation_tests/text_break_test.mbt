///|
/// Official Unicode 18.0.0 cases from
/// https://www.unicode.org/Public/18.0.0/ucd/auxiliary/WordBreakTest.txt and
/// https://www.unicode.org/Public/18.0.0/ucd/auxiliary/SentenceBreakTest.txt.
async fn check_text_breaks(
  filename : String,
  segment : (StringView) -> Iter[StringView],
  expected_cases : Int32,
) -> Unit {
  let content = @support.read_data_file(filename)
  let mut cases = 0
  for line_number, raw_line in content.split("\n") {
    let line = if raw_line.split_once("#") is Some((before, _)) {
      before.trim()
    } else {
      raw_line.trim()
    }
    if line.is_empty() {
      continue
    }
    guard parse_boundary_segments(line) is Some(expected) else {
      fail("Unexpected surrogate in \{filename} line \{line_number + 1}")
    }
    let input = expected.join("")
    @debug.assert_eq(
      segment(input).map(s => s.to_owned()).collect(),
      expected,
      msg="\{filename} line \{line_number + 1}",
    )
    cases += 1
  }
  assert_eq(cases, expected_cases)
}

///|
async test "WordBreakTest.txt conformance" {
  check_text_breaks(
    "WordBreakTest.txt",
    text => @segmentation.word_segments(text).iter(),
    1944,
  )
}

///|
async test "SentenceBreakTest.txt conformance" {
  check_text_breaks(
    "SentenceBreakTest.txt",
    text => @segmentation.sentences(text).iter(),
    512,
  )
}
