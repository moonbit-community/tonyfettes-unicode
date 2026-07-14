///|
test "Emitter writes source fragments and typed values" {
  let out = Emitter::new()
  out.write("let answer = ")
  out.write_int(42)
  out.write_char('\n')
  out.write_line("test \"generated\" {}")
  inspect(
    out.finish(),
    content=(
      #|let answer = 42
      #|test "generated" {}
      #|
    ),
  )
}
