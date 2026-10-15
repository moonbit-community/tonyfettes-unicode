# unicode

Unicode support for MoonBit.

This library implements selected Unicode standards for normalization, case and
category lookup, Punycode, IDNA domain processing, bidirectional text, and text
segmentation. The generated tables target Unicode 18.0.0.

## Features

- Unicode Normalization Forms from UAX #15: NFD, NFC, NFKD, and NFKC
- Default full case folding, canonical caseless matching, and NFKC_Casefold
  identifier matching from Unicode section 3.13
- Punycode encoding and decoding from RFC 3492
- IDNA processing from UTS #46, including mapping, validation, Bidi checks,
  joiner checks, and DNS length checks
- Unicode Bidirectional Algorithm support from UAX #9
- Default line breaking opportunities from UAX #14
- Extended grapheme cluster, word, and sentence segmentation from UAX #29
- General_Category, East_Asian_Width, Line_Break, Joining_Type, Joining_Group,
  and Hangul_Syllable_Type lookup, binary property predicates (White_Space,
  Alphabetic, Lowercase, Uppercase, XID_Start, XID_Continue,
  Default_Ignorable_Code_Point, Grapheme_Extend, Regional_Indicator,
  Prepended_Concatenation_Mark, Emoji_Presentation, Emoji_Modifier,
  Emoji_Modifier_Base, Extended_Pictographic), emoji variation sequences, and simple/full case mapping
  from the Unicode Character Database

## Installation

Add only the feature modules your application needs:

```bash
moon add moonbit-community/unicode-data
moon add moonbit-community/unicode-normalization
moon add moonbit-community/unicode-casefold
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
  "moonbit-community/unicode-casefold" @casefold,
  "moonbit-community/punycode",
  "moonbit-community/unicode-idna" @idna,
  "moonbit-community/unicode-bidi" @bidi,
  "moonbit-community/unicode-segmentation" @segmentation,
}
```

MoonBit uses the last package path segment as the default alias, which is not a
valid identifier for the hyphenated `unicode-*` modules, so give those imports
an explicit alias. The examples below use `@ucd`, `@normalization`, `@casefold`,
`@punycode`, `@idna`, `@bidi`, and `@segmentation`. Existing users may continue depending on
`moonbit-community/unicode`; it is an umbrella compatibility module that
preserves the old package paths.

## Usage

Normalization and case folding accept `StringView`, so callers can pass slices
without copying them first. `String` arguments convert automatically;
text-producing operations still return `String`.

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

### Case folding and caseless matching

```moonbit
let folded = @casefold.case_fold("Straße") // "strasse"
let same_case = @casefold.caseless_match("Straße", "STRASSE") // true
let same_text = @casefold.canonical_caseless_match("Å", "a\u{030A}") // true
let search_key = @casefold.canonical_case_fold("Å") // "a\u{030A}"
let folded_id = @casefold.nfkc_casefold("Ａ\u{00AD}") // "a"
let same_id = @casefold.identifier_caseless_match("Ａ\u{00AD}", "a") // true
```

