///|
fn validate_property_ranges(
  name : StringView,
  ranges : Array[@parsing.CodePointRange],
) -> Unit raise {
  if ranges.length() == 0 {
    fail("Missing \{name} ranges")
  }
  let mut previous_end = -1
  for range in ranges {
    if range.start < 0 || range.start > range.end || range.end > 0x10FFFF {
      fail("Invalid \{name} range")
    }
    if range.start <= previous_end {
      fail("\{name} ranges must be sorted and non-overlapping")
    }
    previous_end = range.end
  }
}

///|
fn validate_xid_subset(
  xid_start : Array[@parsing.CodePointRange],
  xid_continue : Array[@parsing.CodePointRange],
) -> Unit raise {
  let mut continue_index = 0
  for start_range in xid_start {
    let mut next = start_range.start
    while next <= start_range.end {
      while continue_index < xid_continue.length() &&
            xid_continue[continue_index].end < next {
        continue_index += 1
      }
      if continue_index >= xid_continue.length() ||
        xid_continue[continue_index].start > next {
        fail("XID_Start must be a subset of XID_Continue")
      }
      next = xid_continue[continue_index].end + 1
    }
  }
}

///|
fn is_identity_or_empty(cp : Int32, targets : Array[Int32]) -> Bool {
  targets.length() == 0 || (targets.length() == 1 && targets[0] == cp)
}

///|
/// General_Category ordinal of Cn (Unassigned), the value of every code point
/// not listed in UnicodeData.txt.
const GcUnassigned : Int32 = 29

///|
/// Ordinal of a General_Category value in the `GeneralCategory` enum.
fn gc_ordinal(category : StringView) -> Int32 {
  match category {
    "Lu" => 0
    "Ll" => 1
    "Lt" => 2
    "Lm" => 3
    "Lo" => 4
    "Mn" => 5
    "Mc" => 6
    "Me" => 7
    "Nd" => 8
    "Nl" => 9
    "No" => 10
    "Zs" => 11
    "Zl" => 12
    "Zp" => 13
    "Pc" => 14
    "Pd" => 15
    "Ps" => 16
    "Pe" => 17
    "Pi" => 18
    "Pf" => 19
    "Po" => 20
    "Sm" => 21
    "Sc" => 22
    "Sk" => 23
    "So" => 24
    "Cc" => 25
    "Cf" => 26
    "Cs" => 27
    "Co" => 28
    _ => GcUnassigned
  }
}

///|
/// Parse the code point sequence of a simple case mapping field, keeping it
/// only when it maps the code point elsewhere.
fn push_simple_mapping(
  mappings : Array[SimpleMappingEntry],
  code_point : Int32,
  field : StringView,
) -> Unit raise {
  if field.is_empty() {
    return
  }
  let target = @parsing.parse_hex_int(field)
  if target != code_point {
    mappings.push({ code_point, target, })
  }
}

///|
pub fn parse_unicode_data(content : String) -> UnicodeData raise {
  let general_categories = FixedArray::make(
    @emitter.MaxCodePoint + 1,
    GcUnassigned,
  )
  let ccc = FixedArray::make(@emitter.MaxCodePoint + 1, 0)
  let decompositions : Array[Decomposition] = []
  let simple_uppercase : Array[SimpleMappingEntry] = []
  let simple_lowercase : Array[SimpleMappingEntry] = []
  let simple_titlecase : Array[SimpleMappingEntry] = []
  // Start and category of an open `<..., First>` range.
  let mut range_start : (Int32, StringView)? = None
  for fields in @parsing.data_lines(content) {
    if fields.length() < 15 {
      continue
    }
    let cp = @parsing.parse_hex_int(fields[0])
    let name = fields[1]
    let category = fields[2]
    if name.has_suffix(", First>") {
      if range_start is Some(_) {
        fail("Nested UnicodeData First range")
      }
      range_start = Some((cp, category))
      continue
    }
    if name.has_suffix(", Last>") {
      guard range_start is Some((start, start_category)) &&
        start_category == category else {
        fail("Mismatched UnicodeData First/Last range")
      }
      for range_cp in start..<=cp {
        general_categories[range_cp] = gc_ordinal(category)
      }
      range_start = None
      continue
    }
    general_categories[cp] = gc_ordinal(category)
    if !fields[3].is_empty() {
      let value = @parsing.parse_decimal_int(fields[3])
      guard value >= 0 && value <= 255 else {
        fail("Invalid Canonical_Combining_Class")
      }
      ccc[cp] = value
    }
    // A compatibility mapping starts with a `<tag>`.
    let (mapping, compatibility) = match fields[5].split_once(">") {
      Some((_, rest)) => (rest, true)
      None => (fields[5], false)
    }
    let code_points = @parsing.parse_code_point_sequence(mapping)
    if !code_points.is_empty() {
      decompositions.push({ code_point: cp, code_points, compatibility, })
    }
    push_simple_mapping(simple_uppercase, cp, fields[12])
    push_simple_mapping(simple_lowercase, cp, fields[13])
    push_simple_mapping(simple_titlecase, cp, fields[14])
  }
  if range_start is Some(_) {
    fail("Unterminated UnicodeData First range")
  }
  decompositions.sort_by((left, right) => left.code_point - right.code_point)
  {
    general_categories,
    ccc,
    decompositions,
    simple_uppercase,
    simple_lowercase,
    simple_titlecase,
  }
}

