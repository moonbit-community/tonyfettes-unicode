///|
const MaxCodePoint : Int32 = 0x10FFFF

///|
/// Value tries cover planes 0-3; the higher planes hold few distinct runs and
/// are looked up as packed ranges instead.
const ValueTrieLimit : Int32 = 0x40000

///|
/// Each top-level trie entry covers `1 << ValueTrieTopShift` code points.
const ValueTrieTopShift : Int32 = 8

///|
/// Each leaf block holds `1 << ValueTrieLeafShift` values.
const ValueTrieLeafShift : Int32 = 4

///|
/// Write a table holding one small integer per code point, followed by its
/// lookup function.
///
/// Planes 0-3 become a three-level trie named `<prefix>_trie_top`,
/// `<prefix>_trie_mid`, and `<prefix>_trie_leaf`: the top level maps
/// `cp >> 8` to a mid block, the mid level maps the next four bits to a leaf
/// block, and the leaf level stores one value per code point. Identical
/// blocks are shared at both levels. The remaining planes become
/// `<prefix>_high_ranges`, packed as `start << value_bits | value`.
///
/// `values` holds the value of every code point, each below
/// `1 << value_bits`. `lookup` is the declaration head of the lookup
/// function, such as `pub fn lookup_east_asian_width`; it takes a `Char` and
/// returns the value as an `Int`. `lookup_doc` is its documentation, one
/// entry per line.
pub fn Emitter::write_value_trie(
  self : Emitter,
  property~ : String,
  prefix~ : String,
  lookup~ : String,
  lookup_doc~ : Array[String],
  value_bits~ : Int32,
  values : FixedArray[Int32],
) -> Unit raise {
  guard values.length() == MaxCodePoint + 1 else {
    fail("\{property} table must hold one value per code point")
  }
  guard values.iter().all(value => value >= 0 && value < 1 << value_bits) else {
    fail("\{property} value does not fit in \{value_bits} bits")
  }
  // `start << value_bits | value`, so the packed values sort by start code
  // point.
  let high_ranges = []
  for cp in ValueTrieLimit..<=MaxCodePoint {
    if cp == ValueTrieLimit || values[cp] != values[cp - 1] {
      high_ranges.push((cp << value_bits) | values[cp])
    }
  }
  // Leaf level: blocks of values.
  let leaf = @trie.deduplicate_blocks(
    Array::makei(ValueTrieLimit, cp => values[cp]),
    1 << ValueTrieLeafShift,
  )
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = @trie.deduplicate_blocks(
    leaf.ids,
    1 << (ValueTrieTopShift - ValueTrieLeafShift),
  )
  guard mid.ids.iter().all(id => id < 0x100) else {
    fail("\{property} trie has too many mid blocks for one byte")
  }
  guard mid.blocks.iter().all(id => id < 0x10000) else {
    fail("\{property} trie has too many leaf blocks for two bytes")
  }
  let mid_bytes = []
  for id in mid.blocks {
    mid_bytes.push(id >> 8)
    mid_bytes.push(id & 0xFF)
  }
  let trie_limit = "0x\{hex_upper(ValueTrieLimit)}"
  let mid_mask = (1 << (ValueTrieTopShift - ValueTrieLeafShift)) - 1
  let leaf_mask = (1 << ValueTrieLeafShift) - 1
  let value_mask = (1 << value_bits) - 1
  self.write_byte_array(
    "\{property} trie top level: `cp >> \{ValueTrieTopShift}` to mid block index",
    "\{prefix}_trie_top",
    mid.ids,
  )
  self.write_byte_array(
    "\{property} trie mid level: big-endian 16-bit leaf block indices",
    "\{prefix}_trie_mid",
    mid_bytes,
  )
  self.write_byte_array(
    "\{property} trie leaf level: values in blocks of \{1 << ValueTrieLeafShift}",
    "\{prefix}_trie_leaf",
    leaf.blocks,
  )
  self.write_int_array(
    "\{property} ranges from \{trie_limit} packed as `start << \{value_bits} | value`",
    "\{prefix}_high_ranges",
    high_ranges,
    hex=true,
  )
  self.write("///|\n")
  for line in lookup_doc {
    self.write_line("/// \{line}")
  }
  self.write(
    (
      $|\{lookup}(c : Char) -> Int {
      $|  let cp = c.to_int()
      $|  if cp >= \{trie_limit} {
      $|    // Binary search for the last range starting at or before `cp`.
      $|    let key = (cp << \{value_bits}) | \{value_mask}
      $|    let mut low = 0
      $|    let mut high = \{prefix}_high_ranges.length()
      $|    while high - low > 1 {
      $|      let mid = (low + high) / 2
      $|      if \{prefix}_high_ranges[mid] <= key {
      $|        low = mid
      $|      } else {
      $|        high = mid
      $|      }
      $|    }
      $|    return \{prefix}_high_ranges[low] & \{value_mask}
      $|  }
      $|  let mid = (\{prefix}_trie_top[cp >> \{ValueTrieTopShift}].to_int() << \{ValueTrieTopShift - ValueTrieLeafShift}) |
      $|    ((cp >> \{ValueTrieLeafShift}) & \{mid_mask})
      $|  let leaf = (\{prefix}_trie_mid[2 * mid].to_int() << 8) |
      $|    \{prefix}_trie_mid[2 * mid + 1].to_int()
      $|  \{prefix}_trie_leaf[(leaf << \{ValueTrieLeafShift}) | (cp & \{leaf_mask})].to_int()
      $|}
      $|
    ),
  )
}
