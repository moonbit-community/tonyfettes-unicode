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
  let out = StringBuilder(size_hint=s.length())
  for c in s {
    if lookup_nfkc_casefold(c) is Some(mapping) {
      out.write_string(mapping)
    } else {
      out.write_char(c)
    }
  }
  @normalization.nfc(out.to_string())
}
