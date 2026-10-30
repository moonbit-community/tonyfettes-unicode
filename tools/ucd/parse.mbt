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
fn is_mark_category(category : StringView) -> Bool {
  category.strip_prefix("M") is Some(_)
}

///|
fn is_identity_or_empty(cp : Int32, targets : Array[Int32]) -> Bool {
  targets.length() == 0 || (targets.length() == 1 && targets[0] == cp)
}

///|
fn append_general_category(
  general_categories : Array[GeneralCategoryEntry],
  mark_code_points : Array[Int32],
  cp : Int32,
  category : String,
) -> Unit {
  general_categories.push({ code_point: cp, category, })
  if is_mark_category(category) {
    mark_code_points.push(cp)
  }
}

///|
pub fn parse_unicode_data(content : String) -> UnicodeData raise {
  let ccc_entries : Array[CccEntry] = []
  let canonical_decompositions : Array[DecompositionEntry] = []
  let compatibility_decompositions : Array[DecompositionEntry] = []
  let mark_code_points : Array[Int32] = []
  let general_categories : Array[GeneralCategoryEntry] = []
  let simple_uppercase : Array[SimpleMappingEntry] = []
  let simple_lowercase : Array[SimpleMappingEntry] = []
  let simple_titlecase : Array[SimpleMappingEntry] = []
  let mut range_start = -1
  let mut range_category = ""
  for raw_line in content.split("\n") {
    let line = raw_line.trim()
    if line.length() == 0 || line.strip_prefix("#") is Some(_) {
      continue
    }
    let fields = line.split(";").to_array()
    if fields.length() < 15 {
      continue
    }
    let cp = @parsing.parse_hex_int(fields[0])
    let name = fields[1].trim()
    let general_category = fields[2].trim().to_owned()
    if name.has_suffix(", First>") {
      if range_start >= 0 {
        fail("Nested UnicodeData First range")
      }
      range_start = cp
      range_category = general_category
      continue
    }
    if name.has_suffix(", Last>") {
      if range_start < 0 || range_category != general_category {
        fail("Mismatched UnicodeData First/Last range")
      }
      for range_cp in range_start..<=cp {
        append_general_category(
          general_categories, mark_code_points, range_cp, range_category,
        )
      }
      range_start = -1
      range_category = ""
      continue
    }
    append_general_category(
      general_categories, mark_code_points, cp, general_category,
    )
    let ccc_text = fields[3].trim()
    let ccc = if ccc_text.length() > 0 {
      @parsing.parse_decimal_int(ccc_text)
    } else {
      0
    }
    if ccc != 0 {
      ccc_entries.push({ code_point: cp, value: ccc, })
    }
    let decomp = fields[5].trim()
    if decomp.length() > 0 {
      if decomp.strip_prefix("<") is Some(_) {
        match decomp.split_once(">") {
          Some((_, rest)) => {
            let code_points = @parsing.parse_code_point_sequence(rest)
            if code_points.length() > 0 {
              compatibility_decompositions.push({ code_point: cp, code_points, })
            }
          }
          None => ()
        }
      } else {
        let code_points = @parsing.parse_code_point_sequence(decomp)
        if code_points.length() > 0 {
          canonical_decompositions.push({ code_point: cp, code_points, })
        }
      }
    }
    let upper = fields[12].trim()
    if upper.length() > 0 {
      let target = @parsing.parse_hex_int(upper)
      if target != cp {
        simple_uppercase.push({ code_point: cp, target, })
      }
    }
    let lower = fields[13].trim()
    if lower.length() > 0 {
      let target = @parsing.parse_hex_int(lower)
      if target != cp {
        simple_lowercase.push({ code_point: cp, target, })
      }
    }
    let title = fields[14].trim()
    if title.length() > 0 {
      let target = @parsing.parse_hex_int(title)
      if target != cp {
        simple_titlecase.push({ code_point: cp, target, })
      }
    }
  }
  if range_start >= 0 {
    fail("Unterminated UnicodeData First range")
  }
  {
    ccc_entries,
    canonical_decompositions,
    compatibility_decompositions,
    mark_code_points,
    general_categories,
    simple_uppercase,
    simple_lowercase,
    simple_titlecase,
  }
}

///|
pub fn parse_composition_exclusions(content : String) -> Array[Int32] raise {
  let exclusions : Array[Int32] = []
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.length() == 0 {
      continue
    }
    let range = @parsing.parse_code_point_range(line)
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
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.length() == 0 {
      continue
    }
    let fields = line.split(";").to_array()
    if fields.length() < 4 {
      continue
    }
    if fields.length() > 4 && fields[4].trim().length() > 0 {
      continue
    }
    let cp = @parsing.parse_hex_int(fields[0])
    let lower = @parsing.parse_code_point_sequence(fields[1])
    let title = @parsing.parse_code_point_sequence(fields[2])
    let upper = @parsing.parse_code_point_sequence(fields[3])
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
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    if line.split_once(";") is Some((range_text, property_text)) &&
      property_text.trim() == property[:] {
      ranges.push(@parsing.parse_code_point_range(range_text))
    }
  }
  validate_property_ranges(property, ranges)
  ranges
}

///|
pub fn parse_derived_core_properties(
  content : String,
) -> DerivedCoreProperties raise {
  let xid_start = parse_property_ranges(content, "XID_Start")
  let xid_continue = parse_property_ranges(content, "XID_Continue")
  validate_xid_subset(xid_start, xid_continue)
  {
    alphabetic: parse_property_ranges(content, "Alphabetic"),
    lowercase: parse_property_ranges(content, "Lowercase"),
    uppercase: parse_property_ranges(content, "Uppercase"),
    xid_start,
    xid_continue,
    default_ignorable_code_point: parse_property_ranges(
      content, "Default_Ignorable_Code_Point",
    ),
    grapheme_extend: parse_property_ranges(content, "Grapheme_Extend"),
  }
}

///|
pub fn parse_prop_list(content : String) -> PropList raise {
  {
    white_space: parse_property_ranges(content, "White_Space"),
    regional_indicator: parse_property_ranges(content, "Regional_Indicator"),
    prepended_concatenation_mark: parse_property_ranges(
      content, "Prepended_Concatenation_Mark",
    ),
  }
}

///|
pub fn parse_emoji_data(content : String) -> EmojiData raise {
  {
    extended_pictographic: parse_property_ranges(
      content, "Extended_Pictographic",
    ),
    emoji_presentation: parse_property_ranges(content, "Emoji_Presentation"),
    emoji_modifier: parse_property_ranges(content, "Emoji_Modifier"),
    emoji_modifier_base: parse_property_ranges(content, "Emoji_Modifier_Base"),
  }
}

///|
/// Collect the characters `emoji-variation-sequences.txt` lists a variation
/// sequence for, as sorted ranges.
///
/// Every data line is `base selector ; style`, where the selector is U+FE0E
/// for `text style` and U+FE0F for `emoji style`. Each base must have both
/// sequences, so that one set of characters describes the file.
pub fn parse_emoji_variation_sequences(
  content : String,
) -> Array[@parsing.CodePointRange] raise {
  let text_style : Array[Int32] = []
  let emoji_style : Array[Int32] = []
  for raw_line in content.split("\n") {
    let line = @parsing.strip_comment(raw_line)
    guard line.split(";").collect() is [sequence, style, ..] else { continue }
    match (@parsing.parse_code_point_sequence(sequence), style.trim()) {
      ([base, 0xFE0E], "text style") => text_style.push(base)
      ([base, 0xFE0F], "emoji style") => emoji_style.push(base)
      _ => fail("Unexpected emoji variation sequence: \{line}")
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
