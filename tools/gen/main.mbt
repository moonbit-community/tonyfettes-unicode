///|
const UnicodeVersion : String = "16.0.0"

///|
async fn find_project_root() -> String {
  if @fs.exists("moon.work") && @fs.exists("tools/moon.mod") {
    "."
  } else if @fs.exists("../moon.work") && @fs.exists("moon.mod") {
    ".."
  } else {
    fail("Run the generator from the repository root or tools directory")
  }
}

///|
fn cache_path(root : StringView, name : StringView) -> String {
  "\{root}/tools/.cache/\{name}"
}

///|
async fn read_source(root : StringView, name : String, url : String) -> String {
  let path = cache_path(root, name)
  if @fs.exists(path) {
    println("Using cached \{name}")
    return @fs.read_file(path).text()
  }
  println("Downloading \{name}...")
  ensure_directory("\{root}/tools/.cache")
  let (response, body) = @http.get(url)
  guard response.code >= 200 && response.code < 300 else {
    fail("Download failed for \{url}: HTTP \{response.code}")
  }
  let content = body.text()
  @fs.write_file(path, content, create=0o644, truncate=true)
  content
}

///|
async fn ensure_directory(path : String) -> Unit {
  @fs.mkdir(path, permission=0o755, recursive=true) catch {
    @os_error.OSError(_) as error if error.is_EEXIST() => ()
    error => raise error
  }
}

///|
fn parent_directory(path : StringView) -> String? {
  match path.rev_split_once("/") {
    Some((parent, _)) => Some(parent.to_owned())
    None => None
  }
}

///|
async fn write_source(
  root : StringView,
  relative_path : String,
  source : String,
) -> Unit {
  let path = "\{root}/\{relative_path}"
  if parent_directory(path) is Some(parent) {
    ensure_directory(parent)
  }
  @fs.write_file(path, source, create=0o644, truncate=true)
}

///|
async fn format_file(root : StringView, relative_path : String) -> Unit {
  let status = @process.run("moon", ["fmt", relative_path], cwd=root)
  guard status == 0 else { fail("moon fmt \{relative_path} failed") }
}

///|
async fn generate_interfaces(root : StringView, relative_path : String) -> Unit {
  let status = @process.run("moon", ["info", relative_path], cwd=root)
  guard status == 0 else { fail("moon info \{relative_path} failed") }
}

///|
async fn generate_matching_interfaces(
  root : StringView,
  package_pattern : String,
) -> Unit {
  let status = @process.run("moon", ["info", "-p", package_pattern], cwd=root)
  guard status == 0 else { fail("moon info -p \{package_pattern} failed") }
}

///|
async fn generate_ucd(root : StringView) -> Unit {
  let base = "https://www.unicode.org/Public/\{UnicodeVersion}/ucd"
  let unicode_data = @ucd.parse_unicode_data(
    read_source(root, "UnicodeData.txt", "\{base}/UnicodeData.txt"),
  )
  let exclusions = @ucd.parse_composition_exclusions(
    read_source(
      root,
      "CompositionExclusions.txt",
      "\{base}/CompositionExclusions.txt",
    ),
  )
  let special_casing = @ucd.parse_special_casing(
    read_source(root, "SpecialCasing.txt", "\{base}/SpecialCasing.txt"),
  )
  let ccc_ranges = @ucd.compress_ccc_ranges(unicode_data)
  let mark_ranges = @ucd.compress_mark_ranges(unicode_data)
  let general_category_ranges = @ucd.compress_general_category_ranges(
    unicode_data,
  )
  let compositions = @ucd.build_composition_table(unicode_data, exclusions)
  let full_exclusions = @ucd.build_full_composition_exclusions(
    unicode_data, exclusions,
  )
  write_source(
    root,
    "internal/ucd/ccc.mbt",
    @ucd.emit_ccc(ccc_ranges, mark_ranges),
  )
  write_source(
    root,
    "internal/ucd/decomposition.mbt",
    @ucd.emit_decomposition(unicode_data),
  )
  write_source(
    root,
    "internal/ucd/composition.mbt",
    @ucd.emit_composition(compositions, full_exclusions),
  )
  write_source(
    root,
    "internal/ucd/general_category.mbt",
    @ucd.emit_general_category(general_category_ranges),
  )
  write_source(
    root,
    "internal/ucd/case_mapping.mbt",
    @ucd.emit_case_mapping(unicode_data, special_casing),
  )
  let generated_files = [
    "internal/ucd/ccc.mbt",
    "internal/ucd/decomposition.mbt",
    "internal/ucd/composition.mbt",
    "internal/ucd/general_category.mbt",
    "internal/ucd/case_mapping.mbt",
  ]
  for file in generated_files {
    format_file(root, file)
  }
  generate_interfaces(root, "internal/ucd")
}

