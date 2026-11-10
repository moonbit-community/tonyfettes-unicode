///|
/// One value of an enumerated property: the enum constructor standing for it
/// and the comment written next to that constructor.
priv struct EnumValue {
  name : String
  comment : String
}

///|
/// Write the enum of an enumerated property with `Debug` and `Eq`, a `Show`
/// implementation printing the constructor names, and the function
/// `converter` turning a table ordinal into the enum.
///
/// The ordinal of a value is its index in `values`. Ordinals outside the
/// table convert to `fallback`, which must be one of the constructors.
fn write_property_enum(
  out : @emitter.Emitter,
  type_name~ : String,
  doc~ : Array[String],
  converter~ : String,
  values~ : Array[EnumValue],
  fallback~ : String,
) -> Unit raise {
  guard values.search_by(value => value.name == fallback) is Some(fallback_at) else {
    fail("\{type_name} has no constructor \{fallback}")
  }
  out.write("///|\n")
  for line in doc {
    out.write_line("/// \{line}")
  }
  out.write_line("#derive(Debug, Eq)")
  out.write_line("pub(all) enum \{type_name} {")
  for value in values {
    out.write_line("  \{value.name} // \{value.comment}")
  }
  out.write(
    (
      $|}
      $|
      $|///|
      $|#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
      $|#doc(hidden)
      $|pub extend \{type_name} with Debug::{to_repr}
      $|
      $|///|
      $|pub extend \{type_name} with Eq::{not_equal, equal}
      $|
      $|///|
      $|pub extend \{type_name} with Show::{to_string, output}
      $|
      $|///|
      $|pub impl Show for \{type_name} with fn output(self, logger) {
      $|  logger.write_string(
      $|    match self {
      $|
    ),
  )
  for value in values {
    out.write_line("      \{value.name} => \"\{value.name}\"")
  }
  out.write(
    (
      $|    },
      $|  )
      $|}
      $|
      $|///|
      $|/// Convert \{type_name} ordinal to enum value
      $|fn \{converter}(ordinal : Int) -> \{type_name} {
      $|  match ordinal {
      $|
    ),
  )
  for ordinal, value in values {
    if ordinal != fallback_at {
      out.write_line("    \{ordinal} => \{value.name}")
    }
  }
  out.write(
    (
      $|    _ => \{fallback} // \{fallback_at} or any unknown
      $|  }
      $|}
      $|
      $|
    ),
  )
}

///|
/// Write the trie of an enumerated property whose ordinals are
/// `values`, looked up by `lookup_<property in lowercase>`. The ordinals
/// number the constructors of the enum `enum_name`, which has `value_count`
/// of them.
fn write_enumerated_trie(
  out : @emitter.Emitter,
  property~ : String,
  prefix~ : String,
  enum_name~ : String,
  value_count~ : Int32,
  value_bits~ : Int32,
  values : FixedArray[Int32],
) -> Unit raise {
  out.write_value_trie(
    property~,
    prefix~,
    lookup="pub fn lookup_\{property.to_lower()}",
    lookup_doc=[
      "Look up \{property} ordinal for a character",
      "Returns ordinal value (0-\{value_count - 1}) corresponding to \{enum_name} enum",
    ],
    value_bits~,
    values,
  )
}

///|
/// Emit the trie of a small enumerated property from its UCD file `content`,
/// whose name is `source`. `aliases` lists the short and long name of every
/// value in the order of the enum `enum_name`; the file writes short names,
/// and its `@missing` lines may spell out long ones.
fn emit_small_enumerated_property(
  content : String,
  property~ : String,
  source~ : String,
  prefix~ : String,
  enum_name~ : String,
  default~ : String,
  aliases : Array[(String, String)],
) -> String raise {
  let values = @parsing.parse_enumerated_ordinals(
    content,
    property~,
    default~,
    name => aliases.search_by(entry => name == entry.0 || name == entry.1),
  )
  let out = @emitter.Emitter::new()
  out.write_file_header("\{property} lookup data", source)
  write_enumerated_trie(
    out,
    property~,
    prefix~,
    enum_name~,
    value_count=aliases.length(),
    value_bits=3,
    values,
  )
  out.finish()
}

///|
pub fn emit_east_asian_width(content : String) -> String raise {
  emit_small_enumerated_property(
    content,
    property="East_Asian_Width",
    source="EastAsianWidth.txt",
    prefix="eaw",
    enum_name="EastAsianWidth",
    default="N",
    [
      ("A", "Ambiguous"),
      ("F", "Fullwidth"),
      ("H", "Halfwidth"),
      ("N", "Neutral"),
      ("Na", "Narrow"),
      ("W", "Wide"),
    ],
  )
}

///|
pub fn emit_joining_type(content : String) -> String raise {
  emit_small_enumerated_property(
    content,
    property="Joining_Type",
    source="DerivedJoiningType.txt",
    prefix="joining_type",
    enum_name="JoiningType",
    default="U",
    [
      ("U", "Non_Joining"),
      ("C", "Join_Causing"),
      ("D", "Dual_Joining"),
      ("L", "Left_Joining"),
      ("R", "Right_Joining"),
      ("T", "Transparent"),
    ],
  )
}

///|
pub fn emit_hangul_syllable_type(content : String) -> String raise {
  emit_small_enumerated_property(
    content,
    property="Hangul_Syllable_Type",
    source="HangulSyllableType.txt",
    prefix="hangul_syllable_type",
    enum_name="HangulSyllableType",
    default="NA",
    [
      ("NA", "Not_Applicable"),
      ("L", "Leading_Jamo"),
      ("V", "Vowel_Jamo"),
      ("T", "Trailing_Jamo"),
      ("LV", "LV_Syllable"),
      ("LVT", "LVT_Syllable"),
    ],
  )
}
