#!/usr/bin/env python3
#
# check-paths.py - report the paths of the product that would not work on
# another machine
#
#   python3 hooks/check-paths.py      (make check_paths)
#
# Reads every file that git does not ignore, tracked or new: the files made
# by the tools (hw/vivado/, out/, work/) are ignored by git, so they are
# left out. Binary files and the content of submodules (repositories of
# their own) are left out too. It reports, without changing or refusing
# anything:
#   - absolute paths of this machine: the root of the product and the home;
#   - relative paths that point outside the product.
# A relative path is recognized by its form, so the check is a heuristic:
#   - after a variable that names a known directory: $origin_dir of the
#     snapshot (hw/), @PRODUCT_ROOT@ of the vitis-paths filter (the root),
#     ${workspace_loc} of classic Vitis (sw/vitis/), ${ProjDirPath} and
#     ${PROJECT_LOC} of Eclipse (the directory of the file), $PPRDIR of
#     the .xpr (hw/vivado/);
#   - between quotes and starting with ../, from the directory of the file;
#     in an HDL source also from the directory where xsim runs the
#     simulation sets of the project, hw/vivado/<project>.sim/<set>/behav/
#     xsim/, because a file that a testbench opens while it simulates is
#     found from there (a false alarm found by the porting in the CPU
#     project, 26/10/2026). Only the depth of that directory matters for
#     ../, so its names are placeholders.
# A path under a directory of .env (licensed IPs, sources of Linux and
# U-Boot, kernel build) is accepted: it is outside the product on purpose,
# and .env says where it is on this machine.
# The files with the vitis-paths filter (.gitattributes) hold the path of
# this machine in the working tree, because the filter puts it back at
# checkout, while git stores @PRODUCT_ROOT@: they are checked as git stores
# them, with the root replaced as the filter does at commit.
# It always exits with 0: it is a report, run when needed, not a check that
# blocks a commit. The time it takes is printed at the end.

import os
import re
import subprocess
import sys
import time

# Variables of .env that hold a directory outside the product.
ENV_DIRS = ["VIVADO_IP_REPO_EXT", "LINUX_SRC", "UBOOT_SRC", "DT_XLNX_SRC", "LINUX_BUILD_DIR"]

# Files larger than this are not read: no source of the product is so
# large, and a large file is a product of a tool committed on purpose.
MAX_SIZE = 4 * 1024 * 1024

# A path after a variable: the variable, then everything up to a character
# that cannot be part of a path in these files.
PREFIXED = re.compile(r"(\$\{origin_dir\}|\$origin_dir|@PRODUCT_ROOT@|\$\{workspace_loc(?::)?\}?|\$\{ProjDirPath\}|\$\{PROJECT_LOC\}|\$PPRDIR)(/?[^\s\"'<>;,)}\]]*)")

# The sources that a simulator reads, and the directory where xsim runs a
# simulation set of the project, four levels below hw/vivado/.
HDL_EXTS = (".v", ".sv", ".vh", ".svh", ".vhd", ".vhdl")
XSIM_DIR = os.path.join("hw", "vivado", "project.sim", "set", "behav", "xsim")

# A relative path between quotes that goes up at least one directory.
QUOTED = re.compile(r"[\"']((?:\.\./)+[^\"'\s]*)[\"']")


def git_files(root):
    # Tracked files and new files not ignored, each once, relative to root.
    files = set()
    for args in (["ls-files", "-z"], ["ls-files", "-z", "--others", "--exclude-standard"]):
        out = subprocess.run(["git", "-C", root] + args, check=True, capture_output=True).stdout
        for name in out.split(b"\0"):
            if name:
                files.add(name.decode("utf-8", "replace"))
    return sorted(files)


def filtered_files(root, files):
    # The files whose filter attribute is vitis-paths, with one call of git
    # for all of them. The output is "<file>\0filter\0<value>\0" for each.
    out = subprocess.run(["git", "-C", root, "check-attr", "-z", "--stdin", "filter"], input="\0".join(files).encode(), check=True, capture_output=True).stdout
    fields = out.split(b"\0")
    found = set()
    for i in range(0, len(fields) - 2, 3):
        if fields[i + 2] == b"vitis-paths":
            found.add(fields[i].decode("utf-8", "replace"))
    return found


