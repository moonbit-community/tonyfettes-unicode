///|
test "ordered missing declarations and explicit ranges" {
  let ranges = parse_bidi_ranges(
    (
      #|# @missing: 0000..10FFFF; Left_To_Right
      #|# @missing: 0590..05FF; Right_To_Left
      #|05D0; R
      #|0600; AL
      #|
    ),
  )
  debug_inspect(
    ranges.map(range => (range.start, range.end, range.bidi_class)),
    content=(
      #|[
      #|  (0, 1423, "L"),
      #|  (1424, 1535, "R"),
      #|  (1536, 1536, "AL"),
      #|  (1537, 1114111, "L"),
      #|]
    ),
  )
}

///|
test "bidi class trie and high ranges" {
  let source = generate_bidi_class_source(
    (
      #|# @missing: 0000..10FFFF; Left_To_Right
      #|05D0; R
      #|E0001; BN
      #|
    ),
  )
  for
    expected in [
      "let bidi_trie_top : Bytes", "let bidi_trie_mid : Bytes", "let bidi_trie_leaf : Bytes",
      "let bidi_high_ranges : ReadOnlyArray[Int]",
      // Planes 4 and up: L from U+40000, BN at U+E0001, L again from U+E0002.
       "  0x800000,\n  0x1C00029,\n  0x1C00040,\n]", "fn lookup_bidi_class_code(c : Char) -> Int",
      "pub extend BidiClass with Eq::{not_equal, equal}", "pub extend BidiClass with Show::{to_string, output}",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "unknown bidi class is rejected" {
  try generate_bidi_class_source("0041; XX\n") catch {
    error =>
      inspect(
        error.to_string().contains("Unknown Bidi_Class: XX"),
        content="true",
      )
  } noraise {
    _ => fail("expected an unknown Bidi_Class to be rejected")
  }
}

///|
test "mirror and bracket emitters" {
  let mirrors = generate_mirrored_source("0028; 0029\n")
  inspect(mirrors.contains("  0x0028"), content="true")
  let brackets = generate_bracket_source("0028; 0029; o\n0029; 0028; c\n")
  inspect(brackets.contains("let paired_brackets"), content="true")
  inspect(brackets.contains("pub fn paired_bracket"), content="true")
  inspect(
    brackets.contains("pub extend BracketType with Eq::{not_equal, equal}"),
    content="true",
  )
}
