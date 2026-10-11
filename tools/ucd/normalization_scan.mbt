///|
/// Emit private UTF-16 scan data next to the normalizer's hot loops. Keeping
/// these small constants local avoids per-pair helper calls on Wasm backends.
pub fn emit_normalization_scan(
  data : UnicodeData,
  derived_properties : String,
) -> String raise {
  let values = normalization_values(
    compress_ccc_ranges(data),
    derived_properties,
  )
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
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "UTF-16 normalization scan summaries", "UnicodeData.txt and DerivedNormalizationProps.txt",
  )
  out.write_int_array(
    "ORed CCC/Quick_Check flags for each group of 1024 supplementary code points",
    "normalization_lead_flags",
    lead_flags[:lead_limit].to_owned(),
    hex=false,
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
