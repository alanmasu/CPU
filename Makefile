# Thin entry point: the Vivado targets are a single call each to a prj::
# command, whose logic lives in hw/scripts/. On Windows run it from MSYS2, which provides make and
# bash. Without make, run the same commands by hand.

# make splits words at spaces, so a product in a path with a space breaks the
# recipes, and the import_files that write_project_tcl writes for the module
# references of a block design have no quotes: refuse it at once.
ifneq ($(word 2,$(CURDIR)),)
$(error The path of the product has a space: "$(CURDIR)". Move the product to a path without spaces)
endif

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
# When hw/src/vivado_project.tcl changed under an existing project (a pull, a
# checkout, an edit; see hw/scripts/sync.tcl):
#   FORCE=1          export over a snapshot whose version is committed
#   DISCARD_LOCAL=1  lose what git does not have: the local changes of the
#                    project (kept in hw/vivado.bak/), or the changes of the
#                    snapshot that are not committed, when exporting
#   KEEP_LOCAL=1     go on with the local project, without the new snapshot
EXPORT_OPTION := $(if $(DISCARD_LOCAL),-discard-local,$(if $(FORCE),-force))
SYNC_OPTION := $(if $(DISCARD_LOCAL),-discard-local)
# WITH_EXPORT=1 for make check: also export the project into work/ and
# compare it with its snapshot, to find changes not exported.
CHECK_OPTION := $(if $(WITH_EXPORT),-with-export)

.PHONY: help hooks project sync vivado export ip release sim sim_all sim_ip regen_pkg synth bitstream xsa update-xsa check diff clean clean-force
.PHONY: linux-fsbl linux-dtb linux-uboot linux-boot linux-kernel linux-modules linux-sd linux-clean
.PHONY: vitis vitis-build

help:
	@echo "Vivado targets, each runs a prj:: command."
	@echo "In the GUI the same commands are available in the Tcl console: prj::help"
	@echo "  hooks        make git run the checks of hooks/ before every commit"
	@echo "  project      create hw/vivado/, installing the git hooks first"
	@echo "  sync         create hw/vivado/ again if hw/src/vivado_project.tcl changed:"
	@echo "               vivado, synth, bitstream and xsa run it first. With changes"
	@echo "               not exported it stops: KEEP_LOCAL=1 goes on with them,"
	@echo "               DISCARD_LOCAL=1 drops them, keeping them in hw/vivado.bak/"
	@echo "  vivado       open the project in the Vivado GUI, with the prj:: commands loaded"
	@echo "  export       save the project into hw/src/vivado_project.tcl, over a snapshot"
	@echo "               that changed FORCE=1, or DISCARD_LOCAL=1 if not committed"
	@echo "  ip           repackage the IPs of hw/ip/, upgrade and export the project"
	@echo "               IP=name for one IP, VERSION=M.m to change its version"
	@echo "  release      IP=name: package the committed RTL as a release and commit it,"
	@echo "               VERSION=M.m for a new version"
	@echo "  sim          simulate a simulation set of the project, SIMSET=name, default the"
	@echo "               active one, GUI=1 opens the GUI and simulates there, with the waves"
	@echo "  sim_all      simulate every simulation set of the project, with the log and the result"
	@echo "               of each one in out/sim_all/ or RESULTS=dir, summary.txt among them"
	@echo "  sim_ip       the IP testbenches with xsim, without the project, IP=name for one"
	@echo "  regen_pkg    compile the VHDL packages of a simulation set of the project, when a"
	@echo "               SystemVerilog testbench that imports one stops, SIMSET=name, default the active one"
	@echo "  synth        run synthesis"
	@echo "  bitstream    build out/hw/PROJECT.bit"
	@echo "  xsa          build out/hw/PROJECT.bit and out/hw/PROJECT.xsa"
	@echo "  update-xsa   deliver out/hw/PROJECT.xsa to the software: copy it into sw/hw/,"
	@echo "               which is committed, FORCE=1 also if built from uncommitted hw/"
	@echo "  check        checks to run before a commit; WITH_EXPORT=1 also exports the project"
	@echo "               into work/ to find changes not exported (takes the time of an export)"
	@echo "  diff         the files of the project changed after the last export, without Vivado:"
	@echo "               diff in work/project-changes.diff, each file opened in VS Code (code --diff)"
	@echo "  clean        delete everything generated, refuses if not exported"
	@echo "  clean-force  delete it anyway"
	@echo
	@echo "Linux targets, Linux hosts only, run sw/scripts/build.sh:"
	@echo "  linux-fsbl     FSBL of the Linux boot, from sw/hw/PROJECT.xsa"
	@echo "  linux-dtb      device tree from the .xsa and sw/dts/system-user.dtsi"
	@echo "  linux-uboot    U-Boot, in the checkout of UBOOT_SRC"
	@echo "  linux-boot     out/sd-card/BOOT.bin: FSBL, bitstream of sw/hw/PROJECT.xsa, U-Boot"
	@echo "  linux-kernel   kernel uImage, built in out/sw/linux or LINUX_BUILD_DIR"
	@echo "  linux-modules  the drivers in hw/ip/*/linux-driver/"
	@echo "  linux-sd       everything above, collected in out/sd-card/"
	@echo "  linux-clean    delete out/sw/ and out/sd-card/"
	@echo
	@echo "Vitis targets, bare-metal part in the workspace sw/vitis/:"
	@echo "  vitis        open the workspace in the Vitis IDE, after repairing"
	@echo "               what a clone or make xsa left out of date, without building"
	@echo "  vitis-build  repair and build everything, a BOOT.bin included, without the GUI"

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
	$(RUN) export $(EXPORT_OPTION)

