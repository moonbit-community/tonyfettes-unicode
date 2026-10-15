///|
fn grapheme_breaks(
  text : StringView,
) -> Array[(String, @segmentation.BreakOpportunity)] {
  let cursor = @segmentation.graphemes(text)
  let results = []
  for cluster in cursor {
    results.push((cluster.to_owned(), cursor.line_break()))
  }
  results
}

///|
test "grapheme line break kinds" {
  debug_inspect(
    grapheme_breaks("ab cd\n"),
    content=(
      #|[
      #|  ("a", Prohibited),
      #|  ("b", Prohibited),
      #|  (" ", Allowed),
      #|  ("c", Prohibited),
      #|  ("d", Prohibited),
      #|  ("\n", Mandatory),
      #|]
    ),
  )
  debug_inspect(
    grapheme_breaks("中文"),
    content="[(\"中\", Allowed), (\"文\", Mandatory)]",
  )
  debug_inspect(
    grapheme_breaks("A\r\nB"),
    content=(
      #|[("A", Prohibited), ("\r\n", Mandatory), ("B", Mandatory)]
    ),
  )
  for
    newline in ["\r", "\n", "\u{85}", "\u{B}", "\u{C}", "\u{2028}", "\u{2029}"] {
    @debug.assert_eq(grapheme_breaks("A" + newline + "B"), [
      ("A", @segmentation.Prohibited),
      (newline, @segmentation.Mandatory),
      ("B", @segmentation.Mandatory),
    ])
  }
}

///|
test "grapheme line break query does not advance and survives exhaustion" {
  let empty = @segmentation.graphemes("")
  debug_inspect(empty.line_break(), content="Prohibited")
  assert_true(empty.next().is_empty())
  debug_inspect(empty.line_break(), content="Prohibited")
  let cursor = @segmentation.graphemes("a b")
  debug_inspect(cursor.line_break(), content="Prohibited")
  inspect(cursor.next(), content="a")
  debug_inspect(cursor.line_break(), content="Prohibited")
  debug_inspect(cursor.line_break(), content="Prohibited")
  let iterator = cursor.iter()
  debug_inspect(
    iterator.next(),
    content=(
      #|Some(<StringView: " ">)
    ),
  )
  debug_inspect(cursor.line_break(), content="Allowed")
  debug_inspect(cursor.line_break(), content="Allowed")
  inspect(cursor.next(), content="b")
  debug_inspect(cursor.line_break(), content="Mandatory")
  assert_true(iterator.next() is None)
  assert_true(cursor.next().is_empty())
  assert_true(cursor.next().is_empty())
  debug_inspect(cursor.line_break(), content="Mandatory")
}

///|
test "line break queries can start late or skip clusters" {
  let cursor = @segmentation.graphemes("a b c")
  inspect(cursor.next(), content="a")
  inspect(cursor.next(), content=" ")
  debug_inspect(cursor.line_break(), content="Allowed")
  inspect(cursor.next(), content="b")
  inspect(cursor.next(), content=" ")
  debug_inspect(cursor.line_break(), content="Allowed")
  inspect(cursor.next(), content="c")
  debug_inspect(cursor.line_break(), content="Mandatory")
  let late = @segmentation.graphemes("x")
  assert_eq(late.iter().count(), 1)
  assert_true(late.next().is_empty())
  debug_inspect(late.line_break(), content="Mandatory")
}

///|
test "grapheme line breaking preserves whole clusters and default rule context" {
  // UAX #14 allows a break after SPACE inside the first UAX #29 cluster.
  // That opportunity is suppressed, not moved to the cluster's end.
  debug_inspect(
    grapheme_breaks(" \u{0308}a"),
    content="[(\" ̈\", Prohibited), (\"a\", Mandatory)]",
  )
  debug_inspect(
    grapheme_breaks("e\u{0301}x"),
    content="[(\"é\", Prohibited), (\"x\", Mandatory)]",
  )
  debug_inspect(
    grapheme_breaks("🇺🇳🇨🇳"),
    content="[(\"🇺🇳\", Allowed), (\"🇨🇳\", Mandatory)]",
  )
  debug_inspect(
    grapheme_breaks("👨‍👩‍👧x"),
    content="[(\"👨‍👩‍👧\", Allowed), (\"x\", Mandatory)]",
  )
}

///|
test "grapheme line breaking uses independent UTF-16 views" {
  let source = "x😀 中z"
  let text = source.view(start_offset=1, end_offset=5)
  debug_inspect(
    grapheme_breaks(text),
    content="[(\"😀\", Prohibited), (\" \", Allowed), (\"中\", Mandatory)]",
  )
  let quoted = "中’中"
  debug_inspect(
    grapheme_breaks(quoted.view(start_offset=1)),
    content="[(\"’\", Prohibited), (\"中\", Mandatory)]",
  )
  let pair = "😀"
  for half in [pair.view(end_offset=1), pair.view(start_offset=1)] {
    let cursor = @segmentation.graphemes(half)
    let cluster = cursor.next()
    assert_eq(cluster.start_offset(), half.start_offset())
    assert_eq(cluster.length(), 1)
    debug_inspect(cursor.line_break(), content="Mandatory")
    assert_true(cursor.next().is_empty())
  }
}
