///|
/// L1-L4: Reordering Rules
///
/// These rules reorder characters for display based on resolved levels.

///|
/// Take ownership of UTF-16 code units as a string of the same length.
fn uint16_array_to_string(buffer : FixedArray[UInt16]) -> String = "%string.unsafe_from_uint16_fixedarray"

///|
#cfg(target="js")
const JsStrings : Bool = true

///|
#cfg(not(target="js"))
const JsStrings : Bool = false

///|
#cfg(target="js")
extern "js" fn code_units_prefix_to_string(
  data : FixedArray[UInt16],
  len : Int32,
) -> String =
  #|(data, len) => {
  #|  let result = "";
  #|  for (let i = 0; i < len; i += 8192) {
  #|    result += String.fromCharCode.apply(null, data.slice(i, Math.min(i + 8192, len)));
  #|  }
  #|  return result;
  #|}

///|
#cfg(not(target="js"))
fn code_units_prefix_to_string(
  data : FixedArray[UInt16],
  len : Int32,
) -> String {
  ignore(data)
  ignore(len)
  ""
}

///|
fn finalize_code_units(buf : FixedArray[UInt16], len : Int32) -> String {
  if JsStrings {
    return code_units_prefix_to_string(buf, len)
  }
  if len == buf.length() {
    uint16_array_to_string(buf)
  } else {
    let result = FixedArray::make(len, (0).to_uint16())
    result.unsafe_blit(0, buf, 0, len)
    uint16_array_to_string(result)
  }
}

///|
#inline(never)
fn grow_code_units(
  buf : FixedArray[UInt16],
  len : Int32,
  required : Int32,
) -> FixedArray[UInt16] {
  let mut capacity = if buf.length() < 16 { 16 } else { buf.length() * 2 }
  while capacity < required {
    capacity *= 2
  }
  FixedArray::make_and_blit(
    buf,
    allocate_len=capacity,
    init=(0).to_uint16(),
    len~,
  )
}

