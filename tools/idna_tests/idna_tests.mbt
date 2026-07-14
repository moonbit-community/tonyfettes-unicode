///|
priv struct TestCase {
  line_number : Int
  source : String
  to_ascii : String
  status : Array[String]
  has_surrogate : Bool
}

///|
priv struct RequiredFlags {
  check_bidi : Bool
  check_joiners : Bool
  check_hyphens : Bool
  use_std3_ascii_rules : Bool
  verify_dns_length : Bool
}

///|
fn parse_status(text : StringView) -> Array[String]? {
  let text = text.trim()
  if text.is_empty() {
    return None
  }
  if text == "[]" {
    return Some([])
  }
  guard text.strip_prefix("[") is Some(after_open) else { return None }
  guard after_open.split_once("]") is Some((codes, _)) else { return None }
  let result : Array[String] = []
  for code in codes.replace_all(old=",", new=" ").split(" ") {
    let code = code.trim()
    if !code.is_empty() {
      result.push(code.to_owned())
    }
  }
  Some(result)
}

///|
fn parse_test_line(line : StringView, line_number : Int) -> TestCase? {
  let line = line.trim()
  if line.is_empty() || line.has_prefix("#") {
    return None
  }
  match line.split(";").collect() {
    [
      source_text,
      unicode_text,
      unicode_status_text,
      ascii_text,
      ascii_status_text,
      _,
      ..,
    ] => {
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
      let unicode_status = parse_status(unicode_status_text).unwrap_or([])
      let ascii_status = parse_status(ascii_status_text).unwrap_or(
        unicode_status,
      )
      Some({
        line_number,
        source: source.text,
        to_ascii,
        status: ascii_status,
        has_surrogate: source.has_surrogate || to_ascii_has_surrogate,
      })
    }
    _ => None
  }
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
fn padded_line_number(line_number : Int) -> String {
  let number = line_number.to_string()
  let out = @emitter.Emitter::new()
  for _ in number.length()..<4 {
    out.write_char('0')
  }
  out.write(number)
  out.finish()
}

///|
fn joined_statuses(statuses : ArrayView[String]) -> String {
  let out = @emitter.Emitter::new()
  for index, status in statuses {
    if index > 0 {
      out.write_char(' ')
    }
    out.write(status)
  }
  out.finish()
}

///|
fn write_test_name(
  out : @emitter.Emitter,
  case : TestCase,
  status? : String = "",
) -> Unit {
  out.write("test \"conformance/")
  out.write(padded_line_number(case.line_number))
  out.write(": ")
  out.write(
    @support.escape_moonbit_string(@support.truncate_chars(case.source, 20)),
  )
  if !status.is_empty() {
    out.write(" [")
    out.write(status)
    out.write_char(']')
  }
  out.write("\" {\n")
}

///|
fn write_success_test(
  out : @emitter.Emitter,
  case : TestCase,
  separator : Bool,
) -> Unit {
  if separator {
    out.write("///|\n")
  }
  write_test_name(out, case)
  out.write("  let result = @idna.to_ascii(\n    \"")
  out.write(@support.escape_moonbit_string(case.source))
  out.write(
    (
      #|",
      #|    use_std3_ascii_rules=false,
      #|    check_hyphens=false,
      #|    check_bidi=false,
      #|    check_joiners=false,
      #|    verify_dns_length=false,
      #|  )
      #|  assert_eq(result, "
    ),
  )
  out.write(@support.escape_moonbit_string(case.to_ascii))
  out.write("\")\n}\n\n")
}

///|
fn write_error_test(
  out : @emitter.Emitter,
  case : TestCase,
  flags : RequiredFlags,
  separator : Bool,
) -> Unit {
  let status = joined_statuses(case.status)
  if separator {
    out.write("///|\n")
  }
  write_test_name(out, case, status~)
  out.write("  let result = to_ascii_result(\n    \"")
  out.write(@support.escape_moonbit_string(case.source))
  out.write("\",\n    use_std3_ascii_rules=")
  out.write(@support.bool_literal(flags.use_std3_ascii_rules))
  out.write(",\n    check_hyphens=")
  out.write(@support.bool_literal(flags.check_hyphens))
  out.write(",\n    check_bidi=")
  out.write(@support.bool_literal(flags.check_bidi))
  out.write(",\n    check_joiners=")
  out.write(@support.bool_literal(flags.check_joiners))
  out.write(",\n    verify_dns_length=")
  out.write(@support.bool_literal(flags.verify_dns_length))
  out.write(
    (
      #|,
      #|  )
      #|  guard result is Err(_) else {
      #|    fail("Expected error for line
    ),
  )
  out.write_char(' ')
  out.write_int(case.line_number)
  out.write(", got Ok\")\n  }\n}\n\n")
}

///|
pub fn generate_source(content : String) -> String {
  let successes : Array[TestCase] = []
  let flag_errors : Array[(TestCase, RequiredFlags)] = []
  let always_errors : Array[TestCase] = []
  for line_number, line in content.split("\n") {
    guard parse_test_line(line, line_number + 1) is Some(case) else { continue }
    if case.has_surrogate {
      continue
    }
    if case.status.is_empty() {
      successes.push(case)
      continue
    }
    let flags = required_flags(case.status)
    if flags.any() {
      flag_errors.push((case, flags))
    } else if has_flag_independent_error(case.status) {
      always_errors.push(case)
    } else {
      successes.push(case)
    }
  }
  let out = @emitter.Emitter::new()
  out.write(
    (
      #|///|
      #|/// IDNA Conformance Tests
      #|/// Generated from IdnaTestV2.txt (Unicode 16.0.0)
      #|///
      #|/// These tests verify compliance with UTS #46 (Unicode IDNA Compatibility Processing).
      #|/// Source: https://www.unicode.org/Public/idna/16.0.0/IdnaTestV2.txt
      #|
      #|// Success tests (no error expected)
      #|
    ),
  )
  out.write_char('\n')
  for index, case in successes {
    write_success_test(out, case, index > 0)
  }
  out.write("///|\n\n// Error tests with validation flags enabled\n\n")
  for index, entry in flag_errors {
    let (case, flags) = entry
    write_error_test(out, case, flags, index > 0)
  }
  if !always_errors.is_empty() {
    out.write("///|\n\n// Error tests (always fail regardless of flags)\n\n")
    let no_flags = {
      check_bidi: false,
      check_joiners: false,
      check_hyphens: false,
      use_std3_ascii_rules: false,
      verify_dns_length: false,
    }
    for index, case in always_errors {
      write_error_test(out, case, no_flags, index > 0)
    }
  }
  out.finish()
}
