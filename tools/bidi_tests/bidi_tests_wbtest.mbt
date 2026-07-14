///|
test "Bidi conformance output is expanded and streamed by part" {
  let bidi =
    #|@Levels: 0 1 x
    #|@Reorder: 0 1
    #|L R BN; 7
  let characters = "0061 05D0; 0; 0; 0 1; 0 1\n"
  let parts = generate_parts(bidi, characters, 2)
  guard parts.next() is Some(first) else { fail("missing first bidi part") }
  assert_eq(first.relative_directory, "bidi/internal/conformance/bidi/part0")
  assert_true(first.source.contains("struct TestCase"))
  assert_true(first.source.contains("let test_cases : Array[TestCase]"))
  assert_true(first.source.contains("number: 0,"))
  assert_true(first.source.contains("direction: None,"))
  assert_true(first.source.contains("number: 1,"))
  assert_true(first.source.contains("direction: Some(@bidi.Direction::LTR),"))
  assert_true(first.source.contains("case \\{case.number}"))
  guard parts.next() is Some(second) else { fail("missing second bidi part") }
  assert_true(second.source.contains("number: 2,"))
  assert_true(second.source.contains("direction: Some(@bidi.Direction::RTL),"))
  guard parts.next() is Some(character) else { fail("missing character part") }
  assert_eq(
    character.relative_directory,
    "bidi/internal/conformance/character/part0",
  )
  assert_true(character.source.contains("expected_base_level: 0,"))
  assert_false(character.source.contains("process_with_base_level"))
  assert_true(parts.next() is None)
}

///|
test "generated packages use modern package syntax" {
  assert_true(package_source().contains("for \"test\""))
  assert_true(package_source().contains("moonbitlang/core/debug"))
  assert_false(package_source().contains("moon.pkg.json"))
}
