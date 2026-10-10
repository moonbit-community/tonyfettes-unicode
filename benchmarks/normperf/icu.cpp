#include <unicode/normalizer2.h>
#include <unicode/uchar.h>
#include <unicode/unorm2.h>
#include <unicode/uversion.h>
#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <fstream>
#include <functional>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

static volatile int sink;
static void checked(UErrorCode error) {
    if (U_FAILURE(error)) throw std::runtime_error(u_errorName(error));
}
static std::u16string read(const std::string &path) {
    std::ifstream file(path, std::ios::binary);
    if (!file) throw std::runtime_error("Cannot read " + path);
    std::string bytes((std::istreambuf_iterator<char>(file)), {});
    if (bytes.size() % 2) throw std::runtime_error("Odd UTF-16 size");
    std::u16string result;
    for (size_t i = 0; i < bytes.size(); i += 2)
        result.push_back(static_cast<unsigned char>(bytes[i]) |
                         (static_cast<unsigned char>(bytes[i + 1]) << 8));
    return result;
}
static double elapsed(int count, const std::function<void()> &f) {
    auto start = std::chrono::steady_clock::now();
    for (int i = 0; i < count; ++i) f();
    return std::chrono::duration<double, std::micro>(
        std::chrono::steady_clock::now() - start).count();
}
static void measure(const std::string &name, const std::function<void()> &f) {
    int trial = 1;
    double duration = elapsed(trial, f);
    while (duration < 10000) duration = elapsed(trial *= 2, f);
    int count = std::max(1, static_cast<int>(trial * 20000.0 / duration));
    std::cout << "{\"name\":\"" << name << "\",\"iterations\":" << count << ",\"samples_us\":[";
    for (int i = 0; i < 5; ++i) {
        if (i) std::cout << ',';
        std::cout << elapsed(count, f) / count;
    }
    std::cout << "]}" << std::endl;
}
int main(int argc, char **argv) try {
    bool prepare = argc == 3 && std::string(argv[1]) == "prepare";
    if (argc != 2 && !prepare) throw std::runtime_error("Usage: icu [prepare] <fixture-directory>");
    std::string dir = argv[prepare ? 2 : 1];
    std::ifstream names(dir + "/names.txt");
    if (!names) throw std::runtime_error("Missing names.txt");
    UVersionInfo unicode;
    u_getUnicodeVersion(unicode);
    std::cerr << "ICU " << U_ICU_VERSION << ", Unicode " << int(unicode[0]) << '.' << int(unicode[1]) << '\n';
    if (unicode[0] != 16 || std::string(U_ICU_VERSION) != "77.1")
        throw std::runtime_error("Use ICU 77.1 with Unicode 16");
    if (prepare) {
        std::string name;
        while (std::getline(names, name)) {
            auto input = read(dir + "/" + name + ".orig.bin");
            icu::UnicodeString source(false, input.data(), static_cast<int32_t>(input.size()));
            for (bool decompose : {false, true}) {
                UErrorCode error = U_ZERO_ERROR;
                auto normalizer = decompose ? icu::Normalizer2::getNFDInstance(error) : icu::Normalizer2::getNFCInstance(error);
                checked(error);
                icu::UnicodeString result;
                normalizer->normalize(source, result, error);
                checked(error);
                std::ofstream output(dir + "/" + name + (decompose ? ".nfd.bin" : ".nfc.bin"), std::ios::binary);
                for (int32_t i = 0; i < result.length(); ++i) {
                    auto unit = result.charAt(i);
                    output.put(static_cast<char>(unit & 0xff));
                    output.put(static_cast<char>(unit >> 8));
                }
                output.close();
                if (!output) throw std::runtime_error("Cannot write normalized fixture");
            }
        }
        std::cout << "{\"icu\":\"" << U_ICU_VERSION << "\",\"unicode\":\""
                  << int(unicode[0]) << '.' << int(unicode[1]) << '.' << int(unicode[2]) << '.' << int(unicode[3]) << "\"}\n";
        return 0;
    }
    std::string name;
    while (std::getline(names, name)) {
        auto original = read(dir + "/" + name + ".orig.bin");
        auto nfc = read(dir + "/" + name + ".nfc.bin");
        auto nfd = read(dir + "/" + name + ".nfd.bin");
        for (bool decompose : {false, true}) {
            UErrorCode error = U_ZERO_ERROR;
            auto normalizer = decompose ? icu::Normalizer2::getNFDInstance(error) : icu::Normalizer2::getNFCInstance(error);
            auto c_normalizer = decompose ? unorm2_getNFDInstance(&error) : unorm2_getNFCInstance(&error);
            checked(error);
            auto &expected = decompose ? nfd : nfc;
            for (auto state : {"orig", "nfc", "nfd"}) {
                auto &input = std::string(state) == "orig" ? original : (std::string(state) == "nfc" ? nfc : nfd);
                icu::UnicodeString source(false, input.data(), static_cast<int32_t>(input.size()));
                icu::UnicodeString expected_string(false, expected.data(), static_cast<int32_t>(expected.size()));
                icu::UnicodeString validated;
                normalizer->normalize(source, validated, error);
                checked(error);
                if (validated != expected_string || bool(normalizer->isNormalized(source, error)) != (input == expected))
                    throw std::runtime_error("ICU validation mismatch");
                checked(error);
                std::vector<char16_t> output(expected.size() + 1);
                std::string key = name + "/" + state + "/" + (decompose ? "NFD" : "NFC");
                measure(key + "/normalize", [&] {
                    UErrorCode status = U_ZERO_ERROR;
                    icu::UnicodeString result;
                    normalizer->normalize(source, result, status);
                    checked(status);
                    sink = result.length();
                });
                measure(key + "/normalize_reuse", [&] {
                    UErrorCode status = U_ZERO_ERROR;
                    sink = unorm2_normalize(c_normalizer, input.data(), static_cast<int32_t>(input.size()),
                                           output.data(), static_cast<int32_t>(output.size()), &status);
                    checked(status);
                });
                if (sink != static_cast<int>(expected.size()) || !std::equal(expected.begin(), expected.end(), output.begin()))
                    throw std::runtime_error("Reusable output mismatch");
                measure(key + "/check", [&] {
                    UErrorCode status = U_ZERO_ERROR;
                    sink = normalizer->isNormalized(source, status);
                    checked(status);
                });
            }
        }
    }
} catch (const std::exception &error) {
    std::cerr << error.what() << '\n';
    return 1;
}
