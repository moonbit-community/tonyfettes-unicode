name = "tonyfettes/unicode"

version = "0.3.4"

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
    "tools",
    "moon.work",
    "normalization/conformance_part*_test.mbt",
    "idna/conformance_test.mbt",
  ],
)
