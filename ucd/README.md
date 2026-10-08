# ucd

Unicode Character Database lookup, general categories, binary properties
(White_Space, Alphabetic, Lowercase, Uppercase, XID_Start, XID_Continue), and
case mapping for MoonBit. This module uses Unicode 16.0.0 data.

```bash
moon add moonbit-community/ucd
```

See the repository root README for API documentation and examples.

## Low-level data packages

Import the package for the lookup you need. Each package owns its generated
tables and exposes lookup functions; the tables themselves remain private.

| Package under `moonbit-community/ucd/` | Lookups |
| --- | --- |
| `decomposition` | Canonical and compatibility decomposition mappings |
| `composition` | Composition pairs and composition exclusions |
| `ccc` | Canonical Combining Class |
| `general_category` | General Category ordinal and `is_mark` |
| `case_mapping` | Simple and full uppercase, lowercase, and titlecase mappings |
| `xid` | XID_Start and XID_Continue |
| `alphabetic` | Alphabetic |
| `lowercase` | Lowercase |
| `uppercase` | Uppercase |
| `white_space` | White_Space |

`moonbit-community/ucd/data` remains a compatibility package that re-exports
the old lookup functions with deprecation notices pointing to these packages.
The high-level `moonbit-community/ucd` interface is unchanged: its
`general_category(c)` returns `GeneralCategory`, with `GeneralCategoryGroup`
available through `.group()`. These enums remain defined in the root package.
The low-level `general_category` package retains
`lookup_general_category(c) -> Int`, returning the existing 0–29 category
ordinals.
