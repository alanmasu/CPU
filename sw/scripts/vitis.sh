#!/usr/bin/env bash
#
# vitis.sh - the bare-metal part: the Vitis workspace sw/vitis/
#
#   vitis.sh gui     bring the workspace up to date if needed, without
#                    building, then open the Vitis GUI on it
#   vitis.sh build   bring the workspace up to date and build everything,
#                    without the GUI
#
# Called by 'make vitis' and 'make vitis-build'. Only part of the workspace is
# committed (see .gitignore): after a clone the projects are not imported,
# the platforms have no copy of the .xsa and the BSPs no sources; after
# 'make update-xsa' the copy of the .xsa in the platforms is old. The
# hardware comes only from sw/hw/, the .xsa delivered by 'make update-xsa'. The checks below
# take a fraction of a second and need no Vitis tool: xsct, which is slow to
# start, runs only when something has to be repaired, or for a build. The
# repairs and the build are in sw/scripts/vitis-xsct.tcl.
#
# Two IDEs, chosen by the Vivado version of the project (hw/VIVADO_VERSION):
#   classic  up to 2023.1: Eclipse based, workspace of projects; repairs and
#            build in vitis-xsct.tcl, with xsct (tested with 2021.2)
#   unified  from 2023.2, where it is the default: workspace of components;
#            repairs and build in vitis-unified.py, with the Vitis Python API
#            (tested with 2025.1). It has no system project: make vitis-build
#            writes out/vitis/BOOT.bin with bootgen.

set -euo pipefail
# A pattern that matches nothing expands to nothing, not to itself.
shopt -s nullglob

cd "$(dirname "$0")/../.."
ROOT=$PWD

WS=sw/vitis
LOG=work/vitis.log
VITIS_BIN=${VITIS_BIN:-vitis}
XSCT_BIN=${XSCT_BIN:-xsct}

die() {
    echo "vitis: ERROR: $*" >&2
    exit 1
}

# The IDE for the Vivado version of the project: classic up to 2023.1,
# unified from 2023.2.
ide() {
    local year
    local minor
    if [ ! -f hw/VIVADO_VERSION ]; then
        die "hw/VIVADO_VERSION does not exist: create the project first (make project)"
    fi
    IFS=. read -r year minor _ < hw/VIVADO_VERSION
    if [ "$year" -gt 2023 ] || { [ "$year" -eq 2023 ] && [ "$minor" -ge 2 ]; }; then
        echo unified
    else
        echo classic
    fi
}

# The GUI locks the workspace, and the tools would fail halfway through:
# while the GUI is open it keeps a lock file open, which fuser detects. The
# lock file of the IDE is the argument: .metadata/.lock for classic Vitis
# (Eclipse), _ide/.wsdata/.lock for Vitis Unified.
gui_is_open() {
    local lock=$1
    if [ ! -f "$lock" ]; then
        return 1
    fi
    if ! command -v fuser > /dev/null; then
        echo "vitis: WARNING: fuser not found (package psmisc): cannot check that the Vitis GUI is closed" >&2
        return 1
    fi
    fuser -s "$lock" 2> /dev/null
}

# The hardware of a platform can be changed in the Vitis GUI too (Update
# Hardware Specification, Switch XSA), which skips the repairs of the
# template: BSPs regenerated (xparameters.h) and, with Vitis Unified, the
# ps7_init of the FSBL copied. After each repair the scripts keep a copy of
# the .xsa they used in sw/vitis/.template-hw/<platform>.xsa (not
# committed): true when the platform was repaired with this .xsa, false
# when the copy is missing or different, for example after 'make
# update-xsa' followed by an update in the GUI.
hardware_repaired() {
    local dir=$1
    local xsa=$2
    cmp -s "$xsa" "$WS/.template-hw/$(basename "$dir").xsa"
}