ip:
	$(RUN) ip $(IP) $(VERSION)

release:
	@if [ "$(IP)" = all ]; then \
		echo "make release needs IP=name"; \
		exit 1; \
	fi
	$(RUN) release $(IP) $(VERSION)

# GUI=1: Vivado opens the project and runs prj::sim in the GUI (see
# hw/scripts/gui.tcl). A GUI already open on the project cannot be driven
# from here: then simulate from its Tcl console.
sim:
	@if [ -n "$(GUI)" ]; then \
		if bash hw/scripts/gui-open.sh; then \
			echo "The project is open in a Vivado GUI: run prj::sim $(SIMSET) in its Tcl console"; \
			exit 1; \
		fi; \
		cd $(WORK) && $(VIVADO_BIN) -source $(CURDIR)/hw/scripts/gui.tcl -journal vivado.jou -log vivado.log $(CURDIR)/hw/vivado/*.xpr -tclargs sim $(SIMSET); \
	else \
		$(RUN) sim $(SIMSET); \
	fi

# RESULTS is made absolute here: Vivado runs in work/, and a relative path
# would start from there.
sim_all:
	$(RUN) sim_all $(if $(RESULTS),$(abspath $(RESULTS)))

sim_ip:
	$(RUN) sim_ip $(IP)

# A SystemVerilog testbench that imports a VHDL package stops when the
# simulation library is empty: see hw/scripts/regen_pkg.tcl. With the GUI
# closed, because it opens the project.
regen_pkg:
	$(RUN) regen_pkg $(SIMSET)

synth:
	$(RUN) build synth

bitstream:
	$(RUN) build bitstream

xsa:
	$(RUN) build xsa

# The software (Linux part and Vitis workspace) reads the hardware only from
# sw/hw/, which is committed: see sw/scripts/update-xsa.sh.
update-xsa:
	bash sw/scripts/update-xsa.sh $(if $(FORCE),--force)

check:
	$(RUN) check $(CHECK_OPTION)

# No Vivado: the files of hw/vivado/ against hw/vivado/.baseline/, as the
# pre-commit hook compares them (see hw/scripts/project-changes.sh).
diff:
	bash hw/scripts/project-changes.sh --diff

# Bare-metal part, see sw/scripts/vitis.sh: the Vitis workspace is
# sw/vitis/, committed without what Vitis recreates (see .gitignore).
vitis:
	bash sw/scripts/vitis.sh gui

vitis-build:
	bash sw/scripts/vitis.sh build

# Every target that starts Vivado needs work/ (vitis.sh creates it itself).
project sync vivado export ip release sim sim_all sim_ip regen_pkg synth bitstream xsa check: | $(WORK)

# The targets that use the project first bring it in step with the snapshot
# (see hw/scripts/sync.tcl). The checks that need no Vivado are done here,
# so that Vivado starts only when there is something to do:
#  - no project (after a clone or 'make clean'): it is created, after
#    installing the hooks, as 'make project' does, so after a clone
#    'make xsa' is enough;
#  - the snapshot differs from hw/vivado/.snapshot, the copy of the one the
#    project matches (a pull, a checkout, an edit): prj::sync creates the
#    project again, or stops if it has changes that were not exported;
#    with KEEP_LOCAL=1 Vivado is not started, only the warning is printed.
# hw/vivado/.exported, written by prj::create, stands for the project.
vivado sim sim_all regen_pkg synth bitstream xsa: sync

sync:
	@if [ ! -f hw/vivado/.exported ]; then \
		bash hooks/install.sh; \
		$(RUN) create; \
	elif [ -f hw/src/vivado_project.tcl ] && ! cmp -s hw/src/vivado_project.tcl hw/vivado/.snapshot; then \
		if [ -n "$(KEEP_LOCAL)" ]; then \
			echo "WARNING: hw/src/vivado_project.tcl has changed, and KEEP_LOCAL=1 goes on with the local project, without it"; \
		else \
			$(RUN) sync $(SYNC_OPTION); \
		fi; \
	fi

# 'make export' only creates a missing project: over a changed snapshot it
# must refuse, not create the project again.
PROJECT_STAMP := hw/vivado/.exported
export: | $(PROJECT_STAMP)

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

# Rules of the product: local.mk, committed in the product and never
# changed by the template, adds prerequisites to the targets above, or
# targets of its own (see the README, "Rules of the product: local.mk").
# Included at the end, so that 'make' alone still runs help, the first
# target: a rule read before it would become the default goal.
-include local.mk
