///|
test "lowercase: final sigma uses the original string context" {
  inspect(@ucd.lowercase("Σ"), content="σ")
  inspect(@ucd.lowercase("ΟΣ"), content="ος")
  inspect(@ucd.lowercase("ΟΣΑ"), content="οσα")
  inspect(@ucd.lowercase("ΣΣ"), content="σς")
  inspect(@ucd.lowercase("ΣΣΣ"), content="σσς")
  inspect(@ucd.lowercase("ΟΔΥΣΣΕΥΣ"), content="οδυσσευς")
  inspect(@ucd.lowercase("İΣ"), content="i\u{0307}ς")
  // Existing lowercase sigma forms are preserved, not reselected.
  inspect(@ucd.lowercase("ΟΣ σς"), content="ος σς")
  inspect(@ucd.to_lowercase('Σ'), content="σ")
  inspect(@ucd.to_simple_lowercase('Σ'), content="σ")
}

///|
test "lowercase: uncased characters stop the final sigma context" {
  inspect(@ucd.lowercase("AΣ"), content="aς")
  inspect(@ucd.lowercase("中Σ"), content="中σ")
  inspect(@ucd.lowercase("1Σ"), content="1σ")
  inspect(@ucd.lowercase("A Σ"), content="a σ")
  inspect(@ucd.lowercase("AΣ中A"), content="aς中a")
  inspect(@ucd.lowercase("AΣ1A"), content="aς1a")
  inspect(@ucd.lowercase("AΣ A"), content="aς a")
  // Cased includes Other_Lowercase and Other_Uppercase, not just Lu/Ll/Lt.
  inspect(@ucd.lowercase("ªΣ"), content="ªς")
  inspect(@ucd.lowercase("ⅠΣ"), content="ⅰς")
}

///|
test "lowercase: final sigma skips case-ignorable characters" {
  inspect(@ucd.lowercase("A\u{0301}Σ"), content="a\u{0301}ς")
  inspect(@ucd.lowercase("AΣ\u{0301}"), content="aς\u{0301}")
  inspect(@ucd.lowercase("AΣ\u{0301}A"), content="aσ\u{0301}a")
  inspect(@ucd.lowercase("A\u{200D}Σ"), content="a\u{200D}ς")
  inspect(@ucd.lowercase("AΣ\u{200D}"), content="aς\u{200D}")
  inspect(@ucd.lowercase("AΣ\u{200D}A"), content="aσ\u{200D}a")
  inspect(@ucd.lowercase("A'Σ"), content="a'ς")
  inspect(@ucd.lowercase("AΣ'A"), content="aσ'a")
  inspect(@ucd.lowercase("'Σ"), content="'σ")
}

///|
test "lowercase: case-ignorable takes precedence over cased" {
  // U+0345 is both Cased and Case_Ignorable. Unicode's context patterns
  // consume Case_Ignorable possessively, so it cannot supply the cased letter.
  inspect(@ucd.lowercase("\u{0345}Σ"), content="\u{0345}σ")
  inspect(@ucd.lowercase("A\u{0345}Σ"), content="a\u{0345}ς")
  inspect(@ucd.lowercase("AΣ\u{0345}"), content="aς\u{0345}")
  inspect(@ucd.lowercase("AΣ\u{0345}A"), content="aσ\u{0345}a")
  inspect(@ucd.lowercase("\u{0345}Σ\u{0345}"), content="\u{0345}σ\u{0345}")
  inspect(@ucd.lowercase("Σ\u{0345}Σ"), content="σ\u{0345}ς")
}

///|
test "lowercase: supplementary characters participate in sigma context" {
  // Deseret letters are cased; the musical combining doit is case-ignorable.
  inspect(@ucd.lowercase("\u{10400}Σ"), content="\u{10428}ς")
  inspect(@ucd.lowercase("AΣ\u{10400}"), content="aσ\u{10428}")
  inspect(@ucd.lowercase("A\u{1D185}Σ"), content="a\u{1D185}ς")
  inspect(@ucd.lowercase("AΣ\u{1D185}A"), content="aσ\u{1D185}a")
  // Variation selector 17 exercises case-ignorable data in plane 14.
  inspect(@ucd.lowercase("A\u{E0100}Σ"), content="a\u{E0100}ς")
  inspect(@ucd.lowercase("AΣ\u{E0100}"), content="aς\u{E0100}")
  inspect(@ucd.lowercase("AΣ\u{E0100}A"), content="aσ\u{E0100}a")
  inspect(@ucd.lowercase("\u{E0100}Σ"), content="\u{E0100}σ")
}

///|
test "lowercase: sigma context stops at StringView boundaries" {
  inspect(@ucd.lowercase("ΑΣΑ"[1:2]), content="σ")
  inspect(@ucd.lowercase("ΑΣΑ"[:2]), content="ας")
  inspect(@ucd.lowercase("ΑΣΑ"[1:]), content="σα")
  inspect(@ucd.lowercase("😀ΟΣ😀"[2:4]), content="ος")
  inspect(@ucd.lowercase("A\u{0345}Σ"[1:]), content="\u{0345}σ")
  inspect(@ucd.lowercase("AΣ\u{0345}A"[:3]), content="aς\u{0345}")
}

///|
test "lowercase: unpaired surrogates are preserved and stop sigma context" {
  let leading = (0xD800).unsafe_to_char()
  let trailing = (0xDC00).unsafe_to_char()
  let first = String::from_array(['A', leading, 'Σ', 'A', 'Σ', trailing, 'A'])
  debug_inspect(
    @ucd.lowercase(first).code_units().iter().map(c => c.to_int()).collect(),
    content="[97, 55296, 963, 97, 962, 56320, 97]",
  )
  let second = String::from_array(['A', trailing, 'Σ', 'A', 'Σ', leading, 'A'])
  debug_inspect(
    @ucd.lowercase(second).code_units().iter().map(c => c.to_int()).collect(),
    content="[97, 56320, 963, 97, 962, 55296, 97]",
  )
}

///|
test "lowercase: split surrogate pairs do not extend the view's context" {
  // The trailing surrogate in the view must not combine with the leading
  // surrogate outside it to become a cased Deseret letter.
  let prefix = "\u{10400}Σ".unsafe_view(start=1, end=3)
  debug_inspect(
    @ucd.lowercase(prefix).code_units().iter().map(c => c.to_int()).collect(),
    content="[56320, 963]",
  )
  let suffix = "AΣ\u{10400}".unsafe_view(start=0, end=3)
  debug_inspect(
    @ucd.lowercase(suffix).code_units().iter().map(c => c.to_int()).collect(),
    content="[97, 962, 55297]",
  )
}
