# unicode-casefold

Unicode 18.0.0 full case folding and caseless matching for MoonBit.
The package depends on `unicode-normalization` for normalized folding keys.

## Installation

```bash
moon add moonbit-community/unicode-casefold
```

```moonbit
import {
  "moonbit-community/unicode-casefold" @casefold,
}
```

## Usage

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

## API

| API | Description |
| --- | --- |
| `case_fold(StringView) -> String` | Default full case folding (R4). |
| `caseless_match(StringView, StringView) -> Bool` | Default caseless equality, without normalization (D144). |
| `canonical_case_fold(StringView) -> String` | Canonical caseless comparison/search key (D145). |
| `canonical_caseless_match(StringView, StringView) -> Bool` | Caseless equality under canonical equivalence (D145). |
| `nfkc_casefold(StringView) -> String` | Official NFKC_CF mapping followed by NFC (R5). |
| `identifier_caseless_match(StringView, StringView) -> Bool` | Identifier caseless equality after initial NFD (D147). |

All text inputs accept `StringView`, including slices of larger strings.
Existing calls with `String` arguments work through automatic view conversion.
Text-producing operations still return `String`.
