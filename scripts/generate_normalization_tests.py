#!/usr/bin/env python3
"""
Generate MoonBit conformance tests from Unicode NormalizationTest.txt.

This script downloads and parses NormalizationTest.txt and generates
a MoonBit test file that verifies the normalization implementation
against the official Unicode test suite.
"""

import glob
import urllib.request
from pathlib import Path


# Unicode data URL
UNICODE_VERSION = "16.0.0"
NORMALIZATION_TEST_URL = f"https://www.unicode.org/Public/{UNICODE_VERSION}/ucd/NormalizationTest.txt"


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


def hex_seq_to_moonbit_string(hex_seq: str) -> str:
    """
    Convert a hex code point sequence to a MoonBit string literal.

    Input: "0041 0307" (space-separated hex code points)
    Output: "\\u{0041}\\u{0307}"
    """
    if not hex_seq.strip():
        return ""

    parts = hex_seq.strip().split()
    result = ""
    for part in parts:
        cp = int(part, 16)
        result += f"\\u{{{cp:04X}}}"
    return result


def parse_normalization_test(content: str) -> list[tuple[str, str, str, str, str]]:
    """
    Parse NormalizationTest.txt and return list of (c1, c2, c3, c4, c5) tuples.

    Each tuple contains MoonBit string literals for the test case.
    """
    test_cases = []

    for line in content.strip().split("\n"):
        # Skip comments and empty lines
        line = line.strip()
        if not line or line.startswith("#") or line.startswith("@"):
            continue

        # Remove trailing comment
        if "#" in line:
            line = line.split("#")[0].strip()

        # Split by semicolon
        parts = line.split(";")
        if len(parts) < 5:
            continue

        # Extract c1-c5 (first 5 columns)
        c1 = hex_seq_to_moonbit_string(parts[0])
        c2 = hex_seq_to_moonbit_string(parts[1])
        c3 = hex_seq_to_moonbit_string(parts[2])
        c4 = hex_seq_to_moonbit_string(parts[3])
        c5 = hex_seq_to_moonbit_string(parts[4])

        test_cases.append((c1, c2, c3, c4, c5))

    return test_cases


