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
} derive(Eq, Show)

///|
/// Normalize a string to NFD (Canonical Decomposition)
///
/// Characters are decomposed to their canonical equivalents and
/// combining marks are reordered by Canonical Combining Class.
pub fn nfd(s : String) -> String {
  let codepoints = decompose_string(s, compatibility=false)
  canonical_order(codepoints)
  codepoints_to_string(codepoints)
}

///|
/// Normalize a string to NFC (Canonical Decomposition + Composition)
///
/// Characters are first decomposed canonically, reordered, then
/// recomposed using canonical composition rules.
/// This is the most commonly used normalization form.
pub fn nfc(s : String) -> String {
  let codepoints = decompose_string(s, compatibility=false)
  canonical_order(codepoints)
  let composed = canonical_compose(codepoints)
  codepoints_to_string(composed)
}

///|
/// Normalize a string to NFKD (Compatibility Decomposition)
///
/// Characters are decomposed to their compatibility equivalents
/// (including formatting variants like superscripts, fractions, etc.)
/// and combining marks are reordered.
pub fn nfkd(s : String) -> String {
  let codepoints = decompose_string(s, compatibility=true)
  canonical_order(codepoints)
  codepoints_to_string(codepoints)
}

///|
/// Normalize a string to NFKC (Compatibility Decomposition + Composition)
///
/// Characters are decomposed to compatibility equivalents, reordered,
/// then recomposed. Often used for identifier comparison.
pub fn nfkc(s : String) -> String {
  let codepoints = decompose_string(s, compatibility=true)
  canonical_order(codepoints)
  let composed = canonical_compose(codepoints)
  codepoints_to_string(composed)
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
  normalize(s, form) == s
}
