///|
/// Decomposition algorithm for Unicode normalization
/// Implements recursive decomposition for NFD/NFKD

///|
/// Recursively decompose a single code point
/// Returns array of code points in fully decomposed form
fn decompose_codepoint(cp : Int, compatibility~ : Bool) -> Array[Int] {
  // Handle Hangul syllables algorithmically
  if is_hangul_syllable(cp) {
    return decompose_hangul(cp)
  }

  // Look up decomposition mapping
  let mapping : Array[Int]? = if compatibility {
    // For compatibility, first try compat decomposition, then canonical
    match @ucd.get_compat_decomposition(cp) {
      Some(d) => Some(d)
      None => @ucd.get_canonical_decomposition(cp)
    }
  } else {
    @ucd.get_canonical_decomposition(cp)
  }
  match mapping {
    None => [cp] // No decomposition, return as-is
    Some(decomposed) => {
      // Recursively decompose each component
      let result : Array[Int] = []
      for d in decomposed {
        result.append(decompose_codepoint(d, compatibility~))
      }
      result
    }
  }
}

///|
/// Decompose a string to array of code points
/// This is the first step for all normalization forms
fn decompose_string(s : String, compatibility~ : Bool) -> Array[Int] {
  let result : Array[Int] = []
  for c in s {
    let cp = c.to_int()
    result.append(decompose_codepoint(cp, compatibility~))
  }
  result
}
