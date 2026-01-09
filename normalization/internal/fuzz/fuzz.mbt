///|
/// Normalization-specific fuzz utilities

///|
/// Check if combining marks in a string are sorted by CCC
pub fn ccc_is_sorted(s : String) -> Bool {
  let codepoints = @codepoint.string_to_codepoints(s)
  for i = 0, last_ccc = 0, in_combining = false; i < codepoints.length(); {
    let cp = codepoints[i]
    let ccc = @ucd.lookup_ccc(cp)
    if ccc == 0 {
      // Starter - reset
      continue i + 1, 0, false
    } else {
      // Combining mark
      if in_combining && ccc < last_ccc {
        break false // Not sorted
      }
      continue i + 1, ccc, true
    }
  } else {
    true
  }
}
