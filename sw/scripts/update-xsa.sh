#!/usr/bin/env bash
#
# update-xsa.sh - deliver the hardware to the software part
#
#   update-xsa.sh [--force]
#
# Called by 'make update-xsa'. Copies out/hw/<project>.xsa, written by
# 'make xsa', into sw/hw/, which is committed: the Linux part and the Vitis
# workspace read the hardware only from there, so a checkout of an old
# commit brings back the hardware of that commit without building it again,
# and 'make xsa' can run as often as needed without touching the software.
#
# Next to it goes <project>.usr_access, the USR_ACCESS value of its
# bitstream (see hw/scripts/usr_access.tcl): the commit of the product it
# was built from, and whether hw/ had changes that were not committed.
# prj::check reads it to warn about a delivered .xsa older than hw/.
# An .xsa built from uncommitted changes matches no commit: it is refused,
# unless --force (FORCE=1).

set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

die() {
    echo "ERROR: $*" >&2
    exit 1
}

force=0
if [ "$#" -gt 1 ]; then
    die "usage: update-xsa.sh [--force]"
fi
if [ "$#" -eq 1 ]; then
    if [ "$1" != "--force" ]; then
        die "usage: update-xsa.sh [--force]"
    fi
    force=1
fi

shopt -s nullglob
xsas=(out/hw/*.xsa)
if [ "${#xsas[@]}" -ne 1 ]; then
    die "expected one .xsa in out/hw/, found ${#xsas[@]}: run 'make xsa' first"
fi
xsa=${xsas[0]}
name=$(basename "$xsa" .xsa)

# Written by prj::build next to the .xsa, from the run that made it.
value_file=out/hw/$name.usr_access
if [ ! -f "$value_file" ]; then
    if [ "$force" -eq 0 ]; then
        die "$value_file is missing, so the commit $xsa was built from is unknown: build it again with 'make xsa', or deliver it anyway with 'make update-xsa FORCE=1'"
    fi
    echo "WARNING: $value_file is missing: the delivered .xsa has no commit"
    value=
else
    value=$(cat "$value_file")
    commit=$(printf '%07x' $(( (value >> 4) & 0xFFFFFFF )))
    if [ $(( value & 1 )) -eq 1 ]; then
        if [ "$force" -eq 0 ]; then
            die "$xsa was built from commit $commit with changes in hw/ that were not committed, so it matches no commit: commit them and run 'make xsa' again, or deliver it anyway with 'make update-xsa FORCE=1'"
        fi
        echo "WARNING: delivering an .xsa built from commit $commit with changes in hw/ that were not committed"
    fi
fi

# One .xsa only in sw/hw/: an older one, for example of a renamed project,
# would make the software scripts refuse to choose.
mkdir -p sw/hw
rm -f sw/hw/*.xsa sw/hw/*.usr_access
cp "$xsa" sw/hw/
if [ -n "$value" ]; then
    echo "$value" > "sw/hw/$name.usr_access"
    echo "Delivered $xsa to sw/hw/, built from commit $commit: commit sw/hw/"
else
    echo "Delivered $xsa to sw/hw/: commit sw/hw/"
fi