///|
async fn generate_idna_data(root : StringView) -> Unit {
  let mapping = read_source(
    root,
    "IdnaMappingTable.txt",
    "https://www.unicode.org/Public/idna/\{UnicodeVersion}/IdnaMappingTable.txt",
  )
  let joining = read_source(
    root,
    "DerivedJoiningType.txt",
    "https://www.unicode.org/Public/\{UnicodeVersion}/ucd/extracted/DerivedJoiningType.txt",
  )
  write_source(
    root,
    "internal/idna/mapping.mbt",
    @idna_data.generate_mapping_source(mapping),
  )
  write_source(
    root,
    "internal/idna/joining.mbt",
    @idna_data.generate_joining_source(joining),
  )
  format_file(root, "internal/idna/mapping.mbt")
  format_file(root, "internal/idna/joining.mbt")
  generate_interfaces(root, "internal/idna")
}

///|
async fn generate_bidi_data(root : StringView) -> Unit {
  let base = "https://www.unicode.org/Public/\{UnicodeVersion}/ucd"
  let classes = read_source(
    root,
    "DerivedBidiClass.txt",
    "\{base}/extracted/DerivedBidiClass.txt",
  )
  let mirroring = read_source(
    root,
    "BidiMirroring.txt",
    "\{base}/BidiMirroring.txt",
  )
  let brackets = read_source(
    root,
    "BidiBrackets.txt",
    "\{base}/BidiBrackets.txt",
  )
  write_source(
    root,
    "internal/bidi/bidi_class.mbt",
    @bidi_data.generate_bidi_class_source(classes),
  )
  write_source(
    root,
    "internal/bidi/mirrored.mbt",
    @bidi_data.generate_mirrored_source(mirroring),
  )
  write_source(
    root,
    "internal/bidi/bracket.mbt",
    @bidi_data.generate_bracket_source(brackets),
  )
  format_file(root, "internal/bidi/bidi_class.mbt")
  format_file(root, "internal/bidi/mirrored.mbt")
  format_file(root, "internal/bidi/bracket.mbt")
  generate_interfaces(root, "internal/bidi")
}

///|
fn is_old_normalization_test(name : StringView) -> Bool {
  name == "conformance_test.mbt" ||
  (name.has_prefix("conformance_test_part") && name.has_suffix(".mbt")) ||
  (name.has_prefix("conformance_part") && name.has_suffix("_test.mbt"))
}

///|
async fn generate_normalization_tests(root : StringView) -> Unit {
  let content = read_source(
    root,
    "NormalizationTest.txt",
    "https://www.unicode.org/Public/\{UnicodeVersion}/ucd/NormalizationTest.txt",
  )
  let directory = "\{root}/normalization"
  for name in @fs.readdir(directory) {
    if is_old_normalization_test(name) {
      @fs.remove("\{directory}/\{name}")
    }
  }
  for file in @normalization_tests.generate_files(content) {
    write_source(root, file.relative_path, file.source)
    format_file(root, file.relative_path)
  }
}

///|
async fn generate_idna_tests(root : StringView) -> Unit {
  let content = read_source(
    root,
    "IdnaTestV2.txt",
    "https://www.unicode.org/Public/idna/\{UnicodeVersion}/IdnaTestV2.txt",
  )
  write_source(
    root,
    "idna/conformance_test.mbt",
    @idna_tests.generate_source(content),
  )
  format_file(root, "idna/conformance_test.mbt")
}

