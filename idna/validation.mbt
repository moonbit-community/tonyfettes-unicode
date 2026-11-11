///|
/// IDNA label validation (UTS #46 Section 4.1)

///|
/// Validate a single label according to UTS #46 validity criteria, and
/// return its Bidi flags (`RtlLabel`, `BreaksBidiRule`) when `check_bidi`
/// is set, or 0 otherwise.
///
/// Every caller passes a label it has just mapped and normalized to NFC, so
/// the label is not checked for NFC again. `statuses_known` tells that the
/// mapping and normalization left the label as it was, so that every
/// character already has a valid status.
fn validate_label(
  label : StringView,
  use_std3_ascii_rules~ : Bool,
  check_hyphens~ : Bool,
  check_joiners~ : Bool,
  check_bidi~ : Bool,
  statuses_known~ : Bool,
) -> Int32 raise IdnaError {
  // Empty labels should raise an error - they indicate either intentional empty
  // labels (like trailing dots) or labels that became empty after IDNA mapping
  // (like soft hyphen U+00AD). The caller can catch EmptyLabel and decide
  // whether to allow it based on context.
  if label.length() == 0 {
    raise EmptyLabel
  }

  // Check 2 & 3: Hyphen restrictions (when check_hyphens)
  if check_hyphens {
    validate_hyphens(label)
  }

  // Check 4: No U+002E (full stop) within label - handled by label splitting

  // Check 5: No leading combining marks. An unpaired surrogate is not a mark.
  if label.get_char(0) is Some(first) && is_combining_mark(first) {
    raise LeadingCombiningMark
  }

  // Check 6 (every character has a valid status) in the same pass that
  // looks for joiners and gathers what the Bidi rule needs.
  let mut has_joiner = false
  let bidi = LabelBidi::new()
  for c in label {
    if !statuses_known {
      validate_char_status(c, use_std3_ascii_rules)
    } else if use_std3_ascii_rules && c.to_int() < 0x80 && !is_ldh_ascii(c) {
      // The table has these valid; STD3 rules allow only LDH in ASCII.
      raise DisallowedCodePoint(cp=c.to_int())
    }
    if c is ('\u{200C}' | '\u{200D}') {
      has_joiner = true
    }
    if check_bidi {
      bidi.add(@bidi.bidi_class(c))
    }
  }

  // Check 7: ContextJ rules (when check_joiners)
  if check_joiners && has_joiner {
    validate_contextj(label)
  }
  if check_bidi {
    bidi.flags()
  } else {
    0
  }
}

///|
/// Validate hyphen restrictions on a non-empty label
fn validate_hyphens(label : StringView) -> Unit raise IdnaError {
  // Cannot start or end with hyphen. A hyphen is one UTF-16 code unit.
  if label[0] == '-' || label[label.length() - 1] == '-' {
    raise InvalidHyphen
  }

  // Cannot have hyphens at positions 3 and 4 (third and fourth characters)
  // This catches things like "xn--" in non-ACE context
  let mut position = 0
  for c in label {
    if position >= 2 && c != '-' {
      break
    }
    if position == 3 {
      raise InvalidHyphen
    }
    position += 1
  }
}

///|
/// Check if a character is a combining mark (General_Category = Mn, Mc, or Me)
/// This is used for the IDNA "no leading combining mark" validation (V5/V6)
fn is_combining_mark(c : Char) -> Bool {
  @general_category.is_mark(c)
}

///|
/// Check if an ASCII character is an LDH character (Letter, Digit, Hyphen)
/// This implements STD3 ASCII rules from RFC 952/1123
fn is_ldh_ascii(c : Char) -> Bool {
  // ASCII lowercase letters (a-z)
  (c >= 'a' && c <= 'z') ||
  // ASCII uppercase letters (A-Z) - should be mapped to lowercase already
  (c >= 'A' && c <= 'Z') ||
  // ASCII digits (0-9)
  (c >= '0' && c <= '9') ||
  // Hyphen-minus
  c == '-'
}

///|
/// Validate that a character has an acceptable IDNA status
fn validate_char_status(
  c : Char,
  use_std3_ascii_rules : Bool,
) -> Unit raise IdnaError {
  // STD3 ASCII rules: only LDH characters allowed in ASCII range
  // This check is separate from IdnaMappingTable.txt which marks
  // these characters as "valid" but they should be rejected under STD3
  if c.to_int() < 0x80 {
    // IdnaMappingTable has every ASCII character valid but A-Z, which it
    // maps to a-z.
    if (use_std3_ascii_rules && !is_ldh_ascii(c)) || c is ('A'..<='Z') {
      raise DisallowedCodePoint(cp=c.to_int())
    }
    return
  }
  match @idna_data.lookup_idna_entry(c).status() {
    Valid | Deviation =>
      // OK
      ()
    Mapped | Ignored =>
      // These should have been processed in the mapping step
      // If we see them here, something went wrong
      raise DisallowedCodePoint(cp=c.to_int())
    Disallowed => raise DisallowedCodePoint(cp=c.to_int())
    DisallowedSTD3Valid =>
      if use_std3_ascii_rules {
        raise DisallowedCodePoint(cp=c.to_int())
      }
    // Otherwise OK
    DisallowedSTD3Mapped =>
      if use_std3_ascii_rules {
        raise DisallowedCodePoint(cp=c.to_int())
      }
    // Otherwise should have been mapped
  }
}

