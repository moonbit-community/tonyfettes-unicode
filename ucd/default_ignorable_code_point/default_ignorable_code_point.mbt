///|
/// Default_Ignorable_Code_Point lookup data
/// Generated from DerivedCoreProperties.txt

///|
/// Default_Ignorable_Code_Point trie top level: `cp >> 10` to mid block index
let default_ignorable_code_point_trie_top : Bytes = [
  0, 1, 2, 2, 3, 4, 5, 2, 6, 2, 2, 2, 7, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 8, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 9, 2, 2, 2, 2, 10, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
]

///|
/// Default_Ignorable_Code_Point trie mid level: leaf block indices
let default_ignorable_code_point_trie_mid : Bytes = [
  0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 10, 0, 11, 0, 12, 0, 0, 0, 0, 0, 0,
  0, 0, 13, 0, 0, 0, 0, 0,
]

///|
/// Default_Ignorable_Code_Point trie leaf level: bitsets of 128 code points, least significant bit first
let default_ignorable_code_point_trie_leaf : Bytes = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 1, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 0, 0, 0, 124, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 255, 255, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0,
  0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 1, 0, 0, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 7,
]

///|
/// Check whether a character has the Unicode Default_Ignorable_Code_Point property
pub fn is_default_ignorable_code_point(c : Char) -> Bool {
  let cp = c.to_int()
  if cp >= 0x40000 {
    return (cp >= 0xE0000 && cp <= 0xE0000) ||
      (cp >= 0xE0001 && cp <= 0xE0001) ||
      (cp >= 0xE0002 && cp <= 0xE001F) ||
      (cp >= 0xE0020 && cp <= 0xE007F) ||
      (cp >= 0xE0080 && cp <= 0xE00FF) ||
      (cp >= 0xE0100 && cp <= 0xE01EF) ||
      (cp >= 0xE01F0 && cp <= 0xE0FFF)
  }
  let mid = (default_ignorable_code_point_trie_top[cp >> 10].to_int() << 3) |
    ((cp >> 7) & 7)
  let leaf = default_ignorable_code_point_trie_mid[mid].to_int()
  let bits = default_ignorable_code_point_trie_leaf[(leaf << 4) |
  ((cp >> 3) & 15)].to_int()
  ((bits >> (cp & 7)) & 1) != 0
}
