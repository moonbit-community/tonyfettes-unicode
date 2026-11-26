///|
/// The generated kind of a code point that folds to itself.
const KindIdentity : Int32 = 0

///|
/// The generated kind of a code point whose mapping is searched in the
/// exception table.
const KindSearched : Int32 = 1

///|
/// Mask for the 7-bit folding kind in bits 0..6 of a trie entry.
const KindMask : Int32 = 0x7F

///|
/// Bit 7 of a folding trie entry:
/// - In `case_folding_kind`: `cp` or its folding has `CCC != 0` or `NFD_QC != Yes`.
/// - In `nfkc_casefold_kind`: the NFKC_CF output has `CCC != 0` or `NFC_QC != Yes`.
const NormFlagBit : Int32 = 0x80

///|
/// Whether `StringView::to_lower` uses SIMD and is faster than folding ASCII
/// directly into `FixedArray[UInt16]`. True on native and linear Wasm; on
/// Wasm-GC, direct single-pass folding into `FixedArray[UInt16]` is faster.
#cfg(any(target="native", target="wasm"))
const UseStdlibAsciiLower : Bool = true

///|
#cfg(target="wasm-gc")
const UseStdlibAsciiLower : Bool = false

///|
/// Take ownership of UTF-16 code units as a string of the same length.
#cfg(not(target="js"))
fn uint16_array_to_string(buffer : FixedArray[UInt16]) -> String = "%string.unsafe_from_uint16_fixedarray"

///|
/// Grow a UTF-16 output buffer to hold at least `required` code units.
#cfg(not(target="js"))
#inline(never)
fn grow_units(
  buffer : FixedArray[UInt16],
  len : Int32,
  required : Int32,
) -> FixedArray[UInt16] {
  let mut capacity = if buffer.length() < 16 { 16 } else { 2 * buffer.length() }
  while capacity < required {
    capacity *= 2
  }
  FixedArray::make_and_blit(buffer, allocate_len=capacity, init=0, len~)
}

///|
/// Convert the first `len` code units of `buffer` into a `String`, taking
/// ownership without copying when `len == buffer.length()`.
#cfg(not(target="js"))
fn finish_units(buffer : FixedArray[UInt16], len : Int32) -> String {
  if len == buffer.length() {
    uint16_array_to_string(buffer)
  } else {
    let exact = FixedArray::make(len, (0).to_uint16())
    exact.unsafe_blit(0, buffer, 0, len)
    uint16_array_to_string(exact)
  }
}

///|
/// Skip UTF-16 code units below 0x80 starting at `start`, returning the first
/// offset at or above `start` with a unit >= 0x80, or `end`.
#cfg(target="native")
#warnings("-alert_experimental")
fn skip_ascii_units(s : String, start : Int32, end : Int32) -> Int32 {
  let below = @v128.i16x8_splat((0x7F).to_uint16())
  let mut offset = start
  while end - offset >= 16 {
    // SAFETY: sixteen units remain before `end <= s.length()`.
    let excess = @v128.v128_or_(
      @v128.i16x8_sub_sat_u(@v128.v128_load_i16x8(s, offset), below),
      @v128.i16x8_sub_sat_u(@v128.v128_load_i16x8(s, offset + 8), below),
    )
    if @v128.v128_any_true(excess) {
      break
    }
    offset += 16
  }
  while end - offset >= 8 {
    // SAFETY: eight units remain before `end <= s.length()`.
    let excess = @v128.i16x8_sub_sat_u(@v128.v128_load_i16x8(s, offset), below)
    if @v128.v128_any_true(excess) {
      break
    }
    offset += 8
  }
  while offset < end && s.unsafe_get(offset).to_int() < 0x80 {
    offset += 1
  }
  offset
}

