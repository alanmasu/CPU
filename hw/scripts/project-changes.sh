#!/usr/bin/env bash
#
# project-changes.sh - files of the Vivado project changed since the last export
#
#   project-changes.sh          list them; exit 1 if there are any
#   project-changes.sh --diff   also write their diff into
#                               work/project-changes.diff and open each one
#                               with 'code --diff' in VS Code, or print the
#                               commands when 'code' is not found; exit 0
#
# Compares the files of hw/vivado/ that hold the choices made in the GUI
# with hw/vivado/.baseline/, the copy that prj::create and prj::export write
# when the project matches its snapshot. No Vivado, so it is instant: the
# pre-commit hook runs it, and 'make diff' runs it with --diff.
# The files are chosen and copied as project_state_files,
# state_file_ignored and copy_project_state of sync.tcl do: keep them in
# step. A different file
# is not yet a change, because a build rewrites the .xpr by itself: only an
# export tells for sure (prj::check -with-export).

set -euo pipefail

# The files that are not choices of the user (state_file_ignored in
# sync.tcl): rewritten by Vivado by itself (the IPs inside a block design and
# the .bda, derived from the .bd, and the checkpoint of incremental
# synthesis), and the layout of the block designs in ui/, positions in the
# drawing and not hardware. Also applied when comparing, for a .baseline/
# written before a rule was added.
ignored() {
    case "$1" in
        */utils_1/imports/* | */bd/*/ip/* | *.bda | */bd/*/ui/*)
            return 0
            ;;
    esac
    return 1
}

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

project=hw/vivado
baseline=$project/.baseline
now=work/project-now

show_diff=0
if [ "$#" -eq 1 ] && [ "$1" = "--diff" ]; then
    show_diff=1
elif [ "$#" -ne 0 ]; then
    echo "usage: project-changes.sh [--diff]" >&2
    exit 2
fi

if [ ! -d "$project" ]; then
    echo "no project in $project"
    exit 0
fi
if [ ! -d "$baseline" ]; then
    echo "no $baseline to compare with (a project created by an older version of the template): run 'make export' once"
    if [ "$show_diff" -eq 1 ]; then
        exit 0
    fi
    exit 1
fi

# The current files, copied as the baseline is: the .xpr without its
# <Option Name="WTX..."> lines, usage counters of Vivado, and without the
# ignored files.
rm -rf "$now"
mkdir -p "$now"
shopt -s nullglob
for xpr in "$project"/*.xpr; do
    sed '/<Option Name="WTX/d' "$xpr" > "$now/$(basename "$xpr")"
done
for srcs in "$project"/*.srcs; do
    while IFS= read -r -d '' path; do
        relative=${path#"$project"/}
        if ignored "$relative"; then
            continue
        fi
        mkdir -p "$now/$(dirname "$relative")"
        cp "$path" "$now/$relative"
    done < <(find "$srcs" -type f -print0)
done

# Every file of either side, relative to it (%P), each once.
changed=()
while IFS= read -r relative; do
    if ignored "$relative"; then
        continue
    fi
    if [ ! -f "$baseline/$relative" ] || [ ! -f "$now/$relative" ] || ! cmp -s "$baseline/$relative" "$now/$relative"; then
        changed+=("$relative")
    fi
done < <(sort -u <(find "$baseline" -type f -printf '%P\n') <(find "$now" -type f -printf '%P\n'))

if [ "${#changed[@]}" -eq 0 ]; then
    echo "the project has the same files as at the last export"
    exit 0
fi

echo "the project changed after the last export, in:"
for relative in "${changed[@]}"; do
    echo "  $relative"
done

if [ "$show_diff" -eq 0 ]; then
    exit 1
fi

diff_file=work/project-changes.diff
: > "$diff_file"
for relative in "${changed[@]}"; do
    if ! diff -u -N "$baseline/$relative" "$now/$relative" >> "$diff_file"; then
        # diff exits with 1 when the files differ, the expected result here.
        :
    fi
done
echo "the whole diff: $diff_file"

# In the terminal of VS Code, also in a remote one (Remote-SSH), 'code'
# opens the diff in the window of VS Code. Elsewhere the commands are
# printed, to open them by hand.
if command -v code > /dev/null; then
    echo "opening the diffs in VS Code (the .xpr without its WTX usage counters):"
    for relative in "${changed[@]}"; do
        echo "  $relative"
        code --diff "$ROOT/$baseline/$relative" "$ROOT/$now/$relative"
    done
else
    echo "'code' not found: to open them in VS Code, with the paths of this machine (the .xpr without its WTX usage counters):"
    for relative in "${changed[@]}"; do
        echo "  code --diff $ROOT/$baseline/$relative $ROOT/$now/$relative"
    done
fi
