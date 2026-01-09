#!/usr/bin/env python3
"""
Generate MoonBit source files from Unicode Character Database files.

This script downloads and parses:
- UnicodeData.txt: CCC values, decomposition mappings
- CompositionExclusions.txt: Characters excluded from NFC composition

And generates:
- internal/ucd/ccc.mbt: Canonical Combining Class lookup
- internal/ucd/decomposition.mbt: Decomposition mappings
- internal/ucd/composition.mbt: Composition table and exclusions
"""

import os
import sys
import urllib.request
from pathlib import Path
from collections import defaultdict

# Unicode data URLs
UNICODE_VERSION = "16.0.0"
BASE_URL = f"https://www.unicode.org/Public/{UNICODE_VERSION}/ucd"
UNICODE_DATA_URL = f"{BASE_URL}/UnicodeData.txt"
COMPOSITION_EXCLUSIONS_URL = f"{BASE_URL}/CompositionExclusions.txt"

# Hangul constants - handled algorithmically, not in tables
HANGUL_S_BASE = 0xAC00
HANGUL_S_COUNT = 11172


def download_file(url: str, cache_dir: Path) -> str:
    """Download a file and cache it locally."""
    filename = url.split("/")[-1]
    cache_path = cache_dir / filename

    if cache_path.exists():
        print(f"Using cached {filename}")
        return cache_path.read_text()

    print(f"Downloading {filename}...")
    with urllib.request.urlopen(url) as response:
        content = response.read().decode("utf-8")

    cache_path.write_text(content)
    return content


def parse_unicode_data(content: str) -> tuple[dict, dict, dict, set]:
    """
    Parse UnicodeData.txt and extract:
    - ccc_data: code_point -> canonical_combining_class
    - canonical_decomp: code_point -> [decomposed_cps]
    - compat_decomp: code_point -> [decomposed_cps]
    - mark_cps: set of code points with General_Category = Mark (Mn, Mc, Me)
    """
    ccc_data = {}
    canonical_decomp = {}
    compat_decomp = {}
    mark_cps = set()

    for line in content.strip().split("\n"):
        if not line or line.startswith("#"):
            continue

        fields = line.split(";")
        if len(fields) < 6:
            continue

        cp = int(fields[0], 16)

        # Skip Hangul syllables - handled algorithmically
        if HANGUL_S_BASE <= cp < HANGUL_S_BASE + HANGUL_S_COUNT:
            continue

        # Field 2: General Category
        general_category = fields[2].strip()
        if general_category.startswith("M"):  # Mn, Mc, Me
            mark_cps.add(cp)

        # Field 3: Canonical Combining Class
        ccc = int(fields[3]) if fields[3] else 0
        if ccc != 0:
            ccc_data[cp] = ccc

        # Field 5: Decomposition mapping
        decomp = fields[5].strip()
        if decomp:
            # Check for compatibility decomposition tag
            if decomp.startswith("<"):
                # Compatibility decomposition: <tag> followed by code points
                parts = decomp.split(">", 1)
                if len(parts) > 1:
                    cps = [int(x, 16) for x in parts[1].strip().split()]
                    if cps:
                        compat_decomp[cp] = cps
            else:
                # Canonical decomposition: just code points
                cps = [int(x, 16) for x in decomp.split()]
                if cps:
                    canonical_decomp[cp] = cps

    return ccc_data, canonical_decomp, compat_decomp, mark_cps


def parse_composition_exclusions(content: str) -> set[int]:
    """Parse CompositionExclusions.txt and return set of excluded code points."""
    exclusions = set()

    for line in content.strip().split("\n"):
        line = line.split("#")[0].strip()
        if not line:
            continue

        # Handle ranges (though this file typically has single code points)
        if ".." in line:
            start, end = line.split("..")
            for cp in range(int(start, 16), int(end, 16) + 1):
                exclusions.add(cp)
        else:
            exclusions.add(int(line, 16))

    return exclusions


