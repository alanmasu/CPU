#!/usr/bin/env bash
#
# gui-open.sh - exit with 0 when a Vivado GUI has this project open
#
# A GUI opened by 'make vivado' or 'make sim GUI=1' has the path of the .xpr
# on its command line, and pgrep -f finds it there. pgrep -f searches every
# command line, so the pattern is the full path of the .xpr file: the shell
# of a Makefile recipe that starts Vivado holds only hw/vivado/*.xpr, with
# the glob not yet expanded, and is not found. The same check for prj::sync
# is gui_has_project in sync.tcl. A GUI opened by hand with Open Project is
# not seen. No project, no GUI.

set -euo pipefail

shopt -s nullglob
xprs=("$(cd "$(dirname "$0")/.." && pwd)"/vivado/*.xpr)
if [ "${#xprs[@]}" -eq 0 ]; then
    exit 1
fi
pgrep -u "$USER" -f "${xprs[0]}" > /dev/null
