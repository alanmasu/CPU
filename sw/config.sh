# Settings of the software parts, sourced by sw/scripts/build.sh (Linux) and
# sw/scripts/vitis.sh (bare-metal): every version and option chosen for the
# product. Plain assignments only. Paths of the
# source checkouts are machine specific: they are in .env, not here.

# The tags must match each other and the Vivado version of the project,
# whose tools read the .xsa. These work together on the ZedBoard with Vivado
# 2021.2. Choose them before the first build of the Linux part: that build
# writes the Vivado version to sw/VIVADO_VERSION, and build.sh refuses to run
# when the project later moves to another version.
#
# For another Vivado version the tags follow the same names, xilinx-v<version>
# in linux-xlnx and u-boot-xlnx and xilinx_v<version> in device-tree-xlnx, but
# the combination has to be tried: with 2021.2, U-Boot 2019.1 is used because
# the 2021.2 one changes defconfig and boot command.
UBOOT_TAG=xilinx-v2019.1
LINUX_TAG=xilinx-v2021.2
# Only for Vivado up to 2024.1 (xsct backend): from 2024.2 the device tree
# comes from SDTGen, which ships with Vitis, and device-tree-xlnx is unused.
DT_XLNX_TAG=xilinx_v2021.1
# The board file of the device tree, one of
# device_tree/data/kernel_dtsi/<version>/BOARD/ in device-tree-xlnx (xsct
# backend) or in system-device-tree-xlnx (sdt backend, -board_dts of SDTGen).
# It sets the root compatible of the device tree, "xlnx,zynq-7000" among them:
# with SDTGen, without it the kernel does not recognise the Zynq and hangs
# after "Starting kernel ...". It also adds the devices of the board (Ethernet
# PHY, QSPI flash, USB). Leave it empty for a board without a file, and check
# then the root compatible of the generated tree, setting it in
# sw/dts/system-user.dtsi if needed.
DT_BOARD=zedboard

UBOOT_DEFCONFIG=zynq_zed_defconfig
KERNEL_DEFCONFIG=xilinx_zynq_defconfig
CROSS_COMPILE=arm-linux-gnueabihf-
PROCESSOR=ps7_cortexa9_0
LOADADDR=0x8000
JOBS=$(nproc)

# Prebuilt root filesystem, downloaded once into out/sw/ and copied to the SD
# card as uramdisk.image.gz.
ROOTFS_URL=http://ati.ttu.ee/~kjans/soc_design/files/uramdisk.image.gz

# Bare-metal part, Vitis Unified only: the application of sw/vitis/ that
# make vitis-build puts into out/vitis/BOOT.bin. Empty when the workspace has
# only one application.
VITIS_BOOT_APP=
