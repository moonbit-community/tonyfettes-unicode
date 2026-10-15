# unicode

`moonbit-community/unicode` is the compatibility umbrella for the Unicode
library that is split into independently consumable modules. It preserves the
original package paths for existing users by forwarding to the feature modules.

The generated tables target Unicode 18.0.0.

## Packages

| Package | Contents |
| --- | --- |
| `moonbit-community/unicode` | General_Category, East_Asian_Width, Line_Break, Joining_Type, Joining_Group, Hangul_Syllable_Type, binary properties (White_Space, Alphabetic, Lowercase, Uppercase, XID_Start, XID_Continue, Default_Ignorable_Code_Point, Grapheme_Extend, Regional_Indicator, Prepended_Concatenation_Mark, Emoji_Presentation, Emoji_Modifier, Emoji_Modifier_Base), emoji variation sequences, and case mapping |
| `moonbit-community/unicode/normalization` | Normalization Forms from UAX #15 |
| `moonbit-community/unicode/casefold` | Full case folding, canonical caseless matching, and NFKC_Casefold |
| `moonbit-community/unicode/punycode` | Punycode from RFC 3492 |
| `moonbit-community/unicode/bidi` | Bidirectional algorithm from UAX #9 |
| `moonbit-community/unicode/idna` | IDNA processing from UTS #46 |

New code should depend on the feature module it needs directly:

```bash
moon add moonbit-community/unicode-data
moon add moonbit-community/unicode-normalization
moon add moonbit-community/unicode-casefold
moon add moonbit-community/punycode
moon add moonbit-community/unicode-bidi
moon add moonbit-community/unicode-idna
```

See the repository README for the full API reference, development commands,
and release instructions.
