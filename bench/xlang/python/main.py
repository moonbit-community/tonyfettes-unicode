"""Python peer of bench/xlang/moonbit: normalization with the standard
library's unicodedata and full case folding with str.casefold, on the same
inputs, timed with the same protocol and printed in the same row format."""

import os
import sys
import time
import unicodedata


def run(iterations, f):
    start = time.perf_counter_ns()
    for _ in range(iterations):
        f()
    return time.perf_counter_ns() - start


def measure(name, units, check, f):
    """Double the iteration count until one sample takes at least 5 ms, then
    print the fastest of 5 samples, the first of which is that one, as
    library<TAB>case<TAB>ns<TAB>units<TAB>check.
    The library column is empty: this harness has one library."""
    iterations = 1
    first = run(iterations, f)
    while first < 5e6:
        iterations *= 2
        first = run(iterations, f)
    best = min([first] + [run(iterations, f) for _ in range(4)])
    print(f"\t{name}\t{best / iterations}\t{units}\t{check}", flush=True)


def read(path):
    with open(path, encoding="utf-8", newline="") as file:
        return file.read()


def names(directory):
    """Input names in `directory`: the .txt files without their extension."""
    return sorted(file[:-4] for file in os.listdir(directory) if file.endswith(".txt"))


def bench_normalization(inputs):
    normalize = unicodedata.normalize
    for name in names(f"{inputs}/norm"):
        original = read(f"{inputs}/norm/{name}.txt")
        decomposed = read(f"{inputs}/normd/{name}.txt")
        for form in ["NFC", "NFD", "NFKC", "NFKD"]:
            measure(f"norm/{form.lower()}/{name}", len(original), len(normalize(form, original)),
                    lambda: normalize(form, original))
        measure(f"norm/nfd>nfc/{name}", len(decomposed), len(normalize("NFC", decomposed)),
                lambda: normalize("NFC", decomposed))
        measure(f"norm/is_nfc/{name}", len(original),
                int(unicodedata.is_normalized("NFC", original)),
                lambda: unicodedata.is_normalized("NFC", original))


def bench_case(inputs):
    for name in names(f"{inputs}/case"):
        text = read(f"{inputs}/case/{name}.txt")
        measure(f"case/fold/{name}", len(text), len(text.casefold()), text.casefold)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("usage: main.py <inputs> [group]")
    group = sys.argv[2] if len(sys.argv) > 2 else None
    for selected, bench in [("norm", bench_normalization), ("case", bench_case)]:
        if group in (None, selected):
            bench(sys.argv[1])
