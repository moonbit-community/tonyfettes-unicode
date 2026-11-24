///|
/// BMP lookups use a two-level trie with blocks of `1 << ValueTrieBmpShift`.
const ValueTrieBmpLimit : Int32 = 0x10000

///|
/// Each BMP leaf block holds `1 << ValueTrieBmpShift` values (64).
const ValueTrieBmpShift : Int32 = 6

///|
/// Value tries cover planes 0-3; the higher planes hold few distinct runs and
/// are looked up as packed ranges instead.
const ValueTrieLimit : Int32 = 0x40000

///|
/// Each supplementary top-level trie entry covers `1 << ValueTrieTopShift` code points.
const ValueTrieTopShift : Int32 = 8

///|
/// Each supplementary leaf block holds `1 << ValueTrieLeafShift` values.
const ValueTrieLeafShift : Int32 = 4

///|
/// Write a table holding one small integer per code point, followed by its
/// lookup function.
///
/// The BMP (plane 0) becomes a two-level trie named `<prefix>_bmp_index` and
/// `<prefix>_bmp_leaf`: the index maps `cp >> 6` to a 64-entry leaf block (in
/// one byte when all distinct BMP blocks fit in 256 entries, which holds for
/// every UCD property), and the leaf stores one value per code point, in one
/// byte or, when `value_bits` exceeds 8, packed two 16-bit values per `Int`.
///
/// Planes 1-3 become a three-level supplementary trie (`<prefix>_supp_top`,
/// `<prefix>_supp_mid`, `<prefix>_supp_leaf`) with 16-entry leaf blocks, and
/// planes 4-16 become `<prefix>_high_ranges`, packed as
/// `start << range_value_bits | value`. Both are placed inside an
/// `#inline(never)` helper `<prefix>_lookup_supplementary` so the hot BMP path
/// stays small enough to inline into caller loops. Every generated index is
/// exhaustively verified at generation time, allowing `.unsafe_get()` in the
/// emitted lookups.
///
/// `values` holds the value of every code point, each below
/// `1 << value_bits`, and below `1 << range_value_bits` from U+40000 on;
/// `range_value_bits` defaults to `value_bits`. `lookup` is the declaration
/// head of the lookup function, such as `pub fn lookup_east_asian_width`; it
/// takes a `Char`, or the code point as an `Int` when `takes_code_point` is
/// set, and returns the value as an `Int`. `lookup_doc` is its documentation,
/// one entry per line.
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
  // BMP two-level trie: blocks of `1 << ValueTrieBmpShift` values.
  let bmp = deduplicate_blocks(
    Array::makei(ValueTrieBmpLimit, cp => values[cp]),
    1 << ValueTrieBmpShift,
  )
  let bmp_index_byte = bmp.ids.all(id => id < 0x100)
  // Supplementary three-level trie covering [0x10000, 0x40000).
  let supp_leaf = deduplicate_blocks(
    Array::makei(ValueTrieLimit - ValueTrieBmpLimit, i => {
      values[ValueTrieBmpLimit + i]
    }),
    1 << ValueTrieLeafShift,
  )
  let supp_mid = deduplicate_blocks(
    supp_leaf.ids,
    1 << (ValueTrieTopShift - ValueTrieLeafShift),
  )
  guard supp_mid.ids.all(id => id < 0x100) else {
    fail("\{property} supplementary trie has too many mid blocks for one byte")
  }
  guard supp_mid.blocks.all(id => id < 0x10000) else {
    fail(
      "\{property} supplementary trie has too many leaf blocks for two bytes",
    )
  }
  let supp_mid_byte = supp_mid.blocks.all(id => id < 0x100)
  let bmp_limit = hex_literal(ValueTrieBmpLimit)
  let trie_limit = hex_literal(ValueTrieLimit)
  let bmp_mask = (1 << ValueTrieBmpShift) - 1
  let mid_shift = ValueTrieTopShift - ValueTrieLeafShift
  let mid_mask = (1 << mid_shift) - 1
  let leaf_mask = (1 << ValueTrieLeafShift) - 1
  let range_mask = (1 << range_value_bits) - 1
  let wide = value_bits > 8
  let bmp_leaf_packed = if wide { pack_16_bit_pairs(bmp.blocks) } else { [] }
  let supp_leaf_packed = if wide {
    pack_16_bit_pairs(supp_leaf.blocks)
  } else {
    []
  }
  // Validate every lookup index and decoded value before emitting unsafe_get.
  for cp in 0..<ValueTrieBmpLimit {
    let idx = cp >> ValueTrieBmpShift
    guard idx >= 0 && idx < bmp.ids.length() else {
      fail("\{property} BMP index out of bounds at \{hex_literal(cp)}")
    }
    let off = (bmp.ids[idx] << ValueTrieBmpShift) | (cp & bmp_mask)
    let actual = if wide {
      guard off >> 1 >= 0 && off >> 1 < bmp_leaf_packed.length() else {
        fail("\{property} wide BMP leaf out of bounds at \{hex_literal(cp)}")
      }
      (bmp_leaf_packed[off >> 1] >> ((off & 1) << 4)) & 0xFFFF
    } else {
      guard off >= 0 && off < bmp.blocks.length() else {
        fail("\{property} BMP leaf out of bounds at \{hex_literal(cp)}")
      }
      bmp.blocks[off]
    }
    guard actual == values[cp] else {
      fail("\{property} BMP mismatch at \{hex_literal(cp)}")
    }
  }
  for cp in ValueTrieBmpLimit..<ValueTrieLimit {
    let top_idx = (cp - ValueTrieBmpLimit) >> ValueTrieTopShift
    guard top_idx >= 0 && top_idx < supp_mid.ids.length() else {
      fail("\{property} supp top out of bounds at \{hex_literal(cp)}")
    }
    let mid_idx = (supp_mid.ids[top_idx] << mid_shift) |
      ((cp >> ValueTrieLeafShift) & mid_mask)
    guard mid_idx >= 0 && mid_idx < supp_mid.blocks.length() else {
      fail("\{property} supp mid out of bounds at \{hex_literal(cp)}")
    }
    let off = (supp_mid.blocks[mid_idx] << ValueTrieLeafShift) |
      (cp & leaf_mask)
    let actual = if wide {
      guard off >> 1 >= 0 && off >> 1 < supp_leaf_packed.length() else {
        fail("\{property} wide supp leaf out of bounds at \{hex_literal(cp)}")
      }
      (supp_leaf_packed[off >> 1] >> ((off & 1) << 4)) & 0xFFFF
    } else {
      guard off >= 0 && off < supp_leaf.blocks.length() else {
        fail("\{property} supp leaf out of bounds at \{hex_literal(cp)}")
      }
      supp_leaf.blocks[off]
    }
    guard actual == values[cp] else {
      fail("\{property} supp mismatch at \{hex_literal(cp)}")
    }
  }
  if bmp_index_byte {
    self.write_byte_array(
      "\{property} BMP trie index: `cp >> \{ValueTrieBmpShift}` to leaf block index",
      "\{prefix}_bmp_index",
      bmp.ids,
    )
  } else {
    self.write_int_array(
      "\{property} BMP trie index: `cp >> \{ValueTrieBmpShift}` to leaf block index",
      "\{prefix}_bmp_index",
      bmp.ids,
      hex=false,
    )
  }
  if wide {
    self.write_int_array(
      "\{property} BMP trie leaf: 16-bit values in blocks of \{1 << ValueTrieBmpShift}, two per entry",
      "\{prefix}_bmp_leaf",
      bmp_leaf_packed,
      hex=false,
    )
  } else {
    self.write_byte_array(
      "\{property} BMP trie leaf: values in blocks of \{1 << ValueTrieBmpShift}",
      "\{prefix}_bmp_leaf",
      bmp.blocks,
    )
  }
  self.write_byte_array(
    "\{property} supplementary trie top level: `(cp - \{bmp_limit}) >> \{ValueTrieTopShift}` to mid block index",
    "\{prefix}_supp_top",
    supp_mid.ids,
  )
  if supp_mid_byte {
    self.write_byte_array(
      "\{property} supplementary trie mid level: leaf block indices",
      "\{prefix}_supp_mid",
      supp_mid.blocks,
    )
  } else {
    self.write_int_array(
      "\{property} supplementary trie mid level: leaf block indices",
      "\{prefix}_supp_mid",
      supp_mid.blocks,
      hex=false,
    )
  }
  if wide {
    self.write_int_array(
      "\{property} supplementary trie leaf level: 16-bit values in blocks of \{1 << ValueTrieLeafShift}, two per entry",
      "\{prefix}_supp_leaf",
      supp_leaf_packed,
      hex=false,
    )
  } else {
    self.write_byte_array(
      "\{property} supplementary trie leaf level: values in blocks of \{1 << ValueTrieLeafShift}",
      "\{prefix}_supp_leaf",
      supp_leaf.blocks,
    )
  }
  self.write_int_array(
    "\{property} ranges from \{trie_limit} packed as `start << \{range_value_bits} | value`",
    "\{prefix}_high_ranges",
    high_ranges,
    hex=true,
  )
  let supp_mid_load = if supp_mid_byte {
    "\{prefix}_supp_mid.unsafe_get(mid).to_int()"
  } else {
    "\{prefix}_supp_mid.unsafe_get(mid)"
  }
  let supp_leaf_expr = if wide {
    (
      $|  let offset = (leaf << \{ValueTrieLeafShift}) | (cp & \{leaf_mask})
      $|  (\{prefix}_supp_leaf.unsafe_get(offset >> 1) >> ((offset & 1) << 4)) & 0xFFFF
    )
  } else {
    "  \{prefix}_supp_leaf.unsafe_get((leaf << \{ValueTrieLeafShift}) | (cp & \{leaf_mask})).to_int()"
  }
  self.write(
    (
      $|///|
      $|/// Cold supplementary lookup for `cp >= \{bmp_limit}`.
      $|#inline(never)
      $|fn \{prefix}_lookup_supplementary(cp : Int) -> Int {
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
      $|  // SAFETY: cp is in [\{bmp_limit}, \{trie_limit}); generator validated all indices.
      $|  let mid = (\{prefix}_supp_top.unsafe_get((cp - \{bmp_limit}) >> \{ValueTrieTopShift}).to_int() << \{mid_shift}) |
      $|    ((cp >> \{ValueTrieLeafShift}) & \{mid_mask})
      $|  let leaf = \{supp_mid_load}
      $|\{supp_leaf_expr}
      $|}
      $|
      $|///|
      $|
    ),
  )
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
  let bmp_block_load = if bmp_index_byte {
    "\{prefix}_bmp_index.unsafe_get(cp >> \{ValueTrieBmpShift}).to_int()"
  } else {
    "\{prefix}_bmp_index.unsafe_get(cp >> \{ValueTrieBmpShift})"
  }
  let bmp_leaf_expr = if wide {
    (
      $|  let offset = (block << \{ValueTrieBmpShift}) | (cp & \{bmp_mask})
      $|  (\{prefix}_bmp_leaf.unsafe_get(offset >> 1) >> ((offset & 1) << 4)) & 0xFFFF
      $|}
      $|
    )
  } else {
    (
      $|  \{prefix}_bmp_leaf.unsafe_get((block << \{ValueTrieBmpShift}) | (cp & \{bmp_mask})).to_int()
      $|}
      $|
    )
  }
  self.write(
    (
      $|  if cp >= \{bmp_limit} {
      $|    return \{prefix}_lookup_supplementary(cp)
      $|  }
      $|  // SAFETY: cp is in [0, \{bmp_limit}); generator validated all indices.
      $|  let block = \{bmp_block_load}
      $|\{bmp_leaf_expr}
    ),
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
