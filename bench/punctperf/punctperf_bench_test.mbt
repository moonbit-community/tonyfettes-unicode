///|
/// One code point per 97 scalar values, which keeps the sample across all
/// planes and gives a realistic mix of punctuation and non-punctuation.
fn corpus() -> Array[Char] {
  let chars : Array[Char] = []
  for cp in 0..<=0x10FFFF {
    if cp % 97 == 0 {
      chars.push(cp.unsafe_to_char())
    }
  }
  chars
}

///|
test "punctuation predicate vs general category" (b : @bench.T) {
  let cases : Array[(String, Char)] = [
    ("ascii-punct", '!'),
    ("ascii-letter", 'A'),
    ("ascii-digit", '0'),
    ("space", ' '),
    ("cjk-punct", '\u{3002}'),
    ("cjk-letter", '\u{4E2D}'),
    ("combining-mark", '\u{0301}'),
    ("emoji", '\u{1F600}'),
  ]
  for (label, char) in cases {
    let mut c = char
    b.bench(name="is_punctuation/\{label}", fn() {
      c = char
      b.keep(@unicode.is_punctuation(c))
    })
    b.bench(name="general_category/\{label}", fn() {
      c = char
      b.keep(
        @unicode.general_category(c).group() is @unicode.GeneralCategoryGroup::P,
      )
    })
  }
  let chars = corpus()
  b.bench(name="is_punctuation/corpus-\{chars.length()}", fn() {
    let mut found = 0
    for c in chars {
      if @unicode.is_punctuation(c) {
        found += 1
      }
    }
    b.keep(found)
  })
  b.bench(name="general_category/corpus-\{chars.length()}", fn() {
    let mut found = 0
    for c in chars {
      if @unicode.general_category(c).group()
        is @unicode.GeneralCategoryGroup::P {
        found += 1
      }
    }
    b.keep(found)
  })
}
