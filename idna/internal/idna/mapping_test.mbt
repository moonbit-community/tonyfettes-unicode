///|
/// The status of a character followed by the code points of its mapping.
fn describe(c : Char) -> String {
  let entry = @idna.lookup_idna_entry(c)
  let mapping = StringBuilder()
  entry.write_mapping(mapping)
  let description = StringBuilder()
  description.write_object(entry.status())
  for mapped in mapping.to_string() {
    description.write_string(
      " \{mapped.to_int().to_string(radix=16).to_upper()}",
    )
  }
  description.to_string()
}

///|
test "lookup_idna_entry: ASCII" {
  inspect(describe('a'), content="Valid")
  inspect(describe('-'), content="Valid")
  inspect(describe('A'), content="Mapped 61")
  inspect(describe('Z'), content="Mapped 7A")
}

///|
test "lookup_idna_entry: every status" {
  inspect(describe('\u{00E9}'), content="Valid")
  inspect(describe('\u{00AD}'), content="Ignored")
  inspect(describe('\u{00C9}'), content="Mapped E9")
  inspect(describe('\u{00DF}'), content="Deviation 73 73")
  inspect(describe('\u{200C}'), content="Deviation")
  inspect(describe('\u{0080}'), content="Disallowed")
}

///|
test "lookup_idna_entry: shared and long mappings" {
  // U+017F maps to the same "s" as U+0053.
  inspect(describe('S'), content="Mapped 73")
  inspect(describe('\u{017F}'), content="Mapped 73")
  inspect(
    describe('\u{FDFA}'),
    content="Mapped 635 644 649 20 627 644 644 647 20 639 644 64A 647 20 648 633 644 645",
  )
  inspect(describe('\u{2F800}'), content="Mapped 4E3D")
}

///|
test "lookup_idna_entry: supplementary planes" {
  inspect(describe('\u{20000}'), content="Valid")
  // The last code points looked up in the trie, then the packed ranges.
  inspect(describe('\u{3FFFF}'), content="Disallowed")
  inspect(describe('\u{40000}'), content="Disallowed")
  inspect(describe('\u{E00FF}'), content="Disallowed")
  inspect(describe('\u{E0100}'), content="Ignored")
  inspect(describe('\u{E01EF}'), content="Ignored")
  inspect(describe('\u{E01F0}'), content="Disallowed")
  inspect(describe('\u{10FFFF}'), content="Disallowed")
}
