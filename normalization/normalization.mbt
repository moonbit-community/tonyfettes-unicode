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
pub extend NormalizationForm with Eq::{not_equal, equal}

///|
pub extend NormalizationForm with Show::{to_string, output}

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
/// Normalize a string to NFD (Canonical Decomposition)
///
/// Characters are decomposed to their canonical equivalents and
/// combining marks are reordered by Canonical Combining Class.
pub fn nfd(s : String) -> String {
  normalize_spans(s, 12, 1, compatibility=false, compose=false)
}

///|
/// Normalize a string to NFC (Canonical Decomposition + Composition)
///
/// Characters are first decomposed canonically, reordered, then
/// recomposed using canonical composition rules.
/// This is the most commonly used normalization form.
pub fn nfc(s : String) -> String {
  normalize_spans(s, 8, 3, compatibility=false, compose=true)
}

///|
/// Normalize a string to NFKD (Compatibility Decomposition)
///
/// Characters are decomposed to their compatibility equivalents
/// (including formatting variants like superscripts, fractions, etc.)
/// and combining marks are reordered.
pub fn nfkd(s : String) -> String {
  normalize_spans(s, 13, 1, compatibility=true, compose=false)
}

///|
/// Normalize a string to NFKC (Compatibility Decomposition + Composition)
///
/// Characters are decomposed to compatibility equivalents, reordered,
/// then recomposed. Often used for identifier comparison.
pub fn nfkc(s : String) -> String {
  normalize_spans(s, 10, 3, compatibility=true, compose=true)
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
  let result = match form {
    NFC =>
      process_spans(s, 8, 3, compatibility=false, compose=true, check_only=true)
    NFKC =>
      process_spans(s, 10, 3, compatibility=true, compose=true, check_only=true)
    NFD =>
      process_spans(
        s,
        12,
        1,
        compatibility=false,
        compose=false,
        check_only=true,
      )
    NFKD =>
      process_spans(
        s,
        13,
        1,
        compatibility=true,
        compose=false,
        check_only=true,
      )
  }
  result is Some(_)
}
