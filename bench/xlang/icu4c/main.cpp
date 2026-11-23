// ICU4C peer of bench/xlang/moonbit: the same cases on the same inputs, timed
// with the same protocol and printed in the same row format. ICU4C works on
// UTF-16, the same code unit as MoonBit strings.

#include <algorithm>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <functional>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

#include <unicode/brkiter.h>
#include <unicode/normalizer2.h>
#include <unicode/ubidi.h>
#include <unicode/ubrk.h>
#include <unicode/uchar.h>
#include <unicode/uidna.h>
#include <unicode/unistr.h>
#include <unicode/ustring.h>

using icu::BreakIterator;
using icu::Locale;
using icu::Normalizer2;
using icu::UnicodeString;

static volatile long g_sink;

static double run(long iterations, const std::function<long()> &f) {
  long sink = 0;
  auto start = std::chrono::steady_clock::now();
  for (long i = 0; i < iterations; i++) sink ^= f();
  auto elapsed = std::chrono::steady_clock::now() - start;
  g_sink = sink;
  return std::chrono::duration<double, std::nano>(elapsed).count();
}

// Double the iteration count until one sample takes at least 5 ms, then print
// the fastest of 5 samples, the first of which is that one, as
// library<TAB>case<TAB>ns<TAB>units<TAB>check.
// The library column is empty: this harness has one library.
static void measure(const std::string &name, long units, long check,
                    const std::function<long()> &f) {
  long iterations = 1;
  double best = run(iterations, f);
  while (best < 5e6) {
    iterations *= 2;
    best = run(iterations, f);
  }
  for (int i = 1; i < 5; i++) best = std::min(best, run(iterations, f));
  printf("\t%s\t%f\t%ld\t%ld\n", name.c_str(), best / iterations, units, check);
  fflush(stdout);
}

static UnicodeString read(const std::string &path) {
  std::ifstream in(path, std::ios::binary);
  if (!in) {
    fprintf(stderr, "cannot read %s\n", path.c_str());
    exit(1);
  }
  std::stringstream contents;
  contents << in.rdbuf();
  return UnicodeString::fromUTF8(contents.str());
}

// Input names in `directory`: the .txt files without their extension.
static std::vector<std::string> names(const std::string &directory) {
  std::vector<std::string> result;
  for (const auto &entry : std::filesystem::directory_iterator(directory))
    if (entry.path().extension() == ".txt") result.push_back(entry.path().stem().string());
  std::sort(result.begin(), result.end());
  return result;
}

// The name<TAB>value lines of a .tsv input.
static std::vector<std::pair<std::string, std::string>> pairs(const std::string &path) {
  std::ifstream in(path);
  if (!in) {
    fprintf(stderr, "cannot read %s\n", path.c_str());
    exit(1);
  }
  std::vector<std::pair<std::string, std::string>> result;
  std::string line;
  while (std::getline(in, line)) {
    auto tab = line.find('\t');
    if (tab != std::string::npos) result.emplace_back(line.substr(0, tab), line.substr(tab + 1));
  }
  return result;
}

static void check_status(UErrorCode status, const char *what) {
  if (U_FAILURE(status)) {
    fprintf(stderr, "%s: %s\n", what, u_errorName(status));
    exit(1);
  }
}

// A fresh destination per call, like the allocating APIs of the other harnesses.
static UnicodeString normalized(const Normalizer2 *form, const UnicodeString &source) {
  UnicodeString destination;
  UErrorCode status = U_ZERO_ERROR;
  form->normalize(source, destination, status);
  return destination;
}

