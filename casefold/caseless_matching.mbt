///|
/// Default caseless equality (D144), without normalization.
pub fn caseless_match(a : StringView, b : StringView) -> Bool {
  case_fold(a) == case_fold(b)
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
