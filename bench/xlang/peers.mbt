///|
/// A command to run: `program arguments...` in `cwd`.
priv struct Step {
  program : String
  arguments : Array[String]
  cwd : String
}

///|
/// One harness: an implementation of the benchmark cases in some language.
priv struct Peer {
  /// Names the harness in `--impl` and in the report's column headers.
  name : String
  /// Run in order before any timing; a failing step skips the peer.
  build : Array[Step]
  /// Prints result rows; the inputs directory and the group are appended.
  run : Step
}

///|
/// The same MoonBit harness, built for one backend.
fn moonbit_peer(root : String, target : String) -> Peer {
  let package_ = "bench/xlang/moonbit"
  {
    name: "moonbit-\{target}",
    build: [
      {
        program: "moon",
        arguments: ["build", "--target", target, "--release", package_],
        cwd: root,
      },
    ],
    run: {
      program: "moon",
      arguments: ["run", "--target", target, "--release", package_, "--"],
      cwd: root,
    },
  }
}

///|
/// Where ICU4C is installed, when it is not on the compiler's default paths.
/// Homebrew's `icu4c` is keg-only, so look there after `ICU_ROOT`.
async fn icu_prefix() -> String? {
  if @env.get_env_var("ICU_ROOT") is Some(prefix) {
    return Some(prefix)
  }
  for prefix in ["/opt/homebrew/opt/icu4c", "/usr/local/opt/icu4c"] {
    if @fs.exists("\{prefix}/include/unicode/unistr.h") {
      return Some(prefix)
    }
  }
  None
}

///|
/// Every harness, in report order. Build products go to `work`, outside the
/// source tree.
async fn all_peers(root : String, work : String) -> Array[Peer] {
  let source = "\{root}/bench/xlang"
  let icu_paths = if icu_prefix() is Some(prefix) {
    ["-I\{prefix}/include", "-L\{prefix}/lib", "-Wl,-rpath,\{prefix}/lib"]
  } else {
    []
  }
  [
    moonbit_peer(root, "native"),
    moonbit_peer(root, "wasm-gc"),
    moonbit_peer(root, "js"),
    {
      name: "icu4c",
      build: [
        {
          program: @env.get_env_var("CXX").unwrap_or("c++"),
          arguments: [
            "-O2",
            "-std=c++17",
            "main.cpp",
            ..icu_paths,
            "-licuuc",
            "-licui18n",
            "-o",
            "\{work}/icu4c",
          ],
          cwd: "\{source}/icu4c",
        },
      ],
      run: { program: "\{work}/icu4c", arguments: [], cwd: root, },
    },
    {
      name: "rust",
      build: [
        {
          program: "cargo",
          arguments: [
            "build",
            "--release",
            "--locked",
            "--target-dir",
            "\{work}/rust",
          ],
          cwd: "\{source}/rust",
        },
      ],
      run: { program: "\{work}/rust/release/xlang", arguments: [], cwd: root, },
    },
    {
      name: "go",
      build: [
        {
          program: "go",
          arguments: ["build", "-o", "\{work}/go", "."],
          cwd: "\{source}/go",
        },
      ],
      run: { program: "\{work}/go", arguments: [], cwd: root, },
    },
    {
      name: "node",
      build: [],
      run: {
        program: "node",
        // The bundled punycode module is deprecated but still what Node ships.
        arguments: ["--no-deprecation", "\{source}/node/main.cjs"],
        cwd: root,
      },
    },
    {
      name: "python",
      build: [],
      run: {
        program: "python3",
        arguments: ["\{source}/python/main.py"],
        cwd: root,
      },
    },
  ]
}
