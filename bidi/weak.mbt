///|
/// W1-W7: Weak Type Resolution
///
/// These rules resolve weak types (EN, ES, ET, AN, CS, NSM, BN)
/// within an isolating run sequence.

///|
/// Resolve weak types within an isolating run sequence
///
/// The rules apply one after another over the whole sequence, each seeing
/// the types the previous rule left. Two passes reproduce that: the first
/// applies W1-W3, the second W4-W7, and each keeps the earlier-rule types it
/// still needs in locals instead of re-reading them.
fn resolve_weak_types(
  types : Array[BidiClass],
  _levels : Array[Int32],
  seq : IsolatingRunSequence,
) -> Unit {
  let indices = seq.indices
  let count = indices.length()
  if count == 0 {
    return
  }

  // W1: NSM takes the type of the previous character (or sos), or ON after
  //     an isolate initiator or PDI.
  // W2: EN becomes AN when the most recent strong type is AL.
  // W3: AL becomes R.
  // The type after W1 of the previous character, which W1 reads.
  let mut previous_w1 = seq.sos
  // The most recent L, R or AL after W1, which W2 reads.
  let mut last_strong = seq.sos
  for idx in indices {
    let mut bc = types[idx]
    if bc is NSM {
      bc = if previous_w1.is_isolate_initiator() || previous_w1 is PDI {
        BidiClass::ON
      } else {
        previous_w1
      }
    }
    if !(bc is BN) {
      previous_w1 = bc
    }
    match bc {
      L => last_strong = BidiClass::L
      R => last_strong = BidiClass::R
      AL => {
        last_strong = BidiClass::AL
        bc = BidiClass::R
      }
      EN => if last_strong is AL { bc = BidiClass::AN }
      _ => ()
    }
    types[idx] = bc
  }

  // W4: A single ES between two ENs becomes EN; a single CS between two
  //     ENs becomes EN, and between two ANs becomes AN.
  // W5: A sequence of ETs adjacent to EN becomes EN.
  // W6: Remaining ES, ET and CS become ON.
  // W7: EN becomes L when the most recent strong type is L.
  // The type after W4 of the previous character, which W4 reads.
  let mut previous_w4 = BidiClass::ON
  // Whether the previous character is EN after W5.
  let mut previous_is_en = false
  // Start of a run of ETs that no EN precedes; an EN right after the run
  // still turns it into EN.
  let mut et_run_start = -1
  // The most recent L or R, which W7 reads. W3 has removed AL.
  last_strong = seq.sos
  for i in 0..<count {
    let idx = indices[i]
    let mut bc = types[idx]
    if (bc is ES || bc is CS) && i > 0 && i < count - 1 {
      // The next character has not been through W4 yet, as in a W4-only pass.
      let next_bc = types[indices[i + 1]]
      if previous_w4 is EN && next_bc is EN {
        bc = BidiClass::EN
      } else if bc is CS && previous_w4 is AN && next_bc is AN {
        bc = BidiClass::AN
      }
    }
    previous_w4 = bc
    types[idx] = match bc {
      ET =>
        if previous_is_en {
          if last_strong is L {
            BidiClass::L
          } else {
            BidiClass::EN
          }
        } else {
          if et_run_start < 0 {
            et_run_start = i
          }
          BidiClass::ON
        }
      EN => {
        let resolved = if last_strong is L {
          BidiClass::L
        } else {
          BidiClass::EN
        }
        if et_run_start >= 0 {
          for j in et_run_start..<i {
            types[indices[j]] = resolved
          }
          et_run_start = -1
        }
        previous_is_en = true
        resolved
      }
      _ => {
        previous_is_en = false
        et_run_start = -1
        match bc {
          ES | CS => BidiClass::ON
          L => {
            last_strong = BidiClass::L
            bc
          }
          R => {
            last_strong = BidiClass::R
            bc
          }
          _ => bc
        }
      }
    }
  }
}
