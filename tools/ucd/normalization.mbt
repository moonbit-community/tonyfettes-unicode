///|
/// A top block covers 128 code points; a leaf block holds four packed values.
const NormalizationTopShift : Int = 7

///|
const NormalizationLeafShift : Int = 2

///|
/// Pack CCC and Quick_Check properties. Zero means CCC=0 and all checks Yes.
/// Bits 0..7: CCC; 8..9: NFC_QC; 10..11: NFKC_QC;
/// bit 12: NFD_QC; bit 13: NFKD_QC. Quick_Check: Yes=0, No=1, Maybe=2.
fn normalization_values(
  ccc_ranges : Array[CccRange],
  derived_properties : String,
) -> Array[Int] raise {
  let values = Array::make(MaxCodePoint + 1, 0)
  for range in ccc_ranges {
    guard range.start >= 0 &&
      range.start <= range.end &&
      range.end <= MaxCodePoint &&
      range.value >= 0 &&
      range.value <= 255 else {
      fail("Invalid CCC range")
    }
    for cp in range.start..<=range.end {
      values[cp] = range.value
    }
  }
  let seen = Array::make(4, false)
  // Properties can have separate No and Maybe sections, so track duplicates
  // per code point rather than requiring globally sorted ranges.
  let assigned = Array::make(MaxCodePoint + 1, 0)
  for raw_line in derived_properties.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").to_array()
    if fields.length() < 2 {
      continue
    }
    let (index, shift, mask) = match fields[1].trim() {
      "NFC_QC" => (0, 8, 3)
      "NFKC_QC" => (1, 10, 3)
      "NFD_QC" => (2, 12, 1)
      "NFKD_QC" => (3, 13, 1)
      _ => continue
    }
    guard fields.length() == 3 else {
      fail("Quick_Check record must contain a range, property, and value")
    }
    let value = match fields[2].trim() {
      "Y" => 0
      "N" => 1
      "M" if mask == 3 => 2
      _ => fail("Invalid Quick_Check value")
    }
    let range = @parsing.parse_code_point_range(fields[0])
    guard range.start >= 0 &&
      range.start <= range.end &&
      range.end <= MaxCodePoint else {
      fail("Invalid Quick_Check range")
    }
    seen[index] = true
    for cp in range.start..<=range.end {
      guard (assigned[cp] & (1 << index)) == 0 else {
        fail("Overlapping Quick_Check ranges")
      }
      assigned[cp] = assigned[cp] | (1 << index)
      values[cp] = values[cp] | (value << shift)
    }
  }
  guard seen.iter().all(value => value) else {
    fail("Missing Quick_Check properties")
  }
  values
}

