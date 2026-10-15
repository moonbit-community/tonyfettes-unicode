# Segmentation boundary queries

Status: deferred on 2026-10-16. This is a design record, not a published API
contract or a commitment to implement these interfaces.

## Decision

Do not expose stateless `next_*` boundary queries yet. Remove the experimental
`next_line_break` function and its `LineBreakOffset` result type. Keep the
existing `graphemes`, `word_segments`, `words`, `sentences`, and `line_breaks`
cursors unchanged. Internal boundary helpers are not public APIs and remain.

The main unresolved issue is efficient recovery of context at arbitrary
positions. A query must not unconditionally preprocess the whole input just
to find a nearby boundary. A stateful break iterator and streaming support
remain possible future work.

## Proposed interface and semantics

The explored signatures were:

```text
next_grapheme_boundary(StringView, offset~ : Int) -> Int
next_word_boundary(StringView, offset~ : Int) -> Int
next_sentence_boundary(StringView, offset~ : Int) -> Int
next_line_break(StringView, offset~ : Int) -> LineBreakOffset?
```

For line breaking, the preferred result was an ordinary enum:

```moonbit
pub(all) enum LineBreakOffset {
  Allowed(Int)
  Mandatory(Int)
}
```

- All offsets are UTF-16 code unit offsets relative to the supplied view,
  rather than code point ordinals or indices in its backing string.
- Search strictly after `offset`, using the entire view as context.
- The starting offset may be inside a segment or a valid surrogate pair.
  Returned boundaries must not split a valid pair.
- The view is independent of surrounding text in its backing string.
- For line breaks, reaching the end from an earlier position yields
  `Some(Mandatory(length))`; querying at or beyond the end yields `None`.
  Empty input yields `None`.
- The experimental implementation treated negative offsets as zero.
  Reconsider out-of-range handling before publishing the API.
- For the other three queries, returning `length` again at exhaustion was
  discussed, but their final return and exhaustion conventions are not settled.

For example, `"ab cd"` would produce `Some(Allowed(3))` from offset 0,
`Some(Mandatory(5))` from offset 3, and `None` from offset 5.

`BreakOpportunity::Prohibited` remains meaningful when querying a particular
position, such as a grapheme end. It is not a found result for a function that
searches for the next allowed or mandatory opportunity. Using a payload-free
`Prohibited` variant to mean exhaustion was considered, but conflates these
two meanings. `LineBreakOffset?` separates absence from the kind of a boundary.

Separate `next_allowed_line_break` and `next_mandatory_line_break` functions
were also considered. The former would need to include mandatory positions;
otherwise it could skip a required break. Returning the kind together with
the position avoids a second query to classify the result.

## Why arbitrary offsets need context

The search offset is not the beginning of the segmentation context. Slicing
away the prefix and segmenting the suffix independently can change results.
For example, `can't` has no word boundary after the apostrophe, whereas the
independent suffix `'t` does. WB7 needs the preceding letter.

There is no universal fixed number of code points that suffices for lookbehind
when starting at an arbitrary position without cached state:

- UAX #14 LB14 has `OP SP* ×`. In `(` followed by an arbitrarily long space
  run and then `a`, the opening punctuation suppresses the break before `a`.
  Replacing the `(` with `x` allows that break. A fixed local window near `a`
  cannot distinguish these inputs.
- UAX #14 LB30a uses the parity of the preceding consecutive regional
  indicators. That run can be arbitrarily long. UAX #29 grapheme rules
  GB12/GB13 and word rules WB15/WB16 have the same pairing issue.

Unbounded context distance does not imply unbounded state: a sequential
scanner can remember the relevant class before a space run and RI parity.
Nor does it imply that every query must scan the entire input. It means a
stateless query cannot promise constant lookbehind for arbitrary input.
Searching forward to the next boundary can itself cover arbitrarily many
characters, independently of the cost of recovering prior context.

## Why the experimental implementation was removed

