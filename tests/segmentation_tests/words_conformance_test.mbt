///|
/// Exhaustively verify that `words()` keeps every single-code-point string iff
/// the code point is Alphabetic or General_Category=Number (Nd, Nl, No),
/// checking all 1,112,064 Unicode scalar values against `unicode-data`.
test "words filter matches UCD Alphabetic or Number for all Unicode scalar values" {
  let mut checked = 0
  for cp in 0..<=0x10FFFF {
    if cp >= 0xD800 && cp <= 0xDFFF {
      continue
    }
    let c = cp.unsafe_to_char()
    let expected = @ucd.is_alphabetic(c) ||
      @ucd.general_category(c) is (@ucd.Nd | @ucd.Nl | @ucd.No)
    let s = c.to_string()
    let actual = !@segmentation.words(s).next().is_empty()
    assert_eq(actual, expected, msg="words filter mismatch at U+\{cp}")
    checked += 1
  }
  assert_eq(checked, 1112064)
}
