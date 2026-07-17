///|
async fn find_project_root() -> String {
  if @fs.exists("moon.work") && @fs.exists("tools/moon.mod") {
    "."
  } else if @fs.exists("../moon.work") && @fs.exists("moon.mod") {
    ".."
  } else {
    raise ReleaseError(
      "Run the release tool from the repository root or tools directory",
    )
  }
}

///|
async fn[X] wait_with_heartbeat(
  description : StringView,
  action : async () -> X,
) -> X {
  @async.with_task_group(group => {
    group.spawn_bg(no_wait=true, () => {
      for ;; {
        @async.sleep(10000)
        println("    Still waiting for \{description}...")
      }
    })
    action()
  })
}

///|
async fn run_checked(
  root : StringView,
  program : StringView,
  arguments : ArrayView[String],
  description : StringView,
) -> Unit {
  println("==> \{description}")
  let status = @process.run(program, arguments, cwd=root)
  guard status == 0 else {
    raise ReleaseError("\{description} failed with exit status \{status}")
  }
  println("    Completed successfully")
}

///|
async fn run_publish_dry_run(
  root : StringView,
  release_module : ReleaseModule,
  version : String,
) -> Unit {
  let package_name = "tonyfettes/\{release_module.name}"
  let description = "Dry-running \{package_name}@\{version}"
  println("==> \{description}")
  // `moon publish` validates the archive in a fresh directory, so it must be
  // allowed to install registry dependencies there.
  println("    $ moon -C \{release_module.directory} publish --dry-run")
  let (status, output) = wait_with_heartbeat(description, () => {
    @process.collect_output_merged(
      "moon",
      ["-C", release_module.directory, "publish", "--dry-run"],
      cwd=root,
    )
  })
  let output_text = output.text()
  println(output_text.trim_end())
  guard publish_dry_run_succeeded(status, output_text, package_name, version) else {
    raise ReleaseError("\{description} failed with exit status \{status}")
  }
  println("    Dry-run accepted with exit status \{status}")
}

///|
async fn ensure_clean_worktree(root : StringView) -> Unit {
  println("==> Checking that the Git worktree is clean")
  let (status, output) = @process.collect_stdout(
    "git",
    ["status", "--porcelain=v1"],
    cwd=root,
  )
  guard status == 0 else {
    raise ReleaseError("git status failed with exit status \{status}")
  }
  let changes = output.text().trim()
  guard changes == "" else {
    raise ReleaseError(
      "The Git worktree must be clean before this operation:\n\{changes}",
    )
  }
  println("    Git worktree is clean")
}

///|
async fn update_published_versions(root : StringView, version : String) -> Unit {
  let updates : Array[(String, String)] = []
  let mut previous_version : String? = None
  for release_module in published_modules {
    let path = release_module.manifest_path()
    let source = @fs.read_file("\{root}/\{path}").text()
    let current_version = manifest_version(source, path)
    if previous_version is Some(expected) {
      guard current_version == expected else {
        raise ReleaseError(
          "Published module versions are inconsistent: \{path} has \{current_version}, expected \{expected}",
        )
      }
    } else {
      previous_version = Some(current_version)
    }
    updates.push((path, replace_manifest_version(source, path, version)))
  }
  guard previous_version is Some(current_version) else {
    raise ReleaseError("No published modules are configured")
  }
  guard current_version != version else {
    raise ReleaseError("Published modules are already at version \{version}")
  }
  for update in updates {
    @fs.write_file(
      "\{root}/\{update.0}",
      update.1,
      create_mode=CreateOrTruncate,
      permission=0o644,
    )
  }
}

///|
async fn verify_published_versions(
  root : StringView,
  expected_version : String,
) -> Unit {
  println("==> Verifying published module versions")
  for release_module in published_modules {
    let path = release_module.manifest_path()
    let source = @fs.read_file("\{root}/\{path}").text()
    let actual_version = manifest_version(source, path)
    guard actual_version == expected_version else {
      raise ReleaseError(
        "\{path} has version \{actual_version}, expected \{expected_version}",
      )
    }
    println("    \{path}: \{actual_version}")
  }
}

///|
async fn ensure_release_tag(root : StringView, version : String) -> Unit {
  let tag = "v\{version}"
  println("==> Verifying that local tag \{tag} points at HEAD")
  let (local_status, local_output) = @process.collect_stdout(
    "git",
    ["tag", "--points-at", "HEAD", "--list", tag],
    cwd=root,
  )
  guard local_status == 0 else {
    raise ReleaseError("git tag failed with exit status \{local_status}")
  }
  guard local_output.text().trim() == tag else {
    raise ReleaseError(
      "HEAD must have the release tag \{tag} before publishing",
    )
  }
  println("    Local tag \{tag} points at HEAD")
  let (object_status, object_output) = @process.collect_stdout(
    "git",
    ["rev-parse", "--verify", "refs/tags/\{tag}"],
    cwd=root,
  )
  guard object_status == 0 else {
    raise ReleaseError(
      "Resolving release tag \{tag} failed with exit status \{object_status}",
    )
  }
  let local_object = object_output.text().trim()
  let description = "origin release tag \{tag}"
  println("==> Verifying \{description}")
  println(
    "    $ git ls-remote --exit-code --refs --tags origin refs/tags/\{tag}",
  )
  let (remote_status, remote_output) = wait_with_heartbeat(description, () => {
    @async.with_timeout(
      60000,
      error=ReleaseError(
        "Timed out after 60 seconds while checking origin tag \{tag}; run the printed git ls-remote command manually to diagnose credentials or network access",
      ),
      () => {
        @process.collect_stdout(
          "git",
          [
            "ls-remote",
            "--exit-code",
            "--refs",
            "--tags",
            "origin",
            "refs/tags/\{tag}",
          ],
          cwd=root,
        )
      },
    )
  })
  guard remote_status == 0 else {
    raise ReleaseError(
      "Release tag \{tag} must be pushed to origin before publishing (git ls-remote exited with status \{remote_status})",
    )
  }
  guard remote_tag_matches(remote_output.text(), tag, local_object) else {
    raise ReleaseError(
      "Release tag \{tag} on origin does not match the local tag at HEAD",
    )
  }
  println("    Origin tag matches local tag object \{local_object}")
}

