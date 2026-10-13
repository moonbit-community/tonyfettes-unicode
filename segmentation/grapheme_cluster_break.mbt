///|
/// Unicode Grapheme_Cluster_Break values
/// See UAX #29: https://www.unicode.org/reports/tr29/#Grapheme_Cluster_Break_Property_Values
pub(all) enum GraphemeClusterBreak {
  Other // XX
  CR
  LF
  Control // CN
  Extend // EX
  ZWJ
  RegionalIndicator // RI
  Prepend // PP
  SpacingMark // SM
  L
  V
  T
  LV
  LVT
} derive(Eq)

///|
pub extend GraphemeClusterBreak with Eq::{not_equal, equal}

///|
pub extend GraphemeClusterBreak with Show::{to_string, output}

///|
pub impl Show for GraphemeClusterBreak with fn output(self, logger) {
  match self {
    Other => logger.write_string("Other")
    CR => logger.write_string("CR")
    LF => logger.write_string("LF")
    Control => logger.write_string("Control")
    Extend => logger.write_string("Extend")
    ZWJ => logger.write_string("ZWJ")
    RegionalIndicator => logger.write_string("RegionalIndicator")
    Prepend => logger.write_string("Prepend")
    SpacingMark => logger.write_string("SpacingMark")
    L => logger.write_string("L")
    V => logger.write_string("V")
    T => logger.write_string("T")
    LV => logger.write_string("LV")
    LVT => logger.write_string("LVT")
  }
}

///|
/// Get the Grapheme_Cluster_Break for a character.
///
/// Grapheme_Cluster_Break is the property the extended grapheme cluster
/// rules of UAX #29 are written in terms of. It is a property of a single
/// character; use `graphemes` to find the cluster boundaries of a text.
/// Characters the Unicode Character Database does not list, including
/// unassigned code points, are Other.
pub fn grapheme_cluster_break(c : Char) -> GraphemeClusterBreak {
  match grapheme_break_value(c.to_int()) & GcbMask {
    GcbCR => CR
    GcbLF => LF
    GcbControl => Control
    GcbExtend => Extend
    GcbZWJ => ZWJ
    GcbRegionalIndicator => RegionalIndicator
    GcbPrepend => Prepend
    GcbSpacingMark => SpacingMark
    GcbL => L
    GcbV => V
    GcbT => T
    GcbLV => LV
    GcbLVT => LVT
    _ => Other
  }
}
