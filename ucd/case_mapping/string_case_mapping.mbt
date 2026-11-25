///|
/// Whether `StringView::to_upper` / `StringView::to_lower` use SIMD and are
/// faster than mapping ASCII directly into `FixedArray[UInt16]`. True on
/// native and linear Wasm; on Wasm-GC, direct single-pass mapping into
/// `FixedArray[UInt16]` is faster.
#cfg(any(target="native", target="wasm"))
const UseStdlibAsciiCase : Bool = true

///|
#cfg(target="wasm-gc")
const UseStdlibAsciiCase : Bool = false

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
/// Copy `len` UTF-16 code units from `src[src_offset..]` to `dst[dst_offset..]`.
#cfg(not(target="js"))
fn copy_units(
  dst : FixedArray[UInt16],
  dst_offset : Int32,
  src : String,
  src_offset : Int32,
  len : Int32,
) -> Unit {
  for i in 0..<len {
    // SAFETY: callers guarantee both ranges are in bounds.
    dst.unsafe_set(dst_offset + i, src.unsafe_get(src_offset + i))
  }
}

///|
/// Write a supplementary code point (`target >= 0x10000`) as a UTF-16 surrogate
/// pair at `out[out_len..out_len+2]`.
#cfg(not(target="js"))
fn write_supp_cp(
  out : FixedArray[UInt16],
  out_len : Int32,
  target : Int32,
) -> Unit {
  let t = target - 0x10000
  out.unsafe_set(out_len, (0xD800 + (t >> 10)).to_uint16())
  out.unsafe_set(out_len + 1, (0xDC00 + (t & 0x3FF)).to_uint16())
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
/// Skip ASCII code units (< 0x80) that are not in `'a'..'z'` starting at `start`.
#cfg(any(target="native", target="wasm"))
#warnings("-alert_experimental")
fn skip_clean_upper_ascii(s : String, start : Int32, end : Int32) -> Int32 {
  let below = @v128.i16x8_splat((0x7F).to_uint16())
  let lo_a = @v128.i16x8_splat((97).to_uint16())
  let span = @v128.i16x8_splat((26).to_uint16())
  let mut offset = start
  while end - offset >= 8 {
    // SAFETY: eight units remain before `end <= s.length()`.
    let block = @v128.v128_load_i16x8(s, offset)
    let non_ascii = @v128.i16x8_sub_sat_u(block, below)
    let is_lower = @v128.i16x8_lt_u(@v128.i16x8_sub(block, lo_a), span)
    if @v128.v128_any_true(@v128.v128_or_(non_ascii, is_lower)) {
      break
    }
    offset += 8
  }
  while offset < end {
    let unit = s.unsafe_get(offset).to_int()
    if unit < 0x80 && (unit - 97).reinterpret_as_uint() >= 26 {
      offset += 1
    } else {
      break
    }
  }
  offset
}

///|
#cfg(target="wasm-gc")
fn skip_clean_upper_ascii(s : String, start : Int32, end : Int32) -> Int32 {
  let mut offset = start
  while end - offset >= 4 {
    let u0 = s.unsafe_get(offset).to_int()
    let u1 = s.unsafe_get(offset + 1).to_int()
    let u2 = s.unsafe_get(offset + 2).to_int()
    let u3 = s.unsafe_get(offset + 3).to_int()
    if (u0 | u1 | u2 | u3) < 0x80 &&
      (u0 - 97).reinterpret_as_uint() >= 26 &&
      (u1 - 97).reinterpret_as_uint() >= 26 &&
      (u2 - 97).reinterpret_as_uint() >= 26 &&
      (u3 - 97).reinterpret_as_uint() >= 26 {
      offset += 4
    } else {
      break
    }
  }
  while offset < end {
    let unit = s.unsafe_get(offset).to_int()
    if unit < 0x80 && (unit - 97).reinterpret_as_uint() >= 26 {
      offset += 1
    } else {
      break
    }
  }
  offset
}

///|
/// Skip ASCII code units (< 0x80) that are not in `'A'..'Z'` starting at `start`.
#cfg(any(target="native", target="wasm"))
#warnings("-alert_experimental")
fn skip_clean_lower_ascii(s : String, start : Int32, end : Int32) -> Int32 {
  let below = @v128.i16x8_splat((0x7F).to_uint16())
  let hi_a = @v128.i16x8_splat((65).to_uint16())
  let span = @v128.i16x8_splat((26).to_uint16())
  let mut offset = start
  while end - offset >= 8 {
    // SAFETY: eight units remain before `end <= s.length()`.
    let block = @v128.v128_load_i16x8(s, offset)
    let non_ascii = @v128.i16x8_sub_sat_u(block, below)
    let is_upper = @v128.i16x8_lt_u(@v128.i16x8_sub(block, hi_a), span)
    if @v128.v128_any_true(@v128.v128_or_(non_ascii, is_upper)) {
      break
    }
    offset += 8
  }
  while offset < end {
    let unit = s.unsafe_get(offset).to_int()
    if unit < 0x80 && (unit - 65).reinterpret_as_uint() >= 26 {
      offset += 1
    } else {
      break
    }
  }
  offset
}

///|
#cfg(target="wasm-gc")
fn skip_clean_lower_ascii(s : String, start : Int32, end : Int32) -> Int32 {
  let mut offset = start
  while end - offset >= 4 {
    let u0 = s.unsafe_get(offset).to_int()
    let u1 = s.unsafe_get(offset + 1).to_int()
    let u2 = s.unsafe_get(offset + 2).to_int()
    let u3 = s.unsafe_get(offset + 3).to_int()
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
  while offset < end {
    let unit = s.unsafe_get(offset).to_int()
    if unit < 0x80 && (unit - 65).reinterpret_as_uint() >= 26 {
      offset += 1
    } else {
      break
    }
  }
  offset
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
/// End offset of the already-uppercase ASCII run (no a-z, no >= 0x80) starting at `start`.
#cfg(target="js")
extern "js" fn js_clean_upper_ascii_end(s : String, start : Int32) -> Int32 =
  #|(() => {
  #|  const re = /[\x00-\x60\x7b-\x7f]*/y;
  #|  return (s, start) => {
  #|    re.lastIndex = start;
  #|    re.test(s);
  #|    return re.lastIndex;
  #|  };
  #|})()

///|
/// End offset of the already-lowercase ASCII run (no A-Z, no >= 0x80) starting at `start`.
#cfg(target="js")
extern "js" fn js_clean_lower_ascii_end(s : String, start : Int32) -> Int32 =
  #|(() => {
  #|  const re = /[\x00-\x40\x5b-\x7f]*/y;
  #|  return (s, start) => {
  #|    re.lastIndex = start;
  #|    re.test(s);
  #|    return re.lastIndex;
  #|  };
  #|})()

///|
/// Built-in JS uppercase, used only on spans proven to be pure ASCII.
#cfg(target="js")
extern "js" fn js_to_upper(s : String) -> String =
  #|(s) => s.toUpperCase()

///|
/// Built-in JS lowercase, used only on spans proven to be pure ASCII.
#cfg(target="js")
extern "js" fn js_to_lower(s : String) -> String =
  #|(s) => s.toLowerCase()

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
/// Unicode Final_Sigma context, evaluated only at a capital Σ (`data[offset]`).
/// Ignorable characters must be skipped before testing Cased: U+0345 has both
/// properties. ASCII pre-mapping preserves these properties, so the native/Wasm
/// path can inspect its ASCII-mapped string without changing the context.
///
/// Σ itself is not ignorable. Each ignorable run is scanned at most once from
/// either end, keeping the complete conversion linear without a character array.
#inline(never)
fn final_sigma_slice(
  data : String,
  base : Int32,
  end : Int32,
  offset : Int32,
) -> Bool {
  let preceded_by_cased = for pos = offset; pos > base; {
    let mut start = pos - 1
    // SAFETY: base <= start < pos <= offset < end <= data.length(). Do not pair
    // a trailing surrogate with a code unit outside this slice's `base`.
    if data.unsafe_get(start).is_trailing_surrogate() &&
      start > base &&
      data.unsafe_get(start - 1).is_leading_surrogate() {
      start -= 1
    }
    let c = decode_cp(data, start, pos).unsafe_to_char()
    if !is_case_ignorable(c) {
      break is_cased(c)
    }
    continue start
  } nobreak {
    false
  }
  if !preceded_by_cased {
    return false
  }
  // The caller found a BMP Σ, so the following code point starts at offset + 1.
  for pos = offset + 1; pos < end; {
    let cp = decode_cp(data, pos, end)
    let c = cp.unsafe_to_char()
    if !is_case_ignorable(c) {
      return !is_cased(c)
    }
    continue pos + (if cp >= 0x10000 { 2 } else { 1 })
  }
  true
}

///|
/// Full uppercase mapping of a string: every code point is replaced with its
/// full uppercase mapping, as `full_uppercase` gives it, so "Straße" becomes
/// "STRASSE". Builds one string, with nothing allocated per character.
///
/// Context-free: the conditional mappings of SpecialCasing.txt, which depend
/// on the surrounding text or on the language, are not applied. Unpaired
/// surrogates are copied as they are.
#cfg(not(target="js"))
pub fn uppercase(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let length = s.length()
  let end = base + length
  let mut offset = base
  while offset < end {
    // SAFETY: base <= offset < end <= data.length().
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 97).reinterpret_as_uint() < 26 {
        if UseStdlibAsciiCase {
          let mapped = s.to_upper().to_owned()
          let first_non_ascii = first_non_ascii_upper_change(
            mapped,
            offset - base + 1,
            length,
          )
          return if first_non_ascii == length {
            mapped
          } else {
            map_non_ascii_upper(mapped, first_non_ascii)
          }
        }
        return map_upper_units(data, base, end, offset)
      }
      offset = skip_clean_upper_ascii(data, offset + 1, end)
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let record = lookup_case_record_bmp(unit)
      if record != 0 && case_full_upper_deltas.unsafe_get(record) != 0 {
        return map_upper_units(data, base, end, offset)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp >= 0x10000 {
      let record = lookup_case_record_supp(cp)
      if record != 0 && case_full_upper_deltas.unsafe_get(record) != 0 {
        return map_upper_units(data, base, end, offset)
      }
      offset += 2
    } else {
      offset += 1
    }
  }
  s.to_owned()
}

///|
/// First offset >= `start` in an ASCII-uppercased `String` where a non-ASCII
/// character changes under full uppercase, or `end` if none changes.
#cfg(not(target="js"))
fn first_non_ascii_upper_change(
  s : String,
  start : Int32,
  end : Int32,
) -> Int32 {
  let mut offset = skip_ascii_units(s, start, end)
  while offset < end {
    let unit = s.unsafe_get(offset).to_int()
    if unit < 0x80 {
      offset = skip_ascii_units(s, offset + 1, end)
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let record = lookup_case_record_bmp(unit)
      if record != 0 && case_full_upper_deltas.unsafe_get(record) != 0 {
        return offset
      }
      offset += 1
      continue
    }
    let cp = decode_cp(s, offset, end)
    if cp >= 0x10000 {
      let record = lookup_case_record_supp(cp)
      if record != 0 && case_full_upper_deltas.unsafe_get(record) != 0 {
        return offset
      }
      offset += 2
    } else {
      offset += 1
    }
  }
  end
}

///|
/// Map non-ASCII characters of an already ASCII-uppercased string `mapped`
/// starting from `first_change`, writing directly into `FixedArray[UInt16]`.
#cfg(not(target="js"))
#inline(never)
fn map_non_ascii_upper(mapped : String, first_change : Int32) -> String {
  let length = mapped.length()
  let mut out : FixedArray[UInt16] = FixedArray::make(length, 0)
  let mut cap = length
  copy_units(out, 0, mapped, 0, first_change)
  let mut out_len = first_change
  let mut offset = first_change
  // Invariant: `cap - out_len >= length - offset`, so ASCII, identity, and
  // simple delta mappings never need a capacity check.
  while offset < length {
    let unit = mapped.unsafe_get(offset).to_int()
    if unit < 0x80 {
      out.unsafe_set(out_len, unit.to_uint16())
      out_len += 1
      offset += 1
      if offset < length && mapped.unsafe_get(offset).to_int() < 0x80 {
        let run_end = skip_ascii_units(mapped, offset, length)
        let run_len = run_end - offset
        copy_units(out, out_len, mapped, offset, run_len)
        out_len += run_len
        offset = run_end
      }
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      // SAFETY: generator verified record bounds and BMP delta closure.
      let delta = case_full_upper_deltas.unsafe_get(
        lookup_case_record_bmp(unit),
      )
      if delta < CaseSpecialSentinel {
        out.unsafe_set(out_len, (unit + delta).to_uint16())
        out_len += 1
      } else {
        let found = find_special_upper(unit)
        if found >= 0 {
          let mapping = special_upper_strings[found]
          let mlen = mapping.length()
          if mlen > 1 {
            let needed = out_len + mlen + (length - offset - 1)
            if needed > cap {
              out = grow_units(out, out_len, needed)
              cap = out.length()
            }
          }
          copy_units(out, out_len, mapping, 0, mlen)
          out_len += mlen
        } else {
          out.unsafe_set(out_len, unit.to_uint16())
          out_len += 1
        }
      }
      offset += 1
      continue
    }
    let cp = decode_cp(mapped, offset, length)
    if cp < 0x10000 {
      out.unsafe_set(out_len, unit.to_uint16())
      out_len += 1
      offset += 1
      continue
    }
    // SAFETY: generator verified record bounds and supplementary delta closure.
    let delta = case_full_upper_deltas.unsafe_get(lookup_case_record_supp(cp))
    if delta < CaseSpecialSentinel {
      write_supp_cp(out, out_len, cp + delta)
      out_len += 2
    } else {
      let found = find_special_upper(cp)
      if found >= 0 {
        let mapping = special_upper_strings[found]
        let mlen = mapping.length()
        if mlen > 2 {
          let needed = out_len + mlen + (length - offset - 2)
          if needed > cap {
            out = grow_units(out, out_len, needed)
            cap = out.length()
          }
        }
        copy_units(out, out_len, mapping, 0, mlen)
        out_len += mlen
      } else {
        write_supp_cp(out, out_len, cp)
        out_len += 2
      }
    }
    offset += 2
  }
  finish_units(out, out_len)
}

///|
/// Single-pass full uppercase of `data[base:end]` starting from `first_change`,
/// writing UTF-16 code units directly into a `FixedArray[UInt16]`.
#cfg(not(target="js"))
#inline(never)
fn map_upper_units(
  data : String,
  base : Int32,
  end : Int32,
  first_change : Int32,
) -> String {
  let length = end - base
  let mut out : FixedArray[UInt16] = FixedArray::make(length, 0)
  let mut cap = length
  let prefix_len = first_change - base
  copy_units(out, 0, data, base, prefix_len)
  let mut out_len = prefix_len
  let mut offset = first_change
  // Invariant: `cap - out_len >= end - offset`, so ASCII, identity, and
  // simple delta mappings never need a capacity check.
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      // Branchless ASCII a-z -> A-Z: avoids branch mispredictions on English prose.
      let mapped = unit - (((((unit - 97) | (122 - unit)) >> 31) + 1) << 5)
      out.unsafe_set(out_len, mapped.to_uint16())
      out_len += 1
      offset += 1
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      // SAFETY: generator verified record bounds and BMP delta closure.
      let delta = case_full_upper_deltas.unsafe_get(
        lookup_case_record_bmp(unit),
      )
      if delta < CaseSpecialSentinel {
        out.unsafe_set(out_len, (unit + delta).to_uint16())
        out_len += 1
      } else {
        let found = find_special_upper(unit)
        if found >= 0 {
          let mapping = special_upper_strings[found]
          let mlen = mapping.length()
          if mlen > 1 {
            let needed = out_len + mlen + (end - offset - 1)
            if needed > cap {
              out = grow_units(out, out_len, needed)
              cap = out.length()
            }
          }
          copy_units(out, out_len, mapping, 0, mlen)
          out_len += mlen
        } else {
          out.unsafe_set(out_len, unit.to_uint16())
          out_len += 1
        }
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp < 0x10000 {
      out.unsafe_set(out_len, unit.to_uint16())
      out_len += 1
      offset += 1
      continue
    }
    // SAFETY: generator verified record bounds and supplementary delta closure.
    let delta = case_full_upper_deltas.unsafe_get(lookup_case_record_supp(cp))
    if delta < CaseSpecialSentinel {
      write_supp_cp(out, out_len, cp + delta)
      out_len += 2
    } else {
      let found = find_special_upper(cp)
      if found >= 0 {
        let mapping = special_upper_strings[found]
        let mlen = mapping.length()
        if mlen > 2 {
          let needed = out_len + mlen + (end - offset - 2)
          if needed > cap {
            out = grow_units(out, out_len, needed)
            cap = out.length()
          }
        }
        copy_units(out, out_len, mapping, 0, mlen)
        out_len += mlen
      } else {
        write_supp_cp(out, out_len, cp)
        out_len += 2
      }
    }
    offset += 2
  }
  finish_units(out, out_len)
}

///|
/// Unicode default full lowercase conversion of a string, including the
/// context-dependent Final_Sigma mapping: "ΟΣ" becomes "ος", while "ΟΣΑ"
/// becomes "οσα". Full mappings can expand characters, so "İ" becomes
/// "i\u{0307}". Language-specific mappings are not applied. Unpaired
/// surrogates are copied as they are.
#cfg(not(target="js"))
pub fn lowercase(s : StringView) -> String {
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
        if UseStdlibAsciiCase {
          let mapped = s.to_lower().to_owned()
          let first_non_ascii = first_non_ascii_lower_change(
            mapped,
            offset - base + 1,
            length,
          )
          return if first_non_ascii == length {
            mapped
          } else {
            map_non_ascii_lower(mapped, first_non_ascii)
          }
        }
        return map_lower_units(data, base, end, offset)
      }
      offset = skip_clean_lower_ascii(data, offset + 1, end)
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let record = lookup_case_record_bmp(unit)
      if record != 0 && case_full_lower_deltas.unsafe_get(record) != 0 {
        return map_lower_units(data, base, end, offset)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp >= 0x10000 {
      let record = lookup_case_record_supp(cp)
      if record != 0 && case_full_lower_deltas.unsafe_get(record) != 0 {
        return map_lower_units(data, base, end, offset)
      }
      offset += 2
    } else {
      offset += 1
    }
  }
  s.to_owned()
}

///|
/// First offset >= `start` in an ASCII-lowercased `String` where a non-ASCII
/// character changes under full lowercase, or `end` if none changes.
#cfg(not(target="js"))
fn first_non_ascii_lower_change(
  s : String,
  start : Int32,
  end : Int32,
) -> Int32 {
  let mut offset = skip_ascii_units(s, start, end)
  while offset < end {
    let unit = s.unsafe_get(offset).to_int()
    if unit < 0x80 {
      offset = skip_ascii_units(s, offset + 1, end)
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let record = lookup_case_record_bmp(unit)
      if record != 0 && case_full_lower_deltas.unsafe_get(record) != 0 {
        return offset
      }
      offset += 1
      continue
    }
    let cp = decode_cp(s, offset, end)
    if cp >= 0x10000 {
      let record = lookup_case_record_supp(cp)
      if record != 0 && case_full_lower_deltas.unsafe_get(record) != 0 {
        return offset
      }
      offset += 2
    } else {
      offset += 1
    }
  }
  end
}

///|
/// Map non-ASCII characters of an already ASCII-lowercased string `mapped`
/// starting from `first_change`, writing directly into `FixedArray[UInt16]`.
#cfg(not(target="js"))
#inline(never)
fn map_non_ascii_lower(mapped : String, first_change : Int32) -> String {
  let length = mapped.length()
  let mut out : FixedArray[UInt16] = FixedArray::make(length, 0)
  let mut cap = length
  copy_units(out, 0, mapped, 0, first_change)
  let mut out_len = first_change
  let mut offset = first_change
  // Invariant: `cap - out_len >= length - offset`, so ASCII, identity, simple
  // delta, and Final_Sigma mappings never need a capacity check.
  while offset < length {
    let unit = mapped.unsafe_get(offset).to_int()
    if unit < 0x80 {
      out.unsafe_set(out_len, unit.to_uint16())
      out_len += 1
      offset += 1
      if offset < length && mapped.unsafe_get(offset).to_int() < 0x80 {
        let run_end = skip_ascii_units(mapped, offset, length)
        let run_len = run_end - offset
        copy_units(out, out_len, mapped, offset, run_len)
        out_len += run_len
        offset = run_end
      }
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      // SAFETY: generator verified record bounds and BMP delta closure.
      let delta = case_full_lower_deltas.unsafe_get(
        lookup_case_record_bmp(unit),
      )
      if delta < CaseSpecialSentinel {
        out.unsafe_set(out_len, (unit + delta).to_uint16())
        out_len += 1
      } else if unit == 0x03A3 {
        let target = if final_sigma_slice(mapped, 0, length, offset) {
          0x03C2
        } else {
          0x03C3
        }
        out.unsafe_set(out_len, target.to_uint16())
        out_len += 1
      } else {
        let found = find_special_lower(unit)
        if found >= 0 {
          let mapping = special_lower_strings[found]
          let mlen = mapping.length()
          if mlen > 1 {
            let needed = out_len + mlen + (length - offset - 1)
            if needed > cap {
              out = grow_units(out, out_len, needed)
              cap = out.length()
            }
          }
          copy_units(out, out_len, mapping, 0, mlen)
          out_len += mlen
        } else {
          out.unsafe_set(out_len, unit.to_uint16())
          out_len += 1
        }
      }
      offset += 1
      continue
    }
    let cp = decode_cp(mapped, offset, length)
    if cp < 0x10000 {
      out.unsafe_set(out_len, unit.to_uint16())
      out_len += 1
      offset += 1
      continue
    }
    // SAFETY: generator verified record bounds and supplementary delta closure.
    let delta = case_full_lower_deltas.unsafe_get(lookup_case_record_supp(cp))
    if delta < CaseSpecialSentinel {
      write_supp_cp(out, out_len, cp + delta)
      out_len += 2
    } else {
      let found = find_special_lower(cp)
      if found >= 0 {
        let mapping = special_lower_strings[found]
        let mlen = mapping.length()
        if mlen > 2 {
          let needed = out_len + mlen + (length - offset - 2)
          if needed > cap {
            out = grow_units(out, out_len, needed)
            cap = out.length()
          }
        }
        copy_units(out, out_len, mapping, 0, mlen)
        out_len += mlen
      } else {
        write_supp_cp(out, out_len, cp)
        out_len += 2
      }
    }
    offset += 2
  }
  finish_units(out, out_len)
}

///|
/// Single-pass full lowercase of `data[base:end]` starting from `first_change`,
/// writing UTF-16 code units directly into a `FixedArray[UInt16]`.
#cfg(not(target="js"))
#inline(never)
fn map_lower_units(
  data : String,
  base : Int32,
  end : Int32,
  first_change : Int32,
) -> String {
  let length = end - base
  let mut out : FixedArray[UInt16] = FixedArray::make(length, 0)
  let mut cap = length
  let prefix_len = first_change - base
  copy_units(out, 0, data, base, prefix_len)
  let mut out_len = prefix_len
  let mut offset = first_change
  // Invariant: `cap - out_len >= end - offset`, so ASCII, identity, simple
  // delta, and Final_Sigma mappings never need a capacity check.
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      // Branchless ASCII A-Z -> a-z: avoids branch mispredictions on mixed-case text.
      let mapped = unit + (((((unit - 65) | (90 - unit)) >> 31) + 1) << 5)
      out.unsafe_set(out_len, mapped.to_uint16())
      out_len += 1
      offset += 1
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      // SAFETY: generator verified record bounds and BMP delta closure.
      let delta = case_full_lower_deltas.unsafe_get(
        lookup_case_record_bmp(unit),
      )
      if delta < CaseSpecialSentinel {
        out.unsafe_set(out_len, (unit + delta).to_uint16())
        out_len += 1
      } else if unit == 0x03A3 {
        let target = if final_sigma_slice(data, base, end, offset) {
          0x03C2
        } else {
          0x03C3
        }
        out.unsafe_set(out_len, target.to_uint16())
        out_len += 1
      } else {
        let found = find_special_lower(unit)
        if found >= 0 {
          let mapping = special_lower_strings[found]
          let mlen = mapping.length()
          if mlen > 1 {
            let needed = out_len + mlen + (end - offset - 1)
            if needed > cap {
              out = grow_units(out, out_len, needed)
              cap = out.length()
            }
          }
          copy_units(out, out_len, mapping, 0, mlen)
          out_len += mlen
        } else {
          out.unsafe_set(out_len, unit.to_uint16())
          out_len += 1
        }
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp < 0x10000 {
      out.unsafe_set(out_len, unit.to_uint16())
      out_len += 1
      offset += 1
      continue
    }
    // SAFETY: generator verified record bounds and supplementary delta closure.
    let delta = case_full_lower_deltas.unsafe_get(lookup_case_record_supp(cp))
    if delta < CaseSpecialSentinel {
      write_supp_cp(out, out_len, cp + delta)
      out_len += 2
    } else {
      let found = find_special_lower(cp)
      if found >= 0 {
        let mapping = special_lower_strings[found]
        let mlen = mapping.length()
        if mlen > 2 {
          let needed = out_len + mlen + (end - offset - 2)
          if needed > cap {
            out = grow_units(out, out_len, needed)
            cap = out.length()
          }
        }
        copy_units(out, out_len, mapping, 0, mlen)
        out_len += mlen
      } else {
        write_supp_cp(out, out_len, cp)
        out_len += 2
      }
    }
    offset += 2
  }
  finish_units(out, out_len)
}

///|
/// Full uppercase mapping of a string (JavaScript backend).
#cfg(target="js")
pub fn uppercase(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let length = s.length()
  let end = base + length
  let mut offset = base
  if length > 0 && data.unsafe_get(base).to_int() < 0x80 {
    if js_ascii_run_end(data, base) >= end {
      return js_to_upper(s.to_owned())
    }
    offset = js_clean_upper_ascii_end(data, base)
    if offset > end {
      offset = end
    }
  }
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 97).reinterpret_as_uint() < 26 {
        return map_upper_js(data, base, end, offset)
      }
      offset = js_clean_upper_ascii_end(data, offset + 1)
      if offset > end {
        offset = end
      }
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let record = lookup_case_record_bmp(unit)
      if record != 0 && case_full_upper_deltas.unsafe_get(record) != 0 {
        return map_upper_js(data, base, end, offset)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp >= 0x10000 {
      let record = lookup_case_record_supp(cp)
      if record != 0 && case_full_upper_deltas.unsafe_get(record) != 0 {
        return map_upper_js(data, base, end, offset)
      }
      offset += 2
    } else {
      offset += 1
    }
  }
  s.to_owned()
}

///|
#cfg(target="js")
fn map_upper_js(
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
      if end - offset >= 16 &&
        data.unsafe_get(offset + 1).to_int() < 0x80 &&
        data.unsafe_get(offset + 2).to_int() < 0x80 &&
        data.unsafe_get(offset + 4).to_int() < 0x80 &&
        data.unsafe_get(offset + 8).to_int() < 0x80 {
        let mut run_end = js_ascii_run_end(data, offset)
        if run_end > end {
          run_end = end
        }
        if run_end - offset >= 16 {
          let clean_end = js_clean_upper_ascii_end(data, offset)
          if clean_end < run_end {
            if copied < clean_end {
              out.write_view(data.unsafe_view(start=copied, end=clean_end))
            }
            out.write_string(
              js_to_upper(
                data.unsafe_view(start=clean_end, end=run_end).to_owned(),
              ),
            )
            copied = run_end
          }
          offset = run_end
          continue
        }
      }
      if (unit - 97).reinterpret_as_uint() < 26 {
        if copied < offset {
          out.write_view(data.unsafe_view(start=copied, end=offset))
        }
        out.write_char((unit - 32).unsafe_to_char())
        copied = offset + 1
      }
      offset += 1
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let delta = case_full_upper_deltas.unsafe_get(
        lookup_case_record_bmp(unit),
      )
      if delta != 0 {
        if copied < offset {
          out.write_view(data.unsafe_view(start=copied, end=offset))
        }
        if delta < CaseSpecialSentinel {
          out.write_char((unit + delta).unsafe_to_char())
        } else {
          let found = find_special_upper(unit)
          if found >= 0 {
            out.write_string(special_upper_strings[found])
          } else {
            out.write_char(unit.unsafe_to_char())
          }
        }
        copied = offset + 1
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp < 0x10000 {
      offset += 1
      continue
    }
    let delta = case_full_upper_deltas.unsafe_get(lookup_case_record_supp(cp))
    if delta != 0 {
      if copied < offset {
        out.write_view(data.unsafe_view(start=copied, end=offset))
      }
      if delta < CaseSpecialSentinel {
        out.write_char((cp + delta).unsafe_to_char())
      } else {
        let found = find_special_upper(cp)
        if found >= 0 {
          out.write_string(special_upper_strings[found])
        } else {
          out.write_char(cp.unsafe_to_char())
        }
      }
      copied = offset + 2
    }
    offset += 2
  }
  if copied < end {
    out.write_view(data.unsafe_view(start=copied, end~))
  }
  out.to_string()
}

///|
/// Unicode default full lowercase conversion of a string (JavaScript backend).
#cfg(target="js")
pub fn lowercase(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let length = s.length()
  let end = base + length
  let mut offset = base
  if length > 0 && data.unsafe_get(base).to_int() < 0x80 {
    if js_ascii_run_end(data, base) >= end {
      return js_to_lower(s.to_owned())
    }
    offset = js_clean_lower_ascii_end(data, base)
    if offset > end {
      offset = end
    }
  }
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        return map_lower_js(data, base, end, offset)
      }
      offset = js_clean_lower_ascii_end(data, offset + 1)
      if offset > end {
        offset = end
      }
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let record = lookup_case_record_bmp(unit)
      if record != 0 && case_full_lower_deltas.unsafe_get(record) != 0 {
        return map_lower_js(data, base, end, offset)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp >= 0x10000 {
      let record = lookup_case_record_supp(cp)
      if record != 0 && case_full_lower_deltas.unsafe_get(record) != 0 {
        return map_lower_js(data, base, end, offset)
      }
      offset += 2
    } else {
      offset += 1
    }
  }
  s.to_owned()
}

