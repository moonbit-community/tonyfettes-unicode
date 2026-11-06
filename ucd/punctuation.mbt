///|
/// Check whether a character is punctuation.
///
/// Punctuation is the General_Category group `P`, covering the connector,
/// dash, open, close, initial, final, and other punctuation categories
/// (Pc, Pd, Ps, Pe, Pi, Pf, and Po). Symbols such as `$` (Sc) and `+` (Sm)
/// are not punctuation.
///
/// The predicate uses its own compact table instead of the General_Category
/// trie, so code that only tests punctuation does not link the whole category
/// table.
pub fn is_punctuation(c : Char) -> Bool {
  @punctuation.is_punctuation(c)
}
