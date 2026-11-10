///|
#derive(Debug, Eq)
pub(all) struct CodePointRange {
  start : Int32
  end : Int32
}

///|
pub extend CodePointRange with Debug::{to_repr}

///|
pub extend CodePointRange with Eq::{not_equal, equal}

///|
pub fn strip_comment(line : StringView) -> StringView {
  if line.split_once("#") is Some((before, _)) {
    before.trim()
  } else {
    line.trim()
  }
}

///|
/// The fields of every data line of a UCD file: the text before any `#`
/// comment, split at `;`, with every field trimmed. Blank and comment-only
/// lines are skipped.
pub fn data_lines(content : StringView) -> Iter[Array[StringView]] {
  content
  .split("\n")
  .filter_map(line => {
    let line = strip_comment(line)
    if line.is_empty() {
      None
    } else {
      Some(line.split(";").map(field => field.trim()).collect())
    }
  })
}

///|
pub fn parse_hex_int(text : StringView) -> Int32 raise {
  @string.parse_int(text.trim(), base=16)
}

///|
pub fn parse_decimal_int(text : StringView) -> Int32 raise {
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
/// Read a UCD file for one enumerated property, whose data lines are
/// `range ; value`, and return the value of every code point.
///
/// Code points the file does not list take the value of the last
/// `# @missing: range; value` line covering them, or `default` when there is
/// none. Values are returned as written, so a `@missing` line that spells out
/// a long alias such as `Neutral` yields that alias.
pub fn parse_enumerated_property(
  content : StringView,
  default~ : String,
) -> FixedArray[String] raise {
  let values = FixedArray::make(@emitter.MaxCodePoint + 1, default)
  let fill = (range_text : StringView, value : StringView) => {
    let range = parse_code_point_range(range_text)
    let value = value.trim().to_owned()
    for code_point in range.start..<=range.end {
      values[code_point] = value
    }
  }
  for raw_line in content.split("\n") {
    if raw_line.trim().strip_prefix("# @missing:") is Some(declaration) &&
      declaration.split_once(";") is Some((range, value)) {
      fill(range, value)
    }
  }
  for fields in data_lines(content) {
    if fields is [range, value, ..] {
      fill(range, value)
    }
  }
  values
}

///|
/// Read a UCD file for one enumerated property like
/// `parse_enumerated_property`, and convert the value of every code point
/// with `ordinal_of`, which accepts each spelling the file uses.
pub fn parse_enumerated_ordinals(
  content : StringView,
  property~ : String,
  default~ : String,
  ordinal_of : (StringView) -> Int32?,
) -> FixedArray[Int32] raise {
  let names = parse_enumerated_property(content, default~)
  let ordinals = FixedArray::make(names.length(), 0)
  for code_point, name in names {
    guard ordinal_of(name) is Some(ordinal) else {
      fail("Unknown \{property}: \{name}")
    }
    ordinals[code_point] = ordinal
  }
  ordinals
}

///|
pub fn parse_code_point_sequence(text : StringView) -> Array[Int32] raise {
  let result : Array[Int32] = []
  for part in text.trim().split(" ") {
    let part = part.trim()
    if !part.is_empty() {
      result.push(parse_hex_int(part))
    }
  }
  result
}
