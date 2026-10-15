///|
/// A forward cursor over all default UAX #29 word segments, including spaces
/// and punctuation. Create with `word_segments`.
struct WordSegments(TextSegments)

///|
/// Split text at the default Unicode 18.0.0 word boundaries. Segments are
/// contiguous views covering the input exactly. The input view is processed
/// independently of surrounding text, without dictionary or locale tailoring.
/// Construction takes O(n) time and space; traversal does not copy the text.
/// Unpaired surrogates have Word_Break=Other; valid pairs stay together.
///
/// ```mbt check
/// test {
///   debug_inspect(
///     @segmentation.word_segments("Hello, world!")
///     .iter()
///     .map(s => s.to_owned())
///     .collect(),
///     content="[\"Hello\", \",\", \" \", \"world\", \"!\"]",
///   )
/// }
/// ```
pub fn word_segments(text : StringView) -> WordSegments {
  WordSegments({ text, ends: word_segment_ends(text), index: 0, offset: 0, })
}

///|
/// Return the next segment, or an empty view at the input's end on exhaustion.
pub fn WordSegments::next(self : WordSegments) -> StringView {
  self.0.next()
}

///|
/// Iterate over the remaining segments, consuming the same cursor as `next`.
pub fn WordSegments::iter(self : WordSegments) -> Iter[StringView] {
  self.0.iter()
}

///|
/// A forward cursor over word segments containing a Unicode Alphabetic or
/// Number character. Create with `words`.
struct Words(WordSegments)

///|
/// Filter default word segments to those containing at least one Alphabetic
/// character or a character in General_Category=Number (Nd, Nl, or No).
/// The entire matching segment is retained, including internal punctuation.
/// This filtering policy is a convenience over UAX #29 word boundaries, not
/// dictionary word recognition. Construction takes O(n) time and space;
/// traversal scans the segments without copying text.
///
/// ```mbt check
/// test {
///   debug_inspect(
///     @segmentation.words("Hello, world! 42")
///     .iter()
///     .map(s => s.to_owned())
///     .collect(),
///     content="[\"Hello\", \"world\", \"42\"]",
///   )
/// }
/// ```
pub fn words(text : StringView) -> Words {
  Words(word_segments(text))
}

///|
/// Return the next word, skipping other segments. Returns an empty view at
/// the input's end once exhausted, including when the input has no words.
pub fn Words::next(self : Words) -> StringView {
  for segment = self.0.next() {
    if segment.is_empty() {
      return segment
    }
    let mut offset = 0
    while offset < segment.length() {
      let cp = code_point_at(segment, offset, segment.length())
      offset += if cp >= 0x10000 { 2 } else { 1 }
      if cp >= 0xD800 && cp <= 0xDFFF {
        continue
      }
      let character = cp.unsafe_to_char()
      if @ucd.is_alphabetic(character) ||
        @ucd.general_category(character) is (@ucd.Nd | @ucd.Nl | @ucd.No) {
        return segment
      }
    }
    continue self.0.next()
  }
}

///|
/// Iterate over the remaining words, consuming the same cursor as `next`.
pub fn Words::iter(self : Words) -> Iter[StringView] {
  Iter::new(() => {
    let word = self.next()
    if word.is_empty() {
      None
    } else {
      Some(word)
    }
  })
}
