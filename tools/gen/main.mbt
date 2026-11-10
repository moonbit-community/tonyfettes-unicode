///|
const UnicodeVersion : String = "18.0.0"

///|
/// One generator run: reads Unicode data files, each at most once, and writes
/// generated sources under the repository root.
priv struct Generator {
  root : String
  /// Contents of the data files read so far, by path under
  /// `https://www.unicode.org/Public/<version>/`.
  sources : Map[String, String]
  /// Generated files, relative to `root`.
  written : Array[String]
}

///|
async fn Generator::new() -> Generator {
  let root = if @fs.exists("moon.work") && @fs.exists("tools/moon.mod") {
    "."
  } else if @fs.exists("../moon.work") && @fs.exists("moon.mod") {
    ".."
  } else {
    fail("Run the generator from the repository root or tools directory")
  }
  { root, sources: Map([]), written: [], }
}

///|
/// The content of a data file, such as `ucd/UnicodeData.txt`, from the
/// download cache `tools/.cache/<version>/` or else from unicode.org.
async fn Generator::source(self : Generator, path : String) -> String {
  if self.sources.get(path) is Some(content) {
    return content
  }
  let name = match path.rev_split_once("/") {
    Some((_, name)) => name.to_owned()
    None => path
  }
  let cache_directory = "\{self.root}/tools/.cache/\{UnicodeVersion}"
  let cache_path = "\{cache_directory}/\{name}"
  let content = if @fs.exists(cache_path) {
    println("Using cached \{name}")
    @fs.read_text(cache_path)
  } else {
    println("Downloading \{name}...")
    let url = "https://www.unicode.org/Public/\{UnicodeVersion}/\{path}"
    let (response, content) = @http.get_text(url)
    guard response.code >= 200 && response.code < 300 else {
      fail("Download failed for \{url}: HTTP \{response.code}")
    }
    @fs.mkdir(
      cache_directory,
      permission=0o755,
      recursive=true,
      allow_exist=true,
    )
    @fs.write_text(cache_path, content, permission=0o644)
    content
  }
  self.sources[path] = content
  content
}

///|
/// The content of a file of the Unicode Character Database.
async fn Generator::ucd(self : Generator, path : String) -> String {
  self.source("ucd/\{path}")
}

///|
async fn Generator::write(
  self : Generator,
  path : String,
  source : String,
) -> Unit {
  let full_path = "\{self.root}/\{path}"
  if full_path.rev_split_once("/") is Some((directory, _)) {
    @fs.mkdir(
      directory.to_owned(),
      permission=0o755,
      recursive=true,
      allow_exist=true,
    )
  }
  @fs.write_text(full_path, source, permission=0o644)
  self.written.push(path)
}

///|
async fn Generator::run_moon(
  self : Generator,
  arguments : Array[String],
) -> Unit {
  let status = @shell.Cmd("moon", arguments, cwd=self.root).status()
  guard status == 0 else { fail("moon \{arguments.join(" ")} failed") }
}

///|
/// Format the generated files and refresh the interfaces of the packages
/// holding them.
async fn Generator::finish(self : Generator) -> Unit {
  self.run_moon(["fmt", ..self.written])
  let packages : Array[String] = []
  for path in self.written {
    if path.rev_split_once("/") is Some((package_, _)) &&
      !packages.contains(package_.to_owned()) {
      packages.push(package_.to_owned())
    }
  }
  self.run_moon(["info", ..packages])
}

