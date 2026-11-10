///|
/// UTF-16 output of NFC and NFKC after the first suspect character, and the
/// segment being composed.
///
/// A segment begins at a starter that may compose with what follows and
/// ends before the next clean starter (CCC=0, Quick_Check=Yes), which never
/// composes with anything before it. The segment holds full decompositions
/// as packed entries, like those of `@decomposition.packed_decomposition`,
/// so composing it needs no further lookup of combining classes.
priv struct Composer {
  out : CodeUnits
  mut segment : FixedArray[Int32]
  mut segment_len : Int32
  /// The CCC of the last entry of the segment.
  mut previous_ccc : Int32
  mut needs_order : Bool
}

///|
#inline(never)
fn Composer::grow_segment(self : Composer) -> Unit {
  self.segment = FixedArray::make_and_blit(
    self.segment,
    allocate_len=2 * self.segment.length(),
    init=0,
    len=self.segment_len,
  )
}

///|
/// Add one packed entry with combining class `ccc` to the segment.
fn Composer::push(self : Composer, entry : Int32, ccc : Int32) -> Unit {
  if self.segment_len == self.segment.length() {
    self.grow_segment()
  }
  if ccc != 0 && self.previous_ccc > ccc {
    self.needs_order = true
  }
  self.previous_ccc = ccc
  // SAFETY: the segment has room after `segment_len`, as checked above.
  self.segment.unsafe_set(self.segment_len, entry)
  self.segment_len += 1
}

///|
/// Add a character with normalization record `record` to the segment,
/// decomposed when it has a decomposition of this form's kind, which the
/// record's bit `decomposition_bit` tells.
///
/// Hangul syllables stay whole: an LV syllable composes with a following
/// trailing jamo as its decomposition would, and nothing else composes with
/// either. Conjoining jamo compose here, as soon as they arrive: a leading
/// jamo never composes with what precedes it, and a vowel or trailing jamo
/// right after the starter it composes with is never blocked or reordered.
fn Composer::append(
  self : Composer,
  code_point : Int32,
  record : Int32,
  decomposition_bit : Int32,
  compatibility~ : Bool,
) -> Unit {
  let c = code_point.unsafe_to_char()
  if ((record >> decomposition_bit) & 1) == 0 || is_hangul_syllable(c) {
    let ccc = record & 255
    if ccc == 0 && self.segment_len > 0 && self.previous_ccc == 0 {
      // SAFETY: the segment is not empty.
      let last = self.segment.unsafe_get(self.segment_len - 1)
      if try_compose_hangul(last.unsafe_to_char(), c) is Some(syllable) {
        self.segment.unsafe_set(self.segment_len - 1, syllable.to_int())
        return
      }
    }
    self.push(code_point | (ccc << PackedCccShift), ccc)
  } else {
    for entry in @decomposition.packed_decomposition(record, compatibility~) {
      self.push(entry, entry >> PackedCccShift)
    }
  }
}

///|
/// Sort each run of nonstarters of the segment by CCC, keeping equal
/// classes in their order.
fn Composer::order_segment(self : Composer) -> Unit {
  let segment = self.segment
  for i in 1..<self.segment_len {
    let entry = segment[i]
    let ccc = entry >> PackedCccShift
    if ccc == 0 {
      continue
    }
    // A starter's class is 0, below any nonstarter's, so the insertion
    // stops at the start of the run.
    let mut j = i
    while j > 0 && segment[j - 1] >> PackedCccShift > ccc {
      segment[j] = segment[j - 1]
      j -= 1
    }
    segment[j] = entry
  }
}

///|
/// Apply the canonical composition algorithm to the segment in place.
fn Composer::compose_segment(self : Composer) -> Unit {
  let segment = self.segment
  let len = self.segment_len
  let first_ccc = segment[0] >> PackedCccShift
  // The last starter kept, or -1 before the first.
  let mut last_starter = if first_ccc == 0 { 0 } else { -1 }
  // The CCC of the last entry kept; a composed entry keeps the starter's.
  let mut last_ccc = first_ccc
  let mut written = 1
  for i in 1..<len {
    let entry = segment[i]
    let ccc = entry >> PackedCccShift
    // A character is blocked from the last starter by any character kept
    // between them whose class is 0 or not below its own.
    let blocked = last_ccc != 0 && (ccc == 0 || last_ccc >= ccc)
    if last_starter >= 0 && !blocked {
      let starter = (segment[last_starter] & PackedCodePointMask).unsafe_to_char()
      let second = (entry & PackedCodePointMask).unsafe_to_char()
      if try_compose(starter, second) is Some(composed) {
        // Composites are starters, so the entry's class stays 0.
        segment[last_starter] = composed.to_int()
        continue
      }
    }
    segment[written] = entry
    written += 1
    if ccc == 0 {
      last_starter = written - 1
    }
    last_ccc = ccc
  }
  self.segment_len = written
}

