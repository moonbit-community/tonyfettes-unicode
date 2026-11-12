# Cross-language benchmark

Compares this repository's modules with the libraries other languages use for
the same jobs. Run from the repository root:

```sh
moon run --target native bench/xlang
moon run --target native bench/xlang -- --rounds 1 --group bidi
moon run --target native bench/xlang -- --impl moonbit-native,rust --detail
moon run --target native bench/xlang -- --base HEAD^
```

The runner (the MoonBit package in this directory) prepares the inputs, builds
every harness, runs them one at a time for three rounds, and prints a Markdown
report. Nothing is written to the source tree: inputs, build products,
`results.tsv`, `report.md` and `results.json` (for the dashboard) go to
`_build/xlang/`. A full run takes about fifteen minutes.

| Option | Meaning |
|---|---|
| `--rounds N` | Rounds to run; each case keeps its fastest round (default 3) |
| `--impl A,B` | Only these harnesses (default: every one that can be set up) |
| `--group G` | Only `norm`, `seg`, `bidi`, `idna`, `puny` or `case` |
| `--detail` | Also report every case, not only the mean per operation |
| `--base REV` | Compare the MoonBit harnesses with those of commit `REV` instead; see below |

## Harnesses

Each subdirectory is a standalone program in its own language. Nothing is
called across languages: every program reads the same input files, times the
same cases with the same protocol, and prints rows in the same format.

| Harness | Directory | Measures | Needs |
|---|---|---|---|
| `moonbit-native`, `moonbit-wasm-gc`, `moonbit-wasm`, `moonbit-js` | `moonbit/` | This checkout, per backend | `moon`; `node` for `js` |
| `icu4c` | `icu4c/` | ICU4C, on UTF-16 | A C++17 compiler and ICU4C |
| `rust` | `rust/` | `unicode-normalization`, `unicode-segmentation`, `unicode-bidi`, `idna`, `unicode-general-category`, `std`, and ICU4X on UTF-8 and UTF-16 | `cargo` |
| `go` | `go/` | `golang.org/x/text`, `golang.org/x/net/idna`, `rivo/uniseg`, `unicode` | `go` 1.26 or later |
| `node` | `node/` | `String.prototype.normalize` and `Intl.Segmenter` (ICU4C behind V8), `url.domainToASCII` (ada), the bundled `punycode` | `node` |
| `python` | `python/` | `unicodedata` for normalization, `str.casefold` | `python3` |

A harness whose toolchain, runtime or library is missing is reported as
skipped and the comparison continues without it; the run fails only when no
harness produces a result. ICU4C is looked up in `ICU_ROOT`, then in
Homebrew's keg-only `icu4c`, then on the compiler's default paths; `CXX`
selects the compiler. Rust and Go dependencies are pinned by `Cargo.lock` and
`go.sum`.

## Protocol

Every harness doubles the iteration count of a case until one sample takes at
least 10 ms, then reports the fastest of 12 samples as

```
library<TAB>group/operation/input<TAB>ns per call<TAB>units<TAB>check
```

`library` is empty when the harness measures a single library, `units` is the
number of code points processed per call (1 for per-call cases), and `check`
is a value every implementation must agree on, such as the number of code
points of the result, the grapheme cluster count or the sum of the Bidi
levels (`-` when there is nothing comparable). File IO, decoding and input
preparation are outside the timed calls. The report lists the cases on which
implementations disagree.

A harness must keep every result where it could be read later, not only fold
its length into the sink: V8 drops a string that only has its length read,
since it can compute the length without building the string, and LLVM can drop
an allocation it sees unused. The MoonBit and Node harnesses store each result
in a global; the Rust harness passes it through `black_box`.

