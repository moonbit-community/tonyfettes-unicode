///|
test "parse ranges and sequences" {
  let range = parse_code_point_range("0041..0043")
  debug_inspect(range, content="{ start: 65, end: 67 }")
  debug_inspect(parse_code_point_sequence("0041 0307"), content="[65, 775]")
}

///|
test "parse IDNA escape formats" {
  let parsed = parse_escaped_text("a\\u0062\\x{1F600}")
  inspect(parsed.text, content="ab😀")
  inspect(parsed.has_surrogate, content="false")
  inspect(parse_escaped_text("\\uD800").has_surrogate, content="true")
}

///|
test "escape MoonBit source strings" {
  inspect(escape_moonbit_string("a\n😀"), content="a\\n\\u{1F600}")
  inspect(
    code_points_to_moonbit_string([0x41, 0x307]),
    content="\\u{0041}\\u{0307}",
  )
}

///|
test "parse an enumerated property with missing declarations" {
  let values = parse_enumerated_property(
    (
      #|# @missing: 0000..10FFFF; Neutral
      #|# @missing: 3400..4DBF; Wide
      #|0041..0042 ; Na # L& [2] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER B
      #|3400 ; W
      #|
    ),
    default="N",
  )
  inspect(values.length(), content="1114112")
  inspect(values[0x40], content="Neutral")
  inspect(values[0x41], content="Na")
  inspect(values[0x42], content="Na")
  inspect(values[0x3400], content="W")
  inspect(values[0x3401], content="Wide")
  inspect(values[0x10FFFF], content="Neutral")
  // Without a `@missing` line, unlisted code points take the default.
  inspect(
    parse_enumerated_property("0041 ; Na\n", default="N")[0x40],
    content="N",
  )
}