///|
#cfg(target="wasm")
#warnings("-alert_experimental")
fn skip_ascii_units(s : String, start : Int32, end : Int32) -> Int32 {
  let limit = @v128.i16x8_splat((0x80).to_uint16())
  let mut offset = start
  while end - offset >= 8 {
    // SAFETY: eight units remain before `end <= s.length()`.
    let block = @v128.v128_load_i16x8(s, offset)
    if @v128.v128_any_true(@v128.i16x8_ge_u(block, limit)) {
      break
    }
    offset += 8
  }
  while offset < end && s.unsafe_get(offset).to_int() < 0x80 {
    offset += 1
  }
  offset
}

///|
#cfg(target="wasm-gc")
fn skip_ascii_units(s : String, start : Int32, end : Int32) -> Int32 {
  let mut offset = start
  while end - offset >= 4 {
    // SAFETY: four units remain before `end <= s.length()`.
    let units = s.unsafe_get(offset) |
      s.unsafe_get(offset + 1) |
      s.unsafe_get(offset + 2) |
      s.unsafe_get(offset + 3)
    if units.to_int() >= 0x80 {
      break
    }
    offset += 4
  }
  while offset < end && s.unsafe_get(offset).to_int() < 0x80 {
    offset += 1
  }
  offset
}

///|
/// Branchless BMP lookup for full case folding (`unit` in `0..0xFFFF`).
#inline
fn case_fold_bmp_val(unit : Int32) -> Int32 {
  let block = case_folding_kind_bmp_index.unsafe_get(unit >> 6).to_int()
  case_folding_kind_bmp_leaf.unsafe_get((block << 6) | (unit & 63)).to_int()
}

///|
/// Branchless BMP lookup for NFKC_Casefold (`unit` in `0..0xFFFF`).
#inline
fn nfkc_bmp_val(unit : Int32) -> Int32 {
  let block = nfkc_casefold_kind_bmp_index.unsafe_get(unit >> 6).to_int()
  nfkc_casefold_kind_bmp_leaf.unsafe_get((block << 6) | (unit & 63)).to_int()
}

///|
/// Whether at least 8 units remain and the next four units starting at
/// `data[pos]` are all ASCII (`< 0x80`), justifying SIMD ASCII skipping.
#cfg(not(target="js"))
#inline
fn has_ascii_run(data : String, pos : Int32, view_end : Int32) -> Bool {
  view_end - pos >= 8 &&
  (
    data.unsafe_get(pos + 1) |
    data.unsafe_get(pos + 2) |
    data.unsafe_get(pos + 3)
  ) <
  0x80
}

///|
/// Sparse probe for a >= 16-unit ASCII run on JS before invoking sticky RegExp.
#cfg(target="js")
#inline
fn has_js_ascii_run(data : String, pos : Int32, view_end : Int32) -> Bool {
  view_end - pos >= 16 &&
  (
    data.unsafe_get(pos + 1) |
    data.unsafe_get(pos + 2) |
    data.unsafe_get(pos + 4) |
    data.unsafe_get(pos + 8) |
    data.unsafe_get(pos + 15)
  ) <
  0x80
}

///|
/// Skip runs of four already-folded ASCII code units (no `A-Z`, no `>= 0x80`).
#cfg(not(target="js"))
fn skip_clean_ascii_quads(data : String, start : Int32, end : Int32) -> Int32 {
  let mut offset = start
  while end - offset >= 4 {
    let u0 = data.unsafe_get(offset).to_int()
    let u1 = data.unsafe_get(offset + 1).to_int()
    let u2 = data.unsafe_get(offset + 2).to_int()
    let u3 = data.unsafe_get(offset + 3).to_int()
    if (u0 | u1 | u2 | u3) < 0x80 &&
      (u0 - 65).reinterpret_as_uint() >= 26 &&
      (u1 - 65).reinterpret_as_uint() >= 26 &&
      (u2 - 65).reinterpret_as_uint() >= 26 &&
      (u3 - 65).reinterpret_as_uint() >= 26 {
      offset += 4
    } else {
      break
    }
  }
  offset
}

