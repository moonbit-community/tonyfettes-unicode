///|
/// Derived property of one code point (RFC 5892 3), in the form a mapped,
/// NFC-normalised label needs it.
///
/// `Unassigned` (2.10) is folded into `Disallowed` because neither value may
/// appear in a label.
priv enum Idna2008Property {
  Pvalid
  ContextJ
  ContextO
  Disallowed
}

///|
/// IDNA2008 label validity (RFC 5892), on top of the UTS #46 validity criteria
/// `validate_label` already applies.
///
/// UTS #46 and IDNA2008 are different contracts. Section 4.1 of UTS #46 asks
/// whether a label is usable after mapping, and its mapping table marks
/// punctuation, symbols and the RFC 5892 2.6 exception code points
/// `valid`, so a ToASCII-only pipeline accepts labels IDNA2008 forbids:
/// U+00A1 INVERTED EXCLAMATION MARK, U+0640 ARABIC TATWEEL and U+302E HANGUL
/// SINGLE DOT TONE MARK all pass UTS #46 validity and fail RFC 5892. This
/// function adds the Section 3 derived property and the Appendix A contextual
/// rules for the CONTEXTO code points.
fn validate_idna2008_label(label : StringView) -> Unit raise IdnaError {
  let chars = label.to_array()
  let mut arabic_indic_digits = false
  let mut extended_arabic_indic_digits = false
  let mut kana_or_han = false
  for c in chars {
    match idna2008_property(c) {
      Disallowed => raise DisallowedCodePoint(cp=c.to_int())
      Pvalid | ContextJ | ContextO => ()
    }
    if c is ('\u{0660}'..<='\u{0669}') {
      arabic_indic_digits = true
    } else if c is ('\u{06F0}'..<='\u{06F9}') {
      extended_arabic_indic_digits = true
    }
    if is_kana_or_han_script(c) {
      kana_or_han = true
    }
  }
  // Appendix A.8 / A.9: the two Arabic-Indic digit blocks must not be mixed.
  if arabic_indic_digits && extended_arabic_indic_digits {
    raise InvalidContextO
  }
  for i, c in chars {
    if idna2008_property(c) is ContextO {
      validate_contexto(chars, i, kana_or_han~)
    }
  }
}

///|
/// RFC 5892 3: the derived property, decided in the order that section states.
///
/// `Unstable` (2.2) is not reproduced: it needs NFKC plus case folding of one
/// code point, and uppercase code points never reach this check because UTS #46
/// has already mapped them to lowercase.
fn idna2008_property(c : Char) -> Idna2008Property {
  // 2.6 Exceptions.
  if idna2008_exception(c) is Some(property) {
    return property
  }
  // 2.5 LDH.
  if c is ('-' | '0'..<='9' | 'a'..<='z') {
    return Pvalid
  }
  // 2.8 JoinControl. `validate_contextj` owns the Appendix A.1/A.2 rules, so
  // the property only has to mark the code points as context-dependent.
  if c is ('\u{200C}' | '\u{200D}') {
    return ContextJ
  }
  // 2.3 IgnorableProperties.
  if @ucd.is_default_ignorable_code_point(c) ||
    @ucd.is_white_space(c) ||
    is_noncharacter(c) {
    return Disallowed
  }
  // 2.4 IgnorableBlocks: Combining Diacritical Marks for Symbols, Musical
  // Symbols, Ancient Greek Musical Notation.
  if c
    is ('\u{20D0}'..<='\u{20FF}'
    | '\u{1D100}'..<='\u{1D1FF}'
    | '\u{1D200}'..<='\u{1D24F}') {
    return Disallowed
  }
  // 2.9 OldHangulJamo.
  if @ucd.hangul_syllable_type(c) is (LeadingJamo | VowelJamo | TrailingJamo) {
    return Disallowed
  }
  // 2.1 LetterDigits.
  if @ucd.general_category(c) is (Ll | Lu | Lo | Nd | Lm | Mn | Mc) {
    return Pvalid
  }
  Disallowed
}

