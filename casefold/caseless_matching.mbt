///|
/// Compare two distinct code points under single-character full case folding:
/// returns `1` if they fold to the same code point, `0` if they fold to
/// different single code points, or `-1` if either has a multi-character
/// mapping (`KindSearched`).
#inline(never)
fn fold_pair_status(ca : Int32, cb : Int32) -> Int32 {
  let fa = simple_fold_sentinel(ca)
  if fa < 0 {
    return -1
  }
  let fb = simple_fold_sentinel(cb)
  if fb < 0 {
    return -1
  }
  if fa == fb {
    1
  } else {
    0
  }
}

///|
/// Default caseless equality (D144), without normalization.
pub fn caseless_match(a : StringView, b : StringView) -> Bool {
  // Folding maps each code point on its own, so equal folded prefixes leave
  // only the rest to compare. Walk both while every code point folds to a
  // single one, and fold the rest only from the first longer mapping.
  let a_data = a.data()
  let a_base = a.start_offset()
  let a_end = a_base + a.length()
  let b_data = b.data()
  let b_base = b.start_offset()
  let b_end = b_base + b.length()
  let mut i = a_base
  let mut j = b_base
  while i < a_end && j < b_end {
    // SAFETY: a_base <= i < a_end <= a_data.length() and same for b.
    let ua = a_data.unsafe_get(i).to_int()
    let ub = b_data.unsafe_get(j).to_int()
    let diff = ua ^ ub
    // Single fast test covering both equal non-surrogate units and ASCII
    // upper/lower letter pairs (`diff == 32` and `(ua | 32)` in `'a'..'z'`),
    // avoiding branch mispredictions on mixed-case ASCII words.
    if (diff == 0 && (ua & 0xFC00) != 0xD800) ||
      (diff == 32 && ((ua | 32) - 97).reinterpret_as_uint() < 26) {
      i += 1
      j += 1
      continue
    }
    if (ua | ub) < 0x80 {
      return false
    }
    let ca = decode_cp(a_data, i, a_end)
    let cb = decode_cp(b_data, j, b_end)
    if ca != cb {
      let status = fold_pair_status(ca, cb)
      if status == 0 {
        return false
      }
      if status < 0 {
        break
      }
    }
    i += if ca >= 0x10000 { 2 } else { 1 }
    j += if cb >= 0x10000 { 2 } else { 1 }
  }
  if i == a_end && j == b_end {
    return true
  }
  // SAFETY: i and j are code point boundaries within their backing strings.
  case_fold(a_data.unsafe_view(start=i, end=a_end)) ==
  case_fold(b_data.unsafe_view(start=j, end=b_end))
}

///|
/// Case-insensitive equality under canonical equivalence (D145).
pub fn canonical_caseless_match(a : StringView, b : StringView) -> Bool {
  canonical_case_fold(a) == canonical_case_fold(b)
}

///|
/// Identifier caseless equality (D147): NFKC_Casefold(NFD(a)) equals
/// NFKC_Casefold(NFD(b)). The initial NFD handles canonical equivalents with
/// iota subscripts. This does not validate identifiers or detect confusables.
pub fn identifier_caseless_match(a : StringView, b : StringView) -> Bool {
  nfkc_casefold(@normalization.nfd(a)) == nfkc_casefold(@normalization.nfd(b))
}