def env_dirs(root):
    # The directories of .env, made absolute; relative values start from the
    # root, as in the Makefile.
    dirs = []
    path = os.path.join(root, ".env")
    if not os.path.exists(path):
        return dirs
    with open(path) as f:
        for line in f:
            line = line.strip()
            if line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            if key.strip() in ENV_DIRS and value.strip():
                dirs.append(os.path.normpath(os.path.join(root, value.strip())))
    return dirs


def base_of(variable, root, file_dir):
    # The directory a path after this variable starts from.
    if variable in ("$origin_dir", "${origin_dir}"):
        return os.path.join(root, "hw")
    if variable == "@PRODUCT_ROOT@":
        return root
    if variable.startswith("${workspace_loc"):
        return os.path.join(root, "sw", "vitis")
    if variable == "$PPRDIR":
        return os.path.join(root, "hw", "vivado")
    return file_dir


def inside(path, directory):
    return os.path.commonpath([path, directory]) == directory


def main():
    start = time.perf_counter()
    root = subprocess.run(["git", "rev-parse", "--show-toplevel"], check=True, capture_output=True, text=True).stdout.strip()
    allowed = env_dirs(root)
    home = os.path.expanduser("~")
    needles = [root.encode()]
    if home and home != "/":
        needles.append(home.encode())
    myself = os.path.relpath(os.path.abspath(__file__), root)

    files = git_files(root)
    filtered = filtered_files(root, files)
    findings = []
    read = 0
    read_bytes = 0
    for name in files:
        path = os.path.join(root, name)
        # Submodules are listed as a directory, not as a file.
        if name == myself or not os.path.isfile(path) or os.path.getsize(path) > MAX_SIZE:
            continue
        with open(path, "rb") as f:
            data = f.read()
        if b"\0" in data[:8192]:
            continue
        read += 1
        read_bytes += len(data)
        if name in filtered:
            data = data.replace(root.encode(), b"@PRODUCT_ROOT@")
        # Most files have none of the markers: skip them without decoding.
        if b"../" not in data and not any(needle in data for needle in needles) and b"$" not in data and b"@PRODUCT_ROOT@" not in data:
            continue
        text = data.decode("utf-8", "replace")
        file_dir = os.path.dirname(path)
        for number, line in enumerate(text.splitlines(), 1):
            for needle in needles:
                if needle.decode() in line:
                    findings.append((name, number, "absolute", needle.decode(), ""))
                    break
            # Each candidate is the path as written and the directories it
            # may start from: it is fine if it lands in the product, or under
            # a directory of .env, from any of them.
            candidates = []
            for match in PREFIXED.finditer(line):
                base = base_of(match.group(1), root, file_dir)
                candidates.append((match.group(0), match.group(2).lstrip("/"), [base]))
            for match in QUOTED.finditer(line):
                bases = [file_dir]
                if name.endswith(HDL_EXTS):
                    bases.append(os.path.join(root, XSIM_DIR))
                candidates.append((match.group(1), match.group(1), bases))
            for written, relative, bases in candidates:
                resolved = [os.path.normpath(os.path.join(base, relative)) for base in bases]
                if any(inside(r, root) or any(inside(r, d) for d in allowed) for r in resolved):
                    continue
                findings.append((name, number, "outside", written, resolved[0]))

    for name, number, kind, written, resolved in findings:
        if kind == "absolute":
            print(f"{name}:{number}: absolute path of this machine: {written}")
        else:
            print(f"{name}:{number}: points outside the product: {written} -> {resolved}")
    elapsed = time.perf_counter() - start
    print(f"check-paths: {len(findings)} finding(s) in {read} text file(s), {read_bytes / 1024:.0f} KiB read, {elapsed:.2f} s")
    if allowed:
        print("check-paths: accepted under the directories of .env: " + ", ".join(allowed))
    return 0


if __name__ == "__main__":
    sys.exit(main())
