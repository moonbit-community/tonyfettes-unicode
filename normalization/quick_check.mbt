///|
/// ASCII has CCC=0 and Quick_Check=Yes for every normalization form.
fn normalization_properties(c : Char) -> Int {
  if c.to_int() < 0x80 {
    0
  } else {
    @ccc.lookup_normalization_properties(c)
  }
}

///|
/// Scratch storage is allocated only after the first suspect character and
/// reused across safe segments. The output is allocated only on a change.
priv struct NormalizationBuffer {
  chars : Array[Char]
  mut output : StringBuilder?
  mut copied_until : Int
  mut previous_ccc : Int
  mut needs_order : Bool
}

///|
/// Reuse the properties already loaded by the scanner. Only mapped characters
/// need recursive decomposition; detect ordering while appending the result.
fn NormalizationBuffer::append(
  self : NormalizationBuffer,
  c : Char,
  properties : Int,
  compatibility~ : Bool,
) -> Unit {
  let decomp_shift = if compatibility { 13 } else { 12 }
  if ((properties >> decomp_shift) & 1) == 0 {
    let ccc = properties & 255
    if ccc != 0 && self.previous_ccc > ccc {
      self.needs_order = true
    }
    self.previous_ccc = ccc
    self.chars.push(c)
  } else if is_hangul_syllable(c) {
    // Hangul syllables decompose algorithmically into conjoining jamo, which
    // are all starters, so there is no combining class to look up.
    decompose_hangul(c, self.chars)
    self.previous_ccc = 0
  } else {
    let start = self.chars.length()
    @decomposition.append_decomposition(c, self.chars, compatibility~)
    for i in start..<self.chars.length() {
      let ccc = @ccc.lookup_ccc(self.chars[i])
      if ccc != 0 && self.previous_ccc > ccc {
        self.needs_order = true
      }
      self.previous_ccc = ccc
    }
  }
}

///|
/// Compare code points without constructing a normalized string.
fn span_equals(chars : Array[Char], span : StringView) -> Bool {
  let mut i = 0
  for c in span {
    if i >= chars.length() || chars[i] != c {
      return false
    }
    i += 1
  }
  i == chars.length()
}

///|
/// Finish one independent segment. In checking mode, a difference terminates
/// the scan immediately; otherwise append only changed segments to the output.
fn NormalizationBuffer::finish(
  self : NormalizationBuffer,
  s : String,
  start : Int,
  end : Int,
  compose~ : Bool,
  check_only~ : Bool,
) -> Bool {
  if self.needs_order {
    canonical_order(self.chars)
  }
  if compose {
    canonical_compose(self.chars)
  }
  if !span_equals(self.chars, s[start:end]) {
    if check_only {
      return false
    }
    let out = if self.output is Some(out) {
      out
    } else {
      // The size hint counts bytes, two per UTF-16 code unit.
      let out = StringBuilder(size_hint=2 * s.length())
      self.output = Some(out)
      out
    }
    if self.copied_until < start {
      out.write_view(s[self.copied_until:start])
    }
    for c in self.chars {
      out.write_char(c)
    }
    self.copied_until = end
  }
  self.chars.clear()
  self.previous_ccc = 0
  self.needs_order = false
  true
}

///|
/// Process suspect segments with reusable scratch storage until a clean run.
/// Return its next unconsumed boundary, or -1 if checking fails.
fn process_suspect_spans(
  buffer : NormalizationBuffer,
  s : String,
  start : Int,
  problem_offset : Int,
  shift : Int,
  mask : Int,
  compatibility~ : Bool,
  compose~ : Bool,
  check_only~ : Bool,
) -> Int {
  // Retain the starter and any preceding marks in the first suspect segment.
  for c in s[start:problem_offset] {
    buffer.append(c, normalization_properties(c), compatibility~)
  }
  let mut span_start = start
  let mut offset = problem_offset
  let mut previous_ccc = 0
  let mut suspect = true
  let mut clean_start = problem_offset
  for c in s[problem_offset:] {
    let properties = normalization_properties(c)
    let ccc = properties & 255
    let check = (properties >> shift) & mask
    if ccc == 0 && check == 0 {
      // Amortize the handoff over a clean run: consume up to two UTF-16 units
      // here before resuming the tight scanner. Dense one/two-starter gaps
      // stay in this loop, reusing their already loaded properties.
      if !suspect && previous_ccc == 0 && offset - clean_start >= 2 {
        return offset
      }
      if suspect {
        if !buffer.finish(s, span_start, offset, compose~, check_only~) {
          return -1
        }
        clean_start = offset
      }
      span_start = offset
      suspect = false
    }
    let out_of_order = ccc != 0 && previous_ccc > ccc
    if check_only && (check == 1 || out_of_order) {
      return -1
    }
    if !suspect && (check != 0 || out_of_order) {
      for preceding in s[span_start:offset] {
        buffer.append(
          preceding,
          normalization_properties(preceding),
          compatibility~,
        )
      }
      suspect = true
    }
    if suspect {
      buffer.append(c, properties, compatibility~)
    }
    previous_ccc = ccc
    offset += if c.to_int() > 0xFFFF { 2 } else { 1 }
  }
  if suspect && !buffer.finish(s, span_start, offset, compose~, check_only~) {
    return -1
  }
  offset
}

