///|
const ReleaseVersionPattern : Regex = re"^(0|[1-9][0-9]*)[.](0|[1-9][0-9]*)[.](0|[1-9][0-9]*)$"

///|
suberror ReleaseError {
  ReleaseError(String)
} derive(Debug, Eq)

///|
priv struct ReleaseModule {
  name : String
  directory : String
  requires_published_dependencies : Bool
}

///|
// TODO: Derive this topological order from workspace manifests and reject dependency cycles.
let published_modules : Array[ReleaseModule] = [
  { name: "ucd", directory: "ucd", requires_published_dependencies: false },
  {
    name: "punycode",
    directory: "punycode",
    requires_published_dependencies: false,
  },
  { name: "bidi", directory: "bidi", requires_published_dependencies: false },
  {
    name: "normalization",
    directory: "normalization",
    requires_published_dependencies: true,
  },
  { name: "idna", directory: "idna", requires_published_dependencies: true },
  { name: "unicode", directory: ".", requires_published_dependencies: true },
]

///|
fn ReleaseModule::manifest_path(self : ReleaseModule) -> String {
  if self.directory == "." {
    "moon.mod"
  } else {
    "\{self.directory}/moon.mod"
  }
}

///|
fn validate_release_version(version : String) -> Unit raise ReleaseError {
  guard version =~ ReleaseVersionPattern else {
    raise ReleaseError(
      "Invalid release version '\{version}'; expected MAJOR.MINOR.PATCH without a prerelease suffix",
    )
  }
}

///|
fn publish_dry_run_succeeded(
  status : Int,
  output : StringView,
  package_name : StringView,
  version : StringView,
) -> Bool {
  if status == 0 {
    true
  } else {
    // `moon publish --dry-run` currently exits -1 after a successful 202;
    // process APIs expose that as 255 on Unix and -1 on Windows.
    let known_false_failure = status == 255 || status == -1
    let accepted = "Server status: 202 Accepted, detail: Dry run completed successfully. No changes were made. The dry-run was made for package \{package_name} version \{version}."
    known_false_failure &&
    output.contains(accepted) &&
    output.trim_end().has_suffix("Error: `moon publish` failed")
  }
}

///|
fn release_version_from_manifests(
  versions : ArrayView[(String, String)],
) -> String raise ReleaseError {
  let mut root_version : String? = None
  for manifest in versions {
    let (path, version) = manifest
    if path == "moon.mod" {
      guard root_version is None else {
        raise ReleaseError("Published manifests contain more than one moon.mod")
      }
      root_version = Some(version)
    }
  }
  guard root_version is Some(expected_version) else {
    raise ReleaseError("Published manifests do not contain the root moon.mod")
  }
  validate_release_version(expected_version)
  for manifest in versions {
    let (path, actual_version) = manifest
    guard actual_version == expected_version else {
      raise ReleaseError(
        "Published module versions are inconsistent: \{path} has \{actual_version}, expected \{expected_version} from moon.mod",
      )
    }
  }
  expected_version
}

///|
fn manifest_version_and_line(
  source : String,
  path : String,
) -> (String, String) raise ReleaseError {
  let mut found : (String, String)? = None
  for line in source.split("\n") {
    let manifest_line = line.trim_end(chars="\r")
    if manifest_line.split_once("version = \"") is Some(("", rest)) &&
      rest.rev_split_once("\"") is Some((version, "")) {
      if found is Some(_) {
        raise ReleaseError(
          "\{path} contains more than one top-level version declaration",
        )
      }
      found = Some((manifest_line.to_owned(), version.to_owned()))
    }
  }
  guard found is Some(result) else {
    raise ReleaseError(
      "\{path} does not contain a top-level version = \"...\" declaration",
    )
  }
  result
}

///|
fn manifest_version(
  source : String,
  path : String,
) -> String raise ReleaseError {
  let (_, version) = manifest_version_and_line(source, path)
  version
}

///|
fn replace_manifest_version(
  source : String,
  path : String,
  version : String,
) -> String raise ReleaseError {
  let (line, _) = manifest_version_and_line(source, path)
  source.replace(old=line, new="version = \"\{version}\"")
}

///|
fn publish_start_index(name : String) -> Int raise ReleaseError {
  for index, release_module in published_modules {
    if release_module.name == name {
      return index
    }
  }
  raise ReleaseError(
    "Unknown --from module '\{name}'; expected one of ucd, punycode, bidi, normalization, idna, unicode",
  )
}
