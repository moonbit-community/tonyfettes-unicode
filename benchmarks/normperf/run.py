#!/usr/bin/env python3
"""Pinned ICU normperf corpora, equal UTF-16 inputs, untimed validation/preparation."""
import argparse
import concurrent.futures
import ctypes
import hashlib
import json
import os
from pathlib import Path
import platform
import shlex
import shutil
import subprocess
import urllib.request

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
REVISION = '457157a92aa053e632cc7fcfd0e12f8a943b2d11'  # ICU release-77-1
FILES = [f'TestNames_{name}' for name in [
    'Asian', 'Chinese', 'Japanese', 'Japanese_h', 'Japanese_k', 'Korean',
    'Latin', 'SerbianSH', 'SerbianSR', 'Thai', 'Russian',
]] + ['th18057', 'thesis', 'vfear11a']


def fetch():
    cache = HERE / '.cache'
    cache.mkdir(exist_ok=True)
    manifest_path = HERE / 'corpus.json'
    previous = json.loads(manifest_path.read_text()) if manifest_path.exists() else None
    if previous and (previous['revision'] != REVISION or [x['name'] for x in previous['files']] != FILES):
        raise ValueError('Corpus manifest does not match the pinned revision/file list')
    expected = {entry['name']: entry['sha256'] for entry in previous['files']} if previous else {}

    def download(name):
        relative = f'icu4j/perf-tests/data/collation/{name}.txt'
        url = f'https://raw.githubusercontent.com/unicode-org/icu/{REVISION}/{relative}'
        path = cache / f'{name}.txt'
        if not path.exists():
            with urllib.request.urlopen(url, timeout=60) as response:
                data = response.read()
            path.write_bytes(data)
        raw = path.read_bytes()
        digest = hashlib.sha256(raw).hexdigest()
        if name in expected and digest != expected[name]:
            raise ValueError(f'Checksum mismatch: {path}')
        # Match ICU's BOM detection/removal; otherwise preserve every character,
        # including CR/LF. No truncation, sampling, or newline normalization.
        encoding = 'utf-16' if raw.startswith((b'\xff\xfe', b'\xfe\xff')) else 'utf-8-sig'
        text = raw.decode(encoding)
        return dict(name=name, url=url, bytes=len(raw), sha256=digest, encoding=encoding), text

    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        loaded = list(pool.map(download, FILES))
    if not previous:
        manifest_path.write_text(json.dumps(dict(revision=REVISION, files=[x[0] for x in loaded]), indent=2) + '\n')
    return [(entry['name'], text) for entry, text in loaded]


def pkg(prefix, *args):
    env = dict(os.environ)
    env['PKG_CONFIG_PATH'] = str(prefix / 'lib/pkgconfig') + os.pathsep + env.get('PKG_CONFIG_PATH', '')
    return subprocess.check_output(['pkg-config', *args, 'icu-uc'], env=env, text=True).strip()


class ICU:
    def __init__(self, prefix):
        self.version = pkg(prefix, '--modversion')
        major = self.version.split('.')[0]
        library = prefix / 'lib' / ('libicuuc.dylib' if platform.system() == 'Darwin' else 'libicuuc.so')
        self.lib = ctypes.CDLL(str(library))
        def symbol(name):
            return getattr(self.lib, name + '_' + major)
        code = ctypes.c_int32(0)
        self.forms = {}
        for form in ['NFC', 'NFD']:
            get = symbol(f'unorm2_get{form}Instance')
            get.argtypes = [ctypes.POINTER(ctypes.c_int32)]
            get.restype = ctypes.c_void_p
            self.forms[form] = get(ctypes.byref(code))
            if code.value > 0:
                raise RuntimeError(f'ICU initialization failed: {code.value}')
        self.normalize = symbol('unorm2_normalize')
        ptr = ctypes.POINTER(ctypes.c_uint16)
        self.normalize.argtypes = [ctypes.c_void_p, ptr, ctypes.c_int32, ptr, ctypes.c_int32, ctypes.POINTER(ctypes.c_int32)]
        self.normalize.restype = ctypes.c_int32
        version = (ctypes.c_uint8 * 4)()
        get_version = symbol('u_getUnicodeVersion')
        get_version.argtypes = [ctypes.POINTER(ctypes.c_uint8)]
        get_version(version)
        self.unicode = '.'.join(map(str, version))
        if version[0] != 16:
            raise RuntimeError(f'Use a Unicode 16 ICU build; found Unicode {self.unicode}')

    def convert(self, text, form):
        raw = text.encode('utf-16-le')
        length = len(raw) // 2
        source = (ctypes.c_uint16 * length).from_buffer_copy(raw)
        error = ctypes.c_int32(0)
        needed = self.normalize(self.forms[form], source, length, None, 0, ctypes.byref(error))
        if error.value not in (0, 15):  # U_BUFFER_OVERFLOW_ERROR during preflight
            raise RuntimeError(f'ICU preflight failed: {error.value}')
        out = (ctypes.c_uint16 * (needed + 1))()
        error.value = 0
        count = self.normalize(self.forms[form], source, length, out, needed + 1, ctypes.byref(error))
        if error.value > 0:
            raise RuntimeError(f'ICU normalization failed: {error.value}')
        return bytes(out)[:count * 2].decode('utf-16-le')


def literal(text):
    return '"' + ''.join('\\' + c if c in '\\"' else f'\\u{{{ord(c):X}}}' if ord(c) < 32 or ord(c) in (0x2028, 0x2029) else c for c in text) + '"'


