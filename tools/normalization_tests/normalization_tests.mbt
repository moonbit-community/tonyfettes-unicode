///|
priv struct NormalizationCase {
  c1 : String
  c2 : String
  c3 : String
  c4 : String
  c5 : String
}

///|
priv struct Section {
  id : String
  name : String
  cases : Array[NormalizationCase]
}

///|
fn parse_section_marker(line : StringView) -> (String, String)? {
  guard line.strip_prefix("@") is Some(marker) else { return None }
  match marker.split_once("#") {
    Some((id, name)) => Some((id.trim().to_owned(), name.trim().to_owned()))
    None => Some((marker.trim().to_owned(), ""))
  }
}

///|
fn parse_case(line : StringView) -> NormalizationCase? raise {
  let line = @support.strip_comment(line)
  guard !line.is_empty() else { return None }
  match line.split(";").collect() {
    [c1, c2, c3, c4, c5, ..] =>
      Some({
        c1: @support.code_points_to_moonbit_string(
          @support.parse_code_point_sequence(c1),
        ),
        c2: @support.code_points_to_moonbit_string(
          @support.parse_code_point_sequence(c2),
        ),
        c3: @support.code_points_to_moonbit_string(
          @support.parse_code_point_sequence(c3),
        ),
        c4: @support.code_points_to_moonbit_string(
          @support.parse_code_point_sequence(c4),
        ),
        c5: @support.code_points_to_moonbit_string(
          @support.parse_code_point_sequence(c5),
        ),
      })
    _ => None
  }
}

///|
fn parse_sections(content : String) -> Array[Section] raise {
  let sections : Array[Section] = []
  let mut current_cases : Array[NormalizationCase]? = None
  for raw_line in content.split("\n") {
    let line = raw_line.trim()
    if line.has_prefix("@Part") {
      guard parse_section_marker(line) is Some((id, name)) else { continue }
      let cases : Array[NormalizationCase] = []
      sections.push({ id, name, cases })
      current_cases = Some(cases)
      continue
    }
    guard current_cases is Some(cases) else { continue }
    if parse_case(line) is Some(case) {
      cases.push(case)
    }
  }
  sections
}

///|
fn write_case(
  out : @emitter.Emitter,
  case : NormalizationCase,
  first : Bool,
) -> Unit {
  if !first {
    out.write(",\n")
  }
  out.write("  (\"")
  out.write(case.c1)
  out.write("\", \"")
  out.write(case.c2)
  out.write("\", \"")
  out.write(case.c3)
  out.write("\", \"")
  out.write(case.c4)
  out.write("\", \"")
  out.write(case.c5)
  out.write("\")")
}