///|
/// L1: Reset levels of segment/paragraph separators and whitespace
fn reset_whitespace_levels(
  original_classes : Array[BidiClass],
  levels : Array[Int32],
  paragraph_level : Int32,
  has_separator~ : Bool,
) -> Unit {
  let len = levels.length()

  // L1: Reset levels for:
  // - Segment separators (S)
  // - Paragraph separators (B)
  // - Any whitespace (WS) or isolate formatting characters preceding S or B
  // - Any whitespace or isolate formatting at the end of the line

  // First, handle trailing whitespace
  // Note: X9-removed characters (LRE, RLE, LRO, RLO, PDF, BN) should be skipped
  // when detecting trailing whitespace, as they are conceptually removed by X9
  let mut i = len - 1
  while i >= 0 {
    let bc = original_classes[i]
    match bc {
      S | B => {
        levels[i] = paragraph_level
        // Reset preceding whitespace and isolates (skipping X9-removed chars)
        let mut j = i - 1
        while j >= 0 {
          let prev_bc = original_classes[j]
          match prev_bc {
            WS | LRI | RLI | FSI | PDI => {
              levels[j] = paragraph_level
              j -= 1
            }
            // Skip X9-removed characters
            LRE | RLE | LRO | RLO | PDF | BN => j -= 1
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
      // Skip X9-removed characters when detecting trailing whitespace
      LRE | RLE | LRO | RLO | PDF | BN => i -= 1
      _ => break
    }
  }

  // Also reset any S or B in the middle, plus preceding whitespace/isolates.
  // Skip this second full pass when the initial scan saw no S or B.
  if !has_separator {
    return
  }
  for k, bc in original_classes {
    if bc is S || bc is B {
      levels[k] = paragraph_level
      // L1.3: Reset preceding whitespace and isolate formatting characters
      // (skipping X9-removed characters)
      let mut j = k - 1
      while j >= 0 {
        let prev_bc = original_classes[j]
        match prev_bc {
          WS | LRI | RLI | FSI | PDI => {
            levels[j] = paragraph_level
            j -= 1
          }
          // Skip X9-removed characters
          LRE | RLE | LRO | RLO | PDF | BN => j -= 1
          _ => break
        }
      }
    }
  }
}

///|
/// Group contiguous non-X9 characters of equal level into flat `(start, end, level)` runs.
fn build_visual_runs(
  original_classes : Array[BidiClass],
  levels : Array[Int32],
  len : Int32,
) -> (Array[Int32], Int32, Int32, Int32) {
  let init_cap = if len < 64 { len * 3 } else if len < 512 { len } else { 512 }
  let runs : Array[Int32] = Array(capacity=init_cap)
  let mut non_x9_count = 0
  let mut min_level = 126
  let mut max_level = 0
  let mut i = 0
  while i < len {
    if original_classes.unsafe_get(i).is_x9_removed() {
      i += 1
      continue
    }
    let start = i
    let level = levels.unsafe_get(i)
    if level < min_level {
      min_level = level
    }
    if level > max_level {
      max_level = level
    }
    i += 1
    while i < len &&
          levels.unsafe_get(i) == level &&
          !original_classes.unsafe_get(i).is_x9_removed() {
      i += 1
    }
    runs.push(start)
    runs.push(i)
    runs.push(level)
    non_x9_count += i - start
  }
  (runs, non_x9_count, min_level, max_level)
}

///|
/// L2: Apply level-based reversals to the flat `(start, end, level)` run list.
fn reorder_visual_runs(
  runs : Array[Int32],
  min_level : Int32,
  max_level : Int32,
) -> Unit {
  let run_count = runs.length() / 3
  let min_odd = min_level | 1
  if run_count <= 1 || max_level < min_odd {
    return
  }
  let mut level = max_level
  while level >= min_odd {
    let mut r = 0
    while r < run_count {
      if runs.unsafe_get(r * 3 + 2) >= level {
        let start = r
        r += 1
        while r < run_count && runs.unsafe_get(r * 3 + 2) >= level {
          r += 1
        }
        let mut lo = start * 3
        let mut hi = (r - 1) * 3
        while lo < hi {
          let s = runs.unsafe_get(lo)
          let e = runs.unsafe_get(lo + 1)
          let l = runs.unsafe_get(lo + 2)
          runs.unsafe_set(lo, runs.unsafe_get(hi))
          runs.unsafe_set(lo + 1, runs.unsafe_get(hi + 1))
          runs.unsafe_set(lo + 2, runs.unsafe_get(hi + 2))
          runs.unsafe_set(hi, s)
          runs.unsafe_set(hi + 1, e)
          runs.unsafe_set(hi + 2, l)
          lo += 3
          hi -= 3
        }
      } else {
        r += 1
      }
    }
    level -= 1
  }
}

///|
/// Fast path for mirroring a character known to have a mirroring glyph.
fn mirror_char(c : Char) -> Char {
  match c {
    '(' => ')'
    ')' => '('
    '[' => ']'
    ']' => '['
    '{' => '}'
    '}' => '{'
    '<' => '>'
    '>' => '<'
    _ => @bidi_data.bidi_mirroring_glyph(c)
  }
}

///|
/// Convert a BidiClass to its ordinal (0..22).
fn bidi_to_code(bc : BidiClass) -> Int32 = "%identity"

///|
/// Bitmask of X9-removed BidiClass ordinals: BN (9) and LRE..PDF (14..18).
const X9ClassMask : Int32 = (1 << 9) |
  (1 << 14) |
  (1 << 15) |
  (1 << 16) |
  (1 << 17) |
  (1 << 18)

///|
/// Scan leading level-0 non-X9 characters, advancing 4 at a time.
fn scan_ltr_prefix(
  original_classes : Array[BidiClass],
  levels : Array[Int32],
  len : Int32,
) -> Int32 {
  let mut i = 0
  while i + 4 <= len {
    let lvl_or = levels.unsafe_get(i) |
      levels.unsafe_get(i + 1) |
      levels.unsafe_get(i + 2) |
      levels.unsafe_get(i + 3)
    let cls_mask = (1 << bidi_to_code(original_classes.unsafe_get(i))) |
      (1 << bidi_to_code(original_classes.unsafe_get(i + 1))) |
      (1 << bidi_to_code(original_classes.unsafe_get(i + 2))) |
      (1 << bidi_to_code(original_classes.unsafe_get(i + 3)))
    if lvl_or != 0 || (cls_mask & X9ClassMask) != 0 {
      break
    }
    i += 4
  }
  while i < len &&
        levels.unsafe_get(i) == 0 &&
        ((1 << bidi_to_code(original_classes.unsafe_get(i))) & X9ClassMask) == 0 {
    i += 1
  }
  i
}

///|
/// Copy `chars[0..<len]` directly to a String (pure-LTR, no X9 characters).
/// Uses a branchless BMP loop that auto-vectorizes, falling back to surrogate
/// encoding only if a supplementary code point (>= U+10000) is present.
fn copy_ltr_chars(chars : Array[Char], len : Int32) -> String {
  let buf = FixedArray::make(len, (0).to_uint16())
  let mut or_cp = 0
  for i in 0..<len {
    let cp = chars.unsafe_get(i).to_int()
    or_cp = or_cp | cp
    buf.unsafe_set(i, cp.to_uint16())
  }
  if or_cp < 0x10000 {
    return finalize_code_units(buf, len)
  }
  copy_ltr_chars_supplementary(chars, len)
}

///|
#inline(never)
fn copy_ltr_chars_supplementary(chars : Array[Char], len : Int32) -> String {
  let mut buf = FixedArray::make(len + 16, (0).to_uint16())
  let mut pos = 0
  for i in 0..<len {
    let cp = chars.unsafe_get(i).to_int()
    if cp < 0x10000 {
      if pos >= buf.length() {
        buf = grow_code_units(buf, pos, pos + (len - i))
      }
      buf.unsafe_set(pos, cp.to_uint16())
      pos += 1
    } else {
      if pos + 2 > buf.length() {
        buf = grow_code_units(buf, pos, pos + (len - i) + 1)
      }
      let offset = cp - 0x10000
      buf.unsafe_set(pos, (0xD800 + (offset >> 10)).to_uint16())
      buf.unsafe_set(pos + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
      pos += 2
    }
  }
  finalize_code_units(buf, pos)
}

///|
/// L2: Reorder character indices in visual order using visual runs.
fn reorder_indices(
  original_classes : Array[BidiClass],
  levels : Array[Int32],
) -> Array[Int32] {
  let len = original_classes.length()
  if len == 0 {
    return []
  }
  if levels.length() < len {
    abort("BidiParagraph fields have mismatched lengths")
  }
  // Pure-LTR fast path: scan leading level-0 non-X9 characters.
  let prefix_end = scan_ltr_prefix(original_classes, levels, len)
  if prefix_end == len {
    return Array::makei(len, fn(i) { i })
  }
  let (runs, non_x9_count, min_level, max_level) = build_visual_runs(
    original_classes, levels, len,
  )
  if non_x9_count == 0 {
    return []
  }
  reorder_visual_runs(runs, min_level, max_level)
  let result : Array[Int32] = Array::make(non_x9_count, 0)
  let mut pos = 0
  let mut r = 0
  let runs_len = runs.length()
  while r < runs_len {
    let start = runs.unsafe_get(r)
    let end = runs.unsafe_get(r + 1)
    let level = runs.unsafe_get(r + 2)
    if (level & 1) == 0 {
      for i in start..<end {
        result.unsafe_set(pos, i)
        pos += 1
      }
    } else {
      let mut i = end - 1
      while i >= start {
        result.unsafe_set(pos, i)
        pos += 1
        i -= 1
      }
    }
    r += 3
  }
  result
}

///|
/// L2 + L4: Reorder characters into a visually-ordered String using visual runs.
fn reorder_to_string(
  chars : Array[Char],
  original_classes : Array[BidiClass],
  levels : Array[Int32],
  base_level : Int32,
) -> String {
  let len = original_classes.length()
  if len == 0 {
    return ""
  }
  if chars.length() < len || levels.length() < len {
    abort("BidiParagraph fields have mismatched lengths")
  }
  // Pure-LTR fast path: scan leading level-0 non-X9 characters.
  let prefix_end = scan_ltr_prefix(original_classes, levels, len)
  if prefix_end == len {
    return copy_ltr_chars(chars, len)
  }
  // Single-pass fast path for LTR paragraphs without X9 characters and without
  // adjacent non-zero-level runs (covers mixed LTR/RTL and isolated higher-level
  // runs such as LTR+brackets/numbers): no runs array is allocated because L2
  // never moves any run relative to another.
  let mut prealloc : FixedArray[UInt16]? = None
  if base_level == 0 {
    let mut buf = FixedArray::make(len, (0).to_uint16())
    let mut pos = 0
    for j in 0..<prefix_end {
      let cp = chars.unsafe_get(j).to_int()
      if cp < 0x10000 {
        buf.unsafe_set(pos, cp.to_uint16())
        pos += 1
      } else {
        let needed = pos + (len - j) + 1
        if needed > buf.length() {
          buf = grow_code_units(buf, pos, needed)
        }
        let offset = cp - 0x10000
        buf.unsafe_set(pos, (0xD800 + (offset >> 10)).to_uint16())
        buf.unsafe_set(pos + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
        pos += 2
      }
    }
    let mut i = prefix_end
    let mut ok = true
    while i < len {
      let bc = original_classes.unsafe_get(i)
      if bc.is_x9_removed() {
        ok = false
        break
      }
      let lvl = levels.unsafe_get(i)
      if lvl == 0 {
        let cp = chars.unsafe_get(i).to_int()
        if cp < 0x10000 {
          buf.unsafe_set(pos, cp.to_uint16())
          pos += 1
        } else {
          let needed = pos + (len - i) + 1
          if needed > buf.length() {
            buf = grow_code_units(buf, pos, needed)
          }
          let offset = cp - 0x10000
          buf.unsafe_set(pos, (0xD800 + (offset >> 10)).to_uint16())
          buf.unsafe_set(pos + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
          pos += 2
        }
        i += 1
      } else {
        // Scan maximal equal-level run starting at i.
        let mut end = i + 1
        while end < len &&
              levels.unsafe_get(end) == lvl &&
              !original_classes.unsafe_get(end).is_x9_removed() {
          end += 1
        }
        // Only valid in one pass if this run is isolated by paragraph end or
        // a non-X9 level-0 character.
        if end < len &&
          (
            levels.unsafe_get(end) != 0 ||
            original_classes.unsafe_get(end).is_x9_removed()
          ) {
          ok = false
          break
        }
        if (lvl & 1) == 0 {
          for k in i..<end {
            let cp = chars.unsafe_get(k).to_int()
            if cp < 0x10000 {
              buf.unsafe_set(pos, cp.to_uint16())
              pos += 1
            } else {
              let needed = pos + (len - k) + 1
              if needed > buf.length() {
                buf = grow_code_units(buf, pos, needed)
              }
              let offset = cp - 0x10000
              buf.unsafe_set(pos, (0xD800 + (offset >> 10)).to_uint16())
              buf.unsafe_set(pos + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
              pos += 2
            }
          }
        } else {
          let mut k = end - 1
          while k >= i {
            let mut c = chars.unsafe_get(k)
            if has_mirroring_glyph(c) {
              c = mirror_char(c)
            }
            let cp = c.to_int()
            if cp < 0x10000 {
              buf.unsafe_set(pos, cp.to_uint16())
              pos += 1
            } else {
              let needed = pos + (len - i - (end - 1 - k)) + 1
              if needed > buf.length() {
                buf = grow_code_units(buf, pos, needed)
              }
              let offset = cp - 0x10000
              buf.unsafe_set(pos, (0xD800 + (offset >> 10)).to_uint16())
              buf.unsafe_set(pos + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
              pos += 2
            }
            k -= 1
          }
        }
        i = end
      }
    }
    if ok {
      return finalize_code_units(buf, pos)
    }
    prealloc = Some(buf)
  }
  let (runs, non_x9_count, min_level, max_level) = build_visual_runs(
    original_classes, levels, len,
  )
  if non_x9_count == 0 {
    return ""
  }
  reorder_visual_runs(runs, min_level, max_level)
  let mut buf = match prealloc {
    Some(b) if b.length() == non_x9_count => b
    _ => FixedArray::make(non_x9_count, (0).to_uint16())
  }
  let mut pos = 0
  let mut r = 0
  let runs_len = runs.length()
  while r < runs_len {
    let start = runs.unsafe_get(r)
    let end = runs.unsafe_get(r + 1)
    let level = runs.unsafe_get(r + 2)
    let run_len = end - start
    if pos + run_len > buf.length() {
      buf = grow_code_units(buf, pos, pos + run_len)
    }
    if (level & 1) == 0 {
      // Even level: emit forward with no mirroring check.
      for i in start..<end {
        let cp = chars.unsafe_get(i).to_int()
        if cp < 0x10000 {
          buf.unsafe_set(pos, cp.to_uint16())
          pos += 1
        } else {
          let needed = pos + (end - i) + 1
          if needed > buf.length() {
            buf = grow_code_units(buf, pos, needed)
          }
          let offset = cp - 0x10000
          buf.unsafe_set(pos, (0xD800 + (offset >> 10)).to_uint16())
          buf.unsafe_set(pos + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
          pos += 2
        }
      }
    } else {
      // Odd level: emit backward, mirroring glyphs as needed.
      let mut i = end - 1
      while i >= start {
        let mut c = chars.unsafe_get(i)
        if has_mirroring_glyph(c) {
          c = mirror_char(c)
        }
        let cp = c.to_int()
        if cp < 0x10000 {
          buf.unsafe_set(pos, cp.to_uint16())
          pos += 1
        } else {
          let needed = pos + (i - start) + 2
          if needed > buf.length() {
            buf = grow_code_units(buf, pos, needed)
          }
          let offset = cp - 0x10000
          buf.unsafe_set(pos, (0xD800 + (offset >> 10)).to_uint16())
          buf.unsafe_set(pos + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
          pos += 2
        }
        i -= 1
      }
    }
    r += 3
  }
  finalize_code_units(buf, pos)
}
