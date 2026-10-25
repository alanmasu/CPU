#!/usr/bin/env bash
#
# build.sh - Linux for the Zynq-7000, built by hand from the .xsa of hw/
#
#   build.sh fsbl       FSBL from the .xsa
#   build.sh dtb        device tree from the .xsa plus sw/dts/system-user.dtsi
#   build.sh uboot      U-Boot, also provides mkimage for the uImage
#   build.sh boot       BOOT.bin: FSBL, bitstream, U-Boot
#   build.sh kernel     kernel uImage
#   build.sh modules    drivers in hw/ip/*/linux-driver/
#   build.sh sd         collect everything into out/sd-card/
#
# Called by the Makefile, which runs the steps a target depends on first.
# Settings in sw/config.sh, paths of the source checkouts in .env.
# FSBL and device tree are made again only when the .xsa, their sources or
# this script are newer; after changing a tag in sw/config.sh, run
# 'make linux-clean'.
#
# FSBL and device tree come from one of two backends, chosen by the Vivado
# version of the project:
#   xsct  up to 2024.1: xsct with hsi and device-tree-xlnx
#   sdt   from 2024.2:  SDTGen and lopper for the device tree, the Vitis
#                       Python API for the FSBL (xsct is deprecated there)

set -euo pipefail

cd "$(dirname "$0")/../.."
ROOT=$PWD

# shellcheck source=sw/config.sh
source sw/config.sh
if [ -f .env ]; then
    # shellcheck source=/dev/null
    source .env
fi

