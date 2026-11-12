///|
/// Full uppercase mapping of a string: every code point is replaced with its
/// full uppercase mapping, as `full_uppercase` gives it, so "Straße" becomes
/// "STRASSE". Builds one string, with nothing allocated per character.
///
/// Context-free: the conditional mappings of SpecialCasing.txt, which depend
/// on the surrounding text or on the language, are not applied. Unpaired
/// surrogates are copied as they are.
pub fn uppercase(s : StringView) -> String {
  map_string(
    s,
    case_upper_deltas,
    1,
    special_upper_cps,
    special_upper_strings,
    AsciiCase::Upper,
  )
}

///|
/// Full lowercase mapping of a string: every code point is replaced with its
/// full lowercase mapping, as `full_lowercase` gives it, so "İ" becomes
/// "i\u{0307}". Builds one string, with nothing allocated per character.
///
/// Context-free: the conditional mappings of SpecialCasing.txt, which depend
/// on the surrounding text or on the language, are not applied. In
/// particular Σ always becomes σ, never the final form ς. Unpaired surrogates
/// are copied as they are.
pub fn lowercase(s : StringView) -> String {
  map_string(
    s,
    case_lower_deltas,
    2,
    special_lower_cps,
    special_lower_strings,
    AsciiCase::Lower,
  )
}

///|
/// How a case maps ASCII: only letters change, a-z to A-Z or A-Z to a-z. A
/// test checks this against the tables.
priv enum AsciiCase {
  Upper
  Lower
}

///|
/// Map `s` with one case's tables: `deltas` and the `flag` bit of
/// `case_special_flags` select the case, and the `special_*` arrays hold its
/// full mappings. `ascii` is how the same case maps ASCII.
///
/// The standard library maps ASCII letters several code units at a time on
/// these backends, so ASCII is mapped first, with one copy, and only the
/// other code points are looked up.
#cfg(not(target="js"))
fn map_string(
  s : StringView,
  deltas : ReadOnlyArray[Int32],
  flag : Int32,
  special_cps : ReadOnlyArray[Int32],
  special_strings : ReadOnlyArray[String],
  ascii : AsciiCase,
) -> String {
  let mapped = match ascii {
    Upper => s.to_upper()
    Lower => s.to_lower()
  }
  map_non_ascii(mapped, deltas, flag, special_cps, special_strings)
}

///|
/// Map `s` with one case's tables, as the other backends do. On JavaScript
/// the standard library maps ASCII one character at a time into a new
/// string, so mapping it first would cost a second pass: ASCII letters are
/// mapped in the same pass instead.
#cfg(target="js")
fn map_string(
  s : StringView,
  deltas : ReadOnlyArray[Int32],
  flag : Int32,
  special_cps : ReadOnlyArray[Int32],
  special_strings : ReadOnlyArray[String],
  ascii : AsciiCase,
) -> String {
  let (ascii_first, ascii_delta) = match ascii {
    Upper => ('a'.to_int(), -32)
    Lower => ('A'.to_int(), 32)
  }
  let length = s.length()
  let out = StringBuilder(size_hint=length)
  // Code units before `copied` are in `out`.
  let mut copied = 0
  for index = 0; index < length; {
    // SAFETY: index < length.
    let unit = s.unsafe_get(index).to_int()
    if unit < 0x80 {
      if (unit - ascii_first).reinterpret_as_uint() < 26 {
        if copied < index {
          // SAFETY: copied < index < length, both on code point boundaries.
          out.write_view(s.unsafe_view(start=copied, end=index))
        }
        out.write_char((unit + ascii_delta).unsafe_to_char())
        copied = index + 1
      }
      continue index + 1
    }
    let cp = code_point_at(s, index, length)
    let width = utf16_width(cp)
    let record = lookup_case_record(cp.unsafe_to_char())
    let delta = deltas[record]
    let special = (case_special_flags[record].to_int() & flag) != 0
    if delta != 0 || special {
      if copied < index {
        // SAFETY: copied < index < length, both on code point boundaries.
        out.write_view(s.unsafe_view(start=copied, end=index))
      }
      let found = if special { find_special(special_cps, cp) } else { -1 }
      if found >= 0 {
        out.write_string(special_strings[found])
      } else {
        out.write_char((cp + delta).unsafe_to_char())
      }
      copied = index + width
    }
    continue index + width
  }
  if copied == 0 {
    // Nothing changed.
    return s.to_owned()
  }
  // SAFETY: copied <= length, on a code point boundary.
  out.write_view(s.unsafe_view(start=copied, end=length))
  out.to_string()
}

