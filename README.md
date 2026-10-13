# unicode

Unicode support for MoonBit.

This library implements selected Unicode standards for normalization, case and
category lookup, Punycode, IDNA domain processing, bidirectional text, and text
segmentation. The generated tables target Unicode 18.0.0.

## Features

- Unicode Normalization Forms from UAX #15: NFD, NFC, NFKD, and NFKC
- Punycode encoding and decoding from RFC 3492
- IDNA processing from UTS #46, including mapping, validation, Bidi checks,
  joiner checks, and DNS length checks
- Unicode Bidirectional Algorithm support from UAX #9
- Extended grapheme cluster segmentation from UAX #29
- General_Category and East_Asian_Width lookup, binary property predicates
  (White_Space, Alphabetic, Lowercase, Uppercase, XID_Start, XID_Continue), and
  simple/full case mapping from the Unicode Character Database

## Installation

Add only the feature modules your application needs:

```bash
moon add moonbit-community/unicode-data
moon add moonbit-community/unicode-normalization
moon add moonbit-community/punycode
moon add moonbit-community/unicode-bidi
moon add moonbit-community/unicode-segmentation
moon add moonbit-community/unicode-idna
```

Import the packages you need in `moon.pkg`:

```moonbit
import {
  "moonbit-community/unicode-data" @ucd,
  "moonbit-community/unicode-normalization" @normalization,
  "moonbit-community/punycode",
  "moonbit-community/unicode-idna" @idna,
  "moonbit-community/unicode-bidi" @bidi,
  "moonbit-community/unicode-segmentation" @segmentation,
}
```

MoonBit uses the last package path segment as the default alias, which is not a
valid identifier for the hyphenated `unicode-*` modules, so give those imports
an explicit alias. The examples below use `@ucd`, `@normalization`,
`@punycode`, `@idna`, `@bidi`, and `@segmentation`. Existing users may continue depending on
`moonbit-community/unicode`; it is an umbrella compatibility module that
preserves the old package paths.

## Usage

### Normalization

```moonbit
let composed = @normalization.nfc("e\u{0301}") // "é"
let decomposed = @normalization.nfd("é") // "e" + combining acute
let compatible = @normalization.nfkc("ﬁ") // "fi"

let already_nfc = @normalization.is_normalized(
  composed,
  @normalization.NFC,
)

let normalized = @normalization.normalize(
  "text",
  @normalization.NFKC,
)
```

### Punycode

`encode` and `decode` use checked errors. Use `try!` for examples or handle the
error explicitly in application code.

```moonbit
let encoded = try! @punycode.encode("münchen") // "mnchen-3ya"
let decoded = try! @punycode.decode("mnchen-3ya") // "münchen"

let chinese = try! @punycode.encode("中文") // "fiq228c"
```

### IDNA

```moonbit
let ascii = try! @idna.to_ascii("münchen.de")
// "xn--mnchen-3ya.de"

let unicode = try! @idna.to_unicode("xn--mnchen-3ya.de")
// "münchen.de"

let checked = try! @idna.to_ascii(
  "example.com",
  use_std3_ascii_rules=true,
  check_hyphens=true,
  check_bidi=true,
  check_joiners=true,
  verify_dns_length=true,
)
```

To handle validation failures:

```moonbit
try @idna.to_ascii("example..com") catch {
  err => println("invalid domain: \{err}")
} noraise {
  ascii => println(ascii)
}
```

### Bidi

```moonbit
let direction = @bidi.detect_direction("Hello World") // LTR
let needs_bidi = @bidi.requires_bidi("Hello \u{05E9}\u{05DC}\u{05D5}\u{05DD}")

let paragraph = @bidi.process("abc\u{05D0}\u{05D1}")
let visual = @bidi.reorder_string(paragraph)
let order = @bidi.reorder(paragraph)

let forced = @bidi.process(
  "\u{05D0}\u{05D1}\u{05D2}",
  direction=@bidi.Direction::LTR,
)
```

### Segmentation

```moonbit
// "é" (e + combining acute), a flag, and a family emoji are one cluster each.
let count = @segmentation.graphemes("e\u{0301}🇺🇳👨‍👩‍👧").iter().count() // 3

for cluster in @segmentation.graphemes("e\u{0301}x") {
  // Each cluster is a view into the input.
  println("\{cluster.start_offset()}: \{cluster}")
}

// `next` returns an empty view at the end instead of an `Option`, which
// avoids an allocation per cluster in hot loops.
let clusters = @segmentation.graphemes("e\u{0301}x")
while clusters.next() is cluster && !cluster.is_empty() {
  println(cluster)
}
```

### Case And Category Data

