///|
/// Read the official Unicode 18.0.0 files independently of the generator.
fn mapping_string(field : StringView) -> String raise {
  guard @support.code_points_to_string(
      @support.parse_code_point_sequence(field),
    )
    is Some(text) else {
    fail("Invalid scalar in folding mapping")
  }
  text
}

///|
async test "CaseFolding.txt full default mappings and identity for every scalar" {
  let expected : Map[Int32, String] = Map([])
  let content = @support.read_data_file("CaseFolding.txt")
  assert_true(content.has_prefix("# CaseFolding-18.0.0.txt"))
  for raw_line in content.split("\n") {
    let line = raw_line.split("#").next().unwrap().trim()
    if line.is_empty() {
      continue
    }
    guard line.split(";").collect() is [cp, status, target, ..] else {
      fail("Invalid CaseFolding record")
    }
    if status.trim() == "C" || status.trim() == "F" {
      expected[@support.parse_hex_int(cp)] = mapping_string(target)
    }
  }
  assert_true(expected.length() > 1500)
  for cp in 0..<=0x10FFFF {
    if cp >= 0xD800 && cp <= 0xDFFF {
      continue
    }
    let input = cp.unsafe_to_char().to_string()
    let target = expected.get(cp).unwrap_or(input)
    let actual = @casefold.case_fold(input)
    @debug.assert_eq(actual, target, msg="CaseFolding mismatch at \{cp}")
    @debug.assert_eq(
      @casefold.case_fold(actual),
      actual,
      msg="CaseFolding not idempotent at \{cp}",
    )
  }
}

///|
async test "DerivedNormalizationProps.txt NFKC_CF for every scalar" {
  let expected : Map[Int32, String] = Map([])
  let content = @support.read_data_file("DerivedNormalizationProps.txt")
  assert_true(content.has_prefix("# DerivedNormalizationProps-18.0.0.txt"))
  for raw_line in content.split("\n") {
    let line = raw_line.split("#").next().unwrap().trim()
    if line.is_empty() {
      continue
    }
    guard line.split(";").collect() is [range, property, .. fields] else {
      fail("Invalid derived normalization record")
    }
    if property.trim() != "NFKC_CF" {
      continue
    }
    guard fields is [target, ..] else { fail("Missing NFKC_CF target") }
    let target = mapping_string(target)
    let (first, last) = if range.trim().split_once("..") is Some((a, b)) {
      (@support.parse_hex_int(a), @support.parse_hex_int(b))
    } else {
      let cp = @support.parse_hex_int(range)
      (cp, cp)
    }
    for cp in first..<=last {
      expected[cp] = target
    }
  }
  assert_true(expected.length() > 10000)
  for cp in 0..<=0x10FFFF {
    if cp >= 0xD800 && cp <= 0xDFFF {
      continue
    }
    let input = cp.unsafe_to_char().to_string()
    let target = expected.get(cp).unwrap_or(input)
    let actual = @casefold.nfkc_casefold(input)
    @debug.assert_eq(actual, target, msg="NFKC_CF mismatch at \{cp}")
    @debug.assert_eq(
      @casefold.nfkc_casefold(actual),
      actual,
      msg="NFKC_CF not idempotent at \{cp}",
    )
    assert_true(@normalization.is_normalized(actual, @normalization.NFC))
  }
}

///|
async test "canonical caseless keys respect NormalizationTest canonical equivalents" {
  for raw_line in @support.read_data_file("NormalizationTest.txt").split("\n") {
    let line = raw_line.trim()
    if line.is_empty() || line.has_prefix("#") || line.has_prefix("@") {
      continue
    }
    guard line.split(";").collect() is [c1, c2, c3, c4, c5, ..] else {
      fail("Invalid NormalizationTest record")
    }
    let first = mapping_string(c1)
    let composed = mapping_string(c2)
    let decomposed = mapping_string(c3)
    assert_true(@casefold.canonical_caseless_match(first, composed))
    assert_true(@casefold.canonical_caseless_match(first, decomposed))
    assert_true(
      @casefold.canonical_caseless_match(mapping_string(c4), mapping_string(c5)),
    )
    assert_true(@casefold.identifier_caseless_match(first, decomposed))
  }
}
