///|
/// Apply IDNA mapping to a domain name
fn map_domain(
  domain : String,
  use_std3_ascii_rules~ : Bool,
) -> String raise IdnaError {
  let result = StringBuilder()
  for c in domain {
    match @idna_data.lookup_idna_mapping(c) {
      @idna_data.Valid | @idna_data.Deviation(_) =>
        // Keep the character (nontransitional mode keeps deviation as-is)
        result.write_char(c)
      @idna_data.Ignored =>
        // Remove the character (don't add to result)
        ()
      @idna_data.Mapped(mapping) =>
        // Replace with mapping
        for mapped_c in mapping {
          result.write_char(mapped_c)
        }
      @idna_data.Disallowed => raise DisallowedCodePoint(cp=c.to_int())
      @idna_data.DisallowedSTD3Valid =>
        if use_std3_ascii_rules {
          raise DisallowedCodePoint(cp=c.to_int())
        } else {
          result.write_char(c)
        }
      @idna_data.DisallowedSTD3Mapped(mapping) =>
        if use_std3_ascii_rules {
          raise DisallowedCodePoint(cp=c.to_int())
        } else {
          for mapped_c in mapping {
            result.write_char(mapped_c)
          }
        }
    }
  }
  result.to_string()
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
  let current = StringBuilder()
  for c in domain {
    if is_label_separator(c) {
      labels.push(current.to_string())
      current.reset()
    } else {
      current.write_char(c)
    }
  }

  // Add final label
  labels.push(current.to_string())
  labels
}

///|
/// Check if a character is a label separator
fn is_label_separator(c : Char) -> Bool {
  c == '.' || c == '\u{3002}' || c == '\u{FF0E}' || c == '\u{FF61}'
}
