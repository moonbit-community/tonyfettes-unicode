///|
/// A forward cursor over default UAX #29 sentence segments. Create with
/// `sentences`; trailing spaces and punctuation remain in the returned views.
struct Sentences(TextSegments)

///|
/// Split text at the default Unicode 18.0.0 sentence boundaries, retaining
/// every character. Closing punctuation, trailing spaces, and paragraph
/// separators are included according to UAX #29. No abbreviation dictionary
/// or locale tailoring is applied. The supplied view is an independent text.
/// Construction takes O(n) time and space; traversal does not copy text.
/// Unpaired surrogates have Sentence_Break=Other; valid pairs stay together.
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
  Sentences({ text, ends: sentence_segment_ends(text), index: 0, offset: 0, })
}

///|
/// Return the next segment, or an empty view at the input's end on exhaustion.
pub fn Sentences::next(self : Sentences) -> StringView {
  self.0.next()
}

///|
/// Iterate over remaining segments, consuming the same cursor as `next`.
pub fn Sentences::iter(self : Sentences) -> Iter[StringView] {
  self.0.iter()
}