///|
async fn prepare_release(root : StringView, version : String) -> Unit {
  validate_release_version(version)
  ensure_clean_worktree(root)
  update_published_versions(root, version)
  run_checked(
    root,
    "moon",
    ["work", "sync"],
    "Synchronizing workspace versions",
  )
  run_checked(root, "moon", ["fmt"], "Formatting the workspace")
  run_checked(root, "moon", ["info"], "Refreshing generated interfaces")
  run_checked(
    root,
    "moon",
    ["check", "tools/release", "--target", "native"],
    "Checking the native release tool",
  )
  run_checked(
    root,
    "moon",
    ["test", "tools/release", "--target", "native"],
    "Testing the native release tool",
  )
  run_checked(root, "moon", ["check"], "Checking the workspace")
  run_checked(root, "moon", ["test"], "Testing the workspace")
  for release_module in published_modules {
    run_checked(
      root,
      "moon",
      ["-C", release_module.directory, "package", "--list", "--frozen"],
      "Listing tonyfettes/\{release_module.name}@\{version}",
    )
    if release_module.requires_published_dependencies {
      println(
        "==> Deferring the tonyfettes/\{release_module.name}@\{version} dry-run until its same-release dependencies are published",
      )
    } else {
      run_publish_dry_run(root, release_module, version)
    }
  }
  println(
    "Release \{version} is prepared. Review and commit the manifest changes,",
  )
  println("create and push tag v\{version}, then run:")
  println(
    "moon run --target native tools/release -- publish --version \{version} --execute",
  )
}

///|
async fn publish_release(
  root : StringView,
  version : String,
  first_module : String,
) -> Unit {
  validate_release_version(version)
  let start_index = publish_start_index(first_module)
  println("Publishing release v\{version} from module \{first_module}")
  println(
    "No registry changes will be made until every preflight check passes.",
  )
  ensure_clean_worktree(root)
  verify_published_versions(root, version)
  ensure_release_tag(root, version)
  run_checked(root, "moon", ["whoami"], "Checking mooncakes.io login")
  println("==> All preflight checks passed; starting module publication")
  for index, release_module in published_modules {
    if index >= start_index {
      println(
        "==> [\{index + 1}/\{published_modules.length()}] Releasing tonyfettes/\{release_module.name}@\{version}",
      )
      if release_module.requires_published_dependencies {
        run_checked(
          root,
          "moon",
          ["-C", release_module.directory, "update"],
          "Refreshing the registry for tonyfettes/\{release_module.name}@\{version}",
        )
      }
      run_publish_dry_run(root, release_module, version)
      println("==> Publishing tonyfettes/\{release_module.name}@\{version}")
      println("    $ moon -C \{release_module.directory} publish")
      let status = @process.run(
        "moon",
        ["-C", release_module.directory, "publish"],
        cwd=root,
      )
      guard status == 0 else {
        raise ReleaseError(
          "Publishing tonyfettes/\{release_module.name}@\{version} failed with exit status \{status}. After resolving the problem, resume with --from \{release_module.name}",
        )
      }
      println("    Published tonyfettes/\{release_module.name}@\{version}")
    }
  }
  println("Published all modules for v\{version}")
}

///|
async fn run_cli() -> Unit {
  let command = @argparse.Command(
    "unicode-release",
    about="Prepare and publish the Unicode workspace modules",
    subcommand_required=true,
    subcommands=[
      Command(
        "prepare",
        about="Bump versions, validate the workspace, and dry-run independent modules",
        options=[
          OptionArg(
            "version",
            long="version",
            about="Release version in MAJOR.MINOR.PATCH form",
            required=true,
          ),
        ],
      ),
      Command(
        "publish",
        about="Publish all modules in dependency order",
        flags=[
          FlagArg(
            "execute",
            long="execute",
            about="Confirm the irreversible publication step",
            required=true,
          ),
        ],
        options=[
          OptionArg(
            "version",
            long="version",
            about="Release version in MAJOR.MINOR.PATCH form",
            required=true,
          ),
          OptionArg(
            "from",
            long="from",
            about="Resume publication from this module",
            default_values=["ucd"],
          ),
        ],
      ),
    ],
  )
  let matches = command.parse()
  let root = find_project_root()
  match matches.subcommand {
    Some(("prepare", child)) => {
      guard child.values.get("version") is Some([version]) else {
        raise ReleaseError("Missing required --version option")
      }
      prepare_release(root, version)
    }
    Some(("publish", child)) => {
      guard child.values.get("version") is Some([version]) else {
        raise ReleaseError("Missing required --version option")
      }
      guard child.values.get("from") is Some([first_module]) else {
        raise ReleaseError("Invalid --from option")
      }
      guard child.flags.get("execute").unwrap_or(false) else {
        raise ReleaseError("Publication requires the explicit --execute flag")
      }
      publish_release(root, version, first_module)
    }
    Some((name, _)) => raise ReleaseError("Unknown release command \{name}")
    None => raise ReleaseError("A release command is required")
  }
}

///|
async fn main {
  run_cli() catch {
    ReleaseError(message) => fail(message)
    error => raise error
  }
}
