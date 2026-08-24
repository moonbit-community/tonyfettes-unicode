///|
/// Unicode Bidirectional Algorithm conformance tests, read directly from
/// BidiTest.txt (Unicode 16.0.0).
/// Source: https://www.unicode.org/Public/16.0.0/ucd/BidiTest.txt
///
/// Each test case declares a sequence of bidi classes and a bitset of
/// paragraph levels; the implementation must resolve embedding levels and
/// visual reordering exactly as listed in the `@Levels`/`@Reorder` sections.

///|
/// Representative code point for each bidi class used by BidiTest.txt.
fn class_code_point(class : StringView) -> Int raise {
  match class {
    "L" => 0x0061
    "R" => 0x05D0
    "AL" => 0x0627
    "EN" => 0x0030
    "ES" => 0x002B
    "ET" => 0x0024
    "AN" => 0x0660
    "CS" => 0x002C
    "NSM" => 0x0300
    "BN" => 0x200B
    "B" => 0x000A
    "S" => 0x0009
    "WS" => 0x0020
    "ON" => 0x0021
    "LRE" => 0x202A
    "LRO" => 0x202D
    "RLE" => 0x202B
    "RLO" => 0x202E
    "PDF" => 0x202C
    "LRI" => 0x2066
    "RLI" => 0x2067
    "FSI" => 0x2068
    "PDI" => 0x2069
    _ => fail("Unknown bidi class: \{class}")
  }
}

///|
fn parse_classes(text : StringView) -> Array[String] {
  let classes : Array[String] = []
  for class in text.trim().split(" ") {
    let class = class.trim()
    if !class.is_empty() {
      classes.push(class.to_owned())
    }
  }
  classes
}

///|
fn classes_to_string(classes : ArrayView[String]) -> String raise {
  let out = StringBuilder()
  for class in classes {
    out.write_char(class_code_point(class).unsafe_to_char())
  }
  out.to_string()
}

///|
/// Paragraph direction implied by a BidiTest.txt bitset bit:
/// 1 = auto, 2 = LTR, 4 = RTL.
fn bit_paragraph_direction(bit : Int) -> @bidi.Direction? {
  match bit {
    1 => None
    2 => Some(@bidi.Direction::LTR)
    _ => Some(@bidi.Direction::RTL)
  }
}

///|
fn check_case(
  input : String,
  direction : @bidi.Direction?,
  expected_levels : Array[Int],
  expected_reorder : Array[Int],
  line : Int,
) -> Unit raise {
  let result = @bidi.process(input, direction?)
  for index, expected_level in expected_levels {
    if expected_level >= 0 {
      @debug.assert_eq(
        result.levels[index],
        expected_level,
        msg="BidiTest.txt line \{line}: resolved level at index \{index}",
      )
    }
  }
  @debug.assert_eq(
    @bidi.reorder(result),
    expected_reorder,
    msg="BidiTest.txt line \{line}: visual reorder",
  )
}

///|
async test "BidiTest.txt conformance" {
  let content = @support.read_data_file("BidiTest.txt")
  let mut current_levels : Array[Int] = []
  let mut current_reorder : Array[Int] = []
  for line_number, raw_line in content.split("\n") {
    let line = raw_line.trim()
    if line.is_empty() || line.has_prefix("#") {
      continue
    }
    if line.strip_prefix("@Levels:") is Some(levels) {
      current_levels = @support.parse_levels(levels)
      continue
    }
    if line.strip_prefix("@Reorder:") is Some(reorder) {
      current_reorder = @support.parse_reorder(reorder)
      continue
    }
    if line.has_prefix("@") {
      continue
    }
    guard line.split(";").collect() is [classes_text, bitset_text, ..] else {
      continue
    }
    let classes = parse_classes(classes_text)
    if classes.is_empty() {
      continue
    }
    let bitset = @support.parse_decimal_int(bitset_text)
    let input = classes_to_string(classes)
    for bit in [1, 2, 4] {
      if (bitset & bit) != 0 {
        check_case(
          input,
          bit_paragraph_direction(bit),
          current_levels,
          current_reorder,
          line_number + 1,
        )
      }
    }
  }
}
