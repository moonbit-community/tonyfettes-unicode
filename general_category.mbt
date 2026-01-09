///|
/// Unicode General_Category major class (single-letter categories)
/// See UAX #44: https://www.unicode.org/reports/tr44/#General_Category_Values
pub(all) enum GeneralCategoryGroup {
  L // Letter
  M // Mark
  N // Number
  Z // Separator
  P // Punctuation
  S // Symbol
  C // Other
} derive(Eq, Show)

///|
/// Unicode General_Category values (two-letter categories)
/// See UAX #44: https://www.unicode.org/reports/tr44/#General_Category_Values
pub(all) enum GeneralCategory {
  // Letter (L)
  Lu // Uppercase_Letter
  Ll // Lowercase_Letter
  Lt // Titlecase_Letter
  Lm // Modifier_Letter
  Lo // Other_Letter
  // Mark (M)
  Mn // Nonspacing_Mark
  Mc // Spacing_Mark
  Me // Enclosing_Mark
  // Number (N)
  Nd // Decimal_Number
  Nl // Letter_Number
  No // Other_Number
  // Separator (Z)
  Zs // Space_Separator
  Zl // Line_Separator
  Zp // Paragraph_Separator
  // Punctuation (P)
  Pc // Connector_Punctuation
  Pd // Dash_Punctuation
  Ps // Open_Punctuation
  Pe // Close_Punctuation
  Pi // Initial_Punctuation
  Pf // Final_Punctuation
  Po // Other_Punctuation
  // Symbol (S)
  Sm // Math_Symbol
  Sc // Currency_Symbol
  Sk // Modifier_Symbol
  So // Other_Symbol
  // Other (C)
  Cc // Control
  Cf // Format
  Cs // Surrogate
  Co // Private_Use
  Cn // Unassigned
} derive(Eq, Show)

///|
/// Convert GeneralCategory ordinal to enum value
fn ordinal_to_gc(ordinal : Int) -> GeneralCategory {
  match ordinal {
    0 => Lu
    1 => Ll
    2 => Lt
    3 => Lm
    4 => Lo
    5 => Mn
    6 => Mc
    7 => Me
    8 => Nd
    9 => Nl
    10 => No
    11 => Zs
    12 => Zl
    13 => Zp
    14 => Pc
    15 => Pd
    16 => Ps
    17 => Pe
    18 => Pi
    19 => Pf
    20 => Po
    21 => Sm
    22 => Sc
    23 => Sk
    24 => So
    25 => Cc
    26 => Cf
    27 => Cs
    28 => Co
    _ => Cn // 29 or any unknown
  }
}

///|
/// Get the General_Category for a code point
pub fn general_category(cp : Int) -> GeneralCategory {
  ordinal_to_gc(@ucd_data.lookup_general_category(cp))
}

///|
/// Get the major category group (single-letter category) for a GeneralCategory
pub fn GeneralCategory::group(self : GeneralCategory) -> GeneralCategoryGroup {
  match self {
    Lu | Ll | Lt | Lm | Lo => L
    Mn | Mc | Me => M
    Nd | Nl | No => N
    Zs | Zl | Zp => Z
    Pc | Pd | Ps | Pe | Pi | Pf | Po => P
    Sm | Sc | Sk | So => S
    Cc | Cf | Cs | Co | Cn => C
  }
}
