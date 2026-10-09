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
  } else {
    let start = self.chars.length()
    decompose_char(c, self.chars, compatibility~)
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
      let out = StringBuilder(size_hint=s.length())
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
/// Once a suspect character is found, consume and decompose its segment in
/// the same loop. Do not first scan the remainder and then normalize it again.
/// A character with Quick_Check=Yes and CCC=0 starts a new safe segment.
fn process_suspect_spans(
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
  // Retain the starter and any preceding marks in the first suspect segment.
  for c in s[start:problem_offset] {
    buffer.append(c, normalization_properties(c), compatibility~)
  }
  let mut span_start = start
  let mut offset = problem_offset
  let mut previous_ccc = 0
  let mut suspect = true
  for c in s[problem_offset:] {
    let properties = normalization_properties(c)
    let ccc = properties & 255
    let check = (properties >> shift) & mask
    if ccc == 0 && check == 0 {
      if suspect && !buffer.finish(s, span_start, offset, compose~, check_only~) {
        return None
      }
      span_start = offset
      suspect = false
    }
    let out_of_order = ccc != 0 && previous_ccc > ccc
    if check_only && (check == 1 || out_of_order) {
      return None
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
    return None
  }
  if buffer.output is Some(out) {
    if buffer.copied_until < s.length() {
      out.write_view(s[buffer.copied_until:])
    }
    Some(out.to_string())
  } else {
    Some(s)
  }
}

///|
/// Scan the known-normalized prefix without allocating. On the first suspect
/// character switch to local processing, keeping the preceding safe boundary.
/// None means the checking mode found a difference; normalization returns Some.
/// Offsets are UTF-16 units and are advanced only by whole code points.
fn process_spans(
  s : String,
  shift : Int,
  mask : Int,
  compatibility~ : Bool,
  compose~ : Bool,
  check_only~ : Bool,
) -> String? {
  let mut span_start = 0
  let mut offset = 0
  let mut previous_ccc = 0
  for c in s {
    if c.to_int() < 0x80 {
      span_start = offset
      offset += 1
      previous_ccc = 0
      continue
    }
    let properties = @ccc.lookup_normalization_properties(c)
    let ccc = properties & 255
    let check = (properties >> shift) & mask
    let out_of_order = ccc != 0 && previous_ccc > ccc
    if check_only && (check == 1 || out_of_order) {
      return None
    }
    if check != 0 || out_of_order {
      return process_suspect_spans(
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
    if ccc == 0 {
      span_start = offset
    }
    previous_ccc = ccc
    offset += if c.to_int() > 0xFFFF { 2 } else { 1 }
  }
  Some(s)
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
