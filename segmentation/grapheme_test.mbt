///|
/// Describe each cluster by its code points, so that the expected output
/// stays readable for combining marks, controls, and emoji sequences.
fn cluster_code_points(text : StringView) -> Array[Array[String]] {
  @segmentation.graphemes(text)
  .map(cluster => {
    cluster
    .iter()
    .map(character => "U+" + character.to_int().to_string(radix=16).to_upper())
    .collect()
  })
  .collect()
}

///|
test "empty text has no clusters" {
  debug_inspect(
    cluster_code_points(""),
    content=(
      #|[]
    ),
  )
}

///|
test "ASCII breaks between every character" {
  debug_inspect(
    cluster_code_points("ab 1"),
    content=(
      #|[["U+61"], ["U+62"], ["U+20"], ["U+31"]]
    ),
  )
}

///|
test "CR LF is one cluster and controls stand alone" {
  debug_inspect(
    cluster_code_points("a\r\nb\n\r\u{0}\u{301}"),
    content=(
      #|[
      #|  ["U+61"],
      #|  ["U+D", "U+A"],
      #|  ["U+62"],
      #|  ["U+A"],
      #|  ["U+D"],
      #|  ["U+0"],
      #|  ["U+301"],
      #|]
    ),
  )
}

///|
test "combining marks and spacing marks extend the base" {
  debug_inspect(
    cluster_code_points("e\u{301}\u{323}o\u{308}\u{0915}\u{093E}"),
    content=(
      #|[["U+65", "U+301", "U+323"], ["U+6F", "U+308"], ["U+915", "U+93E"]]
    ),
  )
}

///|
test "prepend characters attach to the following character" {
  debug_inspect(
    cluster_code_points("\u{0600}1\u{0600}\n"),
    content=(
      #|[["U+600", "U+31"], ["U+600"], ["U+A"]]
    ),
  )
}

///|
test "Hangul syllable sequences" {
  // L V T jamo, a precomposed LV syllable followed by T, and LVT followed
  // by V, which starts a new cluster.
  debug_inspect(
    cluster_code_points(
      "\u{1100}\u{1161}\u{11A8}\u{AC00}\u{11A8}\u{AC01}\u{1161}",
    ),
    content=(
      #|[
      #|  ["U+1100", "U+1161", "U+11A8"],
      #|  ["U+AC00", "U+11A8"],
      #|  ["U+AC01"],
      #|  ["U+1161"],
      #|]
    ),
  )
}

///|
test "regional indicators pair up from the start of a run" {
  debug_inspect(
    cluster_code_points("🇺🇳🇨🇳🇯a🇯🇵"),
    content=(
      #|[
      #|  ["U+1F1FA", "U+1F1F3"],
      #|  ["U+1F1E8", "U+1F1F3"],
      #|  ["U+1F1EF"],
      #|  ["U+61"],
      #|  ["U+1F1EF", "U+1F1F5"],
      #|]
    ),
  )
}

///|
test "emoji modifier and ZWJ sequences" {
  debug_inspect(
    cluster_code_points("👍🏽👨‍👩‍👧❤️‍🔥"),
    content=(
      #|[
      #|  ["U+1F44D", "U+1F3FD"],
      #|  ["U+1F468", "U+200D", "U+1F469", "U+200D", "U+1F467"],
      #|  ["U+2764", "U+FE0F", "U+200D", "U+1F525"],
      #|]
    ),
  )
}

///|
test "ZWJ joins only after an extended pictographic" {
  debug_inspect(
    cluster_code_points("a\u{200D}👧👨\u{200D}a"),
    content=(
      #|[["U+61", "U+200D"], ["U+1F467"], ["U+1F468", "U+200D"], ["U+61"]]
    ),
  )
}

///|
test "Indic conjuncts stay together across a linker" {
  // KA VIRAMA SSA is one conjunct; without the virama they are separate.
  debug_inspect(
    cluster_code_points("\u{0915}\u{094D}\u{0937}\u{0915}\u{0937}"),
    content=(
      #|[["U+915", "U+94D", "U+937"], ["U+915"], ["U+937"]]
    ),
  )
  // Extenders around the linker, including ZWJ, keep the conjunct open.
  debug_inspect(
    cluster_code_points("\u{0915}\u{093C}\u{094D}\u{200D}\u{0937}"),
    content=(
      #|[["U+915", "U+93C", "U+94D", "U+200D", "U+937"]]
    ),
  )
}

///|
test "clusters are views into the input" {
  let text = "xe\u{301}🇺🇳y"
  let offsets = @segmentation.graphemes(text[1:])
    .map(cluster => (cluster.start_offset(), cluster.length()))
    .collect()
  debug_inspect(
    offsets,
    content=(
      #|[(1, 2), (3, 4), (7, 1)]
    ),
  )
}

///|
test "unpaired surrogates behave like ordinary characters" {
  // Slicing by code unit offsets can split a surrogate pair. Each half is a
  // base character of its own, so the low half takes the combining mark.
  let text = "a😀\u{301}"
  debug_inspect(
    @segmentation.graphemes(text.view(start_offset=0, end_offset=2))
    .map(cluster => cluster.length())
    .collect(),
    content=(
      #|[1, 1]
    ),
  )
  debug_inspect(
    @segmentation.graphemes(text.view(start_offset=2))
    .map(cluster => cluster.length())
    .collect(),
    content=(
      #|[2]
    ),
  )
}

///|
test "iteration is lazy" {
  let clusters = @segmentation.graphemes("e\u{301}abc")
  debug_inspect(
    clusters.next().map(cluster => cluster.to_owned()),
    content=(
      #|Some("é")
    ),
  )
  debug_inspect(
    clusters.next().map(cluster => cluster.to_owned()),
    content=(
      #|Some("a")
    ),
  )
}
