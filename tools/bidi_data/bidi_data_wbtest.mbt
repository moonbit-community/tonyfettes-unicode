///|
test "ordered missing declarations and explicit ranges" {
  let source = generate_bidi_class_source(
    (
      #|# @missing: 0000..10FFFF; Left_To_Right
      #|# @missing: 0590..05FF; Right_To_Left
      #|05D0; R
      #|0600; AL
      #|
    ),
  )
  inspect(source.contains("let bidi_range_starts"), content="true")
  inspect(source.contains("  0x0590"), content="true")
  inspect(source.contains("  0x0600"), content="true")
}

///|
test "mirror and bracket emitters" {
  let mirrors = generate_mirrored_source("0028; 0029\n")
  inspect(mirrors.contains("  0x0028"), content="true")
  let brackets = generate_bracket_source("0028; 0029; o\n0029; 0028; c\n")
  inspect(brackets.contains("let paired_brackets"), content="true")
  inspect(brackets.contains("pub fn paired_bracket"), content="true")
}
