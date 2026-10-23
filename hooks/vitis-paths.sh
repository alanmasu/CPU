#!/usr/bin/env bash
#
# vitis-paths.sh - git filter for the project files of the Vitis workspace
# sw/vitis/: .yaml and .json of Vitis Unified, .spr, .prj and .sprj of
# classic Vitis
#
#   vitis-paths.sh clean   at git add: the absolute path of the product
#                          becomes @PRODUCT_ROOT@ in what git stores,
#                          "config: default" becomes "config: None" and
#                          "mode":"cmd" becomes "mode":"gui"
#   vitis-paths.sh smudge  at checkout: @PRODUCT_ROOT@ becomes the absolute
#                          path of the product in the files on disk
#
# Vitis writes absolute paths of the product into its project files: Vitis
# Unified into bsp.yaml, app.yaml and vitis-comp.json, again at every build;
# classic Vitis into platform.spr (platHandOff, the .xsa the platform was
# made from, used to copy it again when the platform has no copy, as in a
# clone), .prj and .sprj. Without the filter, a clone in another directory
# changes these files, the .xsa of classic Vitis is looked for in the
# directory where the platform was created, and the committed files hold the
# home of whoever committed them. With it, git stores the same text wherever
# the product is, and a checkout writes the paths of that clone.
#
# The same goes for the line "config: ..." of bsp.yaml: Regenerate BSP writes
# "config: default", every build of the platform (GUI or script) writes
# "config: None", both for the default configuration of the BSP; a clone,
# which regenerates the BSPs and then builds, would change the file at every
# build. git stores "config: None", the value after a build. Only the exact
# line "config: default" is changed, never the name of a real configuration.
# In the same way, platform.spr of classic Vitis records who wrote it last:
# "mode":"gui" from the GUI, "mode":"cmd" from xsct; git stores "gui".
#
# Declared for those files in .gitattributes, enabled in each clone by
# hooks/install.sh with git config (git config is not part of the
# repository). Git runs the filter in the root of the working tree, with the
# file on standard input and the result on standard output.

set -euo pipefail

root=$(git rev-parse --show-toplevel)

case "${1:-}" in
    clean)
        sed -e "s|$root|@PRODUCT_ROOT@|g" -e "s|^config: default$|config: None|" -e 's|"mode":"cmd"|"mode":"gui"|'
        ;;
    smudge)
        sed -e "s|@PRODUCT_ROOT@|$root|g"
        ;;
    *)
        echo "usage: vitis-paths.sh clean|smudge" >&2
        exit 1
        ;;
esac
