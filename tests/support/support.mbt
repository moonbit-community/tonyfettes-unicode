///|
/// Shared helpers for the workspace conformance test packages.
///
/// The official Unicode test data files live in the `data` directory of this
/// module. Tests read them at run time with `moonbitlang/async/fs`, so no test
/// code is generated from these files.

///|
/// Read a test data file by name, locating the module's `data` directory
/// relative to the current working directory.
pub async fn read_data_file(name : String) -> String {
  for prefix in ["tests/data/", "data/", "../data/", "../../data/"] {
    let path = "\{prefix}\{name}"
    if @fs.exists(path) {
      return @fs.read_file(path).text()
    }
  }
  fail(
    "test data file `\{name}` not found; run tests from the repository root or the tests module root",
  )
}

///|
/// Parse a hexadecimal integer, e.g. `"1E0A"`.
pub fn parse_hex_int(text : StringView) -> Int raise {
  @string.parse_int(text.trim(), base=16)
}

///|
/// Parse a decimal integer.
pub fn parse_decimal_int(text : StringView) -> Int raise {
  @string.parse_int(text.trim(), base=10)
}

///|
/// Parse a space-separated sequence of hexadecimal code points.
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
/// Build a string from code points. Returns `None` if any code point is a
/// surrogate, which MoonBit strings cannot represent.
pub fn code_points_to_string(code_points : ArrayView[Int]) -> String? {
  let out = StringBuilder()
  for code_point in code_points {
    if code_point >= 0xD800 && code_point <= 0xDFFF {
      return None
    }
    out.write_char(code_point.unsafe_to_char())
  }
  Some(out.to_string())
}

///|
/// Parse a space-separated list of bidi levels; `x`/`X` marks a removed
/// character and is represented as `-1`.
pub fn parse_levels(text : StringView) -> Array[Int] raise {
  let levels : Array[Int] = []
  for part in text.trim().split(" ") {
    let part = part.trim()
    if part.is_empty() {
      continue
    }
    match part {
      "x" | "X" => levels.push(-1)
      number => levels.push(parse_decimal_int(number))
    }
  }
  levels
}

///|
/// Parse a space-separated list of visual ordering indices.
pub fn parse_reorder(text : StringView) -> Array[Int] raise {
  let reorder : Array[Int] = []
  for part in text.trim().split(" ") {
    let part = part.trim()
    if !part.is_empty() {
      reorder.push(parse_decimal_int(part))
    }
  }
  reorder
}

///|
pub struct ParsedText {
  text : String
  has_surrogate : Bool
} derive(Debug, Eq)

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
/// Unescape IdnaTestV2.txt text: literal characters plus `\uXXXX` and
/// `\x{...}` escapes. Tracks whether any surrogate code point appeared.
pub fn parse_escaped_text(text : StringView) -> ParsedText {
  if text == "\"\"" {
    return { text: "", has_surrogate: false }
  }
  let chars = text.iter().collect()
  let out = StringBuilder()
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
          out.write_string("\\x{")
          continue after_open
        }
      [character, .. rest] => {
        out.write_char(character)
        continue rest
      }
    }
  }
  { text: out.to_string(), has_surrogate }
}

///|
/// Parse an IdnaTestV2.txt status list such as `[B1, C2]` or `[]`.
pub fn parse_status(text : StringView) -> Array[String]? {
  let text = text.trim()
  if text.is_empty() {
    return None
  }
  if text == "[]" {
    return Some([])
  }
  guard text.strip_prefix("[") is Some(after_open) else { return None }
  guard after_open.split_once("]") is Some((codes, _)) else { return None }
  let result : Array[String] = []
  for code in codes.replace_all(old=",", new=" ").split(" ") {
    let code = code.trim()
    if !code.is_empty() {
      result.push(code.to_owned())
    }
  }
  Some(result)
}
