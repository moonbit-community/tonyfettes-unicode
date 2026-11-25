///|
test "folding parser selects full default mappings" {
  let mappings = parse_fold_mappings(
    (
      #|0049; C; 0069;
      #|0049; T; 0131;
      #|00DF; F; 0073 0073;
      #|1E9E; F; 0073 0073;
      #|1E9E; S; 00DF;
    ),
    nfkc=false,
  )
  inspect(mappings.length(), content="3")
  assert_true(mappings[0].targets == [105])
  assert_true(mappings[2].targets == [115, 115])
}

///|
test "NFKC_CF parser preserves empty ranges and ignores other properties" {
  let mappings = parse_fold_mappings(
    (
      #|0041; NFKC_CF; 0061
      #|200B..200F; NFKC_CF;
      #|0041; Changes_When_NFKC_Casefolded
    ),
    nfkc=true,
  )
  inspect(mappings.length(), content="2")
  inspect(mappings[1].start, content="8203")
  inspect(mappings[1].end, content="8207")
  assert_true(mappings[1].targets.is_empty())
}

///|
test "fold emitter packs normalization flags in bit 7 and keeps ASCII clean" {
  let ucd = parse_unicode_data(
    (
      #|0041;LATIN CAPITAL LETTER A;Lu;0;L;;;;;N;;;;0061;
      #|0061;LATIN SMALL LETTER A;Ll;0;L;;;;;N;;;0041;;0041
      #|00C9;LATIN CAPITAL LETTER E WITH ACUTE;Lu;0;L;0045 0301;;;;N;;;;00E9;
      #|00E9;LATIN SMALL LETTER E WITH ACUTE;Ll;0;L;0045 0301;;;;N;;;00C9;;00C9
      #|0301;COMBINING ACUTE ACCENT;Mn;230;NSM;;;;;N;;;;;
    ),
  )
  let derived =
    #|00C9; NFD_QC; N
    #|00E9; NFD_QC; N
    #|0301; NFC_QC; M
    #|00C9; NFKD_QC; N
    #|00E9; NFKD_QC; N
    #|0041..005A; NFKC_CF; 0061
    #|00C9; NFKC_CF; 00E9
    #|0041; NFKC_QC; Y
  let case_folding =
    #|0041; C; 0061;
    #|0042; C; 0062;
    #|0043; C; 0063;
    #|0044; C; 0064;
    #|0045; C; 0065;
    #|0046; C; 0066;
    #|0047; C; 0067;
    #|0048; C; 0068;
    #|0049; C; 0069;
    #|004A; C; 006A;
    #|004B; C; 006B;
    #|004C; C; 006C;
    #|004D; C; 006D;
    #|004E; C; 006E;
    #|004F; C; 006F;
    #|0050; C; 0070;
    #|0051; C; 0071;
    #|0052; C; 0072;
    #|0053; C; 0073;
    #|0054; C; 0074;
    #|0055; C; 0075;
    #|0056; C; 0076;
    #|0057; C; 0077;
    #|0058; C; 0078;
    #|0059; C; 0079;
    #|005A; C; 007A;
    #|00C9; C; 00E9;
  let emitted = emit_case_folding(case_folding, ucd, derived)
  assert_true(emitted.contains("fn case_folding_kind(cp : Int)"))
  assert_true(emitted.contains("Bit 7 (`0x80`)"))
  // U+00C9 (delta +32 -> kind 2, NFD_QC=N -> bit 7 set = 130) and
  // U+00E9 (identity -> kind 0, NFD_QC=N -> bit 7 set = 128).
  assert_true(emitted.contains("130"))
  assert_true(emitted.contains("128"))
}
