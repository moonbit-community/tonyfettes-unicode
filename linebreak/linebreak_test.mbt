///|
test "allowed, mandatory, and end of text" {
  debug_inspect(
    @linebreak.line_breaks("Hello world!").iter().collect(),
    content="[(6, Allowed), (12, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("中文").iter().collect(),
    content="[(1, Allowed), (2, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("A\r\nB").iter().collect(),
    content="[(3, Mandatory), (4, Mandatory)]",
  )
  for
    newline in ["\r", "\n", "\u{85}", "\u{B}", "\u{C}", "\u{2028}", "\u{2029}"] {
    @debug.assert_eq(
      @linebreak.line_breaks("A" + newline + "B").iter().collect(),
      [(2, @linebreak.Mandatory), (3, @linebreak.Mandatory)],
    )
  }
  debug_inspect(
    @linebreak.line_breaks("A\n").iter().collect(),
    content="[(2, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("\n\n").iter().collect(),
    content="[(1, Mandatory), (2, Mandatory)]",
  )
}

///|
test "cursor exhaustion and shared iteration" {
  let empty = @linebreak.line_breaks("")
  assert_true(empty.next() is None)
  assert_true(empty.next() is None)
  assert_true(empty.iter().collect().is_empty())
  let cursor = @linebreak.line_breaks("A B C")
  debug_inspect(cursor.next(), content="Some((2, Allowed))")
  let remaining = []
  for point in cursor {
    remaining.push(point)
  }
  debug_inspect(remaining, content="[(4, Allowed), (5, Mandatory)]")
  assert_true(cursor.next() is None)
  assert_true(cursor.next() is None)
  assert_true(cursor.iter().collect().is_empty())
}

///|
test "UTF-16 offsets relative to an independent view" {
  let source = "x😀 中z"
  let text = source.view(start_offset=1, end_offset=5)
  debug_inspect(
    @linebreak.line_breaks(text).iter().collect(),
    content="[(3, Allowed), (4, Mandatory)]",
  )
  // A quote at the start of the view must not inherit the preceding CJK.
  let quoted = "中’中"
  debug_inspect(
    @linebreak.line_breaks(quoted.view(start_offset=1)).iter().collect(),
    content="[(2, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("🇺🇳🇨🇳").iter().collect(),
    content="[(4, Allowed), (8, Mandatory)]",
  )
}

///|
test "default rules do not impose grapheme boundaries or trim whitespace" {
  debug_inspect(
    @linebreak.line_breaks(" \u{0308}a").iter().collect(),
    content="[(1, Allowed), (3, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("a  b ").iter().collect(),
    content="[(3, Allowed), (5, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("a\u{A0}b").iter().collect(),
    content="[(3, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("a\u{200B}  b").iter().collect(),
    content="[(4, Allowed), (5, Mandatory)]",
  )
}

///|
test "unpaired surrogate halves resolve to alphabetic" {
  let text = "a😀b"
  debug_inspect(
    @linebreak.line_breaks(text.view(end_offset=2)).iter().collect(),
    content="[(2, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks(text.view(start_offset=2)).iter().collect(),
    content="[(2, Mandatory)]",
  )
  // A complete pair is an ideograph-like emoji instead of two alphabetics.
  debug_inspect(
    @linebreak.line_breaks(text).iter().collect(),
    content="[(1, Allowed), (3, Allowed), (4, Mandatory)]",
  )
}

///|
test "long contexts preserve combining, numeric, space and RI rules" {
  let marks = "\u{0308}".repeat(10000)
  @debug.assert_eq(@linebreak.line_breaks("a" + marks + "b").iter().collect(), [
    (10002, @linebreak.Mandatory),
  ])
  let punctuation = ",/".repeat(5000)
  @debug.assert_eq(
    @linebreak.line_breaks("1" + punctuation + "2$").iter().collect(),
    [(10003, @linebreak.Mandatory)],
  )
  let spaces = " ".repeat(10000)
  @debug.assert_eq(
    @linebreak.line_breaks("(" + spaces + "a").iter().collect(),
    [(10002, @linebreak.Mandatory)],
  )
  // Marks ignored by LB9 must not reset the significant RI count.
  let flags = "🇦\u{0308}".repeat(1001)
  let points = @linebreak.line_breaks(flags).iter().collect()
  assert_eq(points.length(), 501)
  for i in 0..<500 {
    @debug.assert_eq(points[i], ((i + 1) * 6, @linebreak.Allowed))
  }
  @debug.assert_eq(points[500], (3003, @linebreak.Mandatory))
}

///|
test "Unicode 18 hyphens and potential emoji" {
  // Unicode 18 changes LB12a: BA no longer permits a break before GL.
  debug_inspect(
    @linebreak.line_breaks("\u{2013}\u{A0}x").iter().collect(),
    content="[(3, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("\u{AD}\u{A0}x").iter().collect(),
    content="[(1, Allowed), (3, Mandatory)]",
  )
  debug_inspect(
    @linebreak.line_breaks("\u{1FC00}\u{1F3FB}").iter().collect(),
    content="[(4, Mandatory)]",
  )
}
