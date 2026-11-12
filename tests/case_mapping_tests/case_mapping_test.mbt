///|
/// Full case mappings of one scalar value, read from the official Unicode
/// 18.0.0 files independently of the generator.
priv struct Expected {
  upper : Map[Int32, String]
  lower : Map[Int32, String]
  title : Map[Int32, String]
}

///|
fn mapping_string(field : StringView) -> String raise {
  guard @support.code_points_to_string(
      @support.parse_code_point_sequence(field),
    )
    is Some(text) else {
    fail("Invalid scalar in case mapping")
  }
  text
}

///|
/// The simple mappings of UnicodeData.txt, replaced by the unconditional
/// full mappings of SpecialCasing.txt. Conditional mappings, which need
/// context or a language, are skipped, as the library skips them.
async fn read_expected() -> Expected {
  let expected = { upper: Map([]), lower: Map([]), title: Map([]), }
  let unicode_data = @support.read_data_file("UnicodeData.txt")
  for line in unicode_data.split("\n") {
    if line.is_empty() {
      continue
    }
    let fields = line.split(";").collect()
    guard fields.length() == 15 else { fail("Invalid UnicodeData record") }
    let cp = @support.parse_hex_int(fields[0])
    let upper = fields[12]
    let lower = fields[13]
    // An empty titlecase field means the uppercase mapping.
    let title = if fields[14].is_empty() { upper } else { fields[14] }
    if !upper.is_empty() {
      expected.upper[cp] = mapping_string(upper)
    }
    if !lower.is_empty() {
      expected.lower[cp] = mapping_string(lower)
    }
    if !title.is_empty() {
      expected.title[cp] = mapping_string(title)
    }
  }
  let special_casing = @support.read_data_file("SpecialCasing.txt")
  assert_true(special_casing.has_prefix("# SpecialCasing-18.0.0.txt"))
  let mut unconditional = 0
  for raw_line in special_casing.split("\n") {
    let line = raw_line.split("#").next().unwrap().trim()
    if line.is_empty() {
      continue
    }
    guard line.split(";").collect() is [cp, lower, title, upper, condition, ..] else {
      fail("Invalid SpecialCasing record")
    }
    if !condition.trim().is_empty() {
      continue
    }
    let cp = @support.parse_hex_int(cp)
    expected.lower[cp] = mapping_string(lower)
    expected.title[cp] = mapping_string(title)
    expected.upper[cp] = mapping_string(upper)
    unconditional += 1
  }
  assert_true(unconditional > 100)
  expected
}

///|
async test "UnicodeData.txt and SpecialCasing.txt full mappings for every scalar" {
  let expected = read_expected()
  assert_true(expected.upper.length() > 1400)
  // All scalars in one string, to map runs of them at once.
  let all = StringBuilder()
  let all_upper = StringBuilder()
  let all_lower = StringBuilder()
  for cp in 0..<=0x10FFFF {
    if cp >= 0xD800 && cp <= 0xDFFF {
      continue
    }
    let c = cp.unsafe_to_char()
    let input = c.to_string()
    let upper = expected.upper.get(cp).unwrap_or(input)
    let lower = expected.lower.get(cp).unwrap_or(input)
    let title = expected.title.get(cp).unwrap_or(input)
    @debug.assert_eq(@ucd.to_uppercase(c), upper, msg="to_uppercase at \{cp}")
    @debug.assert_eq(@ucd.to_lowercase(c), lower, msg="to_lowercase at \{cp}")
    @debug.assert_eq(@ucd.to_titlecase(c), title, msg="to_titlecase at \{cp}")
    @debug.assert_eq(@ucd.uppercase(input), upper, msg="uppercase at \{cp}")
    @debug.assert_eq(@ucd.lowercase(input), lower, msg="lowercase at \{cp}")
    // Next to ASCII, which the string functions map separately.
    @debug.assert_eq(
      @ucd.uppercase("a\{input}Z"),
      "A\{upper}Z",
      msg="uppercase in context at \{cp}",
    )
    @debug.assert_eq(
      @ucd.lowercase("a\{input}Z"),
      "a\{lower}z",
      msg="lowercase in context at \{cp}",
    )
    all.write_string(input)
    all_upper.write_string(upper)
    all_lower.write_string(lower)
  }
  let all = all.to_string()
  assert_true(@ucd.uppercase(all) == all_upper.to_string())
  assert_true(@ucd.lowercase(all) == all_lower.to_string())
}
