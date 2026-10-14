///|
/// Unicode East_Asian_Width values
/// See UAX #11: https://www.unicode.org/reports/tr11/
pub(all) enum EastAsianWidth {
  A // Ambiguous
  F // Fullwidth
  H // Halfwidth
  N // Neutral
  Na // Narrow
  W // Wide
} derive(Debug, Eq)

///|
pub extend EastAsianWidth with Debug::{to_repr}

///|
pub extend EastAsianWidth with Eq::{not_equal, equal}

///|
pub extend EastAsianWidth with Show::{to_string, output}

///|
pub impl Show for EastAsianWidth with fn output(self, logger) {
  match self {
    A => logger.write_string("A")
    F => logger.write_string("F")
    H => logger.write_string("H")
    N => logger.write_string("N")
    Na => logger.write_string("Na")
    W => logger.write_string("W")
  }
}

///|
/// Convert EastAsianWidth ordinal to enum value
fn ordinal_to_eaw(ordinal : Int32) -> EastAsianWidth {
  match ordinal {
    0 => A
    1 => F
    2 => H
    4 => Na
    5 => W
    _ => N // 3 or any unknown
  }
}

///|
/// Get the East_Asian_Width for a character.
///
/// East_Asian_Width classifies characters by the width they have in East
/// Asian typography. It is a property of a single character, not a column
/// count: nonspacing marks and control characters have a value too. Code
/// points the Unicode Character Database does not list are Neutral, except
/// that unassigned code points in the CJK ideograph blocks and in planes 2
/// and 3 are Wide.
pub fn east_asian_width(c : Char) -> EastAsianWidth {
  ordinal_to_eaw(@east_asian_width.lookup_east_asian_width(c))
}