///|
/// Skip runs of four BMP code units (`< 0xD800`) whose full case-folding kind
/// is `KindIdentity` (ignoring `NormFlagBit`, so Hanzi, Kana, and Hangul all
/// stay on the quad fast path).
#cfg(any(target="native", target="wasm"))
fn skip_identity_fold_quads(
  data : String,
  start : Int32,
  view_end : Int32,
) -> Int32 {
  for pos = start {
    match data.unsafe_view(start=pos, end=view_end) {
      [
        '\u{0000}'..<='\u{d7ff}' as c0,
        '\u{0000}'..<='\u{d7ff}' as c1,
        '\u{0000}'..<='\u{d7ff}' as c2,
        '\u{0000}'..<='\u{d7ff}' as c3,
        ..,
      ] if (
          (
            case_fold_bmp_val(c0.to_int()) |
            case_fold_bmp_val(c1.to_int()) |
            case_fold_bmp_val(c2.to_int()) |
            case_fold_bmp_val(c3.to_int())
          ) &
          KindMask
        ) ==
        0 => continue pos + 4
      _ => break pos
    }
  }
}

///|
/// Skip runs of four BMP code units (`< 0xD800`) whose full case-folding leaf
/// byte is 0 (`KindIdentity` and `NormFlagBit == 0`).
#cfg(any(target="native", target="wasm"))
fn skip_clean_canonical_quads(
  data : String,
  start : Int32,
  view_end : Int32,
) -> Int32 {
  for pos = start {
    match data.unsafe_view(start=pos, end=view_end) {
      [
        '\u{0000}'..<='\u{d7ff}' as c0,
        '\u{0000}'..<='\u{d7ff}' as c1,
        '\u{0000}'..<='\u{d7ff}' as c2,
        '\u{0000}'..<='\u{d7ff}' as c3,
        ..,
      ] if (
          case_fold_bmp_val(c0.to_int()) |
          case_fold_bmp_val(c1.to_int()) |
          case_fold_bmp_val(c2.to_int()) |
          case_fold_bmp_val(c3.to_int())
        ) ==
        0 => continue pos + 4
      _ => break pos
    }
  }
}

///|
/// Skip runs of four BMP code units (`< 0xD800`) whose NFKC_Casefold leaf byte
/// is 0 (`KindIdentity` and `NormFlagBit == 0`). Reads the leaf directly so
/// blocks like U+3000..U+30FF (mostly clean Kana/punctuation) stay on the quad
/// fast path.
#cfg(any(target="native", target="wasm"))
fn skip_clean_nfkc_quads(
  data : String,
  start : Int32,
  view_end : Int32,
) -> Int32 {
  for pos = start {
    match data.unsafe_view(start=pos, end=view_end) {
      [
        '\u{0000}'..<='\u{d7ff}' as c0,
        '\u{0000}'..<='\u{d7ff}' as c1,
        '\u{0000}'..<='\u{d7ff}' as c2,
        '\u{0000}'..<='\u{d7ff}' as c3,
        ..,
      ] if (
          nfkc_bmp_val(c0.to_int()) |
          nfkc_bmp_val(c1.to_int()) |
          nfkc_bmp_val(c2.to_int()) |
          nfkc_bmp_val(c3.to_int())
        ) ==
        0 => continue pos + 4
      _ => break pos
    }
  }
}

///|
#cfg(not(any(target="js", target="native", target="wasm")))
#inline
fn skip_identity_fold_quads(
  _data : String,
  start : Int32,
  _view_end : Int32,
) -> Int32 {
  start
}

///|
#cfg(not(any(target="js", target="native", target="wasm")))
#inline
fn skip_clean_canonical_quads(
  _data : String,
  start : Int32,
  _view_end : Int32,
) -> Int32 {
  start
}

///|
#cfg(not(any(target="js", target="native", target="wasm")))
#inline
fn skip_clean_nfkc_quads(
  _data : String,
  start : Int32,
  _view_end : Int32,
) -> Int32 {
  start
}

