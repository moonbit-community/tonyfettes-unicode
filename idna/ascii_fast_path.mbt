///|
/// Convert a domain that is already plain ASCII without running the general
/// UTS #46 algorithm.
///
/// Returns the converted domain when every label is valid as written, so
/// that ToASCII and ToUnicode both reduce to lowercasing. Returns `None`
/// when the general algorithm must run: a non-ASCII character, a possible
/// A-label (`xn--`), or anything that might be an error. Errors are always
/// left to the general algorithm, so both paths report them identically.
fn ascii_fast_path(
  domain : String,
  use_std3_ascii_rules~ : Bool,
  check_hyphens~ : Bool,
  verify_dns_length~ : Bool,
) -> String? {
  let length = domain.length()
  if verify_dns_length && length > 253 {
    return None
  }
  let mut label_start = 0
  let mut has_uppercase = false
  for i in 0..<length {
    match domain[i] {
      'a'..='z' | '0'..='9' | '-' => ()
      'A'..='Z' => has_uppercase = true
      '.' => {
        guard is_plain_ascii_label(
          domain,
          label_start,
          i,
          check_hyphens~,
          verify_dns_length~,
        ) else {
          return None
        }
        label_start = i + 1
      }
      // Every other ASCII character is valid unless STD3 rules apply.
      unit => if use_std3_ascii_rules || unit >= 0x80 { return None }
    }
  }
  if label_start == length {
    // An empty final label is a trailing dot, which needs a label before it
    // and is rejected by the DNS length check.
    if label_start == 0 || verify_dns_length {
      return None
    }
  } else if !is_plain_ascii_label(
      domain,
      label_start,
      length,
      check_hyphens~,
      verify_dns_length~,
    ) {
    return None
  }
  Some(if has_uppercase { domain.to_lower() } else { domain })
}

///|
/// Check the label `domain[start:end]`, whose characters are known to be
/// valid ASCII, against the rules that depend on position and length.
fn is_plain_ascii_label(
  domain : String,
  start : Int,
  end : Int,
  check_hyphens~ : Bool,
  verify_dns_length~ : Bool,
) -> Bool {
  let length = end - start
  if length == 0 || (verify_dns_length && length > 63) {
    return false
  }
  if length >= 4 && domain[start + 2] == '-' && domain[start + 3] == '-' {
    // Hyphens in the third and fourth positions are either a violation or
    // the prefix of an A-label, which has to be decoded.
    if check_hyphens ||
      (domain[start] is ('x' | 'X') && domain[start + 1] is ('n' | 'N')) {
      return false
    }
  }
  !check_hyphens || (domain[start] != '-' && domain[end - 1] != '-')
}