static void bench_normalization(const std::string &inputs) {
  UErrorCode status = U_ZERO_ERROR;
  const std::pair<const char *, const Normalizer2 *> forms[] = {
      {"nfc", Normalizer2::getNFCInstance(status)},
      {"nfd", Normalizer2::getNFDInstance(status)},
      {"nfkc", Normalizer2::getNFKCInstance(status)},
      {"nfkd", Normalizer2::getNFKDInstance(status)}};
  check_status(status, "Normalizer2");
  const Normalizer2 *nfc = forms[0].second;
  for (const std::string &name : names(inputs + "/norm")) {
    UnicodeString original = read(inputs + "/norm/" + name + ".txt");
    UnicodeString decomposed = read(inputs + "/normd/" + name + ".txt");
    long units = original.countChar32();
    for (const auto &[label, form] : forms) {
      const Normalizer2 *normalizer = form;
      measure(std::string("norm/") + label + "/" + name, units,
              normalized(normalizer, original).countChar32(),
              [&]() { return (long)normalized(normalizer, original).length(); });
    }
    measure("norm/nfd>nfc/" + name, decomposed.countChar32(),
            normalized(nfc, decomposed).countChar32(),
            [&]() { return (long)normalized(nfc, decomposed).length(); });
    measure("norm/is_nfc/" + name, units, nfc->isNormalized(original, status), [&]() {
      UErrorCode status = U_ZERO_ERROR;
      return (long)nfc->isNormalized(original, status);
    });
  }
}

static void bench_segmentation(const std::string &inputs) {
  UErrorCode status = U_ZERO_ERROR;
  BreakIterator *grapheme_iter = BreakIterator::createCharacterInstance(Locale::getRoot(), status);
  BreakIterator *word_iter = BreakIterator::createWordInstance(Locale::getRoot(), status);
  BreakIterator *sentence_iter = BreakIterator::createSentenceInstance(Locale::getRoot(), status);
  BreakIterator *line_iter = BreakIterator::createLineInstance(Locale::getRoot(), status);
  check_status(status, "BreakIterator");
  for (const std::string &name : names(inputs + "/seg")) {
    UnicodeString text = read(inputs + "/seg/" + name + ".txt");
    long units = text.countChar32();
    auto count_segments = [&](BreakIterator *iterator) {
      iterator->setText(text);
      long segments = 0;
      while (iterator->next() != BreakIterator::DONE) segments++;
      return segments;
    };
    auto count_graphemes = [&]() { return count_segments(grapheme_iter); };
    auto count_word_segments = [&]() { return count_segments(word_iter); };
    auto count_words = [&]() {
      word_iter->setText(text);
      long words = 0;
      while (word_iter->next() != BreakIterator::DONE) {
        if (word_iter->getRuleStatus() != UBRK_WORD_NONE) words++;
      }
      return words;
    };
    auto count_sentences = [&]() { return count_segments(sentence_iter); };
    auto count_line_breaks = [&]() { return count_segments(line_iter); };
    measure("seg/graphemes/" + name, units, count_graphemes(), count_graphemes);
    measure("seg/word_segments/" + name, units, count_word_segments(), count_word_segments);
    measure("seg/words/" + name, units, count_words(), count_words);
    measure("seg/sentences/" + name, units, count_sentences(), count_sentences);
    measure("seg/line_breaks/" + name, units, count_line_breaks(), count_line_breaks);
  }
  delete grapheme_iter;
  delete word_iter;
  delete sentence_iter;
  delete line_iter;
}

static void bench_bidi(const std::string &inputs) {
  UBiDi *bidi = ubidi_open();
  auto reorder = [&](UBiDi *para, int32_t length) {
    UnicodeString destination;
    int32_t capacity = length + 16;
    UErrorCode status = U_ZERO_ERROR;
    int32_t written = ubidi_writeReordered(
        para, destination.getBuffer(capacity), capacity,
        UBIDI_DO_MIRRORING | UBIDI_REMOVE_BIDI_CONTROLS, &status);
    destination.releaseBuffer(U_SUCCESS(status) ? written : 0);
    return destination;
  };
  for (const std::string &name : names(inputs + "/bidi")) {
    UnicodeString text = read(inputs + "/bidi/" + name + ".txt");
    long units = text.countChar32();
    UErrorCode status = U_ZERO_ERROR;
    ubidi_setPara(bidi, text.getBuffer(), text.length(), UBIDI_DEFAULT_LTR, nullptr, &status);
    const UBiDiLevel *levels = ubidi_getLevels(bidi, &status);
    check_status(status, "ubidi");
    long level_sum = 0;
    for (int32_t i = 0; i < text.length(); i++)
      if (!U16_IS_TRAIL(text[i])) level_sum += levels[i];
    measure("bidi/process/" + name, units, level_sum, [&]() {
      UErrorCode status = U_ZERO_ERROR;
      ubidi_setPara(bidi, text.getBuffer(), text.length(), UBIDI_DEFAULT_LTR, nullptr, &status);
      // Levels are computed lazily; ask for them as the other harnesses do.
      const UBiDiLevel *levels = ubidi_getLevels(bidi, &status);
      return (long)levels[text.length() - 1] + ubidi_getProcessedLength(bidi);
    });
    // Ensure `bidi` holds the resolved paragraph before timing visual reordering.
    status = U_ZERO_ERROR;
    ubidi_setPara(bidi, text.getBuffer(), text.length(), UBIDI_DEFAULT_LTR, nullptr, &status);
    check_status(status, "ubidi_setPara");
    measure("bidi/reorder/" + name, units, reorder(bidi, text.length()).countChar32(),
            [&]() { return (long)reorder(bidi, text.length()).length(); });
  }
  ubidi_close(bidi);
}

