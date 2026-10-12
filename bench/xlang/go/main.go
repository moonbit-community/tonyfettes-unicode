// Go peer of bench/xlang/moonbit: the same cases on the same inputs, timed
// with the same protocol and printed in the same row format.
package main

import (
	"fmt"
	"math"
	"os"
	"sort"
	"strings"
	"time"
	"unicode"
	"unicode/utf8"

	"github.com/rivo/uniseg"
	"golang.org/x/net/idna"
	"golang.org/x/text/unicode/bidi"
	"golang.org/x/text/unicode/norm"
)

var sink int

func run(iterations int, f func() int) float64 {
	start := time.Now()
	for i := 0; i < iterations; i++ {
		sink ^= f()
	}
	return float64(time.Since(start).Nanoseconds())
}

// measure doubles the iteration count until one sample takes at least 10 ms,
// then prints the fastest of 12 samples as
// library<TAB>case<TAB>ns<TAB>units<TAB>check.
func measure(library, name string, units int, check any, f func() int) {
	iterations := 1
	for run(iterations, f) < 1e7 {
		iterations *= 2
	}
	best := math.Inf(1)
	for i := 0; i < 12; i++ {
		best = math.Min(best, run(iterations, f))
	}
	fmt.Printf("%s\t%s\t%v\t%d\t%v\n", library, name, best/float64(iterations), units, check)
}

func read(path string) string {
	data, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return string(data)
}

// names lists the inputs in directory: the .txt files without their extension.
func names(directory string) []string {
	entries, err := os.ReadDir(directory)
	if err != nil {
		panic(err)
	}
	var result []string
	for _, entry := range entries {
		if name, ok := strings.CutSuffix(entry.Name(), ".txt"); ok {
			result = append(result, name)
		}
	}
	sort.Strings(result)
	return result
}

// pairs returns the name<TAB>value lines of a .tsv input.
func pairs(path string) [][2]string {
	var result [][2]string
	for _, line := range strings.Split(read(path), "\n") {
		if name, value, ok := strings.Cut(line, "\t"); ok {
			result = append(result, [2]string{name, value})
		}
	}
	return result
}

func toInt(b bool) int {
	if b {
		return 1
	}
	return 0
}

func benchNormalization(inputs string) {
	const library = "x/text"
	forms := []struct {
		name string
		form norm.Form
	}{{"nfc", norm.NFC}, {"nfd", norm.NFD}, {"nfkc", norm.NFKC}, {"nfkd", norm.NFKD}}
	for _, name := range names(inputs + "/norm") {
		original := read(inputs + "/norm/" + name + ".txt")
		decomposed := read(inputs + "/normd/" + name + ".txt")
		units := utf8.RuneCountInString(original)
		for _, f := range forms {
			form := f.form
			measure(library, "norm/"+f.name+"/"+name, units,
				utf8.RuneCountInString(form.String(original)),
				func() int { return len(form.String(original)) })
		}
		measure(library, "norm/nfd>nfc/"+name, utf8.RuneCountInString(decomposed),
			utf8.RuneCountInString(norm.NFC.String(decomposed)),
			func() int { return len(norm.NFC.String(decomposed)) })
		measure(library, "norm/is_nfc/"+name, units, toInt(norm.NFC.IsNormalString(original)),
			func() int { return toInt(norm.NFC.IsNormalString(original)) })
	}
}

func benchSegmentation(inputs string) {
	for _, name := range names(inputs + "/seg") {
		text := read(inputs + "/seg/" + name + ".txt")
		measure("uniseg", "seg/graphemes/"+name, utf8.RuneCountInString(text),
			uniseg.GraphemeClusterCount(text),
			func() int { return uniseg.GraphemeClusterCount(text) })
	}
}

func benchBidi(inputs string) {
	for _, name := range names(inputs + "/bidi") {
		text := read(inputs + "/bidi/" + name + ".txt")
		order := func() int {
			var paragraph bidi.Paragraph
			if _, err := paragraph.SetString(text); err != nil {
				panic(err)
			}
			ordering, err := paragraph.Order()
			if err != nil {
				panic(err)
			}
			return ordering.NumRuns()
		}
		// x/text exposes runs rather than levels, so there is no comparable check.
		measure("x/text", "bidi/process/"+name, utf8.RuneCountInString(text), "-", order)
	}
}

func benchIdna(inputs string) {
	// The closest match to the other harnesses: UTS #46 non-transitional
	// processing with Bidi, joiner and hyphen checks but without STD3 rules.
	profile := idna.New(idna.MapForLookup(), idna.BidiRule(), idna.CheckJoiners(true),
		idna.CheckHyphens(true), idna.StrictDomainName(false))
	for _, pair := range pairs(inputs + "/idna.tsv") {
		name, domain := pair[0], pair[1]
		ascii, err := profile.ToASCII(domain)
		if err != nil {
			panic(err)
		}
		unicode, err := profile.ToUnicode(domain)
		if err != nil {
			panic(err)
		}
		measure("x/net/idna", "idna/to_ascii/"+name, 1, utf8.RuneCountInString(ascii),
			func() int { result, _ := profile.ToASCII(domain); return len(result) })
		measure("x/net/idna", "idna/to_unicode/"+name, 1, utf8.RuneCountInString(unicode),
			func() int { result, _ := profile.ToUnicode(domain); return len(result) })
	}
}

func benchProperties(inputs string) {
	for _, name := range names(inputs + "/case") {
		text := read(inputs + "/case/" + name + ".txt")
		units := utf8.RuneCountInString(text)
		simpleUpper := func() int {
			sum := 0
			for _, r := range text {
				sum ^= int(unicode.ToUpper(r))
			}
			return sum
		}
		lowercaseLetters := func() int {
			count := 0
			for _, r := range text {
				if unicode.Is(unicode.Ll, r) {
					count++
				}
			}
			return count
		}
		measure("std", "case/simple_upper/"+name, units, simpleUpper(), simpleUpper)
		measure("std", "prop/general_category_Ll/"+name, units, lowercaseLetters(), lowercaseLetters)
	}
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: xlang <inputs> [group]")
		os.Exit(2)
	}
	inputs, group := os.Args[1], ""
	if len(os.Args) > 2 {
		group = os.Args[2]
	}
	groups := []struct {
		name  string
		bench func(string)
	}{
		{"norm", benchNormalization}, {"seg", benchSegmentation}, {"bidi", benchBidi},
		{"idna", benchIdna}, {"case", benchProperties},
	}
	for _, g := range groups {
		if group == "" || group == g.name {
			g.bench(inputs)
		}
	}
}
