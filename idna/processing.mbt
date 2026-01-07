///|
/// IDNA processing algorithm (UTS #46 Section 4)

///|
/// Process a domain name according to UTS #46
/// Steps: Map -> Normalize -> Break -> Convert/Validate
fn process_domain(
  domain : String,
  use_std3_ascii_rules~ : Bool,
  check_hyphens~ : Bool,
  check_bidi~ : Bool,
  check_joiners~ : Bool,
) -> String raise IdnaError {
  // Step 1: Map
  let mapped = map_domain(domain, use_std3_ascii_rules~)

  // Step 2: Normalize (NFC)
  let normalized = @normalization.nfc(mapped)

  // Step 3: Break into labels (done in caller)
  // Step 4: Validate each label

  // Validate the normalized domain
  let labels = split_labels(normalized)
  for label in labels {
    validate_label(
      label,
      use_std3_ascii_rules~,
      check_hyphens~,
      check_bidi~,
      check_joiners~,
    )
  }
  normalized
}

///|
/// Apply IDNA mapping to a domain name
fn map_domain(
  domain : String,
  use_std3_ascii_rules~ : Bool,
) -> String raise IdnaError {
  let result = StringBuilder::new()
  for c in domain {
    let cp = c.to_int()
    let (status, mapping) = @idna_data.lookup_idna_mapping(cp)
    match status {
      @idna_data.Valid | @idna_data.Deviation =>
        // Keep the character (nontransitional mode keeps deviation as-is)
        result.write_char(c)
      @idna_data.Ignored =>
        // Remove the character (don't add to result)
        ()
      @idna_data.Mapped =>
        // Replace with mapping
        for mapped_cp in mapping {
          write_codepoint(result, mapped_cp)
        }
      @idna_data.Disallowed => raise DisallowedCodePoint(cp~)
      @idna_data.DisallowedSTD3Valid =>
        if use_std3_ascii_rules {
          raise DisallowedCodePoint(cp~)
        } else {
          result.write_char(c)
        }
      @idna_data.DisallowedSTD3Mapped =>
        if use_std3_ascii_rules {
          raise DisallowedCodePoint(cp~)
        } else {
          for mapped_cp in mapping {
            write_codepoint(result, mapped_cp)
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
  let current = StringBuilder::new()
  for c in domain {
    let cp = c.to_int()
    if is_label_separator(cp) {
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
/// Check if a code point is a label separator
fn is_label_separator(cp : Int) -> Bool {
  cp == 0x002E || cp == 0x3002 || cp == 0xFF0E || cp == 0xFF61
}

///|
/// Write a code point to a StringBuilder
fn write_codepoint(sb : StringBuilder, cp : Int) -> Unit {
  if cp <= 0xFFFF {
    sb.write_char(cp.unsafe_to_char())
  } else {
    // Encode as surrogate pair
    let adjusted = cp - 0x10000
    let high = 0xD800 + (adjusted >> 10)
    let low = 0xDC00 + (adjusted & 0x3FF)
    sb.write_char(high.unsafe_to_char())
    sb.write_char(low.unsafe_to_char())
  }
}
