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
