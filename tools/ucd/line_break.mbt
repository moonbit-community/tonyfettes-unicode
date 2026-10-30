///|
/// Line_Break values in the order of the `LineBreak` enum, with the
/// description UAX #14 gives each class. LineBreak.txt writes the short
/// aliases, which are also the constructor names.
let line_break_values : ReadOnlyArray[(String, String)] = [
  ("AI", "Ambiguous (Alphabetic or Ideographic)"),
  ("AK", "Aksara"),
  ("AL", "Alphabetic"),
  ("AP", "Aksara Pre-Base"),
  ("AS", "Aksara Start"),
  ("B2", "Break Opportunity Before and After"),
  ("BA", "Break After"),
  ("BB", "Break Before"),
  ("BK", "Mandatory Break"),
  ("CB", "Contingent Break Opportunity"),
  ("CJ", "Conditional Japanese Starter"),
  ("CL", "Close Punctuation"),
  ("CM", "Combining Mark"),
  ("CP", "Close Parenthesis"),
  ("CR", "Carriage Return"),
  ("EB", "Emoji Base"),
  ("EM", "Emoji Modifier"),
  ("EX", "Exclamation/Interrogation"),
  ("GL", "Non-breaking (\"Glue\")"),
  ("H2", "Hangul LV Syllable"),
  ("H3", "Hangul LVT Syllable"),
  ("HH", "Unambiguous Hyphen"),
  ("HL", "Hebrew Letter"),
  ("HY", "Hyphen"),
  ("ID", "Ideographic"),
  ("IN", "Inseparable"),
  ("IS", "Infix Numeric Separator"),
  ("JL", "Hangul L Jamo"),
  ("JT", "Hangul T Jamo"),
  ("JV", "Hangul V Jamo"),
  ("LF", "Line Feed"),
  ("NL", "Next Line"),
  ("NS", "Nonstarter"),
  ("NU", "Numeric"),
  ("OP", "Open Punctuation"),
  ("PO", "Postfix Numeric"),
  ("PR", "Prefix Numeric"),
  ("QU", "Quotation"),
  ("RI", "Regional Indicator"),
  ("SA", "Complex Context Dependent (South East Asian)"),
  ("SG", "Surrogate"),
  ("SP", "Space"),
  ("SY", "Symbols Allowing Break After"),
  ("VF", "Virama Final"),
  ("VI", "Virama"),
  ("WJ", "Word Joiner"),
  ("XX", "Unknown"),
  ("ZW", "Zero Width Space"),
  ("ZWJ", "Zero Width Joiner"),
]

///|
/// Number of bits holding a Line_Break ordinal in the packed high ranges.
const LineBreakBits : Int32 = 6

///|
fn line_break_ordinal(value : StringView) -> Int32? {
  for ordinal, entry in line_break_values {
    if entry.0[:] == value {
      return Some(ordinal)
    }
  }
  None
}

///|
/// Emit Line_Break data from `LineBreak.txt` as a three-level trie for planes
/// 0-3, with packed ranges for the remaining planes.
///
/// Every value in `line_break_values` must occur in the file, so that a
/// value Unicode withdraws does not linger in the enum.
pub fn emit_line_break(content : String) -> String raise {
  let values = property_ordinals(
    property="Line_Break",
    @parsing.parse_enumerated_property(content, default="XX"),
    line_break_ordinal,
  )
  let used = FixedArray::make(line_break_values.length(), false)
  for ordinal in values {
    used[ordinal] = true
  }
  for ordinal, entry in line_break_values {
    guard used[ordinal] else {
      fail("Line_Break value \{entry.0} does not occur in LineBreak.txt")
    }
  }
  let out = @emitter.Emitter::new()
  out.write_file_header("Line_Break lookup data", "LineBreak.txt")
  out.write_value_trie(
    property="Line_Break",
    prefix="line_break",
    lookup="pub fn lookup_line_break",
    lookup_doc=[
      "Look up Line_Break ordinal for a character",
      "Returns ordinal value (0-\{line_break_values.length() - 1}) corresponding to LineBreak enum",
    ],
    value_bits=LineBreakBits,
    values,
  )
  out.finish()
}

///|
/// Emit the `LineBreak` enum and the `line_break` lookup of the root package,
/// which reads the ordinals `emit_line_break` stores.
pub fn emit_line_break_enum() -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header("Line_Break values and lookup", "LineBreak.txt")
  write_property_enum(
    out,
    type_name="LineBreak",
    doc=[
      "Unicode Line_Break values", "See UAX #14: https://www.unicode.org/reports/tr14/#Table1",
    ],
    converter="ordinal_to_line_break",
    values=line_break_values
      .iter()
      .map(entry => { name: entry.0, comment: entry.1, })
      .collect(),
    fallback="XX",
  )
  out.write(
    (
      #|///|
      #|/// Get the Line_Break for a character.
      #|///
      #|/// Line_Break is the property the line breaking rules of UAX #14 are
      #|/// written in terms of. It is a property of a single character, and the
      #|/// value is the one the Unicode Character Database assigns: rule LB1 of
      #|/// the algorithm, which resolves AI, CJ, SA, SG, and XX to other classes,
      #|/// is not applied. Unassigned code points are XX, except in ranges
      #|/// reserved for characters of a known class, such as ID in the CJK
      #|/// ideograph blocks and in planes 2 and 3.
      #|pub fn line_break(c : Char) -> LineBreak {
      #|  ordinal_to_line_break(@line_break.lookup_line_break(c))
      #|}
      #|
    ),
  )
  out.finish()
}
