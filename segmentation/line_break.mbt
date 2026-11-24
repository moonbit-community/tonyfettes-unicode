///|
/// Whether a line may end at a text boundary. Mandatory includes the end of
/// nonempty text, even when the text does not end in a newline character.
#derive(Eq, Debug)
pub(all) enum BreakOpportunity {
  Prohibited
  Allowed
  Mandatory
}

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
  mut offset : Int32
  mut opportunity : BreakOpportunity
  mut started : Bool
  mut left_val : Int32
  mut left_end : Int32
  mut left_ends_with_zwj : Bool
  mut before_val : Int32
  mut left_numeric : Bool
  mut before_numeric : Bool
  mut space_rule : Int32
  mut regional_odd : Bool
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
/// Construction takes O(1) time and space; traversal streams forward in O(n)
/// time without copying the text. No locale tailoring, dictionary segmentation,
/// or width-based wrapping is applied. The unicode-data line_break property
/// query remains unresolved.
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
    offset: 0,
    opportunity: Prohibited,
    started: false,
    left_val: 0,
    left_end: 0,
    left_ends_with_zwj: false,
    before_val: 0,
    left_numeric: false,
    before_numeric: false,
    space_rule: SpaceRuleNone,
    regional_odd: false,
  }
}

///|
/// Return the next segment, or an empty view at the end of the input once
/// exhausted. The returned view retains its offsets in the backing string.
/// Empty results do not change opportunity().
pub fn LineBreaks::next(self : LineBreaks) -> StringView {
  let text = self.text
  let length = text.length()
  let start = self.offset
  if start >= length {
    return text.unsafe_view(start~, end=start)
  }
  let mut left_val = self.left_val
  let mut left_end = self.left_end
  let mut left_ends_with_zwj = self.left_ends_with_zwj
  let mut before_val = self.before_val
  let mut left_numeric = self.left_numeric
  let mut before_numeric = self.before_numeric
  let mut space_rule = self.space_rule
  let mut regional_odd = self.regional_odd
  if !self.started {
    let first = text.unsafe_get(0).to_int()
    let mut cp = first
    let mut cp_end = 1
    if first >= 0xD800 && first <= 0xDBFF && cp_end < length {
      let second = text.unsafe_get(cp_end).to_int()
      if second >= 0xDC00 && second <= 0xDFFF {
        cp = 0x10000 + ((first - 0xD800) << 10) + second - 0xDC00
        cp_end += 1
      }
    }
    let raw_val = line_break_value(cp)
    let raw_cls = raw_val & LbClassMask
    left_ends_with_zwj = raw_cls == LbZWJ
    left_val = if raw_cls >= LbCM { LbAL } else { raw_val }
    let cls = left_val & LbClassMask
    left_end = cp_end
    before_val = 0
    before_numeric = false
    left_numeric = cls == LbNU
    space_rule = update_space_rule(LbNone, cls, SpaceRuleNone)
    regional_odd = cls == LbRI
    self.started = true
  }
  while left_end < length {
    // SAFETY: left_end < length; surrogate trail is checked before reading.
    let first = text.unsafe_get(left_end).to_int()
    let mut cp = first
    let mut cp_end = left_end + 1
    if first >= 0xD800 && first <= 0xDBFF && cp_end < length {
      let second = text.unsafe_get(cp_end).to_int()
      if second >= 0xDC00 && second <= 0xDFFF {
        cp = 0x10000 + ((first - 0xD800) << 10) + second - 0xDC00
        cp_end += 1
      }
    }
    let raw_val = line_break_value(cp)
    let raw_cls = raw_val & LbClassMask
    let a = left_val & LbClassMask
    // LB9: combining marks and ZWJ attach to any base other than BK/CR/LF/NL/SP/ZW.
    if raw_cls >= LbCM && !(a is (LbBK | LbCR | LbLF | LbNL | LbSP | LbZW)) {
      left_end = cp_end
      left_ends_with_zwj = raw_cls == LbZWJ
      continue
    }
    // LB10: remaining CM/ZWJ acts as AL (no East Asian or emoji flags), while
    // retaining ends_with_zwj for LB8a.
    let right_ends_with_zwj = raw_cls == LbZWJ
    let right_val = if raw_cls >= LbCM { LbAL } else { raw_val }
    let b = right_val & LbClassMask
    // When left_ends_with_zwj is true, LB4/LB5/LB8 cannot apply (LB9 does not
    // attach ZWJ to BK/CR/LF/NL/SP/ZW), so LB6/LB7/LB8a always prohibit a break.
    let action = if left_ends_with_zwj {
      LbPairProhibited
    } else {
      // SAFETY: a and b are in 1..47, below LbPairClasses (48).
      let pair = line_break_pair_table
        .unsafe_get(a * LbPairClasses + b)
        .to_int()
      if pair != LbPairContext {
        pair
      } else {
        lb_context_boundary(
          text, cp_end, left_val, right_val, before_val, left_numeric, before_numeric,
          space_rule, regional_odd,
        )
      }
    }
    let break_end = left_end
    // Advance state to commit `right` as the next `left`.
    before_val = left_val
    before_numeric = left_numeric
    left_val = right_val
    left_end = cp_end
    left_ends_with_zwj = right_ends_with_zwj
    left_numeric = b == LbNU || (b is (LbSY | LbIS) && before_numeric)
    space_rule = update_space_rule(a, b, space_rule)
    regional_odd = b == LbRI && !regional_odd
    if action != LbPairProhibited {
      self.left_val = left_val
      self.left_end = left_end
      self.left_ends_with_zwj = left_ends_with_zwj
      self.before_val = before_val
      self.left_numeric = left_numeric
      self.before_numeric = before_numeric
      self.space_rule = space_rule
      self.regional_odd = regional_odd
      self.offset = break_end
      self.opportunity = if action == LbPairMandatory {
        Mandatory
      } else {
        Allowed
      }
      return text.unsafe_view(start~, end=break_end)
    }
  }
  self.left_val = left_val
  self.left_end = length
  self.left_ends_with_zwj = left_ends_with_zwj
  self.before_val = before_val
  self.left_numeric = left_numeric
  self.before_numeric = before_numeric
  self.space_rule = space_rule
  self.regional_odd = regional_odd
  self.offset = length
  self.opportunity = Mandatory
  text.unsafe_view(start~, end=length)
}

///|
/// Iterate over the remaining segments, advancing this same cursor. Query
/// opportunity() in the loop body for the segment just yielded. Collected
/// views retain their text and positions, but do not store the break kind.
pub fn LineBreaks::iter(self : LineBreaks) -> Iter[StringView] {
  Iter(() => {
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
