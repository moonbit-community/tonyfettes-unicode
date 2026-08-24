///|
/// W1-W7: Weak Type Resolution
///
/// These rules resolve weak types (EN, ES, ET, AN, CS, NSM, BN)
/// within an isolating run sequence.

///|
/// Resolve weak types within an isolating run sequence
fn resolve_weak_types(
  types : Array[BidiClass],
  _levels : Array[Int],
  seq : IsolatingRunSequence,
) -> Unit {
  let indices = seq.indices
  if indices.length() == 0 {
    return
  }

  // W1: NSM - Non-Spacing Mark
  // Examine each character that is not an isolate initiator or PDI.
  // If the previous character is an isolate initiator or PDI, change NSM to ON.
  // Otherwise, change NSM to the type of the previous character (or sos).
  let mut prev_type = seq.sos
  for idx in indices {
    let bc = types[idx]
    if bc is NSM {
      // Check if previous character was isolate initiator or PDI
      // In resolved types, isolate initiators keep their type
      if prev_type.is_isolate_initiator() || prev_type is PDI {
        types[idx] = BidiClass::ON
      } else {
        types[idx] = prev_type
      }
    }
    // Update prev_type (don't follow BN)
    if !(types[idx] is BN) {
      prev_type = types[idx]
    }
  }

  // W2: EN - European Number after AL
  // Track the most recent strong type instead of rescanning for every EN.
  let mut last_strong = seq.sos
  for idx in indices {
    match types[idx] {
      L => last_strong = BidiClass::L
      R => last_strong = BidiClass::R
      AL => last_strong = BidiClass::AL
      EN => if last_strong is AL { types[idx] = BidiClass::AN }
      _ => ()
    }
  }

  // W3: AL - Arabic Letter becomes R
  for idx in indices {
    if types[idx] is AL {
      types[idx] = BidiClass::R
    }
  }

  // W4: ES/CS between EN/AN
  // A single ES between two ENs becomes EN.
  // A single CS between two ENs becomes EN.
  // A single CS between two ANs becomes AN.
  for i = 1; i < indices.length() - 1; i = i + 1 {
    let idx = indices[i]
    let bc = types[idx]
    if bc is ES || bc is CS {
      let prev_idx = indices[i - 1]
      let next_idx = indices[i + 1]
      let prev_bc = types[prev_idx]
      let next_bc = types[next_idx]
      if bc is ES && prev_bc is EN && next_bc is EN {
        types[idx] = BidiClass::EN
      } else if bc is CS {
        if prev_bc is EN && next_bc is EN {
          types[idx] = BidiClass::EN
        } else if prev_bc is AN && next_bc is AN {
          types[idx] = BidiClass::AN
        }
      }
    }
  }

  // W5: ET adjacent to EN becomes EN
  // A sequence of ETs adjacent to EN becomes EN.
  // First, find all ENs and expand to adjacent ETs
  for i = 0; i < indices.length(); i = i + 1 {
    let idx = indices[i]
    if types[idx] is EN {
      // Look backward for ETs
      let mut j = i - 1
      while j >= 0 && types[indices[j]] is ET {
        types[indices[j]] = BidiClass::EN
        j -= 1
      }
      // Look forward for ETs
      j = i + 1
      while j < indices.length() && types[indices[j]] is ET {
        types[indices[j]] = BidiClass::EN
        j += 1
      }
    }
  }

  // W6: ES, ET, CS become ON
  // All remaining ES, ET, and CS characters become ON.
  for idx in indices {
    let bc = types[idx]
    if bc is ES || bc is ET || bc is CS {
      types[idx] = BidiClass::ON
    }
  }

  // W7: EN becomes L when sos is L or after L
  // W3 has already changed AL to R, so only L and R need tracking here.
  last_strong = seq.sos
  for idx in indices {
    match types[idx] {
      L => last_strong = BidiClass::L
      R => last_strong = BidiClass::R
      EN => if last_strong is L { types[idx] = BidiClass::L }
      _ => ()
    }
  }
}

///|
/// Re-resolve NSM after bracket pairing so combining marks follow
/// brackets that were retyped by N0.
fn resolve_nsm_after_brackets(
  types : Array[BidiClass],
  original_classes : Array[BidiClass],
  seq : IsolatingRunSequence,
) -> Unit {
  let indices = seq.indices
  if indices.length() == 0 {
    return
  }

  let mut prev_type = seq.sos
  for idx in indices {
    if original_classes[idx] is NSM && types[idx] is ON {
      if prev_type.is_isolate_initiator() || prev_type is PDI {
        types[idx] = BidiClass::ON
      } else {
        types[idx] = prev_type
      }
    }

    if !(types[idx] is BN) {
      prev_type = types[idx]
    }
  }
}
