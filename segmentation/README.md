# unicode-segmentation

Unicode 18.0.0 text segmentation for MoonBit: extended grapheme clusters
(UAX #29) and default line break opportunities (UAX #14, revision 57).

```bash
moon add moonbit-community/unicode-segmentation
```

Import `"moonbit-community/unicode-segmentation" @segmentation` in `moon.pkg`.

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

```bash
moon test --target native segmentation tests/linebreak_tests tests/segmentation_tests
```

Specifications: [UAX #14](https://www.unicode.org/reports/tr14/tr14-57.html),
[UAX #29](https://www.unicode.org/reports/tr29/).