static void bench_idna(const std::string &inputs) {
  // The closest match to the other harnesses: UTS #46 non-transitional
  // processing with Bidi and joiner checks but without STD3 rules.
  UErrorCode status = U_ZERO_ERROR;
  UIDNA *idna = uidna_openUTS46(UIDNA_CHECK_BIDI | UIDNA_CHECK_CONTEXTJ |
                                    UIDNA_NONTRANSITIONAL_TO_ASCII |
                                    UIDNA_NONTRANSITIONAL_TO_UNICODE,
                                &status);
  check_status(status, "uidna_openUTS46");
  const int32_t capacity = 512;
  for (const auto &[name, domain_utf8] : pairs(inputs + "/idna.tsv")) {
    UnicodeString domain = UnicodeString::fromUTF8(domain_utf8);
    auto to_ascii = [&](char16_t *destination) {
      UIDNAInfo info = UIDNA_INFO_INITIALIZER;
      UErrorCode status = U_ZERO_ERROR;
      return (long)uidna_nameToASCII(idna, domain.getBuffer(), domain.length(), destination,
                                     capacity, &info, &status);
    };
    auto to_unicode = [&](char16_t *destination) {
      UIDNAInfo info = UIDNA_INFO_INITIALIZER;
      UErrorCode status = U_ZERO_ERROR;
      return (long)uidna_nameToUnicode(idna, domain.getBuffer(), domain.length(), destination,
                                       capacity, &info, &status);
    };
    char16_t buffer[capacity];
    long ascii_length = to_ascii(buffer);
    long unicode_length = u_countChar32(buffer, (int32_t)to_unicode(buffer));
    measure("idna/to_ascii/" + name, 1, ascii_length, [&]() {
      char16_t destination[capacity];
      return to_ascii(destination);
    });
    measure("idna/to_unicode/" + name, 1, unicode_length, [&]() {
      char16_t destination[capacity];
      return to_unicode(destination);
    });
  }
  uidna_close(idna);
}

