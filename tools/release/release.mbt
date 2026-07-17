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
}

///|
let published_modules : Array[ReleaseModule] = [
  { name: "ucd", directory: "ucd" },
  { name: "punycode", directory: "punycode" },
  { name: "bidi", directory: "bidi" },
  { name: "normalization", directory: "normalization" },
  { name: "idna", directory: "idna" },
  { name: "unicode", directory: "." },
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
