///|
/// Decomposition algorithm for Unicode normalization
/// Implements recursive decomposition for NFD/NFKD

///|
/// Recursively decompose a single character
/// Returns array of characters in fully decomposed form
fn decompose_char_into(
  result : Array[Char],
  c : Char,
  compatibility~ : Bool,
) -> Unit {
  // Handle Hangul syllables algorithmically (their jamo have no further
  // decomposition, so push them directly).
  if is_hangul_syllable(c) {
    for part in decompose_hangul(c) {
      result.push(part)
    }
    return
  }

  // Look up decomposition mapping
  let mapping : Array[Char]? = if compatibility {
    // For compatibility, first try compat decomposition, then canonical
    match @ucd.get_compat_decomposition(c) {
      Some(d) => Some(d)
      None => @ucd.get_canonical_decomposition(c)
    }
  } else {
    @ucd.get_canonical_decomposition(c)
  }
  match mapping {
    // No decomposition: keep the character as-is without allocating
    None => result.push(c)
    Some(decomposed) =>
      // Recursively decompose each component
      for d in decomposed {
        decompose_char_into(result, d, compatibility~)
      }
  }
}

///|
/// Decompose a string to array of characters
/// This is the first step for all normalization forms
fn decompose_string(s : String, compatibility~ : Bool) -> Array[Char] {
  let result : Array[Char] = []
  for c in s {
    decompose_char_into(result, c, compatibility~)
  }
  result
}
