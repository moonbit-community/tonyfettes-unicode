///|
/// Unicode Bidirectional Algorithm (UAX #9)
///
/// This module implements the Unicode Bidirectional Algorithm for
/// determining the display order of text containing both left-to-right
/// and right-to-left characters.

///|
/// Direction of text
#derive(Eq)
pub(all) enum Direction {
  LTR // Left-to-Right (base level 0)
  RTL // Right-to-Left (base level 1)
}

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
    // This range is already `0 <= offset < end <= length`, which is all the
    // old bounds-checked view verified: a raw view needs no clamping, and it
    // also keeps a lone surrogate that a block boundary may land on.
    for c in text.unsafe_view(start=offset, end~) {
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
/// Bitmasks over BidiClass ordinals (0..22) accumulated in a single scan.
const RtlClassMask : Int32 = (1 << 1) | (1 << 2) | (1 << 6) // R | AL | AN

///|
const NsmClassBit : Int32 = 1 << 8 // NSM

///|
const BnClassBit : Int32 = 1 << 9 // BN

///|
const SeparatorClassMask : Int32 = (1 << 10) | (1 << 11) // B | S

///|
const L1ClassMask : Int32 = (1 << 10) |
  (1 << 11) |
  (1 << 12) |
  (1 << 19) |
  (1 << 20) |
  (1 << 21) |
  (1 << 22) // B | S | WS | LRI | RLI | FSI | PDI

///|
const ExplicitClassMask : Int32 = (1 << 14) |
  (1 << 15) |
  (1 << 16) |
  (1 << 17) |
  (1 << 18) |
  (1 << 19) |
  (1 << 20) |
  (1 << 21) |
  (1 << 22) // LRE..PDI

///|
/// Both open (bit 6) and close (bit 7) bracket tags present in lookup_bidi_entry.
const BracketBothMask : Int32 = 192

///|
/// Process text according to the Unicode Bidirectional Algorithm
/// If `direction` is omitted, infer it from the first strong character.
/// Returns a BidiParagraph with resolved embedding levels for each character
pub fn process(text : String, direction? : Direction) -> BidiParagraph {
  match direction {
    Some(dir) => process_internal(text, dir.level(), auto_level=false)
    None => process_internal(text, 0, auto_level=true)
  }
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
  process_internal(text, base_level, auto_level=false)
}

///|
fn process_internal(
  text : String,
  initial_base_level : Int32,
  auto_level~ : Bool,
) -> BidiParagraph {
  // Single pass: decode chars, look up BidiClass + bracket tags,
  // accumulate class bitmask, and fuse P2/P3 base-level detection when auto_level.
  let chars : Array[Char] = Array(capacity=text.length())
  let original_classes : Array[BidiClass] = Array(capacity=text.length())
  let mut class_mask = 0
  let mut entry_or = 0
  let mut need_base_level = auto_level
  let mut base_level = initial_base_level
  let mut p2_isolate_count = 0
  for c in text {
    let entry = lookup_bidi_entry(c)
    let code = entry & 31
    let bc = bidi_from_code(code)
    entry_or = entry_or | entry
    class_mask = class_mask | (1 << code)
    if need_base_level {
      match bc {
        LRI | RLI | FSI => p2_isolate_count += 1
        PDI => if p2_isolate_count > 0 { p2_isolate_count -= 1 }
        AL | R =>
          if p2_isolate_count == 0 {
            base_level = 1
            need_base_level = false
          }
        L =>
          if p2_isolate_count == 0 {
            base_level = 0
            need_base_level = false
          }
        _ => ()
      }
    }
    chars.push(c)
    original_classes.push(bc)
  }
  let has_explicit = (class_mask & ExplicitClassMask) != 0
  let has_rtl = (class_mask & RtlClassMask) != 0
  let has_bn = (class_mask & BnClassBit) != 0
  if base_level == 0 && !has_explicit && !has_rtl {
    // With no R, AL, AN or explicit formatting character in a left-to-right
    // paragraph, W1-W7 and N0-N2 resolve every type but BN to L (the most
    // recent strong type, sos and eos are all L), so every level stays 0.
    let resolved_classes : Array[BidiClass] = if has_bn {
      let arr : Array[BidiClass] = Array(capacity=original_classes.length())
      for bc in original_classes {
        arr.push(if bc is BN { BN } else { L })
      }
      arr
    } else {
      Array::make(chars.length(), BidiClass::L)
    }
    let levels : Array[Int32] = Array::make(chars.length(), 0)
    return { chars, original_classes, resolved_classes, levels, base_level, }
  }

  // Make a copy for resolution
  let resolved_classes = original_classes.copy()

  // Allocate levels array
  let levels : Array[Int32] = Array::make(chars.length(), base_level)
  let has_nsm = (class_mask & NsmClassBit) != 0
  let sequences = if has_explicit {
    // X1-X10: Process explicit formatting characters
    let isolate_pairs = process_explicit(resolved_classes, levels, base_level)

    // Align NSM levels with the previous non-X9 character.
    if has_nsm {
      adjust_nsm_levels(original_classes, levels)
    }

    // Compute isolating run sequences
    compute_isolating_run_sequences(
      resolved_classes, levels, original_classes, base_level, isolate_pairs,
    )
  } else {
    // Without embeddings, overrides or isolates, X1-X8 leave every type as
    // it is and every character at the paragraph level, so the paragraph is
    // one level run.
    paragraph_run_sequence(resolved_classes, base_level, has_bn~)
  }
  let has_brackets = (entry_or & BracketBothMask) == BracketBothMask
  let bracket_scratch = if has_brackets {
    Some(BracketScratch::new())
  } else {
    None
  }
  for seq in sequences {
    // W1-W7: Resolve weak types
    resolve_weak_types(resolved_classes, levels, seq)

    // N0: Resolve bracket pairs, and the NSMs that follow a changed bracket
    if bracket_scratch is Some(scratch) {
      resolve_bracket_pairs(
        scratch,
        chars,
        resolved_classes,
        original_classes,
        seq,
        has_nsm~,
      )
    }

    // N1-N2: Resolve neutral types
    resolve_neutral_types(resolved_classes, levels, seq)
  }

  // I1-I2: Apply implicit levels
  apply_implicit_levels(resolved_classes, levels)

  // L1: Reset whitespace and separator levels
  if (class_mask & L1ClassMask) != 0 {
    reset_whitespace_levels(
      original_classes,
      levels,
      base_level,
      has_separator=(class_mask & SeparatorClassMask) != 0,
    )
  }
  { chars, original_classes, resolved_classes, levels, base_level, }
}

///|
/// Reorder text for display according to resolved levels
/// Returns array of character indices in visual order
/// X9-removed characters (LRE, RLE, LRO, RLO, PDF, BN) are excluded
pub fn reorder(para : BidiParagraph) -> Array[Int32] {
  reorder_indices(para.original_classes, para.levels)
}

///|
/// Reorder text and return the visually-ordered string
pub fn reorder_string(para : BidiParagraph) -> String {
  reorder_to_string(
    para.chars,
    para.original_classes,
    para.levels,
    para.base_level,
  )
}

///|
/// Get the mirrored glyph for a character if in RTL context
pub fn get_mirrored(c : Char, level : Int32) -> Char {
  if (level & 1) == 1 && has_mirroring_glyph(c) {
    mirror_char(c)
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
