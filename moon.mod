name = "tonyfettes/unicode"

version = "0.3.3"

license = "Apache-2.0"

repository = "https://github.com/moonbit-community/tonyfettes-unicode"

readme = "README.md"

description = "Unicode in MoonBit"

keywords = [
  "unicode",
  "bidi",
  "idna",
  "nfc",
  "nfd",
  "nfkc",
  "nfkd",
  "punycode",
]

options(
  exclude: [
    "AGENTS.md",
    "CLAUDE.md",
    "docs",
    "scripts",
    "tools",
    "moon.work",
    "bidi/internal/conformance",
    "normalization/conformance_part*_test.mbt",
    "idna/conformance_test.mbt",
  ],
)
