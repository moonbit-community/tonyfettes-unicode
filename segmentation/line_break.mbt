///|
/// Whether a line may end at a text boundary. Mandatory includes the end of
/// nonempty text, even when the text does not end in a newline character.
pub(all) enum BreakOpportunity {
  Prohibited
  Allowed
  Mandatory
} derive(Eq, Debug)

///|
pub extend BreakOpportunity with Eq::{equal}

///|
#deprecated("Use `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend BreakOpportunity with Eq::{not_equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend BreakOpportunity with Debug::{to_repr}

///|
/// A forward cursor over text segments ending at default UAX #14 opportunities.
struct LineBreaks {
  text : StringView
  units : Array[BreakUnit]
  mut index : Int32
  mut offset : Int32
  mut opportunity : BreakOpportunity
}

///|
/// Find the default Unicode 18.0.0 UAX #14 line break opportunities.
///
/// Segments are contiguous views covering the input, retaining spaces and
/// newline characters. The view is processed independently of its backing
/// string. Default line breaks may fall inside extended grapheme clusters;
/// use Graphemes::line_break to query only the ends of complete clusters.
///
/// Nonempty input ends with one Mandatory boundary; empty input yields nothing.
/// Unpaired surrogates are resolved as SG -> AL; valid pairs stay together.
/// Construction prepares character context in O(n) time and space; iteration
/// scans it once without copying the text. No locale tailoring, dictionary
/// segmentation, or width-based wrapping is applied. The unicode-data
/// line_break property query remains unresolved.
///
/// ```mbt check
/// test {
///   let breaks = @segmentation.line_breaks("Hello world!")
///   inspect(breaks.next(), content="Hello ")
///   debug_inspect(breaks.opportunity(), content="Allowed")
///   inspect(breaks.next(), content="world!")
///   debug_inspect(breaks.opportunity(), content="Mandatory")
///   assert_true(breaks.next().is_empty())
/// }
/// ```
pub fn line_breaks(text : StringView) -> LineBreaks {
  {
    text,
    units: prepare_units(text),
    index: 1,
    offset: 0,
    opportunity: Prohibited,
  }
}

///|
/// Return the next segment, or an empty view at the end of the input once
/// exhausted. The returned view retains its offsets in the backing string.
/// Empty results do not change opportunity().
pub fn LineBreaks::next(self : LineBreaks) -> StringView {
  while self.index <= self.units.length() {
    let index = self.index
    self.index += 1
    let kind = if index == self.units.length() {
      Mandatory
    } else {
      boundary(self.units, index).unwrap_or(Prohibited)
    }
    if kind != Prohibited {
      let start = self.offset
      self.offset = self.units[index - 1].end
      self.opportunity = kind
      return self.text.clamped_view(start~, end=self.offset)
    }
  }
  self.text.clamped_view(start=self.offset, end=self.offset)
}

///|
/// Iterate over the remaining segments, advancing this same cursor. Query
/// opportunity() in the loop body for the segment just yielded. Collected
/// views retain their text and positions, but do not store the break kind.
pub fn LineBreaks::iter(self : LineBreaks) -> Iter[StringView] {
  Iter::new(() => {
    let segment = self.next()
    if segment.is_empty() {
      None
    } else {
      Some(segment)
    }
  })
}

///|
/// The break kind at the end of the last nonempty segment returned by next()
/// or iter(). Before the first segment, including for empty input, returns
/// Prohibited. Exhaustion preserves the last kind; querying does not advance.
pub fn LineBreaks::opportunity(self : LineBreaks) -> BreakOpportunity {
  self.opportunity
}
