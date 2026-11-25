///|
/// N1-N2: Neutral Type Resolution
///
/// These rules resolve neutral types (B, S, WS, ON, FSI, LRI, RLI, PDI)
/// after bracket pair resolution.

///|
/// Resolve neutral types within an isolating run sequence in a single forward pass.
fn resolve_neutral_types(
  types : Array[BidiClass],
  _levels : Array[Int32],
  seq : IsolatingRunSequence,
) -> Unit {
  let indices = seq.indices
  let count = indices.length()
  if count == 0 {
    return
  }
  let embedding_dir : BidiClass = if (seq.level & 1) == 0 {
    BidiClass::L
  } else {
    BidiClass::R
  }
  let mut last_strong = seq.sos
  let mut i = 0
  while i < count {
    let idx = indices.unsafe_get(i)
    match types.unsafe_get(idx) {
      L => {
        last_strong = BidiClass::L
        i += 1
      }
      R | EN | AN => {
        last_strong = BidiClass::R
        i += 1
      }
      bc if bc.is_neutral_or_isolate() => {
        let run_start = i
        i += 1
        let mut following = seq.eos
        while i < count {
          match types.unsafe_get(indices.unsafe_get(i)) {
            L => {
              following = BidiClass::L
              break
            }
            R | EN | AN => {
              following = BidiClass::R
              break
            }
            _ => i += 1
          }
        }
        // N1: If preceding and following strong types match, neutrals take that type.
        // N2: Otherwise, neutrals take the embedding direction.
        let resolved = if last_strong == following {
          last_strong
        } else {
          embedding_dir
        }
        for j in run_start..<i {
          types.unsafe_set(indices.unsafe_get(j), resolved)
        }
        if i < count {
          last_strong = following
          i += 1
        }
      }
      _ => i += 1
    }
  }
}