///|
pub fn parse_composition_exclusions(content : String) -> Array[Int32] raise {
  let exclusions : Array[Int32] = []
  for fields in @parsing.data_lines(content) {
    let range = @parsing.parse_code_point_range(fields[0])
    for cp in range.start..<=range.end {
      exclusions.push(cp)
    }
  }
  exclusions
}

///|
pub fn parse_special_casing(content : String) -> SpecialCasingData raise {
  let lower_mapping : Array[FullMappingEntry] = []
  let title_mapping : Array[FullMappingEntry] = []
  let upper_mapping : Array[FullMappingEntry] = []
  for fields in @parsing.data_lines(content) {
    // A fifth field holds the conditions of a conditional mapping.
    guard fields is [cp, lower, title, upper, .. rest] &&
      !(rest is [condition, ..] && !condition.is_empty()) else {
      continue
    }
    let cp = @parsing.parse_hex_int(cp)
    let lower = @parsing.parse_code_point_sequence(lower)
    let title = @parsing.parse_code_point_sequence(title)
    let upper = @parsing.parse_code_point_sequence(upper)
    if !is_identity_or_empty(cp, lower) {
      lower_mapping.push({ code_point: cp, targets: lower, })
    }
    if !is_identity_or_empty(cp, title) {
      title_mapping.push({ code_point: cp, targets: title, })
    }
    if !is_identity_or_empty(cp, upper) {
      upper_mapping.push({ code_point: cp, targets: upper, })
    }
  }
  { lower_mapping, title_mapping, upper_mapping, }
}

///|
/// Collect the ranges listed for one binary property in a UCD property file
/// such as `PropList.txt` or `DerivedCoreProperties.txt`.
fn parse_property_ranges(
  content : String,
  property : String,
) -> Array[@parsing.CodePointRange] raise {
  let ranges : Array[@parsing.CodePointRange] = []
  for fields in @parsing.data_lines(content) {
    if fields is [range, value, ..] && value == property {
      ranges.push(@parsing.parse_code_point_range(range))
    }
  }
  validate_property_ranges(property, ranges)
  ranges
}

///|
/// Collect the characters `emoji-variation-sequences.txt` lists a variation
/// sequence for, as sorted ranges.
///
/// Every data line is `base selector ; style`, where the selector is U+FE0E
/// for `text style` and U+FE0F for `emoji style`. Each base must have both
/// sequences, so that one set of characters describes the file.
fn parse_emoji_variation_sequences(
  content : String,
) -> Array[@parsing.CodePointRange] raise {
  let text_style : Array[Int32] = []
  let emoji_style : Array[Int32] = []
  for fields in @parsing.data_lines(content) {
    guard fields is [sequence, style, ..] else {
      fail("Unexpected emoji variation sequence: \{fields[0]}")
    }
    match (@parsing.parse_code_point_sequence(sequence), style) {
      ([base, 0xFE0E], "text style") => text_style.push(base)
      ([base, 0xFE0F], "emoji style") => emoji_style.push(base)
      _ => fail("Unexpected emoji variation sequence: \{sequence}")
    }
  }
  text_style.sort()
  emoji_style.sort()
  guard text_style == emoji_style else {
    fail("Text and emoji variation sequences have different base characters")
  }
  let ranges : Array[@parsing.CodePointRange] = []
  for base in text_style {
    if ranges.last() is Some(range) && range.end + 1 == base {
      ranges[ranges.length() - 1] = { start: range.start, end: base, }
    } else {
      ranges.push({ start: base, end: base, })
    }
  }
  validate_property_ranges("emoji variation sequence", ranges)
  ranges
}
