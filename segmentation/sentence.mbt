///|
/// A forward cursor over default UAX #29 sentence segments. Create with
/// `sentences`; trailing spaces and punctuation remain in the returned views.
struct Sentences {
  text : StringView
  mut offset : Int32
  // Cached SB8 lookahead: for any query at `pos <= sb8_end`, `sb8_lower` holds
  // whether the first character outside SB8's skipped set is `SbLower`.
  mut sb8_end : Int32
  mut sb8_lower : Bool
}

///|
/// Split text at the default Unicode 18.0.0 sentence boundaries, retaining
/// every character. Closing punctuation, trailing spaces, and paragraph
/// separators are included according to UAX #29. No abbreviation dictionary
/// or locale tailoring is applied. The supplied view is an independent text.
/// Construction takes O(1) time and space; traversal streams forward in O(n)
/// time without copying text. Unpaired surrogates have Sentence_Break=Other;
/// valid pairs stay together.
///
/// ```mbt check
/// test {
///   debug_inspect(
///     @segmentation.sentences("Hello! Next.")
///     .iter()
///     .map(s => s.to_owned())
///     .collect(),
///     content="[\"Hello! \", \"Next.\"]",
///   )
/// }
/// ```
pub fn sentences(text : StringView) -> Sentences {
  { text, offset: 0, sb8_end: -1, sb8_lower: false, }
}

///|
/// Return the next segment, or an empty view at the input's end on exhaustion.
pub fn Sentences::next(self : Sentences) -> StringView {
  let text = self.text
  let length = text.length()
  let start = self.offset
  if start >= length {
    return text.unsafe_view(start~, end=start)
  }
  let end = self.next_sentence_boundary(start, length)
  self.offset = end
  text.unsafe_view(start~, end~)
}

///|
/// Iterate over remaining segments, consuming the same cursor as `next`.
pub fn Sentences::iter(self : Sentences) -> Iter[StringView] {
  Iter(() => {
    let segment = self.next()
    if segment.is_empty() {
      None
    } else {
      Some(segment)
    }
  })
}
