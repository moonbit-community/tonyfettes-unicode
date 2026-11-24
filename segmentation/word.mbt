///|
/// A forward cursor over all default UAX #29 word segments, including spaces
/// and punctuation. Create with `word_segments`.
struct WordSegments {
  text : StringView
  mut offset : Int32
  mut word_like : Bool
}

///|
/// Split text at the default Unicode 18.0.0 word boundaries. Segments are
/// contiguous views covering the input exactly. The input view is processed
/// independently of surrounding text, without dictionary or locale tailoring.
/// Construction takes O(1) time and space; traversal streams forward in O(n)
/// time without copying the text. Unpaired surrogates have Word_Break=Other;
/// valid pairs stay together.
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
  { text, offset: 0, word_like: false, }
}

///|
/// Return the next segment, or an empty view at the input's end on exhaustion.
pub fn WordSegments::next(self : WordSegments) -> StringView {
  let text = self.text
  let length = text.length()
  let start = self.offset
  if start >= length {
    return text.unsafe_view(start~, end=start)
  }
  let end = self.next_word_boundary(start, length)
  self.offset = end
  text.unsafe_view(start~, end~)
}

///|
/// Iterate over the remaining segments, consuming the same cursor as `next`.
pub fn WordSegments::iter(self : WordSegments) -> Iter[StringView] {
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
/// A forward cursor over word segments containing a Unicode Alphabetic or
/// Number character. Create with `words`.
struct Words(WordSegments)

///|
/// Filter default word segments to those containing at least one Alphabetic
/// character or a character in General_Category=Number (Nd, Nl, or No).
/// The entire matching segment is retained, including internal punctuation.
/// This filtering policy is a convenience over UAX #29 word boundaries, not
/// dictionary word recognition. Construction takes O(1) time and space;
/// traversal streams forward in O(n) time without copying text.
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
    if segment.is_empty() || self.0.word_like {
      return segment
    }
    continue self.0.next()
  }
}

///|
/// Iterate over the remaining words, consuming the same cursor as `next`.
pub fn Words::iter(self : Words) -> Iter[StringView] {
  Iter(() => {
    let word = self.next()
    if word.is_empty() {
      None
    } else {
      Some(word)
    }
  })
}
