///|
test "release versions use stable semantic version syntax" {
  validate_release_version("0.4.0")
  validate_release_version("10.20.30")
  for invalid in ["1.2", "1.2.3-rc.1", "01.2.3", "v1.2.3"] {
    try validate_release_version(invalid) catch {
      ReleaseError(_) => ()
    } noraise {
      _ => fail("expected invalid release version: \{invalid}")
    }
  }
}

///|
test "publish dry-run accepts the known false failure" {
  let output =
    #|Server status: 202 Accepted, detail: Dry run completed successfully. No changes were made. The dry-run was made for package moonbit-community/unicode-data version 0.4.0.
    #|Error: `moon publish` failed
  assert_true(
    publish_dry_run_succeeded(0, "", "moonbit-community/unicode-data", "0.4.0"),
  )
  assert_true(
    publish_dry_run_succeeded(
      255, output, "moonbit-community/unicode-data", "0.4.0",
    ),
  )
  assert_true(
    publish_dry_run_succeeded(
      -1, output, "moonbit-community/unicode-data", "0.4.0",
    ),
  )
  assert_false(
    publish_dry_run_succeeded(
      1, output, "moonbit-community/unicode-data", "0.4.0",
    ),
  )
  assert_false(
    publish_dry_run_succeeded(
      255, output, "moonbit-community/unicode-idna", "0.4.0",
    ),
  )
  assert_false(
    publish_dry_run_succeeded(
      255, "Server status: 500 Internal Server Error", "moonbit-community/unicode-data",
      "0.4.0",
    ),
  )
}

///|
test "release version comes from consistent published manifests" {
  let versions = [
    ("ucd/moon.mod", "0.4.0"),
    ("punycode/moon.mod", "0.4.0"),
    ("unicode/moon.mod", "0.4.0"),
  ]
  inspect(release_version_from_manifests(versions), content="0.4.0")
  try
    release_version_from_manifests([
      ("ucd/moon.mod", "0.4.1"),
      ("unicode/moon.mod", "0.4.0"),
    ])
  catch {
    ReleaseError(message) =>
      inspect(
        message,
        content="Published module versions are inconsistent: ucd/moon.mod has 0.4.1, expected 0.4.0 from unicode/moon.mod",
      )
  } noraise {
    _ => fail("expected inconsistent published versions to fail")
  }
  try release_version_from_manifests([("ucd/moon.mod", "0.4.0")]) catch {
    ReleaseError(message) =>
      inspect(
        message,
        content="Published manifests do not contain the umbrella manifest unicode/moon.mod",
      )
  } noraise {
    _ => fail("expected a missing root manifest to fail")
  }
}

///|
test "manifest version is read and replaced without reformatting" {
  let source =
    #|name = "moonbit-community/example"
    #|
    #|version = "0.3.4"
    #|
  inspect(manifest_version(source, "unicode/moon.mod"), content="0.3.4")
  inspect(
    replace_manifest_version(source, "unicode/moon.mod", "0.4.0"),
    content=(
      #|name = "moonbit-community/example"
      #|
      #|version = "0.4.0"
      #|
    ),
  )
}

///|
test "manifest version accepts CRLF line endings" {
  let source = "name = \"moonbit-community/example\"\r\n\r\nversion = \"0.3.4\"\r\n"
  inspect(manifest_version(source, "unicode/moon.mod"), content="0.3.4")
  inspect(
    replace_manifest_version(source, "unicode/moon.mod", "0.4.0"),
    content="name = \"moonbit-community/example\"\r\n\r\nversion = \"0.4.0\"\r\n",
  )
}

///|
test "manifest version declarations must be unique" {
  try
    manifest_version(
      "version = \"0.3.4\"\nversion = \"0.4.0\"\n", "ucd/moon.mod",
    )
  catch {
    ReleaseError(message) =>
      inspect(
        message,
        content="ucd/moon.mod contains more than one top-level version declaration",
      )
  } noraise {
    _ => fail("expected duplicate version declaration to fail")
  }
  try
    manifest_version(
      "name = \"moonbit-community/unicode-data\"\n", "ucd/moon.mod",
    )
  catch {
    ReleaseError(message) =>
      inspect(
        message,
        content="ucd/moon.mod does not contain a top-level version = \"...\" declaration",
      )
  } noraise {
    _ => fail("expected missing version declaration to fail")
  }
}

///|
test "published modules follow dependency order" {
  guard published_modules
    is [
      ucd,
      punycode,
      bidi,
      segmentation,
      normalization,
      casefold,
      idna,
      unicode,
    ] else {
    fail("expected eight published modules")
  }
  assert_false(ucd.requires_published_dependencies)
  assert_false(punycode.requires_published_dependencies)
  assert_false(bidi.requires_published_dependencies)
  assert_true(segmentation.requires_published_dependencies)
  assert_true(normalization.requires_published_dependencies)
  assert_true(casefold.requires_published_dependencies)
  inspect(casefold.directory, content="casefold")
  inspect(casefold.name, content="unicode-casefold")
  assert_true(idna.requires_published_dependencies)
  assert_true(unicode.requires_published_dependencies)
  inspect(unicode.directory, content="unicode")
  inspect(unicode.manifest_path(), content="unicode/moon.mod")
}

///|
/// Every module that can be validated before this release publishes anything
/// must be: otherwise a rejected archive would surface only after the modules
/// before it had been published irreversibly.
///
test "preflight covers every module that does not depend on this release" {
  assert_eq(preflight_modules().map(release_module => release_module.name), [
    "unicode-data", "punycode", "unicode-bidi",
  ])
}
