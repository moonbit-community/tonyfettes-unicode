///|
pub(all) struct GeneratedFile {
  relative_path : String
  source : String
} derive(Debug, Eq)

///|
pub(all) struct CodePointRange {
  start : Int
  end : Int
} derive(Debug, Eq)

///|
pub(all) struct ParsedText {
  text : String
  has_surrogate : Bool
} derive(Debug, Eq)

///|
pub fn strip_comment(line : StringView) -> StringView {
  if line.split_once("#") is Some((before, _)) {
    before.trim()
  } else {
    line.trim()
  }
}

///|
pub fn parse_hex_int(text : StringView) -> Int raise {
  @string.parse_int(text.trim(), base=16)
}

///|
pub fn parse_decimal_int(text : StringView) -> Int raise {
  @string.parse_int(text.trim(), base=10)
}

///|
pub fn parse_code_point_range(text : StringView) -> CodePointRange raise {
  let text = text.trim()
  if text.split_once("..") is Some((start_text, end_text)) {
    { start: parse_hex_int(start_text), end: parse_hex_int(end_text), }
  } else {
    let code_point = parse_hex_int(text)
    { start: code_point, end: code_point, }
  }
}

///|
pub fn parse_code_point_sequence(text : StringView) -> Array[Int] raise {
  let result : Array[Int] = []
  for part in text.trim().split(" ") {
    let part = part.trim()
    if !part.is_empty() {
      result.push(parse_hex_int(part))
    }
  }
  result
}

///|
fn hex_digit(value : Int) -> Char {
  if value < 10 {
    (value + '0'.to_int()).unsafe_to_char()
  } else {
    (value - 10 + 'A'.to_int()).unsafe_to_char()
  }
}

///|
pub fn hex_upper(value : Int, min_width? : Int = 0) -> String {
  let out = @emitter.Emitter::new()
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
  out.finish()
}

///|
pub fn moonbit_code_point_escape(code_point : Int) -> String {
  "\\u{\{hex_upper(code_point, min_width=4)}}"
}

///|
pub fn code_points_to_moonbit_string(code_points : ArrayView[Int]) -> String {
  let out = @emitter.Emitter::new()
  for code_point in code_points {
    out.write(moonbit_code_point_escape(code_point))
  }
  out.finish()
}

///|
pub fn int_array_literal(values : ArrayView[Int]) -> String {
  let out = @emitter.Emitter::new()
  out.write("[")
  for index, value in values {
    if index > 0 {
      out.write(", ")
    }
    out.write_int(value)
  }
  out.write("]")
  out.finish()
}

///|
pub fn optional_int_array_literal(values : ArrayView[Int?]) -> String {
  let out = @emitter.Emitter::new()
  out.write("[")
  for index, value in values {
    if index > 0 {
      out.write(", ")
    }
    out.write_int(value.unwrap_or(-1))
  }
  out.write("]")
  out.finish()
}

///|
pub fn bool_literal(value : Bool) -> String {
  if value {
    "true"
  } else {
    "false"
  }
}

///|
pub fn escape_moonbit_string(text : StringView) -> String {
  let out = @emitter.Emitter::new()
  for character in text {
    let code_point = character.to_int()
    match character {
      '\\' => out.write("\\\\")
      '"' => out.write("\\\"")
      '\n' => out.write("\\n")
      '\r' => out.write("\\r")
      '\t' => out.write("\\t")
      _ if code_point >= 0x20 && code_point <= 0x7E => out.write_char(character)
      _ if code_point <= 0xFFFF => {
        out.write("\\u")
        out.write(hex_upper(code_point, min_width=4))
      }
      _ => {
        out.write("\\u{")
        out.write(hex_upper(code_point))
        out.write("}")
      }
    }
  }
  out.finish()
}

///|
fn hex_value(character : Char) -> Int? {
  match character {
    '0'..='9' => Some(character.to_int() - '0'.to_int())
    'a'..='f' => Some(character.to_int() - 'a'.to_int() + 10)
    'A'..='F' => Some(character.to_int() - 'A'.to_int() + 10)
    _ => None
  }
}

///|
fn parse_hex_chars(chars : ArrayView[Char]) -> Int? {
  if chars.is_empty() {
    return None
  }
  let mut value = 0
  for character in chars {
    guard hex_value(character) is Some(digit) else { return None }
    value = value * 16 + digit
  }
  Some(value)
}

///|
fn parse_braced_hex(chars : ArrayView[Char]) -> (Int, ArrayView[Char])? {
  for remaining = chars, value = 0, has_digit = false {
    match remaining {
      ['}', .. rest] if has_digit => break Some((value, rest))
      [character, .. rest] => {
        guard hex_value(character) is Some(digit) else { break None }
        continue rest, value * 16 + digit, true
      }
      _ => break None
    }
  }
}

///|
pub fn parse_escaped_text(text : StringView) -> ParsedText {
  if text == "\"\"" {
    return { text: "", has_surrogate: false, }
  }
  let chars = text.iter().collect()
  let out = @emitter.Emitter::new()
  let mut has_surrogate = false
  for remaining = chars.view() {
    match remaining {
      [] => break
      ['\\', 'u', a, b, c, d, .. rest] =>
        if parse_hex_chars([a, b, c, d]) is Some(code_point) {
          if code_point >= 0xD800 && code_point <= 0xDFFF {
            has_surrogate = true
          }
          out.write_char(code_point.unsafe_to_char())
          continue rest
        } else {
          out.write_char('\\')
          continue ['u', a, b, c, d, ..rest]
        }
      ['\\', 'x', '{', .. after_open] =>
        if parse_braced_hex(after_open) is Some((code_point, rest)) {
          if code_point >= 0xD800 && code_point <= 0xDFFF {
            has_surrogate = true
          }
          out.write_char(code_point.unsafe_to_char())
          continue rest
        } else {
          out.write("\\x{")
          continue after_open
        }
      [character, .. rest] => {
        out.write_char(character)
        continue rest
      }
    }
  }
  { text: out.finish(), has_surrogate, }
}

///|
pub fn truncate_chars(text : StringView, max_chars : Int) -> String {
  let out = @emitter.Emitter::new()
  let mut count = 0
  let mut truncated = false
  for character in text {
    if count < max_chars {
      out.write_char(character)
      count += 1
    } else {
      truncated = true
      break
    }
  }
  if truncated {
    out.write("...")
  }
  out.finish()
}
