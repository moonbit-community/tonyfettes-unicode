///|
/// The labels of `domain`, found the way ToASCII and ToUnicode find them.
fn split_with_label_end(domain : String) -> Array[String] {
  let labels : Array[String] = []
  let mut start = 0
  for ;; {
    let end = label_end(domain, start)
    labels.push(domain[start:end].to_owned())
    if end == domain.length() {
      break
    }
    start = end + 1
  }
  labels
}

///|
test "label_end: every separator" {
  debug_inspect(
    split_with_label_end("a.b\u{3002}c\u{FF0E}d\u{FF61}e"),
    content=(
      #|["a", "b", "c", "d", "e"]
    ),
  )
  debug_inspect(split_with_label_end(""), content="[\"\"]")
  debug_inspect(split_with_label_end("."), content="[\"\", \"\"]")
  debug_inspect(
    split_with_label_end("a..b."),
    content="[\"a\", \"\", \"b\", \"\"]",
  )
}

///|
test "label_end: supplementary characters next to separators" {
  let labels = split_with_label_end("\u{1F600}.a\u{1F600}\u{3002}\u{1F600}")
  inspect(labels.length(), content="3")
  inspect(labels[0] == "\u{1F600}", content="true")
  inspect(labels[1] == "a\u{1F600}", content="true")
  inspect(labels[2] == "\u{1F600}", content="true")
}

///|
test "map_domain: unchanged input is returned as is" {
  let domain = "b\u{00FC}cher.example"
  inspect(
    physical_equal(map_domain(domain, use_std3_ascii_rules=true), domain),
    content="true",
  )
}

///|
test "map_domain: the first change copies the prefix before it" {
  // The prefix holds a supplementary character (two UTF-16 code units).
  inspect(
    map_domain("a\u{1F600}\u{00C4}b", use_std3_ascii_rules=true) ==
    "a\u{1F600}\u{00E4}b",
    content="true",
  )
  // Ignored (soft hyphen), mapped to several characters (U+00BD), deviation kept.
  inspect(
    map_domain("a\u{00AD}b\u{00BD}\u{00DF}", use_std3_ascii_rules=true) ==
    "ab1\u{2044}2\u{00DF}",
    content="true",
  )
  inspect(map_domain("\u{00AD}", use_std3_ascii_rules=true), content="")
}

///|
test "validate_hyphens: positions count characters, not code units" {
  // The third and fourth characters are hyphens after a supplementary one.
  try validate_hyphens("\u{1F600}a--b") catch {
    error => inspect(error, content="InvalidHyphen")
  } noraise {
    _ => fail("expected InvalidHyphen")
  }
  // Hyphens in the second and third characters are allowed.
  validate_hyphens("\u{1F600}--a")
  validate_hyphens("a-b-c")
  try validate_hyphens("ab-") catch {
    error => inspect(error, content="InvalidHyphen")
  } noraise {
    _ => fail("expected InvalidHyphen")
  }
}

///|
test "has_ace_prefix ignores ASCII case" {
  inspect(has_ace_prefix("xn--a"), content="true")
  inspect(has_ace_prefix("XN--a"), content="true")
  inspect(has_ace_prefix("xN--"), content="true")
  inspect(has_ace_prefix("xn-"), content="false")
  inspect(has_ace_prefix("xn-a-"), content="false")
  inspect(has_ace_prefix("axn--"), content="false")
}

///|
test "ASCII shortcut agrees with the mapping table" {
  // `map_text` and `validate_char_status` skip the table for ASCII, taking
  // every character as valid but A-Z, which maps to a-z.
  for code in 0..<0x80 {
    let c = code.unsafe_to_char()
    let entry = @idna_data.lookup_idna_entry(c)
    if code is ('A'..<='Z') {
      assert_true(entry.status() is Mapped)
      let mapping = StringBuilder()
      entry.write_mapping(mapping)
      assert_eq(mapping.to_string(), (code + 32).unsafe_to_char().to_string())
    } else {
      assert_true(entry.status() is Valid)
    }
  }
}

///|
test "map_domain: ASCII uppercase is mapped without a lookup" {
  inspect(
    map_domain("Ab.C\u{00C4}", use_std3_ascii_rules=true),
    content="ab.c\u{00E4}",
  )
  let domain = "ab-c_d.e"
  inspect(
    physical_equal(map_domain(domain, use_std3_ascii_rules=false), domain),
    content="true",
  )
}
