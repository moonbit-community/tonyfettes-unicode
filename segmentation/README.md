# unicode-segmentation

Unicode 18.0.0 text segmentation for MoonBit: extended grapheme clusters,
word and sentence boundaries (UAX #29), and default line break opportunities
(UAX #14, revision 57).

```bash
moon add moonbit-community/unicode-segmentation
```

Import `"moonbit-community/unicode-segmentation" @segmentation` in `moon.pkg`.

## Words and sentences

```moonbit
for segment in @segmentation.word_segments("Hello, world! 42") {
  // "Hello", ",", " ", "world", "!", " ", "42"
}
for word in @segmentation.words("Hello, world! 42") {
  // "Hello", "world", "42"
}
for sentence in @segmentation.sentences("Hello! Next.") {
  // "Hello! ", "Next."
}
```

| Entry point | Cursor | Contents |
| --- | --- | --- |
| `word_segments(StringView)` | `WordSegments` | All default UAX #29 word segments, including whitespace and punctuation. |
| `words(StringView)` | `Words` | Word segments containing at least one Unicode `Alphabetic` character or `General_Category=Number` character (`Nd`, `Nl`, or `No`). |
| `sentences(StringView)` | `Sentences` | All default UAX #29 sentence segments, retaining closing punctuation, trailing whitespace, and paragraph separators as specified by the rules. |

Each opaque cursor provides `next() -> StringView` and
`iter() -> Iter[StringView]`. Both consume the same cursor and can be
interleaved. `next()` returns an empty view at the input's end on every call
after exhaustion; empty input produces no segments. Returned views retain
UTF-16 offsets in the backing string and do not copy the text.

`word_segments` and `sentences` cover the input exactly. `words` filters whole
segments, so it retains internal punctuation in words such as `can't` and
numbers such as `3.14`, while omitting punctuation, whitespace, and emoji
segments without Alphabetic or Number characters. A digit keycap such as
`1️⃣` is retained because it contains a digit. This filter is a convenience
policy, not a linguistic test for whether a segment is a dictionary word.

The input view is segmented independently of surrounding text. Valid
surrogate pairs stay together; unpaired surrogates use the default `Other`
property. Word and sentence rules are evaluated independently of grapheme
segmentation; their boundaries are not forced to cluster ends.

Construction takes O(n) time and space to prepare boundary context and store
segment ends. Complete traversal takes O(n) time; `words` additionally scans
each segment to apply its filter, still in O(n) total time. No locale
tailoring, abbreviation dictionary, or dictionary-based word segmentation
is applied. In particular, default word boundaries do not provide linguistic
Chinese or Thai word recognition.

All 1,944 `WordBreakTest.txt` and 512 `SentenceBreakTest.txt` cases from
Unicode 18.0.0 run directly from `tests/data/` in `tests/segmentation_tests`.

## Graphemes with line break information

```moonbit
let graphemes = @segmentation.graphemes("ab c")
for grapheme in graphemes {
  let opportunity = graphemes.line_break()
  // "a" -> Prohibited, "b" -> Prohibited,
  // " " -> Allowed, "c" -> Mandatory
}
```

`graphemes(StringView) -> Graphemes` creates a forward cursor over extended
grapheme clusters. `next() -> StringView` returns an empty view at exhaustion;
`iter() -> Iter[StringView]` consumes the same cursor.

`Graphemes::line_break() -> BreakOpportunity` queries the boundary after the
last returned cluster. The first query after a cluster prepares line breaking
context for the whole input in O(n) time and space. Subsequent queries scan
forward in O(n) total time over the traversal. Querying repeatedly does not
advance the grapheme cursor, and queries may be skipped between clusters.
Traversal without this query does not run the line breaking algorithm.

The query exposes only opportunities at complete cluster ends. Default UAX
#14 can allow a break inside a cluster, for example between SPACE and a
combining mark. Such opportunities are not exposed or moved to the end of
the cluster. Grapheme segmentation and the default line breaking rules remain
independent; this is not the per-cluster class tailoring from UAX #14 §8.

## Independent line break cursor

```moonbit
let breaks = @segmentation.line_breaks("Hello world!")
for segment in breaks {
  let opportunity = breaks.opportunity()
  // "Hello " -> Allowed, "world!" -> Mandatory
}
```

`line_breaks(StringView) -> LineBreaks` exposes all default UAX #14
opportunities. `next() -> StringView` and `iter() -> Iter[StringView]` consume
the same cursor. `opportunity() -> BreakOpportunity` reports the boundary at
the end of the most recently returned nonempty segment. Query the kind while
processing that segment; collecting the views does not retain their kinds.

- Segments are contiguous views covering the input exactly, retaining spaces
  and newline characters. They may end inside a grapheme cluster.
- Views retain UTF-16 offsets in their backing string. The supplied input view
  is processed independently of surrounding text.
- Empty input produces no segments. Exhausted cursors keep returning an empty
  view at the end of the input.
- Construction takes O(n) time and space to prepare character context.
  Iteration scans that context once without copying the text.
- Valid surrogate pairs stay together. Unpaired surrogates use `SG -> AL`.

## Break kinds and cursor state

`BreakOpportunity` has `Prohibited`, `Allowed`, and `Mandatory` variants.
Before the first result (including empty input), both cursors' break queries
return `Prohibited`. After a nonempty result they describe its trailing
boundary. Exhaustion preserves the last kind. Nonempty input ends with
`Mandatory`, even without a newline; this does not insert an extra empty line.
Every nonempty `LineBreaks` segment ends with `Allowed` or `Mandatory`.

The algorithm applies no locale tailoring or dictionary segmentation. It
finds legal opportunities; selecting actual lines based on font measurements
and available width is the caller's job. The separate
`unicode-data.line_break(Char)` query still returns the original UCD property;
LB1 resolution happens only within the algorithm.

All 19,346 cases in the official Unicode 18.0.0 `LineBreakTest.txt` run in the
workspace-only `tests/linebreak_tests` package. The same cases also check the
combined grapheme cursor against the opportunities at its cluster ends.
The existing `GraphemeBreakTest.txt` suite checks UAX #29 independently.

Stateless boundary queries are deferred. The repository's
[boundary API design note](../docs/plans/2026-10-16-segmentation-boundary-api.md)
records the proposed signatures, context requirements, and representation
experiments for future work.

```bash
moon test --target native segmentation tests/linebreak_tests tests/segmentation_tests
```

Specifications: [UAX #14](https://www.unicode.org/reports/tr14/tr14-57.html),
[UAX #29](https://www.unicode.org/reports/tr29/).