def prepare(prefix):
    icu = ICU(prefix)
    corpus = fetch()
    work = HERE / '.work'
    runner = work / 'runner'
    fixture_dir = work / 'fixtures'
    runner.mkdir(parents=True, exist_ok=True)
    fixture_dir.mkdir(exist_ok=True)
    (work / 'moon.work').write_text('members = ' + json.dumps([str(ROOT / 'ucd'), str(ROOT / 'normalization'), str(runner)]) + '\n')
    (runner / 'moon.mod').write_text('name = "local/normperf"\nversion = "0.0.0"\nimport { "moonbit-community/normalization@0.5.2", }\n')
    (runner / 'moon.pkg').write_text('import { "moonbit-community/normalization", "moonbitlang/core/bench", }\noptions("is-main": true)\n')
    shutil.copyfile(HERE / 'moon_main.mbt.in', runner / 'main.mbt')
    (fixture_dir / 'names.txt').write_text('\n'.join(FILES) + '\n')
    metadata, rows = [], []
    for index, (name, original) in enumerate(corpus):
        variants = dict(orig=original, nfc=icu.convert(original, 'NFC'), nfd=icu.convert(original, 'NFD'))
        references, declarations = {}, []
        unique = {}
        for state, text in variants.items():
            raw = text.encode('utf-16-le')
            (fixture_dir / f'{name}.{state}.bin').write_bytes(raw)
            if text not in unique:
                variable = f'fixture_{index}_{state}'
                chunks = ',\n'.join(literal(text[i:i+4096]) for i in range(0, len(text), 4096))
                declarations.append(f'///|\nlet {variable} : String = [\n{chunks}\n].join(\"\")\n')
                unique[text] = variable
            references[state] = unique[text]
            metadata.append(dict(name=name, state=state, utf16_units=len(raw)//2, codepoints=len(text),
                                 sha256=hashlib.sha256(raw).hexdigest(),
                                 is_nfc=text == variants['nfc'], is_nfd=text == variants['nfd']))
        (runner / f'fixture_{index}.mbt').write_text('\n'.join(declarations))
        rows.append(f'{{ name: "{name}", original: {references["orig"]}, nfc: {references["nfc"]}, nfd: {references["nfd"]} }}')
    (runner / 'fixtures.mbt').write_text('///|\nfn fixtures() -> Array[Fixture] {\n[' + ',\n'.join(rows) + ']\n}\n')
    (work / 'inputs.json').write_text(json.dumps(metadata, indent=2) + '\n')
    flags = shlex.split(pkg(prefix, '--cflags', '--libs'))
    subprocess.run(['c++', '-std=c++17', '-O3', str(HERE / 'icu.cpp'), *flags, '-o', str(work / 'icu')], check=True)
    return work, dict(icu=icu.version, unicode=icu.unicode, corpus_revision=REVISION,
                     source_revision=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
                     moon=subprocess.check_output(['moon', 'version'], text=True).strip(),
                     machine=platform.platform(), compiler=subprocess.check_output(['c++', '--version'], text=True).splitlines()[0])


def run(args):
    results = args.output.resolve()
    if not args.prepare_only and results.exists() and any(results.iterdir()):
        raise ValueError(f'Results directory is not empty: {results}; choose a new --output directory')
    work, metadata = prepare(args.icu_prefix)
    if args.prepare_only:
        print(f'Prepared {len(FILES)} full corpora in {work}', flush=True)
        return
    results.mkdir(parents=True, exist_ok=True)
    metadata.update(repeats=args.repeats, samples_per_case=5, sample_target_us=20000, calibration_min_us=10000)
    (results / 'environment.json').write_text(json.dumps(metadata, indent=2) + '\n')
    shutil.copyfile(work / 'inputs.json', results / 'inputs.json')
    # Compile everything before measurement; never run targets concurrently.
    commands = {'icu': [str(work / 'icu'), str(work / 'fixtures')]}
    for target in args.targets:
        subprocess.run(['moon', '-C', str(work), 'build', 'runner', '--target', target, '--release'], check=True)
        commands[target] = ['moon', '-C', str(work), 'run', 'runner', '--target', target, '--release']
    for run_index in range(args.repeats):
        # Rotate engine order to reduce systematic temperature/order bias.
        engines = list(commands)
        engines = engines[run_index % len(engines):] + engines[:run_index % len(engines)]
        for engine in engines:
            destination = results / f'{engine}-{run_index+1}.jsonl'
            print(f'Running {engine} {run_index+1}/{args.repeats}', flush=True)
            with destination.open('w') as output:
                subprocess.run(commands[engine], stdout=output, check=True, cwd=ROOT)
            records = [json.loads(line) for line in destination.read_text().splitlines()]
            expected = len(FILES) * 3 * 2 * (3 if engine == 'icu' else 2)
            if len(records) != expected:
                raise RuntimeError(f'Incomplete output: {destination}')
            print(f'Completed {engine}: {len(records)} cases', flush=True)
    print(f'Raw measurements saved in {results}', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    default_prefix = Path('/opt/homebrew/opt/icu4c@77')
    parser.add_argument('--icu-prefix', type=Path, default=default_prefix)
    parser.add_argument('--prepare-only', action='store_true')
    parser.add_argument('--targets', nargs='+', choices=['native','wasm','wasm-gc'], default=['native','wasm','wasm-gc'])
    parser.add_argument('--repeats', type=int, default=3)
    parser.add_argument('--output', type=Path, default=HERE / '.work/results')
    options = parser.parse_args()
    if options.repeats < 1:
        parser.error('--repeats must be positive')
    run(options)
