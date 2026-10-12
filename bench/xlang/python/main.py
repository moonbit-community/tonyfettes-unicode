"""Python peer of bench/xlang/moonbit: normalization with the standard
library's unicodedata, on the same inputs, timed with the same protocol and
printed in the same row format."""

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
    """Double the iteration count until one sample takes at least 10 ms, then
    print the fastest of 12 samples as library<TAB>case<TAB>ns<TAB>units<TAB>check.
    The library column is empty: this harness has one library."""
    iterations = 1
    while run(iterations, f) < 1e7:
        iterations *= 2
    best = min(run(iterations, f) for _ in range(12))
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


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("usage: main.py <inputs> [group]")
    if len(sys.argv) < 3 or sys.argv[2] == "norm":
        bench_normalization(sys.argv[1])
