// The performance dashboard. It reads two files next to the page:
// - snapshot.json: a full run of every harness, `results.json` of `bench/xlang`;
// - history.json: one entry per push to main, `compare.json` of
//   `bench/xlang --base` without its per-case costs, in the order recorded.
// Either may be missing; its sections then say so.
'use strict';

const IMPL = {
  "moonbit-native": { label: "MoonBit native", color: "--mb-native" },
  "moonbit-wasm-gc": { label: "MoonBit wasm-gc", color: "--mb-wasm" },
  "moonbit-wasm": { label: "MoonBit wasm", color: "--mb-wasm1" },
  "moonbit-js": { label: "MoonBit JS", color: "--mb-js" },
  "rust icu4x-utf16": { label: "ICU4X UTF-16", color: "--icu4x16" },
  "rust icu4x-utf8": { label: "ICU4X UTF-8", color: "--icu4x8" },
  "icu4c": { label: "ICU4C", color: "--icu4c" },
  "node": { label: "JS built-in", color: "--node" },
  "rust simd-normalizer": { label: "simd-normalizer", color: "--simd" },
  "rust idna": { label: "Rust idna", color: "--icu4x8" },
  "rust unicode-normalization": { label: "unicode-normalization", color: "--other" },
  "rust unicode-segmentation": { label: "unicode-segmentation", color: "--other" },
  "rust unicode-bidi": { label: "unicode-bidi", color: "--other" },
  "rust unicode-bidi-utf16": { label: "unicode-bidi (UTF-16)", color: "--other" },
  "rust std": { label: "Rust std", color: "--other" },
  "rust unicode-general-category": { label: "unicode-general-category", color: "--other" },
};
const ORDER = Object.keys(IMPL);
const BACKENDS = ["moonbit-native", "moonbit-wasm-gc", "moonbit-wasm", "moonbit-js"];

const OPS = [
  ["norm/nfc", "NFC"], ["norm/nfd", "NFD"], ["norm/nfkc", "NFKC"], ["norm/nfkd", "NFKD"],
  ["norm/nfd>nfc", "NFD → NFC"], ["norm/is_nfc", "Is it NFC?"],
  ["seg/graphemes", "Grapheme clusters"], ["bidi/process", "Bidi levels"],
  ["idna/to_ascii", "IDNA ToASCII"], ["idna/to_unicode", "IDNA ToUnicode"],
  ["puny/encode", "Punycode encode"], ["puny/decode", "Punycode decode"],
  ["case/simple_upper", "Simple uppercase"], ["case/full_upper", "Full uppercase"],
  ["case/fold", "Case folding"], ["case/nfkc_casefold", "NFKC_Casefold"],
  ["prop/general_category_Ll", "General category"],
];
const OP_LABEL = Object.fromEntries(OPS);
const perCall = op => op.startsWith("idna/") || op.startsWith("puny/");
const unit = op => perCall(op) ? "ns / call" : "ns / code point";
const JS_API = {
  norm: "String.prototype.normalize", seg: "Intl.Segmenter",
  "idna/to_ascii": "url.domainToASCII", "idna/to_unicode": "url.domainToUnicode", puny: "node:punycode",
};

// The repository, from the Pages address <owner>.github.io/<repository>/.
const REPO = (() => {
  const owner = location.hostname.endsWith(".github.io") ? location.hostname.split(".")[0] : "";
  const name = location.pathname.split("/").filter(Boolean)[0];
  return owner && name ? `https://github.com/${owner}/${name}` : "";
})();