///|
/// RFC 5892 2.6 Exceptions: the code points whose derived property cannot be
/// computed from the core property values, so the table decides.
fn idna2008_exception(c : Char) -> Idna2008Property? {
  match c.to_int() {
    0x00DF | 0x03C2 | 0x06FD | 0x06FE | 0x0F0B | 0x3007 => Some(Pvalid)
    0x00B7
    | 0x0375
    | 0x05F3
    | 0x05F4
    | 0x0660..<=0x0669
    | 0x06F0..<=0x06F9
    | 0x30FB => Some(ContextO)
    0x0640 | 0x07FA | 0x302E | 0x302F | 0x3031..<=0x3035 | 0x303B =>
      Some(Disallowed)
    _ => None
  }
}

///|
/// RFC 5892 Appendix A.3-A.7 contextual rules, for the CONTEXTO code points
/// whose rule depends on a neighbour. A.8/A.9 are decided once per label in
/// `validate_idna2008_label`, so they are not handled here.
fn validate_contexto(
  chars : Array[Char],
  pos : Int32,
  kana_or_han~ : Bool,
) -> Unit raise IdnaError {
  let c = chars[pos]
  if c is '\u{00B7}' {
    // A.3: MIDDLE DOT is valid only between two 'l' characters.
    if !(pos > 0 &&
      pos + 1 < chars.length() &&
      chars[pos - 1] == 'l' &&
      chars[pos + 1] == 'l') {
      raise InvalidContextO
    }
    return
  }
  if c is '\u{0375}' {
    // A.4: GREEK KERAIA must be followed by a Greek character.
    if !(pos + 1 < chars.length() && is_greek_script(chars[pos + 1])) {
      raise InvalidContextO
    }
    return
  }
  if c is ('\u{05F3}' | '\u{05F4}') {
    // A.5/A.6: GERESH and GERSHAYIM must be preceded by a Hebrew character.
    if !(pos > 0 && is_hebrew_script(chars[pos - 1])) {
      raise InvalidContextO
    }
    return
  }
  if c is '\u{30FB}' {
    // A.7: KATAKANA MIDDLE DOT needs a Hiragana, Katakana or Han character in
    // the label. Its own Script is Common, which is what this rule relies on.
    if !kana_or_han {
      raise InvalidContextO
    }
  }
}

///|
/// `Script(cp).eq.Greek`, approximated by the Greek and Coptic plus Greek
/// Extended blocks.
fn is_greek_script(c : Char) -> Bool {
  c is ('\u{0370}'..<='\u{03FF}' | '\u{1F00}'..<='\u{1FFF}')
}

///|
/// `Script(cp).eq.Hebrew`, approximated by the Hebrew block plus the Hebrew
/// presentation forms.
fn is_hebrew_script(c : Char) -> Bool {
  c is ('\u{0590}'..<='\u{05FF}' | '\u{FB1D}'..<='\u{FB4F}')
}

///|
/// `Script(cp).in.{Hiragana, Katakana, Han}`, approximated by the Hiragana,
/// Katakana, Katakana Phonetic Extensions, halfwidth Katakana and CJK blocks.
/// U+30FB is excluded because its Script is Common: the Appendix A.7 rule is
/// about the *other* characters of the label.
fn is_kana_or_han_script(c : Char) -> Bool {
  c
  is ('\u{3040}'..<='\u{309F}'
  | '\u{30A0}'..<='\u{30FA}'
  | '\u{30FC}'..<='\u{30FF}'
  | '\u{31F0}'..<='\u{31FF}'
  | '\u{3400}'..<='\u{4DBF}'
  | '\u{4E00}'..<='\u{9FFF}'
  | '\u{F900}'..<='\u{FAFF}'
  | '\u{FF66}'..<='\u{FF9D}'
  | '\u{20000}'..<='\u{2FA1F}')
}

///|
/// `Noncharacter_Code_Point`, which RFC 5892 2.3 adds to IgnorableProperties.
fn is_noncharacter(c : Char) -> Bool {
  let code = c.to_int()
  (code >= 0xFDD0 && code <= 0xFDEF) || (code & 0xFFFE) == 0xFFFE
}
