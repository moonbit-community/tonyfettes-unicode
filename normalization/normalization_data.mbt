///|
/// UTF-16 normalization scan summaries
/// Generated from UnicodeData.txt and DerivedNormalizationProps.txt

///|
/// ORed CCC/Quick_Check flags for each group of 1024 supplementary code points
let normalization_lead_flags : ReadOnlyArray[Int] = [
  254, 13312, 255, 254, 15087, 15087, 14863, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 14857, 0, 231, 14854, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 9216, 0, 0, 1, 0, 0, 0, 9216, 13823, 9216, 0, 9216, 9446, 254, 255, 9216,
  9216, 0, 9216, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13568,
]

///|
// The all-zero property tail begins at this UTF-16 pair. No decoding or
// table access is needed there; earlier pairs use the summaries above.
const NormalizationTailLeadIndex : Int = 126

///|
const NormalizationTailTrail : Int = 56862
