# ICU normperf corpora

Compare the public MoonBit normalization APIs with ICU 77.1 (both Unicode 16),
using all 14 files named by ICU's
[NormPerf.pl](https://github.com/unicode-org/icu/blob/457157a92aa053e632cc7fcfd0e12f8a943b2d11/icu4c/source/test/perf/normperf/NormPerf.pl).
The data comes from that same pinned revision's
[collation corpus directory](https://github.com/unicode-org/icu/tree/457157a92aa053e632cc7fcfd0e12f8a943b2d11/icu4j/perf-tests/data/collation).
Upstream data is covered by [ICU's license](https://github.com/unicode-org/icu/blob/457157a92aa053e632cc7fcfd0e12f8a943b2d11/LICENSE).

Run the MoonBit corpus benchmarks directly from the repository root:

```sh
moon -C benchmarks/normperf bench
moon -C benchmarks/normperf bench --target wasm
moon -C benchmarks/normperf bench --target wasm-gc
```

The default backend is Native. The first build automatically downloads and
verifies the corpus, compiles the ICU adapter, and embeds ICU-generated reference
outputs. No separate preparation command is needed. Subsequent builds reuse the
prepared inputs. On installations other than the default Homebrew ICU 77 prefix,
set `NORMPERF_ICU_PREFIX=/path/to/icu77` when running the command. C++17 and
pkg-config are still required for preparation.

This entry point measures all 168 MoonBit cases with the standard `moon bench`
statistics and prints its timing table. Inputs and complete output/predicate
checks are prepared outside the timed closures. Its local workspace resolves
normalization and UCD to this checkout. Generated source is ignored by Git.

For the full comparison with ICU, including raw samples and CSV/Markdown reports:

```sh
moon run --target native tools/normperf -- run --icu-prefix /opt/homebrew/opt/icu4c@77
moon run --target native tools/normperf -- summarize benchmarks/normperf/.work/results
```

Requires MoonBit, a C++17 compiler, pkg-config, and an installed ICU
version 77.1 using Unicode 16. On Linux or other macOS installations supply its installation prefix explicitly.
Downloads are cached in `.cache/` and checked against the committed SHA-256
manifest. Generated fixtures and binaries live in `.work/`; neither is published
with the library. `--prepare-only` downloads/builds fixtures; `--targets native`
restricts the MoonBit backends, and `--repeats` controls independent executions.
Use a comma-separated list to select several backends, e.g. `--targets wasm,wasm-gc`.
The defaults are native, wasm, wasm-gc and three executions.
Each measurement run requires an empty output directory; use a new `--output`
path when rerunning, including when selecting fewer backends. Existing results
are rejected before preparation so measurements from different runs cannot mix.
`--prepare-only` does not write or validate the results directory.

The full-file/bulk matrix is original/NFC/NFD input × NFC/NFD operation ×
normalize/is_normalized. BOM removal matches ICU's Unicode signature handling;
all remaining characters, comments, and line endings are preserved. ICU creates
the NFC/NFD fixture variants before timing. Every MoonBit output is compared in
full with ICU, and every predicate with input equality, before measurement.

ICU has two normalization measurements: fresh C++ UnicodeString output, and
reused C output storage. MoonBit's public API can return the input unchanged.
Read both ICU columns with that ownership difference in mind. Only native
MoonBit versus native ICU is a same-backend comparison; Wasm/GC numbers include
runtime differences. Fast false checks are reported separately from full scans.

The full-comparison harness uses monotonic timers, 10 ms calibration and five
20 ms samples per case; it does not reproduce the upstream driver's longer timing settings. Input
construction, IO, transcoding and correctness validation are outside timing.
Engines run sequentially, with their order rotated across executions.
The direct `moon bench` entry uses the standard library's default ten samples
and outlier treatment instead; its timings should not be mixed into these raw
comparison reports.

Raw samples, environment metadata and generated reports are local output, not
repository content. By default they are written under the ignored
`.work/results/` directory; `results/` is also ignored for local archives.
The harness records the current checkout's source revision with each run.

The summary reports the fastest sample (as in ICU perf) and retains the mean of
process medians in CSV. Results recorded on a busy machine are explicitly marked;
small differences should be rechecked on an idle machine.

The runner, checksum verification, fixture generation, statistics and reports are
implemented in MoonBit. `tools/normperf` is the executable entry point; its
testable implementation lives in `tools/normperf/internal/harness`.
The only C++ code is `icu.cpp`,
which generates ICU reference outputs and measures ICU APIs. SHA-256 comes from
`moonbitlang/x/crypto`; this dependency belongs to the internal `tools/` module,
not the published libraries.

Run the harness regression tests without installing ICU or downloading corpora:

```sh
moon test --target native tools/normperf/internal/harness
```
