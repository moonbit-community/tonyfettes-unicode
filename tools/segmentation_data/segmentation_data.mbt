///|
const MaxCodePoint : Int = 0x10FFFF

///|
/// Number of low bits holding the Grapheme_Cluster_Break code in a packed
/// value.
const GcbBits : Int = 4

///|
/// Number of bits holding the Indic_Conjunct_Break code, above the
/// Grapheme_Cluster_Break code.
const InCBBits : Int = 2

///|
/// Total number of bits in a packed value: Grapheme_Cluster_Break,
/// Indic_Conjunct_Break, and the Extended_Pictographic flag.
const ValueBits : Int = 7

///|
/// The trie covers planes 0-3; the higher planes hold only a few tag and
/// variation selector ranges and are looked up as packed ranges instead.
const TrieLimit : Int = 0x40000

///|
/// Each top-level trie entry covers `1 << TrieTopShift` code points.
const TrieTopShift : Int = 8

///|
/// Each leaf block holds `1 << TrieLeafShift` packed values.
const TrieLeafShift : Int = 4

///|
/// Grapheme_Cluster_Break values in code order. `Other` is the default for
/// code points GraphemeBreakProperty.txt does not list; the generated source
/// has no constant for it.
let grapheme_cluster_break_names : ReadOnlyArray[String] = [
  "Other", "CR", "LF", "Control", "Extend", "ZWJ", "Regional_Indicator", "Prepend",
  "SpacingMark", "L", "V", "T", "LV", "LVT",
]

///|
/// Indic_Conjunct_Break values in code order. `None` is the default for code
/// points DerivedCoreProperties.txt does not list; the generated source has no
/// constant for it.
let indic_conjunct_break_names : ReadOnlyArray[String] = [
  "None", "Consonant", "Extend", "Linker",
]

///|
fn property_code(
  property : String,
  names : ReadOnlyArray[String],
  name : StringView,
) -> Int raise {
  for code, candidate in names {
    if name == candidate {
      return code
    }
  }
  fail("Unknown \{property}: \{name}")
}

///|
/// Combine `bits << shift` into the packed value of every code point in
/// `range`.
fn set_range_bits(
  values : Array[Int],
  range : @parsing.CodePointRange,
  bits : Int,
  shift : Int,
) -> Unit {
  for code_point in range.start..<=range.end {
    values[code_point] = values[code_point] | (bits << shift)
  }
}

///|
/// Compute the packed value of every code point:
/// `extended_pictographic << 6 | indic_conjunct_break << 4 |
/// grapheme_cluster_break`.
fn parse_grapheme_break_values(
  grapheme_break_property : String,
  emoji_data : String,
  derived_core_properties : String,
) -> Array[Int] raise {
  let values = Array::make(MaxCodePoint + 1, 0)
  for raw_line in grapheme_break_property.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    guard line.split(";").collect() is [range, name, ..] else { continue }
    set_range_bits(
      values,
      @parsing.parse_code_point_range(range),
      property_code(
        "Grapheme_Cluster_Break",
        grapheme_cluster_break_names,
        name.trim(),
      ),
      0,
    )
  }
  for raw_line in derived_core_properties.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    guard line.split(";").collect() is [range, property, name, ..] &&
      property.trim() == "InCB" else {
      continue
    }
    set_range_bits(
      values,
      @parsing.parse_code_point_range(range),
      property_code(
        "Indic_Conjunct_Break",
        indic_conjunct_break_names,
        name.trim(),
      ),
      GcbBits,
    )
  }
  for raw_line in emoji_data.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    guard line.split(";").collect() is [range, property, ..] &&
      property.trim() == "Extended_Pictographic" else {
      continue
    }
    set_range_bits(
      values,
      @parsing.parse_code_point_range(range),
      1,
      GcbBits + InCBBits,
    )
  }
  values
}

