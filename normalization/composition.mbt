///|
/// Canonical Composition Algorithm
/// Composes adjacent starter + non-blocked combining marks into precomposed characters

///|
/// Try to compose two characters into one
/// Handles both Hangul and general composition
fn try_compose(first : Char, second : Char) -> Char? {
  // Try Hangul composition first (algorithmic, no table lookup)
  match try_compose_hangul(first, second) {
    Some(h) => return Some(h)
    None => ()
  }

  // Look up in composition table
  @composition.lookup_composition(first, second)
}

///|
/// Compose a sequence of canonically ordered characters
/// Compact in place, reusing the decomposition buffer for NFC and NFKC.
fn canonical_compose(chars : Array[Char]) -> Unit {
  let len = chars.length()
  if len == 0 {
    return
  }
  let mut written = 1

  // Track the last starter position in the compacted prefix (-1 if no starter yet)
  let first_ccc = @ccc.lookup_ccc(chars[0])
  let mut last_starter_idx = if first_ccc == 0 { 0 } else { -1 }

  // Track CCC of the last character we processed
  // Used to detect "blocked" combining marks
  let mut last_ccc = first_ccc
  // written never exceeds i: compaction cannot overwrite unread input.
  for i in 1..<len {
    let c = chars[i]
    let ccc = @ccc.lookup_ccc(c)

    // A combining mark is "blocked" from composing with a starter if
    // there's an intervening combining mark with the same or higher CCC
    // (since marks are canonically ordered by CCC)
    //
    // We can compose if:
    // 1. There is a last starter (last_starter_idx >= 0)
    // 2. Either this is right after the starter (last_ccc == 0)
    //    OR this mark's CCC is greater than the previous mark's CCC
    let not_blocked = last_ccc == 0 || (ccc != 0 && last_ccc < ccc)
    if last_starter_idx >= 0 && not_blocked {
      let starter = chars[last_starter_idx]
      match try_compose(starter, c) {
        Some(composed) => {
          // Successfully composed - update the starter in the compacted prefix
          chars[last_starter_idx] = composed
          // The composed character is still a starter, don't update last_ccc
          // This allows further composition with subsequent marks
          continue
        }
        None => ()
      }
    }

    // Could not compose, keep the character in the compacted prefix
    chars[written] = c
    written += 1
    if ccc == 0 {
      // This is a new starter
      last_starter_idx = written - 1
      last_ccc = 0
    } else {
      // This is a combining mark, update last_ccc
      last_ccc = ccc
    }
  }
  chars.truncate(written)
}
