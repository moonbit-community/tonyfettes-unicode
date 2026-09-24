# unicode

`moonbit-community/unicode` is the compatibility umbrella for the Unicode
library that is split into independently consumable modules. It preserves the
original package paths for existing users by forwarding to the feature modules.

The generated tables target Unicode 16.0.0.

## Packages

| Package | Contents |
| --- | --- |
| `moonbit-community/unicode` | General_Category, binary properties (White_Space, Alphabetic, Lowercase, Uppercase, XID_Start, XID_Continue), and case mapping |
| `moonbit-community/unicode/normalization` | Normalization Forms from UAX #15 |
| `moonbit-community/unicode/punycode` | Punycode from RFC 3492 |
| `moonbit-community/unicode/bidi` | Bidirectional algorithm from UAX #9 |
| `moonbit-community/unicode/idna` | IDNA processing from UTS #46 |

New code should depend on the feature module it needs directly:

```bash
moon add moonbit-community/ucd
moon add moonbit-community/normalization
moon add moonbit-community/punycode
moon add moonbit-community/bidi
moon add moonbit-community/idna
```

See the repository README for the full API reference, development commands,
and release instructions.
