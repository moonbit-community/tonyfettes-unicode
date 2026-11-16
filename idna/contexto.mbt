///|
/// RFC 5892 Appendix A.3-A.9: contextual rules other than join controls.
/// The caller passes a mapped, normalized label containing a CONTEXTO
/// character. Script tests use the Unicode Script property, not blocks or
/// Script_Extensions.
fn validate_contexto(label : StringView) -> Unit raise IdnaError {
  let chars = label.to_array()
  let mut has_japanese = false
  let mut has_katakana_middle_dot = false
  let mut has_arabic_indic_digits = false
  let mut has_extended_arabic_indic_digits = false
  for i, c in chars {
    match c {
      '\u{00B7}' => {
        // Catalan middle dot must occur between two lowercase l's.
        guard i > 0 && chars[i - 1] == 'l' && chars.get(i + 1) is Some('l') else {
          raise InvalidContextO(cp=c.to_int())
        }
      }
      '\u{0375}' => {
        guard chars.get(i + 1) is Some(next) && @idna_data.is_greek(next) else {
          raise InvalidContextO(cp=c.to_int())
        }
      }
      '\u{05F3}' | '\u{05F4}' => {
        guard i > 0 && @idna_data.is_hebrew(chars[i - 1]) else {
          raise InvalidContextO(cp=c.to_int())
        }
      }
      '\u{30FB}' => has_katakana_middle_dot = true
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
    if !has_japanese && @idna_data.is_japanese(c) {
      has_japanese = true
    }
  }
  // U+30FB itself has Script=Common, so it cannot satisfy its own rule.
  if has_katakana_middle_dot && !has_japanese {
    raise InvalidContextO(cp=0x30FB)
  }
}
