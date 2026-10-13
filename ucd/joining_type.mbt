///|
/// Unicode Joining_Type values
/// See the Unicode Standard, section 9.2, Arabic:
/// https://www.unicode.org/versions/latest/core-spec/chapter-9/#G7480
pub(all) enum JoiningType {
  NonJoining // U
  JoinCausing // C
  DualJoining // D
  LeftJoining // L
  RightJoining // R
  Transparent // T
} derive(Eq)

///|
pub extend JoiningType with Eq::{not_equal, equal}

///|
pub extend JoiningType with Show::{to_string, output}

///|
pub impl Show for JoiningType with fn output(self, logger) {
  match self {
    NonJoining => logger.write_string("NonJoining")
    JoinCausing => logger.write_string("JoinCausing")
    DualJoining => logger.write_string("DualJoining")
    LeftJoining => logger.write_string("LeftJoining")
    RightJoining => logger.write_string("RightJoining")
    Transparent => logger.write_string("Transparent")
  }
}

///|
/// Convert JoiningType ordinal to enum value
fn ordinal_to_joining_type(ordinal : Int32) -> JoiningType {
  match ordinal {
    1 => JoinCausing
    2 => DualJoining
    3 => LeftJoining
    4 => RightJoining
    5 => Transparent
    _ => NonJoining // 0 or any unknown
  }
}

///|
/// Get the Joining_Type for a character.
///
/// Joining_Type describes how a character takes part in cursive joining in
/// scripts such as Arabic, Syriac, and Mongolian. Transparent characters,
/// mostly nonspacing marks and format characters, do not interrupt joining
/// between the characters on either side of them. Characters that take no
/// part in cursive joining, including unassigned code points, are NonJoining.
pub fn joining_type(c : Char) -> JoiningType {
  ordinal_to_joining_type(@joining_type.lookup_joining_type(c))
}