# Kernel build directory (O= of the kernel): out/sw/linux, unless
# LINUX_BUILD_DIR is set in .env, for example to share one kernel build
# among products. A relative path starts from the root of the product.
LINUX_BUILD=${LINUX_BUILD_DIR:-out/sw/linux}
if [[ "$LINUX_BUILD" != /* ]]; then
    LINUX_BUILD=$ROOT/$LINUX_BUILD
fi

# =============================================================================
# HELPERS
# =============================================================================
header() {
    echo ""
    echo "############################################"
    echo " $*"
    echo "############################################"
    echo ""
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

# The only file matching a glob in a directory, for example the .xsa in
# sw/hw/. If there is none, the glob stays literal and the -f test fails.
find_one() {
    # $2 is a glob and must expand, so it is not quoted.
    # shellcheck disable=SC2206
    local files=("$1"/$2)
    if [ ! -f "${files[0]}" ]; then
        die "no $2 in $1/ - $3"
    fi
    echo "${files[0]}"
}

# True when the file target exists and is newer than every other argument:
# the step that makes it can be skipped.
is_up_to_date() {
    local target=$1
    local dep
    shift
    if [ ! -f "$target" ]; then
        return 1
    fi
    for dep in "$@"; do
        if [ "$dep" -nt "$target" ]; then
            return 1
        fi
    done
    return 0
}

# hsi extracts the content of the .xsa it opens (ps7_init, bitstream, .hwh)
# into the directory of the .xsa: give it a copy in out/sw/xsa/, so that
# sw/hw/ keeps only the delivered .xsa.
xsa_copy() {
    local xsa=$1
    mkdir -p out/sw/xsa
    cp "$xsa" out/sw/xsa/
    echo "$ROOT/out/sw/xsa/$(basename "$xsa")"
}

# The bitstream of BOOT.bin comes from the delivered .xsa, which holds it
# (an .xsa is a zip), not from out/hw/: the software uses only the hardware
# of sw/hw/, so that FSBL, device tree and bitstream always match.
xsa_bitstream() {
    local xsa=$1
    rm -rf out/sw/bit
    mkdir -p out/sw/bit
    unzip -q -j -o "$xsa" '*.bit' -d out/sw/bit
    find_one out/sw/bit '*.bit' "$xsa holds no bitstream: write it with 'make xsa'"
}

# A PS without any UART gives Linux no serial console: the typical sign of a
# board preset that was not applied to the processing system. Only a
# warning, the design may use another console on purpose.
check_uart() {
    local xsa=$1
    local hwh
    hwh=$(unzip -p "$xsa" '*.hwh')
    if ! grep -q -E 'NAME="PCW_UART[01]_PERIPHERAL_ENABLE" VALUE="1"' <<< "$hwh"; then
        echo "WARNING: no UART of the PS is enabled in $xsa: Linux will have no serial console."
        echo "         If the board part was set after creating the block design, apply its preset to the PS."
    fi
}

# The backend for the Vivado version of the project: xsct up to 2024.1, sdt
# from 2024.2.
backend() {
    local year
    local minor
    IFS=. read -r year minor _ < "$ROOT/hw/VIVADO_VERSION"
    if [ "$year" -gt 2024 ] || { [ "$year" -eq 2024 ] && [ "$minor" -ge 2 ]; }; then
        echo sdt
    else
        echo xsct
    fi
}

# The tools of the backend must be available, and the Vivado version of the
# project must be the one the tags of sw/config.sh were chosen for. The first
# build of the Linux part records it in sw/VIVADO_VERSION, as 'make project'
# does with hw/VIVADO_VERSION.
check_versions() {
    local version
    local sw_version
    local tool
    local tools
    if [ ! -f hw/VIVADO_VERSION ]; then
        die "hw/VIVADO_VERSION does not exist: create the project first (make project)"
    fi
    version=$(cat hw/VIVADO_VERSION)
    if [ "$(backend)" = sdt ]; then
        tools="sdtgen lopper vitis"
    else
        tools="xsct"
    fi
    for tool in $tools; do
        if ! command -v "$tool" > /dev/null; then
            die "$tool not found: source the settings of Vitis $version"
        fi
    done
    if [ ! -f sw/VIVADO_VERSION ]; then
        echo "$version" > sw/VIVADO_VERSION
        echo "Pinned the Linux part to Vivado $version in sw/VIVADO_VERSION: commit this file"
    fi
    sw_version=$(cat sw/VIVADO_VERSION)
    if [ "$sw_version" != "$version" ]; then
        die "the tags in sw/config.sh were chosen for Vivado $sw_version (sw/VIVADO_VERSION), the project now uses $version: choose the tags for $version, then delete sw/VIVADO_VERSION"
    fi
}

# A source checkout from .env: it must exist and be at the tag of
# sw/config.sh. Nothing is ever checked out automatically, that would
# silently throw away local changes.
check_source() {
    local name=$1
    local dir=$2
    local tag=$3
    local current
    if [ -z "$dir" ] || [ ! -d "$dir" ]; then
        die "$name: the path in .env is not set or is not a directory: '$dir'"
    fi
    if ! current=$(git -C "$dir" describe --tags --exact-match HEAD 2>/dev/null); then
        current="no tag"
    fi
    if [ "$current" != "$tag" ]; then
        die "$name: $dir is at '$current', expected $tag. Check it out by hand: git -C $dir checkout $tag"
    fi
}

# =============================================================================
# STEPS
# =============================================================================
step_fsbl() {
    local xsa
    local be
    header "FSBL"
    check_versions
    be=$(backend)
    xsa=$(find_one sw/hw '*.xsa' "deliver the hardware with 'make update-xsa', after 'make xsa'")
    if is_up_to_date out/sw/fsbl/fsbl.elf "$xsa" sw/scripts/fsbl-xsct.tcl sw/scripts/fsbl-vitis.py sw/scripts/build.sh; then
        echo "FSBL up to date"
        return
    fi
    check_uart "$xsa"
    rm -rf out/sw/fsbl
    mkdir -p out/sw/fsbl
    xsa=$(xsa_copy "$xsa")
    # The tools write their scratch files into the current directory: work/.
    mkdir -p work
    cd work
    if [ "$be" = sdt ]; then
        # The Vitis workspace must not exist yet: the platform is created anew.
        rm -rf "$ROOT/out/sw/vitis"
        XSA=$xsa OUT_DIR=$ROOT/out/sw/vitis PROCESSOR=$PROCESSOR vitis -s "$ROOT/sw/scripts/fsbl-vitis.py"
        cd "$ROOT"
        if [ ! -f out/sw/vitis/platform/export/platform/sw/boot/fsbl.elf ]; then
            die "the FSBL was not produced - check the vitis output above"
        fi
        cp out/sw/vitis/platform/export/platform/sw/boot/fsbl.elf out/sw/fsbl/fsbl.elf
    else
        XSA=$xsa OUT_DIR=$ROOT/out/sw/fsbl PROCESSOR=$PROCESSOR xsct "$ROOT/sw/scripts/fsbl-xsct.tcl"
        cd "$ROOT"
        if [ ! -f out/sw/fsbl/executable.elf ]; then
            die "the FSBL was not produced - check the xsct output above"
        fi
        mv out/sw/fsbl/executable.elf out/sw/fsbl/fsbl.elf
    fi
}

# Two stages: the backend writes the .dts sources from the .xsa, then cpp
# and dtc turn them into a .dtb. cpp is needed because the sources use
# #include and #define. sw/dts/system-user.dtsi is included last, so that it
# can change the generated nodes through their labels.
#   xsct  hsi and device-tree-xlnx write system-top.dts and its .dtsi files
#   sdt   sdtgen writes the system device tree of the whole chip in
#         out/sw/sdt/, lopper takes from it linux.dts, the tree seen by
#         Linux on PROCESSOR
step_dtb() {
    local xsa
    local top
    local be
    local board
    header "Device tree"
    check_versions
    be=$(backend)
    xsa=$(find_one sw/hw '*.xsa' "deliver the hardware with 'make update-xsa', after 'make xsa'")
    mkdir -p out/sd-card
    if is_up_to_date out/sw/dt/devicetree.dtb "$xsa" sw/dts/system-user.dtsi sw/scripts/devicetree-xsct.tcl sw/scripts/build.sh sw/config.sh; then
        echo "Device tree up to date"
        cp out/sw/dt/devicetree.dtb out/sd-card/
        return
    fi
    rm -rf out/sw/dt out/sw/sdt
    mkdir -p out/sw/dt
    xsa=$(xsa_copy "$xsa")
    mkdir -p work
    cd work
    if [ "$be" = sdt ]; then
        top=linux.dts
        # DT_BOARD of sw/config.sh: the board file gives the root compatible
        # that the kernel needs to recognise the Zynq.
        board=""
        if [ -n "${DT_BOARD:-}" ]; then
            board="-board_dts $DT_BOARD"
        fi
        sdtgen -eval "set_dt_param -xsa $xsa -dir $ROOT/out/sw/sdt $board; generate_sdt"
        lopper -f --enhanced -O "$ROOT/out/sw/dt" "$ROOT/out/sw/sdt/system-top.dts" "$top" -- gen_domain_dts "$PROCESSOR" linux_dt
    else
        top=system-top.dts
        check_source device-tree-xlnx "${DT_XLNX_SRC:-}" "$DT_XLNX_TAG"
        XSA=$xsa OUT_DIR=$ROOT/out/sw/dt DT_REPO=$DT_XLNX_SRC PROCESSOR=$PROCESSOR DT_BOARD=${DT_BOARD:-} xsct "$ROOT/sw/scripts/devicetree-xsct.tcl"
    fi
    cd "$ROOT"
    if [ ! -f "out/sw/dt/$top" ]; then
        die "$top was not produced - check the output above"
    fi
    cp sw/dts/system-user.dtsi out/sw/dt/
    echo '#include "system-user.dtsi"' >> "out/sw/dt/$top"
    cd out/sw/dt
    cpp -nostdinc -undef -D__DTS__ -x assembler-with-cpp -I. -o devicetree.dts "$top"
    dtc -I dts -O dtb -o devicetree.dtb devicetree.dts
    cd "$ROOT"
    cp out/sw/dt/devicetree.dtb out/sd-card/
}

# Built inside the checkout, as in the lab workspace: U-Boot refuses an O=
# build when its source tree already holds an in-tree one.
# HOSTCFLAGS=-fcommon makes the 2019.1 tag build with gcc 10 and newer.
step_uboot() {
    header "U-Boot ($UBOOT_TAG)"
    check_source u-boot-xlnx "${UBOOT_SRC:-}" "$UBOOT_TAG"
    if [ ! -f "$UBOOT_SRC/.config" ]; then
        make -C "$UBOOT_SRC" CROSS_COMPILE=$CROSS_COMPILE $UBOOT_DEFCONFIG
    fi
    make -C "$UBOOT_SRC" -j"$JOBS" CROSS_COMPILE=$CROSS_COMPILE HOSTCFLAGS=-fcommon
}

# The .bif lists the files of BOOT.bin, in boot order.
step_boot() {
    local bit
    header "BOOT.bin"
    bit=$(xsa_bitstream "$(find_one sw/hw '*.xsa' "deliver the hardware with 'make update-xsa', after 'make xsa'")")
    if [ ! -f out/sw/fsbl/fsbl.elf ]; then
        die "no FSBL: run 'make linux-fsbl' first"
    fi
    if [ ! -f "$UBOOT_SRC/u-boot.elf" ]; then
        die "no u-boot.elf: run 'make linux-uboot' first"
    fi
    mkdir -p out/sd-card
    cat > out/sw/system.bif <<EOF
the_ROM_image:
{
    [bootloader]$ROOT/out/sw/fsbl/fsbl.elf
    $ROOT/$bit
    $UBOOT_SRC/u-boot.elf
}
EOF
    bootgen -image out/sw/system.bif -arch zynq -o out/sd-card/BOOT.bin -w on
}

# Built with O=, so the checkout stays clean. mkimage comes from U-Boot:
# without it the build stops after the zImage. sw/kernel/config.fragment, if
# it sets any option, is merged into the configuration at every build.
# The modules target is built too: external modules need what it leaves in
# the build directory, scripts/module.lds and Module.symvers.
step_kernel() {
    local build=$LINUX_BUILD
    header "Linux kernel ($LINUX_TAG)"
    check_source linux-xlnx "${LINUX_SRC:-}" "$LINUX_TAG"
    check_source u-boot-xlnx "${UBOOT_SRC:-}" "$UBOOT_TAG"
    export PATH=$UBOOT_SRC/tools:$PATH
    mkdir -p "$build"
    if [ ! -f "$build/.config" ]; then
        make -C "$LINUX_SRC" ARCH=arm CROSS_COMPILE=$CROSS_COMPILE O="$build" $KERNEL_DEFCONFIG
    fi
    if grep -q '^CONFIG_' sw/kernel/config.fragment; then
        "$LINUX_SRC/scripts/kconfig/merge_config.sh" -m -O "$build" "$build/.config" sw/kernel/config.fragment
        make -C "$LINUX_SRC" ARCH=arm CROSS_COMPILE=$CROSS_COMPILE O="$build" olddefconfig
    fi
    make -C "$LINUX_SRC" ARCH=arm CROSS_COMPILE=$CROSS_COMPILE O="$build" -j"$JOBS" UIMAGE_LOADADDR=$LOADADDR uImage modules
}

# Every hw/ip/<ip>/linux-driver/ with a Makefile, built against the kernel of
# LINUX_BUILD.
step_modules() {
    local dir
    header "Kernel modules"
    if [ ! -f "$LINUX_BUILD/Module.symvers" ]; then
        die "no kernel build with its modules: run 'make linux-kernel' first"
    fi
    for dir in hw/ip/*/linux-driver; do
        if [ -f "$dir/Makefile" ]; then
            make -C "$dir" KDIR="$LINUX_BUILD" ARCH=arm CROSS_COMPILE=$CROSS_COMPILE
        fi
    done
}

# The root filesystem is downloaded once from ROOTFS_URL and kept in out/sw/.
# wget -O creates the file before the first byte arrives: the download goes
# into a .part file, renamed only when complete, so that an interrupted one
# is not taken as downloaded at the next run.
step_sd() {
    local ko
    local rootfs
    header "SD card"
    rootfs=out/sw/rootfs/$(basename "$ROOTFS_URL")
    if [ ! -s "$rootfs" ]; then
        mkdir -p out/sw/rootfs
        if ! wget --timeout=30 --tries=2 -O "$rootfs.part" "$ROOTFS_URL"; then
            rm -f "$rootfs.part"
            die "cannot download the root filesystem from $ROOTFS_URL: copy the image by hand to $rootfs, then run again"
        fi
        if [ ! -s "$rootfs.part" ]; then
            rm -f "$rootfs.part"
            die "the root filesystem downloaded from $ROOTFS_URL is empty: copy the image by hand to $rootfs, then run again"
        fi
        mv "$rootfs.part" "$rootfs"
    fi
    mkdir -p out/sd-card
    cp "$LINUX_BUILD/arch/arm/boot/uImage" out/sd-card/
    cp "$rootfs" out/sd-card/uramdisk.image.gz
    for ko in hw/ip/*/linux-driver/*.ko; do
        if [ -f "$ko" ]; then
            cp "$ko" out/sd-card/
        fi
    done
    echo "SD card contents in out/sd-card/:"
    ls out/sd-card
}

# =============================================================================
# MAIN
# =============================================================================
case "${1:-}" in
    fsbl)
        step_fsbl
        ;;
    dtb)
        step_dtb
        ;;
    uboot)
        step_uboot
        ;;
    boot)
        step_boot
        ;;
    kernel)
        step_kernel
        ;;
    modules)
        step_modules
        ;;
    sd)
        step_sd
        ;;
    *)
        die "usage: build.sh fsbl|dtb|uboot|boot|kernel|modules|sd"
        ;;
esac
