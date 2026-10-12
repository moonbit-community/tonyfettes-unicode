///|
/// X1-X10: Explicit Formatting Character Processing
///
/// This handles embeddings (LRE, RLE, LRO, RLO, PDF) and
/// isolates (LRI, RLI, FSI, PDI).

///|
/// Directional status stack entry
priv struct DirectionalStatus {
  level : Int32
  override_status : BidiClass // L, R, or ON (neutral = no override)
  isolate_status : Bool
}

///|
/// Process explicit formatting characters (X1-X10)
/// Returns list of (isolate_initiator_index, pdi_index) pairs
fn process_explicit(
  types : Array[BidiClass],
  levels : Array[Int32],
  paragraph_level : Int32,
) -> Array[(Int32, Int32)] {
  // X1: Initialize directional status stack
  let stack : Array[DirectionalStatus] = [
    {
      level: paragraph_level,
      override_status: BidiClass::ON,
      isolate_status: false,
    },
  ]
  let mut overflow_isolate_count = 0
  let mut overflow_embedding_count = 0
  let mut valid_isolate_count = 0

  // Track isolate pairs for later run sequence computation
  let isolate_pairs : Array[(Int32, Int32)] = []
  let isolate_stack : Array[Int32] = [] // Stack of isolate initiator indices
  for i = 0; i < types.length(); i = i + 1 {
    let bc = types[i]
    match bc {
      // X2: RLE - Right-to-Left Embedding
      RLE => {
        let new_level = next_odd_level(stack[stack.length() - 1].level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 {
          stack.push({
            level: new_level,
            override_status: BidiClass::ON,
            isolate_status: false,
          })
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        // X9: Remove from output (set level, keep type for X9 removal)
        levels[i] = stack[stack.length() - 1].level
        types[i] = BidiClass::BN
      }

      // X3: LRE - Left-to-Right Embedding
      LRE => {
        let new_level = next_even_level(stack[stack.length() - 1].level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 {
          stack.push({
            level: new_level,
            override_status: BidiClass::ON,
            isolate_status: false,
          })
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        levels[i] = stack[stack.length() - 1].level
        types[i] = BidiClass::BN
      }

      // X4: RLO - Right-to-Left Override
      RLO => {
        let new_level = next_odd_level(stack[stack.length() - 1].level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 {
          stack.push({
            level: new_level,
            override_status: BidiClass::R,
            isolate_status: false,
          })
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        levels[i] = stack[stack.length() - 1].level
        types[i] = BidiClass::BN
      }

      // X5: LRO - Left-to-Right Override
      LRO => {
        let new_level = next_even_level(stack[stack.length() - 1].level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 {
          stack.push({
            level: new_level,
            override_status: BidiClass::L,
            isolate_status: false,
          })
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        levels[i] = stack[stack.length() - 1].level
        types[i] = BidiClass::BN
      }

      // X5a: RLI - Right-to-Left Isolate
      RLI => {
        levels[i] = stack[stack.length() - 1].level
        let ovr = stack[stack.length() - 1].override_status
        if !(ovr is ON) {
          types[i] = ovr
        }
        let new_level = next_odd_level(stack[stack.length() - 1].level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 {
          valid_isolate_count += 1
          isolate_stack.push(i)
          stack.push({
            level: new_level,
            override_status: BidiClass::ON,
            isolate_status: true,
          })
        } else {
          overflow_isolate_count += 1
        }
      }

      // X5b: LRI - Left-to-Right Isolate
      LRI => {
        levels[i] = stack[stack.length() - 1].level
        let ovr = stack[stack.length() - 1].override_status
        if !(ovr is ON) {
          types[i] = ovr
        }
        let new_level = next_even_level(stack[stack.length() - 1].level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 {
          valid_isolate_count += 1
          isolate_stack.push(i)
          stack.push({
            level: new_level,
            override_status: BidiClass::ON,
            isolate_status: true,
          })
        } else {
          overflow_isolate_count += 1
        }
      }

      // X5c: FSI - First Strong Isolate
      FSI => {
        levels[i] = stack[stack.length() - 1].level
        let ovr = stack[stack.length() - 1].override_status
        if !(ovr is ON) {
          types[i] = ovr
        }
        // Determine direction of isolate content
        let isolate_dir = determine_isolate_direction(types, i + 1)
        let new_level = if isolate_dir is RTL {
          next_odd_level(stack[stack.length() - 1].level)
        } else {
          next_even_level(stack[stack.length() - 1].level)
        }
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 {
          valid_isolate_count += 1
          isolate_stack.push(i)
          stack.push({
            level: new_level,
            override_status: BidiClass::ON,
            isolate_status: true,
          })
        } else {
          overflow_isolate_count += 1
        }
      }

      // X6a: PDI - Pop Directional Isolate
      PDI => {
        if overflow_isolate_count > 0 {
          overflow_isolate_count -= 1
        } else if valid_isolate_count > 0 {
          overflow_embedding_count = 0
          // Pop until isolate
          while stack.length() > 1 && !stack[stack.length() - 1].isolate_status {
            let _ = stack.pop()
          }
          // Pop the isolate entry itself
          if stack.length() > 1 {
            let _ = stack.pop()
          }
          valid_isolate_count -= 1
          // Record isolate pair
          if isolate_stack.length() > 0 {
            match isolate_stack.pop() {
              Some(start) => isolate_pairs.push((start, i))
              None => ()
            }
          }
        }
        levels[i] = stack[stack.length() - 1].level
        let ovr = stack[stack.length() - 1].override_status
        if !(ovr is ON) {
          types[i] = ovr
        }
      }

      // X7: PDF - Pop Directional Formatting
      PDF => {
        if overflow_isolate_count > 0 {
          // Do nothing
        } else if overflow_embedding_count > 0 {
          overflow_embedding_count -= 1
        } else if stack.length() >= 2 &&
          !stack[stack.length() - 1].isolate_status {
          let _ = stack.pop()
        }
        levels[i] = stack[stack.length() - 1].level
        types[i] = BidiClass::BN
      }

      // X6: For all other types
      _ => {
        levels[i] = stack[stack.length() - 1].level
        let ovr = stack[stack.length() - 1].override_status
        if !(ovr is ON) && !(bc is BN) {
          types[i] = ovr
        }
      }
    }
  }
  isolate_pairs
}

///|
/// Ensure NSM levels follow the last non-X9 character.
fn adjust_nsm_levels(
  original_classes : Array[BidiClass],
  levels : Array[Int32],
) -> Unit {
  let mut last_idx = -1
  let mut saw_explicit = false
  for i = 0; i < original_classes.length(); i = i + 1 {
    let bc = original_classes[i]
    if bc is LRE ||
      bc is LRO ||
      bc is RLE ||
      bc is RLO ||
      bc is PDF ||
      bc.is_isolate_initiator() {
      saw_explicit = true
    }
    if bc is NSM && last_idx >= 0 {
      let last_bc = original_classes[last_idx]
      if !last_bc.is_isolate_initiator() && !(last_bc is PDI) && !saw_explicit {
        levels[i] = levels[last_idx]
      }
    }
    if !bc.is_x9_removed() {
      last_idx = i
      saw_explicit = false
    }
  }
}

///|
/// Determine direction for FSI by finding first strong character
fn determine_isolate_direction(
  types : Array[BidiClass],
  start : Int32,
) -> Direction {
  let mut isolate_count = 0
  for i = start; i < types.length(); i = i + 1 {
    let bc = types[i]
    if bc.is_isolate_initiator() {
      isolate_count += 1
    } else if bc is PDI {
      if isolate_count > 0 {
        isolate_count -= 1
      } else {
        // End of our isolate content
        break
      }
    } else if isolate_count == 0 {
      match bc {
        R | AL => return RTL
        L => return LTR
        _ => ()
      }
    }
  }
  LTR // Default
}

///|
/// Get next odd level >= current
fn next_odd_level(level : Int32) -> Int32 {
  (level + 1) | 1
}

///|
/// Get next even level >= current
fn next_even_level(level : Int32) -> Int32 {
  (level + 2) & (1).lnot()
}

///|
/// Isolating run sequence - indices of characters that form a sequence
priv struct IsolatingRunSequence {
  indices : Array[Int32] // Character indices in this sequence
  sos : BidiClass // Start-of-sequence type (L or R)
  eos : BidiClass // End-of-sequence type (L or R)
  level : Int32 // Embedding level of the sequence
}

///|
/// Compute isolating run sequences (X10)
fn compute_isolating_run_sequences(
  types : Array[BidiClass],
  levels : Array[Int32],
  original_classes : Array[BidiClass],
  paragraph_level : Int32,
  isolate_pairs : Array[(Int32, Int32)],
) -> Array[IsolatingRunSequence] {
  let len = types.length()
  if len == 0 {
    return []
  }

  // Build a map from isolate initiator to PDI
  let pdi_of_isolate : Array[Int32] = Array::make(len, -1)
  for pair in isolate_pairs {
    pdi_of_isolate[pair.0] = pair.1
  }
  let sequences : Array[IsolatingRunSequence] = []
  let processed : Array[Bool] = Array::make(len, false)

  // Find level runs and connect them via isolate pairs
  for i = 0; i < len; i = i + 1 {
    if processed[i] {
      continue
    }

    // Skip BN and explicit formatting characters
    let bc = types[i]
    if bc is BN {
      processed[i] = true
      continue
    }

    // Start a new isolating run sequence
    let indices : Array[Int32] = []
    let seq_level = levels[i]
    let mut current = i

    // Follow the run, linking through isolate pairs
    while current < len {
      // Add all characters at the same level in this run
      while current < len {
        if processed[current] {
          current += 1
          continue
        }
        if types[current] is BN {
          processed[current] = true
          current += 1
          continue
        }
        if levels[current] != seq_level {
          break
        }
        indices.push(current)
        processed[current] = true
        current += 1
      }

      // Check if last added character is an isolate initiator
      if indices.length() > 0 {
        let last = indices[indices.length() - 1]
        let pdi_idx = pdi_of_isolate[last]
        if pdi_idx < 0 {
          break
        }
        // Continue sequence at the matching PDI run (include the PDI).
        current = pdi_idx
      } else {
        break
      }
    }
    if indices.length() == 0 {
      continue
    }

    // Compute sos and eos
    let first_idx = indices[0]
    let last_idx = indices[indices.length() - 1]

    // sos: higher of level before sequence and sequence level
    let level_before = if first_idx == 0 {
      paragraph_level
    } else {
      // Find previous character level (skip BN)
      let mut prev = first_idx - 1
      while prev > 0 && types[prev] is BN {
        prev -= 1
      }
      if prev < 0 || types[prev] is BN {
        paragraph_level
      } else if original_classes[prev] is B {
        paragraph_level
      } else {
        levels[prev]
      }
    }
    let sos_level = @cmp.maximum(level_before, seq_level)
    let sos : BidiClass = if sos_level % 2 == 0 {
      BidiClass::L
    } else {
      BidiClass::R
    }

    // eos: higher of level after sequence and sequence level
    let level_after = if last_idx >= len - 1 {
      paragraph_level
    } else if original_classes[last_idx] is B {
      paragraph_level
    } else {
      // Find next character level (skip BN)
      let mut next = last_idx + 1
      while next < len && types[next] is BN {
        next += 1
      }
      // Check if this is an isolate initiator - look for matching PDI
      let last_type = types[last_idx]
      if last_type.is_isolate_initiator() {
        let pdi_idx = pdi_of_isolate[last_idx]
        if pdi_idx < 0 {
          paragraph_level
        } else {
          levels[pdi_idx]
        }
      } else if next >= len {
        paragraph_level
      } else if original_classes[next] is B {
        paragraph_level
      } else {
        levels[next]
      }
    }
    let eos_level = @cmp.maximum(level_after, seq_level)
    let eos : BidiClass = if eos_level % 2 == 0 {
      BidiClass::L
    } else {
      BidiClass::R
    }
    sequences.push({ indices, sos, eos, level: seq_level, })
  }
  sequences
}

///|
/// The isolating run sequences of a paragraph without explicit formatting
/// characters: one sequence at the paragraph level holding every character
/// that X9 keeps, with sos and eos given by that level.
fn paragraph_run_sequence(
  types : Array[BidiClass],
  paragraph_level : Int32,
) -> Array[IsolatingRunSequence] {
  let indices : Array[Int32] = Array(capacity=types.length())
  for i, bc in types {
    if !(bc is BN) {
      indices.push(i)
    }
  }
  if indices.length() == 0 {
    return []
  }
  let direction : BidiClass = if paragraph_level % 2 == 0 {
    BidiClass::L
  } else {
    BidiClass::R
  }
  [{ indices, sos: direction, eos: direction, level: paragraph_level, }]
}