The implementation called `prepare_units(text)` on every query. This scanned
the entire view and allocated an array of context records before searching
for the first boundary after the offset. Each query therefore used O(n) time
and space, even for a nearby result. Repeated calls over O(n) boundaries could
take O(n²) time.

This is a limitation of that implementation, not a requirement of the API or
Unicode. A future implementation should recover context on demand or use
cached state, scan only as far forward as needed, and avoid unconditional
whole-input allocation. Worst-case context distance must still be documented.

Before removal, the query was checked at every UTF-16 offset of all 19,346
official Unicode 18.0.0 `LineBreakTest.txt` cases, including surrogate interiors.
Boundary positions matched the fixture; boundary kinds matched the existing
cursor. These query-specific checks were removed with the experimental API;
the original conformance tests remain.

## Representation experiment: optional enums

A standalone experiment used MoonBit `0.1.20261012` (748b63c), native release
output, and `#inline(never)` producer and consumer functions to preserve call
boundaries. Generated C showed these allocations on a successful result:

| Representation | Heap allocations |
| --- | ---: |
| Ordinary two-variant enum | 1 |
| Optional ordinary two-variant enum | 1 |
| `#valtype` two-variant enum | 0 |
| Optional `#valtype` two-variant enum | 1 |
| `#valtype` enum with `Allowed(Int)`, `Mandatory(Int)`, `End` | 0 |

For the ordinary enum, `None` became a null pointer and `Some(value)` reused
the enum object's pointer. The outer option did not allocate another box.
For the value enum, the payload was returned by value, but wrapping it in
`Some` allocated an object containing that value.

JS release output used `undefined` for `None` and reused the enum object for
`Some`, for both ordinary and value-enum declarations. The enum payload still
used an object. Wasm layouts were not checked. These are observations about
this compiler and these call shapes, not permanent layout guarantees or
performance benchmarks; inlining may remove allocations at other call sites.

The essential reproduction is to compile `enum BreakIndex { Allowed(Int);
Mandatory(Int) }`, a non-inlined function returning it, and another returning
`Some` of that function's result or `None`. Repeat with `#valtype`, consume
results across a non-inlined call, and inspect native release C for
`moonbit_malloc` and the option's representation. The original temporary
experiment is not a repository dependency.

## Stateful and streaming alternatives

A break iterator can retain position, rule state, lookahead, and the last
boundary kind. This can avoid repeated context recovery during sequential
traversal. Arbitrary seeking, reverse traversal, cache invalidation after
edits, and memory costs still need explicit design. Wrapping the stateless
query in a cursor does not by itself remove its costs.

Streaming needs a different input contract. A chunk end is not necessarily a
text end: a trailing CR may be followed by LF in the next chunk, and a high
surrogate may be followed by its low surrogate. The processor must preserve
state and distinguish a found boundary, a need for more input, and completion
after explicit end-of-input. `None` in a complete-text query only means no
later boundary; it must not silently acquire a second meaning of "wait for
another chunk". Boundary offsets would also need a documented stream-wide
coordinate system and retained-input policy.

## References

- [UAX #14, LB14](https://www.unicode.org/reports/tr14/tr14-57.html#LB14)
- [UAX #14, LB30a](https://www.unicode.org/reports/tr14/tr14-57.html#LB30a)
- [UAX #29, word boundary rules](https://www.unicode.org/reports/tr29/tr29-49.html#Default_Word_Boundaries)
- [UAX #29, random access](https://www.unicode.org/reports/tr29/tr29-49.html#Random_Access)
- [Rust unicode-linebreak: tuple items, optional iterator results](https://docs.rs/unicode-linebreak/0.1.5/unicode_linebreak/fn.linebreaks.html)
- [ICU BreakIterator: integer positions, DONE, separate rule status](https://unicode-org.github.io/icu-docs/apidoc/dev/icu4c/classicu_1_1BreakIterator.html)
