///|
/// IDNA (Internationalized Domain Names in Applications) processing
/// Implements UTS #46: Unicode IDNA Compatibility Processing
/// https://www.unicode.org/reports/tr46/

///|
/// Error types for IDNA processing
pub(all) suberror IdnaError {
  PunycodeError(String)
  DisallowedCodePoint(cp~ : Int)
  InvalidLabel(String)
  InvalidHyphen
  LabelTooLong
  DomainTooLong
  EmptyLabel
  InvalidBidi
  InvalidJoiner
  InvalidAcePrefix
  LeadingCombiningMark
} derive(Show)

///|
/// ACE prefix for Punycode labels
let ace_prefix : String = "xn--"

///|
/// Convert a domain name to ASCII (for DNS lookup)
/// This is the main entry point for IDNA ToASCII operation
pub fn to_ascii(
  domain : String,
  use_std3_ascii_rules? : Bool = true,
  check_hyphens? : Bool = true,
  check_bidi? : Bool = true,
  check_joiners? : Bool = true,
  verify_dns_length? : Bool = true,
) -> String raise IdnaError {
  // Process the domain
  let processed = process_domain(
    domain,
    use_std3_ascii_rules~,
    check_hyphens~,
    check_bidi~,
    check_joiners~,
  )

  // Convert to ASCII using Punycode where needed
  let labels = split_labels(processed)
  let ascii_labels : Array[String] = []
  for label in labels {
    let ascii_label = label_to_ascii(label)
    ascii_labels.push(ascii_label)
  }
  let result = ascii_labels.join(".")

  // Verify DNS length constraints
  if verify_dns_length {
    verify_dns_length_constraints(result, ascii_labels)
  }
  result
}

///|
/// Convert a domain name to Unicode (for display)
/// This is the main entry point for IDNA ToUnicode operation
pub fn to_unicode(
  domain : String,
  use_std3_ascii_rules? : Bool = true,
  check_hyphens? : Bool = true,
  check_bidi? : Bool = true,
  check_joiners? : Bool = true,
) -> String raise IdnaError {
  // Split into labels first (before mapping, to handle Punycode)
  let labels = split_labels(domain)
  let unicode_labels : Array[String] = []
  for label in labels {
    let unicode_label = label_to_unicode(
      label,
      use_std3_ascii_rules~,
      check_hyphens~,
      check_bidi~,
      check_joiners~,
    )
    unicode_labels.push(unicode_label)
  }
  unicode_labels.join(".")
}

///|
/// Convert a single label to ASCII (Punycode if needed)
fn label_to_ascii(label : String) -> String raise IdnaError {
  // Check if label is already ASCII
  let mut all_ascii = true
  for c in label {
    if c.to_int() >= 0x80 {
      all_ascii = false
      break
    }
  }
  if all_ascii {
    // Already ASCII, return as-is (lowercased)
    label.to_lower()
  } else {
    // Encode to Punycode
    let encoded = @punycode.encode(label.to_lower()) catch {
      error => raise PunycodeError("\{error}")
    }
    ace_prefix + encoded
  }
}

///|
/// Convert a single label from Punycode to Unicode if needed
fn label_to_unicode(
  label : String,
  use_std3_ascii_rules~ : Bool,
  check_hyphens~ : Bool,
  check_bidi~ : Bool,
  check_joiners~ : Bool,
) -> String raise IdnaError {
  let unicode_label = if has_ace_prefix(label) {
    // Decode Punycode - skip "xn--" prefix
    let punycode_part = get_substring_after_prefix(label, 4)
    let decoded = @punycode.decode(punycode_part) catch {
      error => raise PunycodeError("\{error}")
    }
    decoded
  } else {
    label
  }

  // Apply mapping and normalize
  let processed = map_label(unicode_label, use_std3_ascii_rules~)
  let normalized = @normalization.nfc(processed)

  // Validate the label
  validate_label(
    normalized,
    use_std3_ascii_rules~,
    check_hyphens~,
    check_bidi~,
    check_joiners~,
  )
  normalized
}

///|
/// Check if a label has the ACE prefix "xn--"
fn has_ace_prefix(label : String) -> Bool {
  if label.length() < 4 {
    return false
  }
  let lower = label.to_lower()
  // Check first 4 characters manually to avoid slice error handling
  lower[0] == 'x' && lower[1] == 'n' && lower[2] == '-' && lower[3] == '-'
}

///|
/// Get substring after a given prefix length (safe version)
fn get_substring_after_prefix(s : String, prefix_len : Int) -> String {
  let result = StringBuilder::new()
  let mut i = 0
  for c in s {
    if i >= prefix_len {
      result.write_char(c)
    }
    i = i + 1
  }
  result.to_string()
}

///|
/// Verify DNS length constraints
fn verify_dns_length_constraints(
  domain : String,
  labels : Array[String],
) -> Unit raise IdnaError {
  // Each label must be 1-63 characters
  for label in labels {
    if label.length() == 0 {
      raise EmptyLabel
    }
    if label.length() > 63 {
      raise LabelTooLong
    }
  }

  // Total domain name must be at most 253 characters
  if domain.length() > 253 {
    raise DomainTooLong
  }
}
