///|
test "split_labels: every separator" {
  debug_inspect(
    split_labels("a.b\u{3002}c\u{FF0E}d\u{FF61}e"),
    content=(
      #|["a", "b", "c", "d", "e"]
    ),
  )
  debug_inspect(split_labels(""), content="[\"\"]")
  debug_inspect(split_labels("."), content="[\"\", \"\"]")
  debug_inspect(split_labels("a..b."), content="[\"a\", \"\", \"b\", \"\"]")
}

///|
test "split_labels: supplementary characters next to separators" {
  let labels = split_labels("\u{1F600}.a\u{1F600}\u{3002}\u{1F600}")
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
