# unicode-idna

Unicode IDNA processing for MoonBit following UTS #46 and Unicode 18.0.0.

```bash
moon add moonbit-community/unicode-idna
```

`to_ascii` and `to_unicode` use UTS #46 mapping, NFC normalization, and label
validation. Both accept optional IDNA2008 checks:

- `check_idna2008=true` restricts the resulting Unicode labels to the IDNA2008
  `PVALID`, `CONTEXTJ`, and `CONTEXTO` categories. Other code points raise
  `DisallowedCodePoint(cp~)`. This only checks the repertoire; `check_joiners`
  remains responsible for validating `CONTEXTJ` characters in context.
- `check_contexto=true` independently validates the RFC 5892 ContextO rules.
  Violations raise `InvalidContextO(cp~)`.

Both new options default to `false`. They also check Unicode labels decoded
from Punycode. Enable both alongside the default checks to combine IDNA2008
repertoire and contextual validation with the existing label checks.

```moonbit
let ascii = try! @idna.to_ascii(
  "ÖBB.at",
  check_idna2008=true,
  check_contexto=true,
)
// "xn--bb-eka.at"
```

The input still undergoes UTS #46 mapping: the example accepts and lowercases
`ÖBB.at`. These options do not provide strict validation of unmodified IDNA2008
input. Symbols such as `☕` are rejected by `check_idna2008` even though UTS #46
allows them.

See the repository root README for the remaining options and examples.
