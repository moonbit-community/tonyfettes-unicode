///|
let word_break_names : ReadOnlyArray[String] = [
  "Other", "CR", "LF", "Newline", "Extend", "ZWJ", "Regional_Indicator", "Format",
  "Katakana", "Hebrew_Letter", "ALetter", "Single_Quote", "Double_Quote", "MidNumLet",
  "MidLetter", "MidNum", "Numeric", "ExtendNumLet", "WSegSpace",
]

///|
let sentence_break_names : ReadOnlyArray[String] = [
  "Other", "CR", "LF", "Sep", "Extend", "Format", "Sp", "Lower", "Upper", "OLetter",
  "Numeric", "ATerm", "STerm", "Close", "SContinue",
]

///|
fn generate_text_break_source(
  source : String,
  property~ : String,
  prefix~ : String,
  constant_prefix~ : String,
  names~ : ReadOnlyArray[String],
  bits~ : Int32,
) -> String raise {
  let values = FixedArray::make(MaxCodePoint + 1, 0)
  for raw_line in source.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    guard line.split(";").collect() is [range, name, ..] else { continue }
    let range = @parsing.parse_code_point_range(range)
    let code = property_code(property, names, name.trim())
    for cp in range.start..<=range.end {
      values[cp] = code
    }
  }
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "\{property} properties for Unicode Text Segmentation (UAX #29)",
    if prefix == "word_break" {
      "WordBreakProperty.txt"
    } else {
      "SentenceBreakProperty.txt"
    },
  )
  for code, name in names {
    if code != 0 {
      let constant_name = name.replace_all(old="_", new="")
      out.write_line("///|")
      out.write_line("/// \{property}=\{name}")
      out.write_line(
        "const \{constant_prefix}\{constant_name} : Int = \{code}\n",
      )
    }
  }
  out.write_value_trie(
    property~,
    prefix~,
    lookup="fn \{prefix}_value",
    lookup_doc=[
      "Look up \{property}; unlisted code points have value zero (Other).",
    ],
    value_bits=bits,
    values,
  )
  out.finish()
}

///|
/// Generate the default word boundary property table from WordBreakProperty.txt.
pub fn generate_word_break_source(source : String) -> String raise {
  generate_text_break_source(
    source,
    property="Word_Break",
    prefix="word_break",
    constant_prefix="Wb",
    names=word_break_names,
    bits=5,
  )
}

///|
/// Generate the sentence boundary property table from SentenceBreakProperty.txt.
pub fn generate_sentence_break_source(source : String) -> String raise {
  generate_text_break_source(
    source,
    property="Sentence_Break",
    prefix="sentence_break",
    constant_prefix="Sb",
    names=sentence_break_names,
    bits=4,
  )
}