The inputs are defined once, in `inputs.mbt`; harnesses list the input
directories rather than naming files. Normalization uses the 14 ICU normperf
corpora committed for [`bench/normperf`](../normperf/README.md), as they are
and converted to NFD. The `case` group has short phrases repeated, three of
those corpora (Latin and Russian names, English prose) and the Latin names
in uppercase, where nearly every letter has a mapping to apply.

To add a harness, write a program that takes `<inputs> [group]` and prints
rows in this format, then add it to `all_peers` in `peers.mbt`.

## Reading the report

Cells are nanoseconds per code point (per call for `idna` and `puny`), as the
geometric mean over an operation's inputs. The number in parentheses is the
time relative to `moonbit-native` on the same cases.

- MoonBit, ICU4C and Node work on UTF-16; the Rust and Go libraries work on
  UTF-8, which is why ICU4X is measured on both.
- For input that is already normalized, MoonBit, ICU4X and Go can return the
  input unchanged, while `unicode-normalization` always builds a new string.
  The `nfd` and `nfd>nfc` operations force real work. Python answers
  normalization of ASCII-only strings in constant time, which pulls its
  geometric means down.
- The IDNA options are only approximately aligned: UTS #46 non-transitional
  processing without STD3 rules, with each library's own defaults otherwise.
- `uniseg` implements an older Unicode version, so its grapheme cluster count
  differs on Devanagari text.
- `case/full_upper` compares MoonBit's `to_uppercase`, which returns a string
  per character, with Rust's iterator, which allocates nothing.
- `case/fold` is full default case folding (statuses C and F, no Turkic
  mappings): ICU4C's `u_strFoldCase` on UTF-16, ICU4X's `fold_string`, Go's
  `cases.Fold()` and Python's `str.casefold`. ICU4X and Go return the input
  when folding changes nothing, as on the CJK input; the others always build
  a new string, and Python has a dedicated loop for ASCII-only strings. Node
  and the Rust standard library have no full case folding, and only ICU4C
  has `nfkc_casefold`.
- ICU4C's per-character functions are calls into a shared library, and every
  Node case crosses from JavaScript into the runtime.
- Other processes disturb the measurement. The report's noise table shows how
  much the rounds disagreed; treat differences of that size as equal.

## Comparing two commits

`--base REV` checks `REV` out in `_build/xlang/base`, copies this checkout's
MoonBit harness and `bench/moon.mod` into it, and runs the MoonBit harnesses
of both commits in turns: in odd rounds the base goes first, in even rounds the head. Both sides
run the same harness, so a change to `moonbit/main.mbt` does not show up as a
change to the library. Only the MoonBit harnesses take part. The report,
`compare.md`, gives the change in time per operation and backend, and
`compare.json` holds the costs of every case on both sides.

## Dashboard

`site/` is a static page that shows both kinds of run. The `benchmark`
workflow (`.github/workflows/bench.yml`) runs `--base HEAD^` on every push to
main, appends the result to `history.json` on the `bench-data` branch, keeps
the full comparison in `runs/<commit>.json` there, and publishes `site/` with
the history to GitHub Pages. GitHub's runners are shared machines, so only
these same-runner comparisons are recorded from CI, never absolute times. A
comparison runs two rounds.

Pushes that only change documentation (`*.md`, `docs/`), tests (`*_test.mbt`,
`*_wbtest.mbt`, `tests/`), `tools/` or other workflows start no run, since they
cannot change the library's speed, and leave no entry in the history. Pushes
that only change `site/` republish the page without comparing. Running the
workflow by hand republishes the page, and compares too when its `compare`
input is set.

The cross-language part of the page reads `site/snapshot.json`, which is
updated by hand from a full run on a quiet machine:

```sh
moon run --target native bench/xlang
cp _build/xlang/results.json bench/xlang/site/snapshot.json
```

Commit it; the push to main republishes the page. To look at the page
locally, serve `site/` over HTTP (it fetches its data), for example with
`python3 -m http.server -d bench/xlang/site`. Without a `history.json` next to
it, the history section says there are no runs yet.
