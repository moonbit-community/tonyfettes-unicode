///|
test "generate one file per normalization part" {
  let input =
    #|# header
    #|@Part0 # Specific cases
    #|0041; 0041; 0041; 0041; 0041;
    #|@Part1 # Character by character
    #|00C5; 00C5; 0041 030A; 00C5; 0041 030A;
  let files = generate_files(input)
  assert_eq(files.length(), 2)
  guard files is [first, second] else { fail("expected two generated files") }
  assert_eq(
    first.relative_path,
    "conformance/normalization/conformance_part0_test.mbt",
  )
  assert_true(
    first.source.contains("Array[(String, String, String, String, String)]"),
  )
  assert_true(
    first.source.contains(
      "(\"\\u{0041}\", \"\\u{0041}\", \"\\u{0041}\", \"\\u{0041}\", \"\\u{0041}\")",
    ),
  )
  assert_true(first.source.contains("let (c1, c2, c3, _, _) = case"))
  assert_false(first.source.contains("struct TestCase"))
  assert_true(first.source.contains("\\u{0041}"))
  assert_eq(
    second.relative_path,
    "conformance/normalization/conformance_part1_test.mbt",
  )
  assert_true(second.source.contains("\\u{00C5}"))
  assert_true(second.source.contains("\\u{0041}\\u{030A}"))
}
