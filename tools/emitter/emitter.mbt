///|
/// Largest Unicode scalar value.
pub const MaxCodePoint : Int32 = 0x10FFFF

///|
/// Builds the text of one generated source file.
struct Emitter {
  out : StringBuilder
}

///|
pub fn Emitter::new() -> Emitter {
  { out: StringBuilder(), }
}

///|
pub fn Emitter::write(self : Emitter, source : String) -> Unit {
  self.out.write_string(source)
}

///|
pub fn Emitter::write_line(self : Emitter, source : String) -> Unit {
  self.out.write_string(source)
  self.out.write_char('\n')
}

///|
pub fn Emitter::finish(self : Emitter) -> String {
  self.out.to_string()
}

///|
/// Uppercase hexadecimal representation of `value`, zero-padded to at least
/// `min_width` digits.
pub fn hex_upper(value : Int32, min_width~ : Int32 = 0) -> String {
  let digits = value.to_string(radix=16).to_upper()
  if digits.length() >= min_width {
    digits
  } else {
    "0".repeat(min_width - digits.length()) + digits
  }
}

///|
/// `0x`-prefixed uppercase hexadecimal, as a MoonBit literal.
pub fn hex_literal(value : Int32, min_width~ : Int32 = 0) -> String {
  "0x" + hex_upper(value, min_width~)
}

///|
/// A MoonBit string literal holding the given code points as `\u{...}`
/// escapes.
pub fn string_literal(code_points : ArrayView[Int32]) -> String {
  let literal = StringBuilder()
  literal.write_char('"')
  for code_point in code_points {
    literal.write_string("\\u{\{hex_upper(code_point, min_width=4)}}")
  }
  literal.write_char('"')
  literal.to_string()
}

///|
pub fn Emitter::write_file_header(
  self : Emitter,
  title : String,
  generated_from : String,
) -> Unit {
  self.write("///|\n")
  self.write("/// \{title}\n")
  self.write("/// Generated from \{generated_from}\n\n")
}

///|
/// Write `let <name> : <array_type> = [...]`, one element per line.
fn Emitter::write_array(
  self : Emitter,
  doc : String,
  name : String,
  array_type : String,
  elements : Array[String],
) -> Unit {
  self.write("///|\n")
  self.write("/// \{doc}\n")
  self.write("let \{name} : \{array_type} = [\n")
  for element in elements {
    self.write("  \{element},\n")
  }
  self.write("]\n\n")
}

///|
pub fn Emitter::write_int_array(
  self : Emitter,
  doc : String,
  name : String,
  values : Array[Int32],
  hex~ : Bool,
) -> Unit {
  self.write_array(
    doc,
    name,
    "ReadOnlyArray[Int]",
    values.map(value => {
      if hex {
        hex_literal(value, min_width=4)
      } else {
        value.to_string()
      }
    }),
  )
}

///|
/// Emit a `ReadOnlyArray[UInt16]`, half the size of `write_int_array` for
/// values that fit in 16 bits.
pub fn Emitter::write_uint16_array(
  self : Emitter,
  doc : String,
  name : String,
  values : Array[Int32],
) -> Unit raise {
  guard values.all(value => value >= 0 && value <= 0xFFFF) else {
    fail("\{name} has a value outside UInt16")
  }
  self.write_array(
    doc,
    name,
    "ReadOnlyArray[UInt16]",
    values.map(value => value.to_string()),
  )
}

///|
pub fn Emitter::write_byte_array(
  self : Emitter,
  doc : String,
  name : String,
  values : Array[Int32],
) -> Unit {
  self.write_array(doc, name, "Bytes", values.map(value => value.to_string()))
}

///|
/// Split each value into its high and low byte.
pub fn big_endian_16(values : Array[Int32]) -> Array[Int32] {
  let bytes = []
  for value in values {
    bytes.push(value >> 8)
    bytes.push(value & 0xFF)
  }
  bytes
}
