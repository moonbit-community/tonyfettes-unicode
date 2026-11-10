///|
/// The fields of an entry of `@decomposition.packed_decomposition`.
const PackedCodePointMask : Int32 = 0x1FFFFF

///|
const PackedCccShift : Int32 = 21

///|
/// Take ownership of UTF-16 code units as a string of the same length.
fn uint16_array_to_string(buffer : FixedArray[UInt16]) -> String = "%string.unsafe_from_uint16_fixedarray"

///|
/// UTF-16 output, owned until it becomes a string.
///
/// NFD and NFKD write their output here as it is produced, after the first
/// suspect character, with no scratch segment: decomposition never merges
/// characters, so each can be written as soon as it is decomposed. The
/// trailing run of nonstarters is tracked so that it is sorted in place, and
/// only when it is out of order. NFC and NFKC write segments that are already
/// composed and ordered, and leave that state alone.
priv struct CodeUnits {
  mut data : FixedArray[UInt16]
  mut len : Int32
  /// Where the trailing run of nonstarters begins.
  mut marks_start : Int32
  /// The CCC of the last unit written if it ends a nonstarter, else 0.
  mut previous_ccc : Int32
  mut needs_order : Bool
}

///|
#inline(never)
fn CodeUnits::grow(self : CodeUnits, required : Int32) -> Unit {
  let mut capacity = if self.data.length() < 16 {
    16
  } else {
    2 * self.data.length()
  }
  while capacity < required {
    capacity *= 2
  }
  self.data = FixedArray::make_and_blit(
    self.data,
    allocate_len=capacity,
    init=0,
    len=self.len,
  )
}

///|
/// Make room for `count` more code units.
fn CodeUnits::reserve(self : CodeUnits, count : Int32) -> Unit {
  if self.len + count > self.data.length() {
    self.grow(self.len + count)
  }
}

///|
/// Store one code point. The caller has reserved two units.
fn CodeUnits::store(self : CodeUnits, code_point : Int32) -> Unit {
  // SAFETY: the caller reserved two units after `len`.
  if code_point < 0x10000 {
    self.data.unsafe_set(self.len, code_point.to_uint16())
    self.len += 1
  } else {
    let offset = code_point - 0x10000
    self.data.unsafe_set(self.len, (0xD800 + (offset >> 10)).to_uint16())
    self.data.unsafe_set(self.len + 1, (0xDC00 + (offset & 0x3FF)).to_uint16())
    self.len += 2
  }
}

///|
/// Copy code units `start` to `end` of `s` unchanged.
fn CodeUnits::copy(
  self : CodeUnits,
  s : String,
  start : Int32,
  end : Int32,
) -> Unit {
  let count = end - start
  self.reserve(count)
  // Locals, so that the stores need not reload the fields: the C backend
  // does not assume that stores of code units leave this record unchanged.
  let data = self.data
  let len = self.len
  // SAFETY: the caller passes 0 <= start <= end <= s.length(), and `count`
  // units are reserved after `len`.
  for i in 0..<count {
    data.unsafe_set(len + i, s.unsafe_get(start + i))
  }
  self.len = len + count
}

///|
/// End the trailing run of nonstarters before a starter is written.
fn CodeUnits::end_marks(self : CodeUnits) -> Unit {
  if self.needs_order {
    self.reorder_marks()
    self.needs_order = false
  }
  self.previous_ccc = 0
}

///|
/// Sort the trailing run of nonstarters by CCC, keeping equal classes in
/// their order. Marks out of order are rare, so this decodes and looks up
/// again rather than keeping the classes around.
#inline(never)
fn CodeUnits::reorder_marks(self : CodeUnits) -> Unit {
  let marks : Array[Char] = []
  let mut i = self.marks_start
  while i < self.len {
    let unit = self.data[i].to_int()
    if unit >= 0xD800 && unit <= 0xDBFF && i + 1 < self.len {
      let trail = self.data[i + 1].to_int()
      marks.push(
        (0x10000 + ((unit - 0xD800) << 10) + trail - 0xDC00).unsafe_to_char(),
      )
      i += 2
    } else {
      marks.push(unit.unsafe_to_char())
      i += 1
    }
  }
  canonical_order(marks)
  self.len = self.marks_start
  for c in marks {
    self.store(c.to_int())
  }
}