const css = name => `var(${name})`;
const el = (tag, attrs = {}, html = "") => {
  const e = document.createElement(tag);
  Object.assign(e, attrs);
  if (html) e.innerHTML = html;
  return e;
};
const escapeHtml = text => String(text).replace(/[&<>"']/g, c => `&#${c.charCodeAt(0)};`);
const remember = (key, value) => { try { localStorage.setItem(key, value); } catch (e) {} };
const recall = key => { try { return localStorage.getItem(key); } catch (e) { return null; } };

async function load(path) {
  try {
    const response = await fetch(path, { cache: "no-cache" });
    return response.ok ? await response.json() : null;
  } catch (e) {
    return null;
  }
}

function fmt(v) {
  if (v == null) return "–";
  if (v >= 100) return Math.round(v).toString();
  if (v >= 10) return v.toFixed(1);
  if (v >= 1) return v.toFixed(2);
  return v.toFixed(v < 0.1 ? 3 : 2);
}
const fx = r => (r >= 10 ? r.toFixed(0) : r.toFixed(r >= 2 ? 1 : 2)) + "×";
const change = r => {
  const tenths = Math.round((r - 1) * 1000);
  return (tenths > 0 ? "+" : tenths < 0 ? "−" : "") + (Math.abs(tenths) / 10).toFixed(1) + "%";
};
function relWords(ratio) {
  // ratio = other / reference time. >1: reference is faster.
  if (ratio > 1.04) return { cls: "up", text: fx(ratio) + " faster" };
  if (ratio < 0.96) return { cls: "down", text: fx(1 / ratio) + " slower" };
  return { cls: "", text: "about even" };
}
// r = time / reference time. Faster is green, slower red, on a log scale that
// is full at `cap`.
function tint(r, cap, floor = 0.04) {
  if (!isFinite(r) || Math.abs(Math.log(r)) < floor) return "transparent";
  const a = Math.min(1, Math.abs(Math.log(r)) / Math.log(cap)) * 0.32 + 0.04;
  return r < 1 ? `rgba(var(--good-tint), ${a})` : `rgba(var(--bad-tint), ${a})`;
}

// Chips that pick one of `options` ([value, label]); `onPick` gets the value.
function chips(target, options, current, onPick) {
  const group = document.getElementById(target);
  group.innerHTML = "";
  for (const [value, label] of options) {
    const b = el("button", { className: "chip", type: "button" }, escapeHtml(label));
    b.setAttribute("aria-pressed", value === current);
    b.onclick = () => {
      [...group.children].forEach(c => c.setAttribute("aria-pressed", c === b));
      onPick(value);
    };
    group.appendChild(b);
  }
}

// ---------------------------------------------------------------- history

// A commit of a history entry as a link, with the pull request it merged.
// `pick` is the checkbox that ticks the entry for combining.
function commitCell(commit, pick = "") {
  const sha = commit.commit || "";
  const short = sha.slice(0, 7);
  const subject = commit.subject || "";
  const merge = subject.match(/^Merge pull request #(\d+) from /);
  const squash = subject.match(/\(#(\d+)\)$/);
  const pr = merge ? merge[1] : squash ? squash[1] : null;
  const title = merge && commit.title ? commit.title : subject;
  const shaHtml = REPO && sha
    ? `<a class="sha" href="${REPO}/commit/${sha}">${short}</a>` : `<span class="sha">${short}</span>`;
  const titleHtml = REPO && pr
    ? `<a href="${REPO}/pull/${pr}">${escapeHtml(title)}</a>` : escapeHtml(title);
  const when = (commit.date || "").slice(0, 10);
  return `<td class="commit">${pick}${shaHtml}${titleHtml}<span class="when">${when}${commit.dirty ? " · uncommitted changes" : ""}</span></td>`;
}

// A change in time as a cell: greyed out within `noise`, a ratio itself.
function changeCell(r, noise, title = "") {
  if (r == null) return `<td class="muted">–</td>`;
  const t = title ? ` title="${escapeHtml(title)}"` : "";
  return Math.abs(r - 1) <= noise
    ? `<td class="change quiet"${t}>${change(r)}</td>`
    : `<td class="change"${t} style="background:${tint(r, 1.5, 0)}">${change(r)}</td>`;
}

function renderHistory(history) {
  const body = document.getElementById("history-body");
  // Newest first. Runs may finish out of order, so sort by commit date.
  const runs = (history || []).slice().reverse().sort((a, b) =>
    Date.parse(b.about?.head?.date || 0) - Date.parse(a.about?.head?.date || 0));
  if (!runs.length) {
    document.getElementById("backend-chips").closest(".controls").hidden = true;
    body.appendChild(el("p", { className: "empty" },
      "No runs yet. Each merge to main adds one once the benchmark workflow has run."));
    return;
  }
  const present = BACKENDS.filter(b => runs.some(run => Object.values(run.operations || {}).some(r => b in r)));
  let backend = recall("ub-backend");
  if (!present.includes(backend)) backend = present[0];
  const LIMIT = 30;
  let showAll = false;
  const shaOf = run => run.about?.head?.commit || "";
  const baseOf = run => run.about?.base?.commit || "";
  // Changes within the noise of a run are greyed out; 2% at least.
  const noiseOf = run => Math.max(0.02, (run.spread?.[backend] ?? 1) - 1);

  // The merges combined: rows lo..hi of `runs`, newest first, always one
  // unbroken stretch, so that together they are the change over a range of
  // main. The address keeps it as #range=<base>..<head>, in git's sense: the
  // merges after <base> up to <head>.
  let range = null;
  const readRange = () => {
    range = null;
    const wanted = new URLSearchParams(location.hash.slice(1)).get("range") || "";
    const [from, to] = wanted.split("..");
    if (!from || !to || from.length < 4 || to.length < 4) return;
    const hi = runs.findIndex(run => baseOf(run).startsWith(from));
    const lo = runs.findIndex(run => shaOf(run).startsWith(to));
    if (lo < 0 || hi < lo) return;
    range = { lo, hi };
    if (hi >= LIMIT) showAll = true;
  };
  readRange();
  const saveRange = () => {
    const hash = range ? `#range=${baseOf(runs[range.hi]).slice(0, 7)}..${shaOf(runs[range.lo]).slice(0, 7)}` : "";
    try { window.history.replaceState(null, "", location.pathname + location.search + hash); } catch (e) {}
  };

  // The costs of every case of a run, `runs/<head>.json`, fetched once.
  const costs = new Map();
  const costsOf = run => {
    const sha = shaOf(run);
    if (!costs.has(sha)) {
      costs.set(sha, { state: "loading" });
      load(`runs/${sha}.json`).then(data => {
        costs.set(sha, data?.cases ? { state: "done", cases: data.cases } : { state: "missing" });
        draw();
      });
    }
    return costs.get(sha);
  };

  // The combined change of the range, per operation. Each run times its base
  // and head on one runner, but different runs land on different machines, so
  // times cannot be compared across runs, only ratios. Per case, the ratios of
  // the runs multiply into the change from the base of the oldest to the head
  // of the newest; the geometric mean over the cases that every run measured
  // gives the operation's. Cases some run lacks, because the harness added
  // them within the range, are left out. Without the costs of a run, it falls
  // back on multiplying the runs' means, which differ from the per-case figure
  // only where the inputs changed. Noise adds up too: in log space, as the
  // root of the sum of squares.
  const combinedRow = ops => {
    if (!range || range.hi === range.lo) return "";
    const chosen = runs.slice(range.lo, range.hi + 1);
    const all = chosen.map(costsOf);
    const loading = all.some(c => c.state === "loading");
    const perCase = all.every(c => c.state === "done");
    // Pushes that were never compared (they changed no library code, or their
    // run failed) leave a run whose base is not the head of the one before.
    const gaps = chosen.filter((run, k) => k < chosen.length - 1 && baseOf(run) !== shaOf(chosen[k + 1])).length;
    const noise = Math.expm1(Math.sqrt(chosen.reduce((a, run) => a + Math.log1p(noiseOf(run)) ** 2, 0)));
    const from = baseOf(chosen[chosen.length - 1]);
    const to = shaOf(chosen[0]);
    const label = `${from.slice(0, 7)} → ${to.slice(0, 7)}`;
    const span = REPO && from && to ? `<a href="${REPO}/compare/${from}...${to}">${label}</a>` : label;
    const notes = [];
    if (gaps) notes.push(`${gaps} push${gaps > 1 ? "es" : ""} between them ${gaps > 1 ? "were" : "was"} not compared and count${gaps > 1 ? "" : "s"} as no change`);
    if (!loading && !perCase) notes.push("some per-case costs are missing, so this multiplies the merges' means");
    let dropped = false;
    const cells = ops.map(([op]) => {
      if (loading) return `<td class="muted">…</td>`;
      if (!perCase) {
        const rs = chosen.map(run => run.operations?.[op]?.[backend]);
        if (rs.some(r => r == null)) return `<td class="muted" title="not measured by every merge">–</td>`;
        return changeCell(Math.exp(rs.reduce((a, r) => a + Math.log(r), 0)), noise);
      }
      const prefix = op + "/";
      const names = new Set();
      for (const c of all) for (const name of Object.keys(c.cases)) if (name.startsWith(prefix)) names.add(name);
      const logs = [];
      for (const name of names) {
        let sum = 0;
        const complete = all.every(c => {
          const [base, head] = c.cases[name]?.[backend] || [];
          if (!(base > 0 && head > 0)) return false;
          sum += Math.log(head / base);
          return true;
        });
        if (complete) logs.push(sum);
      }
      if (!logs.length) return `<td class="muted" title="not measured by every merge">–</td>`;
      const partial = logs.length < names.size;
      dropped ||= partial;
      const r = Math.exp(logs.reduce((a, x) => a + x, 0) / logs.length);
      return changeCell(r, noise, partial ? `over the ${logs.length} of ${names.size} inputs that every merge measured` : "");
    }).join("");
    if (dropped) notes.push("inputs added within the range are left out; hover a cell for how many");
    return `<tr class="combined"><td class="commit"><span class="label">Combined · ${chosen.length} merges</span>` +
      `<span class="when">${span} · noise ±${(noise * 100).toFixed(1)}%</span>` +
      notes.map(n => `<span class="when">${n}</span>`).join("") + `</td>${cells}</tr>`;
  };

  const draw = () => {
    const ops = OPS.filter(([op]) => runs.some(run => run.operations?.[op]?.[backend] != null));
    const shown = showAll ? runs : runs.slice(0, LIMIT);
    const head = `<thead><tr><th>merge</th>${ops.map(([, label]) => `<th class="op">${label}</th>`).join("")}</tr></thead>`;
    const rows = shown.map((run, i) => {
      const sha = shaOf(run);
      const on = range != null && i >= range.lo && i <= range.hi;
      const pick = `<input type="checkbox" class="pick" data-index="${i}"${on ? " checked" : ""} aria-label="Combine ${escapeHtml(sha.slice(0, 7))}">`;
      const cells = ops.map(([op]) => changeCell(run.operations?.[op]?.[backend], noiseOf(run))).join("");
      return `<tr${on ? ` class="picked"` : ""}>${commitCell(run.about?.head || {}, pick)}${cells}</tr>`;
    }).join("");
    body.innerHTML = `<div class="table-scroll history"><table>${head}<tbody>${combinedRow(ops)}${rows}</tbody></table></div>`;
    if (runs.length > LIMIT && !showAll) {
      const more = el("button", { className: "chip more", type: "button" }, `Show all ${runs.length} merges`);
      more.onclick = () => { showAll = true; draw(); };
      body.appendChild(more);
    }
  };
  const setRange = next => {
    range = next;
    saveRange();
    draw();
  };
  // Ticking a merge stretches the range to it, ticking every merge between.
  // Unticking one at an end shrinks the range by it; unticking one inside
  // drops it and every older merge, keeping the newer end.
  body.addEventListener("click", event => {
    const box = event.target.closest("input.pick");
    if (!box) return;
    const i = Number(box.dataset.index);
    if (box.checked) {
      setRange(range ? { lo: Math.min(range.lo, i), hi: Math.max(range.hi, i) } : { lo: i, hi: i });
    } else if (range.lo === range.hi) {
      setRange(null);
    } else if (i === range.hi) {
      setRange({ lo: range.lo, hi: i - 1 });
    } else if (i === range.lo) {
      setRange({ lo: i + 1, hi: range.hi });
    } else {
      setRange({ lo: range.lo, hi: i - 1 });
    }
    body.querySelector(`input.pick[data-index="${i}"]`)?.focus();
  });
  const combine = document.getElementById("combine-chips");
  combine.innerHTML = "";
  for (const n of [2, 3, 5, 10].filter(n => n <= runs.length)) {
    const b = el("button", { className: "chip", type: "button" }, `Last ${n}`);
    b.onclick = () => setRange({ lo: 0, hi: n - 1 });
    combine.appendChild(b);
  }
  const none = el("button", { className: "chip", type: "button" }, "None");
  none.onclick = () => setRange(null);
  combine.appendChild(none);

  // A link to another range, opened in this tab, changes only the hash.
  window.addEventListener("hashchange", () => { readRange(); draw(); });

  chips("backend-chips", present.map(b => [b, IMPL[b].label.replace("MoonBit ", "")]), backend, value => {
    backend = value;
    remember("ub-backend", value);
    draw();
  });
  draw();
}

// --------------------------------------------------------------- snapshot

function renderSnapshotMeta(about) {
  const commit = about.commit || {};
  const parts = [];
  if (commit.commit) {
    const short = commit.commit.slice(0, 7);
    const label = `${short}${commit.dirty ? " with uncommitted changes" : ""}`;
    parts.push(REPO ? `<a href="${REPO}/commit/${commit.commit}" style="color:inherit">${label}</a>` : label);
  }
  if (about.machine) parts.push(escapeHtml(about.machine));
  for (const [name, version] of Object.entries(about.versions || {})) {
    parts.push(escapeHtml(version.toLowerCase().startsWith(name.toLowerCase()) ? version : `${name} ${version}`));
  }
  if (about.rounds) parts.push(`fastest of ${about.rounds} rounds`);
  if (about.date) parts.push(escapeHtml(about.date.slice(0, 10)));
  document.getElementById("snapshot-meta").innerHTML = parts.map(p => `<span>${p}</span>`).join("");
}

function renderSnapshot(snapshot) {
  if (!snapshot || !snapshot.cases) {
    document.getElementById("snapshot-meta").replaceWith(el("p", { className: "empty" },
      "No snapshot has been published yet. Copy <code>_build/xlang/results.json</code> of a full run to <code>bench/xlang/site/snapshot.json</code>."));
    for (const id of ["icu4x", "js", "cases"]) document.getElementById(id).hidden = true;
    return;
  }
  renderSnapshotMeta(snapshot.about || {});
  const DATA = snapshot.cases;
  // Only implementations that take UTF-16 strings, so every comparison reads
  // the same bytes. Cases left with no peer for MoonBit are dropped.
  const UTF16 = new Set(["moonbit-native", "moonbit-wasm-gc", "moonbit-wasm", "moonbit-js", "rust icu4x-utf16", "icu4c", "node", "rust unicode-bidi-utf16"]);
  for (const [key, row] of Object.entries(DATA)) {
    for (const impl of Object.keys(row)) if (!UTF16.has(impl)) delete row[impl];
    if (!Object.keys(row).some(i => !i.startsWith("moonbit-"))) delete DATA[key];
  }
  // op -> { input -> { impl -> ns } }
  const byOp = {};
  for (const [key, row] of Object.entries(DATA)) {
    const [g, o, ...rest] = key.split("/");
    (byOp[g + "/" + o] ||= {})[rest.join("/")] = row;
  }
  const geomean = (op, impl) => {
    const vals = Object.values(byOp[op] || {}).map(r => r[impl]).filter(v => v != null);
    if (!vals.length) return null;
    return Math.exp(vals.reduce((a, v) => a + Math.log(v), 0) / vals.length);
  };
  const legend = (target, impls) => {
    document.getElementById(target).innerHTML = impls
      .map(i => `<span><i style="background:${css(IMPL[i].color)}"></i>${IMPL[i].label}</span>`).join("");
  };
  const card = (op, impls, ref, opts = {}) => {
    const vals = impls.map(i => [i, geomean(op, i)]).filter(([, v]) => v != null);
    const refVal = geomean(op, ref);
    if (!vals.length || refVal == null) return null;
    const max = Math.max(...vals.map(([, v]) => v));
    const c = el("article", { className: "card" });
    c.appendChild(el("div", { className: "card-head" }, `<h3>${OP_LABEL[op]}</h3><span class="unit">${unit(op)}</span>`));
    if (opts.api) c.appendChild(el("div", { className: "api" }, opts.api));
    const bars = el("div", { className: "bars" });
    for (const [i, v] of vals) {
      const r = el("div", { className: "bar" + (i === ref ? " ref" : "") });
      const rel = i === ref ? "" : ` <small>${fx(v / refVal)}</small>`;
      r.innerHTML = `<span class="name" title="${IMPL[i].label}">${IMPL[i].label}</span>
        <span class="track"><span class="fill" style="width:${Math.max(1.5, (v / max) * 100)}%;background:${css(IMPL[i].color)}"></span></span>
        <span class="val">${fmt(v)}${rel}</span>`;
      bars.appendChild(r);
    }
    c.appendChild(bars);
    if (opts.verdict) {
      const verdict = opts.verdict(refVal);
      if (verdict) c.appendChild(el("p", { className: "verdict" }, verdict));
    }
    return c;
  };

  // Against ICU
  const ICU_IMPLS = ["moonbit-native", "moonbit-wasm-gc", "moonbit-wasm", "rust icu4x-utf16", "icu4c", "rust unicode-bidi-utf16"];
  legend("legend-icu", ICU_IMPLS.filter(i => Object.values(DATA).some(row => i in row)));
  const gridIcu = document.getElementById("grid-icu");
  const ICU_OPS = ["norm/nfc", "norm/nfd", "norm/nfkc", "norm/nfkd", "norm/nfd>nfc", "norm/is_nfc", "seg/graphemes",
    "bidi/process", "idna/to_ascii", "idna/to_unicode", "case/simple_upper", "prop/general_category_Ll"];
  for (const op of ICU_OPS) {
    const rivals = ["rust icu4x-utf16", "icu4c", "rust unicode-bidi-utf16"]
      .map(i => [i, geomean(op, i)]).filter(([, v]) => v != null).sort((a, b) => a[1] - b[1]);
    const c = card(op, ICU_IMPLS, "moonbit-native", {
      api: op === "bidi/process" ? "ICU4X has no bidi resolver in this harness"
        : op.startsWith("idna") || op.startsWith("case") || op.startsWith("prop") ? "ICU4X is measured here only on UTF-8" : "",
      verdict: refVal => {
        if (!rivals.length) return "";
        const [best, bv] = rivals[0];
        const w = relWords(bv / refVal);
        return `MoonBit native vs ${IMPL[best].label}, the fastest of the others: <b class="${w.cls}">${w.text}</b>`;
      },
    });
    if (c) gridIcu.appendChild(c);
  }

  // JS
  const JS_OPS = ["norm/nfc", "norm/nfd", "norm/nfkc", "norm/nfkd", "norm/nfd>nfc", "seg/graphemes",
    "idna/to_ascii", "idna/to_unicode", "puny/encode", "puny/decode"];
  legend("legend-js", ["moonbit-js", "node", "moonbit-native"]);
  const gridJs = document.getElementById("grid-js");
  for (const op of JS_OPS) {
    const api = JS_API[op] || JS_API[op.split("/")[0]];
    const c = card(op, ["moonbit-js", "node", "moonbit-native"], "moonbit-js", {
      api: "built-in: " + api,
      verdict: refVal => {
        const node = geomean(op, "node");
        if (node == null) return "";
        const w = relWords(node / refVal);
        return `MoonBit JS vs <code>${api}</code>: <b class="${w.cls}">${w.text}</b>`;
      },
    });
    if (c) gridJs.appendChild(c);
  }
  if (!gridJs.children.length) document.getElementById("js").hidden = true;

  // Findings: [ratio, text], where ratio = time of b / time of a.
  const ratio = (op, a, b) => {
    const x = geomean(op, a), y = geomean(op, b);
    return x != null && y != null ? y / x : null;
  };
  const findings = [
    [ratio("norm/nfd>nfc", "moonbit-native", "rust icu4x-utf16"), "ICU4X (UTF-16) at composing NFD into NFC, MoonBit native, geometric mean over the corpora"],
    [ratio("norm/nfd", "moonbit-native", "rust icu4x-utf16"), "ICU4X (UTF-16) at NFD, which forces every character through decomposition"],
    [ratio("idna/to_ascii", "moonbit-native", "icu4c"), "ICU4C at IDNA ToASCII, MoonBit native, per call"],
    [ratio("norm/nfc", "moonbit-wasm", "moonbit-wasm-gc"), "wasm-gc at NFC with the wasm backend, which compiles the SIMD scan to simd128"],
    [ratio("seg/graphemes", "moonbit-js", "node"), "Intl.Segmenter at grapheme clusters, with MoonBit compiled to plain JavaScript"],
    [ratio("norm/nfd", "moonbit-js", "node"), "String.prototype.normalize at NFD on the JS backend, where V8 calls into C++ ICU"],
  ].filter(([r]) => r != null);
  document.getElementById("findings").innerHTML = findings.map(([r, text]) => {
    const [n, word] = r >= 1 ? [fx(r), "faster than"] : [fx(1 / r), "slower than"];
    return `<div class="finding"><b>${n}</b><span>${word} ${text}</span></div>`;
  }).join("");

  // Every case
  const baseSel = document.getElementById("baseline");
  const SHOWN_OPS = OPS.filter(([op]) => byOp[op]);
  let curOp = recall("ub-op");
  if (!byOp[curOp]) curOp = byOp["norm/nfd>nfc"] ? "norm/nfd>nfc" : SHOWN_OPS[0]?.[0];
  const implsFor = op => {
    const present = new Set();
    for (const row of Object.values(byOp[op])) Object.keys(row).forEach(k => present.add(k));
    return ORDER.filter(i => present.has(i));
  };
  const renderTable = () => {
    if (!curOp) return;
    const impls = implsFor(curOp);
    const prev = baseSel.value;
    baseSel.innerHTML = impls.map(i => `<option value="${i}">${IMPL[i].label}</option>`).join("");
    baseSel.value = impls.includes(prev) ? prev : impls.includes("moonbit-native") ? "moonbit-native" : impls[0];
    const base = baseSel.value;
    const rows = byOp[curOp];
    const inputs = Object.keys(rows).sort((a, b) => a.localeCompare(b));
    const head = `<thead><tr><th>input <span class="muted" style="font-weight:400">(${unit(curOp)})</span></th>${impls.map(i =>
      `<th><span class="sw" style="background:${css(IMPL[i].color)}"></span>${IMPL[i].label}</th>`).join("")}</tr></thead>`;
    const cell = (v, b) => {
      if (v == null) return `<td class="muted">–</td>`;
      const r = v / b;
      return `<td style="background:${tint(r, 8)}">${fmt(v)}<span class="r">${isFinite(r) ? r.toFixed(2) + "×" : ""}</span></td>`;
    };
    const body = inputs.map(name => `<tr><td>${escapeHtml(name.replace(/^TestNames_/, "Names · "))}</td>${impls.map(i => cell(rows[name][i], rows[name][base])).join("")}</tr>`).join("");
    const gm = `<tr class="gm"><td>geometric mean</td>${impls.map(i => cell(geomean(curOp, i), geomean(curOp, base))).join("")}</tr>`;
    document.getElementById("case-table").innerHTML = head + `<tbody>${body}${gm}</tbody>`;
  };
  chips("op-chips", SHOWN_OPS, curOp, op => { curOp = op; remember("ub-op", op); renderTable(); });
  baseSel.onchange = renderTable;
  renderTable();
  document.getElementById("case-count").textContent = `All ${Object.keys(DATA).length} cases`;
}

Promise.all([load("snapshot.json"), load("history.json")]).then(([snapshot, history]) => {
  renderHistory(history);
  renderSnapshot(snapshot);
});