def build_composition_table(canonical_decomp: dict, exclusions: set) -> dict:
    """
    Build composition table from decompositions.
    A pair (first, second) composes to cp if:
    - cp has canonical decomposition [first, second]
    - cp is not in composition exclusions
    - first is a starter (CCC=0) - implicitly true for first chars in decomp
    """
    composition = {}

    for cp, decomp in canonical_decomp.items():
        if len(decomp) != 2:
            continue
        if cp in exclusions:
            continue

        first, second = decomp
        composition[(first, second)] = cp

    return composition


def compress_ccc_ranges(ccc_data: dict) -> list[tuple[int, int, int]]:
    """
    Compress CCC data into ranges of (start, end, ccc) where consecutive
    code points have the same CCC value.
    """
    if not ccc_data:
        return []

    sorted_cps = sorted(ccc_data.keys())
    ranges = []

    start = sorted_cps[0]
    prev_cp = start
    prev_ccc = ccc_data[start]

    for cp in sorted_cps[1:]:
        ccc = ccc_data[cp]
        if cp == prev_cp + 1 and ccc == prev_ccc:
            prev_cp = cp
        else:
            ranges.append((start, prev_cp, prev_ccc))
            start = cp
            prev_cp = cp
            prev_ccc = ccc

    ranges.append((start, prev_cp, prev_ccc))
    return ranges


def compress_mark_ranges(mark_cps: set) -> list[tuple[int, int]]:
    """
    Compress mark code points into ranges of (start, end) where consecutive
    code points are all marks.
    """
    if not mark_cps:
        return []

    sorted_cps = sorted(mark_cps)
    ranges = []

    start = sorted_cps[0]
    prev_cp = start

    for cp in sorted_cps[1:]:
        if cp == prev_cp + 1:
            prev_cp = cp
        else:
            ranges.append((start, prev_cp))
            start = cp
            prev_cp = cp

    ranges.append((start, prev_cp))
    return ranges


def generate_ccc_mbt(ccc_ranges: list[tuple[int, int, int]], mark_ranges: list[tuple[int, int]], output_path: Path):
    """Generate ccc.mbt with CCC lookup data and mark detection."""

    # Store as arrays of (start, end, ccc) tuples
    # Use Int arrays for efficient lookup
    starts = []
    ends = []
    values = []

    for start, end, ccc in ccc_ranges:
        starts.append(start)
        ends.append(end)
        values.append(ccc)

    # Store mark ranges
    mark_starts = []
    mark_ends = []
    for start, end in mark_ranges:
        mark_starts.append(start)
        mark_ends.append(end)

    code = '''///|
/// Canonical Combining Class (CCC) lookup data
/// Generated from UnicodeData.txt

///|
/// CCC range start code points
let ccc_starts : FixedArray[Int] = [
'''

    # Write starts array
    for i, s in enumerate(starts):
        if i > 0:
            code += ",\n"
        code += f"  0x{s:04X}"
    code += "\n]\n\n"

    code += '''///|
/// CCC range end code points (inclusive)
let ccc_ends : FixedArray[Int] = [
'''
    for i, e in enumerate(ends):
        if i > 0:
            code += ",\n"
        code += f"  0x{e:04X}"
    code += "\n]\n\n"

    code += '''///|
/// CCC values for each range
let ccc_values : FixedArray[Int] = [
'''
    for i, v in enumerate(values):
        if i > 0:
            code += ",\n"
        code += f"  {v}"
    code += "\n]\n\n"

    # Add mark ranges
    code += '''///|
/// Mark character range start code points (General_Category = M)
let mark_starts : FixedArray[Int] = [
'''
    for i, s in enumerate(mark_starts):
        if i > 0:
            code += ",\n"
        code += f"  0x{s:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Mark character range end code points (inclusive)
