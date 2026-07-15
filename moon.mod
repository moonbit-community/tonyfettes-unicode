name = "tonyfettes/unicode"

version = "0.3.4"

license = "Apache-2.0"

repository = "https://github.com/moonbit-community/tonyfettes-unicode"

readme = "README.md"

description = "Unicode in MoonBit"

source = "unicode"

import {
  "tonyfettes/ucd@0.3.4",
  "tonyfettes/normalization@0.3.4",
  "tonyfettes/punycode@0.3.4",
  "tonyfettes/bidi@0.3.4",
  "tonyfettes/idna@0.3.4",
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
