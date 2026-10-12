///|
/// The scan table covers 32 BMP code points per block, like the norm16 trie.
const NormalizationScanShift : Int32 = 5

///|
/// Supplementary groups with flags store them in blocks of 16 code points.
const NormalizationPairShift : Int32 = 4

///|
/// Scan flag of a leading surrogate; Quick_Check bits stay below it.
const NormalizationScanLeadSurrogate : Int32 = 0x80

///|
/// Reduce packed properties to the byte the UTF-16 scan tests: bit 0 marks a
/// nonzero CCC and bits 1..6 are the Quick_Check bits 8..13. A properties mask
/// `255 | quick_check_bits` therefore becomes a scan mask by shifting right 7.
fn normalization_scan_flags(properties : Int32) -> Int32 {
  let quick_check = properties >> 8 << 1
  if (properties & 255) != 0 {
    quick_check | 1
  } else {
    quick_check
  }
}

///|
/// Emit private UTF-16 scan data next to the normalizer's hot loops. The
/// published lookup functions are not inlined across packages, so the scan
/// reads these one-byte flags itself and asks for full properties only where
/// it stops.
pub fn emit_normalization_scan(
  data : UnicodeData,
  derived_properties : String,
) -> String raise {
  let values = normalization_values(
    compress_ccc_ranges(data),
    derived_properties,
  ).map(normalization_scan_flags)
  let lead_flags = Array::make(1024, 0)
  for cp in NormalizationBmpLimit..<=MaxCodePoint {
    let lead = (cp - NormalizationBmpLimit) >> 10
    lead_flags[lead] = lead_flags[lead] | values[cp]
  }
  for cp in 0xD800..<0xE000 {
    guard values[cp] == 0 else {
      fail("Surrogate code points must have default normalization properties")
    }
  }
  let mut last = MaxCodePoint
  while last >= NormalizationBmpLimit && values[last] == 0 {
    last -= 1
  }
  // The scan needs only CCC/Quick_Check flags, not decomposition/composition
  // record indices. All code points at or above this limit are safe starters.
  let limit = last + 1
  let lead_limit = (limit - NormalizationBmpLimit + 1023) >> 10
  let tail_lead = (limit - NormalizationBmpLimit) >> 10
  let tail_trail = 0xDC00 + ((limit - NormalizationBmpLimit) & 1023)
  for cp in NormalizationBmpLimit..<=MaxCodePoint {
    let lead = (cp - NormalizationBmpLimit) >> 10
    let trail = 0xDC00 + (cp & 1023)
    let default_tail = lead > tail_lead ||
      (lead == tail_lead && trail >= tail_trail)
    guard default_tail == (cp >= limit) else {
      fail("Normalization UTF-16 boundary mismatch at code point \{cp}")
    }
    if default_tail {
      guard values[cp] == 0 else {
        fail("Nonzero normalization scan tail at code point \{cp}")
      }
    } else {
      guard lead >= 0 && lead < lead_limit else {
        fail("Normalization lead index out of bounds at code point \{cp}")
      }
      guard (lead_flags[lead] & values[cp]) == values[cp] else {
        fail("Lead surrogate summary lost properties at code point \{cp}")
      }
    }
  }
  // Leading surrogates have no flags of their own. Marking them lets the scan
  // find a pair with the lookup it does for every other BMP code unit.
  let bmp_values = values[:NormalizationBmpLimit].to_owned()
  for cp in 0xD800..<0xDC00 {
    bmp_values[cp] = NormalizationScanLeadSurrogate
  }
  let block_size = 1 << NormalizationScanShift
  let bmp = @trie.deduplicate_blocks(bmp_values, block_size)
  guard bmp.ids.iter().all(id => id >= 0 && id < 256) else {
    fail("Normalization scan block indices exceed their encoded width")
  }
  // The scan reads both tables unchecked for every UTF-16 code unit.
  for cp in 0..<NormalizationBmpLimit {
    let index = (
        bmp.ids[cp >> NormalizationScanShift] << NormalizationScanShift
      ) |
      (cp & (block_size - 1))
    guard index < bmp.blocks.length() else {
      fail("Normalization scan index out of bounds at code point \{cp}")
    }
    guard bmp.blocks[index] == bmp_values[cp] else {
      fail("Normalization scan flags mismatch at code point \{cp}")
    }
  }
  // Only a few groups of 1024 supplementary code points have flags. Give each
  // a slot holding its own flags, so the scan never has to ask for the full
  // properties of a pair. Slot 0 is clear and serves every other group.
  let pair_block_size = 1 << NormalizationPairShift
  let pair_blocks_per_group = 1024 / pair_block_size
  let lead_slots = Array::make(lead_limit, 0)
  let pair_values = Array::make(1024, 0)
  for lead in 0..<lead_limit {
    if lead_flags[lead] != 0 {
      lead_slots[lead] = pair_values.length() / 1024
      let start = NormalizationBmpLimit + (lead << 10)
      pair_values.append(values[start:start + 1024])
    }
  }
  let pairs = @trie.deduplicate_blocks(pair_values, pair_block_size)
  guard lead_slots.iter().all(slot => slot < 256) &&
    pairs.ids.iter().all(id => id >= 0 && id < 256) else {
    fail("Normalization pair indices exceed their encoded width")
  }
  // The scan reads these tables unchecked for every pair below the tail.
  for lead in 0..<lead_limit {
    for trail in 0..<1024 {
      let cp = NormalizationBmpLimit + (lead << 10) + trail
      let block_index = lead_slots[lead] * pair_blocks_per_group +
        (trail >> NormalizationPairShift)
      guard block_index < pairs.ids.length() else {
        fail("Normalization pair block out of bounds at code point \{cp}")
      }
      let index = (pairs.ids[block_index] << NormalizationPairShift) |
        (trail & (pair_block_size - 1))
      guard index < pairs.blocks.length() else {
        fail("Normalization pair index out of bounds at code point \{cp}")
      }
      guard pairs.blocks[index] == values[cp] else {
        fail("Normalization pair flags mismatch at code point \{cp}")
      }
    }
  }
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "UTF-16 normalization scan summaries", "UnicodeData.txt and DerivedNormalizationProps.txt",
  )
  out.write_byte_array(
    "BMP scan block indices (\{block_size} code points per block)",
    "normalization_scan_index",
    bmp.ids,
  )
  out.write_byte_array(
    "BMP scan flags. Bit 0: CCC is nonzero; bits 1..6: Quick_Check bits 8..13 of the packed properties; bit 7: leading surrogate",
    "normalization_scan_flags",
    bmp.blocks,
  )
  out.write_byte_array(
    "ORed scan flags for each group of 1024 supplementary code points",
    "normalization_lead_flags",
    lead_flags[:lead_limit].to_owned(),
  )
  out.write_byte_array(
    "Slot of each group of 1024 supplementary code points; slot 0 has no flags",
    "normalization_lead_slots", lead_slots,
  )
  out.write_byte_array(
    "Pair block indices (\{pair_blocks_per_group} blocks of \{pair_block_size} code points per slot)",
    "normalization_pair_index",
    pairs.ids,
  )
  out.write_byte_array(
    "Scan flags of supplementary code points, laid out like the BMP ones",
    "normalization_pair_flags",
    pairs.blocks,
  )
  out.write(
    (
      $|///|
      $|const NormalizationPairShift : Int = \{NormalizationPairShift}
      $|
      $|///|
      $|const NormalizationPairBlockMask : Int = \{pair_block_size - 1}
      $|
      $|///|
      $|const NormalizationScanShift : Int = \{NormalizationScanShift}
      $|
      $|///|
      $|const NormalizationScanBlockMask : Int = \{block_size - 1}
      $|
      $|///|
      $|const NormalizationScanLeadSurrogate : Int = \{NormalizationScanLeadSurrogate}
      $|
    ),
  )
  out.write(
    (
      $|///|
      $|// The all-zero property tail begins at this UTF-16 pair. No decoding or
      $|// table access is needed there; earlier pairs use the summaries above.
      $|const NormalizationTailLeadIndex : Int = \{tail_lead}
      $|
      $|///|
      $|const NormalizationTailTrail : Int = \{tail_trail}
      $|
    ),
  )
  out.finish()
}
