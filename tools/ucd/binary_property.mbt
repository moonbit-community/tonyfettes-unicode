///|
/// Binary property tries cover planes 0-3, like the General_Category trie.
/// The few ranges above are checked with explicit comparisons instead.
const BinaryTrieLimit : Int32 = 0x40000

///|
/// Each top-level trie entry covers `1 << BinaryTrieTopShift` code points.
const BinaryTrieTopShift : Int32 = 10

///|
/// Each leaf block is a bitset of `1 << BinaryTrieLeafShift` code points.
const BinaryTrieLeafShift : Int32 = 7

///|
/// Write a binary property as a three-level bitset trie for planes 0-3
/// named `<prefix>_trie_top`, `<prefix>_trie_mid`, and `<prefix>_trie_leaf`,
/// followed by the lookup function `is_<prefix>`, where `<prefix>` is the
/// property name in lowercase (`White_Space` becomes `white_space`).
///
/// A set of code points that is not a Unicode property passes `lookup`, the
/// name of the lookup function, and `lookup_doc`, its one-line description.
///
/// The top level maps `cp >> 10` to a mid block, the mid level maps the next
/// three bits to a leaf block, and each leaf block holds one bit per code
/// point for 128 code points. Identical blocks are shared at both levels.
fn write_binary_property_trie(
  out : @emitter.Emitter,
  property~ : String,
  lookup? : String,
  lookup_doc? : String,
  ranges : Array[@parsing.CodePointRange],
) -> Unit raise {
  let prefix = property.to_lower()
  let lookup = lookup.unwrap_or("is_\{prefix}")
  let lookup_doc = lookup_doc.unwrap_or(
    "Check whether a character has the Unicode \{property} property",
  )
  let bits = Array::make(BinaryTrieLimit / 8, 0)
  let high_ranges : Array[@parsing.CodePointRange] = []
  for range in ranges {
    for cp in range.start..<=Int32::min(range.end, BinaryTrieLimit - 1) {
      bits[cp >> 3] = bits[cp >> 3] | (1 << (cp & 7))
    }
    if range.end >= BinaryTrieLimit {
      high_ranges.push({
        start: Int32::max(range.start, BinaryTrieLimit),
        end: range.end,
      })
    }
  }
  // Leaf level: bitset blocks; `leaf.ids` has one entry per leaf block.
  let leaf = @emitter.deduplicate_blocks(bits, 1 << (BinaryTrieLeafShift - 3))
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = @emitter.deduplicate_blocks(
    leaf.ids,
    1 << (BinaryTrieTopShift - BinaryTrieLeafShift),
  )
  guard mid.ids.all(id => id < 0x100) else {
    fail("\{property} trie has too many mid blocks for one byte")
  }
  guard mid.blocks.all(id => id < 0x100) else {
    fail("\{property} trie has too many leaf blocks for one byte")
  }
  let high_check = if high_ranges.is_empty() {
    "false"
  } else {
    high_ranges
    .map(range => {
      "(cp >= \{@emitter.hex_literal(range.start)} && cp <= \{@emitter.hex_literal(range.end)})"
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
      $|/// \{lookup_doc}
      $|pub fn \{lookup}(c : Char) -> Bool {
      $|  let cp = c.to_int()
      $|  if cp >= \{@emitter.hex_literal(BinaryTrieLimit)} {
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
/// Emit a data file holding the trie and lookup function of the binary
/// property `property`, read from the UCD file `content`, whose name is
/// `source`.
pub fn emit_binary_property(
  content : String,
  property~ : String,
  source~ : String,
) -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header("\{property} lookup data", source)
  write_binary_property_trie(
    out,
    property~,
    parse_property_ranges(content, property),
  )
  out.finish()
}

///|
/// Emit XID_Start and XID_Continue from `DerivedCoreProperties.txt`.
pub fn emit_xid(content : String) -> String raise {
  let xid_start = parse_property_ranges(content, "XID_Start")
  let xid_continue = parse_property_ranges(content, "XID_Continue")
  validate_xid_subset(xid_start, xid_continue)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "XID_Start and XID_Continue lookup data", "DerivedCoreProperties.txt",
  )
  write_binary_property_trie(out, property="XID_Start", xid_start)
  write_binary_property_trie(out, property="XID_Continue", xid_continue)
  out.finish()
}

///|
/// Emit the emoji properties of `emoji-data.txt` and the characters
/// `emoji-variation-sequences.txt` lists a variation sequence for.
pub fn emit_emoji(
  emoji_data : String,
  variation_sequences : String,
) -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Extended_Pictographic, Emoji_Presentation, Emoji_Modifier, Emoji_Modifier_Base, and emoji variation sequence lookup data",
    "emoji-data.txt and emoji-variation-sequences.txt",
  )
  for
    property in [
      "Extended_Pictographic", "Emoji_Presentation", "Emoji_Modifier", "Emoji_Modifier_Base",
    ] {
    write_binary_property_trie(
      out,
      property~,
      parse_property_ranges(emoji_data, property),
    )
  }
  write_binary_property_trie(
    out,
    property="Emoji_Variation_Sequence",
    lookup="has_emoji_variation_sequence",
    lookup_doc="Check whether a character starts an emoji variation sequence",
    parse_emoji_variation_sequences(variation_sequences),
  )
  out.finish()
}

///|
/// Emit an independent punctuation table (General_Category group P). Keeping
/// it separate means code that only tests punctuation does not link the
/// General_Category trie.
pub fn emit_punctuation(data : UnicodeData) -> String raise {
  // Pc, Pd, Ps, Pe, Pi, Pf, and Po are ordinals 14 to 20.
  let ranges = ranges_where(data.general_categories, gc => gc >= 14 && gc <= 20)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Punctuation (General_Category group P) lookup data", "UnicodeData.txt",
  )
  write_binary_property_trie(
    out,
    property="Punctuation",
    lookup_doc="Check whether a character is punctuation (General_Category group P)",
    ranges,
  )
  out.finish()
}
