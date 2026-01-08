///|
/// Generic random Unicode string generator for fuzz testing
/// Generates strings with various Unicode categories

///|
/// Code point ranges for generating interesting test cases
let ascii_range : (Int, Int) = (0x20, 0x7E) // Printable ASCII

///|
let latin_extended_range : (Int, Int) = (0x00C0, 0x024F) // Many decomposable chars

///|
let combining_marks_range : (Int, Int) = (0x0300, 0x036F) // Combining diacritical marks

///|
let hangul_jamo_l_range : (Int, Int) = (0x1100, 0x1112) // Leading consonants

///|
let hangul_jamo_v_range : (Int, Int) = (0x1161, 0x1175) // Vowels

///|
let hangul_jamo_t_range : (Int, Int) = (0x11A8, 0x11C2) // Trailing consonants

///|
let hangul_syllable_range : (Int, Int) = (0xAC00, 0xD7A3) // Precomposed syllables

///|
let supplementary_range : (Int, Int) = (0x10000, 0x10FFFF) // Supplementary planes

///|
let arabic_range : (Int, Int) = (0x0600, 0x06FF) // Arabic script (RTL)

///|
let hebrew_range : (Int, Int) = (0x0590, 0x05FF) // Hebrew script (RTL)

///|
let arabic_number_range : (Int, Int) = (0x0660, 0x0669) // Arabic-Indic digits

///|
/// Characters that have interesting decompositions (singletons, multi-char)
let decomposable_chars : Array[Int] = [
  0x00C5, // Å - decomposes to A + combining ring
   0x00D1, // Ñ - decomposes to N + combining tilde
   0x00E9, // é - decomposes to e + combining acute
   0x01FA, // Ǻ - multi-level decomposition
   0x2126, // Ω (Ohm) - singleton decomposition to Greek Omega
   0x212A, // K (Kelvin) - singleton decomposition to K
   0x212B, // Å (Angstrom) - singleton decomposition to Å then to A + ring
   0x1E69, // ṩ - multi-char decomposition
   0x0132, // IJ ligature (compatibility)
   0x00BC, // ¼ (compatibility)
   0x2160, // Ⅰ Roman numeral (compatibility)
   0xFF21, // Ａ Fullwidth A (compatibility)
]

///|
/// Characters that are IGNORED in IDNA processing
let idna_ignored_chars : Array[Int] = [
  0x00AD, // Soft hyphen
   0x034F, // Combining grapheme joiner
   0x180B, // Mongolian free variation selector one
   0xFE00,
] // Variation selector-1

///|
/// Characters that are DISALLOWED in IDNA processing
let idna_disallowed_chars : Array[Int] = [
  0x0000, // NULL
   0x0020, // SPACE
   0x007F, // DELETE
   0x00A0, // NO-BREAK SPACE
   0x2028, // LINE SEPARATOR
   0x2029, // PARAGRAPH SEPARATOR
   0xFFFD, // REPLACEMENT CHARACTER
]

///|
/// Deviation characters - treated as valid in nontransitional mode
let idna_deviation_chars : Array[Int] = [
  0x00DF, // ß (German sharp s)
   0x03C2, // ς (Greek final sigma)
   0x200C, // ZWNJ
   0x200D,
] // ZWJ

///|
/// Characters that are mapped to other characters in IDNA
let idna_mapped_chars : Array[Int] = [
  0xFF21, // Ａ Fullwidth A -> a
   0xFF22, // Ｂ Fullwidth B -> b
   0xFF23, // Ｃ Fullwidth C -> c
   0x0041, // A -> a (case fold)
   0x0042, // B -> b (case fold)
   0x0043, // C -> c (case fold)
   0x2126, // Ω (Ohm) -> ω
   0x212A, // K (Kelvin) -> k
   0x212B, // Å (Angstrom) -> å
]

///|
/// Generate a random code point within a range (inclusive)
fn random_codepoint_in_range(rng : @random.Rand, range : (Int, Int)) -> Int {
  let (lo, hi) = range
  lo + rng.int(limit=hi - lo + 1)
}

///|
/// Category of code points to generate
pub(all) enum CodePointCategory {
  Ascii
  LatinExtended
  CombiningMark
  HangulJamoL
  HangulJamoV
  HangulJamoT
  HangulSyllable
  Supplementary
  Decomposable
  ArabicRTL
  HebrewRTL
  ArabicNumber
  IdnaIgnored
  IdnaDisallowed
  IdnaDeviation
  IdnaMapped
}

///|
/// Generate a random code point from a specific category
pub fn random_codepoint(
  rng : @random.Rand,
  category : CodePointCategory,
) -> Int {
  match category {
    Ascii => random_codepoint_in_range(rng, ascii_range)
    LatinExtended => random_codepoint_in_range(rng, latin_extended_range)
    CombiningMark => random_codepoint_in_range(rng, combining_marks_range)
    HangulJamoL => random_codepoint_in_range(rng, hangul_jamo_l_range)
    HangulJamoV => random_codepoint_in_range(rng, hangul_jamo_v_range)
    HangulJamoT => random_codepoint_in_range(rng, hangul_jamo_t_range)
    HangulSyllable => random_codepoint_in_range(rng, hangul_syllable_range)
    Supplementary => {
      // Avoid surrogates (0xD800-0xDFFF)
      let cp = random_codepoint_in_range(rng, supplementary_range)
      cp
    }
    Decomposable =>
      decomposable_chars[rng.int(limit=decomposable_chars.length())]
    ArabicRTL => random_codepoint_in_range(rng, arabic_range)
    HebrewRTL => random_codepoint_in_range(rng, hebrew_range)
    ArabicNumber => random_codepoint_in_range(rng, arabic_number_range)
    IdnaIgnored =>
      idna_ignored_chars[rng.int(limit=idna_ignored_chars.length())]
    IdnaDisallowed =>
      idna_disallowed_chars[rng.int(limit=idna_disallowed_chars.length())]
    IdnaDeviation =>
      idna_deviation_chars[rng.int(limit=idna_deviation_chars.length())]
    IdnaMapped => idna_mapped_chars[rng.int(limit=idna_mapped_chars.length())]
  }
}

