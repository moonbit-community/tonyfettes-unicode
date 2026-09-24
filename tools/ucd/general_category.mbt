///|
/// General_Category ordinal of Cn (Unassigned), the value of every code point
/// not listed in UnicodeData.txt.
const GcUnassigned : Int = 29

///|
/// Number of low bits holding the General_Category ordinal in a packed range.
const GcValueBits : Int = 5

///|
const MaxCodePoint : Int = 0x10FFFF

///|
/// The trie covers planes 0-3; the higher planes are almost entirely
/// unassigned or private use and are looked up as packed ranges instead.
const GcTrieLimit : Int = 0x40000

///|
/// Each top-level trie entry covers `1 << GcTrieTopShift` code points.
const GcTrieTopShift : Int = 8

///|
/// Each leaf block holds `1 << GcTrieLeafShift` General_Category ordinals.
const GcTrieLeafShift : Int = 4

///|
/// Pack the ranges covering `[GcTrieLimit, MaxCodePoint]` as
/// `start << GcValueBits | ordinal`, so the packed values sort by start code
/// point. Gaps before, between, and after the ranges become Cn entries.
fn pack_high_ranges(ranges : Array[GeneralCategoryRange]) -> Array[Int] {
  let packed = []
  let mut next = GcTrieLimit
  for range in ranges {
    if range.start > next {
      packed.push((next << GcValueBits) | GcUnassigned)
    }
    packed.push((range.start << GcValueBits) | range.value)
    next = range.end + 1
  }
  if next <= MaxCodePoint {
    packed.push((next << GcValueBits) | GcUnassigned)
  }
  packed
}

///|
/// Emit General_Category data as a three-level trie for planes 0-3, with
/// packed ranges for the remaining planes.
///
/// The top level maps `cp >> 8` to a mid block, the mid level maps the next
/// four bits to a leaf block, and the leaf level stores one ordinal per code
/// point. Identical blocks are shared at both levels.
pub fn emit_general_category(
  ranges : Array[GeneralCategoryRange],
) -> String raise {
  let values = Array::make(GcTrieLimit, GcUnassigned)
  let high_ranges : Array[GeneralCategoryRange] = []
  for range in ranges {
    for cp in range.start..<=Int::min(range.end, GcTrieLimit - 1) {
      values[cp] = range.value
    }
    if range.end >= GcTrieLimit {
      high_ranges.push({
        start: Int::max(range.start, GcTrieLimit),
        end: range.end,
        value: range.value,
      })
    }
  }
  // Leaf level: blocks of code point ordinals.
  let leaf = deduplicate_blocks(values, 1 << GcTrieLeafShift)
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = deduplicate_blocks(
    leaf.ids,
    1 << (GcTrieTopShift - GcTrieLeafShift),
  )
  guard mid.ids.iter().all(id => id < 0x100) else {
    fail("General_Category trie has too many mid blocks for one byte")
  }
  guard mid.blocks.iter().all(id => id < 0x10000) else {
    fail("General_Category trie has too many leaf blocks for two bytes")
  }
  let mid_bytes = []
  for id in mid.blocks {
    mid_bytes.push(id >> 8)
    mid_bytes.push(id & 0xFF)
  }
  let trie_limit = "0x\{GcTrieLimit.to_string(radix=16).to_upper()}"
  let mid_mask = (1 << (GcTrieTopShift - GcTrieLeafShift)) - 1
  let leaf_mask = (1 << GcTrieLeafShift) - 1
  let value_mask = (1 << GcValueBits) - 1
  let out = @emitter.Emitter::new()
  out.write_file_header("General_Category lookup data", "UnicodeData.txt")
  out.write_byte_array(
    "General_Category trie top level: `cp >> \{GcTrieTopShift}` to mid block index",
    "gc_trie_top",
    mid.ids,
  )
  out.write_byte_array(
    "General_Category trie mid level: big-endian 16-bit leaf block indices", "gc_trie_mid",
    mid_bytes,
  )
  out.write_byte_array(
    "General_Category trie leaf level: ordinals in blocks of \{1 << GcTrieLeafShift}",
    "gc_trie_leaf",
    leaf.blocks,
  )
  out.write_int_array(
    "General_Category ranges from \{trie_limit} packed as `start << \{GcValueBits} | ordinal`",
    "gc_high_ranges",
    pack_high_ranges(high_ranges),
    hex=true,
  )
  out.write(
    (
      $|///|
      $|/// Look up General_Category ordinal for a character
      $|/// Returns ordinal value (0-29) corresponding to GeneralCategory enum
      $|pub fn lookup_general_category(c : Char) -> Int {
      $|  let cp = c.to_int()
      $|  if cp >= \{trie_limit} {
      $|    // Binary search for the last range starting at or before `cp`.
      $|    let key = (cp << \{GcValueBits}) | \{value_mask}
      $|    let mut low = 0
      $|    let mut high = gc_high_ranges.length()
      $|    while high - low > 1 {
      $|      let mid = (low + high) / 2
      $|      if gc_high_ranges[mid] <= key {
      $|        low = mid
      $|      } else {
      $|        high = mid
      $|      }
      $|    }
      $|    return gc_high_ranges[low] & \{value_mask}
      $|  }
      $|  let mid = (gc_trie_top[cp >> \{GcTrieTopShift}].to_int() << \{GcTrieTopShift - GcTrieLeafShift}) |
      $|    ((cp >> \{GcTrieLeafShift}) & \{mid_mask})
      $|  let leaf = (gc_trie_mid[2 * mid].to_int() << 8) |
      $|    gc_trie_mid[2 * mid + 1].to_int()
      $|  gc_trie_leaf[(leaf << \{GcTrieLeafShift}) | (cp & \{leaf_mask})].to_int()
      $|}
      $|
    ),
  )
  out.finish()
}
