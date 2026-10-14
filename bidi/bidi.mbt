///|
/// Unicode Bidirectional Algorithm (UAX #9)
///
/// This module implements the Unicode Bidirectional Algorithm for
/// determining the display order of text containing both left-to-right
/// and right-to-left characters.

///|
/// Direction of text
pub(all) enum Direction {
  LTR // Left-to-Right (base level 0)
  RTL // Right-to-Left (base level 1)
} derive(Eq)

///|
pub extend Direction with Eq::{not_equal, equal}

///|
pub extend Direction with Show::{to_string, output}

///|
pub impl Show for Direction with fn output(self, logger) {
  match self {
    LTR => logger.write_string("LTR")
    RTL => logger.write_string("RTL")
  }
}

///|
/// Result of bidi processing - a paragraph with resolved levels
pub(all) struct BidiParagraph {
  /// Original characters
  chars : Array[Char]
  /// Original Bidi classes (before resolution)
  original_classes : Array[BidiClass]
  /// Resolved Bidi classes (after W and N rules)
  resolved_classes : Array[BidiClass]
  /// Resolved embedding level per character (0-125)
  levels : Array[Int32]
  /// Paragraph embedding level (0 for LTR, 1 for RTL)
  base_level : Int32
}

///|
/// Maximum embedding level allowed by UAX #9
let max_depth : Int32 = 125

///|
/// Look up Bidi_Class for a character
pub fn bidi_class(c : Char) -> BidiClass {
  lookup_bidi_class(c)
}

///|
/// Detect the base direction of text (P2-P3)
/// Returns the direction of the first strong character,
/// or LTR if no strong character is found
pub fn detect_direction(text : String) -> Direction {
  let level = determine_paragraph_level(text, default_level=0)
  if level == 0 {
    LTR
  } else {
    RTL
  }
}

///|
/// Check if text requires bidi processing
/// Returns false for pure LTR text (optimization)
#cfg(not(any(target="native", target="wasm")))
pub fn requires_bidi(text : String) -> Bool {
  for c in text {
    let bc = lookup_bidi_class(c)
    if bc.is_strong_rtl() || bc.is_explicit() {
      return true
    }
  }
  false
}

///|
/// Check if text requires bidi processing
/// Returns false for pure LTR text (optimization)
#cfg(any(target="native", target="wasm"))
pub fn requires_bidi(text : String) -> Bool {
  // Once a stretch of characters has had its classes looked up, blocks of
  // eight code units are tried: a block below `LeftToRightLimit` needs no
  // lookup. The stretch starts short, so that text with an early
  // right-to-left character never reaches a block, and grows while no block
  // can be skipped, so that text above the limit pays for few tries.
  let length = text.length()
  let mut offset = 0
  let mut stretch = MinClassStretch
  while offset < length {
    let mut end = if length - offset > stretch {
      offset + stretch
    } else {
      length
    }
    if end < length &&
      text[end - 1].is_leading_surrogate() &&
      text[end].is_trailing_surrogate() {
      // Keep a surrogate pair that crosses the end of the stretch together.
      end += 1
    }
    for c in text.view(start_offset=offset, end_offset=end) {
      let bc = lookup_bidi_class(c)
      if bc.is_strong_rtl() || bc.is_explicit() {
        return true
      }
    }
    offset = skip_left_to_right_blocks(text, end, length)
    if offset > end {
      stretch = MinClassStretch
    } else if stretch < MaxClassStretch {
      stretch = 4 * stretch
    }
  }
  false
}

///|
/// Code units looked up before the first block and after a block that cannot
/// be skipped.
#cfg(any(target="native", target="wasm"))
const MinClassStretch : Int32 = 16

///|
#cfg(any(target="native", target="wasm"))
const MaxClassStretch : Int32 = 4096

///|
/// Code points below U+0590, where the Hebrew block starts, are neither
/// strongly right-to-left nor explicit formatting characters.
#cfg(any(target="native", target="wasm"))
const LeftToRightLimit : Int32 = 0x590

///|
/// Skip blocks of eight code units that are all below `LeftToRightLimit`,
/// and return the offset of the first block that is not, or that is
/// incomplete.
#cfg(any(target="native", target="wasm"))
// The SIMD operations are experimental upstream. Only this function uses
// them, so the alert is silenced here and not for the whole package.
#warnings("-alert_experimental")
fn skip_left_to_right_blocks(
  text : String,
  start : Int32,
  length : Int32,
) -> Int32 {
  let limit = @v128.i16x8_splat(LeftToRightLimit.to_uint16())
  let mut offset = start
  while offset + 8 <= length {
    // SAFETY: offset is nonnegative and offset + 8 <= length is checked above.
    let block = @v128.v128_load_i16x8(text, offset)
    if @v128.v128_any_true(@v128.i16x8_ge_u(block, limit)) {
      break
    }
    offset += 8
  }
  offset
}

