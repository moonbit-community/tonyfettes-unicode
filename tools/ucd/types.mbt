///|
priv struct DecompositionEntry {
  code_point : Int32
  code_points : Array[Int32]
}

///|
priv struct SimpleMappingEntry {
  code_point : Int32
  target : Int32
}

///|
priv struct FullMappingEntry {
  code_point : Int32
  targets : Array[Int32]
}

///|
/// The fields of `UnicodeData.txt` the generators use.
struct UnicodeData {
  /// General_Category ordinal of every code point; see `gc_ordinal`.
  general_categories : FixedArray[Int32]
  /// Canonical_Combining_Class of every code point.
  ccc : FixedArray[Int32]
  canonical_decompositions : Array[DecompositionEntry]
  compatibility_decompositions : Array[DecompositionEntry]
  simple_uppercase : Array[SimpleMappingEntry]
  simple_lowercase : Array[SimpleMappingEntry]
  simple_titlecase : Array[SimpleMappingEntry]
}

///|
/// The unconditional mappings of `SpecialCasing.txt`.
struct SpecialCasingData {
  lower_mapping : Array[FullMappingEntry]
  title_mapping : Array[FullMappingEntry]
  upper_mapping : Array[FullMappingEntry]
}

///|
priv struct CompositionEntry {
  first : Int32
  second : Int32
  result : Int32
}
