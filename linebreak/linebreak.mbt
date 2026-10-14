///|
/// A permitted line ending. Mandatory includes the end of nonempty text,
/// even when the text does not end in a newline character.
pub(all) enum BreakOpportunity {
  Allowed
  Mandatory
} derive(Eq, Debug)

///|
pub extend BreakOpportunity with Eq::{equal, not_equal}

///|
pub extend BreakOpportunity with Debug::{to_repr}

///|
/// A forward cursor over the remaining line break opportunities.
struct LineBreaks {
  units : Array[BreakUnit]
  mut index : Int32
}

///|
/// Find the default Unicode 18.0.0 UAX #14 line break opportunities.
///
/// Positions are UTF-16 offsets relative to `text`, immediately after the
/// preceding text. The view is processed independently of its backing string.
/// No leading zero is emitted. Nonempty text ends with one Mandatory break;
/// empty text yields nothing. Spaces and newline characters are not trimmed.
/// Unpaired surrogates are resolved as SG -> AL; valid pairs stay together.
///
/// Construction prepares the characters and their rule context in O(n) time
/// and space. Iteration visits them once, without copying the input text.
/// No locale tailoring, dictionary segmentation, or width-based wrapping is
/// applied. The unicode-data `line_break` property query remains unresolved.
///
/// ```mbt check
/// test {
///   debug_inspect(
///     @linebreak.line_breaks("Hello world!").iter().collect(),
///     content="[(6, Allowed), (12, Mandatory)]",
///   )
/// }
/// ```
pub fn line_breaks(text : StringView) -> LineBreaks {
  { units: prepare_units(text), index: 1, }
}

///|
/// Advance to the next opportunity. Once exhausted, always returns None.
pub fn LineBreaks::next(self : LineBreaks) -> (Int32, BreakOpportunity)? {
  while self.index <= self.units.length() {
    let index = self.index
    self.index += 1
    if index == self.units.length() {
      return Some((self.units[index - 1].end, Mandatory))
    }
    if boundary(self.units, index) is Some(kind) {
      return Some((self.units[index - 1].end, kind))
    }
  }
  None
}

///|
/// Iterate over the remaining opportunities, advancing this same cursor.
pub fn LineBreaks::iter(self : LineBreaks) -> Iter[(Int32, BreakOpportunity)] {
  Iter::new(() => self.next())
}