///|
/// Store one fully decomposed character with combining class `ccc`. The
/// caller has reserved two units.
fn CodeUnits::emit(self : CodeUnits, code_point : Int32, ccc : Int32) -> Unit {
  if ccc == 0 {
    if self.previous_ccc != 0 {
      self.end_marks()
    }
  } else if self.previous_ccc == 0 {
    self.marks_start = self.len
    self.previous_ccc = ccc
  } else {
    if self.previous_ccc > ccc {
      self.needs_order = true
    }
    self.previous_ccc = ccc
  }
  self.store(code_point)
}

///|
/// Decompose `s` from view-relative `start`, the last starter before the
/// first suspect character (or the view's start). Everything before `start`
/// is unchanged.
///
/// Clean starters (CCC=0, Quick_Check=Yes) are their own decomposition, and
/// no mark reorders across a starter, so clean runs are copied as they are.
/// The clean-run scanner finds where each ends: it reads a table without
/// calls, much cheaper per character than a property lookup, so it pays
/// even for the single starters between marks.
#inline(never)
fn decompose_remaining(
  s : StringView,
  start : Int32,
  shift : Int32,
  compatibility~ : Bool,
) -> String {
  let data = s.data()
  let view_start = s.start_offset()
  let view_end = view_start + s.length()
  let slow_mask = 255 | (1 << shift)
  let out : CodeUnits = {
    data: FixedArray::make(s.length() + s.length() / 2 + 16, 0),
    len: 0,
    marks_start: 0,
    previous_ccc: 0,
    needs_order: false,
  }
  out.copy(data, view_start, view_start + start)
  let mut offset = view_start + start
  while offset < view_end {
    // SAFETY: view_start <= offset < view_end <= data.length(), and the
    // trailing unit is read only when offset + 1 < view_end.
    let unit = data.unsafe_get(offset).to_int()
    let mut code_point = unit
    let mut width = 1
    if unit >= 0xD800 && unit <= 0xDBFF && offset + 1 < view_end {
      let trail = data.unsafe_get(offset + 1).to_int()
      if trail >= 0xDC00 && trail <= 0xDFFF {
        code_point = 0x10000 + ((unit - 0xD800) << 10) + trail - 0xDC00
        width = 2
      }
    }
    // An unpaired surrogate has default properties: a clean starter.
    let c = code_point.unsafe_to_char()
    let properties = normalization_properties(c)
    let ccc = properties & 255
    out.reserve(2)
    if ((properties >> shift) & 1) == 0 {
      if ccc != 0 {
        out.emit(code_point, ccc)
      } else {
        let run_end = scan_clean_run(data, offset + width, view_end, slow_mask)
        out.emit(code_point, 0)
        out.copy(data, offset + width, run_end)
        offset = run_end
        continue
      }
    } else if is_hangul_syllable(c) {
      // Conjoining jamo are starters.
      if out.previous_ccc != 0 {
        out.end_marks()
      }
      out.reserve(3)
      let s_index = code_point - hangul_s_base
      let t_index = s_index % hangul_t_count
      // Conjoining jamo are in the BMP: one unit each, stored through
      // locals as in `CodeUnits::copy`.
      let units = out.data
      let len = out.len
      // SAFETY: three units are reserved after `len`.
      units.unsafe_set(
        len,
        (hangul_l_base + s_index / hangul_n_count).to_uint16(),
      )
      units.unsafe_set(
        len + 1,
        (hangul_v_base + s_index % hangul_n_count / hangul_t_count).to_uint16(),
      )
      if t_index != 0 {
        units.unsafe_set(len + 2, (hangul_t_base + t_index).to_uint16())
        out.len = len + 3
      } else {
        out.len = len + 2
      }
    } else {
      // The character has a mapping of this form's kind, so the view is not
      // empty, and its entries carry their combining classes.
      let entries = @decomposition.packed_decomposition(
        properties,
        compatibility~,
      )
      out.reserve(2 * entries.length())
      for entry in entries {
        out.emit(entry & PackedCodePointMask, entry >> PackedCccShift)
      }
    }
    offset += width
  }
  if out.previous_ccc != 0 {
    out.end_marks()
  }
  // The result is copied here rather than in a `CodeUnits` method: on
  // wasm-gc, where moonc keeps such a method a call, NFD measured 5-20%
  // slower with it, though the loop compiled to the same instructions.
  let result = FixedArray::make(out.len, (0).to_uint16())
  result.unsafe_blit(0, out.data, 0, out.len)
  uint16_array_to_string(result)
}
