///|
/// L1-L4: Reordering Rules
///
/// These rules reorder characters for display based on resolved levels.

///|
/// L1: Reset levels of segment/paragraph separators and whitespace
fn reset_whitespace_levels(
  original_classes : Array[@bidi_data.BidiClass],
  levels : Array[Int],
  paragraph_level : Int,
) -> Unit {
  let len = levels.length()

  // L1: Reset levels for:
  // - Segment separators (S)
  // - Paragraph separators (B)
  // - Any whitespace (WS) or isolate formatting characters preceding S or B
  // - Any whitespace or isolate formatting at the end of the line

  // First, handle trailing whitespace
  let mut i = len - 1
  while i >= 0 {
    let bc = original_classes[i]
    match bc {
      S | B => {
        levels[i] = paragraph_level
        // Reset preceding whitespace and isolates
        let mut j = i - 1
        while j >= 0 {
          let prev_bc = original_classes[j]
          match prev_bc {
            WS | LRI | RLI | FSI | PDI => {
              levels[j] = paragraph_level
              j -= 1
            }
            _ => break
          }
        }
        i = j
      }
      WS | LRI | RLI | FSI | PDI => {
        // Trailing whitespace at end of paragraph
        levels[i] = paragraph_level
        i -= 1
      }
      _ => break
    }
  }

  // Also reset any S or B in the middle
  for k = 0; k < len; k = k + 1 {
    let bc = original_classes[k]
    if bc == @bidi_data.BidiClass::S || bc == @bidi_data.BidiClass::B {
      levels[k] = paragraph_level
    }
  }
}

///|
/// L2: Reorder text based on levels
/// Returns indices in visual order
fn apply_reordering(levels : Array[Int], paragraph_level : Int) -> Array[Int] {
  let len = levels.length()
  if len == 0 {
    return []
  }

  // Initialize result with logical order
  let result : Array[Int] = Array::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    result[i] = i
  }

  // Find the maximum level
  let mut max_level = paragraph_level
  for level in levels {
    if level > max_level {
      max_level = level
    }
  }

  // L2: From the highest level to the lowest odd level, reverse each
  // contiguous sequence of characters at that level or higher
  let mut level = max_level
  while level >= 1 {
    let mut i = 0
    while i < len {
      if levels[result[i]] >= level {
        // Found start of sequence to reverse
        let start = i
        while i < len && levels[result[i]] >= level {
          i += 1
        }
        // Reverse from start to i-1
        reverse_range(result, start, i - 1)
      } else {
        i += 1
      }
    }
    level -= 1
  }
  result
}

///|
/// Reverse a range in an array
fn reverse_range(arr : Array[Int], start : Int, end : Int) -> Unit {
  let mut lo = start
  let mut hi = end
  while lo < hi {
    let tmp = arr[lo]
    arr[lo] = arr[hi]
    arr[hi] = tmp
    lo += 1
    hi -= 1
  }
}
