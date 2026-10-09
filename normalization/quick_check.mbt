///|
priv enum QuickCheck {
  Yes
  No
  Maybe
}

///|
/// ASCII has CCC=0 and Quick_Check=Yes for every normalization form.
fn normalization_properties(c : Char) -> Int {
  if c.to_int() < 0x80 {
    0
  } else {
    @ccc.lookup_normalization_properties(c)
  }
}

///|
/// UAX #15 section 9: No dominates Maybe, and ordering is checked even when
/// every character individually has Quick_Check=Yes. CCC=0 resets ordering.
fn quick_check(s : String, shift : Int, mask : Int) -> QuickCheck {
  let mut previous_ccc = 0
  let mut result = Yes
  for c in s {
    let properties = normalization_properties(c)
    let ccc = properties & 255
    if ccc != 0 && previous_ccc > ccc {
      return No
    }
    let check = (properties >> shift) & mask
    if check == 1 {
      return No
    }
    if check == 2 {
      result = Maybe
    }
    previous_ccc = ccc
  }
  result
}

///|
/// Apply the full algorithm only to a span bounded by safe boundaries.
fn append_normalized_span(
  out : StringBuilder,
  span : StringView,
  compatibility~ : Bool,
  compose~ : Bool,
) -> Unit {
  let chars = decompose_string(span, compatibility~)
  canonical_order(chars)
  let normalized = if compose { canonical_compose(chars) } else { chars }
  for c in normalized {
    out.write_char(c)
  }
}

///|
/// UAX #15 section 9.1: there is a safe boundary BEFORE a character with
/// Quick_Check=Yes and CCC=0. Keep that character with the following marks:
/// even a precomposed starter can change when another mark follows it.
/// See https://www.unicode.org/reports/tr15/#Stable_Code_Points.
///
/// Coalesce suspect spans across short clean gaps (under 16 UTF-16 units),
/// avoiding per-starter allocations in densely mixed text. Copy longer clean
/// spans together. Allocate a builder only
/// when a suspect span is reached; an entirely quick-check-Yes string is
/// returned unchanged. Offsets count UTF-16 code units, not characters.
fn normalize_spans(
  s : String,
  shift : Int,
  mask : Int,
  compatibility~ : Bool,
  compose~ : Bool,
) -> String {
  let mut output : StringBuilder? = None
  let mut copied_until = 0
  let mut span_start = 0
  let mut normalize_start = -1
  let mut normalize_end = 0
  let mut offset = 0
  let mut previous_ccc = 0
  let mut suspect = false
  for c in s {
    let properties = normalization_properties(c)
    let ccc = properties & 255
    let check = (properties >> shift) & mask
    if ccc == 0 && check == 0 {
      if suspect {
        normalize_end = offset
      } else if normalize_start >= 0 && offset - normalize_end >= 16 {
        let out = if output is Some(out) {
          out
        } else {
          let out = StringBuilder(size_hint=s.length())
          output = Some(out)
          out
        }
        out.write_view(s[copied_until:normalize_start])
        append_normalized_span(
          out,
          s[normalize_start:normalize_end],
          compatibility~,
          compose~,
        )
        copied_until = normalize_end
        normalize_start = -1
      }
      span_start = offset
      suspect = false
    }
    if check != 0 || (ccc != 0 && previous_ccc > ccc) {
      if normalize_start < 0 {
        normalize_start = span_start
      }
      suspect = true
    }
    previous_ccc = ccc
    offset += if c.to_int() > 0xFFFF { 2 } else { 1 }
  }
  if normalize_start >= 0 {
    let out = if output is Some(out) {
      out
    } else {
      StringBuilder(size_hint=s.length())
    }
    out.write_view(s[copied_until:normalize_start])
    let end = if suspect { s.length() } else { normalize_end }
    append_normalized_span(
      out,
      s[normalize_start:end],
      compatibility~,
      compose~,
    )
    out.write_view(s[end:])
    out.to_string()
  } else if output is Some(out) {
    out.write_view(s[copied_until:])
    out.to_string()
  } else {
    s
  }
}
