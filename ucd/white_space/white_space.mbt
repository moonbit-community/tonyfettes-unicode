///|
/// White_Space lookup data
/// Generated from PropList.txt

///|
/// White_Space trie top level: `cp >> 10` to mid block index
let white_space_trie_top : Bytes = [
  0, 1, 1, 1, 1, 2, 1, 1, 3, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
]

///|
/// White_Space trie mid level: leaf block indices
let white_space_trie_mid : Bytes = [
  0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 4, 2, 2,
  2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2,
]

///|
/// White_Space trie leaf level: bitsets of 128 code points, least significant bit first
let white_space_trie_leaf : Bytes = [
  0, 62, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 1, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 7, 0, 0, 0, 131, 0, 0, 0, 0, 0, 128, 0, 0,
  0, 0,
]

///|
/// Check whether a character has the Unicode White_Space property
pub fn is_white_space(c : Char) -> Bool {
  let cp = c.to_int()
  if cp >= 0x40000 {
    return false
  }
  let mid = (white_space_trie_top[cp >> 10].to_int() << 3) | ((cp >> 7) & 7)
  let leaf = white_space_trie_mid[mid].to_int()
  let bits = white_space_trie_leaf[(leaf << 4) | ((cp >> 3) & 15)].to_int()
  ((bits >> (cp & 7)) & 1) != 0
}
