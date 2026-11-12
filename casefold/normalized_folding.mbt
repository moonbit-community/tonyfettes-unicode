///|
/// A key for canonical caseless matching (D145): NFD(case_fold(NFD(s))).
/// Both normalizations are needed, notably for Greek iota subscripts.
pub fn canonical_case_fold(s : StringView) -> String {
  @normalization.nfd(case_fold(@normalization.nfd(s)))
}

///|
/// Unicode NFKC_Casefold (R5). Applies the official NFKC_CF mapping, removing
/// default-ignorable code points, then normalizes the concatenation to NFC.
/// This is locale-independent and is not an identifier validity check.
pub fn nfkc_casefold(s : StringView) -> String {
  let index = Nfkc.first_change(s)
  // Unchanged input goes to NFC as it is, which copies it only once.
  if index == s.length() {
    @normalization.nfc(s)
  } else {
    @normalization.nfc(Nfkc.fold_from(s, index))
  }
}
