///|
/// Apply IDNA mapping to a domain name
///
/// The result is built only once a character is removed or replaced, so a
/// domain that needs no mapping is returned as is.
fn map_domain(
  domain : String,
  use_std3_ascii_rules~ : Bool,
) -> String raise IdnaError {
  let mut output : StringBuilder? = None
  // UTF-16 offset of `c`, to copy the unchanged prefix on the first change.
  let mut offset = 0
  for c in domain {
    let entry = @idna_data.lookup_idna_entry(c)
    let keep = match entry.status() {
      // Nontransitional processing keeps deviation characters as they are.
      Valid | Deviation => true
      Ignored | Mapped => false
      Disallowed => raise DisallowedCodePoint(cp=c.to_int())
      DisallowedSTD3Valid =>
        if use_std3_ascii_rules {
          raise DisallowedCodePoint(cp=c.to_int())
        } else {
          true
        }
      DisallowedSTD3Mapped =>
        if use_std3_ascii_rules {
          raise DisallowedCodePoint(cp=c.to_int())
        } else {
          false
        }
    }
    if output is Some(output) {
      if keep {
        output.write_char(c)
      } else {
        // An ignored character has an empty mapping.
        entry.write_mapping(output)
      }
    } else if !keep {
      // The size hint counts bytes, two per UTF-16 code unit.
      let builder = StringBuilder(size_hint=2 * domain.length())
      builder.write_view(domain[:offset])
      entry.write_mapping(builder)
      output = Some(builder)
    }
    offset += if c.to_int() > 0xFFFF { 2 } else { 1 }
  }
  if output is Some(output) {
    output.to_string()
  } else {
    domain
  }
}

///|
/// Apply IDNA mapping to a single label (for ToUnicode)
fn map_label(
  label : String,
  use_std3_ascii_rules~ : Bool,
) -> String raise IdnaError {
  map_domain(label, use_std3_ascii_rules~)
}

///|
/// Split domain into labels at separators
fn split_labels(domain : String) -> Array[String] {
  let labels : Array[String] = []
  // Separators are single UTF-16 code units, so slicing at them never
  // splits a surrogate pair.
  let mut start = 0
  for i in 0..<domain.length() {
    if domain[i] is ('.' | '\u{3002}' | '\u{FF0E}' | '\u{FF61}') {
      labels.push(domain[start:i].to_owned())
      start = i + 1
    }
  }

  // Add final label
  labels.push(domain[start:].to_owned())
  labels
}
