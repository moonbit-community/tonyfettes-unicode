# Table lookup benchmark

Times the generated lookups that `bench/xlang` does not reach on their own:

```moonbit
@general_category.is_mark(c)
@composition.is_composition_excluded(c)
@bidi.get_mirrored(c, 1) // Bidi_Mirroring_Glyph
```

Run from the repository root:

```sh
moon bench ./bench/lookupperf --target native
moon bench ./bench/lookupperf --target wasm-gc
moon bench ./bench/lookupperf --target wasm
```

Each case visits a whole sample per iteration, so the `@bench` call overhead
is amortized: `all` takes one scalar value per 97 across every plane, and
`bmp` one per 7 below U+10000, where the smaller tables are dense. Paired
brackets are covered by the `bidi` group of `bench/xlang`, and the special
case mappings by its `case` group.
