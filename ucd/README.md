# unicode-data

Unicode Character Database lookup, general categories, East Asian width,
line break classes, joining types and groups, Hangul syllable types, binary
properties (White_Space, Alphabetic, Lowercase, Uppercase, XID_Start,
XID_Continue, Default_Ignorable_Code_Point, Grapheme_Extend,
Regional_Indicator, Prepended_Concatenation_Mark, Emoji_Presentation,
Emoji_Modifier, Emoji_Modifier_Base, Extended_Pictographic), emoji variation sequences, and case
mapping for MoonBit. This module uses Unicode 18.0.0 data.

```bash
moon add moonbit-community/unicode-data
```

See the repository root README for API documentation and examples.

## Low-level data packages

Import the package for the lookup you need. Each package owns its generated
tables and exposes lookup functions; the tables themselves remain private.

| Package under `moonbit-community/unicode-data/` | Lookups |
| --- | --- |
| `decomposition` | Canonical and compatibility decomposition mappings |
| `composition` | Composition pairs and composition exclusions |
| `ccc` | Canonical Combining Class |
| `general_category` | General Category ordinal and `is_mark` |
| `east_asian_width` | East_Asian_Width ordinal |
| `case_mapping` | Simple and full uppercase, lowercase, and titlecase mappings |
| `xid` | XID_Start and XID_Continue |
| `alphabetic` | Alphabetic |
| `lowercase` | Lowercase |
| `uppercase` | Uppercase |
| `white_space` | White_Space |
| `default_ignorable_code_point` | Default_Ignorable_Code_Point |
| `grapheme_extend` | Grapheme_Extend |
| `regional_indicator` | Regional_Indicator |
| `prepended_concatenation_mark` | Prepended_Concatenation_Mark |
| `emoji` | Extended_Pictographic, Emoji_Presentation, Emoji_Modifier, Emoji_Modifier_Base, and the characters starting an emoji variation sequence |
| `joining_type` | Joining_Type ordinal |
| `joining_group` | Joining_Group ordinal |
| `hangul_syllable_type` | Hangul_Syllable_Type ordinal |
| `line_break` | Line_Break ordinal |

`moonbit-community/unicode-data/data` remains a compatibility package that re-exports
the old lookup functions with deprecation notices pointing to these packages.
The high-level `moonbit-community/unicode-data` interface is unchanged: its
`general_category(c)` returns `GeneralCategory`, with `GeneralCategoryGroup`
available through `.group()`. These enums remain defined in the root package.
The low-level `general_category` package retains
`lookup_general_category(c) -> Int`, returning the existing 0–29 category
ordinals.
