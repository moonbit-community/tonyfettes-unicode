///|
/// IDNA label validation (UTS #46 Section 4.1)

///|
/// Validate a single label according to UTS #46 validity criteria
fn validate_label(
  label : String,
  use_std3_ascii_rules~ : Bool,
  check_hyphens~ : Bool,
  check_bidi~ : Bool,
  check_joiners~ : Bool,
) -> Unit raise IdnaError {
  // Empty labels are allowed here - the check is done in verify_dns_length_constraints
  // when verify_dns_length is true. This allows domains with trailing dots or
  // consecutive dots when DNS length checking is disabled.
  if label.length() == 0 {
    return
  }
  let codepoints = label_to_codepoints(label)

  // Check 1: Must be NFC normalized
  if not(@normalization.is_normalized(label, @normalization.NFC)) {
    raise InvalidLabel(label)
  }

  // Check 2 & 3: Hyphen restrictions (when check_hyphens)
  if check_hyphens {
    validate_hyphens(label, codepoints)
  }

  // Check 4: No U+002E (full stop) within label - handled by label splitting

  // Check 5: No leading combining marks
  if codepoints.length() > 0 {
    let first_cp = codepoints[0]
    if is_combining_mark(first_cp) {
      raise LeadingCombiningMark
    }
  }

  // Check 6: All code points must have valid status
  for cp in codepoints {
    validate_codepoint_status(cp, use_std3_ascii_rules)
  }

  // Check 7: ContextJ rules (when check_joiners)
  if check_joiners {
    validate_contextj(codepoints)
  }

  // Check 8: Bidi rules (when check_bidi)
  if check_bidi {
    validate_bidi(codepoints)
  }
}

///|
/// Convert a label string to array of code points
fn label_to_codepoints(label : String) -> Array[Int] {
  let result : Array[Int] = []
  for c in label {
    result.push(c.to_int())
  }
  result
}

///|
/// Validate hyphen restrictions
fn validate_hyphens(
  _label : String,
  codepoints : Array[Int],
) -> Unit raise IdnaError {
  // Cannot start or end with hyphen
  if codepoints.length() > 0 {
    if codepoints[0] == '-'.to_int() ||
      codepoints[codepoints.length() - 1] == '-'.to_int() {
      raise InvalidHyphen
    }
  }

  // Cannot have hyphens at positions 3 and 4 (third and fourth characters)
  // This catches things like "xn--" in non-ACE context
  if codepoints.length() >= 4 {
    if codepoints[2] == '-'.to_int() && codepoints[3] == '-'.to_int() {
      raise InvalidHyphen
    }
  }
}

///|
/// Check if a code point is a combining mark (General_Category = Mn, Mc, or Me)
/// This is used for the IDNA "no leading combining mark" validation (V5/V6)
fn is_combining_mark(cp : Int) -> Bool {
  @ucd.is_mark(cp)
}

///|
/// Validate that a code point has an acceptable IDNA status
fn validate_codepoint_status(
  cp : Int,
  use_std3_ascii_rules : Bool,
) -> Unit raise IdnaError {
  let (status, _) = @idna_data.lookup_idna_mapping(cp)
  match status {
    @idna_data.Valid | @idna_data.Deviation =>
      // OK
      ()
    @idna_data.Mapped | @idna_data.Ignored =>
      // These should have been processed in the mapping step
      // If we see them here, something went wrong
      raise DisallowedCodePoint(cp~)
    @idna_data.Disallowed => raise DisallowedCodePoint(cp~)
    @idna_data.DisallowedSTD3Valid =>
      if use_std3_ascii_rules {
        raise DisallowedCodePoint(cp~)
      }
    // Otherwise OK
    @idna_data.DisallowedSTD3Mapped =>
      if use_std3_ascii_rules {
        raise DisallowedCodePoint(cp~)
      }
    // Otherwise should have been mapped
  }
}

///|
/// Validate ContextJ rules for ZWNJ (U+200C) and ZWJ (U+200D)
fn validate_contextj(codepoints : Array[Int]) -> Unit raise IdnaError {
  for i, cp in codepoints {
    if cp == 0x200C {
      // ZWNJ: Zero Width Non-Joiner
      if not(is_valid_zwnj_context(codepoints, i)) {
        raise InvalidJoiner
      }
    } else if cp == 0x200D {
      // ZWJ: Zero Width Joiner
      if not(is_valid_zwj_context(codepoints, i)) {
        raise InvalidJoiner
      }
    }
  }
}

///|
/// Check if ZWNJ is in a valid context
/// Valid if:
/// - There is a combining Virama (U+094D, etc.) before, OR
/// - Surrounded by appropriate joining characters
fn is_valid_zwnj_context(codepoints : Array[Int], pos : Int) -> Bool {
  // Rule 1: After a Virama (e.g., for Indic scripts)
  if pos > 0 && is_virama(codepoints[pos - 1]) {
    return true
  }

  // Rule 2: Between joining characters
  // Look for L or D type before, and R or D type after
  if has_left_joining_before(codepoints, pos) &&
    has_right_joining_after(codepoints, pos) {
    return true
  }
  false
}

