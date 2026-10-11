///|
test "parse and emit IDNA mapping data" {
  let source = generate_mapping_source(
    (
      #|0041; mapped; 0061
      #|0053; mapped; 0073
      #|0061..007A; valid;
      #|00DF; deviation; 0073 0073
      #|017F; mapped; 0073
      #|200C..200D; deviation;
      #|
    ),
  )
  for
    expected in [
      "let idna_trie_top : Bytes", "let idna_trie_mid : Bytes", "let idna_trie_leaf : Bytes",
      // Unlisted code points are disallowed, including everything above the trie.
       "let idna_high_ranges : ReadOnlyArray[Int] = [\n  0x200004,\n]",
      // The empty mapping, "a", "s" shared by U+0053 and U+017F, and "ss".
       "let idna_mapping_offsets : ReadOnlyArray[Int] = [\n  0,\n  0,\n  1,\n  2,\n  4,\n]",
      "let idna_mapping_data : ReadOnlyArray[Int] = [\n  0x0061,\n  0x0073,\n  0x0073,\n  0x0073,\n]",
      "Mapped(Array[Char])", "pub extend IdnaStatus with Eq::{not_equal, equal}",
      "pub extend IdnaStatus with Show::{to_string, output}", "pub fn lookup_idna_mapping(c : Char) -> IdnaStatus",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "IDNA ranges above the trie are packed and merged" {
  let source = generate_mapping_source(
    (
      #|3FFFE..4FFFD; disallowed
      #|4FFFE..4FFFF; disallowed
      #|E0100..E01EF; ignored
      #|E01F0..E0FFF; disallowed
      #|F0000..F0001; valid
      #|
    ),
  )
  // Disallowed from U+40000, ignored from U+E0100, disallowed from U+E01F0
  // through the unlisted gap, valid from U+F0000, disallowed from U+F0002.
  let expected = "let idna_high_ranges : ReadOnlyArray[Int] = [\n  0x200004,\n  0x700801,\n  0x700F84,\n  0x780000,\n  0x780014,\n]"
  guard source.contains(expected) else {
    fail("Unexpected high ranges in generated source")
  }
}

///|
test "IDNA mappings above the trie are rejected" {
  try generate_mapping_source("40000; mapped; 0061\n") catch {
    Failure::Failure(message) =>
      assert_true(message.contains("needs trie coverage"))
    error => raise error
  } noraise {
    _ => fail("expected a mapping above the trie to be rejected")
  }
}

///|
test "parse and emit joining data" {
  let source = generate_joining_source(
    (
      #|0620..063F ; D # Arabic letters
      #|200C ; U
      #|
    ),
  )
  inspect(source.contains("let joining_range_types"), content="true")
  inspect(source.contains("  2"), content="true")
  inspect(
    source.contains("pub extend JoiningType with Eq::{not_equal, equal}"),
    content="true",
  )
  inspect(
    source.contains("pub extend JoiningType with Show::{to_string, output}"),
    content="true",
  )
}
