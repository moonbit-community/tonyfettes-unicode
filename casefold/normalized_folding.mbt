///|
/// A key for canonical caseless matching (D145): NFD(case_fold(NFD(s))).
/// Both normalizations are needed, notably for Greek iota subscripts.
#cfg(not(target="js"))
pub fn canonical_case_fold(s : StringView) -> String {
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
          // ASCII A-Z -> a-z commutes with NFD, so `to_lower` is never wasted
          // even if a later non-ASCII character requires NFD.
          let mapped = s.to_lower().to_owned()
          return canonical_fold_from_lower(mapped, offset - base + 1, length)
        }
        return canonical_fold_direct(data, base, end, offset, s)
      }
      offset += 1
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
      continue
    }
    let cp = if unit < 0xD800 || unit > 0xDBFF {
      unit
    } else {
      decode_cp(data, offset, end)
    }
    let val = case_folding_kind(cp)
    if (val & NormFlagBit) != 0 {
      return canonical_fold_via_nfd(s)
    }
    if val != KindIdentity {
      return canonical_fold_direct(data, base, end, offset, s)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  // Every code point was unchanged and NFD-clean.
  s.to_owned()
}

///|
/// Finish `canonical_case_fold` on an ASCII-lowercased string `mapped` whose
/// prefix `0..<start` is already known to be NFD-clean and unchanged.
#cfg(not(target="js"))
fn canonical_fold_from_lower(
  mapped : String,
  start : Int32,
  length : Int32,
) -> String {
  let mut offset = skip_ascii_units(mapped, start, length)
  while offset < length {
    let unit = mapped.unsafe_get(offset).to_int()
    if unit < 0x80 {
      offset = skip_ascii_units(mapped, offset + 1, length)
      continue
    }
    let cp = if unit < 0xD800 || unit > 0xDBFF {
      unit
    } else {
      decode_cp(mapped, offset, length)
    }
    let val = case_folding_kind(cp)
    if (val & NormFlagBit) != 0 {
      return canonical_fold_via_nfd(mapped, ascii_lowered=true)
    }
    if val != KindIdentity {
      return canonical_fold_direct(mapped, 0, length, offset, mapped)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  mapped
}

///|
/// Fold `data[base:end]` from `first_change` assuming every code point stays
/// NFD-clean (`NormFlagBit == 0`). Bails to `canonical_fold_via_nfd(orig)` if
/// any later code point carries `NormFlagBit`.
#cfg(not(target="js"))
#inline(never)
fn canonical_fold_direct(
  data : String,
  base : Int32,
  end : Int32,
  first_change : Int32,
  orig : StringView,
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
  let mut norm_flags = 0
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
      let val = case_folding_kind(unit)
      norm_flags = norm_flags | val
      let kind = val & KindMask
      if kind == KindIdentity {
        out.unsafe_set(out_len, unit.to_uint16())
        out_len += 1
      } else if kind >= 2 {
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
    let val = case_folding_kind(cp)
    norm_flags = norm_flags | val
    let kind = val & KindMask
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
  if (norm_flags & NormFlagBit) != 0 {
    return canonical_fold_via_nfd(orig)
  }
  finish_units(out, out_len)
}

///|
/// General canonical case folding: normalize to NFD first, then fold while
/// tracking whether any *changed* character can disturb NFD. Unchanged
/// characters preserve NFD, and changed characters with `NormFlagBit == 0`
/// replace a starter with non-empty NFD-clean starters, also preserving NFD;
/// only when a changed character has `NormFlagBit != 0` is the final NFD run.
#cfg(not(target="js"))
#inline(never)
fn canonical_fold_via_nfd(
  s : StringView,
  ascii_lowered~ : Bool = false,
) -> String {
  let decomposed = @normalization.nfd(s)
  let length = decomposed.length()
  let mut offset = 0
  while offset < length {
    let unit = decomposed.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        if UseStdlibAsciiLower && !ascii_lowered {
          let mapped = decomposed.to_lower()
          let first_non_ascii = first_non_ascii_change_full(
            mapped,
            offset + 1,
            length,
          )
          return if first_non_ascii == length {
            mapped
          } else {
            fold_after_nfd_units(mapped, first_non_ascii)
          }
        }
        return fold_after_nfd_units(decomposed, offset)
      }
      offset += 1
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      if (case_folding_kind(unit) & KindMask) != KindIdentity {
        return fold_after_nfd_units(decomposed, offset)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(decomposed, offset, length)
    if (case_folding_kind(cp) & KindMask) != KindIdentity {
      return fold_after_nfd_units(decomposed, offset)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  decomposed
}

///|
#cfg(not(target="js"))
#inline(never)
fn fold_after_nfd_units(data : String, first_change : Int32) -> String {
  let length = data.length()
  let mut out : FixedArray[UInt16] = FixedArray::make(length, 0)
  let mut cap = length
  for i in 0..<first_change {
    out.unsafe_set(i, data.unsafe_get(i))
  }
  let mut out_len = first_change
  let mut offset = first_change
  let mut changed_norm_flags = 0
  while offset < length {
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
      let val = case_folding_kind(unit)
      let kind = val & KindMask
      if kind == KindIdentity {
        out.unsafe_set(out_len, unit.to_uint16())
        out_len += 1
      } else {
        changed_norm_flags = changed_norm_flags | val
        if kind >= 2 {
          out.unsafe_set(
            out_len,
            (unit + case_folding_deltas.unsafe_get(kind)).to_uint16(),
          )
          out_len += 1
        } else if lookup_case_folding(unit) is Some(mapping) {
          let mlen = mapping.length()
          if mlen > 1 {
            let needed = out_len + mlen + (length - offset - 1)
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
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, length)
    let width = if cp >= 0x10000 { 2 } else { 1 }
    let val = case_folding_kind(cp)
    let kind = val & KindMask
    if kind == KindIdentity {
      out.unsafe_set(out_len, unit.to_uint16())
      if width == 2 {
        out.unsafe_set(out_len + 1, data.unsafe_get(offset + 1))
      }
      out_len += width
    } else {
      changed_norm_flags = changed_norm_flags | val
      if kind >= 2 {
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
          let needed = out_len + mlen + (length - offset - width)
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
    }
    offset += width
  }
  let folded = finish_units(out, out_len)
  if (changed_norm_flags & NormFlagBit) == 0 {
    folded
  } else {
    @normalization.nfd(folded)
  }
}

///|
/// Unicode NFKC_Casefold (R5). Applies the official NFKC_CF mapping, removing
/// default-ignorable code points, then normalizes the concatenation to NFC.
/// This is locale-independent and is not an identifier validity check.
#cfg(not(target="js"))
pub fn nfkc_casefold(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let length = s.length()
  let end = base + length
  let mut offset = base
  let mut norm_flags = 0
  while offset < end {
    // SAFETY: base <= offset < end <= data.length().
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        if UseStdlibAsciiLower {
          let mapped = s.to_lower().to_owned()
          return nfkc_from_lower(mapped, offset - base + 1, length, norm_flags)
        }
        return fold_nfkc_units(data, base, end, offset, norm_flags)
      }
      offset += 1
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
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let val = nfkc_casefold_kind(unit)
      norm_flags = norm_flags | val
      if (val & KindMask) != KindIdentity {
        return fold_nfkc_units(data, base, end, offset, norm_flags)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(data, offset, end)
    let val = nfkc_casefold_kind(cp)
    norm_flags = norm_flags | val
    if (val & KindMask) != KindIdentity {
      return fold_nfkc_units(data, base, end, offset, norm_flags)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  if (norm_flags & NormFlagBit) == 0 {
    s.to_owned()
  } else {
    @normalization.nfc(s)
  }
}

///|
#cfg(not(target="js"))
fn nfkc_from_lower(
  mapped : String,
  start : Int32,
  length : Int32,
  initial_flags : Int32,
) -> String {
  let mut norm_flags = initial_flags
  let mut offset = skip_ascii_units(mapped, start, length)
  while offset < length {
    let unit = mapped.unsafe_get(offset).to_int()
    if unit < 0x80 {
      offset = skip_ascii_units(mapped, offset + 1, length)
      continue
    }
    if unit < 0xD800 || unit > 0xDBFF {
      let val = nfkc_casefold_kind(unit)
      norm_flags = norm_flags | val
      if (val & KindMask) != KindIdentity {
        return fold_nfkc_units(mapped, 0, length, offset, norm_flags)
      }
      offset += 1
      continue
    }
    let cp = decode_cp(mapped, offset, length)
    let val = nfkc_casefold_kind(cp)
    norm_flags = norm_flags | val
    if (val & KindMask) != KindIdentity {
      return fold_nfkc_units(mapped, 0, length, offset, norm_flags)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  if (norm_flags & NormFlagBit) == 0 {
    mapped
  } else {
    @normalization.nfc(mapped)
  }
}

///|
#cfg(not(target="js"))
#inline(never)
fn fold_nfkc_units(
  data : String,
  base : Int32,
  end : Int32,
  first_change : Int32,
  initial_flags : Int32,
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
  let mut norm_flags = initial_flags
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
      let val = nfkc_casefold_kind(unit)
      norm_flags = norm_flags | val
      let kind = val & KindMask
      if kind == KindIdentity {
        out.unsafe_set(out_len, unit.to_uint16())
        out_len += 1
      } else if kind >= 2 {
        out.unsafe_set(
          out_len,
          (unit + nfkc_casefold_deltas.unsafe_get(kind)).to_uint16(),
        )
        out_len += 1
      } else if lookup_nfkc_casefold(unit) is Some(mapping) {
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
    let val = nfkc_casefold_kind(cp)
    norm_flags = norm_flags | val
    let kind = val & KindMask
    if kind == KindIdentity {
      out.unsafe_set(out_len, unit.to_uint16())
      if width == 2 {
        out.unsafe_set(out_len + 1, data.unsafe_get(offset + 1))
      }
      out_len += width
    } else if kind >= 2 {
      let target = cp + nfkc_casefold_deltas.unsafe_get(kind)
      if target < 0x10000 {
        out.unsafe_set(out_len, target.to_uint16())
        out_len += 1
      } else {
        let t = target - 0x10000
        out.unsafe_set(out_len, (0xD800 + (t >> 10)).to_uint16())
        out.unsafe_set(out_len + 1, (0xDC00 + (t & 0x3FF)).to_uint16())
        out_len += 2
      }
    } else if lookup_nfkc_casefold(cp) is Some(mapping) {
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
  let folded = finish_units(out, out_len)
  if (norm_flags & NormFlagBit) == 0 {
    folded
  } else {
    @normalization.nfc(folded)
  }
}

///|
/// A key for canonical caseless matching (D145): NFD(case_fold(NFD(s))).
/// Both normalizations are needed, notably for Greek iota subscripts.
#cfg(target="js")
pub fn canonical_case_fold(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let end = base + s.length()
  if js_ascii_run_end(data, base) >= end {
    return js_to_lower(s.to_owned())
  }
  let mut offset = js_clean_ascii_end(data, base)
  if offset > end {
    offset = end
  }
  let mut has_change = false
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        has_change = true
        offset += 1
        continue
      }
      offset = js_clean_ascii_end(data, offset + 1)
      if offset > end {
        offset = end
      }
      continue
    }
    let cp = if unit < 0xD800 || unit > 0xDBFF {
      unit
    } else {
      decode_cp(data, offset, end)
    }
    let val = case_folding_kind(cp)
    if (val & NormFlagBit) != 0 {
      return canonical_fold_via_nfd_js(s)
    }
    if val != KindIdentity {
      has_change = true
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  if has_change {
    fold_full_js(data, base, end, base)
  } else {
    s.to_owned()
  }
}

///|
#cfg(target="js")
fn canonical_fold_via_nfd_js(s : StringView) -> String {
  let decomposed = @normalization.nfd(s)
  let length = decomposed.length()
  let mut offset = js_clean_ascii_end(decomposed, 0)
  while offset < length {
    let unit = decomposed.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        return fold_after_nfd_js(decomposed, offset)
      }
      offset = js_clean_ascii_end(decomposed, offset + 1)
      continue
    }
    let cp = if unit < 0xD800 || unit > 0xDBFF {
      unit
    } else {
      decode_cp(decomposed, offset, length)
    }
    if (case_folding_kind(cp) & KindMask) != KindIdentity {
      return fold_after_nfd_js(decomposed, offset)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  decomposed
}

///|
#cfg(target="js")
fn fold_after_nfd_js(data : String, first_change : Int32) -> String {
  let length = data.length()
  let out = StringBuilder(capacity=length)
  let mut copied = 0
  let mut offset = first_change
  let mut changed_norm_flags = 0
  while offset < length {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
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
      decode_cp(data, offset, length)
    }
    let width = if cp >= 0x10000 { 2 } else { 1 }
    let val = case_folding_kind(cp)
    let kind = val & KindMask
    if kind != KindIdentity {
      changed_norm_flags = changed_norm_flags | val
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
  if copied < length {
    out.write_view(data.unsafe_view(start=copied, end=length))
  }
  let folded = out.to_string()
  if (changed_norm_flags & NormFlagBit) == 0 {
    folded
  } else {
    @normalization.nfd(folded)
  }
}

///|
/// Unicode NFKC_Casefold (R5). Applies the official NFKC_CF mapping, removing
/// default-ignorable code points, then normalizes the concatenation to NFC.
/// This is locale-independent and is not an identifier validity check.
#cfg(target="js")
pub fn nfkc_casefold(s : StringView) -> String {
  let data = s.data()
  let base = s.start_offset()
  let end = base + s.length()
  if js_ascii_run_end(data, base) >= end {
    return js_to_lower(s.to_owned())
  }
  let mut offset = js_clean_ascii_end(data, base)
  if offset > end {
    offset = end
  }
  let mut norm_flags = 0
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
      if (unit - 65).reinterpret_as_uint() < 26 {
        return fold_nfkc_js(data, base, end, offset, norm_flags)
      }
      offset = js_clean_ascii_end(data, offset + 1)
      if offset > end {
        offset = end
      }
      continue
    }
    let cp = if unit < 0xD800 || unit > 0xDBFF {
      unit
    } else {
      decode_cp(data, offset, end)
    }
    let val = nfkc_casefold_kind(cp)
    norm_flags = norm_flags | val
    if (val & KindMask) != KindIdentity {
      return fold_nfkc_js(data, base, end, offset, norm_flags)
    }
    offset += if cp >= 0x10000 { 2 } else { 1 }
  }
  if (norm_flags & NormFlagBit) == 0 {
    s.to_owned()
  } else {
    @normalization.nfc(s)
  }
}

///|
#cfg(target="js")
fn fold_nfkc_js(
  data : String,
  base : Int32,
  end : Int32,
  first_change : Int32,
  initial_flags : Int32,
) -> String {
  let out = StringBuilder(capacity=end - base)
  let mut copied = base
  let mut offset = first_change
  let mut norm_flags = initial_flags
  while offset < end {
    let unit = data.unsafe_get(offset).to_int()
    if unit < 0x80 {
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
    let val = nfkc_casefold_kind(cp)
    norm_flags = norm_flags | val
    let kind = val & KindMask
    if kind != KindIdentity {
      if copied < offset {
        out.write_view(data.unsafe_view(start=copied, end=offset))
      }
      if kind >= 2 {
        out.write_char(
          (cp + nfkc_casefold_deltas.unsafe_get(kind)).unsafe_to_char(),
        )
      } else if lookup_nfkc_casefold(cp) is Some(mapping) {
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
  let folded = out.to_string()
  if (norm_flags & NormFlagBit) == 0 {
    folded
  } else {
    @normalization.nfc(folded)
  }
}