///|
#cfg(target="js")
fn map_lower_js(
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
      if end - offset >= 16 &&
        data.unsafe_get(offset + 1).to_int() < 0x80 &&
        data.unsafe_get(offset + 2).to_int() < 0x80 &&
        data.unsafe_get(offset + 4).to_int() < 0x80 &&
        data.unsafe_get(offset + 8).to_int() < 0x80 {
        let mut run_end = js_ascii_run_end(data, offset)
        if run_end > end {
          run_end = end
        }
        if run_end - offset >= 16 {
          let clean_end = js_clean_lower_ascii_end(data, offset)
          if clean_end < run_end {
            if copied < clean_end {
              out.write_view(data.unsafe_view(start=copied, end=clean_end))
            }
            out.write_string(
              js_to_lower(
                data.unsafe_view(start=clean_end, end=run_end).to_owned(),
              ),
            )
            copied = run_end
          }
          offset = run_end
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
    if unit < 0xD800 || unit > 0xDBFF {
      let delta = case_full_lower_deltas.unsafe_get(
        lookup_case_record_bmp(unit),
      )
      if delta != 0 {
        if copied < offset {
          out.write_view(data.unsafe_view(start=copied, end=offset))
        }
        if delta < CaseSpecialSentinel {
          out.write_char((unit + delta).unsafe_to_char())
        } else if unit == 0x03A3 {
          let target = if final_sigma_slice(data, base, end, offset) {
            0x03C2
          } else {
            0x03C3
          }
          out.write_char(target.unsafe_to_char())
        } else {
          let found = find_special_lower(unit)
          if found >= 0 {
            out.write_string(special_lower_strings[found])
          } else {
            out.write_char(unit.unsafe_to_char())
          }
        }
        copied = offset + 1
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    if cp < 0x10000 {
      offset += 1
      continue
    }
    let delta = case_full_lower_deltas.unsafe_get(lookup_case_record_supp(cp))
    if delta != 0 {
      if copied < offset {
        out.write_view(data.unsafe_view(start=copied, end=offset))
      }
      if delta < CaseSpecialSentinel {
        out.write_char((cp + delta).unsafe_to_char())
      } else {
        let found = find_special_lower(cp)
        if found >= 0 {
          out.write_string(special_lower_strings[found])
        } else {
          out.write_char(cp.unsafe_to_char())
        }
      }
      copied = offset + 2
    }
    offset += 2
  }
  if copied < end {
    out.write_view(data.unsafe_view(start=copied, end~))
  }
  out.to_string()
}
