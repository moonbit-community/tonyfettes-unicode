///|
let word_break_names : ReadOnlyArray[String] = [
  "Other", "CR", "LF", "Newline", "Extend", "ZWJ", "Regional_Indicator", "Format",
  "Katakana", "Hebrew_Letter", "ALetter", "Single_Quote", "Double_Quote", "MidNumLet",
  "MidLetter", "MidNum", "Numeric", "ExtendNumLet", "WSegSpace",
]

///|
/// Sentence_Break names with the five break-triggering classes (CR, LF, Sep,
/// ATerm, STerm) placed contiguously in 1..5 so the hot scan loop tests all
/// five with one unsigned range comparison.
let sentence_break_names : ReadOnlyArray[String] = [
  "Other", "CR", "LF", "Sep", "ATerm", "STerm", "Extend", "Format", "Sp", "Lower",
  "Upper", "OLetter", "Numeric", "Close", "SContinue",
]

///|
/// Mask selecting the 5-bit Word_Break class of a packed word break value.
const WbClassMask : Int32 = 31

///|
/// Bit set for Alphabetic or General_Category=Number (Nd, Nl, No) code points.
const WbWordLikeBit : Int32 = 32

///|
/// Bit set for Extended_Pictographic code points (used by WB3c).
const WbExtendedPictographicBit : Int32 = 64

///|
/// Generate the packed default word boundary property table from
/// WordBreakProperty.txt, UnicodeData.txt, DerivedCoreProperties.txt, and
/// emoji-data.txt.
pub fn emit_word_break(
  word_break_property : String,
  unicode_data : String,
  derived_core_properties : String,
  emoji_data : String,
) -> String raise {
  let values = @parsing.parse_enumerated_ordinals(
    word_break_property,
    property="Word_Break",
    default="Other",
    name => word_break_names.search_by(n => name == n),
  )
  let gc_tags = parse_unicode_data_gc_tags(unicode_data)
  for cp in 0..<=@emitter.MaxCodePoint {
    if gc_tags[cp] == 5 {
      values[cp] = values[cp] | WbWordLikeBit
    }
  }
  for fields in @parsing.data_lines(derived_core_properties) {
    guard fields is [range, "Alphabetic", ..] else { continue }
    set_range_bits(
      values,
      @parsing.parse_code_point_range(range),
      WbWordLikeBit,
    )
  }
  for fields in @parsing.data_lines(emoji_data) {
    guard fields is [range, "Extended_Pictographic", ..] else { continue }
    set_range_bits(
      values,
      @parsing.parse_code_point_range(range),
      WbExtendedPictographicBit,
    )
  }
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Word_Break properties for Unicode Text Segmentation (UAX #29)", "WordBreakProperty.txt, UnicodeData.txt, DerivedCoreProperties.txt, and emoji-data.txt",
  )
  for code, name in word_break_names {
    if code != 0 {
      let constant_name = name.replace_all(old="_", new="")
      out.write_line("///|")
      out.write_line("/// Word_Break=\{name}")
      out.write_line("const Wb\{constant_name} : Int = \{code}\n")
    }
  }
  out.write(
    (
      $|///|
      $|const WbClassMask : Int = \{WbClassMask}
      $|
      $|///|
      $|const WbWordLikeBit : Int = \{WbWordLikeBit}
      $|
      $|///|
      $|const WbExtendedPictographicBit : Int = \{WbExtendedPictographicBit}
      $|
      $|
    ),
  )
  out.write_value_trie(
    property="Word_Break",
    prefix="word_break",
    lookup="fn word_break_value",
    lookup_doc=[
      "Look up packed Word_Break properties: `extended_pictographic << 6 | word_like << 5 | word_break`.",
    ],
    value_bits=7,
    takes_code_point=true,
    values,
  )
  out.finish()
}

///|
/// Generate the sentence boundary property table from SentenceBreakProperty.txt.
pub fn emit_sentence_break(source : String) -> String raise {
  let values = @parsing.parse_enumerated_ordinals(
    source,
    property="Sentence_Break",
    default="Other",
    name => sentence_break_names.search_by(n => name == n),
  )
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Sentence_Break properties for Unicode Text Segmentation (UAX #29)", "SentenceBreakProperty.txt",
  )
  for code, name in sentence_break_names {
    if code != 0 {
      let constant_name = name.replace_all(old="_", new="")
      out.write_line("///|")
      out.write_line("/// Sentence_Break=\{name}")
      out.write_line("const Sb\{constant_name} : Int = \{code}\n")
    }
  }
  out.write_value_trie(
    property="Sentence_Break",
    prefix="sentence_break",
    lookup="fn sentence_break_value",
    lookup_doc=[
      "Look up Sentence_Break; unlisted code points have value zero (Other).",
    ],
    value_bits=4,
    takes_code_point=true,
    values,
  )
  out.finish()
}
