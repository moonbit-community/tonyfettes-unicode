///|
test "case context properties require both derived properties" {
  for property in ["Cased", "Case_Ignorable"] {
    try emit_case_context("0041 ; \{property}") catch {
      Failure::Failure(message) => assert_true(message.contains("Missing"))
      error => raise error
    } noraise {
      _ => fail("expected a missing casing property to fail")
    }
  }
}

///|
test "case context lookups stay private and include supplementary properties" {
  let input =
    #|0041..005A ; Cased
    #|0345 ; Cased
    #|10400..1044F ; Cased
    #|0300..036F ; Case_Ignorable
    #|E0100..E01EF ; Case_Ignorable
  let output = emit_case_context(input)
  assert_true(output.contains("fn is_cased(c : Char) -> Bool"))
  assert_true(output.contains("fn is_case_ignorable(c : Char) -> Bool"))
  assert_false(output.contains("pub fn"))
  assert_true(output.contains("cp >= 0xE0100 && cp <= 0xE01EF"))
}
