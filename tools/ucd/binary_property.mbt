///|
/// Binary property tries cover planes 0-3, like the General_Category trie.
/// The few ranges above are checked with explicit comparisons instead.
const BinaryTrieLimit : Int = 0x40000

///|
/// Each top-level trie entry covers `1 << BinaryTrieTopShift` code points.
const BinaryTrieTopShift : Int = 10

///|
/// Each leaf block is a bitset of `1 << BinaryTrieLeafShift` code points.
const BinaryTrieLeafShift : Int = 7

///|
fn hex_literal(value : Int) -> String {
  "0x\{value.to_string(radix=16).to_upper()}"
}

///|
/// Write a binary property as a three-level bitset trie for planes 0-3
/// named `<prefix>_trie_top`, `<prefix>_trie_mid`, and `<prefix>_trie_leaf`,
/// followed by the lookup function `is_<prefix>`, where `<prefix>` is the
/// property name in lowercase (`White_Space` becomes `white_space`).
///
/// The top level maps `cp >> 10` to a mid block, the mid level maps the next
/// three bits to a leaf block, and each leaf block holds one bit per code
/// point for 128 code points. Identical blocks are shared at both levels.
fn write_binary_property_trie(
  out : @emitter.Emitter,
  property~ : String,
  ranges : Array[CodePointRange],
) -> Unit raise {
  let prefix = property.to_lower()
  let bits = Array::make(BinaryTrieLimit / 8, 0)
  let high_ranges : Array[CodePointRange] = []
  for range in ranges {
    for cp in range.start..<=Int::min(range.end, BinaryTrieLimit - 1) {
      bits[cp >> 3] = bits[cp >> 3] | (1 << (cp & 7))
    }
    if range.end >= BinaryTrieLimit {
      high_ranges.push({
        start: Int::max(range.start, BinaryTrieLimit),
        end: range.end,
      })
    }
  }
  // Leaf level: bitset blocks; `leaf.ids` has one entry per leaf block.
  let leaf = deduplicate_blocks(bits, 1 << (BinaryTrieLeafShift - 3))
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = deduplicate_blocks(
    leaf.ids,
    1 << (BinaryTrieTopShift - BinaryTrieLeafShift),
  )
  guard mid.ids.iter().all(id => id < 0x100) else {
    fail("\{property} trie has too many mid blocks for one byte")
  }
  guard mid.blocks.iter().all(id => id < 0x100) else {
    fail("\{property} trie has too many leaf blocks for one byte")
  }
  let high_check = if high_ranges.is_empty() {
    "false"
  } else {
    high_ranges
    .map(range => {
      "(cp >= \{hex_literal(range.start)} && cp <= \{hex_literal(range.end)})"
    })
    .join(" || ")
  }
  let mid_mask = (1 << (BinaryTrieTopShift - BinaryTrieLeafShift)) - 1
  let byte_mask = (1 << (BinaryTrieLeafShift - 3)) - 1
  out.write_byte_array(
    "\{property} trie top level: `cp >> \{BinaryTrieTopShift}` to mid block index",
    "\{prefix}_trie_top",
    mid.ids,
  )
  out.write_byte_array(
    "\{property} trie mid level: leaf block indices",
    "\{prefix}_trie_mid",
    mid.blocks,
  )
  out.write_byte_array(
    "\{property} trie leaf level: bitsets of \{1 << BinaryTrieLeafShift} code points, least significant bit first",
    "\{prefix}_trie_leaf",
    leaf.blocks,
  )
  out.write(
    (
      $|///|
      $|/// Check whether a character has the Unicode \{property} property
      $|pub fn is_\{prefix}(c : Char) -> Bool {
      $|  let cp = c.to_int()
      $|  if cp >= \{hex_literal(BinaryTrieLimit)} {
      $|    return \{high_check}
      $|  }
      $|  let mid = (\{prefix}_trie_top[cp >> \{BinaryTrieTopShift}].to_int() << \{BinaryTrieTopShift - BinaryTrieLeafShift}) |
      $|    ((cp >> \{BinaryTrieLeafShift}) & \{mid_mask})
      $|  let leaf = \{prefix}_trie_mid[mid].to_int()
      $|  let bits = \{prefix}_trie_leaf[(leaf << \{BinaryTrieLeafShift - 3}) | ((cp >> 3) & \{byte_mask})].to_int()
      $|  ((bits >> (cp & 7)) & 1) != 0
      $|}
      $|
    ),
  )
}

///|
/// Emit a data file holding the trie and lookup function for one binary
/// property read from `source`.
fn emit_binary_property(
  property~ : String,
  source~ : String,
  ranges : Array[CodePointRange],
) -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header("\{property} lookup data", source)
  write_binary_property_trie(out, property~, ranges)
  out.finish()
}

///|
pub fn emit_alphabetic(properties : DerivedCoreProperties) -> String raise {
  emit_binary_property(
    property="Alphabetic",
    source="DerivedCoreProperties.txt",
    properties.alphabetic,
  )
}

///|
pub fn emit_lowercase(properties : DerivedCoreProperties) -> String raise {
  emit_binary_property(
    property="Lowercase",
    source="DerivedCoreProperties.txt",
    properties.lowercase,
  )
}

///|
pub fn emit_uppercase(properties : DerivedCoreProperties) -> String raise {
  emit_binary_property(
    property="Uppercase",
    source="DerivedCoreProperties.txt",
    properties.uppercase,
  )
}

///|
pub fn emit_white_space(properties : PropList) -> String raise {
  emit_binary_property(
    property="White_Space",
    source="PropList.txt",
    properties.white_space,
  )
}