///|
/// Validate ContextJ rules for ZWNJ (U+200C) and ZWJ (U+200D)
fn validate_contextj(label : StringView) -> Unit raise IdnaError {
  // Joiners are rare; only a label containing one needs random access.
  let chars = label.to_array()
  for i, c in chars {
    if c == '\u{200C}' {
      // ZWNJ: Zero Width Non-Joiner
      if !is_valid_zwnj_context(chars, i) {
        raise InvalidJoiner
      }
    } else if c == '\u{200D}' {
      // ZWJ: Zero Width Joiner
      if !is_valid_zwj_context(chars, i) {
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
fn is_valid_zwnj_context(chars : Array[Char], pos : Int32) -> Bool {
  // Rule 1: After a Virama (e.g., for Indic scripts)
  if pos > 0 && is_virama(chars[pos - 1]) {
    return true
  }

  // Rule 2: Between joining characters
  // Look for L or D type before, and R or D type after
  if has_left_joining_before(chars, pos) && has_right_joining_after(chars, pos) {
    return true
  }
  false
}

///|
/// Check if ZWJ is in a valid context
/// Valid if preceded by a Virama
fn is_valid_zwj_context(chars : Array[Char], pos : Int32) -> Bool {
  // ZWJ is valid if preceded by a combining Virama
  pos > 0 && is_virama(chars[pos - 1])
}

///|
/// Check if a character is a Virama (combining class 9)
fn is_virama(c : Char) -> Bool {
  @ccc.lookup_ccc(c) == 9
}

///|
/// Check if there's a left-joining or dual-joining character before position
fn has_left_joining_before(chars : Array[Char], pos : Int32) -> Bool {
  for i in pos>..0 {
    let jt = @ucd.joining_type(chars[i])
    match jt {
      @ucd.LeftJoining | @ucd.DualJoining => return true
      @ucd.Transparent => continue
      _ => return false
    }
  }
  false
}

///|
/// Check if there's a right-joining or dual-joining character after position
fn has_right_joining_after(chars : Array[Char], pos : Int32) -> Bool {
  for i in (pos + 1)..<chars.length() {
    let jt = @ucd.joining_type(chars[i])
    match jt {
      @ucd.RightJoining | @ucd.DualJoining => return true
      @ucd.Transparent => continue
      _ => return false
    }
  }
  false
}

///|
/// A label in a right-to-left (Bidi) domain name: one with an R, AL or AN.
const RtlLabel : Int32 = 1

///|
/// A label that breaks the RFC 5893 Bidi rule that applies to it in a Bidi
/// domain name: the rule for right-to-left labels if it is one, and the rule
/// for left-to-right labels otherwise.
const BreaksBidiRule : Int32 = 2

///|
/// What the RFC 5893 Bidi rule needs to know about a label, gathered one
/// Bidi class at a time. Whether the label is right-to-left is known only at
/// the end, so both the right-to-left and the left-to-right rule are tracked.
priv struct LabelBidi {
  mut first : @bidi.BidiClass?
  /// The last class that is not NSM and that either rule allows (B3, B6).
  mut last : @bidi.BidiClass
  mut has_l : Bool
  mut has_rtl : Bool
  mut has_en : Bool
  mut has_an : Bool
}

///|
fn LabelBidi::new() -> LabelBidi {
  {
    first: None,
    last: @bidi.ON,
    has_l: false,
    has_rtl: false,
    has_en: false,
    has_an: false,
  }
}

///|
fn LabelBidi::add(self : LabelBidi, bc : @bidi.BidiClass) -> Unit {
  if self.first is None {
    self.first = Some(bc)
    self.last = bc
  }
  match bc {
    @bidi.L => self.has_l = true
    @bidi.R | @bidi.AL => self.has_rtl = true
    @bidi.AN => {
      self.has_rtl = true
      self.has_an = true
    }
    @bidi.EN => self.has_en = true
    _ => ()
  }
  // Each rule rejects a label with a class outside its list (L for the
  // right-to-left rule; R, AL and AN for the left-to-right one), so the
  // union of both lists can be tracked for whichever rule applies.
  if bc
    is (@bidi.L
    | @bidi.R
    | @bidi.AL
    | @bidi.AN
    | @bidi.EN
    | @bidi.ES
    | @bidi.CS
    | @bidi.ET
    | @bidi.ON
    | @bidi.BN) {
    self.last = bc
  }
}

///|
/// `RtlLabel` and `BreaksBidiRule` for the label.
fn LabelBidi::flags(self : LabelBidi) -> Int32 {
  if self.has_rtl {
    // B1: starts with R or AL. B2: no L. B3: ends with R, AL, EN or AN
    // (ignoring NSM). B4: not both EN and AN.
    let valid = self.first is Some(@bidi.R | @bidi.AL) &&
      !self.has_l &&
      self.last is (@bidi.R | @bidi.AL | @bidi.EN | @bidi.AN) &&
      !(self.has_en && self.has_an)
    if valid {
      RtlLabel
    } else {
      RtlLabel | BreaksBidiRule
    }
  } else {
    // B5 is implied, with no R, AL or AN. Starting with L is stricter than
    // B1 requires, as left-to-right labels in a Bidi domain name must.
    // B6: ends with L or EN (ignoring NSM).
    let valid = self.first is Some(@bidi.L) && self.last is (@bidi.L | @bidi.EN)
    if valid {
      0
    } else {
      BreaksBidiRule
    }
  }
}
