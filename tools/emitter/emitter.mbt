///|
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
pub fn Emitter::write_char(self : Emitter, character : Char) -> Unit {
  self.out.write_char(character)
}

///|
pub fn Emitter::write_int(self : Emitter, value : Int) -> Unit {
  self.out.write_object(value)
}

///|
pub fn Emitter::write_line(self : Emitter, source : String) -> Unit {
  self.write(source)
  self.write_char('\n')
}

///|
pub fn Emitter::finish(self : Emitter) -> String {
  self.out.to_string()
}

///|
/// Uppercase hexadecimal digit for a value in `0..15`.
fn hex_digit(value : Int) -> Char {
  if value < 10 {
    (value + '0'.to_int()).unsafe_to_char()
  } else {
    (value - 10 + 'A'.to_int()).unsafe_to_char()
  }
}

///|
/// Uppercase hexadecimal representation of `value`, zero-padded to at least
/// `min_width` digits.
pub fn hex_upper(value : Int, min_width? : Int = 0) -> String {
  let out = StringBuilder()
  let digits : Array[Char] = []
  let mut remaining = value
  if remaining == 0 {
    digits.push('0')
  }
  while remaining > 0 {
    digits.push(hex_digit(remaining % 16))
    remaining = remaining / 16
  }
  while digits.length() < min_width {
    digits.push('0')
  }
  for digit in digits.rev_iter() {
    out.write_char(digit)
  }
  out.to_string()
}

///|
/// `0x`-prefixed uppercase hexadecimal, zero-padded to at least four digits.
fn hex_code(value : Int) -> String {
  "0x" + hex_upper(value, min_width=4)
}

///|
pub fn Emitter::write_file_header(
  self : Emitter,
  title : String,
  generated_from : String,
) -> Unit {
  self.write("///|\n")
  self.write("/// " + title + "\n")
  self.write("/// Generated from " + generated_from + "\n\n")
}

///|
pub fn Emitter::write_int_array(
  self : Emitter,
  doc : String,
  name : String,
  values : Array[Int],
  hex~ : Bool,
) -> Unit {
  self.write("///|\n")
  self.write("/// " + doc + "\n")
  self.write("let " + name + " : ReadOnlyArray[Int] = [\n")
  for value in values {
    self.write("  ")
    if hex {
      self.write(hex_code(value))
    } else {
      self.write(value.to_string())
    }
    self.write(",\n")
  }
  self.write("]\n\n")
}

///|
pub fn Emitter::write_byte_array(
  self : Emitter,
  doc : String,
  name : String,
  values : Array[Int],
) -> Unit {
  self.write("///|\n")
  self.write("/// " + doc + "\n")
  self.write("let " + name + " : Bytes = [\n")
  for value in values {
    self.write("  ")
    self.write(value.to_string())
    self.write(",\n")
  }
  self.write("]\n\n")
}
