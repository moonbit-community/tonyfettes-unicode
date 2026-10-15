# unicode-normalization

Unicode NFC, NFD, NFKC, and NFKD normalization for MoonBit, using Unicode
18.0.0 data from `moonbit-community/unicode-data`.

```bash
moon add moonbit-community/unicode-normalization
```

See the repository root README for API documentation and examples.

All text inputs accept `StringView`, including slices of larger strings.
Existing calls with `String` arguments work through automatic view conversion.
Text-producing operations still return `String`.
