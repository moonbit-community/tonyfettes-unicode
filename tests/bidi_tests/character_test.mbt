///|
/// Unicode Bidirectional Algorithm conformance tests, read directly from
/// BidiCharacterTest.txt (Unicode 16.0.0).
/// Source: https://www.unicode.org/Public/16.0.0/ucd/BidiCharacterTest.txt

///|
/// Paragraph direction field of BidiCharacterTest.txt:
/// 0 = LTR, 1 = RTL, 2 = auto.
fn level_paragraph_direction(level : Int) -> @bidi.Direction? {
  match level {
    0 => Some(@bidi.Direction::LTR)
    1 => Some(@bidi.Direction::RTL)
    _ => None
  }
}

///|
async test "BidiCharacterTest.txt conformance" {
  let content = @support.read_data_file("BidiCharacterTest.txt")
  for line_number, raw_line in content.split("\n") {
    let line = raw_line.trim()
    if line.is_empty() || line.has_prefix("#") {
      continue
    }
    guard line.split(";").collect()
      is [
        code_points_text,
        paragraph_direction_text,
        base_level_text,
        levels_text,
        reorder_text,
        ..,
      ] else {
      continue
    }
    let code_points = @support.parse_code_point_sequence(code_points_text)
    guard @support.code_points_to_string(code_points) is Some(input) else {
      continue
    }
    let direction = level_paragraph_direction(
      @support.parse_decimal_int(paragraph_direction_text),
    )
    let expected_base_level = @support.parse_decimal_int(base_level_text)
    let expected_levels = @support.parse_levels(levels_text)
    let expected_reorder = @support.parse_reorder(reorder_text)
    let result = @bidi.process(input, direction?)
    @debug.assert_eq(
      result.base_level,
      expected_base_level,
      msg="BidiCharacterTest.txt line \{line_number + 1}: paragraph base level",
    )
    for index, expected_level in expected_levels {
      if expected_level >= 0 {
        @debug.assert_eq(
          result.levels[index],
          expected_level,
          msg="BidiCharacterTest.txt line \{line_number + 1}: resolved level at index \{index}",
        )
      }
    }
    @debug.assert_eq(
      @bidi.reorder(result),
      expected_reorder,
      msg="BidiCharacterTest.txt line \{line_number + 1}: visual reorder",
    )
  }
}
