///|
/// Unicode Text Segmentation conformance tests for extended grapheme
/// clusters, read directly from GraphemeBreakTest.txt (Unicode 16.0.0).
/// Source: https://www.unicode.org/Public/16.0.0/ucd/auxiliary/GraphemeBreakTest.txt

///|
/// Parse one test line such as `÷ 0020 × 0308 ÷ 0020 ÷` into its clusters:
/// `÷` marks a boundary and `×` joins the surrounding code points. Returns
/// `None` if a cluster contains a surrogate, which MoonBit strings cannot
/// represent.
fn parse_clusters(line : StringView) -> Array[String]? raise {
  let clusters : Array[String] = []
  let code_points : Array[Int] = []
  for token in line.split(" ") {
    match token.trim() {
      "" | "×" => ()
      "÷" =>
        if !code_points.is_empty() {
          guard @support.code_points_to_string(code_points) is Some(cluster) else {
            return None
          }
          clusters.push(cluster)
          code_points.clear()
        }
      code_point => code_points.push(@support.parse_hex_int(code_point))
    }
  }
  Some(clusters)
}

///|
async test "GraphemeBreakTest.txt conformance" {
  let content = @support.read_data_file("GraphemeBreakTest.txt")
  let mut cases = 0
  for line_number, raw_line in content.split("\n") {
    let line = match raw_line.split_once("#") {
      Some((before, _)) => before.trim()
      None => raw_line.trim()
    }
    if line.is_empty() {
      continue
    }
    guard parse_clusters(line) is Some(expected) else { continue }
    let input = expected.join("")
    let actual = @segmentation.graphemes(input)
      .map(cluster => cluster.to_owned())
      .collect()
    @debug.assert_eq(
      actual,
      expected,
      msg="GraphemeBreakTest.txt line \{line_number + 1}",
    )
    cases += 1
  }
  // Guard against a parser that silently skips every line.
  assert_true(cases > 1000)
}