```moonbit
let category = @ucd.general_category('A') // Lu
let group = category.group() // L
let width = @ucd.east_asian_width('世') // W
let can_start = @ucd.is_xid_start('A') // true
let can_continue = @ucd.is_xid_continue('0') // true
let is_space = @ucd.is_white_space('\u{3000}') // true
let is_letter = @ucd.is_alphabetic('\u{093E}') // true (Other_Alphabetic)
let is_lower = @ucd.is_lowercase('\u{00AA}') // true, although gc is Lo
let is_upper = @ucd.is_uppercase('\u{2160}') // true, although gc is Nl

let simple = @ucd.to_simple_uppercase('a') // 'A'
let full = @ucd.to_uppercase('\u{00DF}') // "SS"
let lower = @ucd.to_lowercase('\u{0130}') // "i" + combining dot above
```

## Public Packages

### `moonbit-community/unicode-data`

Root package for Unicode Character Database helpers.

| API | Description |
| --- | --- |
| `general_category(Char) -> GeneralCategory` | Return the two-letter Unicode General_Category value. |
| `GeneralCategory::group() -> GeneralCategoryGroup` | Return the one-letter category group. |
| `east_asian_width(Char) -> EastAsianWidth` | Return the UAX #11 East_Asian_Width value: `A`, `F`, `H`, `N`, `Na`, or `W`. |
| `is_white_space(Char) -> Bool` | Test the Unicode White_Space property. |
| `is_alphabetic(Char) -> Bool` | Test the Unicode Alphabetic property. |
| `is_lowercase(Char) -> Bool` | Test the Unicode Lowercase property (broader than General_Category Ll). |
| `is_uppercase(Char) -> Bool` | Test the Unicode Uppercase property (broader than General_Category Lu). |
| `is_xid_start(Char) -> Bool` | Test the Unicode XID_Start identifier property. |
| `is_xid_continue(Char) -> Bool` | Test the Unicode XID_Continue identifier property. |
| `to_simple_uppercase(Char) -> Char` | Simple uppercase mapping. |
| `to_simple_lowercase(Char) -> Char` | Simple lowercase mapping. |
| `to_simple_titlecase(Char) -> Char` | Simple titlecase mapping. |
| `to_uppercase(Char) -> String` | Full uppercase mapping. |
| `to_lowercase(Char) -> String` | Full lowercase mapping. |
| `to_titlecase(Char) -> String` | Full titlecase mapping. |

### `moonbit-community/unicode-normalization`

| API | Description |
| --- | --- |
| `nfd(String) -> String` | Canonical decomposition. |
| `nfc(String) -> String` | Canonical decomposition followed by canonical composition. |
| `nfkd(String) -> String` | Compatibility decomposition. |
| `nfkc(String) -> String` | Compatibility decomposition followed by canonical composition. |
| `normalize(String, NormalizationForm) -> String` | Normalize with a selected form. |
| `is_normalized(String, NormalizationForm) -> Bool` | Check whether text is already in a selected form. |

The available forms are `NFD`, `NFC`, `NFKD`, and `NFKC`.

### `moonbit-community/punycode`

| API | Description |
| --- | --- |
| `encode(String) -> String raise PunycodeError` | Encode Unicode text as Punycode. |
| `decode(String) -> String raise PunycodeError` | Decode Punycode text back to Unicode. |

`PunycodeError` variants are `Overflow`, `InvalidInput`, and `BadInput`.

### `moonbit-community/unicode-idna`

| API | Description |
| --- | --- |
| `to_ascii(String, ...) -> String raise IdnaError` | Convert a domain name to ASCII form for DNS use. |
| `to_unicode(String, ...) -> String raise IdnaError` | Convert an ASCII or ACE domain name to Unicode form for display. |

`to_ascii` accepts these optional checks, all defaulting to `true`:

- `use_std3_ascii_rules? : Bool`
- `check_hyphens? : Bool`
- `check_bidi? : Bool`
- `check_joiners? : Bool`
- `verify_dns_length? : Bool`

`to_unicode` accepts the same options except `verify_dns_length`; they also
default to `true`.

### `moonbit-community/unicode-bidi`

| API | Description |
| --- | --- |
| `detect_direction(String) -> Direction` | Detect the base direction from the first strong character. |
| `requires_bidi(String) -> Bool` | Check whether text contains right-to-left characters. |
| `process(String, direction? : Direction) -> BidiParagraph` | Resolve classes and levels, optionally forcing the base direction. |
| `reorder(BidiParagraph) -> Array[Int]` | Return visual-order indexes. |
| `reorder_string(BidiParagraph) -> String` | Return visually reordered text. |
| `bidi_class(Char) -> BidiClass` | Return the Unicode Bidi_Class value. |
| `get_mirrored(Char, Int) -> Char` | Return the mirrored character at an RTL level when one exists. |
| `direction_from_level(Int) -> Direction` | Convert an embedding level to `LTR` or `RTL`. |

