///|
/// The normalization record of a character: its packed properties in bits
/// 0..15, and in the bits above, where `@decomposition.packed_decomposition`
/// finds its decomposition. ASCII has CCC=0, Quick_Check=Yes for every
/// normalization form and no decomposition.
fn normalization_record(c : Char) -> Int32 {
  if c.to_int() < 0x80 {
    0
  } else {
    @decomposition.lookup_normalization_record(c)
  }
}

///|
/// The Quick_Check bits of NFC and NFKC, the forms that compose: Yes=0,
/// No=1, Maybe=2.
const ComposeQuickCheckMask : Int32 = 3

///|
/// Check suspect segments of NFC or NFKC, composed in `composer`, until a
/// clean run. Return its next unconsumed boundary, or -1 if checking fails.
fn check_suspect_spans(
  composer : Composer,
  s : StringView,
  start : Int32,
  problem_offset : Int32,
  shift : Int32,
  compatibility~ : Bool,
) -> Int32 {
  // Retain the starter and any preceding marks in the first suspect segment.
  for c in s[start:problem_offset] {
    composer.append(c.to_int(), normalization_record(c), compatibility~)
  }
  let mut span_start = start
  let mut offset = problem_offset
  let mut previous_ccc = 0
  let mut suspect = true
  let mut clean_start = problem_offset
  for c in s[problem_offset:] {
    let record = normalization_record(c)
    let ccc = record & 255
    let check = (record >> shift) & ComposeQuickCheckMask
    if ccc == 0 && check == 0 {
      // Amortize the handoff over a clean run: consume up to two UTF-16 units
      // here before resuming the tight scanner. Dense one/two-starter gaps
      // stay in this loop, reusing their already loaded properties.
      if !suspect && previous_ccc == 0 && offset - clean_start >= 2 {
        return offset
      }
      if suspect {
        if !composer.check(s[span_start:offset]) {
          return -1
        }
        clean_start = offset
      }
      span_start = offset
      suspect = false
    }
    let out_of_order = ccc != 0 && previous_ccc > ccc
    if check == 1 || out_of_order {
      return -1
    }
    if !suspect && check != 0 {
      for preceding in s[span_start:offset] {
        composer.append(
          preceding.to_int(),
          normalization_record(preceding),
          compatibility~,
        )
      }
      suspect = true
    }
    if suspect {
      composer.append(c.to_int(), record, compatibility~)
    }
    previous_ccc = ccc
    offset += if c.to_int() > 0xFFFF { 2 } else { 1 }
  }
  if suspect && !composer.check(s[span_start:offset]) {
    return -1
  }
  offset
}