///|
/// End offset of the ASCII run (`[\x00-\x7f]*`) in `s` starting at `start`.
#cfg(target="js")
extern "js" fn js_ascii_run_end(s : String, start : Int32) -> Int32 =
  #|(() => {
  #|  const re = /[\x00-\x7f]*/y;
  #|  return (s, start) => {
  #|    re.lastIndex = start;
  #|    re.test(s);
  #|    return re.lastIndex;
  #|  };
  #|})()

///|
/// End offset of the already-folded ASCII run (no A-Z, no >= 0x80) starting at `start`.
#cfg(target="js")
extern "js" fn js_clean_ascii_end(s : String, start : Int32) -> Int32 =
  #|(() => {
  #|  const re = /[\x00-\x40\x5b-\x7f]*/y;
  #|  return (s, start) => {
  #|    re.lastIndex = start;
  #|    re.test(s);
  #|    return re.lastIndex;
  #|  };
  #|})()

///|
/// Built-in JS lowercase for a slice proven to be pure ASCII.
#cfg(target="js")
extern "js" fn js_ascii_to_lower(
  s : String,
  start : Int32,
  end : Int32,
) -> String =
  #|(s, start, end) => (start === 0 && end === s.length ? s : s.slice(start, end)).toLowerCase()

///|
/// Decode the code point at `offset` in `data` (bounded by `end`).
/// An unpaired surrogate is returned as it is.
fn decode_cp(data : String, offset : Int32, end : Int32) -> Int32 {
  // SAFETY: callers guarantee 0 <= offset < end <= data.length().
  let first = data.unsafe_get(offset).to_int()
  if first >= 0xD800 && first <= 0xDBFF && offset + 1 < end {
    let second = data.unsafe_get(offset + 1).to_int()
    if second >= 0xDC00 && second <= 0xDFFF {
      return 0x10000 + ((first - 0xD800) << 10) + second - 0xDC00
    }
  }
  first
}

///|
/// Simple single-code-point full folding of `cp`, returning `-1` when `cp`
/// has a multi-character mapping (`KindSearched`).
fn simple_fold_sentinel(cp : Int32) -> Int32 {
  if cp < 0x80 {
    return if (cp - 65).reinterpret_as_uint() < 26 { cp + 32 } else { cp }
  }
  let kind = case_folding_kind(cp) & KindMask
  if kind == KindIdentity {
    cp
  } else if kind == KindSearched {
    -1
  } else {
    // SAFETY: generator verified every kind in 0..case_folding_deltas.length().
    cp + case_folding_deltas.unsafe_get(kind)
  }
}

///|
/// Unicode default full case folding (section 3.13, R4).
/// Locale-independent: uses the C and F mappings in CaseFolding.txt, including
/// expansions such as ß -> ss. Does not normalize or apply Turkic tailoring.
#cfg(not(target="js"))
pub fn case_fold(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let length = s.length()
  let end = base + length
  let mut offset = base
  while offset < end {
    // SAFETY: base <= offset < end <= data.length().
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        if UseStdlibAsciiLower {
          // First change is ASCII A-Z: let the stdlib's vectorized `to_lower`
          // handle all ASCII in bulk, then scan only non-ASCII code points.
          let mapped = s.to_lower().to_owned()
          let first_non_ascii = first_non_ascii_change_full(
            mapped,
            offset - base + 1,
            length,
          )
          return if first_non_ascii == length {
            mapped
          } else {
            fold_full_units(mapped, 0, length, first_non_ascii)
          }
        }
        return fold_full_units(data, base, end, offset)
      }
      offset = skip_clean_ascii_quads(data, offset + 1, end)
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      if (case_fold_bmp_val(unit) & KindMask) != KindIdentity {
        return fold_full_units(data, base, end, offset)
      }
      offset = skip_identity_fold_quads(data, offset + 1, end)
      continue
    }
    let cp = decode_cp(data, offset, end)
    if (case_folding_kind(cp) & KindMask) != KindIdentity {
      return fold_full_units(data, base, end, offset)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  s.to_owned()
}

