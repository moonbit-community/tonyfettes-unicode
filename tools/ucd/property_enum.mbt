///|
/// One value of an enumerated property: the enum constructor standing for it
/// and the comment written next to that constructor.
priv struct EnumValue {
  name : String
  comment : String
}

///|
/// Write the enum of an enumerated property, a `Show` implementation printing
/// the constructor names, and the function `converter` turning a table
/// ordinal into the enum.
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
  out.write_line("pub(all) enum \{type_name} {")
  for value in values {
    out.write_line("  \{value.name} // \{value.comment}")
  }
  out.write(
    (
      $|} derive(Eq)
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
/// Look up the ordinal of every code point's value in `values`, matching the
/// value names as the UCD file writes them.
fn property_ordinals(
  property~ : String,
  names : FixedArray[String],
  ordinal_of : (StringView) -> Int32?,
) -> FixedArray[Int32] raise {
  let ordinals = FixedArray::make(names.length(), 0)
  for cp, name in names {
    guard ordinal_of(name) is Some(ordinal) else {
      fail("Unknown \{property}: \{name}")
    }
    ordinals[cp] = ordinal
  }
  ordinals
}
