///|
test "word segments retain punctuation, spaces, and numeric context" {
  @debug.assert_eq(
    @segmentation.word_segments(
      "can't  3.14 foo_bar אב\"ג カタカナ\r\n中文",
    )
    .iter()
    .map(s => s.to_owned())
    .collect(),
    [
      "can't", "  ", "3.14", " ", "foo_bar", " ", "אב\"ג", " ", "カタカナ",
      "\r\n", "中", "文",
    ],
  )
}

///|
test "words filter by Alphabetic or Number and preserve complete segments" {
  @debug.assert_eq(
    @segmentation.words(
      "👩‍👩‍👧‍👦 -- can't 42 Ⅷ ² _ \u{301} e\u{301} 中文",
    )
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["can't", "42", "Ⅷ", "²", "e\u{301}", "中", "文"],
  )
  assert_true(@segmentation.words("!? 👩‍👧 🇺🇳").next().is_empty())
  @debug.assert_eq(
    @segmentation.words("1️⃣ #️⃣")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["1️⃣"],
  )
}

///|
test "word cursor exhaustion and interleaved iterators" {
  let cursor = @segmentation.word_segments("one two!")
  let iterator = cursor.iter()
  inspect(cursor.next(), content="one")
  @debug.assert_eq(iterator.next(), Some(" "))
  inspect(cursor.next(), content="two")
  @debug.assert_eq(iterator.next(), Some("!"))
  assert_true(cursor.next().is_empty())
  assert_true(cursor.next().is_empty())
  @debug.assert_eq(iterator.next(), None)
  let filtered = @segmentation.words("one two!")
  let iterator = filtered.iter()
  inspect(filtered.next(), content="one")
  @debug.assert_eq(iterator.next(), Some("two"))
  let end = filtered.next()
  assert_true(end.is_empty())
  assert_eq(end.start_offset(), 8)
  assert_true(filtered.next().is_empty())
  @debug.assert_eq(iterator.next(), None)
  let empty_segments = @segmentation.word_segments("")
  let empty_words = @segmentation.words("")
  assert_true(empty_segments.next().is_empty())
  assert_true(empty_segments.next().is_empty())
  assert_true(empty_words.next().is_empty())
  assert_true(empty_words.next().is_empty())
}

///|
test "word views retain UTF-16 offsets and use independent context" {
  let backing = "xa.b😀z"
  let text = backing.view(start_offset=2, end_offset=6)
  let cursor = @segmentation.word_segments(text)
  @debug.assert_eq(
    cursor
    .iter()
    .map(s => (s.to_owned(), s.start_offset(), s.length()))
    .collect(),
    [(".", 2, 1), ("b", 3, 1), ("😀", 4, 2)],
  )
  assert_eq(cursor.next().start_offset(), 6)
  let flags = "🇦🇧🇨🇩🇪"
  @debug.assert_eq(
    @segmentation.word_segments(flags.view(start_offset=2))
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["🇧🇨", "🇩🇪"],
  )
}

///|
test "word ignored characters and RI pairing keep the required context" {
  @debug.assert_eq(
    @segmentation.word_segments("\u{301}a\r\n\u{301}b a\u{301}'\u{301}b")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["\u{301}", "a", "\r\n", "\u{301}", "b", " ", "a\u{301}'\u{301}b"],
  )
  @debug.assert_eq(
    @segmentation.word_segments("🇦\u{301}🇧🇨\u{301}🇩🇪")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["🇦\u{301}🇧", "🇨\u{301}🇩", "🇪"],
  )
  // WB3d is before WB4: marks between spaces prevent their grouping.
  @debug.assert_eq(
    @segmentation.word_segments(" \u{301} ")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    [" \u{301}", " "],
  )
}

///|
test "word boundaries can split an extended grapheme" {
  let text = "\u{6DD} "
  assert_eq(@segmentation.graphemes(text).iter().count(), 1)
  @debug.assert_eq(
    @segmentation.word_segments(text).iter().map(s => s.to_owned()).collect(),
    ["\u{6DD}", " "],
  )
}

///|
test "word cursors preserve unpaired surrogates" {
  let text = "a😀\u{301}b"
  let leading = text.view(end_offset=2)
  @debug.assert_eq(
    @segmentation.word_segments(leading).iter().map(s => s.length()).collect(),
    [1, 1],
  )
  let trailing = text.view(start_offset=2)
  @debug.assert_eq(
    @segmentation.word_segments(trailing).iter().map(s => s.length()).collect(),
    [2, 1],
  )
  @debug.assert_eq(
    @segmentation.words(trailing).iter().map(s => s.to_owned()).collect(),
    ["b"],
  )
}

///|
test "long ignored runs do not change word punctuation lookaround" {
  let marks = "\u{301}".repeat(20000)
  let text = "a" + marks + "'" + marks + "b"
  let cursor = @segmentation.word_segments(text)
  assert_eq(cursor.next().length(), text.length())
  assert_true(cursor.next().is_empty())
}
