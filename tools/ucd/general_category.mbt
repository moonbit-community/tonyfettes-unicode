///|
/// Emit General_Category data as a three-level trie for planes 0-3, with
/// packed ranges for the remaining planes.
pub fn emit_general_category(data : UnicodeData) -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header("General_Category lookup data", "UnicodeData.txt")
  out.write_value_trie(
    property="General_Category",
    prefix="gc",
    lookup="pub fn lookup_general_category",
    lookup_doc=[
      "Look up General_Category ordinal for a character", "Returns ordinal value (0-29) corresponding to GeneralCategory enum",
    ],
    value_bits=5,
    data.general_categories,
  )
  out.finish()
}
