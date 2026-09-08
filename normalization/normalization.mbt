///|
/// Unicode Normalization Forms (UAX #15)
///
/// This module implements the four Unicode normalization forms:
/// - NFD: Canonical Decomposition
/// - NFC: Canonical Decomposition followed by Canonical Composition
/// - NFKD: Compatibility Decomposition
/// - NFKC: Compatibility Decomposition followed by Canonical Composition

///|
/// Normalization form enumeration
pub(all) enum NormalizationForm {
  NFD // Canonical Decomposition
  NFC // Canonical Decomposition + Composition
  NFKD // Compatibility Decomposition
  NFKC // Compatibility Decomposition + Composition
} derive(Eq)

///|
pub impl Show for NormalizationForm with fn output(self, logger) {
  match self {
    NFD => logger.write_string("NFD")
    NFC => logger.write_string("NFC")
    NFKD => logger.write_string("NFKD")
    NFKC => logger.write_string("NFKC")
  }
}

///|
/// Convert array of characters to string
fn chars_to_string(chars : Array[Char]) -> String {
  let sb = StringBuilder()
  for c in chars {
    sb.write_char(c)
  }
  sb.to_string()
}

///|
/// Normalize a string to NFD (Canonical Decomposition)
///
/// Characters are decomposed to their canonical equivalents and
/// combining marks are reordered by Canonical Combining Class.
pub fn nfd(s : String) -> String {
  if is_ascii_only(s) {
    return s // pure ASCII is already NFD
  }
  let chars = decompose_string(s, compatibility=false)
  let _ = canonical_order(chars)
  chars_to_string(chars)
}

///|
/// Normalize a string to NFC (Canonical Decomposition + Composition)
///
/// Characters are first decomposed canonically, reordered, then
/// recomposed using canonical composition rules.
/// This is the most commonly used normalization form.
pub fn nfc(s : String) -> String {
  if is_ascii_only(s) {
    return s // pure ASCII is already NFC
  }
  let chars = decompose_string(s, compatibility=false)
  let saw_marks = canonical_order(chars)
  // Composition is a no-op when ordering found no combining marks and the
  // text has no code point >= U+0300: every canonical composition pair and
  // every Hangul jamo involves such a code point, so skipping is safe. Any
  // ccc=0 composition second (e.g. spacing vowel signs) is also >= U+0300,
  // so such input still takes the compose path.
  let composed = if !saw_marks && can_skip_composition(chars) {
    chars
  } else {
    canonical_compose(chars)
  }
  chars_to_string(composed)
}

///|
/// Normalize a string to NFKD (Compatibility Decomposition)
///
/// Characters are decomposed to their compatibility equivalents
/// (including formatting variants like superscripts, fractions, etc.)
/// and combining marks are reordered.
pub fn nfkd(s : String) -> String {
  if is_ascii_only(s) {
    return s // pure ASCII is already NFKD
  }
  let chars = decompose_string(s, compatibility=true)
  let _ = canonical_order(chars)
  chars_to_string(chars)
}

///|
/// Normalize a string to NFKC (Compatibility Decomposition + Composition)
///
/// Characters are decomposed to compatibility equivalents, reordered,
/// then recomposed. Often used for identifier comparison.
pub fn nfkc(s : String) -> String {
  if is_ascii_only(s) {
    return s // pure ASCII is already NFKC
  }
  let chars = decompose_string(s, compatibility=true)
  let saw_marks = canonical_order(chars)
  // Composition is a no-op when ordering found no combining marks and the
  // text has no code point >= U+0300: every canonical composition pair and
  // every Hangul jamo involves such a code point, so skipping is safe. Any
  // ccc=0 composition second (e.g. spacing vowel signs) is also >= U+0300,
  // so such input still takes the compose path.
  let composed = if !saw_marks && can_skip_composition(chars) {
    chars
  } else {
    canonical_compose(chars)
  }
  chars_to_string(composed)
}

///|
/// Normalize a string to the specified form
pub fn normalize(s : String, form : NormalizationForm) -> String {
  match form {
    NFD => nfd(s)
    NFC => nfc(s)
    NFKD => nfkd(s)
    NFKC => nfkc(s)
  }
}

///|
/// Check if a string is in the specified normalization form
pub fn is_normalized(s : String, form : NormalizationForm) -> Bool {
  if is_ascii_only(s) {
    return true // pure ASCII is normalized under every form
  }
  normalize(s, form) == s
}

///|
/// Check whether the string consists only of ASCII code points.
/// ASCII text has no decompositions, no combining marks and no Hangul, so it
/// is already in every normalization form: all forms can return it unchanged.
fn is_ascii_only(s : String) -> Bool {
  for c in s {
    if c.to_int() >= 0x80 {
      return false
    }
  }
  true
}

///|
/// Whether no canonical composition can possibly apply to the (ordered)
/// character array: every code point is below U+0300. All canonical
/// composition seconds and all Hangul jamo are >= U+0300.
fn can_skip_composition(chars : Array[Char]) -> Bool {
  for c in chars {
    if c.to_int() >= 0x300 {
      return false
    }
  }
  true
}
