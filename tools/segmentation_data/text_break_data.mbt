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
fn emit_text_break(
  source : String,
  property~ : String,
  file~ : String,
  prefix~ : String,
  constant_prefix~ : String,
  names~ : ReadOnlyArray[String],
  bits~ : Int32,
) -> String raise {
  let values = @parsing.parse_enumerated_ordinals(
    source,
    property~,
    default="Other",
    name => name_code(names, name),
  )
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "\{property} properties for Unicode Text Segmentation (UAX #29)",
    file,
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
pub fn emit_word_break(source : String) -> String raise {
  emit_text_break(
    source,
    property="Word_Break",
    file="WordBreakProperty.txt",
    prefix="word_break",
    constant_prefix="Wb",
    names=word_break_names,
    bits=5,
  )
}

///|
/// Generate the sentence boundary property table from SentenceBreakProperty.txt.
pub fn emit_sentence_break(source : String) -> String raise {
  emit_text_break(
    source,
    property="Sentence_Break",
    file="SentenceBreakProperty.txt",
    prefix="sentence_break",
    constant_prefix="Sb",
    names=sentence_break_names,
    bits=4,
  )
}
