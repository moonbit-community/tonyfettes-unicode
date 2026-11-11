///|
/// IDNA (Internationalized Domain Names in Applications) processing
/// Implements UTS #46: Unicode IDNA Compatibility Processing
/// https://www.unicode.org/reports/tr46/

///|
/// Error types for IDNA processing
pub(all) suberror IdnaError {
  PunycodeError(@punycode.PunycodeError)
  DisallowedCodePoint(cp~ : Int32)
  InvalidLabel(String)
  InvalidHyphen
  LabelTooLong
  DomainTooLong
  EmptyLabel
  InvalidBidi
  InvalidJoiner
  InvalidAcePrefix
  LeadingCombiningMark
}

///|
pub extend IdnaError with Show::{to_string, output}

///|
pub impl Show for IdnaError with fn output(self, logger) {
  match self {
    PunycodeError(error) =>
      logger.write_string("PunycodeError(\{error.to_string()})")
    DisallowedCodePoint(cp~) =>
      logger.write_string("DisallowedCodePoint(cp=\{cp.to_string()})")
    InvalidLabel(label) =>
      logger.write_string("InvalidLabel(\{label.to_string()})")
    InvalidHyphen => logger.write_string("InvalidHyphen")
    LabelTooLong => logger.write_string("LabelTooLong")
    DomainTooLong => logger.write_string("DomainTooLong")
    EmptyLabel => logger.write_string("EmptyLabel")
    InvalidBidi => logger.write_string("InvalidBidi")
    InvalidJoiner => logger.write_string("InvalidJoiner")
    InvalidAcePrefix => logger.write_string("InvalidAcePrefix")
    LeadingCombiningMark => logger.write_string("LeadingCombiningMark")
  }
}

///|
/// ACE prefix for Punycode labels
let ace_prefix : String = "xn--"

///|
/// Convert a domain name to ASCII (for DNS lookup)
/// This is the main entry point for IDNA ToASCII operation
pub fn to_ascii(
  domain : String,
  use_std3_ascii_rules~ : Bool = true,
  check_hyphens~ : Bool = true,
  check_bidi~ : Bool = true,
  check_joiners~ : Bool = true,
  verify_dns_length~ : Bool = true,
) -> String raise IdnaError {
  if ascii_fast_path(
      domain,
      use_std3_ascii_rules~,
      check_hyphens~,
      verify_dns_length~,
    )
    is Some(ascii) {
    return ascii
  }
  to_ascii_general(
    domain,
    use_std3_ascii_rules~,
    check_hyphens~,
    check_bidi~,
    check_joiners~,
    verify_dns_length~,
  )
}

///|
/// ToASCII for any domain: map, normalize, then validate and encode each label.
fn to_ascii_general(
  domain : String,
  use_std3_ascii_rules~ : Bool,
  check_hyphens~ : Bool,
  check_bidi~ : Bool,
  check_joiners~ : Bool,
  verify_dns_length~ : Bool,
) -> String raise IdnaError {
  // Map and normalize before splitting. Labels are validated below, after
  // existing A-labels have been decoded to their Unicode form. Mapping
  // leaves no ASCII uppercase letter, so every label is already lowercase.
  let processed = @normalization.nfc(map_domain(domain, use_std3_ascii_rules~))
  // When mapping and normalization leave the domain as it is, every
  // character has a valid status.
  let statuses_known = physical_equal(processed, domain)
  let length = processed.length()
  // Punycode is longer than the label it encodes; the size hint counts
  // bytes, two per UTF-16 code unit.
  let output = StringBuilder(size_hint=4 * length)
  // The `validate_label` Bidi flags of every label so far, or-ed together.
  let mut domain_bidi = 0
  // The first label that the DNS length checks reject. Like the Bidi
  // error, it is reported only once every label has been validated.
  let mut dns_error : IdnaError? = None
  // Length of the output, which is all ASCII.
  let mut ascii_length = 0
  let mut start = 0
  for ;; {
    let end = label_end(processed, start)
    let label = processed[start:end]
    if start > 0 {
      output.write_char('.')
      ascii_length += 1
    }
    if label.length() == 0 {
      // Only the last label may be empty, after a dot (a trailing dot).
      // Any other empty label comes from ".." or from a label mapped to
      // nothing, such as a soft hyphen.
      guard end == length && start > 0 else { raise EmptyLabel }
      if dns_error is None {
        dns_error = Some(EmptyLabel)
      }
      break
    }
    let mut label_bidi = 0
    let label_length = if has_ace_prefix(label) {
      // Decode the A-label to validate its Unicode content.
      let decoded = decode_ace_label(label)
      let normalized = map_and_normalize_label(decoded, use_std3_ascii_rules~)
      let unicode_label = if normalized is Some(normalized) {
        normalized[:]
      } else {
        decoded[:]
      }
      label_bidi = validate_label(
        unicode_label,
        use_std3_ascii_rules~,
        check_hyphens~,
        check_joiners~,
        check_bidi~,
        statuses_known=normalized is None,
      )
      // Encoding the Unicode form must give the A-label back (V7). The
      // decoded label always encodes back to an A-label in canonical form,
      // so it is encoded again only when mapping changed it.
      let round_trips = if normalized is None {
        is_canonical_ace_label(label)
      } else {
        encodes_to_ace_label(unicode_label, label)
      }
      guard round_trips else { raise InvalidAcePrefix }
      output.write_view(label)
      label.length()
    } else {
      // Raw A-labels must not be subjected to the hyphen checks before
      // decoding, because the xn-- prefix is intentional.
      label_bidi = validate_label(
        label,
        use_std3_ascii_rules~,
        check_hyphens~,
        check_joiners~,
        check_bidi~,
        statuses_known~,
      )
      if is_all_ascii(label) {
        output.write_view(label)
        label.length()
      } else {
        output.write_string(ace_prefix)
        let encoded_length = @punycode.encode_to(label, output) catch {
          error => raise PunycodeError(error)
        }
        ace_prefix.length() + encoded_length
      }
    }
    domain_bidi = domain_bidi | label_bidi
    if dns_error is None && label_length > 63 {
      dns_error = Some(LabelTooLong)
    }
    ascii_length += label_length
    if end == length {
      break
    }
    start = end + 1
  }
  // A Bidi domain name, one with a right-to-left label, needs every label
  // to satisfy the Bidi rule.
  if domain_bidi == (RtlLabel | BreaksBidiRule) {
    raise InvalidBidi
  }
  if verify_dns_length {
    if dns_error is Some(error) {
      raise error
    }
    if ascii_length > 253 {
      raise DomainTooLong
    }
  }
  output.to_string()
}

