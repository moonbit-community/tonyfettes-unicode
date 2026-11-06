# Punctuation benchmark

Compare the dedicated punctuation predicate with the General_Category group
lookup:

```moonbit
@unicode.is_punctuation(c)
@unicode.general_category(c).group() is @unicode.GeneralCategoryGroup::P
```

Run from the repository root:

```sh
moon bench ./bench/punctperf --target native
moon bench ./bench/punctperf --target wasm-gc
moon bench ./bench/punctperf --target wasm
```

The benchmark uses one code point per 97 scalar values, 11,486 characters in
all. Each iteration of the corpus cases visits the whole sample, so it measures
the predicate without the per-call benchmark harness dominating. The named
single-character cases include punctuation and non-punctuation code points from
ASCII, CJK, marks, and emoji; their reported time includes the `@bench` call
overhead, while the corpus cases amortize it.

## Example results

One run on arm64, using the corpus cases (11,486 characters):

| Target | `is_punctuation` | `general_category(...) is P` | Speedup |
| --- | ---: | ---: | ---: |
| native | 5.19 µs (0.45 ns/char) | 39.56 µs (3.44 ns/char) | 7.6× |
| wasm-gc | 10.65 µs (0.93 ns/char) | 75.84 µs (6.60 ns/char) | 7.1× |
| wasm | 13.66 µs (1.19 ns/char) | 154.42 µs (13.44 ns/char) | 11.3× |

The named single-character cases include the `@bench` call overhead, so their
reported difference is smaller; use the corpus cases for throughput.
