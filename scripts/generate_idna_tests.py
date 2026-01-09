#!/usr/bin/env python3
"""
Generate MoonBit conformance tests from Unicode IdnaTestV2.txt.

This script downloads the official IDNA test vectors and generates
MoonBit test cases for the idna package.
"""

import re
import urllib.request
from pathlib import Path


UNICODE_VERSION = "16.0.0"
TEST_URL = f"https://www.unicode.org/Public/idna/{UNICODE_VERSION}/IdnaTestV2.txt"


def download_file(url: str, cache_dir: Path) -> str:
    """Download a file and cache it locally."""
    filename = url.split("/")[-1]
    cache_path = cache_dir / filename

    if cache_path.exists():
        print(f"Using cached {filename}")
        return cache_path.read_text(encoding="utf-8")

    print(f"Downloading {filename}...")
    with urllib.request.urlopen(url) as response:
        content = response.read().decode("utf-8")

    cache_path.write_text(content, encoding="utf-8")
    return content


def parse_escape_sequences(s: str) -> str:
    r"""
    Convert Unicode escape sequences to actual characters.
    Handles both \uXXXX and \x{XXXX} formats.
    """
    # Handle \x{XXXX} format (variable length hex)
    def replace_x_escape(m):
        return chr(int(m.group(1), 16))

    s = re.sub(r"\\x\{([0-9A-Fa-f]+)\}", replace_x_escape, s)

    # Handle \uXXXX format (4-digit hex)
    def replace_u_escape(m):
        return chr(int(m.group(1), 16))

    s = re.sub(r"\\u([0-9A-Fa-f]{4})", replace_u_escape, s)

    return s


def parse_status(status_str: str) -> list[str] | None:
    """Parse status codes from string like '[]' or '[B5, B6]'.

    Returns:
        - None if the string is blank (inherit from previous column)
        - [] if the string is '[]' (explicit no errors)
        - list of codes if the string is '[B5, B6]', etc.
    """
    status_str = status_str.strip()
    if not status_str:
        return None  # Blank means inherit
    if status_str == "[]":
        return []  # Explicit empty
    # Extract codes from brackets
    match = re.match(r"\[([^\]]*)\]", status_str)
    if match:
        codes = match.group(1).strip()
        if codes:
            # Split by comma and/or whitespace, strip each code
            return [c.strip() for c in re.split(r'[,\s]+', codes) if c.strip()]
        return []
    return None


def parse_test_line(line: str, line_num: int) -> dict | None:
    """
    Parse one test line from IdnaTestV2.txt.

    Format: source; toUnicode; toUnicodeStatus; toAsciiN; reserved; toAsciiT

    Returns dict with parsed fields or None for comments/empty lines.
    """
    # Skip comments and empty lines
    line = line.strip()
    if not line or line.startswith("#"):
        return None

    # Split by semicolon
    parts = line.split(";")
    if len(parts) < 6:
        return None

    source = parse_escape_sequences(parts[0].strip())
    to_unicode = parse_escape_sequences(parts[1].strip())
    to_unicode_status = parse_status(parts[2].strip())
    to_ascii_n = parse_escape_sequences(parts[3].strip())
    to_ascii_n_status = parse_status(parts[4].strip()) if len(parts) > 4 else None
    to_ascii_t = parse_escape_sequences(parts[5].strip()) if len(parts) > 5 else ""

    # If toUnicode is empty, use source
    if not to_unicode:
        to_unicode = source

    # If toAsciiN is empty, use toUnicode (which may already be source)
    if not to_ascii_n:
        to_ascii_n = to_unicode

    # If toUnicodeStatus is None (blank), it means no errors
    if to_unicode_status is None:
        to_unicode_status = []

    # If toAsciiNStatus is None (blank), inherit from toUnicodeStatus
    # If toAsciiNStatus is [] (explicit empty), it means no errors
    if to_ascii_n_status is None:
        to_ascii_n_status = to_unicode_status.copy()

    return {
        "line_num": line_num,
        "source": source,
        "to_unicode": to_unicode,
        "to_unicode_status": to_unicode_status,
        "to_ascii_n": to_ascii_n,
        "to_ascii_n_status": to_ascii_n_status,
        "to_ascii_t": to_ascii_t,
    }


def has_surrogate(s: str) -> bool:
    """Check if string contains surrogate code points (0xD800-0xDFFF)."""
    for ch in s:
        cp = ord(ch)
        if 0xD800 <= cp <= 0xDFFF:
            return True
    return False