`process_with_direction` and `process_with_base_level` remain available as
deprecated compatibility wrappers.

### `moonbit-community/unicode-segmentation`

| API | Description |
| --- | --- |
| `graphemes(StringView) -> Graphemes` | Create a single-pass cursor over the extended grapheme clusters of a text. |
| `Graphemes::iter() -> Iter[StringView]` | Iterate over the remaining clusters, each a view into the input; enables `for .. in`. |
| `Graphemes::next() -> StringView` | Return the next cluster, or an empty view at the end. |

## Development

Common commands:

```bash
moon check
moon test
moon test -p moonbit-community/unicode-normalization
moon fmt
moon info
moon build
```

Run `moon info` after public API changes to refresh `pkg.generated.mbti` files.

Unicode data tables are generated from official Unicode files:

```bash
moon run --target native tools/gen data

# Or regenerate everything in one pass:
moon run --target native tools/gen all
```

Individual commands are `ucd`, `idna`, `bidi`, and `segmentation`. Downloaded
Unicode source files are cached per version in `tools/.cache/<version>/`.

Conformance tests live in the workspace-only `moonbit-community/unicode-tests`
module (`tests/`). They read the official Unicode test data files committed
under `tests/data/` directly at test time with `moonbitlang/async`, keeping the
test dependency separate from the published modules. Verify a module's contents
from its directory, for example:

```bash
moon -C unicode package --list  # the compatibility umbrella
moon -C bidi package --list     # an individual feature module
```

### Normalization benchmarks

Run `moon bench ./bench/normperf` to measure normalization using the
[14 full ICU normperf corpora](bench/normperf/README.md). The benchmark
reads committed data directly and supports Native, Wasm and Wasm-GC.

### Cross-language benchmark

Run `moon run --target native bench/xlang` to compare every module with ICU4C,
ICU4X and the usual Rust, Go, Node and Python libraries on the same inputs.
See [bench/xlang](bench/xlang/README.md) for the harnesses and how to read the
report.

### Releasing

The native release tool keeps the seven published module versions aligned,
validates the workspace, and checks every package archive. Preparation
publishes nothing and never dry-runs an archive against the registry, so it
needs no mooncakes.io credentials:

```bash
moon run --target native tools/release -- prepare --version <MAJOR.MINOR.PATCH>
```

The version is a plain `MAJOR.MINOR.PATCH` with no prerelease suffix. `prepare`
refuses to run unless the Git worktree is clean and the seven published
manifests already agree on one version, which it then rewrites to the new one.

Review and commit the resulting manifest changes, open a pull request, and wait
for CI to pass before merging: `main` is protected and rejects direct pushes.
Publication is a separate, explicit step that does not require a Git tag. Run
the `publish-package` workflow in GitHub Actions, or run the underlying command
from a clean checkout of the commit to publish:

```bash
moon run --target native tools/release -- publish \
  --execute
```

The tool publishes `unicode-data`, `punycode`, `unicode-bidi`,
`unicode-segmentation`, `unicode-normalization`, `unicode-idna`, and the
`unicode` compatibility umbrella in dependency order. It reads
the release version from the umbrella manifest `unicode/moon.mod` and verifies
that all seven published modules use that version. The modules that do not
depend on this release are dry-run before anything is published, so a rejected
archive cannot leave a partial release behind; each remaining module is
dry-run immediately before its own publication, after the registry is
refreshed for its same-release dependencies. It never publishes the
workspace-only `tests` or `tools` modules. If publication stops partway there
is no resume step: the modules that were already published stay at that
version, so fix the problem and release the whole set again at a new version.

## Standards

- [UAX #9: Unicode Bidirectional Algorithm](https://unicode.org/reports/tr9/)
- [UAX #15: Unicode Normalization Forms](https://unicode.org/reports/tr15/)
- [UAX #29: Unicode Text Segmentation](https://unicode.org/reports/tr29/)
- [UAX #44: Unicode Character Database](https://unicode.org/reports/tr44/)
- [RFC 3492: Punycode](https://datatracker.ietf.org/doc/html/rfc3492)
- [UTS #46: Unicode IDNA Compatibility Processing](https://unicode.org/reports/tr46/)
- [RFC 5891: Internationalized Domain Names in Applications](https://datatracker.ietf.org/doc/html/rfc5891)
- [RFC 5892: The Unicode Code Points and IDNA](https://datatracker.ietf.org/doc/html/rfc5892)
- [RFC 5893: Right-to-Left Scripts for IDNA](https://datatracker.ietf.org/doc/html/rfc5893)

## License

Apache-2.0. See [LICENSE](LICENSE).
