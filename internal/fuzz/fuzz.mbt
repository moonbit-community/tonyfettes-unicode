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
  }
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
