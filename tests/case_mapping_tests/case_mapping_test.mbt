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
/// full mappings of SpecialCasing.txt. These are the character-level mappings;
/// language-independent conditional string mappings are tested separately.
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

///|
async test "SpecialCasing.txt language-independent conditional string mappings" {
  let unconditional = read_expected()
  let special_casing = @support.read_data_file("SpecialCasing.txt")
  let mut conditional = 0
  for raw_line in special_casing.split("\n") {
    let line = raw_line.split("#").next().unwrap().trim()
    if line.is_empty() {
      continue
    }
    guard line.split(";").collect() is [cp, lower, _, _, condition, ..] else {
      fail("Invalid SpecialCasing record")
    }
    let condition = condition.trim()
    if condition.is_empty() {
      continue
    }
    // Default casing does not apply Turkish, Azeri or Lithuanian tailorings.
    if condition =~ re"^(tr|az|lt)( |$)" {
      continue
    }
    guard condition == "Final_Sigma" else {
      fail("Untested language-independent casing condition: \{condition}")
    }
    let input = mapping_string(cp)
    let cp = @support.parse_hex_int(cp)
    let final_form = mapping_string(lower)
    let ordinary_form = unconditional.lower.get(cp).unwrap_or(input)
    // Prefixes and suffixes are already lowercase. The booleans encode the
    // contexts from Unicode Table 3-17, independently of the implementation.
    let prefixes = [
      ("", false),
      ("a", true),
      ("a\u{0301}", true),
      ("\u{0301}", false),
      ("\u{0345}", false),
      ("a\u{0345}", true),
      ("a ", false),
      ("a0", false),
      ("a中", false),
      ("a'", true),
      ("a\u{1D185}", true),
      ("a\u{E0100}", true),
      ("\u{10428}", true),
      ("ª", true),
      ("a\u{200D}", true),
    ]
    let suffixes = [
      ("", true),
      ("a", false),
      ("\u{0301}", true),
      ("\u{0301}a", false),
      ("\u{0345}", true),
      ("\u{0345}a", false),
      (" a", true),
      ("0a", true),
      ("中a", true),
      ("'a", false),
      ("\u{1D185}a", false),
      ("\u{E0100}a", false),
      ("\u{10428}", false),
      ("ª", false),
      ("\u{200D}", true),
    ]
    for (prefix, cased_before) in prefixes {
      for (suffix, no_cased_after) in suffixes {
        let mapped = if cased_before && no_cased_after {
          final_form
        } else {
          ordinary_form
        }
        @debug.assert_eq(
          @ucd.lowercase("\{prefix}\{input}\{suffix}"),
          "\{prefix}\{mapped}\{suffix}",
          msg="\{condition}: prefix=\{Repr(prefix)}, suffix=\{Repr(suffix)}",
        )
      }
    }
    conditional += 1
  }
  assert_true(conditional > 0)
}

///|
test "lowercase: long case-ignorable runs between successive sigmas" {
  let marks = "\u{0345}\u{E0100}".repeat(2048)
  @debug.assert_eq(
    @ucd.lowercase("AΣ\{marks}Σ\{marks}"),
    "aσ\{marks}ς\{marks}",
  )
}
