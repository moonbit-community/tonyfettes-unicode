# Case folding benchmark

Times `moonbit-community/unicode-casefold` on four of the
[`bench/normperf`](../normperf/README.md) corpora: English prose (`vfear11a`)
and personal names in Latin, Cyrillic and Han script.

```sh
moon bench ./bench/casefoldperf --target native
```

| Case | Measures |
|---|---|
| `case_fold` | Full default case folding of the corpus |
| `case_fold/folded` | The same on already folded text, which is copied unchanged |
| `nfkc_casefold` | NFKC_Casefold, including its final NFC |
| `caseless_match/same` | `caseless_match` of the corpus with itself |
| `caseless_match/upper` | `caseless_match` of the corpus with its full uppercase mapping |

## Example results

One run on an Apple M3 Max, native backend, in nanoseconds per code point.
"Before" looked every code point up with a binary search over all mappings
and folded both strings to compare them; "after" uses the kind trie, skips
ASCII without decoding it, copies unchanged runs at once and compares equal
code units before decoding anything.

| Corpus | Case | Before | After |
|---|---|---:|---:|
| `vfear11a` | `case_fold` | 10.8 | 0.82 |
| | `case_fold/folded` | 10.2 | 0.46 |
| | `nfkc_casefold` | 12.9 | 0.86 |
| | `caseless_match/same` | 21.6 | 0.56 |
| | `caseless_match/upper` | 32.7 | 3.87 |
| `TestNames_Latin` | `case_fold` | 11.9 | 1.83 |
| | `nfkc_casefold` | 14.1 | 1.86 |
| | `caseless_match/upper` | 33.5 | 3.15 |
| `TestNames_Russian` | `case_fold` | 13.5 | 3.81 |
| | `nfkc_casefold` | 15.3 | 4.16 |
| | `caseless_match/upper` | 33.1 | 4.82 |
| `TestNames_Chinese` | `case_fold` | 10.1 | 2.20 |
| | `nfkc_casefold` | 14.7 | 2.50 |
| | `caseless_match/upper` | 21.2 | 0.57 |
