///|
/// N0: Bracket Pair Processing
///
/// This rule handles matching bracket pairs according to UAX #9.
/// It uses the Bidi_Paired_Bracket property to find bracket pairs
/// and resolves their types based on context.

///|
priv struct BracketPair {
  open_index : Int
  close_index : Int
  open_position : Int
  close_position : Int
}

///|
priv struct BracketStackEntry {
  bracket : Char
  char_index : Int
  sequence_position : Int
}

///|
/// Resolve bracket pairs within an isolating run sequence
fn resolve_bracket_pairs(
  chars : Array[Char],
  types : Array[BidiClass],
  _levels : Array[Int],
  seq : IsolatingRunSequence,
) -> Unit {
  let indices = seq.indices
  if indices.length() == 0 {
    return
  }

  // Find bracket pairs in the sequence
  let pairs = find_bracket_pairs(chars, types, indices)
  if pairs.length() == 0 {
    return
  }

  // Get embedding direction
  let embedding_is_ltr = seq.level % 2 == 0
  let embedding_direction : BidiClass = if embedding_is_ltr {
    BidiClass::L
  } else {
    BidiClass::R
  }
  let opposite_direction : BidiClass = if embedding_is_ltr {
    BidiClass::R
  } else {
    BidiClass::L
  }

  // Prefix counts let each pair query the strong types in its contents in O(1).
  // Earlier pairs cannot be strictly inside a later pair because pairs are
  // processed in opening-position order, so their resolved brackets do not
  // invalidate these counts.
  let ltr_prefix = Array::make(indices.length() + 1, 0)
  let rtl_prefix = Array::make(indices.length() + 1, 0)
  for position, idx in indices {
    ltr_prefix[position + 1] = ltr_prefix[position]
    rtl_prefix[position + 1] = rtl_prefix[position]
    match types[idx] {
      L => ltr_prefix[position + 1] += 1
      R | EN | AN => rtl_prefix[position + 1] += 1
      _ => ()
    }
  }

  // Scan context monotonically as opening positions increase. Reading from
  // types includes brackets resolved by earlier N0 pairs.
  let mut context_position = 0
  let mut context_type = seq.sos
  for pair in pairs {
    while context_position < pair.open_position {
      match types[indices[context_position]] {
        L => context_type = BidiClass::L
        R | EN | AN => context_type = BidiClass::R
        _ => ()
      }
      context_position += 1
    }

    // N0b: Inspect types inside the bracket pair
    let content_start = pair.open_position + 1
    let found_ltr = ltr_prefix[pair.close_position] > ltr_prefix[content_start]
    let found_rtl = rtl_prefix[pair.close_position] > rtl_prefix[content_start]
    let found_embedding = if embedding_is_ltr { found_ltr } else { found_rtl }
    let found_opposite = if embedding_is_ltr { found_rtl } else { found_ltr }

    // N0c: Determine bracket type
    if found_embedding {
      // Set both brackets to embedding direction
      types[pair.open_index] = embedding_direction
      types[pair.close_index] = embedding_direction
    } else if found_opposite {
      let context_matches_embedding = if embedding_is_ltr {
        context_type is L
      } else {
        context_type is R
      }
      if context_matches_embedding {
        // Set brackets to embedding direction
        types[pair.open_index] = embedding_direction
        types[pair.close_index] = embedding_direction
      } else {
        // N0c2: Set brackets to opposite direction
        types[pair.open_index] = opposite_direction
        types[pair.close_index] = opposite_direction
      }
    }
    // If neither found_embedding nor found_opposite, leave brackets as ON
  }
}

///|
/// Find all bracket pairs in an isolating run sequence
/// Returns pairs sorted by opening position in the isolating run sequence.
fn find_bracket_pairs(
  chars : Array[Char],
  types : Array[BidiClass],
  indices : Array[Int],
) -> Array[BracketPair] {
  let pairs : Array[BracketPair] = []

  let stack : Array[BracketStackEntry] = []
  let mut overflow = false
  for sequence_position, idx in indices {
    let c = chars[idx]

    // Only consider brackets that are ON type (after weak resolution)
    let bc = types[idx]
    if !(bc is ON) {
      continue
    }
    let bracket_type = @bidi_data.bracket_type(c)
    match bracket_type {
      Open =>
        // Push to stack
        if stack.length() < 63 { // BD16 limit
          stack.push({ bracket: c, char_index: idx, sequence_position })
        } else {
          overflow = true
          break
        }
      Close =>
        // Find matching opening bracket
        if @bidi_data.paired_bracket(c) is Some(matching_open) {
          let matching_canonical = canonical_bracket(matching_open)
          // Search stack from top for matching open bracket
          let mut found = -1
          for j = stack.length() - 1; j >= 0; j = j - 1 {
            if canonical_bracket(stack[j].bracket) == matching_canonical {
              found = j
              break
            }
          }
          if found >= 0 {
            let open_entry = stack[found]
            pairs.push({
              open_index: open_entry.char_index,
              close_index: idx,
              open_position: open_entry.sequence_position,
              close_position: sequence_position,
            })
            // Remove found entry and everything above it
            while stack.length() > found {
              let _ = stack.pop()
            }
          }
        }
      None => ()
    }
  }

  if overflow {
    return []
  }

  // Sort pairs by opening position
  pairs.sort_by(fn(a, b) { a.open_position - b.open_position })
  pairs
}

///|
/// Map bracket characters to their canonical equivalents for matching.
fn canonical_bracket(c : Char) -> Char {
  match c {
    '\u{2329}' => '\u{3008}'
    '\u{232A}' => '\u{3009}'
    _ => c
  }
}
