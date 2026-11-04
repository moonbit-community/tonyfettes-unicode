///|
/// Ordinal of a Joining_Type value in the `JoiningType` enum.
/// `@missing` lines spell out the long alias.
fn joining_type_ordinal(value : StringView) -> Int32? {
  match value {
    "U" | "Non_Joining" => Some(0)
    "C" | "Join_Causing" => Some(1)
    "D" | "Dual_Joining" => Some(2)
    "L" | "Left_Joining" => Some(3)
    "R" | "Right_Joining" => Some(4)
    "T" | "Transparent" => Some(5)
    _ => None
  }
}

///|
/// Emit Joining_Type data from `DerivedJoiningType.txt` as a three-level trie
/// for planes 0-3, with packed ranges for the remaining planes.
pub fn emit_joining_type(content : String) -> String raise {
  let values = property_ordinals(
    property="Joining_Type",
    @parsing.parse_enumerated_property(content, default="U"),
    joining_type_ordinal,
  )
  let out = @emitter.Emitter::new()
  out.write_file_header("Joining_Type lookup data", "DerivedJoiningType.txt")
  out.write_value_trie(
    property="Joining_Type",
    prefix="joining_type",
    lookup="pub fn lookup_joining_type",
    lookup_doc=[
      "Look up Joining_Type ordinal for a character", "Returns ordinal value (0-5) corresponding to JoiningType enum",
    ],
    value_bits=3,
    values,
  )
  out.finish()
}
