# ICU normperf corpora

Compare the public MoonBit normalization APIs with ICU 77.1 (both Unicode 16),
using all 14 files named by ICU's
[NormPerf.pl](https://github.com/unicode-org/icu/blob/457157a92aa053e632cc7fcfd0e12f8a943b2d11/icu4c/source/test/perf/normperf/NormPerf.pl).
The data comes from that same pinned revision's
[collation corpus directory](https://github.com/unicode-org/icu/tree/457157a92aa053e632cc7fcfd0e12f8a943b2d11/icu4j/perf-tests/data/collation).
Upstream data is covered by [ICU's license](https://github.com/unicode-org/icu/blob/457157a92aa053e632cc7fcfd0e12f8a943b2d11/LICENSE).

```sh
python3 benchmarks/normperf/run.py --icu-prefix /opt/homebrew/opt/icu4c@77
python3 benchmarks/normperf/summarize.py benchmarks/normperf/.work/results
```

Requires Python 3, MoonBit, a C++17 compiler, pkg-config, and an installed ICU
using Unicode 16. On Linux or other macOS installations supply its installation prefix explicitly.
Downloads are cached in `.cache/` and checked against the committed SHA-256
manifest. Generated fixtures and binaries live in `.work/`; neither is published
with the library. `--prepare-only` downloads/builds fixtures; `--targets native`
restricts the MoonBit backends, and `--repeats` controls independent executions.
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

The harness uses monotonic timers, 10 ms calibration and five 20 ms samples per
case; it does not reproduce the upstream driver's longer timing settings. Input
construction, IO, transcoding and correctness validation are outside timing.
Engines run sequentially, with their order rotated across executions.

Raw samples, environment metadata and generated reports are local output, not
repository content. By default they are written under the ignored
`.work/results/` directory; `results/` is also ignored for local archives.
The harness records the current checkout's source revision with each run.

The summary reports the fastest sample (as in ICU perf) and retains the mean of
process medians in CSV. Results recorded on a busy machine are explicitly marked;
small differences should be rechecked on an idle machine.
