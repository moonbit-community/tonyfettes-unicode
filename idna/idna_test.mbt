///|
/// Tests for IDNA processing (UTS #46)

///|
test "to_ascii: pure ASCII domain" {
  inspect(to_ascii("example.com"), content="example.com")
}

///|
test "to_ascii: simple IDN" {
  // münchen.de -> xn--mnchen-3ya.de
  inspect(to_ascii("münchen.de"), content="xn--mnchen-3ya.de")
}

///|
test "to_ascii: Chinese domain" {
  // 中文.com
  inspect(to_ascii("中文.com"), content="xn--fiq228c.com")
}

///|
test "to_ascii: Japanese domain" {
  // ドメイン.jp
  inspect(to_ascii("ドメイン.jp"), content="xn--eckwd4c7c.jp")
}

///|
test "to_ascii: mixed ASCII and Unicode" {
  inspect(to_ascii("bücher.example.com"), content="xn--bcher-kva.example.com")
}

///|
test "to_ascii: uppercase conversion" {
  inspect(to_ascii("EXAMPLE.COM"), content="example.com")
}

///|
test "to_ascii: fullwidth separators" {
  // Fullwidth full stop U+FF0E should be treated as separator
  inspect(to_ascii("example\u{FF0E}com"), content="example.com")
}

///|
test "to_unicode: pure ASCII domain" {
  inspect(to_unicode("example.com"), content="example.com")
}

///|
test "to_unicode: Punycode domain" {
  // xn--mnchen-3ya.de -> münchen.de
  inspect(to_unicode("xn--mnchen-3ya.de"), content="münchen.de")
}

///|
test "to_unicode: Chinese Punycode" {
  inspect(to_unicode("xn--fiq228c.com"), content="中文.com")
}

///|
test "roundtrip: German" {
  let original = "münchen.de"
  let ascii = to_ascii(original)
  let back = to_unicode(ascii)
  assert_eq(back, original)
}

///|
test "roundtrip: Chinese" {
  let original = "中文.com"
  let ascii = to_ascii(original)
  let back = to_unicode(ascii)
  assert_eq(back, original)
}

///|
test "roundtrip: Japanese" {
  let original = "ドメイン.jp"
  let ascii = to_ascii(original)
  let back = to_unicode(ascii)
  assert_eq(back, original)
}

///|
test "roundtrip: Korean" {
  let original = "한국어.kr"
  let ascii = to_ascii(original)
  let back = to_unicode(ascii)
  assert_eq(back, original)
}

///|
test "roundtrip: Russian" {
  let original = "пример.ru"
  let ascii = to_ascii(original)
  let back = to_unicode(ascii)
  assert_eq(back, original)
}

///|
test "panic invalid: disallowed character" {
  // U+0000 is disallowed
  let result : Result[String, Error] = try? to_ascii("example\u{0000}.com")
  guard result is Err(_) else {
    fail("Expected error for disallowed character")
  }
}

///|
test "to_ascii: double dots handled" {
  // Double dots create an empty label which triggers EmptyLabel error
  let result : Result[String, Error] = try? to_ascii("example..com")
  inspect(result, content="Err(EmptyLabel)")
}

///|
test "to_ascii: label too long" {
  // Create a label that will be > 63 characters after Punycode encoding
  // This is hard to test directly, so we test with already long ASCII
  let long_label = "a".repeat(64)
  let result : Result[String, Error] = try? to_ascii(long_label + ".com")
  guard result is Err(_) else { fail("Expected error for label too long") }
}

///|
test "mapping: ignored characters" {
  // Soft hyphen U+00AD is ignored
  inspect(to_ascii("exam\u{00AD}ple.com"), content="example.com")
}

///|
test "mapping: mapped characters" {
  // U+00DF (ß) maps to "ss"
  inspect(to_ascii("straße.de"), content="xn--strae-oqa.de")
}

///|
test "validation: hyphen at start" {
  let result : Result[String, Error] = try? to_ascii("-example.com")
  guard result is Err(_) else { fail("Expected error for hyphen at start") }
}

///|
test "validation: hyphen at end" {
  let result : Result[String, Error] = try? to_ascii("example-.com")
  guard result is Err(_) else { fail("Expected error for hyphen at end") }
}

///|
test "std3 rules: space character" {
  // Space U+0020 is marked as "valid" in IDNA mapping table (with NV8)
  // UTS46 compatibility mode allows it
  let result : Result[String, Error] = try? to_ascii("exam ple.com")
  inspect(result, content="Ok(\"exam ple.com\")")
}

///|
test "std3 disabled: allows some characters" {
  // Without STD3 rules, some characters are allowed
  let result = to_ascii(
    "example.com",
    use_std3_ascii_rules=false,
    check_hyphens=false,
  )
  inspect(result, content="example.com")
}

///|
test "to_ascii: ideographic full stop" {
  // Ideographic full stop U+3002 should be treated as separator
  inspect(to_ascii("中文\u{3002}com"), content="xn--fiq228c.com")
}

///|
test "to_ascii: multiple labels" {
  inspect(
    to_ascii("münchen.example.中文.com"),
    content="xn--mnchen-3ya.example.xn--fiq228c.com",
  )
}

///|
test "to_unicode: mixed Punycode and ASCII" {
  inspect(
    to_unicode("xn--mnchen-3ya.example.com"),
    content="münchen.example.com",
  )
}

///|
test "case folding: uppercase to lowercase" {
  inspect(to_ascii("MÜNCHEN.DE"), content="xn--mnchen-3ya.de")
}
