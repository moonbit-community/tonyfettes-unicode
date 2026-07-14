///|
fn strip_comment(line : StringView) -> StringView {
  match line.split_once("#") {
    Some((before, _)) => before.trim()
    None => line.trim()
  }
}

///|
fn parse_hex_int(text : StringView) -> Int raise {
  @string.parse_int(text.trim(), base=16)
}

///|
fn parse_decimal_int(text : StringView) -> Int raise {
  @string.parse_int(text.trim(), base=10)
}

///|
fn parse_code_point_sequence(text : StringView) -> Array[Int] raise {
  let result : Array[Int] = []
  for part in text.trim().split(" ") {
    let part = part.trim()
    if part.length() > 0 {
      result.push(parse_hex_int(part))
    }
  }
  result
}

///|
fn is_mark_category(category : StringView) -> Bool {
  category.strip_prefix("M") is Some(_)
}

///|
fn is_identity_or_empty(cp : Int, targets : Array[Int]) -> Bool {
  targets.length() == 0 || (targets.length() == 1 && targets[0] == cp)
}

///|
fn append_general_category(
  general_categories : Array[GeneralCategoryEntry],
  mark_code_points : Array[Int],
  cp : Int,
  category : String,
) -> Unit {
  general_categories.push({ code_point: cp, category })
  if is_mark_category(category) {
    mark_code_points.push(cp)
  }
}

///|
pub fn parse_unicode_data(content : String) -> UnicodeData raise {
  let ccc_entries : Array[CccEntry] = []
  let canonical_decompositions : Array[DecompositionEntry] = []
  let compatibility_decompositions : Array[DecompositionEntry] = []
  let mark_code_points : Array[Int] = []
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
    let cp = parse_hex_int(fields[0])
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
      parse_decimal_int(ccc_text)
    } else {
      0
    }
    if ccc != 0 {
      ccc_entries.push({ code_point: cp, value: ccc })
    }
    let decomp = fields[5].trim()
    if decomp.length() > 0 {
      if decomp.strip_prefix("<") is Some(_) {
        match decomp.split_once(">") {
          Some((_, rest)) => {
            let code_points = parse_code_point_sequence(rest)
            if code_points.length() > 0 {
              compatibility_decompositions.push({ code_point: cp, code_points })
            }
          }
          None => ()
        }
      } else {
        let code_points = parse_code_point_sequence(decomp)
        if code_points.length() > 0 {
          canonical_decompositions.push({ code_point: cp, code_points })
        }
      }
    }
    let upper = fields[12].trim()
    if upper.length() > 0 {
      let target = parse_hex_int(upper)
      if target != cp {
        simple_uppercase.push({ code_point: cp, target })
      }
    }
    let lower = fields[13].trim()
    if lower.length() > 0 {
      let target = parse_hex_int(lower)
      if target != cp {
        simple_lowercase.push({ code_point: cp, target })
      }
    }
    let title = fields[14].trim()
    if title.length() > 0 {
      let target = parse_hex_int(title)
      if target != cp {
        simple_titlecase.push({ code_point: cp, target })
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
pub fn parse_composition_exclusions(content : String) -> Array[Int] raise {
  let exclusions : Array[Int] = []
  for raw_line in content.split("\n") {
    let line = strip_comment(raw_line)
    if line.length() == 0 {
      continue
    }
    match line.split_once("..") {
      Some((start_text, end_text)) => {
        let start = parse_hex_int(start_text)
        let end = parse_hex_int(end_text)
        for cp in start..<=end {
          exclusions.push(cp)
        }
      }
      None => exclusions.push(parse_hex_int(line))
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
    let line = strip_comment(raw_line)
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
    let cp = parse_hex_int(fields[0])
    let lower = parse_code_point_sequence(fields[1])
    let title = parse_code_point_sequence(fields[2])
    let upper = parse_code_point_sequence(fields[3])
    if !is_identity_or_empty(cp, lower) {
      lower_mapping.push({ code_point: cp, targets: lower })
    }
    if !is_identity_or_empty(cp, title) {
      title_mapping.push({ code_point: cp, targets: title })
    }
    if !is_identity_or_empty(cp, upper) {
      upper_mapping.push({ code_point: cp, targets: upper })
    }
  }
  { lower_mapping, title_mapping, upper_mapping }
}
