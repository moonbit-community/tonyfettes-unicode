name = "moonbit-community/unicode"

version = "0.4.0"

license = "Apache-2.0"

repository = "https://github.com/moonbit-community/tonyfettes-unicode"

readme = "README.md"

description = "Unicode in MoonBit"

source = "unicode"

import {
  "moonbit-community/ucd@0.4.0",
  "moonbit-community/normalization@0.4.0",
  "moonbit-community/punycode@0.4.0",
  "moonbit-community/bidi@0.4.0",
  "moonbit-community/idna@0.4.0",
}

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
    "/.DS_Store",
    "/.claude",
    "/.git",
    "/.gitignore",
    "/.mooncakes",
    "/.vscode",
    "/_build",
    "/AGENTS.md",
    "/CLAUDE.md",
    "/docs",
    "/tools",
    "/conformance",
    "/ucd",
    "/normalization",
    "/punycode",
    "/bidi",
    "/idna",
    "/internal",
    "/moon.work",
  ],
)