///|
/// Skip Quick_Check=Yes, CCC=0 characters from `start` and return the offset
/// of the first other character. Without one before `end`, return `end`, or
/// one past it when a surrogate pair crosses it. `slow_mask` selects CCC and
/// one form's Quick_Check bits of the packed properties; shifted right by
/// seven it selects the same bits of the generated scan flags.
/// Offsets are absolute in the backing string. `limit` is the view's end;
/// a pair may cross the current scan chunk's `end`, but never `limit`.
///
/// The loop reads the generated one-byte flags and makes no calls. Looking
/// properties up through `@ccc` instead costs a call per character, because
/// functions are not inlined across packages. Even one call on a rare path
/// would make every entry to this function save and restore registers, which
/// shows on text with many short runs. The loop is also sensitive to its
/// shape: trying blocks inside it instead of around it costs an extra taken
/// branch per character.
fn scan_clean_units(
  s : String,
  start : Int32,
  end : Int32,
  limit : Int32,
  slow_mask : Int32,
) -> Int32 {
  let scan_mask = slow_mask >> 7
  let unit_mask = scan_mask | NormalizationScanLeadSurrogate
  let mut offset = start
  while offset < end {
    // SAFETY: offset starts at a nonnegative boundary and offset < end <= limit <= s.length().
    // It advances by two only after checking that a second unit exists.
    let first = s.unsafe_get(offset).to_int()
    // SAFETY: first is a UTF-16 code unit, so first >> NormalizationScanShift
    // indexes one of the 2048 blocks; the generator checks every flags index.
    let block = normalization_scan_index
      .unsafe_get(first >> NormalizationScanShift)
      .to_int()
    let flags = normalization_scan_flags
      .unsafe_get(
        (block << NormalizationScanShift) | (first & NormalizationScanBlockMask),
      )
      .to_int()
    if (flags & unit_mask) == 0 {
      offset += 1
      continue
    }
    if flags != NormalizationScanLeadSurrogate {
      break
    }
    // An unpaired surrogate has default properties.
    if offset + 1 >= limit {
      offset += 1
      continue
    }
    // SAFETY: offset + 1 < limit is checked above.
    let second = s.unsafe_get(offset + 1).to_int()
    if second < 0xDC00 || second > 0xDFFF {
      offset += 1
      continue
    }
    let lead = first - 0xD800
    // Compare the default-tail boundary before reading the group summary.
    // SAFETY: a valid pair outside that tail has a generated lead index.
    if lead > NormalizationTailLeadIndex ||
      (lead == NormalizationTailLeadIndex && second >= NormalizationTailTrail) ||
      (normalization_lead_flags.unsafe_get(lead).to_int() & scan_mask) == 0 {
      offset += 2
      continue
    }
    // Some character in this group of 1024 has flags: read this pair's own.
    // SAFETY: lead is below the tail as above and trail is a 10-bit value;
    // the generator checks both indices for every such pair.
    let trail = second - 0xDC00
    let slot = normalization_lead_slots.unsafe_get(lead).to_int()
    let pair_block = normalization_pair_index
      .unsafe_get(
        (slot << (10 - NormalizationPairShift)) |
        (trail >> NormalizationPairShift),
      )
      .to_int()
    let pair_flags = normalization_pair_flags
      .unsafe_get(
        (pair_block << NormalizationPairShift) |
        (trail & NormalizationPairBlockMask),
      )
      .to_int()
    if (pair_flags & scan_mask) != 0 {
      break
    }
    offset += 2
  }
  offset
}

///|
/// Return the end of the run of clean characters starting at `start`.
///
/// Once a stretch of code units has passed the scan one at a time, blocks
/// are tried: a block whose code units are all below the clean limit needs
/// no table. The stretch starts short, so that a run that soon ends never
/// reaches a block, and grows while no block is clean, so that text above the
/// limit pays for few tries and few calls. On native and wasm, later
/// stretches are scanned four units at a time, which takes fewer branches per
/// unit but costs more where the run ends, so the first stretch, where most
/// short runs end, is not.
fn scan_clean_run(
  s : String,
  start : Int32,
  end : Int32,
  slow_mask : Int32,
) -> Int32 {
  let mut offset = start
  let mut stretch = MinUnitStretch
  while true {
    let chunk_end = if end - offset > stretch { offset + stretch } else { end }
    if offset > start {
      offset = skip_clean_quads(s, offset, chunk_end, slow_mask >> 7)
    }
    offset = scan_clean_units(s, offset, chunk_end, end, slow_mask)
    // A pair that crosses `chunk_end` leaves the offset one past it.
    if offset < chunk_end || offset >= end {
      break
    }
    let blocks_end = skip_clean_blocks(s, offset, end, slow_mask >> 7)
    if blocks_end > offset {
      stretch = MinUnitStretch
    } else if stretch < MaxUnitStretch {
      stretch = 4 * stretch
    }
    offset = blocks_end
  }
  offset
}

///|
/// Without SIMD, the scan one unit at a time is faster than groups of four.
#cfg(not(any(target="native", target="wasm")))
fn skip_clean_quads(
  _s : String,
  start : Int32,
  _end : Int32,
  _scan_mask : Int32,
) -> Int32 {
  start
}

///|
/// Skip groups of four code units that are all clean. A lead surrogate
/// stops the skip; the scan one unit at a time handles it.
#cfg(any(target="native", target="wasm"))
fn skip_clean_quads(
  s : String,
  start : Int32,
  end : Int32,
  scan_mask : Int32,
) -> Int32 {
  let unit_mask = scan_mask | NormalizationScanLeadSurrogate
  let mut offset = start
  while end - offset >= 4 {
    // SAFETY: four units remain before `end`.
    let flags = unit_scan_flags(s.unsafe_get(offset)) |
      unit_scan_flags(s.unsafe_get(offset + 1)) |
      unit_scan_flags(s.unsafe_get(offset + 2)) |
      unit_scan_flags(s.unsafe_get(offset + 3))
    if (flags & unit_mask) != 0 {
      break
    }
    offset += 4
  }
  offset
}

