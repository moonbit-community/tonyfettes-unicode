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
test "manifest version is read and replaced without reformatting" {
  let source =
    #|name = "tonyfettes/example"
    #|
    #|version = "0.3.4"
    #|
  inspect(manifest_version(source, "moon.mod"), content="0.3.4")
  inspect(
    replace_manifest_version(source, "moon.mod", "0.4.0"),
    content=(
      #|name = "tonyfettes/example"
      #|
      #|version = "0.4.0"
      #|
    ),
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
  try manifest_version("name = \"tonyfettes/ucd\"\n", "ucd/moon.mod") catch {
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
test "publish resume points follow dependency order" {
  inspect(publish_start_index("ucd"), content="0")
  inspect(publish_start_index("normalization"), content="3")
  inspect(publish_start_index("unicode"), content="5")
  try publish_start_index("tools") catch {
    ReleaseError(message) =>
      inspect(
        message,
        content="Unknown --from module 'tools'; expected one of ucd, punycode, bidi, normalization, idna, unicode",
      )
  } noraise {
    _ => fail("expected unknown resume module to fail")
  }
}
