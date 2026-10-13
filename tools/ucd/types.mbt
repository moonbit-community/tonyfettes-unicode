///|
priv struct CccEntry {
  code_point : Int32
  value : Int32
}

///|
priv struct DecompositionEntry {
  code_point : Int32
  code_points : Array[Int32]
}

///|
priv struct GeneralCategoryEntry {
  code_point : Int32
  category : String
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
struct UnicodeData {
  ccc_entries : Array[CccEntry]
  canonical_decompositions : Array[DecompositionEntry]
  compatibility_decompositions : Array[DecompositionEntry]
  mark_code_points : Array[Int32]
  general_categories : Array[GeneralCategoryEntry]
  simple_uppercase : Array[SimpleMappingEntry]
  simple_lowercase : Array[SimpleMappingEntry]
  simple_titlecase : Array[SimpleMappingEntry]
}

///|
struct SpecialCasingData {
  lower_mapping : Array[FullMappingEntry]
  title_mapping : Array[FullMappingEntry]
  upper_mapping : Array[FullMappingEntry]
}

///|
struct DerivedCoreProperties {
  alphabetic : Array[@parsing.CodePointRange]
  lowercase : Array[@parsing.CodePointRange]
  uppercase : Array[@parsing.CodePointRange]
  xid_start : Array[@parsing.CodePointRange]
  xid_continue : Array[@parsing.CodePointRange]
  default_ignorable_code_point : Array[@parsing.CodePointRange]
  grapheme_extend : Array[@parsing.CodePointRange]
}

///|
struct PropList {
  white_space : Array[@parsing.CodePointRange]
  regional_indicator : Array[@parsing.CodePointRange]
  prepended_concatenation_mark : Array[@parsing.CodePointRange]
}

///|
struct EmojiData {
  emoji_presentation : Array[@parsing.CodePointRange]
  emoji_modifier : Array[@parsing.CodePointRange]
  emoji_modifier_base : Array[@parsing.CodePointRange]
}

///|
struct CccRange {
  start : Int32
  end : Int32
  value : Int32
}

///|
struct GeneralCategoryRange {
  start : Int32
  end : Int32
  value : Int32
}

///|
struct CompositionEntry {
  first : Int32
  second : Int32
  result : Int32
}