///|
/// The scan flags of one code unit.
#cfg(any(target="native", target="wasm"))
fn unit_scan_flags(unit : UInt16) -> Int32 {
  let unit = unit.to_int()
  // SAFETY: a code unit shifted by NormalizationScanShift indexes one of the
  // 2048 blocks; the generator checks every flags index.
  normalization_scan_flags
  .unsafe_get(
    (
      normalization_scan_index
      .unsafe_get(unit >> NormalizationScanShift)
      .to_int() <<
      NormalizationScanShift
    ) |
    (unit & NormalizationScanBlockMask),
  )
  .to_int()
}

///|
/// Code units scanned one at a time before the first block and after a block
/// that is not clean.
const MinUnitStretch : Int32 = 16

///|
const MaxUnitStretch : Int32 = 4096

///|
/// The first code unit that is not a clean starter in the forms `scan_mask`
/// selects: U+00A0 has a compatibility mapping, U+00C0 a canonical one, and
/// U+0300 is the first combining mark.
fn clean_unit_limit(scan_mask : Int32) -> Int32 {
  if (scan_mask & 0b1011000) != 0 {
    0xA0
  } else if (scan_mask & 0b0100000) != 0 {
    0xC0
  } else {
    0x300
  }
}

///|
/// Skip blocks of four code units that are all below the clean limit, and
/// return the offset of the first block that is not, or that is incomplete.
/// Without SIMD, comparing the units' union is one test per block, against
/// the largest power of two at or below the limit: U+0200 for NFC, which
/// covers Latin Extended-A, and ASCII for the other forms.
#cfg(target="wasm-gc")
fn skip_clean_blocks(
  s : String,
  start : Int32,
  end : Int32,
  scan_mask : Int32,
) -> Int32 {
  // `clean_unit_limit` is 0x300 exactly when none of these forms is selected.
  // Tested here, since a call stays a call on wasm-gc: calling it made NFD
  // 6-8% slower there on x86.
  let limit = if (scan_mask & 0b1111000) == 0 { 0x200 } else { 0x80 }
  let mut offset = start
  while end - offset >= 4 {
    // SAFETY: four units remain before `end`.
    let units = s.unsafe_get(offset) |
      s.unsafe_get(offset + 1) |
      s.unsafe_get(offset + 2) |
      s.unsafe_get(offset + 3)
    if units.to_int() >= limit {
      break
    }
    offset += 4
  }
  offset
}

///|
/// The loop of the wasm-gc `skip_clean_blocks`, for a JS view that ends
/// before its string.
#cfg(target="js")
fn skip_low_unit_blocks(
  s : String,
  start : Int32,
  end : Int32,
  scan_mask : Int32,
) -> Int32 {
  // The test of the wasm-gc version, for the same `scan_mask` bits.
  let limit = if (scan_mask & 0b1111000) == 0 { 0x200 } else { 0x80 }
  let mut offset = start
  while end - offset >= 4 {
    // SAFETY: four units remain before `end`.
    let units = s.unsafe_get(offset) |
      s.unsafe_get(offset + 1) |
      s.unsafe_get(offset + 2) |
      s.unsafe_get(offset + 3)
    if units.to_int() >= limit {
      break
    }
    offset += 4
  }
  offset
}

///|
/// Skip code units that are all below the clean limit, and return the offset
/// of the first that is not. A sticky regular expression scans the string in
/// V8's compiled matcher, about three times as fast on ASCII as reading the
/// units one at a time; it stops only at a unit it rejects or at the string's
/// end, so a view that ends early is scanned with the loop instead.
#cfg(target="js")
fn skip_clean_blocks(
  s : String,
  start : Int32,
  end : Int32,
  scan_mask : Int32,
) -> Int32 {
  let limit = clean_unit_limit(scan_mask)
  // SAFETY: start < end is checked first. A run often ends at its first
  // unit, as in Cyrillic text, and the call into the matcher costs more
  // than that test.
  if start >= end || s.unsafe_get(start).to_int() >= limit {
    start
  } else if end == s.length() {
    skip_units_below(s, start, limit)
  } else {
    skip_low_unit_blocks(s, start, end, scan_mask)
  }
}