///|
fn is_old_bidi_test(name : StringView) -> Bool {
  (name.has_prefix("conformance_biditest_") && name.has_suffix("_test.mbt")) ||
  (name.has_prefix("conformance_character") && name.has_suffix("_test.mbt"))
}

///|
async fn remove_directory_if_present(path : String) -> Unit {
  try @fs.rmdir(path, recursive=true) catch {
    @os_error.OSError(_) as error if error.is_ENOENT() => ()
    error => raise error
  }
}

///|
async fn generate_bidi_tests(root : StringView, part_size : Int) -> Unit {
  let base = "https://www.unicode.org/Public/\{UnicodeVersion}/ucd"
  let bidi_content = read_source(root, "BidiTest.txt", "\{base}/BidiTest.txt")
  let character_content = read_source(
    root,
    "BidiCharacterTest.txt",
    "\{base}/BidiCharacterTest.txt",
  )
  let bidi_directory = "\{root}/bidi"
  for name in @fs.readdir(bidi_directory) {
    if is_old_bidi_test(name) {
      @fs.remove("\{bidi_directory}/\{name}")
    }
  }
  remove_directory_if_present("\{bidi_directory}/conformance")
  remove_directory_if_present("\{bidi_directory}/internal/conformance")
  let parts = @bidi_tests.generate_parts(
    bidi_content, character_content, part_size,
  )
  for ;; {
    guard parts.next() is Some(part) else { break }
    let package_path = "\{part.relative_directory}/moon.pkg"
    let test_path = "\{part.relative_directory}/conformance_test.mbt"
    write_source(root, package_path, @bidi_tests.package_source())
    write_source(root, test_path, part.source)
  }
  format_file(root, "bidi/internal/conformance")
  generate_matching_interfaces(root, "bidi/internal/conformance")
}

///|
fn part_size(matches : @argparse.Matches) -> Int raise {
  let size = match matches.values {
    { "part-size": [value], .. } => @support.parse_decimal_int(value)
    _ => 5000
  }
  guard size > 0 else { fail("--part-size must be positive") }
  size
}

///|
async fn generate_data(root : StringView) -> Unit {
  generate_ucd(root)
  generate_idna_data(root)
  generate_bidi_data(root)
}

///|
async fn generate_tests(root : StringView, part_size : Int) -> Unit {
  generate_normalization_tests(root)
  generate_idna_tests(root)
  generate_bidi_tests(root, part_size)
}

///|
async fn main {
  let command = @argparse.Command(
    "unicode-gen",
    about="Generate Unicode tables and conformance tests with MoonBit",
    options=[
      @argparse.OptionArg(
        "part-size",
        long="part-size",
        about="Bidi conformance tests per package",
        default_values=["5000"],
        global=true,
      ),
    ],
    subcommands=[
      @argparse.Command("ucd"),
      @argparse.Command("idna"),
      @argparse.Command("bidi"),
      @argparse.Command("normalization-tests"),
      @argparse.Command("idna-tests"),
      @argparse.Command("bidi-tests"),
      @argparse.Command("data"),
      @argparse.Command("tests"),
      @argparse.Command("all"),
    ],
  )
  let matches = command.parse() catch { error => fail(error.to_string()) }
  let root = find_project_root()
  let size = part_size(matches)
  match matches.subcommand {
    None | Some(("all", _)) => {
      generate_data(root)
      generate_tests(root, size)
    }
    Some(("ucd", _)) => generate_ucd(root)
    Some(("idna", _)) => generate_idna_data(root)
    Some(("bidi", _)) => generate_bidi_data(root)
    Some(("normalization-tests", _)) => generate_normalization_tests(root)
    Some(("idna-tests", _)) => generate_idna_tests(root)
    Some(("bidi-tests", _)) => generate_bidi_tests(root, size)
    Some(("data", _)) => generate_data(root)
    Some(("tests", _)) => generate_tests(root, size)
    Some(_) => fail("unreachable subcommand")
  }
}
