///|
/// Emit the bitset trie of General_Category group M (Mn, Mc, and Me).
pub fn emit_marks(data : UnicodeData) -> String raise {
  // Mn, Mc, and Me are ordinals 5 to 7.
  let ranges = ranges_where(data.general_categories, gc => gc >= 5 && gc <= 7)
  let out = @emitter.Emitter::new()
  out.write_file_header(
    "Mark (General_Category group M) lookup data", "UnicodeData.txt",
  )
  write_binary_property_trie(
    out,
    property="Mark",
    lookup_doc="Check whether a character is a mark (General_Category Mn, Mc, or Me)",
    ranges,
  )
  out.finish()
}
