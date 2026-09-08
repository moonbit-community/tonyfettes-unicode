///|
/// IDNA (UTS #46) conformance tests, read directly from IdnaTestV2.txt
/// (Unicode 16.0.0).
/// Source: https://www.unicode.org/Public/idna/16.0.0/IdnaTestV2.txt
///
/// Each line is `source; toUnicode; toUnicodeStatus; toAscii; toAsciiStatus`.
/// Cases whose status list only contains codes tied to a validation flag are
/// expected to fail exactly when those flags are enabled; cases with
/// flag-independent status codes fail unconditionally.

///|
struct TestCase {
  line_number : Int
  source : String
  to_ascii : String
  status : Array[String]
}

///|
struct RequiredFlags {
  check_bidi : Bool
  check_joiners : Bool
  check_hyphens : Bool
  use_std3_ascii_rules : Bool
  verify_dns_length : Bool
}

///|
fn parse_test_line(line : StringView, line_number : Int) -> TestCase? {
  let line = line.trim()
  if line.is_empty() || line.has_prefix("#") {
    return None
  }
  guard line.split(";").collect()
    is [
      source_text,
      unicode_text,
      unicode_status_text,
      ascii_text,
      ascii_status_text,
      ..,
    ] else {
    return None
  }
  let source = @support.parse_escaped_text(source_text.trim())
  let unicode = @support.parse_escaped_text(unicode_text.trim())
  let ascii = @support.parse_escaped_text(ascii_text.trim())
  let to_unicode = if unicode.text.is_empty() {
    source.text
  } else {
    unicode.text
  }
  let to_ascii = if ascii.text.is_empty() { to_unicode } else { ascii.text }
  let to_ascii_has_surrogate = if ascii.text.is_empty() {
    if unicode.text.is_empty() {
      source.has_surrogate
    } else {
      unicode.has_surrogate
    }
  } else {
    ascii.has_surrogate
  }
  let unicode_status = @support.parse_status(unicode_status_text).unwrap_or([])
  let ascii_status = @support.parse_status(ascii_status_text).unwrap_or(
    unicode_status,
  )
  if source.has_surrogate || to_ascii_has_surrogate {
    return None
  }
  Some({ line_number, source: source.text, to_ascii, status: ascii_status, })
}

///|
fn flag_for_status(status : StringView) -> String? {
  match status {
    "B1" | "B2" | "B3" | "B4" | "B5" | "B6" => Some("check_bidi")
    "C1" | "C2" => Some("check_joiners")
    "V2" | "V3" => Some("check_hyphens")
    "V4" | "U1" => Some("use_std3_ascii_rules")
    "A4_1" | "A4_2" => Some("verify_dns_length")
    _ => None
  }
}

///|
fn required_flags(statuses : ArrayView[String]) -> RequiredFlags {
  let mut check_bidi = false
  let mut check_joiners = false
  let mut check_hyphens = false
  let mut use_std3_ascii_rules = false
  let mut verify_dns_length = false
  for status in statuses {
    match flag_for_status(status) {
      Some("check_bidi") => check_bidi = true
      Some("check_joiners") => check_joiners = true
      Some("check_hyphens") => check_hyphens = true
      Some("use_std3_ascii_rules") => use_std3_ascii_rules = true
      Some("verify_dns_length") => verify_dns_length = true
      _ => ()
    }
  }
  {
    check_bidi,
    check_joiners,
    check_hyphens,
    use_std3_ascii_rules,
    verify_dns_length,
  }
}

///|
fn RequiredFlags::any(self : RequiredFlags) -> Bool {
  self.check_bidi ||
  self.check_joiners ||
  self.check_hyphens ||
  self.use_std3_ascii_rules ||
  self.verify_dns_length
}

///|
fn has_flag_independent_error(statuses : ArrayView[String]) -> Bool {
  statuses.any(status => flag_for_status(status) is None)
}

///|
let no_flags : RequiredFlags = {
  check_bidi: false,
  check_joiners: false,
  check_hyphens: false,
  use_std3_ascii_rules: false,
  verify_dns_length: false,
}

///|
fn call_to_ascii(
  source : String,
  flags : RequiredFlags,
) -> String raise @idna.IdnaError {
  @idna.to_ascii(
    source,
    use_std3_ascii_rules=flags.use_std3_ascii_rules,
    check_hyphens=flags.check_hyphens,
    check_bidi=flags.check_bidi,
    check_joiners=flags.check_joiners,
    verify_dns_length=flags.verify_dns_length,
  )
}

///|
fn assert_success(case : TestCase) -> Unit raise {
  let result = call_to_ascii(case.source, no_flags)
  @debug.assert_eq(
    result,
    case.to_ascii,
    msg="IdnaTestV2.txt line \{case.line_number}: to_ascii mismatch",
  )
}

///|
/// Assert that `to_ascii` raises for the case with the given flags. The try
/// body can only raise `IdnaError`, so any error escaping it is the expected
/// failure; a successful call falls through to `fail` with the line number.
fn assert_failure(case : TestCase, flags : RequiredFlags) -> Unit raise {
  try {
    let _ = call_to_ascii(case.source, flags)
  } catch {
    _ => return
  }
  fail("IdnaTestV2.txt line \{case.line_number}: expected to_ascii to fail")
}

///|
async test "IdnaTestV2.txt conformance" {
  let content = @support.read_data_file("IdnaTestV2.txt")
  for line_number, raw_line in content.split("\n") {
    guard parse_test_line(raw_line, line_number + 1) is Some(case) else {
      continue
    }
    if case.status.is_empty() {
      assert_success(case)
      continue
    }
    let flags = required_flags(case.status)
    if flags.any() {
      assert_failure(case, flags)
    } else if has_flag_independent_error(case.status) {
      assert_failure(case, no_flags)
    } else {
      assert_success(case)
    }
  }
}