let mark_ends : FixedArray[Int] = [
'''
    for i, e in enumerate(mark_ends):
        if i > 0:
            code += ",\n"
        code += f"  0x{e:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Look up Canonical Combining Class for a code point
/// Returns 0 (starter) for most characters
pub fn lookup_ccc(cp : Int) -> Int {
  // Binary search through ranges
  let mut left = 0
  let mut right = ccc_starts.length() - 1

  while left <= right {
    let mid = (left + right) / 2
    let start = ccc_starts[mid]
    let end = ccc_ends[mid]

    if cp < start {
      right = mid - 1
    } else if cp > end {
      left = mid + 1
    } else {
      return ccc_values[mid]
    }
  }

  0 // Not found, default CCC is 0 (starter)
}

///|
/// Check if a code point is a Mark character (General_Category = Mn, Mc, or Me)
/// This is used for the IDNA "no leading combining mark" validation (V5/V6)
pub fn is_mark(cp : Int) -> Bool {
  // Binary search through mark ranges
  let mut left = 0
  let mut right = mark_starts.length() - 1

  while left <= right {
    let mid = (left + right) / 2
    let start = mark_starts[mid]
    let end = mark_ends[mid]

    if cp < start {
      right = mid - 1
    } else if cp > end {
      left = mid + 1
    } else {
      return true
    }
  }

  false
}
'''

    output_path.write_text(code)
    print(f"Generated {output_path} with {len(ccc_ranges)} CCC ranges and {len(mark_ranges)} mark ranges")


def generate_decomposition_mbt(
    canonical_decomp: dict,
    compat_decomp: dict,
    output_path: Path
):
    """Generate decomposition.mbt with decomposition lookup data."""

    # Merge canonical and compat for unified storage
    # Store flag to distinguish them
    all_decomp = {}
    for cp, decomp in canonical_decomp.items():
        all_decomp[cp] = (decomp, False)  # False = canonical
    for cp, decomp in compat_decomp.items():
        if cp in all_decomp:
            # Already has canonical, add compat
            all_decomp[cp] = (all_decomp[cp][0], decomp)
        else:
            all_decomp[cp] = (None, decomp)  # None = no canonical, just compat

    # Sort by code point for binary search
    sorted_cps = sorted(all_decomp.keys())

    # Build index and data arrays
    # Index: [cp, data_start, canonical_len, compat_len]
    # Data: flattened decomposition code points

    index_cps = []
    index_data_starts = []
    index_canonical_lens = []
    index_compat_lens = []
    data = []

    for cp in sorted_cps:
        canonical, compat = all_decomp[cp]

        index_cps.append(cp)
        index_data_starts.append(len(data))

        if canonical:
            index_canonical_lens.append(len(canonical))
            data.extend(canonical)
        else:
            index_canonical_lens.append(0)

        if isinstance(compat, list):
            index_compat_lens.append(len(compat))
            data.extend(compat)
        else:
            index_compat_lens.append(0)

    code = '''///|
/// Decomposition mapping data
/// Generated from UnicodeData.txt

///|
/// Code points with decomposition mappings (sorted for binary search)
let decomp_cps : FixedArray[Int] = [
'''
    for i, cp in enumerate(index_cps):
        if i > 0:
            code += ",\n"
        code += f"  0x{cp:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Data start index for each code point
let decomp_data_starts : FixedArray[Int] = [
'''
    for i, s in enumerate(index_data_starts):
        if i > 0:
            code += ",\n"
        code += f"  {s}"
    code += "\n]\n\n"

    code += '''///|
/// Canonical decomposition length (0 if none)
let decomp_canonical_lens : FixedArray[Int] = [
'''
    for i, l in enumerate(index_canonical_lens):
        if i > 0:
            code += ",\n"
        code += f"  {l}"
    code += "\n]\n\n"

    code += '''///|
/// Compatibility decomposition length (0 if none)
let decomp_compat_lens : FixedArray[Int] = [
'''
    for i, l in enumerate(index_compat_lens):
        if i > 0:
            code += ",\n"
        code += f"  {l}"
    code += "\n]\n\n"

    code += '''///|
/// Decomposition data (flattened code points)
let decomp_data : FixedArray[Int] = [
'''
    for i, d in enumerate(data):
        if i > 0:
            code += ",\n"
        code += f"  0x{d:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Binary search for code point index, returns -1 if not found
fn find_decomp_index(cp : Int) -> Int {
  let mut left = 0
  let mut right = decomp_cps.length() - 1

  while left <= right {
    let mid = (left + right) / 2
    let mid_cp = decomp_cps[mid]

    if cp < mid_cp {
      right = mid - 1
    } else if cp > mid_cp {
      left = mid + 1
    } else {
      return mid
    }
  }

  -1
}

///|
/// Get canonical decomposition for a code point
/// Returns None if no decomposition exists
pub fn get_canonical_decomposition(cp : Int) -> Array[Int]? {
  let idx = find_decomp_index(cp)
  if idx < 0 {
    return None
  }

  let len = decomp_canonical_lens[idx]
  if len == 0 {
    return None
  }

  let start = decomp_data_starts[idx]
  let result : Array[Int] = []
  for i = 0; i < len; i = i + 1 {
    result.push(decomp_data[start + i])
  }
  Some(result)
}

///|
/// Get compatibility decomposition for a code point
/// Returns None if no decomposition exists
pub fn get_compat_decomposition(cp : Int) -> Array[Int]? {
  let idx = find_decomp_index(cp)
  if idx < 0 {
    return None
  }

  let compat_len = decomp_compat_lens[idx]
  if compat_len == 0 {
    return None
  }

  // Compat data comes after canonical data
  let canonical_len = decomp_canonical_lens[idx]
  let start = decomp_data_starts[idx] + canonical_len
  let result : Array[Int] = []
  for i = 0; i < compat_len; i = i + 1 {
    result.push(decomp_data[start + i])
  }
  Some(result)
}
'''

    output_path.write_text(code)
    print(f"Generated {output_path} with {len(sorted_cps)} decompositions, {len(data)} data points")


def generate_composition_mbt(
    composition: dict,
    exclusions: set,
    ccc_data: dict,
    canonical_decomp: dict,
    output_path: Path
):
    """Generate composition.mbt with composition lookup data."""

    # For composition, we need to be able to look up: (starter, combining) -> composed
    # Store as parallel arrays sorted by (first, second) for binary search

    sorted_pairs = sorted(composition.keys())

    firsts = []
    seconds = []
    results = []

    for first, second in sorted_pairs:
        firsts.append(first)
        seconds.append(second)
        results.append(composition[(first, second)])

    # Build full exclusion list including:
    # 1. Explicit exclusions from CompositionExclusions.txt
    # 2. Singletons (decomposition to single character)
    # 3. Non-starter decompositions (first char has CCC > 0)
    full_exclusions = set(exclusions)

    for cp, decomp in canonical_decomp.items():
        # Singleton exclusion
        if len(decomp) == 1:
            full_exclusions.add(cp)
        # Non-starter decomposition
        elif len(decomp) > 0 and ccc_data.get(decomp[0], 0) > 0:
            full_exclusions.add(cp)

    sorted_exclusions = sorted(full_exclusions)

    code = '''///|
/// Composition lookup data
/// Generated from UnicodeData.txt and CompositionExclusions.txt

///|
/// First code points of composition pairs (sorted)
let comp_firsts : FixedArray[Int] = [
'''
    for i, f in enumerate(firsts):
        if i > 0:
            code += ",\n"
        code += f"  0x{f:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Second code points of composition pairs
let comp_seconds : FixedArray[Int] = [
'''
    for i, s in enumerate(seconds):
        if i > 0:
            code += ",\n"
        code += f"  0x{s:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Composed result code points
let comp_results : FixedArray[Int] = [
'''
    for i, r in enumerate(results):
        if i > 0:
            code += ",\n"
        code += f"  0x{r:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Composition exclusions (sorted for binary search)
let comp_exclusions : FixedArray[Int] = [
'''
    for i, e in enumerate(sorted_exclusions):
        if i > 0:
            code += ",\n"
        code += f"  0x{e:04X}"
    code += "\n]\n\n"

    code += '''///|
/// Look up composition for a pair of code points
/// Returns Some(composed) if composition exists, None otherwise
pub fn lookup_composition(starter : Int, combining : Int) -> Int? {
  // Binary search for the pair
  let mut left = 0
  let mut right = comp_firsts.length() - 1

  while left <= right {
    let mid = (left + right) / 2
    let mid_first = comp_firsts[mid]
    let mid_second = comp_seconds[mid]

    if starter < mid_first || (starter == mid_first && combining < mid_second) {
      right = mid - 1
    } else if starter > mid_first || (starter == mid_first && combining > mid_second) {
      left = mid + 1
    } else {
      return Some(comp_results[mid])
    }
  }

  None
}

///|
/// Check if a code point is excluded from composition
pub fn is_composition_excluded(cp : Int) -> Bool {
  // Binary search in exclusions
  let mut left = 0
  let mut right = comp_exclusions.length() - 1

  while left <= right {
    let mid = (left + right) / 2
    let mid_cp = comp_exclusions[mid]

    if cp < mid_cp {
      right = mid - 1
    } else if cp > mid_cp {
      left = mid + 1
    } else {
      return true
    }
  }

  false
}
'''

    output_path.write_text(code)
    print(f"Generated {output_path} with {len(sorted_pairs)} compositions, {len(sorted_exclusions)} exclusions")


def main():
    # Determine paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    cache_dir = script_dir / ".cache"
    ucd_dir = project_root / "internal" / "ucd"

    cache_dir.mkdir(exist_ok=True)
    ucd_dir.mkdir(parents=True, exist_ok=True)

    # Download data files
    unicode_data = download_file(UNICODE_DATA_URL, cache_dir)
    exclusions_data = download_file(COMPOSITION_EXCLUSIONS_URL, cache_dir)

    # Parse data
    print("Parsing UnicodeData.txt...")
    ccc_data, canonical_decomp, compat_decomp, mark_cps = parse_unicode_data(unicode_data)
    print(f"  Found {len(ccc_data)} non-zero CCC entries")
    print(f"  Found {len(canonical_decomp)} canonical decompositions")
    print(f"  Found {len(compat_decomp)} compatibility decompositions")
    print(f"  Found {len(mark_cps)} mark characters")

    print("Parsing CompositionExclusions.txt...")
    exclusions = parse_composition_exclusions(exclusions_data)
    print(f"  Found {len(exclusions)} explicit exclusions")

    print("Building composition table...")
    composition = build_composition_table(canonical_decomp, exclusions)
    print(f"  Found {len(composition)} composition pairs")

    # Generate MoonBit files
    print("\nGenerating MoonBit source files...")

    # CCC and mark data
    ccc_ranges = compress_ccc_ranges(ccc_data)
    mark_ranges = compress_mark_ranges(mark_cps)
    generate_ccc_mbt(ccc_ranges, mark_ranges, ucd_dir / "ccc.mbt")

    # Decomposition data
    generate_decomposition_mbt(canonical_decomp, compat_decomp, ucd_dir / "decomposition.mbt")

    # Composition data
    generate_composition_mbt(composition, exclusions, ccc_data, canonical_decomp, ucd_dir / "composition.mbt")

    # Remove the stub file if it exists
    stub_file = ucd_dir / "ucd.mbt"
    if stub_file.exists():
        stub_file.unlink()
        print(f"Removed stub file {stub_file}")

    print("\nDone!")


if __name__ == "__main__":
    main()
