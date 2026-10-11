///|
/// The scan flags the generator derives from packed properties.
fn expected_scan_flags(c : Char) -> Int {
  let properties = @ccc.lookup_normalization_properties(c)
  let quick_check = properties >> 8 << 1
  if (properties & 255) != 0 {
    quick_check | 1
  } else {
    quick_check
  }
}

///|
// The scan tables are a second copy of data that unicode-data also carries.
// Check every code point, so a data update that regenerates only one of the
// two modules cannot go unnoticed.
test "BMP scan flags agree with the packed properties" {
  for cp in 0..<0x10000 {
    let block = normalization_scan_index[cp >> NormalizationScanShift].to_int()
    let flags = normalization_scan_flags[(block << NormalizationScanShift) |
    (cp & NormalizationScanBlockMask)].to_int()
    let expected = if cp >= 0xD800 && cp < 0xDC00 {
      NormalizationScanLeadSurrogate
    } else {
      expected_scan_flags(cp.unsafe_to_char())
    }
    guard flags == expected else {
      fail("scan flags \{flags} != \{expected} at code point \{cp}")
    }
  }
}

///|
test "supplementary scan flags agree with the packed properties" {
  for lead in 0..<1024 {
    let generated = if lead < normalization_lead_flags.length() {
      normalization_lead_flags[lead].to_int()
    } else {
      0
    }
    let mut summary = 0
    for trail in 0..<1024 {
      let cp = 0x10000 + (lead << 10) + trail
      let expected = expected_scan_flags(cp.unsafe_to_char())
      let default_tail = lead > NormalizationTailLeadIndex ||
        (
          lead == NormalizationTailLeadIndex &&
          0xDC00 + trail >= NormalizationTailTrail
        )
      guard !default_tail || expected == 0 else {
        fail("code point \{cp} in the default tail has scan flags \{expected}")
      }
      summary = summary | expected
      // The scan reads a pair's own flags whenever its group summary is set.
      if generated != 0 {
        let slot = normalization_lead_slots[lead].to_int()
        let block = normalization_pair_index[(
          slot << (10 - NormalizationPairShift)
        ) |
        (trail >> NormalizationPairShift)].to_int()
        let flags = normalization_pair_flags[(block << NormalizationPairShift) |
        (trail & NormalizationPairBlockMask)].to_int()
        guard flags == expected else {
          fail("pair flags \{flags} != \{expected} at code point \{cp}")
        }
      }
    }
    guard generated == summary else {
      fail("lead flags \{generated} != \{summary} for lead index \{lead}")
    }
  }
}