///|
/// Emit a norm16 trie. Values below 0x8000 contain packed properties directly;
/// values with bit 15 set index six-byte records (properties, decomposition row
/// + 1, composition group + 1). Zero indices denote absent mappings/groups.
pub fn emit_normalization(
  data : UnicodeData,
  compositions : Array[CompositionEntry],
  derived_properties : String,
) -> String raise {
  let values = normalization_values(
    compress_ccc_ranges(data),
    derived_properties,
  )
  let decomp_indices = Array::make(MaxCodePoint + 1, 0)
  for index, entry in decomposition_entries(data) {
    guard index < 65535 else { fail("Too many decomposition rows for norm16") }
    decomp_indices[entry.code_point] = index + 1
  }
  let composition_groups = Array::make(MaxCodePoint + 1, 0)
  let offsets = composition_group_offsets(compositions)
  for group in 0..<(offsets.length() - 1) {
    guard group < 65535 else { fail("Too many composition groups for norm16") }
    composition_groups[compositions[offsets[group]].first] = group + 1
  }
  let extra : Array[Int] = []
  for cp in 0..<=MaxCodePoint {
    if decomp_indices[cp] != 0 || composition_groups[cp] != 0 {
      let record = extra.length() / 6
      guard record < 32768 else { fail("Too many extra records for norm16") }
      for field in [values[cp], decomp_indices[cp], composition_groups[cp]] {
        extra.push(field & 255)
        extra.push(field >> 8)
      }
      values[cp] = 0x8000 | record
    }
  }
  let mut last = MaxCodePoint
  while last > 0 && values[last] == 0 {
    last -= 1
  }
  let top_size = 1 << NormalizationTopShift
  let limit = (last + top_size) / top_size * top_size
  let leaf = deduplicate_blocks(
    values[:limit].to_owned(),
    1 << NormalizationLeafShift,
  )
  let mid = deduplicate_blocks(
    leaf.ids,
    1 << (NormalizationTopShift - NormalizationLeafShift),
  )
  guard mid.ids.iter().all(id => id < 256) &&
    mid.blocks.iter().all(id => id < 65536) else {
    fail("Normalization trie block indices exceed their encoded width")
  }
  let mid_bytes : Array[Int] = []
  for value in mid.blocks {
    mid_bytes.push(value & 255)
    mid_bytes.push(value >> 8)
  }
  let leaf_bytes : Array[Int] = []
  for value in leaf.blocks {
    leaf_bytes.push(value & 255)
    leaf_bytes.push(value >> 8)
  }
  let mid_shift = NormalizationTopShift - NormalizationLeafShift
  let mid_mask = (1 << mid_shift) - 1
  let leaf_mask = (1 << NormalizationLeafShift) - 1
  // Check the encoded representation, including the implicit default tail,
  // before emitting source. This also guards changes to the block layout.
  for cp in 0..<=MaxCodePoint {
    let actual = if cp >= limit {
      0
    } else {
      let mid_index = (mid.ids[cp >> NormalizationTopShift] << mid_shift) |
        ((cp >> NormalizationLeafShift) & mid_mask)
      let leaf_index = mid_bytes[mid_index * 2] |
        (mid_bytes[mid_index * 2 + 1] << 8)
      let offset = ((leaf_index << NormalizationLeafShift) | (cp & leaf_mask)) *
        2
      leaf_bytes[offset] | (leaf_bytes[offset + 1] << 8)
    }
    guard actual == values[cp] else {
      fail("Normalization trie mismatch at code point \{cp}")
    }
  }
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Normalization descriptors (Unicode 16.0.0)", "UnicodeData.txt, CompositionExclusions.txt and DerivedNormalizationProps.txt",
  )
  out.write_byte_array(
    "Top-level block indices (\{top_size} code points per block)",
    "normalization_trie_top",
    mid.ids,
  )
  out.write_byte_array(
    "Little-endian 16-bit leaf block indices (\{1 << NormalizationLeafShift} code points per block)",
    "normalization_trie_mid",
    mid_bytes,
  )
  out.write_byte_array(
    "Little-endian norm16 values: direct properties or tagged extra-record indices",
    "normalization_trie_leaf", leaf_bytes,
  )
  out.write_byte_array(
    "Six-byte records: packed properties, decomposition row + 1, composition group + 1 (all u16 LE)",
    "normalization_extra", extra,
  )
  out.write(
    (
      $|///|
      $|/// Bit 15 tags an extra-record index; otherwise the value is packed properties.
      $|fn lookup_norm16(c : Char) -> Int {
      $|  let cp = c.to_int()
      $|  if cp >= \{limit} {
      $|    return 0
      $|  }
      $|  let mid = (normalization_trie_top[cp >> \{NormalizationTopShift}].to_int() << \{mid_shift}) |
      $|    ((cp >> \{NormalizationLeafShift}) & \{mid_mask})
      $|  let leaf = normalization_trie_mid[mid * 2].to_int() |
      $|    (normalization_trie_mid[mid * 2 + 1].to_int() << 8)
      $|  let offset = ((leaf << \{NormalizationLeafShift}) |
      $|    (cp & \{leaf_mask})) * 2
      $|  normalization_trie_leaf[offset].to_int() |
      $|    (normalization_trie_leaf[offset + 1].to_int() << 8)
      $|}
      $|
      $|///|
      $|/// Packed properties. Bits 0..7: CCC; 8..9: NFC_QC; 10..11: NFKC_QC;
      $|/// bit 12: NFD_QC; bit 13: NFKD_QC. Yes=0, No=1, Maybe=2 (NFC/NFKC).
      $|pub fn lookup_normalization_properties(c : Char) -> Int {
      $|  let norm16 = lookup_norm16(c)
      $|  if norm16 < 0x8000 {
      $|    return norm16
      $|  }
      $|  let offset = (norm16 & 0x7FFF) * 6
      $|  normalization_extra[offset].to_int() |
      $|    (normalization_extra[offset + 1].to_int() << 8)
      $|}
      $|
      $|///|
      $|pub fn normalization_decomposition_index(c : Char) -> Int {
      $|  let norm16 = lookup_norm16(c)
      $|  if norm16 < 0x8000 { return -1 }
      $|  let offset = (norm16 & 0x7FFF) * 6 + 2
      $|  (normalization_extra[offset].to_int() |
      $|    (normalization_extra[offset + 1].to_int() << 8)) - 1
      $|}
      $|
      $|///|
      $|pub fn normalization_composition_group(c : Char) -> Int {
      $|  let norm16 = lookup_norm16(c)
      $|  if norm16 < 0x8000 { return -1 }
      $|  let offset = (norm16 & 0x7FFF) * 6 + 4
      $|  (normalization_extra[offset].to_int() |
      $|    (normalization_extra[offset + 1].to_int() << 8)) - 1
      $|}
      $|
    ),
  )
  out.finish()
}
