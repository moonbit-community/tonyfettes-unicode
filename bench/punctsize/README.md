# Punctuation artifact size

Compare the compiled package units behind the two ways to test punctuation:

```moonbit
@unicode.is_punctuation(c)
@unicode.general_category(c).group() is @unicode.GeneralCategoryGroup::P
```

Build the two low-level packages at release:

```sh
moon build --target wasm-gc --release ucd/punctuation
moon build --target wasm-gc --release ucd/general_category
```

Then compare their `.core` package artifacts:

```sh
wc -c \
  _build/wasm-gc/release/build/moonbit-community/unicode-data/punctuation/punctuation.core \
  _build/wasm-gc/release/build/moonbit-community/unicode-data/general_category/general_category.core
```

Example `wasm-gc` release sizes:

| Package | `.core` bytes |
| --- | ---: |
| `punctuation` | 3,731 |
| `general_category` | 44,223 |

The `.core` file is the compiled package artifact that the linker pulls in when
the predicate is used; it contains the lookup function and its table. Measuring
it needs no executable probe and no artificial result consumer. The difference
is the General_Category trie, which the punctuation package does not link.