///|
/// Map the non-ASCII code points of `s`, whose ASCII characters are mapped
/// already, with one case's tables: `deltas` and the `flag` bit of
/// `case_special_flags` select the case, and the `special_*` arrays hold its
/// full mappings.
///
/// The standard library maps ASCII several code units at a time on native
/// and Wasm, so text that is mostly ASCII costs little more than one copy.
/// The unchanged prefix is found without building anything; from the first
/// change on, runs of unchanged code points are copied at once.
#cfg(not(target="js"))
fn map_non_ascii(
  s : StringView,
  deltas : ReadOnlyArray[Int32],
  flag : Int32,
  special_cps : ReadOnlyArray[Int32],
  special_strings : ReadOnlyArray[String],
) -> String {
  let length = s.length()
  let first_change = for index = 0; index < length; {
    // SAFETY: index < length.
    let unit = s.unsafe_get(index)
    if unit < 0x80 {
      continue index + ascii_run(s, unit, index, length)
    }
    let cp = code_point_at(s, index, length)
    let record = lookup_case_record(cp.unsafe_to_char())
    if deltas[record] != 0 || (case_special_flags[record].to_int() & flag) != 0 {
      break index
    }
    continue index + utf16_width(cp)
  } nobreak {
    // A view of a whole string gives that string back without a copy.
    return s.to_owned()
  }
  let out = StringBuilder(size_hint=length)
  // Code units before `copied` are in `out`.
  let mut copied = 0
  for index = first_change; index < length; {
    // SAFETY: index < length.
    let unit = s.unsafe_get(index)
    if unit < 0x80 {
      continue index + ascii_run(s, unit, index, length)
    }
    let cp = code_point_at(s, index, length)
    let width = utf16_width(cp)
    let record = lookup_case_record(cp.unsafe_to_char())
    let delta = deltas[record]
    let special = (case_special_flags[record].to_int() & flag) != 0
    if delta != 0 || special {
      // Changed characters often come in runs: skip the empty copy between.
      if copied < index {
        // SAFETY: copied < index < length, both on code point boundaries.
        out.write_view(s.unsafe_view(start=copied, end=index))
      }
      let found = if special { find_special(special_cps, cp) } else { -1 }
      if found >= 0 {
        out.write_string(special_strings[found])
      } else {
        out.write_char((cp + delta).unsafe_to_char())
      }
      copied = index + width
    }
    continue index + width
  }
  // SAFETY: copied <= length, on a code point boundary.
  out.write_view(s.unsafe_view(start=copied, end=length))
  out.to_string()
}

///|
/// How far to skip from the ASCII code unit `unit` at `index`: four code
/// units when they are all ASCII, otherwise one. A single expression, so
/// that it is inlined into the loops.
#cfg(not(target="js"))
fn ascii_run(
  s : StringView,
  unit : UInt16,
  index : Int32,
  length : Int32,
) -> Int32 {
  // `length - index` cannot overflow, unlike `index + 4`.
  // SAFETY: index + 3 < length when the first test holds.
  if length - index >= 4 &&
    (
      unit |
      s.unsafe_get(index + 1) |
      s.unsafe_get(index + 2) |
      s.unsafe_get(index + 3)
    ) <
    0x80 {
    4
  } else {
    1
  }
}

///|
/// The code point starting at `index`. An unpaired surrogate is returned as
/// it is, as iterating over the view does.
fn code_point_at(s : StringView, index : Int32, length : Int32) -> Int32 {
  // SAFETY: callers guarantee 0 <= index < length.
  let first = s.unsafe_get(index)
  if first.is_leading_surrogate() && index + 1 < length {
    // SAFETY: index + 1 < length is checked above.
    let second = s.unsafe_get(index + 1)
    if second.is_trailing_surrogate() {
      return 0x10000 +
        ((first.to_int() - 0xD800) << 10) +
        second.to_int() -
        0xDC00
    }
  }
  first.to_int()
}

///|
/// The number of UTF-16 code units of `cp`.
fn utf16_width(cp : Int32) -> Int32 {
  if cp >= 0x10000 {
    2
  } else {
    1
  }
}

///|
/// Index of `key` in the sorted array `cps`, or -1 if it is absent.
fn find_special(cps : ReadOnlyArray[Int32], key : Int32) -> Int32 {
  let mut left = 0
  let mut right = cps.length() - 1
  while left <= right {
    let mid = (left + right) / 2
    let value = cps[mid]
    if key < value {
      right = mid - 1
    } else if key > value {
      left = mid + 1
    } else {
      return mid
    }
  }
  -1
}
