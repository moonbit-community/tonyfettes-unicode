//! Rust peer of `bench/xlang/moonbit`: the same cases on the same inputs,
//! timed with the same protocol and printed in the same row format.

use std::hint::black_box;
use std::time::Instant;

use icu_casemap::CaseMapper;
use icu_normalizer::{ComposingNormalizerBorrowed, DecomposingNormalizerBorrowed};
use icu_properties::{props::GeneralCategory, CodePointMapData};
use icu_segmenter::GraphemeClusterSegmenter;
use unicode_normalization::UnicodeNormalization;
use unicode_segmentation::UnicodeSegmentation;

fn run(iterations: u64, f: &mut dyn FnMut() -> usize) -> f64 {
    let mut sink = 0usize;
    let start = Instant::now();
    for _ in 0..iterations {
        sink ^= black_box(f());
    }
    black_box(sink);
    start.elapsed().as_secs_f64() * 1e9
}

/// Double the iteration count until one sample takes at least 10 ms, then
/// print the fastest of 12 samples as `library<TAB>case<TAB>ns<TAB>units<TAB>check`.
fn measure(library: &str, name: &str, units: usize, check: usize, mut f: impl FnMut() -> usize) {
    let mut iterations = 1u64;
    while run(iterations, &mut f) < 1e7 {
        iterations *= 2;
    }
    let best = (0..12).map(|_| run(iterations, &mut f)).fold(f64::INFINITY, f64::min);
    println!("{library}\t{name}\t{}\t{units}\t{check}", best / iterations as f64);
}

fn read(path: String) -> String {
    std::fs::read_to_string(&path).unwrap_or_else(|e| panic!("{path}: {e}"))
}

/// Input names in `directory`: the `.txt` files without their extension.
fn names(directory: String) -> Vec<String> {
    let mut result: Vec<String> = std::fs::read_dir(&directory)
        .unwrap_or_else(|e| panic!("{directory}: {e}"))
        .filter_map(|entry| entry.ok()?.file_name().to_str()?.strip_suffix(".txt").map(String::from))
        .collect();
    result.sort();
    result
}

/// The `name<TAB>value` lines of a `.tsv` input.
fn pairs(path: String) -> Vec<(String, String)> {
    read(path)
        .lines()
        .filter_map(|line| line.split_once('\t'))
        .map(|(name, value)| (name.to_string(), value.to_string()))
        .collect()
}

fn chars(text: &str) -> usize {
    text.chars().count()
}

fn chars16(text: &[u16]) -> usize {
    char::decode_utf16(text.iter().copied()).count()
}

