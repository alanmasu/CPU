# Thin entry point: the Vivado targets are a single call each to a prj::
# command, whose logic lives in hw/scripts/. On Windows run it from MSYS2, which provides make and
# bash. Without make, run the same commands by hand.

# Local settings, never committed: see .env.example
-include .env
export VIVADO_IP_REPO_EXT

# Vivado and its tools write their scratch files (.Xil/, NA/, *.str, logs)
# into the directory they start in: they start in work/. Paths given to them
# are absolute, because the current directory changes.
WORK := work
VIVADO_BIN ?= vivado
VITIS_BIN ?= vitis
XSCT_BIN ?= xsct
export VITIS_BIN XSCT_BIN
VIVADO := cd $(WORK) && $(VIVADO_BIN) -mode batch -nojournal -nolog -notrace
RUN := $(VIVADO) -source $(CURDIR)/hw/scripts/run.tcl -tclargs
SW := bash sw/scripts/build.sh
GENERATED := hw/vivado out/hw out/sim out/ip_edit $(WORK) .Xil hw/.Xil
IP ?= all

.PHONY: help hooks project vivado export ip sim synth bitstream xsa check clean clean-force
.PHONY: linux-fsbl linux-dtb linux-uboot linux-boot linux-kernel linux-modules linux-sd linux-clean
.PHONY: vitis vitis-build

help:
	@echo Vivado targets, each runs a prj:: command.
	@echo In the GUI the same commands are available in the Tcl console: prj::help
	@echo   hooks        make git run the checks of hooks/ before every commit
	@echo   project      create hw/vivado/, installing the git hooks first
	@echo   vivado       open the project in the Vivado GUI, with the prj:: commands loaded
	@echo   export       save the project into hw/src/vivado_project.tcl
	@echo   ip           repackage the IPs of hw/ip/, upgrade and export the project
	@echo                IP=name for one IP, VERSION=M.m to change its version
	@echo   sim          run the IP testbenches, IP=name for one IP
	@echo   synth        run synthesis
	@echo   bitstream    build out/hw/PROJECT.bit
	@echo   xsa          build out/hw/PROJECT.bit and out/hw/PROJECT.xsa
	@echo   check        checks to run before a commit
	@echo   clean        delete everything generated, refuses if not exported
	@echo   clean-force  delete it anyway
	@echo
	@echo Linux targets, Linux hosts only, run sw/scripts/build.sh:
	@echo   linux-fsbl     FSBL of the Linux boot, from out/hw/PROJECT.xsa
	@echo   linux-dtb      device tree from the .xsa and sw/dts/system-user.dtsi
	@echo   linux-uboot    U-Boot, in the checkout of UBOOT_SRC
	@echo   linux-boot     out/sd-card/BOOT.bin: FSBL, bitstream, U-Boot
	@echo   linux-kernel   kernel uImage, built in out/sw/linux or LINUX_BUILD_DIR
	@echo   linux-modules  the drivers in hw/ip/*/linux-driver/
	@echo   linux-sd       everything above, collected in out/sd-card/
	@echo   linux-clean    delete out/sw/ and out/sd-card/
	@echo
	@echo Vitis targets, bare-metal part in the workspace sw/vitis/:
	@echo   vitis        open the workspace in the Vitis IDE, after repairing
	@echo                what a clone or 'make xsa' left out of date (no build)
	@echo   vitis-build  repair and build everything, a BOOT.bin included, without the GUI

# Make git run hooks/vivado_consistency.pre_commit before every commit: see
# hooks/install.sh.
hooks:
	bash hooks/install.sh

project: hooks
	$(RUN) create

# The .xpr is found by the shell when Vivado starts: make may not see a file
# created by the same run (the project, created by the rule below).
vivado:
	cd $(WORK) && $(VIVADO_BIN) -source $(CURDIR)/hw/scripts/prj.tcl -journal vivado.jou -log vivado.log $(CURDIR)/hw/vivado/*.xpr

export:
	$(RUN) export

ip:
	$(RUN) ip $(IP) $(VERSION)

sim:
	$(RUN) sim $(IP)

synth:
	$(RUN) build synth

bitstream:
	$(RUN) build bitstream

xsa:
	$(RUN) build xsa

check:
	$(RUN) check

# Bare-metal part, see sw/scripts/vitis.sh: the Vitis workspace is
# sw/vitis/, committed without what Vitis recreates (see .gitignore).
vitis:
	bash sw/scripts/vitis.sh gui

vitis-build:
	bash sw/scripts/vitis.sh build

# Every target that starts Vivado needs work/ (vitis.sh creates it itself).
project vivado export ip sim synth bitstream xsa check: | $(WORK)

# The targets that work on the project create it first when hw/vivado/ does
# not exist, as 'make project' does: after a clone, 'make xsa' is enough.
# hw/vivado/.exported, written at the end of prj::create, stands for the
# project. It is an order-only prerequisite (after |): only its existence
# matters, not its date, so make never recreates an existing project because
# some file is newer; 'make clean' and then any of these targets does that.
# The hooks are installed by calling install.sh, because a phony
# prerequisite would make the project out of date at every run.
PROJECT_STAMP := hw/vivado/.exported
vivado export synth bitstream xsa: | $(PROJECT_STAMP)

$(PROJECT_STAMP): | $(WORK)
	bash hooks/install.sh
	$(RUN) create

$(WORK):
	mkdir -p $(WORK)

# Refuse when a block design was saved after the last export or project
# creation (both touch hw/vivado/.exported): deleting vivado/ would lose it.
clean:
	@if [ -d hw/vivado ]; then \
		if [ -f hw/vivado/.exported ]; then \
			stale=$$(find hw/vivado -name '*.bd' -newer hw/vivado/.exported); \
		else \
			stale=$$(find hw/vivado -name '*.bd'); \
		fi; \
		if [ -n "$$stale" ]; then \
			echo "Block designs changed after the last export:"; \
			echo "$$stale"; \
			echo "Run 'make export' first, or 'make clean-force' to discard the changes"; \
			exit 1; \
		fi; \
	fi
	rm -rf $(GENERATED)

clean-force:
	rm -rf $(GENERATED)

# Linux part: each target runs one step of sw/scripts/build.sh, after the
# steps it needs. Kept apart from 'clean': the kernel build takes long.
linux-fsbl:
	$(SW) fsbl

linux-dtb:
	$(SW) dtb

linux-uboot:
	$(SW) uboot

linux-boot: linux-fsbl linux-uboot
	$(SW) boot

linux-kernel: linux-uboot
	$(SW) kernel

linux-modules: linux-kernel
	$(SW) modules

linux-sd: linux-boot linux-dtb linux-modules
	$(SW) sd

linux-clean:
	rm -rf out/sw out/sd-card
