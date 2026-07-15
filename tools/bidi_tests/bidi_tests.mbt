///|
pub(all) struct BidiCase {
  classes : Array[String]
  bitset : Int
  levels : Array[Int?]
  reorder : Array[Int]
}

///|
pub(all) struct CharacterCase {
  code_points : Array[Int]
  paragraph_direction : Int
  base_level : Int
  levels : Array[Int?]
  reorder : Array[Int]
}

///|
pub(all) struct GeneratedPart {
  relative_directory : String
  source : String
} derive(Debug, Eq)

///|
pub struct GeneratedParts {
  bidi_cases : Array[BidiCase]
  character_cases : Array[CharacterCase]
  part_size : Int
  mut phase : Int
  mut part_number : Int
  mut bidi_index : Int
  mut bidi_bit : Int
  mut character_index : Int
}

///|
fn parse_levels(text : StringView) -> Array[Int?] raise {
  let levels : Array[Int?] = []
  for part in text.trim().split(" ") {
    let part = part.trim()
    if part.is_empty() {
      continue
    }
    match part {
      "x" | "X" => levels.push(None)
      number => levels.push(Some(@support.parse_decimal_int(number)))
    }
  }
  levels
}

///|
fn parse_reorder(text : StringView) -> Array[Int] raise {
  let reorder : Array[Int] = []
  for part in text.trim().split(" ") {
    let part = part.trim()
    if !part.is_empty() {
      reorder.push(@support.parse_decimal_int(part))
    }
  }
  reorder
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
fn parse_bidi_cases(content : String) -> Array[BidiCase] raise {
  let cases : Array[BidiCase] = []
  let mut current_levels : Array[Int?] = []
  let mut current_reorder : Array[Int] = []
  for raw_line in content.split("\n") {
    let line = raw_line.trim()
    if line.is_empty() || line.has_prefix("#") {
      continue
    }
    match line.strip_prefix("@Levels:") {
      Some(levels) => {
        current_levels = parse_levels(levels)
        continue
      }
      None => ()
    }
    match line.strip_prefix("@Reorder:") {
      Some(reorder) => {
        current_reorder = parse_reorder(reorder)
        continue
      }
      None => ()
    }
    if line.has_prefix("@") {
      continue
    }
    match line.split(";").collect() {
      [classes_text, bitset_text, ..] => {
        let classes = parse_classes(classes_text)
        if classes.is_empty() {
          continue
        }
        cases.push({
          classes,
          bitset: @support.parse_decimal_int(bitset_text),
          levels: current_levels.copy(),
          reorder: current_reorder.copy(),
        })
      }
      _ => ()
    }
  }
  cases
}

///|
fn parse_character_cases(content : String) -> Array[CharacterCase] raise {
  let cases : Array[CharacterCase] = []
  for raw_line in content.split("\n") {
    let line = raw_line.trim()
    if line.is_empty() || line.has_prefix("#") {
      continue
    }
    match line.split(";").collect() {
      [code_points, paragraph_direction, base_level, levels, reorder, ..] =>
        cases.push({
          code_points: @support.parse_code_point_sequence(code_points),
          paragraph_direction: @support.parse_decimal_int(paragraph_direction),
          base_level: @support.parse_decimal_int(base_level),
          levels: parse_levels(levels),
          reorder: parse_reorder(reorder),
        })
      _ => ()
    }
  }
  cases
}

///|
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
fn classes_to_moonbit_string(classes : ArrayView[String]) -> String raise {
  let out = @emitter.Emitter::new()
  for class in classes {
    out.write(@support.moonbit_code_point_escape(class_code_point(class)))
  }
  out.finish()
}

///|
fn paragraph_level(bit : Int) -> Int {
  match bit {
    1 => -1
    2 => 0
    _ => 1
  }
}

///|
fn GeneratedParts::next_bidi_case(self : GeneratedParts) -> (BidiCase, Int)? {
  while self.bidi_index < self.bidi_cases.length() {
    let case = self.bidi_cases[self.bidi_index]
    while self.bidi_bit <= 4 {
      let bit = self.bidi_bit
      self.bidi_bit *= 2
      if (case.bitset & bit) != 0 {
        return Some((case, paragraph_level(bit)))
      }
    }
    self.bidi_index += 1
    self.bidi_bit = 1
  }
  None
}

///|
fn write_bidi_case(
  out : @emitter.Emitter,
  test_number : Int,
  case : BidiCase,
  para_level : Int,
) -> Unit raise {
  out.write("  {\n    number: ")
  out.write_int(test_number)
  out.write(",\n    input: \"")
  out.write(classes_to_moonbit_string(case.classes))
  out.write("\",\n    direction: ")
  write_direction_option(out, para_level)
  out.write(",\n    expected_levels: ")
  out.write(@support.optional_int_array_literal(case.levels))
  out.write(",\n    expected_reorder: ")
  out.write(@support.int_array_literal(case.reorder))
  out.write(",\n  },\n")
}

///|
fn write_character_case(
  out : @emitter.Emitter,
  test_number : Int,
  case : CharacterCase,
) -> Unit {
  out.write("  {\n    number: ")
  out.write_int(test_number)
  out.write(",\n    input: \"")
  out.write(@support.code_points_to_moonbit_string(case.code_points))
  out.write("\",\n    direction: ")
  write_direction_option(out, case.paragraph_direction)
  out.write(",\n    expected_base_level: ")
  out.write_int(case.base_level)
  out.write(",\n    expected_levels: ")
  out.write(@support.optional_int_array_literal(case.levels))
  out.write(",\n    expected_reorder: ")
  out.write(@support.int_array_literal(case.reorder))
  out.write(",\n  },\n")
}

///|
fn write_direction_option(
  out : @emitter.Emitter,
  paragraph_direction : Int,
) -> Unit {
  match paragraph_direction {
    0 => out.write("Some(@bidi.Direction::LTR)")
    1 => out.write("Some(@bidi.Direction::RTL)")
    _ => out.write("None")
  }
}

///|
fn write_bidi_test_header(out : @emitter.Emitter) -> Unit {
  out.write(
    (
      #|///|
      #|struct TestCase {
      #|  number : Int
      #|  input : String
      #|  direction : @bidi.Direction?
      #|  expected_levels : Array[Int]
      #|  expected_reorder : Array[Int]
      #|}
      #|
      #|///|
      #|let test_cases : Array[TestCase] = [
      #|
    ),
  )
}

///|
fn write_character_test_header(out : @emitter.Emitter) -> Unit {
  out.write(
    (
      #|///|
      #|struct TestCase {
      #|  number : Int
      #|  input : String
      #|  direction : @bidi.Direction?
      #|  expected_base_level : Int
      #|  expected_levels : Array[Int]
      #|  expected_reorder : Array[Int]
      #|}
      #|
      #|///|
      #|let test_cases : Array[TestCase] = [
      #|
    ),
  )
}

///|
fn write_bidi_test_runner(out : @emitter.Emitter, part_number : Int) -> Unit {
  out.write("]\n\n///|\ntest \"BidiTest.txt part ")
  out.write_int(part_number)
  out.write(
    (
      #|" {
      #|  for case in test_cases {
      #|    let direction = case.direction
      #|    let result = @bidi.process(case.input, direction?)
      #|    for index, expected_level in case.expected_levels {
      #|      if expected_level >= 0 {
      #|        @debug.assert_eq(
      #|          result.levels[index],
      #|          expected_level,
      #|          msg="case \{case.number}: resolved level at index \{index}",
      #|        )
      #|      }
      #|    }
      #|    @debug.assert_eq(
      #|      @bidi.reorder(result),
      #|      case.expected_reorder,
      #|      msg="case \{case.number}: visual reorder",
      #|    )
      #|  }
      #|}
      #|
    ),
  )
}

///|
fn write_character_test_runner(
  out : @emitter.Emitter,
  part_number : Int,
) -> Unit {
  out.write("]\n\n///|\ntest \"BidiCharacterTest.txt part ")
  out.write_int(part_number)
  out.write(
    (
      #|" {
      #|  for case in test_cases {
      #|    let direction = case.direction
      #|    let result = @bidi.process(case.input, direction?)
      #|    @debug.assert_eq(
      #|      result.base_level,
      #|      case.expected_base_level,
      #|      msg="case \{case.number}: paragraph base level",
      #|    )
      #|    for index, expected_level in case.expected_levels {
      #|      if expected_level >= 0 {
      #|        @debug.assert_eq(
      #|          result.levels[index],
      #|          expected_level,
      #|          msg="case \{case.number}: resolved level at index \{index}",
      #|        )
      #|      }
      #|    }
      #|    @debug.assert_eq(
      #|      @bidi.reorder(result),
      #|      case.expected_reorder,
      #|      msg="case \{case.number}: visual reorder",
      #|    )
      #|  }
      #|}
      #|
    ),
  )
}

///|
fn GeneratedParts::next_bidi_part(
  self : GeneratedParts,
) -> GeneratedPart? raise {
  let out = @emitter.Emitter::new()
  out.write(
    "///|\n/// Unicode Bidi Algorithm Conformance Tests - BidiTest.txt Part ",
  )
  out.write_int(self.part_number)
  out.write(
    (
      #|
      #|/// Generated from BidiTest.txt (Unicode 16.0.0)
      #|///
      #|/// Tests the implementation against official Unicode bidi test data.
      #|/// Each test verifies resolved embedding levels and visual reordering.
      #|
    ),
  )
  write_bidi_test_header(out)
  let mut count = 0
  while count < self.part_size {
    guard self.next_bidi_case() is Some((case, para_level)) else { break }
    write_bidi_case(
      out,
      self.part_number * self.part_size + count,
      case,
      para_level,
    )
    count += 1
  }
  if count == 0 {
    return None
  }
  let part_number = self.part_number
  write_bidi_test_runner(out, part_number)
  self.part_number += 1
  Some({
    relative_directory: "conformance/bidi/bidi/part\{part_number}",
    source: out.finish(),
  })
}

///|
fn GeneratedParts::next_character_part(self : GeneratedParts) -> GeneratedPart? {
  if self.character_index >= self.character_cases.length() {
    return None
  }
  let out = @emitter.Emitter::new()
  out.write(
    "///|\n/// Unicode Bidi Algorithm Conformance Tests - BidiCharacterTest.txt Part ",
  )
  out.write_int(self.part_number)
  out.write(
    (
      #|
      #|/// Generated from BidiCharacterTest.txt (Unicode 16.0.0)
      #|///
      #|/// Tests the implementation with actual Unicode characters including
      #|/// bracket pairs and other character-specific behaviors.
      #|
    ),
  )
  write_character_test_header(out)
  let mut count = 0
  while count < self.part_size &&
        self.character_index < self.character_cases.length() {
    write_character_case(
      out,
      self.part_number * self.part_size + count,
      self.character_cases[self.character_index],
    )
    self.character_index += 1
    count += 1
  }
  let part_number = self.part_number
  write_character_test_runner(out, part_number)
  self.part_number += 1
  Some({
    relative_directory: "conformance/bidi/character/part\{part_number}",
    source: out.finish(),
  })
}

///|
pub fn GeneratedParts::next(self : GeneratedParts) -> GeneratedPart? raise {
  for ;; {
    match self.phase {
      0 =>
        match self.next_bidi_part() {
          Some(part) => break Some(part)
          None => {
            self.phase = 1
            self.part_number = 0
            continue
          }
        }
      1 =>
        match self.next_character_part() {
          Some(part) => break Some(part)
          None => {
            self.phase = 2
            continue
          }
        }
      _ => break None
    }
  }
}

///|
pub fn generate_parts(
  bidi_content : String,
  character_content : String,
  part_size : Int,
) -> GeneratedParts raise {
  guard part_size > 0 else { fail("part_size must be positive") }
  {
    bidi_cases: parse_bidi_cases(bidi_content),
    character_cases: parse_character_cases(character_content),
    part_size,
    phase: 0,
    part_number: 0,
    bidi_index: 0,
    bidi_bit: 1,
    character_index: 0,
  }
}

///|
pub fn package_source() -> String {
  (
    #|import {
    #|  "tonyfettes/bidi" @bidi,
    #|  "moonbitlang/core/debug",
    #|} for "test"
    #|
  )
}