fn bench_normalization(inputs: &str) {
    let nfc = ComposingNormalizerBorrowed::new_nfc();
    let nfkc = ComposingNormalizerBorrowed::new_nfkc();
    let nfd = DecomposingNormalizerBorrowed::new_nfd();
    let nfkd = DecomposingNormalizerBorrowed::new_nfkd();
    for name in names(format!("{inputs}/norm")) {
        let original = read(format!("{inputs}/norm/{name}.txt"));
        let decomposed = read(format!("{inputs}/normd/{name}.txt"));
        let original16: Vec<u16> = original.encode_utf16().collect();
        let decomposed16: Vec<u16> = decomposed.encode_utf16().collect();
        let units = chars(&original);
        let decomposed_units = chars(&decomposed);
        let case = |operation: &str| format!("norm/{operation}/{name}");

        // UTF-8 in, UTF-8 out; always builds a new string.
        let library = "unicode-normalization";
        measure(library, &case("nfc"), units, chars(&original.nfc().collect::<String>()),
            || black_box(&original).nfc().collect::<String>().len());
        measure(library, &case("nfd"), units, chars(&original.nfd().collect::<String>()),
            || black_box(&original).nfd().collect::<String>().len());
        measure(library, &case("nfkc"), units, chars(&original.nfkc().collect::<String>()),
            || black_box(&original).nfkc().collect::<String>().len());
        measure(library, &case("nfkd"), units, chars(&original.nfkd().collect::<String>()),
            || black_box(&original).nfkd().collect::<String>().len());
        measure(library, &case("nfd>nfc"), decomposed_units,
            chars(&decomposed.nfc().collect::<String>()),
            || black_box(&decomposed).nfc().collect::<String>().len());
        measure(library, &case("is_nfc"), units, unicode_normalization::is_nfc(&original) as usize,
            || unicode_normalization::is_nfc(black_box(&original)) as usize);

        let library = "icu4x-utf8";
        measure(library, &case("nfc"), units, chars(&nfc.normalize(&original)),
            || nfc.normalize(black_box(&original)).len());
        measure(library, &case("nfd"), units, chars(&nfd.normalize(&original)),
            || nfd.normalize(black_box(&original)).len());
        measure(library, &case("nfkc"), units, chars(&nfkc.normalize(&original)),
            || nfkc.normalize(black_box(&original)).len());
        measure(library, &case("nfkd"), units, chars(&nfkd.normalize(&original)),
            || nfkd.normalize(black_box(&original)).len());
        measure(library, &case("nfd>nfc"), decomposed_units, chars(&nfc.normalize(&decomposed)),
            || nfc.normalize(black_box(&decomposed)).len());
        measure(library, &case("is_nfc"), units, nfc.is_normalized(&original) as usize,
            || nfc.is_normalized(black_box(&original)) as usize);

        // The same code unit as MoonBit strings.
        let library = "icu4x-utf16";
        measure(library, &case("nfc"), units, chars16(&nfc.normalize_utf16(&original16)),
            || nfc.normalize_utf16(black_box(&original16)).len());
        measure(library, &case("nfd"), units, chars16(&nfd.normalize_utf16(&original16)),
            || nfd.normalize_utf16(black_box(&original16)).len());
        measure(library, &case("nfkc"), units, chars16(&nfkc.normalize_utf16(&original16)),
            || nfkc.normalize_utf16(black_box(&original16)).len());
        measure(library, &case("nfkd"), units, chars16(&nfkd.normalize_utf16(&original16)),
            || nfkd.normalize_utf16(black_box(&original16)).len());
        measure(library, &case("nfd>nfc"), decomposed_units,
            chars16(&nfc.normalize_utf16(&decomposed16)),
            || nfc.normalize_utf16(black_box(&decomposed16)).len());
        measure(library, &case("is_nfc"), units, nfc.is_normalized_utf16(&original16) as usize,
            || nfc.is_normalized_utf16(black_box(&original16)) as usize);
    }
}

fn bench_segmentation(inputs: &str) {
    let segmenter = GraphemeClusterSegmenter::new();
    for name in names(format!("{inputs}/seg")) {
        let text = read(format!("{inputs}/seg/{name}.txt"));
        let text16: Vec<u16> = text.encode_utf16().collect();
        let units = chars(&text);
        let case = format!("seg/graphemes/{name}");
        measure("unicode-segmentation", &case, units, text.graphemes(true).count(),
            || black_box(&text).graphemes(true).count());
        // ICU4X yields boundaries, including the one at offset 0.
        measure("icu4x-utf8", &case, units, segmenter.segment_str(&text).count() - 1,
            || segmenter.segment_str(black_box(&text)).count() - 1);
        measure("icu4x-utf16", &case, units, segmenter.segment_utf16(&text16).count() - 1,
            || segmenter.segment_utf16(black_box(&text16)).count() - 1);
    }
}

fn bench_bidi(inputs: &str) {
    for name in names(format!("{inputs}/bidi")) {
        let text = read(format!("{inputs}/bidi/{name}.txt"));
        let text16: Vec<u16> = text.encode_utf16().collect();
        let units = chars(&text);
        let info = unicode_bidi::BidiInfo::new(&text, None);
        let level_sum: usize =
            text.char_indices().map(|(i, _)| info.levels[i].number() as usize).sum();
        let case = format!("bidi/process/{name}");
        measure("unicode-bidi", &case, units, level_sum,
            || unicode_bidi::BidiInfo::new(black_box(&text), None).levels.len());
        measure("unicode-bidi-utf16", &case, units, level_sum,
            || unicode_bidi::utf16::BidiInfo::new(black_box(&text16), None).levels.len());
    }
}