# True when the workspace needs a repair by xsct: projects not imported, a
# platform whose copy of the .xsa is missing or differs from sw/hw/, or
# whose hardware was not repaired by the template (see hardware_repaired),
# a BSP without its sources. A workspace without platforms needs nothing.
needs_update() {
    local spr
    local dir
    local xsa
    local mss
    local found=0
    for spr in "$WS"/*/platform.spr; do
        found=1
        dir=$(dirname "$spr")
        for xsa in sw/hw/*.xsa; do
            if ! cmp -s "$xsa" "$dir/hw/$(basename "$xsa")"; then
                return 0
            fi
            if ! hardware_repaired "$dir" "$xsa"; then
                return 0
            fi
        done
        for mss in "$dir"/*/*/bsp/system.mss "$dir"/zynq_fsbl/zynq_fsbl_bsp/system.mss; do
            if [ -z "$(find "$(dirname "$mss")" -mindepth 2 -maxdepth 2 -type d -name libsrc)" ]; then
                return 0
            fi
        done
    done
    if [ "$found" -eq 0 ]; then
        return 1
    fi
    if [ ! -d "$WS/.metadata" ]; then
        return 0
    fi
    return 1
}

# vitis-xsct.tcl, with its long output in work/vitis.log: only its own
# progress lines, on stderr, reach the terminal.
run_xsct() {
    local mode=$1
    if ! (cd work && "$XSCT_BIN" "$ROOT/sw/scripts/vitis-xsct.tcl" "$mode" > "$ROOT/$LOG"); then
        die "full output of the Vitis tools in $LOG"
    fi
}

# Vitis Unified: true when the workspace needs a repair: no _ide/version.ini
# (a fresh clone), a platform whose copy of the .xsa is missing or differs
# from sw/hw/ or whose hardware was not repaired by the template (see
# hardware_repaired), a BSP without its sources. A workspace without platforms
# needs nothing. The platforms are
# the components whose vitis-comp.json has "type": "PLATFORM"; each BSP is a
# directory with a bsp.yaml.
unified_needs_update() {
    local comp
    local dir
    local xsa
    local yaml
    for comp in "$WS"/*/vitis-comp.json; do
        if ! grep -q '"type": "PLATFORM"' "$comp"; then
            continue
        fi
        if [ ! -f "$WS/_ide/version.ini" ]; then
            return 0
        fi
        dir=$(dirname "$comp")
        for xsa in sw/hw/*.xsa; do
            if ! cmp -s "$xsa" "$dir/hw/$(basename "$xsa")"; then
                return 0
            fi
            if ! hardware_repaired "$dir" "$xsa"; then
                return 0
            fi
        done
        for yaml in "$dir"/*/*/bsp/bsp.yaml "$dir"/zynq_fsbl/zynq_fsbl_bsp/bsp.yaml; do
            if [ ! -d "$(dirname "$yaml")/libsrc" ]; then
                return 0
            fi
        done
    done
    return 1
}

# vitis-unified.py with the Vitis Python API, output as for run_xsct. The
# application for BOOT.bin is VITIS_BOOT_APP of sw/config.sh.
run_unified() {
    local mode=$1
    local boot_app=""
    if [ -f sw/config.sh ]; then
        # shellcheck source=sw/config.sh
        source sw/config.sh
        boot_app=${VITIS_BOOT_APP:-}
    fi
    if ! (cd work && VITIS_ROOT=$ROOT VITIS_MODE=$mode VITIS_BOOT_APP=$boot_app "$VITIS_BIN" -s "$ROOT/sw/scripts/vitis-unified.py" > "$ROOT/$LOG"); then
        die "full output of the Vitis tools in $LOG"
    fi
}

mode=${1:-}
if [ "$mode" != gui ] && [ "$mode" != build ]; then
    die "usage: vitis.sh gui|build"
fi

mkdir -p "$WS" work
# The workspace directory is created above, so as not to depend on whether
# Vitis creates it. Vitis starts in work/, like Vivado, so its scratch files
# stay out of sw/.
if [ "$(ide)" = unified ]; then
    if gui_is_open "$WS/_ide/.wsdata/.lock"; then
        die "the workspace $WS/ is open in the Vitis GUI: close it, then run make again"
    fi
    if [ "$mode" = build ]; then
        run_unified build
        exit 0
    fi
    if unified_needs_update; then
        run_unified update
    else
        echo "vitis: workspace up to date"
    fi
    cd work
    exec "$VITIS_BIN" -w "$ROOT/$WS"
fi

if gui_is_open "$WS/.metadata/.lock"; then
    die "the workspace $WS/ is open in the Vitis GUI: close it, then run make again"
fi

if [ "$mode" = build ]; then
    run_xsct build
    exit 0
fi

if needs_update; then
    run_xsct update
else
    echo "vitis: workspace up to date"
fi
cd work
exec "$VITIS_BIN" -workspace "$ROOT/$WS"
