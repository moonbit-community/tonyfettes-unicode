///|
/// Shared storage for the word and sentence cursors. Only segment ends are
/// retained after boundary analysis; slices keep the original backing text.
priv struct TextSegments {
  text : StringView
  ends : Array[Int32]
  mut index : Int32
  mut offset : Int32
}

///|
fn TextSegments::next(self : TextSegments) -> StringView {
  let start = self.offset
  if self.index < self.ends.length() {
    self.offset = self.ends[self.index]
    self.index += 1
  }
  // Cursor ends are raw UTF-16 offsets; retain split surrogate fixtures.
  guard! 0 <= start && start <= self.offset && self.offset <= self.text.length()
  self.text.unsafe_view(start~, end=self.offset)
}

///|
fn TextSegments::iter(self : TextSegments) -> Iter[StringView] {
  Iter::new(() => {
    let segment = self.next()
    if segment.is_empty() {
      None
    } else {
      Some(segment)
    }
  })
}

///|
/// One entry per decoded code point, with UTF-16 end offsets. Unpaired
/// surrogates have the unlisted (Other) property; valid pairs stay together.
priv struct TextBreakInput {
  points : Array[Int32]
  properties : Array[Int32]
  ends : Array[Int32]
}

///|
fn text_break_input(
  text : StringView,
  property : (Char) -> Int32,
) -> TextBreakInput {
  let points = []
  let properties = []
  let ends = []
  let mut offset = 0
  while offset < text.length() {
    let cp = code_point_at(text, offset, text.length())
    offset += if cp >= 0x10000 { 2 } else { 1 }
    points.push(cp)
    properties.push(
      if cp >= 0xD800 && cp <= 0xDFFF {
        0
      } else {
        property(cp.unsafe_to_char())
      },
    )
    ends.push(offset)
  }
  { points, properties, ends, }
}
