///|
/// Ordinal of an East_Asian_Width value in the `EastAsianWidth` enum.
/// `@missing` lines may spell out the long alias.
fn east_asian_width_ordinal(value : StringView) -> Int? {
  match value {
    "A" | "Ambiguous" => Some(0)
    "F" | "Fullwidth" => Some(1)
    "H" | "Halfwidth" => Some(2)
    "N" | "Neutral" => Some(3)
    "Na" | "Narrow" => Some(4)
    "W" | "Wide" => Some(5)
    _ => None
  }
}

///|
/// Emit East_Asian_Width data from `EastAsianWidth.txt` as a three-level trie
/// for planes 0-3, with packed ranges for the remaining planes.
pub fn emit_east_asian_width(content : String) -> String raise {
  let names = @parsing.parse_enumerated_property(content, default="N")
  let values = FixedArray::make(names.length(), 0)
  for cp, name in names {
    guard east_asian_width_ordinal(name) is Some(ordinal) else {
      fail("Unknown East_Asian_Width: \{name}")
    }
    values[cp] = ordinal
  }
  let out = @emitter.Emitter::new()
  out.write_file_header("East_Asian_Width lookup data", "EastAsianWidth.txt")
  out.write_value_trie(
    property="East_Asian_Width",
    prefix="eaw",
    lookup="pub fn lookup_east_asian_width",
    lookup_doc=[
      "Look up East_Asian_Width ordinal for a character", "Returns ordinal value (0-5) corresponding to EastAsianWidth enum",
    ],
    value_bits=3,
    values,
  )
  out.finish()
}
