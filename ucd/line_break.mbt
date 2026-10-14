///|
/// Line_Break values and lookup
/// Generated from LineBreak.txt

///|
/// Unicode Line_Break values
/// See UAX #14: https://www.unicode.org/reports/tr14/#Table1
pub(all) enum LineBreak {
  AI // Ambiguous (Alphabetic or Ideographic)
  AK // Aksara
  AL // Alphabetic
  AP // Aksara Pre-Base
  AS // Aksara Start
  B2 // Break Opportunity Before and After
  BA // Break After
  BB // Break Before
  BK // Mandatory Break
  CB // Contingent Break Opportunity
  CJ // Conditional Japanese Starter
  CL // Close Punctuation
  CM // Combining Mark
  CP // Close Parenthesis
  CR // Carriage Return
  EB // Emoji Base
  EM // Emoji Modifier
  EX // Exclamation/Interrogation
  GL // Non-breaking ("Glue")
  H2 // Hangul LV Syllable
  H3 // Hangul LVT Syllable
  HH // Unambiguous Hyphen
  HL // Hebrew Letter
  HY // Hyphen
  ID // Ideographic
  IN // Inseparable
  IS // Infix Numeric Separator
  JL // Hangul L Jamo
  JT // Hangul T Jamo
  JV // Hangul V Jamo
  LF // Line Feed
  NL // Next Line
  NS // Nonstarter
  NU // Numeric
  OP // Open Punctuation
  PO // Postfix Numeric
  PR // Prefix Numeric
  QU // Quotation
  RI // Regional Indicator
  SA // Complex Context Dependent (South East Asian)
  SG // Surrogate
  SP // Space
  SY // Symbols Allowing Break After
  VF // Virama Final
  VI // Virama
  WJ // Word Joiner
  XX // Unknown
  ZW // Zero Width Space
  ZWJ // Zero Width Joiner
} derive(Debug, Eq)

///|
pub extend LineBreak with Debug::{to_repr}

///|
pub extend LineBreak with Eq::{not_equal, equal}

///|
pub extend LineBreak with Show::{to_string, output}

///|
pub impl Show for LineBreak with fn output(self, logger) {
  logger.write_string(
    match self {
      AI => "AI"
      AK => "AK"
      AL => "AL"
      AP => "AP"
      AS => "AS"
      B2 => "B2"
      BA => "BA"
      BB => "BB"
      BK => "BK"
      CB => "CB"
      CJ => "CJ"
      CL => "CL"
      CM => "CM"
      CP => "CP"
      CR => "CR"
      EB => "EB"
      EM => "EM"
      EX => "EX"
      GL => "GL"
      H2 => "H2"
      H3 => "H3"
      HH => "HH"
      HL => "HL"
      HY => "HY"
      ID => "ID"
      IN => "IN"
      IS => "IS"
      JL => "JL"
      JT => "JT"
      JV => "JV"
      LF => "LF"
      NL => "NL"
      NS => "NS"
      NU => "NU"
      OP => "OP"
      PO => "PO"
      PR => "PR"
      QU => "QU"
      RI => "RI"
      SA => "SA"
      SG => "SG"
      SP => "SP"
      SY => "SY"
      VF => "VF"
      VI => "VI"
      WJ => "WJ"
      XX => "XX"
      ZW => "ZW"
      ZWJ => "ZWJ"
    },
  )
}

///|
/// Convert LineBreak ordinal to enum value
fn ordinal_to_line_break(ordinal : Int32) -> LineBreak {
  match ordinal {
    0 => AI
    1 => AK
    2 => AL
    3 => AP
    4 => AS
    5 => B2
    6 => BA
    7 => BB
    8 => BK
    9 => CB
    10 => CJ
    11 => CL
    12 => CM
    13 => CP
    14 => CR
    15 => EB
    16 => EM
    17 => EX
    18 => GL
    19 => H2
    20 => H3
    21 => HH
    22 => HL
    23 => HY
    24 => ID
    25 => IN
    26 => IS
    27 => JL
    28 => JT
    29 => JV
    30 => LF
    31 => NL
    32 => NS
    33 => NU
    34 => OP
    35 => PO
    36 => PR
    37 => QU
    38 => RI
    39 => SA
    40 => SG
    41 => SP
    42 => SY
    43 => VF
    44 => VI
    45 => WJ
    47 => ZW
    48 => ZWJ
    _ => XX // 46 or any unknown
  }
}

///|
/// Get the Line_Break for a character.
///
/// Line_Break is the property the line breaking rules of UAX #14 are
/// written in terms of. It is a property of a single character, and the
/// value is the one the Unicode Character Database assigns: rule LB1 of
/// the algorithm, which resolves AI, CJ, SA, SG, and XX to other classes,
/// is not applied. Unassigned code points are XX, except in ranges
/// reserved for characters of a known class, such as ID in the CJK
/// ideograph blocks and in planes 2 and 3.
pub fn line_break(c : Char) -> LineBreak {
  ordinal_to_line_break(@line_break.lookup_line_break(c))
}