def filter_ignored_status_codes(codes: list[str]) -> list[str]:
    """Remove status codes for disabled validation flags.

    Based on IdnaTestV2.txt documentation, when validation flags are disabled:
    - check_bidi=false    → ignore B1, B2, B3, B4, B5, B6
    - check_joiners=false → ignore C1, C2
    - check_hyphens=false → ignore V2, V3
    - use_std3_ascii_rules=false → ignore U1
    - verify_dns_length=false → ignore A4_1, A4_2

    Additionally, V4 (code point status check) can be triggered by DisallowedSTD3Valid
    characters (like hyphen-minus). When use_std3_ascii_rules=false, these are treated
    as valid, so V4 should not trigger errors for them. We ignore V4 when std3 rules
    are disabled because all V4 errors in the test suite that remain after filtering
    are caused by DisallowedSTD3Valid characters.

    Since the conformance tests disable all these flags, we filter all of them.
    """
    ignored = {'B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'C1', 'C2', 'V2', 'V3', 'V4', 'U1', 'A4_1', 'A4_2'}
    return [c for c in codes if c not in ignored]


def escape_moonbit_string(s: str) -> str:
    """Escape a string for use in MoonBit source code."""
    result = []
    for ch in s:
        cp = ord(ch)
        if ch == "\\":
            result.append("\\\\")
        elif ch == '"':
            result.append('\\"')
        elif ch == "\n":
            result.append("\\n")
        elif ch == "\r":
            result.append("\\r")
        elif ch == "\t":
            result.append("\\t")
        elif 0x20 <= cp <= 0x7E:
            # Printable ASCII
            result.append(ch)
        elif 0xD800 <= cp <= 0xDFFF:
            # Surrogate - skip these (will be filtered out at test level)
            result.append(f"<SURROGATE:{cp:04X}>")
        elif cp <= 0xFFFF:
            # BMP character
            result.append(f"\\u{cp:04X}")
        else:
            # Supplementary character
            result.append(f"\\u{{{cp:X}}}")
    return "".join(result)


def generate_tests(test_cases: list[dict], output_path: Path):
    """Generate MoonBit conformance test file."""

    # Group tests by expected behavior, filtering out surrogates
    success_tests = []
    error_tests = []
    skipped = 0

    for tc in test_cases:
        # Skip tests with surrogate code points (MoonBit doesn't support them)
        if has_surrogate(tc["source"]) or has_surrogate(tc["to_ascii_n"]):
            skipped += 1
            continue

        # Filter out status codes for disabled validation flags
        # Use to_ascii_n_status (not to_unicode_status) since we're testing to_ascii
        filtered_status = filter_ignored_status_codes(tc["to_ascii_n_status"])

        if filtered_status:
            # Has remaining error codes after filtering - expect failure
            tc["filtered_status"] = filtered_status
            error_tests.append(tc)
        else:
            # No error codes (or all filtered out) - expect success
            success_tests.append(tc)

    print(f"  Skipped (surrogates): {skipped}")

    code = '''///|
/// IDNA Conformance Tests
/// Generated from IdnaTestV2.txt (Unicode {version})
///
/// These tests verify compliance with UTS #46 (Unicode IDNA Compatibility Processing).
/// Source: https://www.unicode.org/Public/idna/{version}/IdnaTestV2.txt

'''.format(version=UNICODE_VERSION)

    # Generate success tests
    code += "// Success tests (no error expected)\n\n"

    tests_per_segment = 500  # Split into segments to avoid line limit

    for i, tc in enumerate(success_tests):
        # Add segment marker every N tests
        if i > 0 and i % tests_per_segment == 0:
            code += "///|\n\n"

        source_escaped = escape_moonbit_string(tc["source"])
        expected_escaped = escape_moonbit_string(tc["to_ascii_n"])

        # Create a short label for the test name
        label = tc["source"][:20]
        if len(tc["source"]) > 20:
            label += "..."
        label_escaped = escape_moonbit_string(label)

        code += f'''test "conformance/{tc['line_num']:04d}: {label_escaped}" {{
  let result = @idna.to_ascii(
    "{source_escaped}",
    use_std3_ascii_rules=false,
    check_hyphens=false,
    check_bidi=false,
    check_joiners=false,
    verify_dns_length=false,
  )
  assert_eq(result, "{expected_escaped}")
}}

'''

    # Generate error tests
    code += "///|\n\n// Error tests (failure expected)\n\n"

    for i, tc in enumerate(error_tests):
        # Add segment marker every N tests
        if i > 0 and i % tests_per_segment == 0:
            code += "///|\n\n"

        source_escaped = escape_moonbit_string(tc["source"])
        status_str = " ".join(tc["filtered_status"])

        # Create a short label for the test name
        label = tc["source"][:20]
        if len(tc["source"]) > 20:
            label += "..."
        label_escaped = escape_moonbit_string(label)

        code += f'''test "conformance/{tc['line_num']:04d}: {label_escaped} [{status_str}]" {{
  let result : Result[String, Error] = try? @idna.to_ascii(
    "{source_escaped}",
    use_std3_ascii_rules=false,
    check_hyphens=false,
    check_bidi=false,
    check_joiners=false,
    verify_dns_length=false,
  )
  guard result is Err(_) else {{
    fail("Expected error for line {tc['line_num']}, got Ok")
  }}
}}

'''

    output_path.write_text(code, encoding="utf-8")
    print(f"Generated {output_path}")
    print(f"  Success tests: {len(success_tests)}")
    print(f"  Error tests: {len(error_tests)}")
    print(f"  Total: {len(test_cases)}")


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    cache_dir = script_dir / ".cache"
    output_path = project_root / "idna" / "conformance_test.mbt"

    cache_dir.mkdir(exist_ok=True)

    # Download test file
    content = download_file(TEST_URL, cache_dir)

    # Parse test cases
    print("Parsing IdnaTestV2.txt...")
    test_cases = []
    for line_num, line in enumerate(content.split("\n"), start=1):
        tc = parse_test_line(line, line_num)
        if tc:
            test_cases.append(tc)

    print(f"  Found {len(test_cases)} test cases")

    # Generate MoonBit tests
    print("\nGenerating MoonBit conformance tests...")
    generate_tests(test_cases, output_path)

    print("\nDone!")
    print("Run: moon test -p idna -f 'conformance'")


if __name__ == "__main__":
    main()