///|
/// Check if ZWJ is in a valid context
/// Valid if preceded by a Virama
fn is_valid_zwj_context(codepoints : Array[Int], pos : Int) -> Bool {
  // ZWJ is valid if preceded by a combining Virama
  pos > 0 && is_virama(codepoints[pos - 1])
}

///|
/// Check if a code point is a Virama (combining class 9)
fn is_virama(cp : Int) -> Bool {
  @ucd.lookup_ccc(cp) == 9
}

///|
/// Check if there's a left-joining or dual-joining character before position
fn has_left_joining_before(codepoints : Array[Int], pos : Int) -> Bool {
  for i = pos - 1; i >= 0; i = i - 1 {
    let jt = @idna_data.lookup_joining_type(codepoints[i])
    match jt {
      @idna_data.LeftJoining | @idna_data.DualJoining => return true
      @idna_data.Transparent => continue
      _ => return false
    }
  }
  false
}

///|
/// Check if there's a right-joining or dual-joining character after position
fn has_right_joining_after(codepoints : Array[Int], pos : Int) -> Bool {
  for i = pos + 1; i < codepoints.length(); i = i + 1 {
    let jt = @idna_data.lookup_joining_type(codepoints[i])
    match jt {
      @idna_data.RightJoining | @idna_data.DualJoining => return true
      @idna_data.Transparent => continue
      _ => return false
    }
  }
  false
}

///|
/// Validate Bidi rules (RFC 5893)
fn validate_bidi(codepoints : Array[Int]) -> Unit raise IdnaError {
  if codepoints.length() == 0 {
    return
  }

  // Determine if this is an RTL label
  let is_rtl_label = is_rtl_label_check(codepoints)
  if is_rtl_label {
    validate_rtl_label(codepoints)
  } else {
    validate_ltr_label(codepoints)
  }
}

///|
/// Check if label is RTL (contains R, AL, or AN characters)
fn is_rtl_label_check(codepoints : Array[Int]) -> Bool {
  for cp in codepoints {
    let bc = @idna_data.lookup_bidi_class(cp)
    match bc {
      @idna_data.R | @idna_data.AL | @idna_data.AN => return true
      _ => continue
    }
  }
  false
}

///|
/// Validate an RTL label according to RFC 5893
fn validate_rtl_label(codepoints : Array[Int]) -> Unit raise IdnaError {
  // Rule 1: First character must be R or AL
  let first_bc = @idna_data.lookup_bidi_class(codepoints[0])
  match first_bc {
    @idna_data.R | @idna_data.AL => ()
    _ => raise InvalidBidi
  }

  // Rule 2: Only certain Bidi classes allowed
  // Rule 3: Last character must be R, AL, EN, or AN
  let mut last_strong : @idna_data.BidiClass = first_bc
  let mut has_en = false
  let mut has_an = false
  for cp in codepoints {
    let bc = @idna_data.lookup_bidi_class(cp)
    match bc {
      @idna_data.R
      | @idna_data.AL
      | @idna_data.AN
      | @idna_data.EN
      | @idna_data.ES
      | @idna_data.CS
      | @idna_data.ET
      | @idna_data.ON
      | @idna_data.BN
      | @idna_data.NSM => {
        // Allowed in RTL label
        match bc {
          @idna_data.R | @idna_data.AL | @idna_data.AN | @idna_data.EN =>
            last_strong = bc
          _ => ()
        }
        if bc is @idna_data.EN {
          has_en = true
        }
        if bc is @idna_data.AN {
          has_an = true
        }
      }
      @idna_data.L => raise InvalidBidi // L not allowed in RTL label
      _ => ()
    }
  }

  // Rule 3: Last strong character must be R, AL, EN, or AN
  match last_strong {
    @idna_data.R | @idna_data.AL | @idna_data.EN | @idna_data.AN => ()
    _ => raise InvalidBidi
  }

  // Rule 4: EN and AN cannot both appear
  if has_en && has_an {
    raise InvalidBidi
  }
}

///|
/// Validate an LTR label according to RFC 5893
fn validate_ltr_label(codepoints : Array[Int]) -> Unit raise IdnaError {
  // Rule 5: First character must be L
  let first_bc = @idna_data.lookup_bidi_class(codepoints[0])
  match first_bc {
    @idna_data.L => ()
    // Allow pure ASCII/neutral labels
    @idna_data.EN
    | @idna_data.ES
    | @idna_data.CS
    | @idna_data.ET
    | @idna_data.ON
    | @idna_data.BN
    | @idna_data.NSM => ()
    _ => raise InvalidBidi
  }

  // Rule 6: Only certain Bidi classes allowed in LTR label
  for cp in codepoints {
    let bc = @idna_data.lookup_bidi_class(cp)
    match bc {
      @idna_data.L
      | @idna_data.EN
      | @idna_data.ES
      | @idna_data.CS
      | @idna_data.ET
      | @idna_data.ON
      | @idna_data.BN
      | @idna_data.NSM =>
        // Allowed in LTR label
        ()
      @idna_data.R | @idna_data.AL | @idna_data.AN => raise InvalidBidi // RTL chars not allowed
      _ => ()
    }
  }
}