fn bench_idna(inputs: &str) {
    for (name, domain) in pairs(format!("{inputs}/idna.tsv")) {
        let ascii = idna::domain_to_ascii(&domain).unwrap();
        let (unicode, result) = idna::domain_to_unicode(&domain);
        result.unwrap();
        measure("idna", &format!("idna/to_ascii/{name}"), 1, chars(&ascii),
            || idna::domain_to_ascii(black_box(&domain)).map_or(0, |s| s.len()));
        measure("idna", &format!("idna/to_unicode/{name}"), 1, chars(&unicode),
            || idna::domain_to_unicode(black_box(&domain)).0.len());
    }
}

fn bench_punycode(inputs: &str) {
    for (name, input) in pairs(format!("{inputs}/puny.tsv")) {
        let encoded = idna::punycode::encode_str(&input).unwrap();
        measure("idna", &format!("puny/encode/{name}"), 1, encoded.len(),
            || idna::punycode::encode_str(black_box(&input)).map_or(0, |s| s.len()));
        measure("idna", &format!("puny/decode/{name}"), 1, chars(&input),
            || idna::punycode::decode_to_string(black_box(&encoded)).map_or(0, |s| s.len()));
    }
}

fn bench_properties(inputs: &str) {
    let mapper = CaseMapper::new();
    let categories = CodePointMapData::<GeneralCategory>::new();
    for name in names(format!("{inputs}/case")) {
        let text = read(format!("{inputs}/case/{name}.txt"));
        let units = chars(&text);
        let simple_upper =
            |s: &str| s.chars().fold(0usize, |sum, c| sum ^ mapper.simple_uppercase(c) as usize);
        // An iterator per character: unlike MoonBit's `to_uppercase`, no string is allocated.
        let full_upper = |s: &str| s.chars().map(|c| c.to_uppercase().count()).sum::<usize>();
        let lowercase_icu4x = |s: &str| {
            s.chars().filter(|&c| categories.get(c) == GeneralCategory::LowercaseLetter).count()
        };
        let lowercase_ugc = |s: &str| {
            s.chars()
                .filter(|&c| {
                    unicode_general_category::get_general_category(c)
                        == unicode_general_category::GeneralCategory::LowercaseLetter
                })
                .count()
        };
        measure("icu4x-utf8", &format!("case/simple_upper/{name}"), units, simple_upper(&text),
            || simple_upper(black_box(&text)));
        measure("std", &format!("case/full_upper/{name}"), units, full_upper(&text),
            || full_upper(black_box(&text)));
        let case = format!("prop/general_category_Ll/{name}");
        measure("icu4x-utf8", &case, units, lowercase_icu4x(&text),
            || lowercase_icu4x(black_box(&text)));
        measure("unicode-general-category", &case, units, lowercase_ugc(&text),
            || lowercase_ugc(black_box(&text)));
    }
}

fn main() {
    let arguments: Vec<String> = std::env::args().collect();
    let Some(inputs) = arguments.get(1) else {
        eprintln!("usage: xlang <inputs> [group]");
        std::process::exit(2);
    };
    let group = arguments.get(2).map(String::as_str);
    let groups: [(&str, fn(&str)); 6] = [
        ("norm", bench_normalization),
        ("seg", bench_segmentation),
        ("bidi", bench_bidi),
        ("idna", bench_idna),
        ("puny", bench_punycode),
        ("case", bench_properties),
    ];
    for (name, bench) in groups {
        if group.is_none_or(|selected| selected == name) {
            bench(inputs);
        }
    }
}
