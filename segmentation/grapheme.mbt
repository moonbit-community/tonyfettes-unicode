///|
/// State of the GB11 emoji sequence scan within a cluster: no
/// Extended_Pictographic code point is pending.
const EmojiNone : Int = 0

///|
/// The cluster so far ends in `\p{Extended_Pictographic} Extend*`.
const EmojiPictographic : Int = 1

///|
/// The cluster so far ends in `\p{Extended_Pictographic} Extend* ZWJ`.
const EmojiZWJ : Int = 2

///|
/// State of the GB9c conjunct scan within a cluster: no consonant is pending.
const ConjunctNone : Int = 0

///|
/// The cluster so far ends in `\p{InCB=Consonant} \p{InCB=Extend}*`.
const ConjunctConsonant : Int = 1

///|
/// The cluster so far ends in `\p{InCB=Consonant}` followed by
/// `\p{InCB=Extend}` and `\p{InCB=Linker}` code points with at least one
/// linker.
const ConjunctLinker : Int = 2

///|
/// Decode the code point starting at `index`. An unpaired surrogate is
/// returned as is; like any code point GraphemeBreakProperty.txt does not
/// list, its Grapheme_Cluster_Break value is Other.
fn code_point_at(text : StringView, index : Int, length : Int) -> Int {
  // SAFETY: callers guarantee 0 <= index < length.
  let first = text.unsafe_get(index)
  if first.is_leading_surrogate() && index + 1 < length {
    // SAFETY: index + 1 < length is checked above.
    let second = text.unsafe_get(index + 1)
    if second.is_trailing_surrogate() {
      return 0x10000 +
        ((first.to_int() - 0xD800) << 10) +
        second.to_int() -
        0xDC00
    }
  }
  first.to_int()
}

///|
/// Return the end offset of the extended grapheme cluster starting at `start`,
/// following the boundary rules of UAX #29. Requires `start < text.length()`.
fn next_grapheme_boundary(text : StringView, start : Int) -> Int {
  let length = text.length()
  let first = code_point_at(text, start, length)
  let mut index = start + (if first >= 0x10000 { 2 } else { 1 })
  let mut previous = grapheme_break_value(first)
  // Whether the cluster ends in an odd number of Regional_Indicator code
  // points (GB12, GB13).
  let mut regional_odd = (previous & GcbMask) == GcbRegionalIndicator
  let mut emoji = if (previous & ExtendedPictographicBit) != 0 {
    EmojiPictographic
  } else {
    EmojiNone
  }
  let mut conjunct = if ((previous >> InCBShift) & InCBMask) == InCBConsonant {
    ConjunctConsonant
  } else {
    ConjunctNone
  }
  while index < length {
    let code_point = code_point_at(text, index, length)
    let current = grapheme_break_value(code_point)
    let before = previous & GcbMask
    let after = current & GcbMask
    let conjunct_break = (current >> InCBShift) & InCBMask
    let pictographic = (current & ExtendedPictographicBit) != 0
    // GB3, GB4, GB5: break around controls, except between CR and LF.
    match before {
      GcbCR => return if after == GcbLF { index + 1 } else { index }
      GcbLF | GcbControl => break
      _ => ()
    }
    if after is (GcbCR | GcbLF | GcbControl) {
      break
    }
    let joined = match (before, after) {
      // GB9, GB9a: do not break before extending characters, ZWJ, or
      // spacing marks.
      (_, GcbExtend | GcbZWJ | GcbSpacingMark) => true
      // GB9b: do not break after prepend characters.
      (GcbPrepend, _) => true
      // GB6, GB7, GB8: do not break Hangul syllable sequences.
      (GcbL, GcbL | GcbV | GcbLV | GcbLVT) => true
      (GcbLV | GcbV, GcbV | GcbT) => true
      (GcbLVT | GcbT, GcbT) => true
      // GB12, GB13: do not break within a pair of regional indicators.
      (GcbRegionalIndicator, GcbRegionalIndicator) => regional_odd
      _ =>
        // GB9c: do not break within an Indic conjunct.
        (conjunct == ConjunctLinker && conjunct_break == InCBConsonant) ||
        // GB11: do not break within an emoji ZWJ sequence.
        (emoji == EmojiZWJ && pictographic)
    }
    // GB999: otherwise, break everywhere.
    if !joined {
      break
    }
    regional_odd = after == GcbRegionalIndicator && !regional_odd
    emoji = if pictographic {
      EmojiPictographic
    } else if emoji == EmojiPictographic && after == GcbExtend {
      EmojiPictographic
    } else if emoji == EmojiPictographic && after == GcbZWJ {
      EmojiZWJ
    } else {
      EmojiNone
    }
    conjunct = match conjunct_break {
      InCBConsonant => ConjunctConsonant
      InCBExtend => conjunct
      InCBLinker if conjunct != ConjunctNone => ConjunctLinker
      _ => ConjunctNone
    }
    index += if code_point >= 0x10000 { 2 } else { 1 }
    previous = current
  }
  index
}

///|
/// A single-pass cursor over the extended grapheme clusters of a text, the
/// user-perceived characters defined by Unicode Text Segmentation (UAX #29).
///
/// Create one with `graphemes`. Use it in a `for .. in` loop, or call `next`
/// directly to avoid allocating an `Option` per cluster.
struct Graphemes {
  text : StringView
  /// Offset in `text` of the next cluster to return.
  mut offset : Int
}

///|
/// Split `text` into extended grapheme clusters.
///
/// Each cluster is a view into `text`, so `StringView::start_offset` gives its
/// position in the underlying string. The clusters are contiguous and cover
/// `text` exactly. `text` is segmented on its own: its start is a boundary
/// even if the underlying string continues before it.
///
/// ```mbt check
/// test {
///   let clusters = []
///   for cluster in @segmentation.graphemes("e\u{301}🇺🇳x") {
///     clusters.push(cluster.to_owned())
///   }
///   debug_inspect(
///     clusters,
///     content=(
///       #|["é", "🇺🇳", "x"]
///     ),
///   )
/// }
/// ```
pub fn graphemes(text : StringView) -> Graphemes {
  { text, offset: 0, }
}

///|
/// Return the next cluster and advance past it, or return an empty view once
/// the text is exhausted. A cluster is never empty, so an empty result always
/// means the end.
///
/// ```mbt check
/// test {
///   let clusters = @segmentation.graphemes("e\u{301}x")
///   inspect(
///     clusters.next(),
///     content=(
///       #|é
///     ),
///   )
///   inspect(
///     clusters.next(),
///     content=(
///       #|x
///     ),
///   )
///   inspect(
///     clusters.next().is_empty(),
///     content=(
///       #|true
///     ),
///   )
/// }
/// ```
pub fn Graphemes::next(self : Graphemes) -> StringView {
  let text = self.text
  let start = self.offset
  let end = if start < text.length() {
    next_grapheme_boundary(text, start)
  } else {
    start
  }
  self.offset = end
  text.view(start_offset=start, end_offset=end)
}

///|
/// Iterate over the remaining clusters. The iterator advances this cursor, so
/// clusters it yields are not returned by `next` again.
pub fn Graphemes::iter(self : Graphemes) -> Iter[StringView] {
  Iter::new(() => {
    let cluster = self.next()
    if cluster.is_empty() {
      None
    } else {
      Some(cluster)
    }
  })
}
