///|
pub(all) suberror IdnaError {
  PunycodeError(@legacy_punycode.PunycodeError)
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
}

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
fn legacy_punycode_error(
  error : @punycode_impl.PunycodeError,
) -> @legacy_punycode.PunycodeError {
  match error {
    @punycode_impl.Overflow => @legacy_punycode.Overflow
    @punycode_impl.InvalidInput => @legacy_punycode.InvalidInput
    @punycode_impl.BadInput => @legacy_punycode.BadInput
  }
}

///|
fn legacy_error(error : @impl.IdnaError) -> IdnaError {
  match error {
    @impl.PunycodeError(error) => PunycodeError(legacy_punycode_error(error))
    @impl.DisallowedCodePoint(cp~) => DisallowedCodePoint(cp~)
    @impl.InvalidLabel(label) => InvalidLabel(label)
    @impl.InvalidHyphen => InvalidHyphen
    @impl.LabelTooLong => LabelTooLong
    @impl.DomainTooLong => DomainTooLong
    @impl.EmptyLabel => EmptyLabel
    @impl.InvalidBidi => InvalidBidi
    @impl.InvalidJoiner => InvalidJoiner
    @impl.InvalidAcePrefix => InvalidAcePrefix
    @impl.LeadingCombiningMark => LeadingCombiningMark
  }
}

///|
pub fn to_ascii(
  domain : String,
  use_std3_ascii_rules? : Bool = true,
  check_hyphens? : Bool = true,
  check_bidi? : Bool = true,
  check_joiners? : Bool = true,
  verify_dns_length? : Bool = true,
) -> String raise IdnaError {
  @impl.to_ascii(
    domain,
    use_std3_ascii_rules~,
    check_hyphens~,
    check_bidi~,
    check_joiners~,
    verify_dns_length~,
  ) catch {
    error => raise legacy_error(error)
  }
}

///|
pub fn to_unicode(
  domain : String,
  use_std3_ascii_rules? : Bool = true,
  check_hyphens? : Bool = true,
  check_bidi? : Bool = true,
  check_joiners? : Bool = true,
) -> String raise IdnaError {
  @impl.to_unicode(
    domain,
    use_std3_ascii_rules~,
    check_hyphens~,
    check_bidi~,
    check_joiners~,
  ) catch {
    error => raise legacy_error(error)
  }
}
