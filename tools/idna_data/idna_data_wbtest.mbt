///|
test "parse and emit IDNA mapping data" {
  let source = generate_mapping_source(
    (
      #|0041; mapped; 0061
      #|0061..007A; valid;
      #|
    ),
  )
  inspect(source.contains("0x0041"), content="true")
  inspect(source.contains("let idna_mapping_data"), content="true")
  inspect(source.contains("  0x0061"), content="true")
  inspect(source.contains("Mapped(Array[Char])"), content="true")
  inspect(
    source.contains("pub fn lookup_idna_mapping(c : Char) -> IdnaStatus"),
    content="true",
  )
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
}
