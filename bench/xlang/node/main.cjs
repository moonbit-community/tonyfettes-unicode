// Node peer of bench/xlang/moonbit: the same cases on the same inputs, timed
// with the same protocol and printed in the same row format. It measures what
// a JavaScript program gets from the platform: String.prototype.normalize and
// Intl.Segmenter (ICU4C behind V8), url.domainTo* (ada) and the bundled
// punycode.js. Every call crosses from JavaScript into the runtime.
'use strict';

const fs = require('node:fs');
const url = require('node:url');
const punycode = require('node:punycode');

let sink = 0;
function run(iterations, f) {
  const start = process.hrtime.bigint();
  for (let i = 0; i < iterations; i++) sink ^= f();
  return Number(process.hrtime.bigint() - start);
}

// The latest result a case built. Every result is stored here, where it can be
// read later, so that V8 cannot drop the work that builds it: it drops a string
// that only has its length read, as it can compute the length without it.
let kept;
function keep(result) {
  kept = result;
  return result.length;
}

// Double the iteration count until one sample takes at least 5 ms, then print
// the fastest of 5 samples, the first of which is that one, as
// library<TAB>case<TAB>ns<TAB>units<TAB>check.
// The library column is empty: each case has a single platform API.
function measure(name, units, check, f) {
  let iterations = 1;
  let best = run(iterations, f);
  while (best < 5e6) {
    iterations *= 2;
    best = run(iterations, f);
  }
  for (let i = 1; i < 5; i++) best = Math.min(best, run(iterations, f));
  console.log(`\t${name}\t${best / iterations}\t${units}\t${check}`);
}

const read = (path) => fs.readFileSync(path, 'utf8');
// Input names in `directory`: the .txt files without their extension.
const names = (directory) =>
  fs.readdirSync(directory).filter((file) => file.endsWith('.txt')).map((file) => file.slice(0, -4)).sort();
// The name<TAB>value lines of a .tsv input.
const pairs = (path) => read(path).split('\n').filter((line) => line.includes('\t')).map((line) => line.split('\t'));
const codePoints = (text) => {
  let count = 0;
  for (const _ of text) count++;
  return count;
};

function benchNormalization(inputs) {
  for (const name of names(`${inputs}/norm`)) {
    const original = read(`${inputs}/norm/${name}.txt`);
    const decomposed = read(`${inputs}/normd/${name}.txt`);
    const units = codePoints(original);
    for (const form of ['NFC', 'NFD', 'NFKC', 'NFKD']) {
      measure(`norm/${form.toLowerCase()}/${name}`, units, codePoints(original.normalize(form)),
        () => keep(original.normalize(form)));
    }
    measure(`norm/nfd>nfc/${name}`, codePoints(decomposed), codePoints(decomposed.normalize('NFC')),
      () => keep(decomposed.normalize('NFC')));
  }
}

function benchSegmentation(inputs) {
  const segmenter = new Intl.Segmenter(undefined, { granularity: 'grapheme' });
  for (const name of names(`${inputs}/seg`)) {
    const text = read(`${inputs}/seg/${name}.txt`);
    const count = () => {
      let clusters = 0;
      for (const _ of segmenter.segment(text)) clusters++;
      return clusters;
    };
    measure(`seg/graphemes/${name}`, codePoints(text), count(), count);
  }
}

function benchIdna(inputs) {
  for (const [name, domain] of pairs(`${inputs}/idna.tsv`)) {
    measure(`idna/to_ascii/${name}`, 1, codePoints(url.domainToASCII(domain)),
      () => keep(url.domainToASCII(domain)));
    measure(`idna/to_unicode/${name}`, 1, codePoints(url.domainToUnicode(domain)),
      () => keep(url.domainToUnicode(domain)));
  }
}

function benchPunycode(inputs) {
  for (const [name, input] of pairs(`${inputs}/puny.tsv`)) {
    const encoded = punycode.encode(input);
    measure(`puny/encode/${name}`, 1, encoded.length, () => keep(punycode.encode(input)));
    measure(`puny/decode/${name}`, 1, codePoints(input), () => keep(punycode.decode(encoded)));
  }
}

const [inputs, group] = process.argv.slice(2);
if (!inputs) {
  console.error('usage: node main.cjs <inputs> [group]');
  process.exit(2);
}
const groups = { norm: benchNormalization, seg: benchSegmentation, idna: benchIdna, puny: benchPunycode };
for (const [name, bench] of Object.entries(groups)) {
  if (!group || group === name) bench(inputs);
}
