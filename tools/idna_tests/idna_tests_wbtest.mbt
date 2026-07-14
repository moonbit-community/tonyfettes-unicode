///|
test "IDNA cases inherit fields and select validation flags" {
  let input =
    #|# comment
    #|fass.de;;;fass.de;;
    #|fa\u00DF.de;;;xn--fa-hia.de;;
    #|abc;;;abc;[B5, C1];
    #|bad;;;bad;[V1];
    #|\uD800;;;ascii;;
  let source = generate_source(input)
  assert_true(source.contains("test \"conformance/0002: fass.de\""))
  assert_true(source.contains("assert_eq(result, \"xn--fa-hia.de\")"))
  assert_true(source.contains("check_bidi=true"))
  assert_true(source.contains("check_joiners=true"))
  assert_true(source.contains("bad [V1]"))
  assert_false(source.contains("SURROGATE"))
}
