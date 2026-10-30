///|
fn line_break_points(
  text : StringView,
) -> Array[(Int32, @segmentation.BreakOpportunity)] {
  let cursor = @segmentation.line_breaks(text)
  let points = []
  for segment in cursor {
    points.push(
      (
        segment.start_offset() - text.start_offset() + segment.length(),
        cursor.opportunity(),
      ),
    )
  }
  points
}

///|
test "allowed, mandatory, and end of text" {
  debug_inspect(
    line_break_points("Hello world!"),
    content="[(6, Allowed), (12, Mandatory)]",
  )
  debug_inspect(
    line_break_points("中文"),
    content="[(1, Allowed), (2, Mandatory)]",
  )
  debug_inspect(
    line_break_points("A\r\nB"),
    content="[(3, Mandatory), (4, Mandatory)]",
  )
  for
    newline in ["\r", "\n", "\u{85}", "\u{B}", "\u{C}", "\u{2028}", "\u{2029}"] {
    @debug.assert_eq(line_break_points("A" + newline + "B"), [
      (2, @segmentation.Mandatory),
      (3, @segmentation.Mandatory),
    ])
  }
  debug_inspect(line_break_points("A\n"), content="[(2, Mandatory)]")
  debug_inspect(
    line_break_points("\n\n"),
    content="[(1, Mandatory), (2, Mandatory)]",
  )
}

///|
test "cursor exhaustion and shared iteration" {
  let empty = @segmentation.line_breaks("")
  debug_inspect(empty.opportunity(), content="Prohibited")
  assert_true(empty.next().is_empty())
  assert_true(empty.next().is_empty())
  assert_true(empty.iter().collect().is_empty())
  debug_inspect(empty.opportunity(), content="Prohibited")
  let cursor = @segmentation.line_breaks("A B C")
  debug_inspect(cursor.opportunity(), content="Prohibited")
  inspect(cursor.next(), content="A ")
  debug_inspect(cursor.opportunity(), content="Allowed")
  debug_inspect(cursor.opportunity(), content="Allowed")
  let remaining = []
  for segment in cursor {
    remaining.push((segment.to_owned(), cursor.opportunity()))
  }
  debug_inspect(remaining, content="[(\"B \", Allowed), (\"C\", Mandatory)]")
  assert_true(cursor.next().is_empty())
  assert_true(cursor.next().is_empty())
  assert_true(cursor.iter().collect().is_empty())
  debug_inspect(cursor.opportunity(), content="Mandatory")
}

///|
test "UTF-16 offsets relative to an independent view" {
  let source = "x😀 中z"
  let text = source.unsafe_view(start=1, end=5)
  let cursor = @segmentation.line_breaks(text)
  let first = cursor.next()
  inspect(first, content="😀 ")
  assert_eq(first.start_offset(), 1)
  assert_eq(first.length(), 3)
  debug_inspect(cursor.opportunity(), content="Allowed")
  let second = cursor.next()
  inspect(second, content="中")
  assert_eq(second.start_offset(), 4)
  debug_inspect(cursor.opportunity(), content="Mandatory")
  let end = cursor.next()
  assert_true(end.is_empty())
  assert_eq(end.start_offset(), 5)
  debug_inspect(
    line_break_points(text),
    content="[(3, Allowed), (4, Mandatory)]",
  )
  // A quote at the start of the view must not inherit the preceding CJK.
  let quoted = "中’中"
  debug_inspect(
    line_break_points(quoted.unsafe_view(start=1, end=quoted.length())),
    content="[(2, Mandatory)]",
  )
  debug_inspect(
    line_break_points("🇺🇳🇨🇳"),
    content="[(4, Allowed), (8, Mandatory)]",
  )
}

///|
test "default rules do not impose grapheme boundaries or trim whitespace" {
  debug_inspect(
    line_break_points(" \u{0308}a"),
    content="[(1, Allowed), (3, Mandatory)]",
  )
  debug_inspect(
    line_break_points("a  b "),
    content="[(3, Allowed), (5, Mandatory)]",
  )
  debug_inspect(line_break_points("a\u{A0}b"), content="[(3, Mandatory)]")
  debug_inspect(
    line_break_points("a\u{200B}  b"),
    content="[(4, Allowed), (5, Mandatory)]",
  )
}

///|
test "unpaired surrogate halves resolve to alphabetic" {
  let text = "a😀b"
  debug_inspect(
    line_break_points(text.unsafe_view(start=0, end=2)),
    content="[(2, Mandatory)]",
  )
  debug_inspect(
    line_break_points(text.unsafe_view(start=2, end=text.length())),
    content="[(2, Mandatory)]",
  )
  // A complete pair is an ideograph-like emoji instead of two alphabetics.
  debug_inspect(
    line_break_points(text),
    content="[(1, Allowed), (3, Allowed), (4, Mandatory)]",
  )
}

///|
test "long contexts preserve combining, numeric, space and RI rules" {
  let marks = "\u{0308}".repeat(10000)
  @debug.assert_eq(line_break_points("a" + marks + "b"), [
    (10002, @segmentation.Mandatory),
  ])
  let punctuation = ",/".repeat(5000)
  @debug.assert_eq(line_break_points("1" + punctuation + "2$"), [
    (10003, @segmentation.Mandatory),
  ])
  let spaces = " ".repeat(10000)
  @debug.assert_eq(line_break_points("(" + spaces + "a"), [
    (10002, @segmentation.Mandatory),
  ])
  // Marks ignored by LB9 must not reset the significant RI count.
  let flags = "🇦\u{0308}".repeat(1001)
  let points = line_break_points(flags)
  assert_eq(points.length(), 501)
  for i in 0..<500 {
    @debug.assert_eq(points[i], ((i + 1) * 6, @segmentation.Allowed))
  }
  @debug.assert_eq(points[500], (3003, @segmentation.Mandatory))
}

///|
test "Unicode 18 hyphens and potential emoji" {
  // Unicode 18 changes LB12a: BA no longer permits a break before GL.
  debug_inspect(
    line_break_points("\u{2013}\u{A0}x"),
    content="[(3, Mandatory)]",
  )
  debug_inspect(
    line_break_points("\u{AD}\u{A0}x"),
    content="[(1, Allowed), (3, Mandatory)]",
  )
  debug_inspect(
    line_break_points("\u{1FC00}\u{1F3FB}"),
    content="[(4, Mandatory)]",
  )
}
