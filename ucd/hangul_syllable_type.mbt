///|
/// Unicode Hangul_Syllable_Type values
/// See the Unicode Standard, section 3.12, Conjoining Jamo Behavior:
/// https://www.unicode.org/versions/latest/core-spec/chapter-3/#G24646
pub(all) enum HangulSyllableType {
  NotApplicable // NA
  LeadingJamo // L
  VowelJamo // V
  TrailingJamo // T
  LVSyllable // LV
  LVTSyllable // LVT
} derive(Debug, Eq)

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend HangulSyllableType with Debug::{to_repr}

///|
pub extend HangulSyllableType with Eq::{not_equal, equal}

///|
pub extend HangulSyllableType with Show::{to_string, output}

///|
pub impl Show for HangulSyllableType with fn output(self, logger) {
  match self {
    NotApplicable => logger.write_string("NotApplicable")
    LeadingJamo => logger.write_string("LeadingJamo")
    VowelJamo => logger.write_string("VowelJamo")
    TrailingJamo => logger.write_string("TrailingJamo")
    LVSyllable => logger.write_string("LVSyllable")
    LVTSyllable => logger.write_string("LVTSyllable")
  }
}

///|
/// Convert HangulSyllableType ordinal to enum value
fn ordinal_to_hangul_syllable_type(ordinal : Int32) -> HangulSyllableType {
  match ordinal {
    1 => LeadingJamo
    2 => VowelJamo
    3 => TrailingJamo
    4 => LVSyllable
    5 => LVTSyllable
    _ => NotApplicable // 0 or any unknown
  }
}

///|
/// Get the Hangul_Syllable_Type for a character.
///
/// Hangul_Syllable_Type tells the conjoining jamo apart from the precomposed
/// syllables: a leading consonant, a vowel, a trailing consonant, a syllable
/// of a leading consonant and a vowel, or one that also has a trailing
/// consonant. Every other character, including the Hangul compatibility
/// jamo and unassigned code points, is NotApplicable.
///
/// It is narrower than Grapheme_Cluster_Break, whose V value also covers a
/// few characters outside Hangul.
pub fn hangul_syllable_type(c : Char) -> HangulSyllableType {
  ordinal_to_hangul_syllable_type(
    @hangul_syllable_type.lookup_hangul_syllable_type(c),
  )
}