///|
/// The offset of the first code unit of `s` from `start` that is not below
/// `limit`, one of the results of `clean_unit_limit`, or `s.length()`.
#cfg(target="js")
extern "js" fn skip_units_below(
  s : String,
  start : Int32,
  limit : Int32,
) -> Int32 =
  #|(() => {
  #|  const below = { 0xa0: /[\0-\x9f]*/y, 0xc0: /[\0-\xbf]*/y, 0x300: /[\0-\u02ff]*/y };
  #|  return (s, start, limit) => {
  #|    const re = below[limit];
  #|    re.lastIndex = start;
  #|    re.test(s);
  #|    return re.lastIndex;
  #|  };
  #|})()

///|
/// Skip blocks of eight code units that are all below the clean limit, and
/// return the offset of the first block that is not, or that is incomplete.
///
/// A unit at or above the limit is the one that leaves a lane nonzero after
/// subtracting `limit - 1` with saturation. That takes one instruction on
/// SSE2, which has no unsigned 16-bit comparison, and two blocks are tested
/// per step. With a comparison and one block per step, the loop took 60-86%
/// longer on the x86 CI runners (AMD EPYC 7763 and 9V74) once a change to
/// unrelated tables moved it, though its code was the same: about 4 cycles
/// per block instead of 2.5.
#cfg(target="native")
// The SIMD operations are experimental upstream. Only this function uses
// them, so the alert is silenced here and not for the whole package.
#warnings("-alert_experimental")
fn skip_clean_blocks(
  s : String,
  start : Int32,
  end : Int32,
  scan_mask : Int32,
) -> Int32 {
  let below = @v128.i16x8_splat((clean_unit_limit(scan_mask) - 1).to_uint16())
  let mut offset = start
  while end - offset >= 16 {
    // SAFETY: offset is absolute and sixteen units remain before the view's
    // end.
    let excess = @v128.v128_or_(
      @v128.i16x8_sub_sat_u(@v128.v128_load_i16x8(s, offset), below),
      @v128.i16x8_sub_sat_u(@v128.v128_load_i16x8(s, offset + 8), below),
    )
    if @v128.v128_any_true(excess) {
      break
    }
    offset += 16
  }
  // The first block of a pair that failed may still be clean.
  while end - offset >= 8 {
    // SAFETY: offset is absolute and eight units remain before the view's end.
    let excess = @v128.i16x8_sub_sat_u(@v128.v128_load_i16x8(s, offset), below)
    if @v128.v128_any_true(excess) {
      break
    }
    offset += 8
  }
  offset
}

///|
/// Skip blocks of eight code units that are all below the clean limit, and
/// return the offset of the first block that is not, or that is incomplete.
///
/// The native version tests two blocks per step; here that made NFD on
/// Cyrillic text 30-38% slower in V8, though it halved the time on ASCII.
#cfg(target="wasm")
// The SIMD operations are experimental upstream. Only this function uses
// them, so the alert is silenced here and not for the whole package.
#warnings("-alert_experimental")
fn skip_clean_blocks(
  s : String,
  start : Int32,
  end : Int32,
  scan_mask : Int32,
) -> Int32 {
  let limit = @v128.i16x8_splat(clean_unit_limit(scan_mask).to_uint16())
  let mut offset = start
  while end - offset >= 8 {
    // SAFETY: offset is absolute and eight units remain before the view's end.
    let block = @v128.v128_load_i16x8(s, offset)
    if @v128.v128_any_true(@v128.i16x8_ge_u(block, limit)) {
      break
    }
    offset += 8
  }
  offset
}

