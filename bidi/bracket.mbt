///|
/// N0: Bracket Pair Processing
///
/// This rule handles matching bracket pairs according to UAX #9.
/// It uses the Bidi_Paired_Bracket property to find bracket pairs
/// and resolves their types based on context.

///|
priv struct BracketPair {
  open_index : Int32
  close_index : Int32
  open_position : Int32
  close_position : Int32
  /// Strong types between the brackets: `StrongLtr`, `StrongRtl`, or both.
  strong : Int32
}

///|
/// An L between a bracket pair.
const StrongLtr : Int32 = 1

///|
/// An R, EN or AN between a bracket pair.
const StrongRtl : Int32 = 2

///|
priv struct BracketStackEntry {
  bracket : Char
  char_index : Int32
  sequence_position : Int32
}

///|
/// Working storage for bracket pairing, reused across the isolating run
/// sequences of a paragraph.
priv struct BracketScratch {
  /// The pairs found in the current sequence.
  pairs : Array[BracketPair]
  /// Open brackets not yet closed.
  stack : Array[BracketStackEntry]
  /// Strong types seen directly inside each open bracket on the stack.
  strong : Array[Int32]
}

///|
fn BracketScratch::new() -> BracketScratch {
  { pairs: [], stack: [], strong: [], }
}

///|
/// Resolve bracket pairs within an isolating run sequence
fn resolve_bracket_pairs(
  scratch : BracketScratch,
  chars : Array[Char],
  types : Array[BidiClass],
  original_classes : Array[BidiClass],
  seq : IsolatingRunSequence,
) -> Unit {
  let indices = seq.indices
  if indices.length() == 0 {
    return
  }

  // Find bracket pairs in the sequence
  find_bracket_pairs(scratch, chars, types, indices)
  let pairs = scratch.pairs
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
  let embedding_strong = if embedding_is_ltr { StrongLtr } else { StrongRtl }
  let opposite_strong = if embedding_is_ltr { StrongRtl } else { StrongLtr }

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

    // N0b, N0c: Determine bracket type from the strong types inside the pair
    let resolved = if (pair.strong & embedding_strong) != 0 {
      embedding_direction
    } else if (pair.strong & opposite_strong) != 0 {
      let context_matches_embedding = if embedding_is_ltr {
        context_type is L
      } else {
        context_type is R
      }
      if context_matches_embedding {
        embedding_direction
      } else {
        // N0c2: Set brackets to opposite direction
        opposite_direction
      }
    } else {
      // With no strong type inside, leave brackets as ON
      continue
    }
    types[pair.open_index] = resolved
    types[pair.close_index] = resolved
    retype_following_marks(
      types,
      original_classes,
      indices,
      pair.open_position,
      resolved,
    )
    retype_following_marks(
      types,
      original_classes,
      indices,
      pair.close_position,
      resolved,
    )
  }
}

///|
/// N0: characters that were NSM before W1 and follow a bracket that N0
/// changed take the bracket's new type. They are still ON here, the type W1
/// gave them from the bracket.
fn retype_following_marks(
  types : Array[BidiClass],
  original_classes : Array[BidiClass],
  indices : Array[Int32],
  bracket_position : Int32,
  resolved : BidiClass,
) -> Unit {
  for position in (bracket_position + 1)..<indices.length() {
    let idx = indices[position]
    guard original_classes[idx] is NSM && types[idx] is ON else { break }
    types[idx] = resolved
  }
}

///|
/// Find all bracket pairs in an isolating run sequence
/// Leaves them in `scratch.pairs`, sorted by opening position in the sequence.
///
/// The same pass records which strong types lie between each pair. An open
/// bracket collects the strong types seen while it is the innermost one, and
/// hands them to the bracket enclosing it when it is closed or discarded.
/// Brackets resolved for other pairs never count: a pair is resolved before
/// any pair inside it, so the types read here are the ones N0 starts from.
fn find_bracket_pairs(
  scratch : BracketScratch,
  chars : Array[Char],
  types : Array[BidiClass],
  indices : Array[Int32],
) -> Unit {
  let { pairs, stack, strong, } = scratch
  pairs.clear()
  stack.clear()
  strong.clear()
  let mut overflow = false
  for sequence_position, idx in indices {
    // Only consider brackets that are ON type (after weak resolution)
    match types[idx] {
      ON => ()
      L => {
        if strong.length() > 0 {
          strong[strong.length() - 1] = strong[strong.length() - 1] | StrongLtr
        }
        continue
      }
      R | EN | AN => {
        if strong.length() > 0 {
          strong[strong.length() - 1] = strong[strong.length() - 1] | StrongRtl
        }
        continue
      }
      _ => continue
    }
    let c = chars[idx]
    let bracket_type = @bidi_data.bracket_type(c)
    match bracket_type {
      Open =>
        // Push to stack
        if stack.length() < 63 { // BD16 limit
          stack.push({ bracket: c, char_index: idx, sequence_position, })
          strong.push(0)
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
            // Everything above the match lies inside the pair too.
            let mut inside = 0
            for j in found..<strong.length() {
              inside = inside | strong[j]
            }
            pairs.push({
              open_index: open_entry.char_index,
              close_index: idx,
              open_position: open_entry.sequence_position,
              close_position: sequence_position,
              strong: inside,
            })
            // Remove found entry and everything above it
            stack.truncate(found)
            strong.truncate(found)
            if found > 0 {
              strong[found - 1] = strong[found - 1] | inside
            }
          }
        }
      None => ()
    }
  }

  if overflow {
    pairs.clear()
    return
  }

  // Sort pairs by opening position
  pairs.sort_by(fn(a, b) { a.open_position - b.open_position })
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
