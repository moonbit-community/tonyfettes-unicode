# Case mapping benchmark

Times the string-level full case mappings of `moonbit-community/unicode-data`,
`@ucd.uppercase` and `@ucd.lowercase`, on four short texts and four of the
[`bench/normperf`](../normperf/README.md) corpora: English prose (`vfear11a`)
and personal names in Latin, Cyrillic and Han script.

```sh
moon bench ./bench/casemapperf --target native
```

| Case | Measures |
|---|---|
| `uppercase` | Full uppercase mapping of the text |
| `uppercase/upper` | The same on uppercased text, which is returned unchanged |
| `lowercase` | Full lowercase mapping of the text |
| `uppercase_by_char` | `@ucd.to_uppercase` on every character, appended to one builder: what callers wrote before `uppercase` |

## Example results

One run on an Apple M3 Max, native backend, in microseconds per call.

| Text | `uppercase_by_char` | `uppercase` | `uppercase/upper` | `lowercase` |
|---|---:|---:|---:|---:|
| ASCII | 3.11 | 0.28 | 0.24 | 0.28 |
| Latin | 8.19 | 1.97 | 0.81 | 1.20 |
| Greek | 17.5 | 2.71 | 1.11 | 1.51 |
| CJK | 20.1 | 1.25 | 1.27 | 1.26 |
| `vfear11a` | 1070 | 94.0 | 75.4 | 92.7 |
| `TestNames_Latin` | 471 | 57.8 | 34.8 | 56.9 |
| `TestNames_Russian` | 888 | 145 | 72.5 | 101 |
| `TestNames_Chinese` | 908 | 66.4 | 61.9 | 64.5 |
