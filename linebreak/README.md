# unicode-linebreak

Default Unicode 18.0.0 line breaking (UAX #14, revision 57) for MoonBit.

```bash
moon add moonbit-community/unicode-linebreak
```

Import `"moonbit-community/unicode-linebreak" @linebreak` in `moon.pkg`.

```moonbit
let breaks = @linebreak.line_breaks("Hello world!")
// breaks.next() -> Some((6, Allowed))
// breaks.next() -> Some((12, Mandatory))
// breaks.next() -> None

for point in breaks {
  let (offset, opportunity) = point
  // Choose among Allowed positions using your layout width.
  // Mandatory positions must end the line.
}
```

`line_breaks(StringView) -> LineBreaks` creates a forward cursor. Its
`next() -> (Int, BreakOpportunity)?` and
`iter() -> Iter[(Int, BreakOpportunity)]` consume the same remaining results.
`BreakOpportunity` has `Allowed` and `Mandatory` variants.

- Offsets count UTF-16 code units relative to the supplied view, immediately
  after the preceding text. Spaces and newline characters are retained.
- The view is processed independently of surrounding text in its backing string.
- No leading zero is returned. Nonempty input ends with one `Mandatory` at its
  length, even without a newline. Empty input produces no results. Exhausted
  cursors keep returning `None`.
- Valid surrogate pairs stay together. Unpaired surrogates use the default
  `SG -> AL` resolution.
- Construction takes O(n) time and space to prepare character context.
  Iteration scans that context once; it does not copy the text.

The algorithm implements the default rules without locale tailoring or
dictionary segmentation. It finds legal break opportunities; choosing actual
lines based on font measurements and available width is the caller's job.
Default UAX #14 boundaries are not necessarily grapheme cluster boundaries.

The separate `unicode-data.line_break(Char)` query continues to return the
original UCD property. LB1 normalization happens only inside this algorithm.

All 19,346 cases in Unicode 18.0.0 `LineBreakTest.txt` run in the workspace-only
`tests/linebreak_tests` package. Additional module tests cover break kinds,
cursor semantics, UTF-16 views, surrogate halves, and long contexts.

```bash
moon test --target native linebreak tests/linebreak_tests
```

Specification: <https://www.unicode.org/reports/tr14/tr14-57.html>
