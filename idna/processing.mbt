///|
/// Apply IDNA mapping to a domain name
///
/// A domain that needs no mapping is returned as is.
fn map_domain(
  domain : String,
  use_std3_ascii_rules~ : Bool,
) -> String raise IdnaError {
  map_text(domain, use_std3_ascii_rules~).unwrap_or(domain)
}

///|
/// Apply IDNA mapping to `text`, or return `None` when it leaves `text` as it
/// is. The result is built only once a character is removed or replaced.
fn map_text(
  text : StringView,
  use_std3_ascii_rules~ : Bool,
) -> String? raise IdnaError {
  let mut output : StringBuilder? = None
  // UTF-16 offset of `c`, to copy the unchanged prefix on the first change.
  let mut offset = 0
  for c in text {
    let code = c.to_int()
    if code < 0x80 {
      // IdnaMappingTable has every ASCII character valid but A-Z, which it
      // maps to a-z, so ASCII needs no lookup.
      let mapped = if code is ('A'..<='Z') {
        (code + 32).unsafe_to_char()
      } else {
        c
      }
      if output is Some(output) {
        output.write_char(mapped)
      } else if mapped != c {
        let builder = mapping_builder(text, offset)
        builder.write_char(mapped)
        output = Some(builder)
      }
      offset += 1
      continue
    }
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
      let builder = mapping_builder(text, offset)
      entry.write_mapping(builder)
      output = Some(builder)
    }
    offset += if code > 0xFFFF { 2 } else { 1 }
  }
  if output is Some(output) {
    Some(output.to_string())
  } else {
    None
  }
}

///|
/// A builder for the mapping of `text`, holding its first `offset` code
/// units, which the mapping leaves as they are.
fn mapping_builder(text : StringView, offset : Int32) -> StringBuilder {
  // The size hint counts bytes, two per UTF-16 code unit.
  let builder = StringBuilder(size_hint=2 * text.length())
  builder.write_view(text[:offset])
  builder
}

///|
/// Map and normalize one label, or return `None` when that leaves it as it
/// is. Every character of such a label has a valid status.
fn map_and_normalize_label(
  label : StringView,
  use_std3_ascii_rules~ : Bool,
) -> String? raise IdnaError {
  if map_text(label, use_std3_ascii_rules~) is Some(mapped) {
    Some(@normalization.nfc(mapped))
  } else if @normalization.is_normalized(label, @normalization.NFC) {
    None
  } else {
    Some(@normalization.nfc(label))
  }
}

///|
/// Offset of the first label separator in `domain` at or after `start`, or
/// the length of `domain` when the last label starts at `start`.
fn label_end(domain : StringView, start : Int32) -> Int32 {
  // Separators are single UTF-16 code units, so slicing at them never
  // splits a surrogate pair.
  for i in start..<domain.length() {
    if domain[i] is ('.' | '\u{3002}' | '\u{FF0E}' | '\u{FF61}') {
      return i
    }
  }
  domain.length()
}
