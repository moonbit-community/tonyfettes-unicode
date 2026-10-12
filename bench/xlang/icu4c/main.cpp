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

// Double the iteration count until one sample takes at least 10 ms, then print
// the fastest of 12 samples as library<TAB>case<TAB>ns<TAB>units<TAB>check.
// The library column is empty: this harness has one library.
static void measure(const std::string &name, long units, long check,
                    const std::function<long()> &f) {
  long iterations = 1;
  while (run(iterations, f) < 1e7) iterations *= 2;
  double best = run(iterations, f);
  for (int i = 1; i < 12; i++) best = std::min(best, run(iterations, f));
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

static void bench_normalization(const std::string &inputs) {
  UErrorCode status = U_ZERO_ERROR;
  const std::pair<const char *, const Normalizer2 *> forms[] = {
      {"nfc", Normalizer2::getNFCInstance(status)},
      {"nfd", Normalizer2::getNFDInstance(status)},
      {"nfkc", Normalizer2::getNFKCInstance(status)},
      {"nfkd", Normalizer2::getNFKDInstance(status)}};
  check_status(status, "Normalizer2");
  const Normalizer2 *nfc = forms[0].second;
  // A fresh destination per call, like the allocating APIs of the other harnesses.
  auto normalized = [](const Normalizer2 *form, const UnicodeString &source) {
    UnicodeString destination;
    UErrorCode status = U_ZERO_ERROR;
    form->normalize(source, destination, status);
    return destination;
  };
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
  BreakIterator *iterator = BreakIterator::createCharacterInstance(Locale::getRoot(), status);
  check_status(status, "BreakIterator");
  for (const std::string &name : names(inputs + "/seg")) {
    UnicodeString text = read(inputs + "/seg/" + name + ".txt");
    auto count = [&]() {
      iterator->setText(text);
      long clusters = 0;
      while (iterator->next() != BreakIterator::DONE) clusters++;
      return clusters;
    };
    measure("seg/graphemes/" + name, text.countChar32(), count(), count);
  }
  delete iterator;
}

static void bench_bidi(const std::string &inputs) {
  UBiDi *bidi = ubidi_open();
  for (const std::string &name : names(inputs + "/bidi")) {
    UnicodeString text = read(inputs + "/bidi/" + name + ".txt");
    UErrorCode status = U_ZERO_ERROR;
    ubidi_setPara(bidi, text.getBuffer(), text.length(), UBIDI_DEFAULT_LTR, nullptr, &status);
    const UBiDiLevel *levels = ubidi_getLevels(bidi, &status);
    check_status(status, "ubidi");
    long level_sum = 0;
    for (int32_t i = 0; i < text.length(); i++)
      if (!U16_IS_TRAIL(text[i])) level_sum += levels[i];
    measure("bidi/process/" + name, text.countChar32(), level_sum, [&]() {
      UErrorCode status = U_ZERO_ERROR;
      ubidi_setPara(bidi, text.getBuffer(), text.length(), UBIDI_DEFAULT_LTR, nullptr, &status);
      // Levels are computed lazily; ask for them as the other harnesses do.
      const UBiDiLevel *levels = ubidi_getLevels(bidi, &status);
      return (long)levels[text.length() - 1] + ubidi_getProcessedLength(bidi);
    });
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
  // These are calls into the ICU shared library: nothing is inlined into the loop.
  for (const std::string &name : names(inputs + "/case")) {
    UnicodeString text = read(inputs + "/case/" + name + ".txt");
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
    auto lowercase_letters = [&]() {
      long count = 0;
      for (int32_t i = 0; i < text.length();) {
        UChar32 c = text.char32At(i);
        count += u_charType(c) == U_LOWERCASE_LETTER;
        i += U16_LENGTH(c);
      }
      return count;
    };
    measure("case/simple_upper/" + name, units, simple_upper(), simple_upper);
    measure("prop/general_category_Ll/" + name, units, lowercase_letters(), lowercase_letters);
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
