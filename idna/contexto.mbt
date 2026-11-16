///|
/// RFC 5892 Appendix A.3-A.9: contextual rules other than join controls.
/// The caller passes a mapped, normalized label containing a CONTEXTO
/// character. Script tests use the Unicode Script property, not blocks or
/// Script_Extensions.
fn validate_contexto(
  label : StringView,
  has_katakana_middle_dot~ : Bool,
) -> Unit raise IdnaError {
  // U+0000 cannot satisfy any of the preceding-character conditions.
  let mut previous = '\u{0000}'
  let mut has_japanese = false
  let mut has_arabic_indic_digits = false
  let mut has_extended_arabic_indic_digits = false
  for c in label {
    // Check a required successor when it arrives, before the current
    // character's own rule, so the earlier violation still takes precedence.
    if previous == '\u{00B7}' && c != 'l' {
      raise InvalidContextO(cp=0x00B7)
    }
    if previous == '\u{0375}' || (has_katakana_middle_dot && !has_japanese) {
      let properties = @idna_data.lookup_idna_properties(c)
      if previous == '\u{0375}' && !properties.is_greek() {
        raise InvalidContextO(cp=0x0375)
      }
      if properties.is_japanese() {
        has_japanese = true
      }
    }
    match c {
      '\u{00B7}' => {
        // The following l is checked on the next iteration.
        guard previous == 'l' else { raise InvalidContextO(cp=c.to_int()) }
      }
      '\u{05F3}' | '\u{05F4}' => {
        guard @idna_data.lookup_idna_properties(previous).is_hebrew() else {
          raise InvalidContextO(cp=c.to_int())
        }
      }
      '\u{0660}'..<='\u{0669}' => {
        guard !has_extended_arabic_indic_digits else {
          raise InvalidContextO(cp=c.to_int())
        }
        has_arabic_indic_digits = true
      }
      '\u{06F0}'..<='\u{06F9}' => {
        guard !has_arabic_indic_digits else {
          raise InvalidContextO(cp=c.to_int())
        }
        has_extended_arabic_indic_digits = true
      }
      _ => ()
    }
    previous = c
  }
  // A final middle dot or Greek numeral sign has no required successor.
  if previous is ('\u{00B7}' | '\u{0375}') {
    raise InvalidContextO(cp=previous.to_int())
  }
  // U+30FB itself has Script=Common, so it cannot satisfy its own rule.
  if has_katakana_middle_dot && !has_japanese {
    raise InvalidContextO(cp=0x30FB)
  }
}
