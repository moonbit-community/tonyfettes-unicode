///|
/// BMP lookups use one block-offset load and one norm16 value load.
const NormalizationBmpShift : Int = 5

///|
const NormalizationBmpLimit : Int = 0x10000

///|
/// Supplementary top blocks cover 128 code points; leaves hold four values.
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
  let limit = Int::max(
    NormalizationBmpLimit,
    (last + top_size) / top_size * top_size,
  )
  let bmp = deduplicate_blocks(
    values[:NormalizationBmpLimit].to_owned(),
    1 << NormalizationBmpShift,
  )
  let bmp_offsets = bmp.ids.map(id => id << NormalizationBmpShift)
  let leaf = deduplicate_blocks(
    values[NormalizationBmpLimit:limit].to_owned(),
    1 << NormalizationLeafShift,
  )
  let mid = deduplicate_blocks(
    leaf.ids,
    1 << (NormalizationTopShift - NormalizationLeafShift),
  )
  guard mid.ids.iter().all(id => id < 256) else {
    fail("Normalization trie top indices exceed their encoded width")
  }
  let mid_shift = NormalizationTopShift - NormalizationLeafShift
  let mid_mask = (1 << mid_shift) - 1
  let leaf_mask = (1 << NormalizationLeafShift) - 1
  // Check the encoded representation, including the implicit default tail,
  // before emitting source. This also guards changes to the block layout.
  for cp in 0..<=MaxCodePoint {
    let actual = if cp < NormalizationBmpLimit {
      bmp.blocks[bmp_offsets[cp >> NormalizationBmpShift] +
      (cp & ((1 << NormalizationBmpShift) - 1))]
    } else if cp >= limit {
      0
    } else {
      let mid_index = (
          mid.ids[(cp - NormalizationBmpLimit) >> NormalizationTopShift] <<
          mid_shift
        ) |
        ((cp >> NormalizationLeafShift) & mid_mask)
      let leaf_index = mid.blocks[mid_index]
      leaf.blocks[(leaf_index << NormalizationLeafShift) | (cp & leaf_mask)]
    }
    guard actual == values[cp] else {
      fail("Normalization trie mismatch at code point \{cp}")
    }
  }
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Normalization descriptors (Unicode 16.0.0)", "UnicodeData.txt, CompositionExclusions.txt and DerivedNormalizationProps.txt",
  )
  // Int constants are emitted as compact static data on every backend.
  // UInt16 array literals currently expand to per-element initialization in Wasm-GC.
  out.write_int_array(
    "BMP block offsets (\{1 << NormalizationBmpShift} code points per block)",
    "normalization_bmp_index",
    bmp_offsets,
    hex=false,
  )
  out.write_int_array(
    "BMP norm16 values: direct properties or tagged extra-record indices",
    "normalization_bmp_data",
    bmp.blocks,
    hex=false,
  )
  out.write_byte_array(
    "Supplementary top-level block indices (\{top_size} code points per block)",
    "normalization_trie_top",
    mid.ids,
  )
  out.write_int_array(
    "Supplementary leaf block indices (\{1 << NormalizationLeafShift} code points per block)",
    "normalization_trie_mid",
    mid.blocks,
    hex=false,
  )
  out.write_int_array(
    "Supplementary norm16 values: direct properties or tagged extra-record indices",
    "normalization_trie_leaf",
    leaf.blocks,
    hex=false,
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
      $|  if cp < \{NormalizationBmpLimit} {
      $|    return lookup_bmp_norm16(cp)
      $|  }
      $|  lookup_supplementary_norm16(cp)
      $|}
      $|
      $|///|
      $|/// Two indexed loads for BMP normalization descriptors.
      $|fn lookup_bmp_norm16(cp : Int) -> Int {
      $|  normalization_bmp_data[normalization_bmp_index[cp >> \{NormalizationBmpShift}] + (cp & \{(1 << NormalizationBmpShift) - 1})]
      $|}
      $|
      $|///|
      $|/// Keep the compressed supplementary path out of the BMP lookup.
      $|fn lookup_supplementary_norm16(cp : Int) -> Int {
      $|  if cp >= \{limit} {
      $|    return 0
      $|  }
      $|  let mid = (normalization_trie_top[(cp - \{NormalizationBmpLimit}) >> \{NormalizationTopShift}].to_int() << \{mid_shift}) |
      $|    ((cp >> \{NormalizationLeafShift}) & \{mid_mask})
      $|  let leaf = normalization_trie_mid[mid]
      $|  normalization_trie_leaf[(leaf << \{NormalizationLeafShift}) | (cp & \{leaf_mask})]
      $|}
      $|
      $|///|
      $|/// Packed properties. Bits 0..7: CCC; 8..9: NFC_QC; 10..11: NFKC_QC;
      $|/// bit 12: NFD_QC; bit 13: NFKD_QC. Yes=0, No=1, Maybe=2 (NFC/NFKC).
      $|pub fn lookup_normalization_properties(c : Char) -> Int {
      $|  // Dispatch here so the full-scan property path has no extra lookup wrapper.
      $|  let cp = c.to_int()
      $|  let norm16 = if cp < \{NormalizationBmpLimit} {
      $|    lookup_bmp_norm16(cp)
      $|  } else {
      $|    lookup_supplementary_norm16(cp)
      $|  }
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
