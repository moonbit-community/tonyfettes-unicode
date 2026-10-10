///|
test "normalization generator rejects incomplete Quick_Check data" {
  try
    @ucd.emit_normalization(
      @ucd.parse_unicode_data(""),
      [],
      "00C0 ; NFD_QC ; N",
    )
  catch {
    Failure::Failure(message) =>
      assert_true(message.contains("Missing Quick_Check properties"))
    error => raise error
  } noraise {
    _ => fail("expected incomplete Quick_Check data to fail")
  }
}

///|
test "normalization generator rejects Maybe for decomposition forms" {
  for property in ["NFD_QC", "NFKD_QC"] {
    try
      @ucd.emit_normalization(
        @ucd.parse_unicode_data(""),
        [],
        "0300 ; \{property} ; M",
      )
    catch {
      Failure::Failure(message) =>
        assert_true(message.contains("Invalid Quick_Check value"))
      error => raise error
    } noraise {
      _ => fail("expected invalid Maybe value to fail")
    }
  }
}

///|
test "normalization generator rejects overlapping ranges including explicit Yes" {
  let input =
    #|0300..0302 ; NFC_QC ; Y
    #|0301 ; NFC_QC ; M
  try @ucd.emit_normalization(@ucd.parse_unicode_data(""), [], input) catch {
    Failure::Failure(message) =>
      assert_true(message.contains("Overlapping Quick_Check ranges"))
    error => raise error
  } noraise {
    _ => fail("expected overlapping ranges to fail")
  }
}

///|
test "normalization generator rejects out of range code points" {
  try
    @ucd.emit_normalization(
      @ucd.parse_unicode_data(""),
      [],
      "110000 ; NFC_QC ; N",
    )
  catch {
    Failure::Failure(message) =>
      assert_true(message.contains("Invalid Quick_Check range"))
    error => raise error
  } noraise {
    _ => fail("expected out of range code point to fail")
  }
}

///|
test "normalization generator accepts explicit defaults and unrelated properties" {
  let input =
    #|# @missing: 0000..10FFFF; NFC_QC; Yes
    #|0041 ; NFC_QC ; Y
    #|0041 ; NFKC_QC ; Y
    #|0041 ; NFD_QC ; Y
    #|0041 ; NFKD_QC ; Y
    #|0042 ; Full_Composition_Exclusion
  let source = @ucd.emit_normalization(@ucd.parse_unicode_data(""), [], input)
  // An all-default table has a BMP block and an implicit supplementary tail.
  assert_true(source.contains("if cp >= 65536"))
}

///|
test "normalization generator validates the full supplementary range" {
  // Force a stored value at both supplementary endpoints, including the last
  // slot of the last leaf. emit_normalization validates every intervening index.
  let input =
    #|10000 ; NFC_QC ; N
    #|10FFFF ; NFC_QC ; N
    #|10FFFF ; NFKC_QC ; N
    #|10FFFF ; NFD_QC ; N
    #|10FFFF ; NFKD_QC ; N
  let source = @ucd.emit_normalization(@ucd.parse_unicode_data(""), [], input)
  assert_true(source.contains("if cp >= 1114112"))
}
