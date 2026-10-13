///|
/// Prepended_Concatenation_Mark lookup data
/// Generated from PropList.txt

///|
/// Prepended_Concatenation_Mark trie top level: `cp >> 10` to mid block index
let prepended_concatenation_mark_trie_top : Bytes = [
  0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
]

///|
/// Prepended_Concatenation_Mark trie mid level: leaf block indices
let prepended_concatenation_mark_trie_mid : Bytes = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 5, 0,
  0, 0, 0, 0, 0,
]

///|
/// Prepended_Concatenation_Mark trie leaf level: bitsets of 128 code points, least significant bit first
let prepended_concatenation_mark_trie_leaf : Bytes = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 63, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 128, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 32, 0, 0, 0, 0, 0, 0,
]

///|
/// Check whether a character has the Unicode Prepended_Concatenation_Mark property
pub fn is_prepended_concatenation_mark(c : Char) -> Bool {
  let cp = c.to_int()
  if cp >= 0x40000 {
    return false
  }
  let mid = (prepended_concatenation_mark_trie_top[cp >> 10].to_int() << 3) |
    ((cp >> 7) & 7)
  let leaf = prepended_concatenation_mark_trie_mid[mid].to_int()
  let bits = prepended_concatenation_mark_trie_leaf[(leaf << 4) |
  ((cp >> 3) & 15)].to_int()
  ((bits >> (cp & 7)) & 1) != 0
}