///|
/// Process text according to the Unicode Bidirectional Algorithm
/// If `direction` is omitted, infer it from the first strong character.
/// Returns a BidiParagraph with resolved embedding levels for each character
pub fn process(text : String, direction? : Direction) -> BidiParagraph {
  let base_level = if direction is Some(direction) {
    direction.level()
  } else {
    determine_paragraph_level(text, default_level=0)
  }
  process_at_base_level(text, base_level)
}

///|
/// Process text with explicit base direction
/// Use when the paragraph direction is known externally
#deprecated("Use process(text, direction=direction) instead")
pub fn process_with_direction(
  text : String,
  direction : Direction,
) -> BidiParagraph {
  process(text, direction~)
}

///|
/// Process text with explicit base level
#deprecated("Use process(text, direction=LTR or RTL) instead")
pub fn process_with_base_level(
  text : String,
  base_level : Int32,
) -> BidiParagraph {
  process_at_base_level(text, base_level)
}

///|
fn process_at_base_level(text : String, base_level : Int32) -> BidiParagraph {
  // Convert to char array and get original classes
  let chars : Array[Char] = Array(capacity=text.length())
  let original_classes : Array[BidiClass] = Array(capacity=text.length())
  let mut has_explicit = false
  for c in text {
    let bc = lookup_bidi_class(c)
    if bc.is_explicit() {
      has_explicit = true
    }
    chars.push(c)
    original_classes.push(bc)
  }

  // Make a copy for resolution
  let resolved_classes = original_classes.copy()

  // Allocate levels array
  let levels : Array[Int32] = Array::make(chars.length(), base_level)
  let sequences = if has_explicit {
    // X1-X10: Process explicit formatting characters
    let isolate_pairs = process_explicit(resolved_classes, levels, base_level)

    // Align NSM levels with the previous non-X9 character.
    adjust_nsm_levels(original_classes, levels)

    // Compute isolating run sequences
    compute_isolating_run_sequences(
      resolved_classes, levels, original_classes, base_level, isolate_pairs,
    )
  } else {
    // Without embeddings, overrides or isolates, X1-X8 leave every type as
    // it is and every character at the paragraph level, so the paragraph is
    // one level run.
    paragraph_run_sequence(resolved_classes, base_level)
  }
  let bracket_scratch = BracketScratch::new()
  for seq in sequences {
    // W1-W7: Resolve weak types
    resolve_weak_types(resolved_classes, levels, seq)

    // N0: Resolve bracket pairs, and the NSMs that follow a changed bracket
    resolve_bracket_pairs(
      bracket_scratch, chars, resolved_classes, original_classes, seq,
    )

    // N1-N2: Resolve neutral types
    resolve_neutral_types(resolved_classes, levels, seq)
  }

  // I1-I2: Apply implicit levels
  apply_implicit_levels(resolved_classes, levels)

  // L1: Reset whitespace and separator levels
  reset_whitespace_levels(original_classes, levels, base_level)
  { chars, original_classes, resolved_classes, levels, base_level, }
}

///|
/// Reorder text for display according to resolved levels
/// Returns array of character indices in visual order
/// X9-removed characters (LRE, RLE, LRO, RLO, PDF, BN) are excluded
pub fn reorder(para : BidiParagraph) -> Array[Int32] {
  // X9: remove explicit formatting and BN before reordering.
  let indices : Array[Int32] = []
  for i = 0; i < para.levels.length(); i = i + 1 {
    let bc = para.original_classes[i]
    if !bc.is_x9_removed() {
      indices.push(i)
    }
  }
  apply_reordering(indices, para.levels, para.base_level)
}

///|
/// Reorder text and return the visually-ordered string
pub fn reorder_string(para : BidiParagraph) -> String {
  let order = reorder(para)
  let sb = StringBuilder()
  for i in order {
    let c = para.chars[i]
    let level = para.levels[i]
    // Apply mirroring for RTL levels (odd levels)
    if level % 2 == 1 {
      sb.write_char(@bidi_data.bidi_mirroring_glyph(c))
    } else {
      sb.write_char(c)
    }
  }
  sb.to_string()
}

///|
/// Get the mirrored glyph for a character if in RTL context
pub fn get_mirrored(c : Char, level : Int32) -> Char {
  if level % 2 == 1 {
    @bidi_data.bidi_mirroring_glyph(c)
  } else {
    c
  }
}

///|
/// Get embedding level for direction
pub fn Direction::level(self : Direction) -> Int32 {
  match self {
    LTR => 0
    RTL => 1
  }
}

///|
/// Get direction from embedding level
pub fn direction_from_level(level : Int32) -> Direction {
  if level % 2 == 0 {
    LTR
  } else {
    RTL
  }
}