///|
/// First offset >= `start` in an ASCII-lowercased `String` where a non-ASCII
/// character changes under full case folding, or `end` if none changes.
#cfg(not(target="js"))
fn first_non_ascii_change_full(s : String, start : Int32, end : Int32) -> Int32 {
  let mut offset = skip_ascii_units(s, start, end)
  while offset < end {
    let unit = s.unsafe_get(offset).to_int()
    if unit < 0x80 {
      offset = if has_ascii_run(s, offset, end) {
        skip_ascii_units(s, offset + 4, end)
      } else {
        offset + 1
      }
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      if (case_fold_bmp_val(unit) & KindMask) != KindIdentity {
        return offset
      }
      offset = skip_identity_fold_quads(s, offset + 1, end)
      continue
    }
    let cp = decode_cp(s, offset, end)
    if (case_folding_kind(cp) & KindMask) != KindIdentity {
      return offset
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  end
}

///|
/// Fold `data[base:end]` starting from `first_change`, writing UTF-16 code
/// units directly into a `FixedArray[UInt16]`. When every mapping preserves
/// UTF-16 length (all ASCII and BMP/supplementary deltas), the buffer becomes
/// the returned `String` with zero extra copy.
#cfg(not(target="js"))
#inline(never)
fn fold_full_units(
  data : String,
  base : Int32,
  end : Int32,
  first_change : Int32,
) -> String {
  let length = end - base
  let mut out : FixedArray[UInt16] = FixedArray::make(length, 0)
  let mut cap = length
  let prefix_len = first_change - base
  for i in 0..<prefix_len {
    out.unsafe_set(i, data.unsafe_get(base + i))
  }
  let mut out_len = prefix_len
  let mut offset = first_change
  // Invariant: `cap - out_len >= end - offset`, so ASCII, identity, and
  // delta mappings never need a capacity check.
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      let folded = if (unit - 65).reinterpret_as_uint() < 26 {
        unit + 32
      } else {
        unit
      }
      out.unsafe_set(out_len, folded.to_uint16())
      out_len += 1
      offset += 1
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let kind = case_fold_bmp_val(unit) & KindMask
      if kind == KindIdentity {
        out.unsafe_set(out_len, unit.to_uint16())
        out_len += 1
      } else if kind >= 2 {
        // SAFETY: generator verified BMP deltas remain in BMP and kind < deltas.length().
        out.unsafe_set(
          out_len,
          (unit + case_folding_deltas.unsafe_get(kind)).to_uint16(),
        )
        out_len += 1
      } else if lookup_case_folding(unit) is Some(mapping) {
        let mlen = mapping.length()
        if mlen > 1 {
          let needed = out_len + mlen + (end - offset - 1)
          if needed > cap {
            out = grow_units(out, out_len, needed)
            cap = out.length()
          }
        }
        let mdata = mapping.data()
        let mbase = mapping.start_offset()
        for j in 0..<mlen {
          out.unsafe_set(out_len + j, mdata.unsafe_get(mbase + j))
        }
        out_len += mlen
      } else {
        out.unsafe_set(out_len, unit.to_uint16())
        out_len += 1
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    let width = if cp >= 0x10000 { 2 } else { 1 }
    let kind = case_folding_kind(cp) & KindMask
    if kind == KindIdentity {
      out.unsafe_set(out_len, unit.to_uint16())
      if width == 2 {
        out.unsafe_set(out_len + 1, data.unsafe_get(offset + 1))
      }
      out_len += width
    } else if kind >= 2 {
      let target = cp + case_folding_deltas.unsafe_get(kind)
      if target < 0x10000 {
        out.unsafe_set(out_len, target.to_uint16())
        out_len += 1
      } else {
        let t = target - 0x10000
        out.unsafe_set(out_len, (0xD800 + (t >> 10)).to_uint16())
        out.unsafe_set(out_len + 1, (0xDC00 + (t & 0x3FF)).to_uint16())
        out_len += 2
      }
    } else if lookup_case_folding(cp) is Some(mapping) {
      let mlen = mapping.length()
      if mlen > width {
        let needed = out_len + mlen + (end - offset - width)
        if needed > cap {
          out = grow_units(out, out_len, needed)
          cap = out.length()
        }
      }
      let mdata = mapping.data()
      let mbase = mapping.start_offset()
      for j in 0..<mlen {
        out.unsafe_set(out_len + j, mdata.unsafe_get(mbase + j))
      }
      out_len += mlen
    } else {
      out.unsafe_set(out_len, unit.to_uint16())
      if width == 2 {
        out.unsafe_set(out_len + 1, data.unsafe_get(offset + 1))
      }
      out_len += width
    }
    offset += width
  }
  finish_units(out, out_len)
}

///|
/// Unicode default full case folding (section 3.13, R4).
/// Locale-independent: uses the C and F mappings in CaseFolding.txt, including
/// expansions such as ß -> ss. Does not normalize or apply Turkic tailoring.
#cfg(target="js")
pub fn case_fold(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let length = s.length()
  let end = base + length
  if length == 0 {
    return ""
  }
  if data.unsafe_get(base) < 0x80 && js_ascii_run_end(data, base) >= end {
    return js_ascii_to_lower(data, base, end)
  }
  let mut offset = base
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        return fold_full_js(data, base, end, offset)
      }
      if has_js_ascii_run(data, offset, end) {
        offset = js_clean_ascii_end(data, offset + 1)
        if offset > end {
          offset = end
        }
      } else {
        offset += 1
      }
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      if (case_fold_bmp_val(unit) & KindMask) != KindIdentity {
        return fold_full_js(data, base, end, offset)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if (case_folding_kind(cp) & KindMask) != KindIdentity {
      return fold_full_js(data, base, end, offset)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  s.to_owned()
}

///|
#cfg(target="js")
fn fold_full_js(
  data : String,
  base : Int32,
  end : Int32,
  first_change : Int32,
) -> String {
  let out = StringBuilder(capacity=end - base)
  let mut copied = base
  let mut offset = first_change
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if has_js_ascii_run(data, offset, end) {
        let mut ascii_end = js_ascii_run_end(data, offset)
        if ascii_end > end {
          ascii_end = end
        }
        if ascii_end - offset >= 16 {
          let clean_end = js_clean_ascii_end(data, offset)
          if clean_end < ascii_end {
            if copied < clean_end {
              out.write_view(data.unsafe_view(start=copied, end=clean_end))
            }
            out.write_string(js_ascii_to_lower(data, clean_end, ascii_end))
            copied = ascii_end
          }
          offset = ascii_end
          continue
        }
      }
      if (unit - 65).reinterpret_as_uint() < 26 {
        if copied < offset {
          out.write_view(data.unsafe_view(start=copied, end=offset))
        }
        out.write_char((unit + 32).unsafe_to_char())
        copied = offset + 1
      }
      offset += 1
      continue
    }
    let cp = if unit < 0xD800 || unit > 0xDBFF {
      unit
    } else {
      decode_cp(data, offset, end)
    }
    let width = if cp >= 0x10000 { 2 } else { 1 }
    let kind = if width == 1 {
      case_fold_bmp_val(cp) & KindMask
    } else {
      case_folding_kind(cp) & KindMask
    }
    if kind != KindIdentity {
      if copied < offset {
        out.write_view(data.unsafe_view(start=copied, end=offset))
      }
      if kind >= 2 {
        out.write_char(
          (cp + case_folding_deltas.unsafe_get(kind)).unsafe_to_char(),
        )
      } else if lookup_case_folding(cp) is Some(mapping) {
        out.write_view(mapping)
      } else {
        out.write_char(cp.unsafe_to_char())
      }
      copied = offset + width
    }
    offset += width
  }
  if copied < end {
    out.write_view(data.unsafe_view(start=copied, end~))
  }
  out.to_string()
}
