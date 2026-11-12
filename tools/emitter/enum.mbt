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
/// The ordinal of a value is its index in `values`, which is how moonc
/// represents a constructor without arguments on every backend, so the
/// converter is `%identity`. Its callers must pass only ordinals below
/// `values.length()`: no other value is a constructor.
pub fn Emitter::write_enum(
  self : Emitter,
  type_name~ : String,
  doc~ : Array[String],
  converter~ : String,
  values~ : Array[EnumValue],
) -> Unit raise {
  guard !values.is_empty() else { fail("\{type_name} has no constructors") }
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
      $|/// Convert a \{type_name} ordinal, below \{values.length()}, to the enum value.
      $|///
      $|/// A constructor without arguments is its ordinal on every backend. A
      $|/// `match` or a table would cost a jump table or a load on wasm, wasm-gc
      $|/// and JS, slower there than the trie lookup itself.
      $|fn \{converter}(ordinal : Int) -> \{type_name} = "%identity"
      $|
      $|
    ),
  )
}
