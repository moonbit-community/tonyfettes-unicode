#!/usr/bin/env python3
"""Summarize fastest samples and process medians; separate early exits from full scans."""
import argparse
import csv
import json
from pathlib import Path
import statistics


def summarize(directory):
    environment = json.loads((directory / 'environment.json').read_text())
    metadata = {(x['name'], x['state']): x for x in json.loads((directory / 'inputs.json').read_text())}
    measurements = {}
    typical = {}
    for engine in ['icu', 'native', 'wasm', 'wasm-gc']:
        runs = []
        for index in range(1, environment['repeats'] + 1):
            path = directory / f'{engine}-{index}.jsonl'
            if not path.exists():
                if engine == 'icu' or index > 1:
                    raise ValueError(f'Missing results: {path}')
                break
            rows = [json.loads(line) for line in path.read_text().splitlines()]
            if len({x['name'] for x in rows}) != len(rows):
                raise ValueError(f'Duplicate cases: {path}')
            runs.append({x['name']: x['samples_us'] for x in rows})
        if runs:
            keys = set(runs[0])
            if any(set(run) != keys for run in runs):
                raise ValueError(f'Case mismatch across {engine} runs')
            measurements[engine] = {key: min(value for run in runs for value in run[key]) for key in keys}
            typical[engine] = {key: statistics.mean(statistics.median(run[key]) for run in runs) for key in keys}
    records = []
    for key, icu_time in sorted(measurements['icu'].items()):
        name, state, form, operation = key.split('/')
        if operation == 'normalize_reuse':
            continue
        meta = metadata[name, state]
        row = dict(corpus=name, input=state, form=form, operation=operation,
                   already_normalized=meta['is_' + form.lower()], utf16_units=meta['utf16_units'],
                   codepoints=meta['codepoints'], icu_us=icu_time, icu_mean_median_us=typical['icu'][key])
        row['icu_reuse_us'] = measurements['icu'][key.replace('/normalize', '/normalize_reuse')] if operation == 'normalize' else ''
        for engine, cases in measurements.items():
            if engine == 'icu':
                continue
            row[engine + '_us'] = cases[key]
            row[engine + '_mean_median_us'] = typical[engine][key]
            row[engine + '_over_icu'] = cases[key] / icu_time
        records.append(row)
    with (directory / 'comparison.csv').open('w') as f:
        writer = csv.DictWriter(f, fieldnames=list(records[0]))
        writer.writeheader()
        writer.writerows(records)
    engines = [name for name in measurements if name != 'icu']
    lines = ['# ICU normperf corpus comparison', '',
             f'Normalization source: `{environment["source_revision"]}`. ICU {environment["icu"]}, Unicode {environment["unicode"]}.',
             '', 'Full-file/bulk inputs; 14 corpora × original/NFC/NFD input × NFC/NFD target × normalize/check.',
             f'Times are microseconds per complete API call. Primary results use the fastest of {environment["repeats"] * 5} samples across {environment["repeats"]} processes, following the ICU perf fastest-pass convention. CSV also includes means of process medians.',
             ('**Measurement limitation:** ' + environment['load_note']) if environment.get('load_note') else 'Inspect raw sample variation before interpreting small differences.',
             'Ratios > 1 mean MoonBit takes longer. Wasm and Wasm-GC columns compare against **native ICU**, so include backend/runtime differences.',
             '', '## Geometric mean of per-case time ratios', '',
             '| Operation | Input status | Cases | ' + ' | '.join(engines) + ' |',
             '| --- | --- | ---: | ' + ' | '.join(['---:'] * len(engines)) + ' |']
    groups = []
    for operation in ['normalize', 'check']:
        for form in ['NFC', 'NFD']:
            for normalized in [True, False]:
                subset = [r for r in records if r['operation'] == operation and r['form'] == form and r['already_normalized'] == normalized]
                if not subset:
                    continue
                values = {e: statistics.geometric_mean(r[e+'_over_icu'] for r in subset) for e in engines}
                status = 'already normalized' if normalized else ('requires change' if operation == 'normalize' else 'false / may exit early')
                lines.append('| ' + operation + ' ' + form + ' | ' + status + f' | {len(subset)} | ' + ' | '.join(f'{v:.2f}×' for v in values.values()) + ' |')
                groups.append(dict(operation=operation, form=form, already_normalized=normalized, cases=len(subset), ratios=values))
    lines += ['', 'Cases are equally weighted, including duplicate content across input states. These are corpus-specific aggregates, not universal speed factors.',
              'False checks may stop near the beginning; their whole-input size is **not** processed throughput. Their sub-microsecond ratios also include harness overhead.',
              '', '## NFC conversion from NFD input', '',
              '| Corpus | UTF-16 units | Changes? | ICU fresh µs | ICU reuse µs | ' + ' | '.join(e + ' µs (ratio)' for e in engines) + ' |',
              '| --- | ---: | --- | ---: | ---: | ' + ' | '.join(['---:'] * len(engines)) + ' |']
    for row in records:
        if row['operation'] == 'normalize' and row['form'] == 'NFC' and row['input'] == 'nfd':
            lines.append(f'| {row["corpus"]} | {row["utf16_units"]} | {not row["already_normalized"]} | {row["icu_us"]:.2f} | {row["icu_reuse_us"]:.2f} | ' +
                         ' | '.join(f'{row[e+"_us"]:.2f} ({row[e+"_over_icu"]:.2f}×)' for e in engines) + ' |')
    lines += ['', '## Interpretation and reproducibility', '',
              '- ICU `normalize` uses a fresh C++ `UnicodeString` per call. `normalize_reuse` uses `unorm2_normalize` with a buffer allocated before timing, as in normperf. Both are validated against the same complete expected output.',
              '- MoonBit uses the public `normalize` / `is_normalized` APIs and `@bench.keep` to retain results. Its unchanged-string path can return the original string; fresh ICU output may copy it. This API/ownership distinction is part of the measured result.',
              '- Corpus download, BOM decoding, creation of normalized variants, initialization, and correctness comparisons are outside the timer. Every MoonBit result and predicate is checked against ICU before measurement on every target and run.',
              '- Five samples target 20 ms each after adaptive calibration of at least 10 ms. Engines run sequentially; order rotates between the three executions.',
              '- Only NFC/NFD are included, the shared forms in the original normperf matrix. This is a standalone harness reusing its full corpora and bulk input matrix, not the upstream executable or its five-second/ten-pass timing configuration.',
              '- The fastest-sample convention follows [ICU perf methodology](https://github.com/unicode-org/icu-perf#performance-test-methodology); timing duration differs. Mean-of-median columns expose how much loaded-machine timings diverged.',
              '- Raw samples: `*-1.jsonl` through `*-3.jsonl`; every case including original-text and NFD results: [comparison.csv](comparison.csv). Toolchain details: [environment.json](environment.json). Input lengths and hashes: [inputs.json](inputs.json).',
              '- Reproduce from repository root: `python3 benchmarks/normperf/run.py --icu-prefix /path/to/icu77 --output /tmp/normperf-results`, then `python3 benchmarks/normperf/summarize.py /tmp/normperf-results`.', '']
    (directory / 'summary.md').write_text('\n'.join(lines))
    (directory / 'groups.json').write_text(json.dumps(groups, indent=2) + '\n')
    print('\n'.join(lines[:25]))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    summarize(parser.parse_args().directory)
