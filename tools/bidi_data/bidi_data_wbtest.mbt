///|
test "bidi class trie and high ranges" {
  let source = emit_bidi_class(
    (
      #|# @missing: 0000..10FFFF; Left_To_Right
      #|0028..0029; ON
      #|05D0; R
      #|E0001; BN
      #|
    ),
    mirroring="0028; 0029\n0029; 0028\n",
    brackets="0028; 0029; o\n0029; 0028; c\n",
  )
  for
    expected in [
      "let bidi_bmp_index : Bytes", "let bidi_bmp_leaf : Bytes", "let bidi_supp_top : Bytes",
      "let bidi_high_ranges : ReadOnlyArray[Int]",
      // Planes 4 and up: L from U+40000, BN at U+E0001, L again from U+E0002.
       "  0x800000,\n  0x1C00029,\n  0x1C00040,\n]", "fn lookup_bidi_entry(c : Char) -> Int",
      "fn has_mirroring_glyph(c : Char) -> Bool", "fn lookup_bracket_tag(c : Char) -> Int",
      // 0x28 = ON (13) | mirrored (32) | open (64) = 109; 0x29 = 13 | 32 | 128 = 173.
       "  109,\n  173,\n", "pub extend BidiClass with Eq::{not_equal, equal}", "pub extend BidiClass with Show::{to_string, output}",
    ] {
    guard source.contains(expected) else {
      fail("Generated source is missing: \{expected}")
    }
  }
}

///|
test "unknown bidi class is rejected" {
  try emit_bidi_class("0041; XX\n") catch {
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
  let mirrors = emit_mirrored("0028; 0029\n")
  inspect(mirrors.contains("  0x0028"), content="true")
  let brackets = emit_bracket("0028; 0029; o\n0029; 0028; c\n")
  inspect(brackets.contains("let paired_brackets"), content="true")
  inspect(brackets.contains("pub fn paired_bracket"), content="true")
  inspect(
    brackets.contains("pub extend BracketType with Eq::{not_equal, equal}"),
    content="true",
  )
}