///|
fn write_test_body(
  out : @emitter.Emitter,
  section : Section,
  part : String,
) -> Unit {
  out.write(
    (
      #|
      #|]
      #|
      #|///|
      #|test "conformance: NormalizationTest.txt
    ),
  )
  out.write_char(' ')
  out.write(section.id)
  out.write(
    (
      #| - NFC" {
      #|  for i, t in conformance_test_data_part
    ),
  )
  out.write(part)
  out.write(
    (
      #| {
      #|    let (c1, c2, c3, _, _) = t
      #|    // NFC invariants: c2 == NFC(c1) == NFC(c2) == NFC(c3)
      #|    let nfc_c1 = @normalization.nfc(c1)
      #|    let nfc_c2 = @normalization.nfc(c2)
      #|    let nfc_c3 = @normalization.nfc(c3)
      #|    assert_eq(nfc_c1, c2, msg="NFC(c1) != c2 at index \{i}")
      #|    assert_eq(nfc_c2, c2, msg="NFC(c2) != c2 at index \{i}")
      #|    assert_eq(nfc_c3, c2, msg="NFC(c3) != c2 at index \{i}")
      #|  }
      #|}
      #|
      #|///|
      #|test "conformance: NormalizationTest.txt
    ),
  )
  out.write_char(' ')
  out.write(section.id)
  out.write(
    (
      #| - NFD" {
      #|  for i, t in conformance_test_data_part
    ),
  )
  out.write(part)
  out.write(
    (
      #| {
      #|    let (c1, c2, c3, _, _) = t
      #|    // NFD invariants: c3 == NFD(c1) == NFD(c2) == NFD(c3)
      #|    let nfd_c1 = @normalization.nfd(c1)
      #|    let nfd_c2 = @normalization.nfd(c2)
      #|    let nfd_c3 = @normalization.nfd(c3)
      #|    assert_eq(nfd_c1, c3, msg="NFD(c1) != c3 at index \{i}")
      #|    assert_eq(nfd_c2, c3, msg="NFD(c2) != c3 at index \{i}")
      #|    assert_eq(nfd_c3, c3, msg="NFD(c3) != c3 at index \{i}")
      #|  }
      #|}
      #|
      #|///|
      #|test "conformance: NormalizationTest.txt
    ),
  )
  out.write_char(' ')
  out.write(section.id)
  out.write(
    (
      #| - NFKC" {
      #|  for i, t in conformance_test_data_part
    ),
  )
  out.write(part)
  out.write(
    (
      #| {
      #|    let (c1, c2, c3, c4, c5) = t
      #|    // NFKC invariants: c4 == NFKC(c1) == NFKC(c2) == NFKC(c3) == NFKC(c4) == NFKC(c5)
      #|    let nfkc_c1 = @normalization.nfkc(c1)
      #|    let nfkc_c2 = @normalization.nfkc(c2)
      #|    let nfkc_c3 = @normalization.nfkc(c3)
      #|    let nfkc_c4 = @normalization.nfkc(c4)
      #|    let nfkc_c5 = @normalization.nfkc(c5)
      #|    assert_eq(nfkc_c1, c4, msg="NFKC(c1) != c4 at index \{i}")
      #|    assert_eq(nfkc_c2, c4, msg="NFKC(c2) != c4 at index \{i}")
      #|    assert_eq(nfkc_c3, c4, msg="NFKC(c3) != c4 at index \{i}")
      #|    assert_eq(nfkc_c4, c4, msg="NFKC(c4) != c4 at index \{i}")
      #|    assert_eq(nfkc_c5, c4, msg="NFKC(c5) != c4 at index \{i}")
      #|  }
      #|}
      #|
      #|///|
      #|test "conformance: NormalizationTest.txt
    ),
  )
  out.write_char(' ')
  out.write(section.id)
  out.write(
    (
      #| - NFKD" {
      #|  for i, t in conformance_test_data_part
    ),
  )
  out.write(part)
  out.write(
    (
      #| {
      #|    let (c1, c2, c3, c4, c5) = t
      #|    // NFKD invariants: c5 == NFKD(c1) == NFKD(c2) == NFKD(c3) == NFKD(c4) == NFKD(c5)
      #|    let nfkd_c1 = @normalization.nfkd(c1)
      #|    let nfkd_c2 = @normalization.nfkd(c2)
      #|    let nfkd_c3 = @normalization.nfkd(c3)
      #|    let nfkd_c4 = @normalization.nfkd(c4)
      #|    let nfkd_c5 = @normalization.nfkd(c5)
      #|    assert_eq(nfkd_c1, c5, msg="NFKD(c1) != c5 at index \{i}")
      #|    assert_eq(nfkd_c2, c5, msg="NFKD(c2) != c5 at index \{i}")
      #|    assert_eq(nfkd_c3, c5, msg="NFKD(c3) != c5 at index \{i}")
      #|    assert_eq(nfkd_c4, c5, msg="NFKD(c4) != c5 at index \{i}")
      #|    assert_eq(nfkd_c5, c5, msg="NFKD(c5) != c5 at index \{i}")
      #|  }
      #|}
      #|
    ),
  )
}

///|
fn generate_section_source(section : Section) -> String {
  let part = section.id.replace_all(old="Part", new="")
  let out = @emitter.Emitter::new()
  out.write("///|\n/// Unicode Normalization Conformance Tests - ")
  out.write(section.id)
  out.write(
    "\n/// Generated from NormalizationTest.txt (Unicode 16.0.0)\n///\n/// ",
  )
  out.write(section.name)
  out.write(
    (
      #|
      #|///
      #|/// Each test case contains 5 strings (c1, c2, c3, c4, c5) and must satisfy:
      #|/// - NFC: c2 == NFC(c1) == NFC(c2) == NFC(c3)
      #|/// - NFD: c3 == NFD(c1) == NFD(c2) == NFD(c3)
      #|/// - NFKC: c4 == NFKC(c1) == NFKC(c2) == NFKC(c3) == NFKC(c4) == NFKC(c5)
      #|/// - NFKD: c5 == NFKD(c1) == NFKD(c2) == NFKD(c3) == NFKD(c4) == NFKD(c5)
      #|
      #|///|
      #|/// Test data from NormalizationTest.txt (
    ),
  )
  out.write(section.id)
  out.write(": ")
  out.write(section.name)
  out.write(
    ")\n/// Format: (c1, c2, c3, c4, c5)\nlet conformance_test_data_part",
  )
  out.write(part)
  out.write(" : Array[(String, String, String, String, String)] = [\n")
  for index, case in section.cases {
    write_case(out, case, index == 0)
  }
  write_test_body(out, section, part)
  out.finish()
}

///|
pub fn generate_files(content : String) -> Array[@support.GeneratedFile] raise {
  let files : Array[@support.GeneratedFile] = []
  for section in parse_sections(content) {
    if section.cases.is_empty() {
      continue
    }
    let part = section.id.replace_all(old="Part", new="")
    files.push({
      relative_path: "normalization/conformance_part\{part}_test.mbt",
      source: generate_section_source(section),
    })
  }
  files
}