///|
/// Compose the segment and write it out.
fn Composer::flush(self : Composer) -> Unit {
  if self.segment_len == 0 {
    return
  }
  if self.segment_len > 1 {
    if self.needs_order {
      self.order_segment()
    }
    self.compose_segment()
  }
  self.out.reserve(2 * self.segment_len)
  for i in 0..<self.segment_len {
    self.out.store(self.segment[i] & PackedCodePointMask)
  }
  self.segment_len = 0
  self.previous_ccc = 0
  self.needs_order = false
}

///|
/// Compose `s` from view-relative `start`, the last starter before the
/// first suspect character (or the view's start). Everything before `start`
/// is unchanged. The record bits from `shift` hold this form's Quick_Check
/// value, and `compatibility` selects NFKC.
///
/// Like `decompose_remaining`, this copies clean runs as they are, found by
/// the clean-run scanner, except for each run's last character: the
/// characters after it may compose with it, so it begins a segment.
#inline(never)
fn compose_remaining(
  s : StringView,
  start : Int32,
  shift : Int32,
  compatibility~ : Bool,
) -> String {
  let data = s.data()
  let view_start = s.start_offset()
  let view_end = view_start + s.length()
  let slow_mask = 255 | (3 << shift)
  let decomposition_bit = if compatibility { 13 } else { 12 }
  let composer : Composer = {
    out: {
      data: FixedArray::make(s.length() + 16, 0),
      len: 0,
      marks_start: 0,
      previous_ccc: 0,
      needs_order: false,
    },
    segment: FixedArray::make(32, 0),
    segment_len: 0,
    previous_ccc: 0,
    needs_order: false,
  }
  composer.out.copy(data, view_start, view_start + start)
  let mut offset = view_start + start
  while offset < view_end {
    // A leading jamo is a clean starter, and the syllable it composes with
    // the vowel and trailing jamo right after it composes with nothing that
    // follows. So the syllable is written at once, before any lookup.
    // SAFETY: offset < view_end, and each following unit is read only below
    // view_end.
    let l_index = data.unsafe_get(offset).to_int() - hangul_l_base
    if l_index >= 0 && l_index < hangul_l_count && offset + 1 < view_end {
      let v_index = data.unsafe_get(offset + 1).to_int() - hangul_v_base
      if v_index >= 0 && v_index < hangul_v_count {
        composer.flush()
        let mut syllable = hangul_s_base +
          (l_index * hangul_v_count + v_index) * hangul_t_count
        offset += 2
        if offset < view_end {
          let t_index = data.unsafe_get(offset).to_int() - hangul_t_base
          if t_index > 0 && t_index < hangul_t_count {
            syllable += t_index
            offset += 1
          }
        }
        composer.out.reserve(1)
        composer.out.store(syllable)
        continue
      }
    }
    let code_point = code_point_at(data, offset, view_end)
    let width = if code_point >= 0x10000 { 2 } else { 1 }
    // An unpaired surrogate has default properties: a clean starter.
    let record = normalization_properties(code_point.unsafe_to_char())
    if (record & 255) != 0 || ((record >> shift) & 3) != 0 {
      composer.append(code_point, record, decomposition_bit, compatibility~)
      offset += width
      continue
    }
    // A clean starter: nothing from here on composes with the segment.
    composer.flush()
    let run_end = scan_clean_run(data, offset + width, view_end, slow_mask)
    if run_end == view_end {
      composer.out.copy(data, offset, view_end)
      break
    }
    // The run's last character begins the next segment.
    let mut last = run_end - 1
    if last > offset &&
      data.unsafe_get(last).is_trailing_surrogate() &&
      data.unsafe_get(last - 1).is_leading_surrogate() {
      last -= 1
    }
    if last == offset {
      composer.append(code_point, record, decomposition_bit, compatibility~)
    } else {
      composer.out.copy(data, offset, last)
      let last_code_point = code_point_at(data, last, view_end)
      composer.append(
        last_code_point,
        normalization_properties(last_code_point.unsafe_to_char()),
        decomposition_bit,
        compatibility~,
      )
    }
    offset = run_end
  }
  composer.flush()
  // Copied here for the reason given in `decompose_remaining`.
  let out = composer.out
  let result = FixedArray::make(out.len, (0).to_uint16())
  result.unsafe_blit(0, out.data, 0, out.len)
  uint16_array_to_string(result)
}

///|
/// The code point at absolute `offset` of `s`, where `end` bounds the units
/// that may be read. An unpaired surrogate is returned as it is.
fn code_point_at(s : String, offset : Int32, end : Int32) -> Int32 {
  // SAFETY: the caller passes offset < end <= s.length().
  let unit = s.unsafe_get(offset).to_int()
  if unit >= 0xD800 && unit <= 0xDBFF && offset + 1 < end {
    let trail = s.unsafe_get(offset + 1).to_int()
    if trail >= 0xDC00 && trail <= 0xDFFF {
      return 0x10000 + ((unit - 0xD800) << 10) + trail - 0xDC00
    }
  }
  unit
}
