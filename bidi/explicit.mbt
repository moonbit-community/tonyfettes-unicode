///|
/// X1-X10: Explicit Formatting Character Processing
///
/// This handles embeddings (LRE, RLE, LRO, RLO, PDF) and
/// isolates (LRI, RLI, FSI, PDI).

///|
/// Pack a directional status stack entry into a single Int32:
/// bits 0..7 = level (0..125), bits 8..12 = override BidiClass ordinal, bit 16 = isolate_status.
fn pack_status(level : Int32, ovr : BidiClass, isolate : Bool) -> Int32 {
  let ovr_code = match ovr {
    L => 0
    R => 1
    _ => 13
  }
  level | (ovr_code << 8) | (if isolate { 0x10000 } else { 0 })
}

///|
fn unpack_level(entry : Int32) -> Int32 {
  entry & 0xFF
}

///|
fn unpack_override(entry : Int32) -> BidiClass {
  bidi_from_code((entry >> 8) & 31)
}

///|
fn unpack_isolate(entry : Int32) -> Bool {
  (entry & 0x10000) != 0
}

///|
/// Process explicit formatting characters (X1-X10)
/// Returns list of (isolate_initiator_index, pdi_index) pairs
fn process_explicit(
  types : Array[BidiClass],
  levels : Array[Int32],
  paragraph_level : Int32,
) -> Array[(Int32, Int32)] {
  // X1: Initialize directional status stack (max depth is 125, so at most 126 entries)
  let stack : FixedArray[Int32] = FixedArray::make(126, 0)
  let mut cur_level = paragraph_level
  let mut cur_override = BidiClass::ON
  let mut cur_isolate = false
  let mut stack_len = 1
  stack.unsafe_set(0, pack_status(cur_level, cur_override, false))
  let mut overflow_isolate_count = 0
  let mut overflow_embedding_count = 0
  let mut valid_isolate_count = 0

  // Track isolate pairs for later run sequence computation
  let isolate_pairs : Array[(Int32, Int32)] = []
  let isolate_stack : Array[Int32] = [] // Stack of isolate initiator indices
  let len = types.length()
  for i in 0..<len {
    let bc = types.unsafe_get(i)
    match bc {
      // X2: RLE - Right-to-Left Embedding
      RLE => {
        let new_level = next_odd_level(cur_level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 &&
          stack_len < 126 {
          cur_level = new_level
          cur_override = BidiClass::ON
          cur_isolate = false
          stack.unsafe_set(
            stack_len,
            pack_status(cur_level, BidiClass::ON, false),
          )
          stack_len += 1
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        // X9: Remove from output (set level, keep type for X9 removal)
        levels.unsafe_set(i, cur_level)
        types.unsafe_set(i, BidiClass::BN)
      }

      // X3: LRE - Left-to-Right Embedding
      LRE => {
        let new_level = next_even_level(cur_level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 &&
          stack_len < 126 {
          cur_level = new_level
          cur_override = BidiClass::ON
          cur_isolate = false
          stack.unsafe_set(
            stack_len,
            pack_status(cur_level, BidiClass::ON, false),
          )
          stack_len += 1
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        levels.unsafe_set(i, cur_level)
        types.unsafe_set(i, BidiClass::BN)
      }

      // X4: RLO - Right-to-Left Override
      RLO => {
        let new_level = next_odd_level(cur_level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 &&
          stack_len < 126 {
          cur_level = new_level
          cur_override = BidiClass::R
          cur_isolate = false
          stack.unsafe_set(
            stack_len,
            pack_status(cur_level, BidiClass::R, false),
          )
          stack_len += 1
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        levels.unsafe_set(i, cur_level)
        types.unsafe_set(i, BidiClass::BN)
      }

      // X5: LRO - Left-to-Right Override
      LRO => {
        let new_level = next_even_level(cur_level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 &&
          stack_len < 126 {
          cur_level = new_level
          cur_override = BidiClass::L
          cur_isolate = false
          stack.unsafe_set(
            stack_len,
            pack_status(cur_level, BidiClass::L, false),
          )
          stack_len += 1
        } else if overflow_isolate_count == 0 {
          overflow_embedding_count += 1
        }
        levels.unsafe_set(i, cur_level)
        types.unsafe_set(i, BidiClass::BN)
      }

      // X5a: RLI - Right-to-Left Isolate
      RLI => {
        levels.unsafe_set(i, cur_level)
        if !(cur_override is ON) {
          types.unsafe_set(i, cur_override)
        }
        let new_level = next_odd_level(cur_level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 &&
          stack_len < 126 {
          valid_isolate_count += 1
          isolate_stack.push(i)
          cur_level = new_level
          cur_override = BidiClass::ON
          cur_isolate = true
          stack.unsafe_set(
            stack_len,
            pack_status(cur_level, BidiClass::ON, true),
          )
          stack_len += 1
        } else {
          overflow_isolate_count += 1
        }
      }

      // X5b: LRI - Left-to-Right Isolate
      LRI => {
        levels.unsafe_set(i, cur_level)
        if !(cur_override is ON) {
          types.unsafe_set(i, cur_override)
        }
        let new_level = next_even_level(cur_level)
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 &&
          stack_len < 126 {
          valid_isolate_count += 1
          isolate_stack.push(i)
          cur_level = new_level
          cur_override = BidiClass::ON
          cur_isolate = true
          stack.unsafe_set(
            stack_len,
            pack_status(cur_level, BidiClass::ON, true),
          )
          stack_len += 1
        } else {
          overflow_isolate_count += 1
        }
      }

      // X5c: FSI - First Strong Isolate
      FSI => {
        levels.unsafe_set(i, cur_level)
        if !(cur_override is ON) {
          types.unsafe_set(i, cur_override)
        }
        // Determine direction of isolate content
        let isolate_dir = determine_isolate_direction(types, i + 1)
        let new_level = if isolate_dir is RTL {
          next_odd_level(cur_level)
        } else {
          next_even_level(cur_level)
        }
        if new_level <= max_depth &&
          overflow_isolate_count == 0 &&
          overflow_embedding_count == 0 &&
          stack_len < 126 {
          valid_isolate_count += 1
          isolate_stack.push(i)
          cur_level = new_level
          cur_override = BidiClass::ON
          cur_isolate = true
          stack.unsafe_set(
            stack_len,
            pack_status(cur_level, BidiClass::ON, true),
          )
          stack_len += 1
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
          while stack_len > 1 && !cur_isolate {
            stack_len -= 1
            cur_isolate = unpack_isolate(stack.unsafe_get(stack_len - 1))
          }
          // Pop the isolate entry itself
          if stack_len > 1 {
            stack_len -= 1
          }
          let top = stack.unsafe_get(stack_len - 1)
          cur_level = unpack_level(top)
          cur_override = unpack_override(top)
          cur_isolate = unpack_isolate(top)
          valid_isolate_count -= 1
          // Record isolate pair
          if isolate_stack.pop() is Some(start) {
            isolate_pairs.push((start, i))
          }
        }
        levels.unsafe_set(i, cur_level)
        if !(cur_override is ON) {
          types.unsafe_set(i, cur_override)
        }
      }

      // X7: PDF - Pop Directional Formatting
      PDF => {
        if overflow_isolate_count > 0 {
          // Do nothing
        } else if overflow_embedding_count > 0 {
          overflow_embedding_count -= 1
        } else if stack_len >= 2 && !cur_isolate {
          stack_len -= 1
          let top = stack.unsafe_get(stack_len - 1)
          cur_level = unpack_level(top)
          cur_override = unpack_override(top)
          cur_isolate = unpack_isolate(top)
        }
        levels.unsafe_set(i, cur_level)
        types.unsafe_set(i, BidiClass::BN)
      }

      // X6: For all other types
      _ => {
        levels.unsafe_set(i, cur_level)
        if !(cur_override is ON) && !(bc is BN) {
          types.unsafe_set(i, cur_override)
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
  for i, bc in original_classes {
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
  for i in start..<types.length() {
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

  // Build a map from isolate initiator to PDI only if isolate pairs exist.
  let has_isolate_pairs = !isolate_pairs.is_empty()
  let pdi_of_isolate : FixedArray[Int32] = if has_isolate_pairs {
    let map = FixedArray::make(len, -1)
    for pair in isolate_pairs {
      map.unsafe_set(pair.0, pair.1)
    }
    map
  } else {
    FixedArray::make(0, -1)
  }
  let sequences : Array[IsolatingRunSequence] = []
  let processed : FixedArray[Bool] = FixedArray::make(len, false)

  // Find level runs and connect them via isolate pairs
  for i in 0..<len {
    if processed.unsafe_get(i) {
      continue
    }

    // Skip BN and explicit formatting characters
    let bc = types.unsafe_get(i)
    if bc is BN {
      processed.unsafe_set(i, true)
      continue
    }

    // Start a new isolating run sequence
    let indices : Array[Int32] = Array(capacity=16)
    let seq_level = levels.unsafe_get(i)
    let mut current = i

    // Follow the run, linking through isolate pairs
    while current < len {
      // Add all characters at the same level in this run
      while current < len {
        if processed.unsafe_get(current) {
          current += 1
          continue
        }
        if types.unsafe_get(current) is BN {
          processed.unsafe_set(current, true)
          current += 1
          continue
        }
        if levels.unsafe_get(current) != seq_level {
          break
        }
        indices.push(current)
        processed.unsafe_set(current, true)
        current += 1
      }

      // Check if last added character is an isolate initiator
      if has_isolate_pairs && indices.length() > 0 {
        let last = indices.unsafe_get(indices.length() - 1)
        let pdi_idx = pdi_of_isolate.unsafe_get(last)
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
    let first_idx = indices.unsafe_get(0)
    let last_idx = indices.unsafe_get(indices.length() - 1)

    // sos: higher of level before sequence and sequence level
    let level_before = if first_idx == 0 {
      paragraph_level
    } else {
      // Find previous character level (skip BN)
      let mut prev = first_idx - 1
      while prev > 0 && types.unsafe_get(prev) is BN {
        prev -= 1
      }
      if prev < 0 || types.unsafe_get(prev) is BN {
        paragraph_level
      } else if original_classes.unsafe_get(prev) is B {
        paragraph_level
      } else {
        levels.unsafe_get(prev)
      }
    }
    let sos_level = @cmp.maximum(level_before, seq_level)
    let sos : BidiClass = if (sos_level & 1) == 0 {
      BidiClass::L
    } else {
      BidiClass::R
    }

    // eos: higher of level after sequence and sequence level
    let level_after = if last_idx >= len - 1 {
      paragraph_level
    } else if original_classes.unsafe_get(last_idx) is B {
      paragraph_level
    } else {
      // Check if this is an isolate initiator - look for matching PDI
      let last_type = types.unsafe_get(last_idx)
      if last_type.is_isolate_initiator() {
        let pdi_idx = if has_isolate_pairs {
          pdi_of_isolate.unsafe_get(last_idx)
        } else {
          -1
        }
        if pdi_idx < 0 {
          paragraph_level
        } else {
          levels.unsafe_get(pdi_idx)
        }
      } else {
        // Find next character level (skip BN)
        let mut next = last_idx + 1
        while next < len && types.unsafe_get(next) is BN {
          next += 1
        }
        if next >= len {
          paragraph_level
        } else if original_classes.unsafe_get(next) is B {
          paragraph_level
        } else {
          levels.unsafe_get(next)
        }
      }
    }
    let eos_level = @cmp.maximum(level_after, seq_level)
    let eos : BidiClass = if (eos_level & 1) == 0 {
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
  has_bn~ : Bool,
) -> Array[IsolatingRunSequence] {
  let len = types.length()
  if len == 0 {
    return []
  }
  let indices : Array[Int32] = if has_bn {
    let arr : Array[Int32] = Array(capacity=len)
    for i, bc in types {
      if !(bc is BN) {
        arr.push(i)
      }
    }
    if arr.length() == 0 {
      return []
    }
    arr
  } else {
    Array::makei(len, fn(i) { i })
  }
  let direction : BidiClass = if (paragraph_level & 1) == 0 {
    BidiClass::L
  } else {
    BidiClass::R
  }
  [{ indices, sos: direction, eos: direction, level: paragraph_level, }]
}