These operations follow [Unicode §3.13](https://www.unicode.org/versions/Unicode18.0.0/core-spec/chapter-3/)
and are locale-independent. Default full folding uses `CaseFolding.txt` statuses
`C` and `F`, with expansions such as `ß → ss`; it does not normalize text or
apply Turkic tailoring. `I` folds to `i`, while `İ` folds to `i` plus U+0307.
Cherokee folds to uppercase, so a folded string is not necessarily lowercase.

For canonically equivalent text, `canonical_case_fold(s)` computes
`NFD(case_fold(NFD(s)))` (D145). Store and compare these keys, or search folded
text with a folded query. Folding can change text length, so result offsets do
not directly identify positions in the original text.

`nfkc_casefold(s)` applies the official `NFKC_CF` mappings and then NFC (R5).
This merges compatibility differences and removes default-ignorable characters.
`identifier_caseless_match(a, b)` first applies NFD to both inputs before
NFKC_Casefold (D147), including the Greek iota-subscript edge cases. It tests
equality; identifier validation and confusable detection are separate operations.

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
let joining = @ucd.joining_type('\u{0628}') // DualJoining
let is_ignorable = @ucd.is_default_ignorable_code_point('\u{200D}') // true
let is_emoji = @ucd.is_emoji_presentation('\u{2764}') // false: text by default
let has_vs = @ucd.has_emoji_variation_sequence('\u{2764}') // true: U+FE0F selects emoji
let group = @ucd.joining_group('\u{062A}') // Beh
let break_class = @ucd.line_break('\u{4E2D}') // ID
let hangul = @ucd.hangul_syllable_type('\u{AC00}') // LVSyllable

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
| `is_default_ignorable_code_point(Char) -> Bool` | Test the Unicode Default_Ignorable_Code_Point property. |
| `is_grapheme_extend(Char) -> Bool` | Test the Unicode Grapheme_Extend property. |
| `is_regional_indicator(Char) -> Bool` | Test the Unicode Regional_Indicator property. |
| `is_prepended_concatenation_mark(Char) -> Bool` | Test the Unicode Prepended_Concatenation_Mark property. |
| `is_emoji_presentation(Char) -> Bool` | Test the UTS #51 Emoji_Presentation property (emoji by default). |
| `is_emoji_modifier(Char) -> Bool` | Test the UTS #51 Emoji_Modifier property (skin tone modifiers). |
| `is_emoji_modifier_base(Char) -> Bool` | Test the UTS #51 Emoji_Modifier_Base property. |
| `has_emoji_variation_sequence(Char) -> Bool` | Test whether `emoji-variation-sequences.txt` lists the character, so that U+FE0E or U+FE0F may follow it to select a text or emoji presentation. |
| `joining_type(Char) -> JoiningType` | Return the Joining_Type value: `NonJoining`, `JoinCausing`, `DualJoining`, `LeftJoining`, `RightJoining`, or `Transparent`. |
| `joining_group(Char) -> JoiningGroup` | Return the Joining_Group value, such as `Beh`, `Alef`, or `Lam`; `NoJoiningGroup` for characters outside the groups. |
| `hangul_syllable_type(Char) -> HangulSyllableType` | Return the Hangul_Syllable_Type value: `NotApplicable`, `LeadingJamo`, `VowelJamo`, `TrailingJamo`, `LVSyllable`, or `LVTSyllable`. |
| `is_extended_pictographic(Char) -> Bool` | Test Extended_Pictographic, including reserved potential emoji. |
| `line_break(Char) -> LineBreak` | Return the UAX #14 Line_Break class, such as `AL`, `ID`, or `OP`, as the Unicode Character Database assigns it. Rule LB1 is not applied here; use `unicode-segmentation` for the default line breaking algorithm. |
| `to_simple_uppercase(Char) -> Char` | Simple uppercase mapping. |
| `to_simple_lowercase(Char) -> Char` | Simple lowercase mapping. |
| `to_simple_titlecase(Char) -> Char` | Simple titlecase mapping. |
| `to_uppercase(Char) -> String` | Full uppercase mapping. |
| `to_lowercase(Char) -> String` | Full lowercase mapping. |
| `to_titlecase(Char) -> String` | Full titlecase mapping. |

The Joining_Group value `Pe` shares its name with a General_Category value.
Where the type is not known from the context, write `@ucd.JoiningGroup::Pe` or
`@ucd.GeneralCategory::Pe`.

### `moonbit-community/unicode-normalization`

| API | Description |
| --- | --- |
| `nfd(StringView) -> String` | Canonical decomposition. |
| `nfc(StringView) -> String` | Canonical decomposition followed by canonical composition. |
| `nfkd(StringView) -> String` | Compatibility decomposition. |
| `nfkc(StringView) -> String` | Compatibility decomposition followed by canonical composition. |
| `normalize(StringView, NormalizationForm) -> String` | Normalize with a selected form. |
| `is_normalized(StringView, NormalizationForm) -> Bool` | Check whether text is already in a selected form. |

The available forms are `NFD`, `NFC`, `NFKD`, and `NFKC`.

### `moonbit-community/unicode-casefold`

| API | Description |
| --- | --- |
| `case_fold(StringView) -> String` | Default full case folding (R4). |
| `caseless_match(StringView, StringView) -> Bool` | Default caseless equality, without normalization (D144). |
| `canonical_case_fold(StringView) -> String` | Canonical caseless comparison/search key (D145). |
| `canonical_caseless_match(StringView, StringView) -> Bool` | Caseless equality under canonical equivalence (D145). |
| `nfkc_casefold(StringView) -> String` | Official NFKC_CF mapping followed by NFC (R5). |
| `identifier_caseless_match(StringView, StringView) -> Bool` | Identifier caseless equality after initial NFD (D147). |

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
| `graphemes(StringView) -> Graphemes` | Create a cursor over extended grapheme clusters (UAX #29). |
| `Graphemes::iter() -> Iter[StringView]` | Iterate over remaining clusters; enables `for .. in`. |
| `Graphemes::next() -> StringView` | Return the next cluster, or an empty view at the end. |
| `Graphemes::line_break() -> BreakOpportunity` | Query `Prohibited`, `Allowed`, or `Mandatory` after the last returned cluster. Initializes line breaking context only when queried. |
| `word_segments(StringView) -> WordSegments` | All default UAX #29 word segments, retaining whitespace and punctuation. |
| `words(StringView) -> Words` | Word segments containing at least one Unicode Alphabetic or Number character. |
| `sentences(StringView) -> Sentences` | Default UAX #29 sentence segments, retaining trailing whitespace and punctuation. |
| `line_breaks(StringView) -> LineBreaks` | Create a cursor over segments ending at default UAX #14 opportunities. |
| `LineBreaks::next() -> StringView` | Return the next segment, or an empty view at the end. |
| `LineBreaks::iter() -> Iter[StringView]` | Iterate over remaining segments; enables `for .. in`. |
| `LineBreaks::opportunity() -> BreakOpportunity` | Query the break kind at the end of the last returned segment. |

All cursors expose `next() -> StringView` and `iter() -> Iter[StringView]`,
which consume the same cursor. Returned views retain UTF-16 offsets in the
backing string; `next()` returns an empty view at the input's end on
exhaustion. `word_segments` and `sentences` retain all input characters;
`words` filters complete word segments. They use default rules without
locale or dictionary tailoring and prepare boundaries in O(n) time and space.

The grapheme and line cursors retain spaces and newlines.
Before the first result their break queries return `Prohibited`;
after exhaustion they preserve the last kind. Nonempty text ends with
`Mandatory`, even without a newline. Empty text has no results.

`LineBreaks` exposes every default UAX #14 opportunity, including ones inside
grapheme clusters. `Graphemes::line_break()` queries only complete cluster ends,
without moving internal opportunities to those ends. See
[segmentation](segmentation/README.md) for examples and complexity.
The workspace conformance suite runs every Unicode 18.0.0 `LineBreakTest.txt`
case directly from `tests/data/`, along with all 1,944 word and 512 sentence
boundary cases in `WordBreakTest.txt` and `SentenceBreakTest.txt`.

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

Individual commands are `ucd`, `casefold`, `idna`, `bidi`, and `segmentation`.
`casefold` regenerates just the folding tables; it is also included in `data` / `all`.
Downloaded Unicode source files are cached per version in `tools/.cache/<version>/`.

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

The native release tool keeps the eight published module versions aligned,
validates the workspace, and checks every package archive. Preparation
publishes nothing and never dry-runs an archive against the registry, so it
needs no mooncakes.io credentials:

```bash
moon run --target native tools/release -- prepare --version <MAJOR.MINOR.PATCH>
```

The version is a plain `MAJOR.MINOR.PATCH` with no prerelease suffix. `prepare`
refuses to run unless the Git worktree is clean and the eight published
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
`unicode-segmentation`, `unicode-normalization`, `unicode-casefold`, `unicode-idna`, and the
`unicode` compatibility umbrella in dependency order. It reads
the release version from the umbrella manifest `unicode/moon.mod` and verifies
that all eight published modules use that version. The modules that do not
depend on this release are dry-run before anything is published, so a rejected
archive cannot leave a partial release behind; each remaining module is
dry-run immediately before its own publication, after the registry is
refreshed for its same-release dependencies. It never publishes the
workspace-only `tests` or `tools` modules. If publication stops partway there
is no resume step: the modules that were already published stay at that
version, so fix the problem and release the whole set again at a new version.

## Standards

- [UAX #9: Unicode Bidirectional Algorithm](https://unicode.org/reports/tr9/)
- [UAX #14: Unicode Line Breaking Algorithm](https://unicode.org/reports/tr14/)
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