///|
/// Scan UTF-16 with one cursor. The clean-run scan only skips Quick_Check=Yes,
/// CCC=0 characters; CCC ordering and boundary recovery live outside that loop.
/// When it stops, the last skipped code point is the preceding safe boundary.
/// Checking returns None on a difference and Some("") on success, without
/// copying the input. Normalization returns Some with the normalized string.
/// String? uses the native nullable-pointer representation; StringView? would
/// allocate an Option wrapper even when the input is already normalized.
fn process_spans(
  s : StringView,
  shift : Int32,
  mask : Int32,
  compatibility~ : Bool,
  compose~ : Bool,
  check_only~ : Bool,
) -> String? {
  let data = s.data()
  let start = s.start_offset()
  let end = start + s.length()
  let slow_mask = 255 | (mask << shift)
  let mut offset = start
  let mut span_start = start
  let mut previous_ccc = 0
  while offset < end {
    let run_start = offset
    offset = scan_clean_run(data, offset, end, slow_mask)
    if offset == end {
      return Some(if check_only { "" } else { s.to_owned() })
    }
    // SAFETY: start <= offset < end <= data.length().
    let mut cp = data.unsafe_get(offset).to_int()
    let mut width = 1
    if cp >= 0xD800 && cp <= 0xDBFF {
      // The scan stops on a leading surrogate only when a trailing one follows.
      cp = 0x10000 + ((cp - 0xD800) << 10) + data[offset + 1].to_int() - 0xDC00
      width = 2
    }
    let properties = @ccc.lookup_normalization_properties(cp.unsafe_to_char())
    if offset > run_start {
      // All skipped characters are CCC=0 and Quick_Check=Yes. Recover only
      // the last one's start, including its leading surrogate when present.
      // Written out, not shared with the other two scans that do this: a
      // helper stays a call on wasm-gc, where this runs after every clean
      // run.
      span_start = offset - 1
      if data[span_start].is_trailing_surrogate() &&
        span_start > run_start &&
        data[span_start - 1].is_leading_surrogate() {
        span_start -= 1
      }
      previous_ccc = 0
    }
    let ccc = properties & 255
    let check = (properties >> shift) & mask
    let out_of_order = ccc != 0 && previous_ccc > ccc
    if check_only && (check == 1 || out_of_order) {
      return None
    }
    if check != 0 || out_of_order {
      if !check_only {
        let remaining_start = span_start - start
        return Some(
          if compose {
            compose_remaining(s, remaining_start, shift, compatibility~)
          } else {
            decompose_remaining(s, remaining_start, shift, compatibility~)
          },
        )
      }
      // Checking reaches this point only past Quick_Check=Maybe, which
      // only NFC and NFKC have.
      return if check_remaining_spans(
          s,
          span_start - start,
          offset - start,
          shift,
          compatibility~,
        ) {
        Some("")
      } else {
        None
      }
    }
    // Quick_Check=Yes marks still require ordering checks. Keep their starter
    // boundary until the next run of CCC=0 characters or a suspect character.
    previous_ccc = ccc
    offset += width
  }
  Some(if check_only { "" } else { s.to_owned() })
}

///|
/// Check NFC or NFKC after the first suspect character, reusing one
/// composer, which writes nothing. Normal runs resume the tight scanner; the
/// allocation-free entry path keeps the scratch state out of its hot loop.
fn check_remaining_spans(
  s : StringView,
  start : Int32,
  problem_offset : Int32,
  shift : Int32,
  compatibility~ : Bool,
) -> Bool {
  let composer = Composer::new(0)
  let length = s.length()
  let data = s.data()
  let view_start = s.start_offset()
  let view_end = view_start + length
  let slow_mask = 255 | (ComposeQuickCheckMask << shift)
  let mut offset = problem_offset
  let mut span_start = start
  while offset < length {
    offset = check_suspect_spans(
      composer,
      s,
      span_start,
      offset,
      shift,
      compatibility~,
    )
    if offset < 0 {
      return false
    }
    // The helper stopped before a clean starter (or at the end). Scan the
    // following run without carrying scratch state through its loop.
    let run_start = offset
    // Suspect-segment processing uses view-relative offsets; convert only
    // at the handoff to the scanner, whose hot loop uses absolute offsets.
    offset = scan_clean_run(data, view_start + offset, view_end, slow_mask) -
      view_start
    if offset == length {
      break
    }
    // At least one clean starter was skipped. Retain its last code point for
    // the next segment, including the leading half of a surrogate pair.
    span_start = offset - 1
    if s[span_start].is_trailing_surrogate() &&
      span_start > run_start &&
      s[span_start - 1].is_leading_surrogate() {
      span_start -= 1
    }
  }
  true
}

///|
fn normalize_spans(
  s : StringView,
  shift : Int32,
  mask : Int32,
  compatibility~ : Bool,
  compose~ : Bool,
) -> String {
  // Keep the fallback lazy without allocating a capturing closure.
  if process_spans(s, shift, mask, compatibility~, compose~, check_only=false)
    is Some(result) {
    result
  } else {
    s.to_owned()
  }
}