///|
/// Whether `label`, a lowercase A-label that decodes, is the encoding of its
/// decoding. Punycode gives each string a single lowercase encoding, and
/// decoding accepts only that one but for a delimiter with no basic code
/// point before it, which the encoding leaves out (see the Punycode fuzz
/// test "lowercase input that decodes encodes back to itself").
fn is_canonical_ace_label(label : StringView) -> Bool {
  let encoded = label[ace_prefix.length():]
  if encoded.length() == 0 || encoded[0] != '-' {
    return true
  }
  // The first delimiter is the last one only without basic code points.
  for i in 1..<encoded.length() {
    if encoded[i] == '-' {
      return true
    }
  }
  false
}

///|
/// Whether encoding `unicode_label` gives back `label`, an A-label that is
/// already lowercase.
fn encodes_to_ace_label(
  unicode_label : StringView,
  label : StringView,
) -> Bool raise IdnaError {
  if is_all_ascii(unicode_label) {
    // An all-ASCII label is not encoded, so it is compared as it is.
    return unicode_label == label
  }
  let encoded = @punycode.encode(unicode_label) catch {
    error => raise PunycodeError(error)
  }
  label[ace_prefix.length():] == encoded[:]
}

///|
/// Convert a domain name to Unicode (for display)
/// This is the main entry point for IDNA ToUnicode operation
pub fn to_unicode(
  domain : String,
  use_std3_ascii_rules~ : Bool = true,
  check_hyphens~ : Bool = true,
  check_bidi~ : Bool = true,
  check_joiners~ : Bool = true,
) -> String raise IdnaError {
  // ToUnicode does not verify DNS lengths.
  if ascii_fast_path(
      domain,
      use_std3_ascii_rules~,
      check_hyphens~,
      verify_dns_length=false,
    )
    is Some(unicode) {
    return unicode
  }
  to_unicode_general(
    domain,
    use_std3_ascii_rules~,
    check_hyphens~,
    check_bidi~,
    check_joiners~,
  )
}

///|
/// ToUnicode for any domain: decode, map, normalize and validate each label.
fn to_unicode_general(
  domain : String,
  use_std3_ascii_rules~ : Bool,
  check_hyphens~ : Bool,
  check_bidi~ : Bool,
  check_joiners~ : Bool,
) -> String raise IdnaError {
  // Split into labels first (before mapping, to handle Punycode)
  let length = domain.length()
  // The size hint counts bytes, two per UTF-16 code unit.
  let output = StringBuilder(size_hint=2 * length)
  let mut domain_bidi = 0
  let mut start = 0
  for ;; {
    let end = label_end(domain, start)
    let label = domain[start:end]
    if start > 0 {
      output.write_char('.')
    }
    if label.length() == 0 {
      // Only the last label may be empty, after a dot (a trailing dot).
      guard end == length && start > 0 else { raise EmptyLabel }
      break
    }
    let decoded = if has_ace_prefix(label) {
      decode_ace_label(label)[:]
    } else {
      label
    }
    let normalized = map_and_normalize_label(decoded, use_std3_ascii_rules~)
    let unicode_label = if normalized is Some(normalized) {
      normalized[:]
    } else {
      decoded
    }
    let label_bidi = validate_label(
      unicode_label,
      use_std3_ascii_rules~,
      check_hyphens~,
      check_joiners~,
      check_bidi~,
      statuses_known=normalized is None,
    )
    domain_bidi = domain_bidi | label_bidi
    output.write_view(unicode_label)
    if end == length {
      break
    }
    start = end + 1
  }
  // A Bidi domain name, one with a right-to-left label, needs every label
  // to satisfy the Bidi rule.
  if domain_bidi == (RtlLabel | BreaksBidiRule) {
    raise InvalidBidi
  }
  output.to_string()
}

///|
/// Decode an A-label and enforce the UTS #46 requirement that its decoded
/// form is non-empty and contains at least one non-ASCII code point.
fn decode_ace_label(label : StringView) -> String raise IdnaError {
  // The prefix is four ASCII characters, so four UTF-16 code units.
  let decoded = @punycode.decode(label[ace_prefix.length():]) catch {
    error => raise PunycodeError(error)
  }
  if is_all_ascii(decoded) {
    raise InvalidAcePrefix
  }
  decoded
}

///|
fn is_all_ascii(label : StringView) -> Bool {
  label.all(c => c.to_int() < 0x80)
}

///|
/// Check if a label has the ACE prefix "xn--", ignoring ASCII case
fn has_ace_prefix(label : StringView) -> Bool {
  label.length() >= 4 &&
  label[0] is ('x' | 'X') &&
  label[1] is ('n' | 'N') &&
  label[2] == '-' &&
  label[3] == '-'
}