///|
async fn generate_ucd(g : Generator) -> Unit {
  let unicode_data = @ucd.parse_unicode_data(g.ucd("UnicodeData.txt"))
  let exclusions = @ucd.parse_composition_exclusions(
    g.ucd("CompositionExclusions.txt"),
  )
  let normalization_properties = g.ucd("DerivedNormalizationProps.txt")
  g.write(
    "normalization/normalization_data.mbt",
    @ucd.emit_normalization_scan(unicode_data, normalization_properties),
  )
  g.write("ucd/ccc/ccc.mbt", @ucd.emit_ccc())
  g.write(
    "ucd/internal/normalization/normalization.mbt",
    @ucd.emit_normalization(unicode_data, exclusions, normalization_properties),
  )
  g.write(
    "ucd/decomposition/decomposition.mbt",
    @ucd.emit_decomposition(unicode_data),
  )
  g.write(
    "ucd/composition/composition.mbt",
    @ucd.emit_composition(unicode_data, exclusions),
  )
  g.write("ucd/general_category/mark.mbt", @ucd.emit_marks(unicode_data))
  g.write(
    "ucd/general_category/general_category.mbt",
    @ucd.emit_general_category(unicode_data),
  )
  g.write(
    "ucd/punctuation/punctuation.mbt",
    @ucd.emit_punctuation(unicode_data),
  )
  g.write(
    "ucd/case_mapping/case_mapping.mbt",
    @ucd.emit_case_mapping(
      unicode_data,
      @ucd.parse_special_casing(g.ucd("SpecialCasing.txt")),
    ),
  )
  g.write("ucd/xid/xid.mbt", @ucd.emit_xid(g.ucd("DerivedCoreProperties.txt")))
  // Each binary property lives in a package named after it.
  for
    entry in [
      ("Alphabetic", "DerivedCoreProperties.txt"),
      ("Lowercase", "DerivedCoreProperties.txt"),
      ("Uppercase", "DerivedCoreProperties.txt"),
      ("Default_Ignorable_Code_Point", "DerivedCoreProperties.txt"),
      ("Grapheme_Extend", "DerivedCoreProperties.txt"),
      ("White_Space", "PropList.txt"),
      ("Regional_Indicator", "PropList.txt"),
      ("Prepended_Concatenation_Mark", "PropList.txt"),
    ] {
    let (property, source) = entry
    let package_ = property.to_lower()
    g.write(
      "ucd/\{package_}/\{package_}.mbt",
      @ucd.emit_binary_property(g.ucd(source), property~, source~),
    )
  }
  g.write(
    "ucd/emoji/emoji.mbt",
    @ucd.emit_emoji(
      g.ucd("emoji/emoji-data.txt"),
      g.ucd("emoji/emoji-variation-sequences.txt"),
    ),
  )
  g.write(
    "ucd/east_asian_width/east_asian_width.mbt",
    @ucd.emit_east_asian_width(g.ucd("EastAsianWidth.txt")),
  )
  g.write(
    "ucd/hangul_syllable_type/hangul_syllable_type.mbt",
    @ucd.emit_hangul_syllable_type(g.ucd("HangulSyllableType.txt")),
  )
  g.write(
    "ucd/joining_type/joining_type.mbt",
    @ucd.emit_joining_type(g.ucd("extracted/DerivedJoiningType.txt")),
  )
  let joining_groups = g.ucd("extracted/DerivedJoiningGroup.txt")
  g.write(
    "ucd/joining_group/joining_group.mbt",
    @ucd.emit_joining_group(joining_groups),
  )
  g.write("ucd/joining_group.mbt", @ucd.emit_joining_group_enum(joining_groups))
  g.write(
    "ucd/line_break/line_break.mbt",
    @ucd.emit_line_break(g.ucd("LineBreak.txt")),
  )
  g.write("ucd/line_break.mbt", @ucd.emit_line_break_enum())
}

///|
async fn generate_casefold(g : Generator) -> Unit {
  g.write(
    "casefold/case_folding_data.mbt",
    @ucd.emit_case_folding(g.ucd("CaseFolding.txt")),
  )
  g.write(
    "casefold/nfkc_casefold_data.mbt",
    @ucd.emit_nfkc_casefold(g.ucd("DerivedNormalizationProps.txt")),
  )
}

///|
async fn generate_idna(g : Generator) -> Unit {
  g.write(
    "idna/internal/idna/mapping.mbt",
    @idna_data.emit_mapping(g.source("idna/IdnaMappingTable.txt")),
  )
}

///|
async fn generate_bidi(g : Generator) -> Unit {
  g.write(
    "bidi/bidi_class.mbt",
    @bidi_data.emit_bidi_class(g.ucd("extracted/DerivedBidiClass.txt")),
  )
  g.write(
    "bidi/internal/bidi/mirrored.mbt",
    @bidi_data.emit_mirrored(g.ucd("BidiMirroring.txt")),
  )
  g.write(
    "bidi/internal/bidi/bracket.mbt",
    @bidi_data.emit_bracket(g.ucd("BidiBrackets.txt")),
  )
}

///|
async fn generate_segmentation(g : Generator) -> Unit {
  g.write(
    "segmentation/grapheme_break_property.mbt",
    @segmentation_data.emit_grapheme_break(
      g.ucd("auxiliary/GraphemeBreakProperty.txt"),
      g.ucd("emoji/emoji-data.txt"),
      g.ucd("DerivedCoreProperties.txt"),
    ),
  )
  g.write(
    "segmentation/word_break_property.mbt",
    @segmentation_data.emit_word_break(g.ucd("auxiliary/WordBreakProperty.txt")),
  )
  g.write(
    "segmentation/sentence_break_property.mbt",
    @segmentation_data.emit_sentence_break(
      g.ucd("auxiliary/SentenceBreakProperty.txt"),
    ),
  )
}

///|
async fn main {
  let generators : Array[(String, async (Generator) -> Unit)] = [
    ("ucd", generate_ucd),
    ("casefold", generate_casefold),
    ("idna", generate_idna),
    ("bidi", generate_bidi),
    ("segmentation", generate_segmentation),
  ]
  let command = @argparse.Command(
    "unicode-gen",
    about="Generate Unicode lookup tables with MoonBit",
    subcommands=[
      ..generators.map(entry => @argparse.Command(entry.0)),
      @argparse.Command("data", about="Run every generator"),
      @argparse.Command("all", about="Alias for `data`"),
    ],
  )
  let matches = command.parse() catch { error => fail(error.to_string()) }
  let selected = match matches.subcommand {
    Some((name, _)) if name != "data" && name != "all" =>
      generators.filter(entry => entry.0 == name)
    _ => generators
  }
  let g = Generator::new()
  for entry in selected {
    (entry.1)(g)
  }
  g.finish()
}
