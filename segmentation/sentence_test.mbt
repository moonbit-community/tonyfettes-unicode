///|
test "sentences retain closing punctuation, spaces, and paragraph separators" {
  @debug.assert_eq(
    @segmentation.sentences("Hello!  \"Next.\"\r\n第三句。尾巴")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["Hello!  ", "\"Next.\"\r\n", "第三句。", "尾巴"],
  )
  @debug.assert_eq(
    @segmentation.sentences("\r\n\n\u{2029}tail")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["\r\n", "\n", "\u{2029}", "tail"],
  )
}

///|
test "sentence full stops use numeric, abbreviation, and lowercase context" {
  @debug.assert_eq(
    @segmentation.sentences("3.14 is pi. U.S.A. is here. Next!")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["3.14 is pi. ", "U.S.A. is here. ", "Next!"],
  )
  @debug.assert_eq(
    @segmentation.sentences("Go.)  'again! Yes?! No")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["Go.)  'again! ", "Yes?! ", "No"],
  )
}

///|
test "sentence cursor exhaustion and shared iteration" {
  let cursor = @segmentation.sentences("One! Two? Three.")
  let iterator = cursor.iter()
  inspect(cursor.next(), content="One! ")
  @debug.assert_eq(iterator.next(), Some("Two? "))
  inspect(cursor.next(), content="Three.")
  assert_true(cursor.next().is_empty())
  assert_true(cursor.next().is_empty())
  @debug.assert_eq(iterator.next(), None)
  assert_eq(cursor.next().start_offset(), 16)
  let empty = @segmentation.sentences("")
  assert_true(empty.next().is_empty())
  assert_true(empty.next().is_empty())
  assert_true(empty.iter().collect().is_empty())
  @debug.assert_eq(
    @segmentation.sentences("   ").iter().map(s => s.to_owned()).collect(),
    ["   "],
  )
}

///|
test "sentence views retain offsets and do not read preceding punctuation" {
  let backing = "Done!   Next.😀"
  let text = backing.view(start_offset=6)
  let cursor = @segmentation.sentences(text)
  @debug.assert_eq(
    cursor.iter().map(s => (s.to_owned(), s.start_offset())).collect(),
    [("  Next.", 6), ("😀", 13)],
  )
  assert_eq(cursor.next().start_offset(), backing.length())
}

///|
test "sentence ignore exceptions and non-nested word boundaries" {
  @debug.assert_eq(
    @segmentation.sentences("A!\u{301} B\r\u{301}C")
    .iter()
    .map(s => s.to_owned())
    .collect(),
    ["A!\u{301} ", "B\r", "\u{301}C"],
  )
  let text = "1\u{589}2"
  assert_eq(@segmentation.word_segments(text).iter().count(), 1)
  @debug.assert_eq(
    @segmentation.sentences(text).iter().map(s => s.to_owned()).collect(),
    ["1\u{589}", "2"],
  )
}

///|
test "sentence cursors preserve unpaired surrogates" {
  let text = "😀!😀"
  let view = text.view(start_offset=1, end_offset=4)
  @debug.assert_eq(
    @segmentation.sentences(view)
    .iter()
    .map(s => (s.start_offset(), s.length()))
    .collect(),
    [(1, 2), (3, 1)],
  )
}

///|
test "long sentence suffixes and lowercase lookahead" {
  let closers = ")".repeat(20000)
  let spaces = " ".repeat(20000)
  let text = "A." + closers + spaces + "lower"
  let cursor = @segmentation.sentences(text)
  assert_eq(cursor.next().length(), text.length())
  assert_true(cursor.next().is_empty())
}
