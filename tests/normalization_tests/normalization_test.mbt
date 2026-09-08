///|
/// Unicode normalization conformance tests, read directly from
/// NormalizationTest.txt (Unicode 16.0.0).
/// Source: https://www.unicode.org/Public/16.0.0/ucd/NormalizationTest.txt
///
/// Each line contains five strings (c1..c5) that must satisfy:
/// - NFC:  c2 == NFC(c1) == NFC(c2) == NFC(c3)
/// - NFD:  c3 == NFD(c1) == NFD(c2) == NFD(c3)
/// - NFKC: c4 == NFKC(c1) == NFKC(c2) == NFKC(c3) == NFKC(c4) == NFKC(c5)
/// - NFKD: c5 == NFKD(c1) == NFKD(c2) == NFKD(c3) == NFKD(c4) == NFKD(c5)

///|
struct NormalizationCase {
  line_number : Int
  c1 : String
  c2 : String
  c3 : String
  c4 : String
  c5 : String
}

///|
fn parse_field(field : StringView) -> String? raise {
  @support.code_points_to_string(@support.parse_code_point_sequence(field))
}

///|
fn parse_case(line : StringView, line_number : Int) -> NormalizationCase? raise {
  let line = line.trim()
  if line.is_empty() || line.has_prefix("#") || line.has_prefix("@") {
    return None
  }
  guard line.split(";").collect() is [c1, c2, c3, c4, c5, ..] else {
    return None
  }
  guard parse_field(c1) is Some(c1) else { return None }
  guard parse_field(c2) is Some(c2) else { return None }
  guard parse_field(c3) is Some(c3) else { return None }
  guard parse_field(c4) is Some(c4) else { return None }
  guard parse_field(c5) is Some(c5) else { return None }
  Some({ line_number, c1, c2, c3, c4, c5, })
}

///|
fn parse_cases(content : String) -> Array[NormalizationCase] raise {
  let cases : Array[NormalizationCase] = []
  for line_number, raw_line in content.split("\n") {
    if parse_case(raw_line, line_number + 1) is Some(case) {
      cases.push(case)
    }
  }
  cases
}

///|
async test "NormalizationTest.txt - NFC" {
  for case in parse_cases(@support.read_data_file("NormalizationTest.txt")) {
    @debug.assert_eq(
      @normalization.nfc(case.c1),
      case.c2,
      msg="NormalizationTest.txt line \{case.line_number}: NFC(c1) != c2",
    )
    @debug.assert_eq(
      @normalization.nfc(case.c2),
      case.c2,
      msg="NormalizationTest.txt line \{case.line_number}: NFC(c2) != c2",
    )
    @debug.assert_eq(
      @normalization.nfc(case.c3),
      case.c2,
      msg="NormalizationTest.txt line \{case.line_number}: NFC(c3) != c2",
    )
  }
}

///|
async test "NormalizationTest.txt - NFD" {
  for case in parse_cases(@support.read_data_file("NormalizationTest.txt")) {
    @debug.assert_eq(
      @normalization.nfd(case.c1),
      case.c3,
      msg="NormalizationTest.txt line \{case.line_number}: NFD(c1) != c3",
    )
    @debug.assert_eq(
      @normalization.nfd(case.c2),
      case.c3,
      msg="NormalizationTest.txt line \{case.line_number}: NFD(c2) != c3",
    )
    @debug.assert_eq(
      @normalization.nfd(case.c3),
      case.c3,
      msg="NormalizationTest.txt line \{case.line_number}: NFD(c3) != c3",
    )
  }
}

///|
async test "NormalizationTest.txt - NFKC" {
  for case in parse_cases(@support.read_data_file("NormalizationTest.txt")) {
    @debug.assert_eq(
      @normalization.nfkc(case.c1),
      case.c4,
      msg="NormalizationTest.txt line \{case.line_number}: NFKC(c1) != c4",
    )
    @debug.assert_eq(
      @normalization.nfkc(case.c2),
      case.c4,
      msg="NormalizationTest.txt line \{case.line_number}: NFKC(c2) != c4",
    )
    @debug.assert_eq(
      @normalization.nfkc(case.c3),
      case.c4,
      msg="NormalizationTest.txt line \{case.line_number}: NFKC(c3) != c4",
    )
    @debug.assert_eq(
      @normalization.nfkc(case.c4),
      case.c4,
      msg="NormalizationTest.txt line \{case.line_number}: NFKC(c4) != c4",
    )
    @debug.assert_eq(
      @normalization.nfkc(case.c5),
      case.c4,
      msg="NormalizationTest.txt line \{case.line_number}: NFKC(c5) != c4",
    )
  }
}

///|
async test "NormalizationTest.txt - NFKD" {
  for case in parse_cases(@support.read_data_file("NormalizationTest.txt")) {
    @debug.assert_eq(
      @normalization.nfkd(case.c1),
      case.c5,
      msg="NormalizationTest.txt line \{case.line_number}: NFKD(c1) != c5",
    )
    @debug.assert_eq(
      @normalization.nfkd(case.c2),
      case.c5,
      msg="NormalizationTest.txt line \{case.line_number}: NFKD(c2) != c5",
    )
    @debug.assert_eq(
      @normalization.nfkd(case.c3),
      case.c5,
      msg="NormalizationTest.txt line \{case.line_number}: NFKD(c3) != c5",
    )
    @debug.assert_eq(
      @normalization.nfkd(case.c4),
      case.c5,
      msg="NormalizationTest.txt line \{case.line_number}: NFKD(c4) != c5",
    )
    @debug.assert_eq(
      @normalization.nfkd(case.c5),
      case.c5,
      msg="NormalizationTest.txt line \{case.line_number}: NFKD(c5) != c5",
    )
  }
}