def generate_conformance_test_mbt(test_cases: list[tuple[str, str, str, str, str]], output_dir: Path):
    """Generate conformance test files split into parts to avoid compiler issues."""

    # Split test data into chunks of 2000 test cases each
    CHUNK_SIZE = 2000
    chunks = [test_cases[i:i + CHUNK_SIZE] for i in range(0, len(test_cases), CHUNK_SIZE)]

    for chunk_idx, chunk in enumerate(chunks):
        code = f'''///|
/// Unicode Normalization Conformance Tests - Part {chunk_idx + 1}
/// Generated from NormalizationTest.txt (Unicode 16.0.0)
///
/// Each test case contains 5 strings (c1, c2, c3, c4, c5) and must satisfy:
/// - NFC: c2 == NFC(c1) == NFC(c2) == NFC(c3)
/// - NFD: c3 == NFD(c1) == NFD(c2) == NFD(c3)
/// - NFKC: c4 == NFKC(c1) == NFKC(c2) == NFKC(c3) == NFKC(c4) == NFKC(c5)
/// - NFKD: c5 == NFKD(c1) == NFKD(c2) == NFKD(c3) == NFKD(c4) == NFKD(c5)

///|
/// Test data from NormalizationTest.txt (part {chunk_idx + 1})
/// Format: (c1, c2, c3, c4, c5)
let conformance_test_data_part{chunk_idx + 1} : Array[(String, String, String, String, String)] = [
'''

        # Write test data
        for i, (c1, c2, c3, c4, c5) in enumerate(chunk):
            if i > 0:
                code += ",\n"
            code += f'  ("{c1}", "{c2}", "{c3}", "{c4}", "{c5}")'

        code += f'''
]

///|
test "conformance: NormalizationTest.txt part {chunk_idx + 1} - NFC" {{
  for i, t in conformance_test_data_part{chunk_idx + 1} {{
    let (c1, c2, c3, _, _) = t
    // NFC invariants: c2 == NFC(c1) == NFC(c2) == NFC(c3)
    let nfc_c1 = @normalization.nfc(c1)
    let nfc_c2 = @normalization.nfc(c2)
    let nfc_c3 = @normalization.nfc(c3)
    assert_eq(nfc_c1, c2, msg="NFC(c1) != c2 at index \\{{i}}")
    assert_eq(nfc_c2, c2, msg="NFC(c2) != c2 at index \\{{i}}")
    assert_eq(nfc_c3, c2, msg="NFC(c3) != c2 at index \\{{i}}")
  }}
}}

///|
test "conformance: NormalizationTest.txt part {chunk_idx + 1} - NFD" {{
  for i, t in conformance_test_data_part{chunk_idx + 1} {{
    let (c1, c2, c3, _, _) = t
    // NFD invariants: c3 == NFD(c1) == NFD(c2) == NFD(c3)
    let nfd_c1 = @normalization.nfd(c1)
    let nfd_c2 = @normalization.nfd(c2)
    let nfd_c3 = @normalization.nfd(c3)
    assert_eq(nfd_c1, c3, msg="NFD(c1) != c3 at index \\{{i}}")
    assert_eq(nfd_c2, c3, msg="NFD(c2) != c3 at index \\{{i}}")
    assert_eq(nfd_c3, c3, msg="NFD(c3) != c3 at index \\{{i}}")
  }}
}}

///|
test "conformance: NormalizationTest.txt part {chunk_idx + 1} - NFKC" {{
  for i, t in conformance_test_data_part{chunk_idx + 1} {{
    let (c1, c2, c3, c4, c5) = t
    // NFKC invariants: c4 == NFKC(c1) == NFKC(c2) == NFKC(c3) == NFKC(c4) == NFKC(c5)
    let nfkc_c1 = @normalization.nfkc(c1)
    let nfkc_c2 = @normalization.nfkc(c2)
    let nfkc_c3 = @normalization.nfkc(c3)
    let nfkc_c4 = @normalization.nfkc(c4)
    let nfkc_c5 = @normalization.nfkc(c5)
    assert_eq(nfkc_c1, c4, msg="NFKC(c1) != c4 at index \\{{i}}")
    assert_eq(nfkc_c2, c4, msg="NFKC(c2) != c4 at index \\{{i}}")
    assert_eq(nfkc_c3, c4, msg="NFKC(c3) != c4 at index \\{{i}}")
    assert_eq(nfkc_c4, c4, msg="NFKC(c4) != c4 at index \\{{i}}")
    assert_eq(nfkc_c5, c4, msg="NFKC(c5) != c4 at index \\{{i}}")
  }}
}}

///|
test "conformance: NormalizationTest.txt part {chunk_idx + 1} - NFKD" {{
  for i, t in conformance_test_data_part{chunk_idx + 1} {{
    let (c1, c2, c3, c4, c5) = t
    // NFKD invariants: c5 == NFKD(c1) == NFKD(c2) == NFKD(c3) == NFKD(c4) == NFKD(c5)
    let nfkd_c1 = @normalization.nfkd(c1)
    let nfkd_c2 = @normalization.nfkd(c2)
    let nfkd_c3 = @normalization.nfkd(c3)
    let nfkd_c4 = @normalization.nfkd(c4)
    let nfkd_c5 = @normalization.nfkd(c5)
    assert_eq(nfkd_c1, c5, msg="NFKD(c1) != c5 at index \\{{i}}")
    assert_eq(nfkd_c2, c5, msg="NFKD(c2) != c5 at index \\{{i}}")
    assert_eq(nfkd_c3, c5, msg="NFKD(c3) != c5 at index \\{{i}}")
    assert_eq(nfkd_c4, c5, msg="NFKD(c4) != c5 at index \\{{i}}")
    assert_eq(nfkd_c5, c5, msg="NFKD(c5) != c5 at index \\{{i}}")
  }}
}}
'''

        # File names must end with _test.mbt to be recognized as test files
        output_path = output_dir / f"conformance_part{chunk_idx + 1}_test.mbt"
        output_path.write_text(code)
        print(f"Generated {output_path} with {len(chunk)} test cases")

    print(f"Generated {len(chunks)} test files with {len(test_cases)} total test cases")


def main():
    # Determine paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    cache_dir = script_dir / ".cache"
    normalization_dir = project_root / "normalization"

    cache_dir.mkdir(exist_ok=True)

    # Download test file
    test_data = download_file(NORMALIZATION_TEST_URL, cache_dir)

    # Parse test cases
    print("Parsing NormalizationTest.txt...")
    test_cases = parse_normalization_test(test_data)
    print(f"  Found {len(test_cases)} test cases")

    # Remove old generated test files
    for old_pattern in ["conformance_test.mbt", "conformance_test_part*.mbt", "conformance_part*_test.mbt"]:
        for old_file in glob.glob(str(normalization_dir / old_pattern)):
            Path(old_file).unlink()
            print(f"Removed old {old_file}")

    # Generate MoonBit test files (split into parts)
    print("\nGenerating MoonBit test files...")
    generate_conformance_test_mbt(test_cases, normalization_dir)

    print("\nDone!")


if __name__ == "__main__":
    main()
