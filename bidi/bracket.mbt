///|
/// N0: Bracket Pair Processing
///
/// This rule handles matching bracket pairs according to UAX #9.
/// It uses the Bidi_Paired_Bracket property to find bracket pairs
/// and resolves their types based on context.

///|
/// An L between a bracket pair.
const StrongLtr : Int32 = 1

///|
/// An R, EN or AN between a bracket pair.
const StrongRtl : Int32 = 2

///|
/// Working storage for bracket pairing, reused across the isolating run
/// sequences of a paragraph. Uses unboxed primitive arrays to avoid
/// per-bracket heap allocations.
priv struct BracketScratch {
  /// The pairs found in the current sequence, kept sorted by opening position.
  pair_open_index : Array[Int32]
  pair_close_index : Array[Int32]
  pair_open_position : Array[Int32]
  pair_close_position : Array[Int32]
  pair_strong : Array[Int32]
  /// Open brackets not yet closed (BD16 limit is 63).
  stack_bracket : FixedArray[Char]
  stack_char_index : FixedArray[Int32]
  stack_seq_pos : FixedArray[Int32]
  stack_strong : FixedArray[Int32]
}

///|
fn BracketScratch::new() -> BracketScratch {
  {
    pair_open_index: [],
    pair_close_index: [],
    pair_open_position: [],
    pair_close_position: [],
    pair_strong: [],
    stack_bracket: FixedArray::make(63, '\u{0}'),
    stack_char_index: FixedArray::make(63, 0),
    stack_seq_pos: FixedArray::make(63, 0),
    stack_strong: FixedArray::make(63, 0),
  }
}

