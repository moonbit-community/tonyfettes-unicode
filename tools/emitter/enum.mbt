///|
/// One value of an enumerated property: the enum constructor standing for it
/// and the comment written next to that constructor.
pub(all) struct EnumValue {
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
pub fn Emitter::write_enum(
  self : Emitter,
  type_name~ : String,
  doc~ : Array[String],
  converter~ : String,
  values~ : Array[EnumValue],
  fallback~ : String,
) -> Unit raise {
  guard values.search_by(value => value.name == fallback) is Some(fallback_at) else {
    fail("\{type_name} has no constructor \{fallback}")
  }
  self.write("///|\n")
  for line in doc {
    self.write_line("/// \{line}")
  }
  self.write_line("#derive(Debug, Eq)")
  self.write_line("pub(all) enum \{type_name} {")
  for value in values {
    self.write_line("  \{value.name} // \{value.comment}")
  }
  self.write(
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
    self.write_line("      \{value.name} => \"\{value.name}\"")
  }
  self.write(
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
      self.write_line("    \{ordinal} => \{value.name}")
    }
  }
  self.write(
    (
      $|    _ => \{fallback} // \{fallback_at} or any unknown
      $|  }
      $|}
      $|
      $|
    ),
  )
}