///|
/// Emit the grapheme cluster break properties as a three-level trie for
/// planes 0-3, with packed ranges for the remaining planes.
///
/// The top level maps `cp >> 8` to a mid block, the mid level maps the next
/// four bits to a leaf block, and the leaf level stores one packed value per
/// code point. Identical blocks are shared at both levels.
pub fn generate_grapheme_break_source(
  grapheme_break_property : String,
  emoji_data : String,
  derived_core_properties : String,
) -> String raise {
  let values = parse_grapheme_break_values(
    grapheme_break_property, emoji_data, derived_core_properties,
  )
  // `start << ValueBits | value`, so the packed ranges sort by start code
  // point. The ranges cover every code point from `TrieLimit` without gaps.
  let high_ranges : Array[Int] = []
  for code_point in TrieLimit..<=MaxCodePoint {
    if code_point == TrieLimit || values[code_point] != values[code_point - 1] {
      high_ranges.push((code_point << ValueBits) | values[code_point])
    }
  }
  values.truncate(TrieLimit)
  // Leaf level: blocks of packed values.
  let leaf = @trie.deduplicate_blocks(values, 1 << TrieLeafShift)
  // Mid level: blocks of leaf block indices; `mid.ids` is the top level.
  let mid = @trie.deduplicate_blocks(
    leaf.ids,
    1 << (TrieTopShift - TrieLeafShift),
  )
  guard mid.ids.iter().all(id => id < 0x100) else {
    fail("Grapheme break trie has too many mid blocks for one byte")
  }
  guard mid.blocks.iter().all(id => id < 0x10000) else {
    fail("Grapheme break trie has too many leaf blocks for two bytes")
  }
  let mid_bytes = []
  for id in mid.blocks {
    mid_bytes.push(id >> 8)
    mid_bytes.push(id & 0xFF)
  }
  let trie_limit = "0x\{@emitter.hex_upper(TrieLimit)}"
  let mid_mask = (1 << (TrieTopShift - TrieLeafShift)) - 1
  let leaf_mask = (1 << TrieLeafShift) - 1
  let value_mask = (1 << ValueBits) - 1
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Grapheme cluster break properties for Unicode Text Segmentation (UAX #29)",
    "GraphemeBreakProperty.txt, emoji-data.txt, and DerivedCoreProperties.txt",
  )
  for code, name in grapheme_cluster_break_names {
    if code == 0 {
      continue
    }
    out.write(
      (
        $|///|
        $|/// Grapheme_Cluster_Break=\{name}
        $|const Gcb\{name.replace_all(old="_", new="")} : Int = \{code}
        $|
        $|
      ),
    )
  }
  for code, name in indic_conjunct_break_names {
    if code == 0 {
      continue
    }
    out.write(
      (
        $|///|
        $|/// Indic_Conjunct_Break=\{name}
        $|const InCB\{name} : Int = \{code}
        $|
        $|
      ),
    )
  }
  out.write(
    (
      $|///|
      $|/// Mask selecting the Grapheme_Cluster_Break code of a packed value.
      $|const GcbMask : Int = \{(1 << GcbBits) - 1}
      $|
      $|///|
      $|/// Shift moving the Indic_Conjunct_Break code of a packed value to bit 0.
      $|const InCBShift : Int = \{GcbBits}
      $|
      $|///|
      $|/// Mask selecting the Indic_Conjunct_Break code after shifting.
      $|const InCBMask : Int = \{(1 << InCBBits) - 1}
      $|
      $|///|
      $|/// Bit set in a packed value for Extended_Pictographic code points.
      $|const ExtendedPictographicBit : Int = \{1 << (GcbBits + InCBBits)}
      $|
      $|
    ),
  )
  out.write_byte_array(
    "Grapheme break trie top level: `cp >> \{TrieTopShift}` to mid block index",
    "grapheme_break_trie_top",
    mid.ids,
  )
  out.write_byte_array(
    "Grapheme break trie mid level: big-endian 16-bit leaf block indices", "grapheme_break_trie_mid",
    mid_bytes,
  )
  out.write_byte_array(
    "Grapheme break trie leaf level: packed values in blocks of \{1 << TrieLeafShift}",
    "grapheme_break_trie_leaf",
    leaf.blocks,
  )
  out.write_int_array(
    "Grapheme break ranges from \{trie_limit} packed as `start << \{ValueBits} | value`",
    "grapheme_break_high_ranges",
    high_ranges,
    hex=true,
  )
  out.write(
    (
      $|///|
      $|/// Look up the packed grapheme cluster break properties of a code point:
      $|/// `extended_pictographic << \{GcbBits + InCBBits} | indic_conjunct_break << \{GcbBits} |
      $|/// grapheme_cluster_break`.
      $|fn grapheme_break_value(cp : Int) -> Int {
      $|  if cp >= \{trie_limit} {
      $|    // Binary search for the last range starting at or before `cp`.
      $|    let key = (cp << \{ValueBits}) | \{value_mask}
      $|    let mut low = 0
      $|    let mut high = grapheme_break_high_ranges.length()
      $|    while high - low > 1 {
      $|      let mid = (low + high) / 2
      $|      if grapheme_break_high_ranges[mid] <= key {
      $|        low = mid
      $|      } else {
      $|        high = mid
      $|      }
      $|    }
      $|    return grapheme_break_high_ranges[low] & \{value_mask}
      $|  }
      $|  let mid = (grapheme_break_trie_top[cp >> \{TrieTopShift}].to_int() << \{TrieTopShift - TrieLeafShift}) |
      $|    ((cp >> \{TrieLeafShift}) & \{mid_mask})
      $|  let leaf = (grapheme_break_trie_mid[2 * mid].to_int() << 8) |
      $|    grapheme_break_trie_mid[2 * mid + 1].to_int()
      $|  grapheme_break_trie_leaf[(leaf << \{TrieLeafShift}) | (cp & \{leaf_mask})].to_int()
      $|}
      $|
    ),
  )
  out.finish()
}