///|
/// Resolve bracket pairs within an isolating run sequence
fn resolve_bracket_pairs(
  scratch : BracketScratch,
  chars : Array[Char],
  types : Array[BidiClass],
  original_classes : Array[BidiClass],
  seq : IsolatingRunSequence,
  has_nsm~ : Bool,
) -> Unit {
  let indices = seq.indices
  if indices.length() == 0 {
    return
  }

  // Find bracket pairs in the sequence
  find_bracket_pairs(scratch, chars, types, indices)
  let pair_count = scratch.pair_open_index.length()
  if pair_count == 0 {
    return
  }

  // Get embedding direction
  let embedding_is_ltr = (seq.level & 1) == 0
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
  let {
    pair_open_index,
    pair_close_index,
    pair_open_position,
    pair_close_position,
    pair_strong,
    ..
  } = scratch

  // Scan context monotonically as opening positions increase. Reading from
  // types includes brackets resolved by earlier N0 pairs.
  let mut context_position = 0
  let mut context_type = seq.sos
  for p in 0..<pair_count {
    let open_position = pair_open_position.unsafe_get(p)
    while context_position < open_position {
      match types.unsafe_get(indices.unsafe_get(context_position)) {
        L => context_type = BidiClass::L
        R | EN | AN => context_type = BidiClass::R
        _ => ()
      }
      context_position += 1
    }

    // N0b, N0c: Determine bracket type from the strong types inside the pair
    let strong = pair_strong.unsafe_get(p)
    let resolved = if (strong & embedding_strong) != 0 {
      embedding_direction
    } else if (strong & opposite_strong) != 0 {
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
    types.unsafe_set(pair_open_index.unsafe_get(p), resolved)
    types.unsafe_set(pair_close_index.unsafe_get(p), resolved)
    if has_nsm {
      retype_following_marks(
        types, original_classes, indices, open_position, resolved,
      )
      retype_following_marks(
        types,
        original_classes,
        indices,
        pair_close_position.unsafe_get(p),
        resolved,
      )
    }
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
    let idx = indices.unsafe_get(position)
    guard original_classes.unsafe_get(idx) is NSM && types.unsafe_get(idx) is ON else {
      break
    }
    types.unsafe_set(idx, resolved)
  }
}

///|
/// Fast path for matching ASCII closing brackets to their opening bracket.
fn paired_open_bracket(c : Char) -> Char? {
  match c {
    ')' => Some('(')
    ']' => Some('[')
    '}' => Some('{')
    _ => @bidi_data.paired_bracket(c)
  }
}

///|
/// Find all bracket pairs in an isolating run sequence
/// Leaves them in `scratch`, sorted by opening position in the sequence.
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
  let {
    pair_open_index,
    pair_close_index,
    pair_open_position,
    pair_close_position,
    pair_strong,
    stack_bracket,
    stack_char_index,
    stack_seq_pos,
    stack_strong,
  } = scratch
  pair_open_index.clear()
  pair_close_index.clear()
  pair_open_position.clear()
  pair_close_position.clear()
  pair_strong.clear()
  let mut stack_len = 0
  let mut overflow = false
  for sequence_position, idx in indices {
    // Only consider brackets that are ON type (after weak resolution)
    match types.unsafe_get(idx) {
      ON => ()
      L => {
        if stack_len > 0 {
          let top = stack_len - 1
          stack_strong.unsafe_set(top, stack_strong.unsafe_get(top) | StrongLtr)
        }
        continue
      }
      R | EN | AN => {
        if stack_len > 0 {
          let top = stack_len - 1
          stack_strong.unsafe_set(top, stack_strong.unsafe_get(top) | StrongRtl)
        }
        continue
      }
      _ => continue
    }
    let c = chars.unsafe_get(idx)
    match lookup_bracket_tag(c) {
      1 =>
        // Push to stack
        if stack_len < 63 { // BD16 limit
          stack_bracket.unsafe_set(stack_len, canonical_bracket(c))
          stack_char_index.unsafe_set(stack_len, idx)
          stack_seq_pos.unsafe_set(stack_len, sequence_position)
          stack_strong.unsafe_set(stack_len, 0)
          stack_len += 1
        } else {
          overflow = true
          break
        }
      2 =>
        // Find matching opening bracket
        if stack_len > 0 && paired_open_bracket(c) is Some(matching_open) {
          let matching_canonical = canonical_bracket(matching_open)
          // Search stack from top for matching open bracket
          let mut found = -1
          for j in (stack_len - 1)>=..0 {
            if stack_bracket.unsafe_get(j) == matching_canonical {
              found = j
              break
            }
          }
          if found >= 0 {
            let open_index = stack_char_index.unsafe_get(found)
            let open_position = stack_seq_pos.unsafe_get(found)
            // Everything above the match lies inside the pair too.
            let mut inside = 0
            for j in found..<stack_len {
              inside = inside | stack_strong.unsafe_get(j)
            }
            // Insert in sorted order by opening position. Since each pair can
            // only be displaced by at most 62 enclosing pairs (BD16 limit),
            // insertion sort is strictly O(N) worst-case.
            let mut insert_at = pair_open_position.length()
            pair_open_index.push(open_index)
            pair_close_index.push(idx)
            pair_open_position.push(open_position)
            pair_close_position.push(sequence_position)
            pair_strong.push(inside)
            while insert_at > 0 &&
                  pair_open_position.unsafe_get(insert_at - 1) > open_position {
              let prev = insert_at - 1
              pair_open_index.unsafe_set(
                insert_at,
                pair_open_index.unsafe_get(prev),
              )
              pair_close_index.unsafe_set(
                insert_at,
                pair_close_index.unsafe_get(prev),
              )
              pair_open_position.unsafe_set(
                insert_at,
                pair_open_position.unsafe_get(prev),
              )
              pair_close_position.unsafe_set(
                insert_at,
                pair_close_position.unsafe_get(prev),
              )
              pair_strong.unsafe_set(insert_at, pair_strong.unsafe_get(prev))
              insert_at = prev
            }
            if insert_at < pair_open_position.length() - 1 {
              pair_open_index.unsafe_set(insert_at, open_index)
              pair_close_index.unsafe_set(insert_at, idx)
              pair_open_position.unsafe_set(insert_at, open_position)
              pair_close_position.unsafe_set(insert_at, sequence_position)
              pair_strong.unsafe_set(insert_at, inside)
            }
            // Remove found entry and everything above it
            stack_len = found
            if found > 0 {
              stack_strong.unsafe_set(
                found - 1,
                stack_strong.unsafe_get(found - 1) | inside,
              )
            }
          }
        }
      _ => ()
    }
  }
  if overflow {
    pair_open_index.clear()
    pair_close_index.clear()
    pair_open_position.clear()
    pair_close_position.clear()
    pair_strong.clear()
  }
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
