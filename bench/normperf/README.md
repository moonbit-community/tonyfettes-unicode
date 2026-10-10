# Normalization benchmarks

Run from the repository root:

```sh
moon -C bench/normperf bench
moon -C bench/normperf bench --target wasm
moon -C bench/normperf bench --target wasm-gc
```

Native is the default. The benchmark reads the committed files in `data/`
directly with `moonbitlang/x/fs`, verifies their sizes and SHA-256 hashes against
`corpus.json`, removes the UTF-8 BOM where present, and preserves all remaining
characters and line endings. After MoonBit dependencies are installed, running
the benchmark needs no network access, ICU installation, or preparation command.
There is no code generation or temporary runner project; Moon manages build
artifacts in `_build` and prints timing statistics directly.

The matrix contains 168 cases: 14 full corpora × original/NFC/NFD input ×
NFC/NFD target × normalize/is_normalized. NFC and NFD inputs are produced with
the library under test before timing. File IO, decoding, hashing, input
preparation and consistency checks are outside the `b.bench` closures. All cases
run sequentially in one benchmark block, using the standard `moon bench`
sampling and statistics. The local workspace uses normalization and UCD from
this checkout.

Already-normalized input may take the unchanged-string path. False checks may
exit near the beginning, so they do not represent whole-input throughput.
Generated NFC/NFD inputs and consistency checks are not an independent
correctness oracle; the workspace's normalization conformance tests use the
official Unicode test data. This benchmark measures MoonBit only.

To validate the corpus and input matrix without running timers:

```sh
moon -C bench/normperf test --target native
moon -C bench/normperf test --target wasm
moon -C bench/normperf test --target wasm-gc
```

The 14 source files are those named by ICU's
[NormPerf.pl](https://github.com/unicode-org/icu/blob/457157a92aa053e632cc7fcfd0e12f8a943b2d11/icu4c/source/test/perf/normperf/NormPerf.pl),
from the same pinned revision's
[collation corpus directory](https://github.com/unicode-org/icu/tree/457157a92aa053e632cc7fcfd0e12f8a943b2d11/icu4j/perf-tests/data/collation).
They are committed unchanged (about 6.5 MiB), with their source URLs and hashes
in `corpus.json` and the upstream [license](data/LICENSE).
