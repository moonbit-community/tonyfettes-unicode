///|
/// Emit the private properties used by the default casing contexts. They
/// come from DerivedCoreProperties.txt rather than approximations based on
/// case mappings: some cased characters map to themselves, and a character
/// can be both Cased and Case_Ignorable.
pub fn emit_case_context(content : String) -> String raise {
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Cased and Case_Ignorable lookup data", "DerivedCoreProperties.txt",
  )
  for property in ["Cased", "Case_Ignorable"] {
    write_binary_property_trie(
      out,
      property~,
      exported=false,
      parse_property_ranges(content, property),
    )
  }
  out.finish()
}
