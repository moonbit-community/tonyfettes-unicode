///|
/// Unicode default full case folding (section 3.13, R4).
/// Locale-independent: uses the C and F mappings in CaseFolding.txt, including
/// expansions such as ß -> ss. Does not normalize or apply Turkic tailoring.
pub fn case_fold(s : StringView) -> String {
  let out = StringBuilder(size_hint=s.length())
  for c in s {
    if lookup_case_folding(c) is Some(mapping) {
      out.write_string(mapping)
    } else {
      out.write_char(c)
    }
  }
  out.to_string()
}