// Total valid Unicode code points (excluding surrogates U+D800-U+DFFF)
// U+0000 to U+10FFFF = 1114112 total, minus 2048 surrogates = 1112064 valid

///|
let unicode_valid_count : Int = 0x110000 - 0x800 // 1112064

// Non-ASCII valid code points (U+0080 to U+10FFFF, excluding surrogates)
// 1112064 total minus 128 ASCII = 1111936

///|
let non_ascii_valid_count : Int = unicode_valid_count - 0x80 // 1111936

///|
/// Map an index to a valid Unicode code point (skipping surrogates)
fn index_to_codepoint(index : Int) -> Int {
  // If index < 0xD800, return as-is (before surrogate range)
  // Otherwise, add 0x800 to skip the surrogate range
  if index < 0xD800 {
    index
  } else {
    index + 0x800
  }
}

///|
/// Generate a random non-ASCII code point (U+0080 to U+10FFFF, excluding surrogates)
pub fn random_non_ascii_codepoint(rng : @random.Rand) -> Int {
  // Generate index in range [0, non_ascii_valid_count)
  // Then offset by 0x80 to skip ASCII, and apply surrogate skip
  let index = rng.int(limit=non_ascii_valid_count)
  index_to_codepoint(index + 0x80)
}

///|
/// Generate a random Unicode code point (U+0000 to U+10FFFF, excluding surrogates)
pub fn random_any_codepoint(rng : @random.Rand) -> Int {
  // Generate index in range [0, unicode_valid_count)
  let index = rng.int(limit=unicode_valid_count)
  index_to_codepoint(index)
}

///|
/// Convert a single code point to string (handling supplementary plane)
pub fn codepoint_to_char(cp : Int) -> String {
  let sb = StringBuilder::new()
  if cp <= 0xFFFF {
    sb.write_char(cp.unsafe_to_char())
  } else {
    // Encode as surrogate pair
    let adjusted = cp - 0x10000
    let high = 0xD800 + (adjusted >> 10)
    let low = 0xDC00 + (adjusted & 0x3FF)
    sb.write_char(high.unsafe_to_char())
    sb.write_char(low.unsafe_to_char())
  }
  sb.to_string()
}

///|
/// Generate a random Unicode string with mixed categories
pub fn random_unicode_string(rng : @random.Rand, max_len? : Int = 50) -> String {
  let len = rng.int(limit=max_len) + 1
  let sb = StringBuilder::new()
  let categories : Array[CodePointCategory] = [
    Ascii,
    Ascii,
    Ascii, // Weight ASCII more heavily
    LatinExtended,
    LatinExtended,
    CombiningMark,
    HangulSyllable,
    Decomposable,
  ]
  for _ in 0..<len {
    let cat = categories[rng.int(limit=categories.length())]
    let cp = random_codepoint(rng, cat)
    sb.write_string(codepoint_to_char(cp))
  }
  sb.to_string()
}

///|
/// Generate a string with a base character followed by combining marks
/// This tests CCC ordering specifically
pub fn random_combining_sequence(
  rng : @random.Rand,
  base_count? : Int = 3,
  mark_count? : Int = 5,
) -> String {
  let sb = StringBuilder::new()
  for _ in 0..<base_count {
    // Add a base character (Latin Extended has many decomposable base chars)
    let base = random_codepoint(rng, LatinExtended)
    sb.write_string(codepoint_to_char(base))
    // Add random combining marks
    let marks = rng.int(limit=mark_count) + 1
    for _ in 0..<marks {
      let mark = random_codepoint(rng, CombiningMark)
      sb.write_string(codepoint_to_char(mark))
    }
  }
  sb.to_string()
}

///|
/// Generate a random Hangul string (jamo and syllables mixed)
pub fn random_hangul_string(rng : @random.Rand, max_len? : Int = 20) -> String {
  let len = rng.int(limit=max_len) + 1
  let sb = StringBuilder::new()
  for _ in 0..<len {
    let choice = rng.int(limit=5)
    let cp = if choice < 2 {
      // Precomposed syllable (most common)
      random_codepoint(rng, HangulSyllable)
    } else if choice == 2 {
      random_codepoint(rng, HangulJamoL)
    } else if choice == 3 {
      random_codepoint(rng, HangulJamoV)
    } else {
      random_codepoint(rng, HangulJamoT)
    }
    sb.write_string(codepoint_to_char(cp))
  }
  sb.to_string()
}

///|
/// Generate a string that should stress deep decomposition
pub fn random_deep_decomposition_string(
  rng : @random.Rand,
  max_len? : Int = 20,
) -> String {
  let len = rng.int(limit=max_len) + 1
  let sb = StringBuilder::new()
  for _ in 0..<len {
    let cp = random_codepoint(rng, Decomposable)
    sb.write_string(codepoint_to_char(cp))
  }
  sb.to_string()
}
