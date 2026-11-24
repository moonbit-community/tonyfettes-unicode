///|
/// BMP binary properties use a two-level bitset trie with 256-code-point
/// (32-byte) leaf blocks, giving a 256-byte top index.
const BinaryTrieBmpLimit : Int32 = 0x10000

///|
const BinaryTrieBmpShift : Int32 = 8

///|
/// Binary property tries cover planes 0-3, like the General_Category trie.
/// The few ranges above are checked with explicit comparisons instead.
const BinaryTrieLimit : Int32 = 0x40000

///|
/// Each supplementary top-level trie entry covers `1 << BinaryTrieTopShift` code points.
const BinaryTrieTopShift : Int32 = 10

///|
/// Each supplementary leaf block is a bitset of `1 << BinaryTrieLeafShift` code points.
const BinaryTrieLeafShift : Int32 = 7

///|
/// Write a binary property as a two-level bitset trie for the BMP plus an
/// out-of-line supplementary trie for planes 1-3, followed by the lookup
/// function `is_<prefix>`, where `<prefix>` is the property name in lowercase
/// (`White_Space` becomes `white_space`).
///
/// Single-range properties (such as `Regional_Indicator` and `Emoji_Modifier`)
/// emit a direct range check with no tables.
fn write_binary_property_trie(
  out : @emitter.Emitter,
  property~ : String,
  lookup? : String,
  lookup_doc? : String,
  exported~ : Bool = true,
  ranges : Array[@parsing.CodePointRange],
) -> Unit raise {
  let prefix = property.to_lower()
  let visibility = if exported { "pub " } else { "" }
  let lookup = lookup.unwrap_or("is_\{prefix}")
  let lookup_doc = lookup_doc.unwrap_or(
    "Check whether a character has the Unicode \{property} property",
  )
  if ranges.length() == 1 {
    let range = ranges[0]
    let cond = if range.start == range.end {
      "cp == \{@emitter.hex_literal(range.start)}"
    } else {
      "cp >= \{@emitter.hex_literal(range.start)} && cp <= \{@emitter.hex_literal(range.end)}"
    }
    out.write(
      (
        $|///|
        $|/// \{lookup_doc}
        $|\{visibility}fn \{lookup}(c : Char) -> Bool {
        $|  let cp = c.to_int()
        $|  \{cond}
        $|}
        $|
      ),
    )
    return
  }
  let bmp_bits = Array::make(BinaryTrieBmpLimit / 8, 0)
  let supp_bits = Array::make((BinaryTrieLimit - BinaryTrieBmpLimit) / 8, 0)
  let mut has_supp = false
  let high_ranges : Array[@parsing.CodePointRange] = []
  for range in ranges {
    if range.start < BinaryTrieBmpLimit {
      for cp in range.start..<=Int32::min(range.end, BinaryTrieBmpLimit - 1) {
        bmp_bits[cp >> 3] = bmp_bits[cp >> 3] | (1 << (cp & 7))
      }
    }
    if range.end >= BinaryTrieBmpLimit && range.start < BinaryTrieLimit {
      has_supp = true
      let s = Int32::max(range.start, BinaryTrieBmpLimit)
      let e = Int32::min(range.end, BinaryTrieLimit - 1)
      for cp in s..<=e {
        let rel = cp - BinaryTrieBmpLimit
        supp_bits[rel >> 3] = supp_bits[rel >> 3] | (1 << (rel & 7))
      }
    }
    if range.end >= BinaryTrieLimit {
      high_ranges.push({
        start: Int32::max(range.start, BinaryTrieLimit),
        end: range.end,
      })
    }
  }
  // BMP two-level trie: 256-cp (32-byte) blocks -> 256-entry Bytes index.
  let bmp_block_bytes = 1 << (BinaryTrieBmpShift - 3)
  let bmp_byte_mask = bmp_block_bytes - 1
  let bmp = @emitter.deduplicate_blocks(bmp_bits, bmp_block_bytes)
  guard bmp.ids.all(id => id < 0x100) else {
    fail("\{property} BMP trie has too many blocks for one byte")
  }
  // Validate every BMP index before emitting unsafe_get.
  for cp in 0..<BinaryTrieBmpLimit {
    let idx = cp >> BinaryTrieBmpShift
    guard idx >= 0 && idx < bmp.ids.length() else {
      fail("\{property} BMP index out of bounds at \{@emitter.hex_literal(cp)}")
    }
    let off = (bmp.ids[idx] << (BinaryTrieBmpShift - 3)) |
      ((cp >> 3) & bmp_byte_mask)
    guard off >= 0 && off < bmp.blocks.length() else {
      fail("\{property} BMP leaf out of bounds at \{@emitter.hex_literal(cp)}")
    }
    let actual = ((bmp.blocks[off] >> (cp & 7)) & 1) != 0
    let expected = ((bmp_bits[cp >> 3] >> (cp & 7)) & 1) != 0
    guard actual == expected else {
      fail("\{property} BMP mismatch at \{@emitter.hex_literal(cp)}")
    }
  }
  out.write_byte_array(
    "\{property} BMP trie index: `cp >> \{BinaryTrieBmpShift}` to leaf block index",
    "\{prefix}_bmp_index",
    bmp.ids,
  )
  out.write_byte_array(
    "\{property} BMP trie leaf: bitsets of \{1 << BinaryTrieBmpShift} code points, least significant bit first",
    "\{prefix}_bmp_leaf",
    bmp.blocks,
  )
  let bmp_limit = @emitter.hex_literal(BinaryTrieBmpLimit)
  let supp_return = if !has_supp && high_ranges.is_empty() {
    "false"
  } else if !has_supp {
    high_ranges
    .map(range => {
      "(cp >= \{@emitter.hex_literal(range.start)} && cp <= \{@emitter.hex_literal(range.end)})"
    })
    .join(" || ")
  } else {
    let supp_leaf_bytes = 1 << (BinaryTrieLeafShift - 3)
    let supp_leaf = @emitter.deduplicate_blocks(supp_bits, supp_leaf_bytes)
    let supp_mid_shift = BinaryTrieTopShift - BinaryTrieLeafShift
    let supp_mid = @emitter.deduplicate_blocks(
      supp_leaf.ids,
      1 << supp_mid_shift,
    )
    guard supp_mid.ids.all(id => id < 0x100) else {
      fail(
        "\{property} supplementary trie has too many mid blocks for one byte",
      )
    }
    guard supp_mid.blocks.all(id => id < 0x100) else {
      fail(
        "\{property} supplementary trie has too many leaf blocks for one byte",
      )
    }
    let supp_mid_mask = (1 << supp_mid_shift) - 1
    let supp_byte_mask = supp_leaf_bytes - 1
    // Validate every supplementary index before emitting unsafe_get.
    for cp in BinaryTrieBmpLimit..<BinaryTrieLimit {
      let rel = cp - BinaryTrieBmpLimit
      let top_idx = rel >> BinaryTrieTopShift
      guard top_idx >= 0 && top_idx < supp_mid.ids.length() else {
        fail(
          "\{property} supp top out of bounds at \{@emitter.hex_literal(cp)}",
        )
      }
      let mid_idx = (supp_mid.ids[top_idx] << supp_mid_shift) |
        ((cp >> BinaryTrieLeafShift) & supp_mid_mask)
      guard mid_idx >= 0 && mid_idx < supp_mid.blocks.length() else {
        fail(
          "\{property} supp mid out of bounds at \{@emitter.hex_literal(cp)}",
        )
      }
      let off = (supp_mid.blocks[mid_idx] << (BinaryTrieLeafShift - 3)) |
        ((cp >> 3) & supp_byte_mask)
      guard off >= 0 && off < supp_leaf.blocks.length() else {
        fail(
          "\{property} supp leaf out of bounds at \{@emitter.hex_literal(cp)}",
        )
      }
      let actual = ((supp_leaf.blocks[off] >> (cp & 7)) & 1) != 0
      let expected = ((supp_bits[rel >> 3] >> (rel & 7)) & 1) != 0
      guard actual == expected else {
        fail("\{property} supp mismatch at \{@emitter.hex_literal(cp)}")
      }
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
    out.write_byte_array(
      "\{property} supplementary trie top level: `(cp - \{bmp_limit}) >> \{BinaryTrieTopShift}` to mid block index",
      "\{prefix}_supp_top",
      supp_mid.ids,
    )
    out.write_byte_array(
      "\{property} supplementary trie mid level: leaf block indices",
      "\{prefix}_supp_mid",
      supp_mid.blocks,
    )
    out.write_byte_array(
      "\{property} supplementary trie leaf level: bitsets of \{1 << BinaryTrieLeafShift} code points, least significant bit first",
      "\{prefix}_supp_leaf",
      supp_leaf.blocks,
    )
    out.write(
      (
        $|///|
        $|/// Cold supplementary lookup for `cp >= \{bmp_limit}`.
        $|#inline(never)
        $|fn \{prefix}_lookup_supplementary(cp : Int) -> Bool {
        $|  if cp >= \{@emitter.hex_literal(BinaryTrieLimit)} {
        $|    return \{high_check}
        $|  }
        $|  // SAFETY: cp is in [\{bmp_limit}, \{@emitter.hex_literal(BinaryTrieLimit)}); generator validated all indices.
        $|  let mid = (\{prefix}_supp_top.unsafe_get((cp - \{bmp_limit}) >> \{BinaryTrieTopShift}).to_int() << \{supp_mid_shift}) |
        $|    ((cp >> \{BinaryTrieLeafShift}) & \{supp_mid_mask})
        $|  let leaf = \{prefix}_supp_mid.unsafe_get(mid).to_int()
        $|  let bits = \{prefix}_supp_leaf.unsafe_get((leaf << \{BinaryTrieLeafShift - 3}) | ((cp >> 3) & \{supp_byte_mask})).to_int()
        $|  ((bits >> (cp & 7)) & 1) != 0
        $|}
        $|
      ),
    )
    "\{prefix}_lookup_supplementary(cp)"
  }
  out.write(
    (
      $|///|
      $|/// \{lookup_doc}
      $|\{visibility}fn \{lookup}(c : Char) -> Bool {
      $|  let cp = c.to_int()
      $|  if cp >= \{bmp_limit} {
      $|    return \{supp_return}
      $|  }
      $|  // SAFETY: cp is in [0, \{bmp_limit}); generator validated all indices.
      $|  let leaf = \{prefix}_bmp_index.unsafe_get(cp >> \{BinaryTrieBmpShift}).to_int()
      $|  let bits = \{prefix}_bmp_leaf.unsafe_get((leaf << \{BinaryTrieBmpShift - 3}) | ((cp >> 3) & \{bmp_byte_mask})).to_int()
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