static void bench_properties(const std::string &inputs) {
  UErrorCode status = U_ZERO_ERROR;
  const Normalizer2 *nfd = Normalizer2::getNFDInstance(status);
  const Normalizer2 *nfkc_casefold = Normalizer2::getNFKCCasefoldInstance(status);
  check_status(status, "Normalizer2");
  // Full default case mapping and folding into a fresh destination per call.
  // Case operations expand a UTF-16 code unit to at most three.
  auto to_upper = [](const UnicodeString &source) {
    UnicodeString destination;
    int32_t capacity = source.length() * 3;
    UErrorCode status = U_ZERO_ERROR;
    int32_t length = u_strToUpper(destination.getBuffer(capacity), capacity, source.getBuffer(),
                                  source.length(), "", &status);
    destination.releaseBuffer(U_SUCCESS(status) ? length : 0);
    return destination;
  };
  auto to_lower = [](const UnicodeString &source) {
    UnicodeString destination;
    int32_t capacity = source.length() * 3;
    UErrorCode status = U_ZERO_ERROR;
    int32_t length = u_strToLower(destination.getBuffer(capacity), capacity, source.getBuffer(),
                                  source.length(), "", &status);
    destination.releaseBuffer(U_SUCCESS(status) ? length : 0);
    return destination;
  };
  auto fold = [](const UnicodeString &source) {
    UnicodeString destination;
    int32_t capacity = source.length() * 3;
    UErrorCode status = U_ZERO_ERROR;
    int32_t length = u_strFoldCase(destination.getBuffer(capacity), capacity, source.getBuffer(),
                                   source.length(), U_FOLD_CASE_DEFAULT, &status);
    destination.releaseBuffer(U_SUCCESS(status) ? length : 0);
    return destination;
  };
  auto canonical_fold = [&](const UnicodeString &source) {
    return normalized(nfd, fold(normalized(nfd, source)));
  };
  // These are calls into the ICU shared library: nothing is inlined into the loop.
  for (const std::string &name : names(inputs + "/case")) {
    UnicodeString text = read(inputs + "/case/" + name + ".txt");
    UnicodeString folded = fold(text);
    long units = text.countChar32();
    auto simple_upper = [&]() {
      long sum = 0;
      for (int32_t i = 0; i < text.length();) {
        UChar32 c = text.char32At(i);
        sum ^= u_toupper(c);
        i += U16_LENGTH(c);
      }
      return sum;
    };
    auto caseless_match = [&]() {
      UErrorCode status = U_ZERO_ERROR;
      return (long)(u_strCaseCompare(text.getBuffer(), text.length(), folded.getBuffer(),
                                     folded.length(), U_FOLD_CASE_DEFAULT, &status) == 0);
    };
    auto lowercase_letters = [&]() {
      long count = 0;
      for (int32_t i = 0; i < text.length();) {
        UChar32 c = text.char32At(i);
        count += u_charType(c) == U_LOWERCASE_LETTER;
        i += U16_LENGTH(c);
      }
      return count;
    };
    auto alphabetic = [&]() {
      long count = 0;
      for (int32_t i = 0; i < text.length();) {
        UChar32 c = text.char32At(i);
        count += u_hasBinaryProperty(c, UCHAR_ALPHABETIC);
        i += U16_LENGTH(c);
      }
      return count;
    };
    auto line_break_al = [&]() {
      long count = 0;
      for (int32_t i = 0; i < text.length();) {
        UChar32 c = text.char32At(i);
        count += u_getIntPropertyValue(c, UCHAR_LINE_BREAK) == U_LB_ALPHABETIC;
        i += U16_LENGTH(c);
      }
      return count;
    };
    measure("case/simple_upper/" + name, units, simple_upper(), simple_upper);
    measure("case/full_upper/" + name, units, to_upper(text).countChar32(),
            [&]() { return (long)to_upper(text).length(); });
    measure("case/full_lower/" + name, units, to_lower(text).countChar32(),
            [&]() { return (long)to_lower(text).length(); });
    measure("case/fold/" + name, units, folded.countChar32(),
            [&]() { return (long)fold(text).length(); });
    measure("case/canonical_fold/" + name, units, canonical_fold(text).countChar32(),
            [&]() { return (long)canonical_fold(text).length(); });
    measure("case/nfkc_casefold/" + name, units, normalized(nfkc_casefold, text).countChar32(),
            [&]() { return (long)normalized(nfkc_casefold, text).length(); });
    measure("case/caseless_match/" + name, units, caseless_match(), caseless_match);
    measure("prop/general_category_Ll/" + name, units, lowercase_letters(), lowercase_letters);
    measure("prop/alphabetic/" + name, units, alphabetic(), alphabetic);
    measure("prop/line_break_AL/" + name, units, line_break_al(), line_break_al);
  }
}

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: xlang <inputs> [group]\n");
    return 2;
  }
  std::string inputs = argv[1];
  std::string group = argc > 2 ? argv[2] : "";
  const std::pair<const char *, void (*)(const std::string &)> groups[] = {
      {"norm", bench_normalization}, {"seg", bench_segmentation}, {"bidi", bench_bidi},
      {"idna", bench_idna},          {"case", bench_properties}};
  for (const auto &[name, bench] : groups)
    if (group.empty() || group == name) bench(inputs);
  return 0;
}
