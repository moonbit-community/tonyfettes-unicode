# unicode

Unicode support for MoonBit.

This library implements selected Unicode standards for normalization, case and
category lookup, Punycode, IDNA domain processing, and bidirectional text. The
generated tables target Unicode 16.0.0.

## Features

- Unicode Normalization Forms from UAX #15: NFD, NFC, NFKD, and NFKC
- Punycode encoding and decoding from RFC 3492
- IDNA processing from UTS #46, including mapping, validation, Bidi checks,
  joiner checks, and DNS length checks
- Unicode Bidirectional Algorithm support from UAX #9
- General_Category lookup and simple/full case mapping from the Unicode
  Character Database

## Installation

Add only the feature modules your application needs:

```bash
moon add tonyfettes/ucd
moon add tonyfettes/normalization
moon add tonyfettes/punycode
moon add tonyfettes/bidi
moon add tonyfettes/idna
```

Import the packages you need in `moon.pkg`:

```moonbit
import {
  "tonyfettes/ucd"
  "tonyfettes/normalization"
  "tonyfettes/punycode"
  "tonyfettes/idna"
  "tonyfettes/bidi"
}
```

MoonBit uses the last package path segment as the default alias, so these
imports are used as `@ucd`, `@normalization`, `@punycode`, `@idna`, and
`@bidi`. Existing users may continue depending on `tonyfettes/unicode`; it is
an umbrella compatibility module that preserves the old package paths.

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

### Case And Category Data

```moonbit
let category = @ucd.general_category('A') // Lu
let group = category.group() // L

let simple = @ucd.to_simple_uppercase('a') // 'A'
let full = @ucd.to_uppercase('\u{00DF}') // "SS"
let lower = @ucd.to_lowercase('\u{0130}') // "i" + combining dot above
```

## Public Packages

### `tonyfettes/ucd`

Root package for Unicode Character Database helpers.

| API | Description |
| --- | --- |
| `general_category(Char) -> GeneralCategory` | Return the two-letter Unicode General_Category value. |
| `GeneralCategory::group() -> GeneralCategoryGroup` | Return the one-letter category group. |
| `to_simple_uppercase(Char) -> Char` | Simple uppercase mapping. |
| `to_simple_lowercase(Char) -> Char` | Simple lowercase mapping. |
| `to_simple_titlecase(Char) -> Char` | Simple titlecase mapping. |
| `to_uppercase(Char) -> String` | Full uppercase mapping. |
| `to_lowercase(Char) -> String` | Full lowercase mapping. |
| `to_titlecase(Char) -> String` | Full titlecase mapping. |

### `tonyfettes/normalization`

| API | Description |
| --- | --- |
| `nfd(String) -> String` | Canonical decomposition. |
| `nfc(String) -> String` | Canonical decomposition followed by canonical composition. |
| `nfkd(String) -> String` | Compatibility decomposition. |
| `nfkc(String) -> String` | Compatibility decomposition followed by canonical composition. |
| `normalize(String, NormalizationForm) -> String` | Normalize with a selected form. |
| `is_normalized(String, NormalizationForm) -> Bool` | Check whether text is already in a selected form. |

The available forms are `NFD`, `NFC`, `NFKD`, and `NFKC`.

### `tonyfettes/punycode`

| API | Description |
| --- | --- |
| `encode(String) -> String raise PunycodeError` | Encode Unicode text as Punycode. |
| `decode(String) -> String raise PunycodeError` | Decode Punycode text back to Unicode. |

`PunycodeError` variants are `Overflow`, `InvalidInput`, and `BadInput`.

### `tonyfettes/idna`

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

### `tonyfettes/bidi`

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

## Development

Common commands:

```bash
moon check
moon test
moon test -p tonyfettes/normalization
moon fmt
moon info
moon build
```

Run `moon info` after public API changes to refresh `pkg.generated.mbti` files.

Unicode data and conformance tests are generated from official Unicode files:

```bash
moon run --target native tools/gen data
moon run --target native tools/gen tests

# Or regenerate everything in one pass:
moon run --target native tools/gen all
```

Individual commands are `ucd`, `idna`, `bidi`, `normalization-tests`,
`idna-tests`, and `bidi-tests`. To control the number of Bidi conformance cases
per generated package (default: 500), run
`moon run --target native tools/gen -- bidi-tests --part-size N`. Downloaded
Unicode source files are cached in `tools/.cache/`.

Large generated conformance fixtures live in the workspace-only
`tonyfettes/unicode-conformance` module, so they remain part of local and CI
tests without inflating published feature archives. Verify a feature module's
contents from its directory, for example:

```bash
moon -C bidi package --list
```

## Standards

- [UAX #9: Unicode Bidirectional Algorithm](https://unicode.org/reports/tr9/)
- [UAX #15: Unicode Normalization Forms](https://unicode.org/reports/tr15/)
- [UAX #44: Unicode Character Database](https://unicode.org/reports/tr44/)
- [RFC 3492: Punycode](https://datatracker.ietf.org/doc/html/rfc3492)
- [UTS #46: Unicode IDNA Compatibility Processing](https://unicode.org/reports/tr46/)
- [RFC 5891: Internationalized Domain Names in Applications](https://datatracker.ietf.org/doc/html/rfc5891)
- [RFC 5892: The Unicode Code Points and IDNA](https://datatracker.ietf.org/doc/html/rfc5892)
- [RFC 5893: Right-to-Left Scripts for IDNA](https://datatracker.ietf.org/doc/html/rfc5893)

## License

Apache-2.0. See [LICENSE](LICENSE).
