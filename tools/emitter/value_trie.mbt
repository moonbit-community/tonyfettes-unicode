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
/// block, and the leaf level stores one value per code point, in one byte or,
/// when `value_bits` exceeds 8, in 16 bits. Identical blocks are shared at
/// both levels. The remaining planes become `<prefix>_high_ranges`, packed as
/// `start << range_value_bits | value`.
///
/// The mid level holds one leaf block index per `Int`, so that the step every
/// lookup takes is a single load. Reading two bytes per index instead costs a
/// second bounds-checked load, which made the General_Category trie 1.4-1.8
/// times as slow on wasm and JS; packing two indices per `Int` leaves a shift
/// and a mask on the path to the leaf load, which made it about 5% slower on
/// native than two bytes. A `ReadOnlyArray[UInt16]` would be as fast and half
/// the size, but moonc builds it on wasm-gc with one `array.set` per element
/// instead of from a data segment.
///
/// 16-bit leaf values are packed two to an `Int`, the even value in the low
/// half, since the leaf level is the largest and its value is the result.
/// The pairs are written in decimal, since a pair whose high half has its top
/// bit set is negative.
///
/// `values` holds the value of every code point, each below
/// `1 << value_bits`, and below `1 << range_value_bits` from U+40000 on;
/// `range_value_bits` defaults to `value_bits`. `lookup` is the declaration
/// head of the lookup
/// function, such as `pub fn lookup_east_asian_width`; it takes a `Char`, or
/// the code point as an `Int` when `takes_code_point` is set, and returns the
/// value as an `Int`. `lookup_doc` is its documentation, one entry per line.
pub fn Emitter::write_value_trie(
  self : Emitter,
  property~ : String,
  prefix~ : String,
  lookup~ : String,
  lookup_doc~ : Array[String],
  value_bits~ : Int32,
  range_value_bits~ : Int32 = value_bits,
  takes_code_point~ : Bool = false,
  values : FixedArray[Int32],
) -> Unit raise {
  guard values.length() == MaxCodePoint + 1 else {
    fail("\{property} table must hold one value per code point")
  }
  guard value_bits <= 16 && range_value_bits <= value_bits else {
    fail("\{property} trie values must fit in 16 bits")
  }
  guard values.all(value => value >= 0 && value < 1 << value_bits) else {
    fail("\{property} value does not fit in \{value_bits} bits")
  }
  // `start << range_value_bits | value`, so the packed values sort by start
  // code point.
  let high_ranges = []
  for cp in ValueTrieLimit..<=MaxCodePoint {
    guard values[cp] < 1 << range_value_bits else {
      fail(
        "\{property} value at \{hex_literal(cp)} does not fit in \{range_value_bits} bits",
      )
    }
    if cp == ValueTrieLimit || values[cp] != values[cp - 1] {
      high_ranges.push((cp << range_value_bits) | values[cp])
    }
  }
  // Leaf level: blocks of values.
  let leaf = deduplicate_blocks(
    Array::makei(ValueTrieLimit, cp => values[cp]),
    1 << ValueTrieLeafShift,
  )
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = deduplicate_blocks(
    leaf.ids,
    1 << (ValueTrieTopShift - ValueTrieLeafShift),
  )
  guard mid.ids.all(id => id < 0x100) else {
    fail("\{property} trie has too many mid blocks for one byte")
  }
  guard mid.blocks.all(id => id < 0x10000) else {
    fail("\{property} trie has too many leaf blocks for two bytes")
  }
  let trie_limit = hex_literal(ValueTrieLimit)
  let mid_mask = (1 << (ValueTrieTopShift - ValueTrieLeafShift)) - 1
  let leaf_mask = (1 << ValueTrieLeafShift) - 1
  let range_mask = (1 << range_value_bits) - 1
  let wide = value_bits > 8
  self.write_byte_array(
    "\{property} trie top level: `cp >> \{ValueTrieTopShift}` to mid block index",
    "\{prefix}_trie_top",
    mid.ids,
  )
  self.write_int_array(
    "\{property} trie mid level: leaf block indices",
    "\{prefix}_trie_mid",
    mid.blocks,
    hex=false,
  )
  if wide {
    self.write_int_array(
      "\{property} trie leaf level: 16-bit values in blocks of \{1 << ValueTrieLeafShift}, two per entry",
      "\{prefix}_trie_leaf",
      pack_16_bit_pairs(leaf.blocks),
      hex=false,
    )
  } else {
    self.write_byte_array(
      "\{property} trie leaf level: values in blocks of \{1 << ValueTrieLeafShift}",
      "\{prefix}_trie_leaf",
      leaf.blocks,
    )
  }
  self.write_int_array(
    "\{property} ranges from \{trie_limit} packed as `start << \{range_value_bits} | value`",
    "\{prefix}_high_ranges",
    high_ranges,
    hex=true,
  )
  self.write("///|\n")
  for line in lookup_doc {
    self.write_line("/// \{line}")
  }
  self.write(
    if takes_code_point {
      "\{lookup}(cp : Int) -> Int {\n"
    } else {
      "\{lookup}(c : Char) -> Int {\n  let cp = c.to_int()\n"
    },
  )
  self.write(
    (
      $|  if cp >= \{trie_limit} {
      $|    // Binary search for the last range starting at or before `cp`.
      $|    let key = (cp << \{range_value_bits}) | \{range_mask}
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
      $|    return \{prefix}_high_ranges[low] & \{range_mask}
      $|  }
      $|  let mid = (\{prefix}_trie_top[cp >> \{ValueTrieTopShift}].to_int() << \{ValueTrieTopShift - ValueTrieLeafShift}) |
      $|    ((cp >> \{ValueTrieLeafShift}) & \{mid_mask})
      $|  let leaf = \{prefix}_trie_mid[mid]
      $|
    ),
  )
  self.write(
    if wide {
      (
        $|  let offset = (leaf << \{ValueTrieLeafShift}) | (cp & \{leaf_mask})
        $|  (\{prefix}_trie_leaf[offset >> 1] >> ((offset & 1) << 4)) & 0xFFFF
        $|}
        $|
      )
    } else {
      (
        $|  \{prefix}_trie_leaf[(leaf << \{ValueTrieLeafShift}) | (cp & \{leaf_mask})].to_int()
        $|}
        $|
      )
    },
  )
}

///|
/// Pack 16-bit values two to an `Int`: value `2 * i` in the low half of entry
/// `i` and value `2 * i + 1` in the high half. An odd count leaves the last
/// high half zero.
fn pack_16_bit_pairs(values : Array[Int32]) -> Array[Int32] {
  Array::makei((values.length() + 1) / 2, i => {
    let high = if 2 * i + 1 < values.length() { values[2 * i + 1] } else { 0 }
    values[2 * i] | (high << 16)
  })
}
