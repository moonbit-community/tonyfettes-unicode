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
  @fs.write_file(path, content, create_mode=CreateOrTruncate, permission=0o644)
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
  @fs.write_file(path, source, create_mode=CreateOrTruncate, permission=0o644)
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
  let xid_properties = @ucd.parse_derived_core_properties(
    read_source(
      root,
      "DerivedCoreProperties.txt",
      "\{base}/DerivedCoreProperties.txt",
    ),
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
    "unicode-data/data/ccc.mbt",
    @ucd.emit_ccc(ccc_ranges, mark_ranges),
  )
  write_source(
    root,
    "unicode-data/data/decomposition.mbt",
    @ucd.emit_decomposition(unicode_data),
  )
  write_source(
    root,
    "unicode-data/data/composition.mbt",
    @ucd.emit_composition(compositions, full_exclusions),
  )
  write_source(
    root,
    "unicode-data/data/general_category.mbt",
    @ucd.emit_general_category(general_category_ranges),
  )
  write_source(
    root,
    "unicode-data/data/case_mapping.mbt",
    @ucd.emit_case_mapping(unicode_data, special_casing),
  )
  write_source(root, "unicode-data/data/xid.mbt", @ucd.emit_xid(xid_properties))
  let generated_files = [
    "unicode-data/data/ccc.mbt", "unicode-data/data/decomposition.mbt", "unicode-data/data/composition.mbt",
    "unicode-data/data/general_category.mbt", "unicode-data/data/case_mapping.mbt",
    "unicode-data/data/xid.mbt",
  ]
  for file in generated_files {
    format_file(root, file)
  }
  generate_interfaces(root, "unicode-data/data")
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
    "unicode-idna/internal/idna/mapping.mbt",
    @idna_data.generate_mapping_source(mapping),
  )
  write_source(
    root,
    "unicode-idna/internal/idna/joining.mbt",
    @idna_data.generate_joining_source(joining),
  )
  format_file(root, "unicode-idna/internal/idna/mapping.mbt")
  format_file(root, "unicode-idna/internal/idna/joining.mbt")
  generate_interfaces(root, "unicode-idna/internal/idna")
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
    "unicode-bidi/bidi_class.mbt",
    @bidi_data.generate_bidi_class_source(classes),
  )
  write_source(
    root,
    "unicode-bidi/internal/bidi/mirrored.mbt",
    @bidi_data.generate_mirrored_source(mirroring),
  )
  write_source(
    root,
    "unicode-bidi/internal/bidi/bracket.mbt",
    @bidi_data.generate_bracket_source(brackets),
  )
  format_file(root, "unicode-bidi/bidi_class.mbt")
  format_file(root, "unicode-bidi/internal/bidi/mirrored.mbt")
  format_file(root, "unicode-bidi/internal/bidi/bracket.mbt")
  generate_interfaces(root, "unicode-bidi")
  generate_interfaces(root, "unicode-bidi/internal/bidi")
}

///|
async fn generate_data(root : StringView) -> Unit {
  generate_ucd(root)
  generate_idna_data(root)
  generate_bidi_data(root)
}

///|
async fn main {
  let command = @argparse.Command(
    "unicode-gen",
    about="Generate Unicode lookup tables with MoonBit",
    subcommands=[
      @argparse.Command("ucd"),
      @argparse.Command("idna"),
      @argparse.Command("bidi"),
      @argparse.Command("data"),
      @argparse.Command("all"),
    ],
  )
  let matches = command.parse() catch { error => fail(error.to_string()) }
  let root = find_project_root()
  match matches.subcommand {
    None | Some(("all", _)) | Some(("data", _)) => generate_data(root)
    Some(("ucd", _)) => generate_ucd(root)
    Some(("idna", _)) => generate_idna_data(root)
    Some(("bidi", _)) => generate_bidi_data(root)
    Some(_) => fail("unreachable subcommand")
  }
}
