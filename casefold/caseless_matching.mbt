///|
/// Default caseless equality (D144), without normalization.
pub fn caseless_match(a : StringView, b : StringView) -> Bool {
  // Folding maps each code point on its own, so equal folded prefixes leave
  // only the rest to compare. Walk both while every code point folds to a
  // single one, and fold the rest only from the first longer mapping.
  let a_length = a.length()
  let b_length = b.length()
  let mut i = 0
  let mut j = 0
  while i < a_length && j < b_length {
    let ca = code_point_at(a, i, a_length)
    let cb = code_point_at(b, j, b_length)
    if ca != cb {
      guard simple_fold(ca) is Some(fa) && simple_fold(cb) is Some(fb) else {
        break
      }
      if fa != fb {
        return false
      }
    }
    i += if ca >= 0x10000 { 2 } else { 1 }
    j += if cb >= 0x10000 { 2 } else { 1 }
  }
  if i == a_length && j == b_length {
    return true
  }
  // SAFETY: i and j are code point boundaries within their views.
  case_fold(a.unsafe_view(start=i, end=a_length)) ==
  case_fold(b.unsafe_view(start=j, end=b_length))
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
