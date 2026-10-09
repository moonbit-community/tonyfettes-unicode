///|
/// Decomposition algorithm for Unicode normalization
/// Implements recursive decomposition for NFD/NFKD

///|
/// Append a character's full recursive decomposition to the destination.
fn decompose_char(c : Char, dest : Array[Char], compatibility~ : Bool) -> Unit {
  // Handle Hangul syllables algorithmically
  if is_hangul_syllable(c) {
    decompose_hangul(c, dest)
    return
  }

  // Look up decomposition mapping
  let mapping : Array[Char]? = if compatibility {
    // For compatibility, first try compat decomposition, then canonical
    let compat = @decomposition.get_compat_decomposition(c)
    if compat is None {
      @decomposition.get_canonical_decomposition(c)
    } else {
      compat
    }
  } else {
    @decomposition.get_canonical_decomposition(c)
  }
  if mapping is Some(decomposed) {
    for d in decomposed {
      decompose_char(d, dest, compatibility~)
    }
  } else {
    dest.push(c)
  }
}

///|
/// Decompose a string to array of characters
/// This is the first step for all normalization forms
fn decompose_string(s : String, compatibility~ : Bool) -> Array[Char] {
  let result : Array[Char] = []
  for c in s {
    decompose_char(c, result, compatibility~)
  }
  result
}