///|
/// Skip Quick_Check=Yes, CCC=0 characters from `start` and return the offset
/// of the first other character, or the length. `slow_mask` selects CCC and
/// one form's Quick_Check bits of the packed properties; shifted right by
/// seven it selects the same bits of the generated scan flags.
///
/// The loop reads the generated one-byte flags and makes no calls. Looking
/// properties up through `@ccc` instead costs a call per character, because
/// functions are not inlined across packages. Even one call on a rare path
/// would make every entry to this function save and restore registers, which
/// shows on text with many short runs.
fn scan_clean_run(s : String, start : Int, slow_mask : Int) -> Int {
  let length = s.length()
  let scan_mask = slow_mask >> 7
  let unit_mask = scan_mask | NormalizationScanLeadSurrogate
  let mut offset = start
  while offset < length {
    // SAFETY: offset starts at a nonnegative boundary and the loop guarantees offset < length.
    // It advances by two only after checking that a second unit exists.
    let first = s.unsafe_get(offset).to_int()
    if first < 0x80 {
      offset += 1
      continue
    }
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
    if offset + 1 >= length {
      offset += 1
      continue
    }
    // SAFETY: offset + 1 < length is checked above.
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
/// Scan UTF-16 with one cursor. The clean-run scan only skips Quick_Check=Yes,
/// CCC=0 characters; CCC ordering and boundary recovery live outside that loop.
/// When it stops, the last skipped code point is the preceding safe boundary.
/// None means the checking mode found a difference; normalization returns Some.
fn process_spans(
  s : String,
  shift : Int,
  mask : Int,
  compatibility~ : Bool,
  compose~ : Bool,
  check_only~ : Bool,
) -> String? {
  let length = s.length()
  let slow_mask = 255 | (mask << shift)
  let mut offset = 0
  let mut span_start = 0
  let mut previous_ccc = 0
  while offset < length {
    let run_start = offset
    offset = scan_clean_run(s, offset, slow_mask)
    if offset == length {
      return Some(s)
    }
    // SAFETY: offset < length is checked above.
    let mut cp = s.unsafe_get(offset).to_int()
    let mut width = 1
    if cp >= 0xD800 && cp <= 0xDBFF {
      // The scan stops on a leading surrogate only when a trailing one follows.
      cp = 0x10000 + ((cp - 0xD800) << 10) + s[offset + 1].to_int() - 0xDC00
      width = 2
    }
    let properties = @ccc.lookup_normalization_properties(cp.unsafe_to_char())
    if offset > run_start {
      // All skipped characters are CCC=0 and Quick_Check=Yes. Recover only
      // the last one's start, including its leading surrogate when present.
      span_start = offset - 1
      if s[span_start].is_trailing_surrogate() &&
        span_start > run_start &&
        s[span_start - 1].is_leading_surrogate() {
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
      return process_remaining_spans(
        s,
        span_start,
        offset,
        shift,
        mask,
        compatibility~,
        compose~,
        check_only~,
      )
    }
    // Quick_Check=Yes marks still require ordering checks. Keep their starter
    // boundary until the next run of CCC=0 characters or a suspect character.
    previous_ccc = ccc
    offset += width
  }
  Some(s)
}

///|
/// Continue after the first suspect character, reusing one scratch buffer.
/// Normal runs resume the tight scanner; the allocation-free entry path above
/// keeps this scratch/output state out of its hot loop.
fn process_remaining_spans(
  s : String,
  start : Int,
  problem_offset : Int,
  shift : Int,
  mask : Int,
  compatibility~ : Bool,
  compose~ : Bool,
  check_only~ : Bool,
) -> String? {
  let buffer : NormalizationBuffer = {
    chars: [],
    output: None,
    copied_until: 0,
    previous_ccc: 0,
    needs_order: false,
  }
  let length = s.length()
  let slow_mask = 255 | (mask << shift)
  let mut offset = problem_offset
  let mut span_start = start
  while offset < length {
    offset = process_suspect_spans(
      buffer,
      s,
      span_start,
      offset,
      shift,
      mask,
      compatibility~,
      compose~,
      check_only~,
    )
    if offset < 0 {
      return None
    }
    // The helper stopped before a clean starter (or at the end). Scan the
    // following run without carrying scratch/output state through its loop.
    let run_start = offset
    offset = scan_clean_run(s, offset, slow_mask)
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
  if buffer.output is Some(out) {
    if buffer.copied_until < length {
      out.write_view(s[buffer.copied_until:])
    }
    Some(out.to_string())
  } else {
    Some(s)
  }
}

///|
fn normalize_spans(
  s : String,
  shift : Int,
  mask : Int,
  compatibility~ : Bool,
  compose~ : Bool,
) -> String {
  process_spans(s, shift, mask, compatibility~, compose~, check_only=false).unwrap_or(
    s,
  )
}
