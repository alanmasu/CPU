# Common part of the Makefile of a RISC-V program (the tests of riscv/tests and
# the examples of riscv/examples):
# toolchain, build folders, the files that describe the ELF, and the export
# for the loader of sw/vitis.
#
# A program's Makefile sets NAME, includes this file first, and then writes
# its own rules to build $(OUT), linking with $(MAP_FLAGS) and compiling with
# $(DEP_FLAGS):
#
#   NAME = test_ALU
#   include ../../sdk/program.mk
#   all: $(OUT)
#
# The Makefiles of riscv/tests/ and riscv/examples/ are complete examples.
#
# Build folders: the board build and the simulation build (SIMULATION=1) have
# their own objects and ELF, so switching between them needs no clean:
#
#   obj/<variant>/       objects (and the dependency files .d)
#   bin/<variant>/       <NAME>.elf and <NAME>.map, the map of the linker
#   listing/<variant>/   <NAME>.dump     objdump -d: address, instruction in
#                                        hex and in assembly on one line
#                        <NAME>.disas    objdump -D: every section, data too
#                        <NAME>.sections readelf -S
#                        <NAME>.symbols  nm -n -S: symbols by address, with size
#
# Export for the loader: make run from the folder of the program, for the
# board, also writes out/riscv/loader/program.h, the program LoaderApp of
# sw/vitis loads (every name starts with loader_program). The Makefiles that
# build every program of a folder (riscv/tests/Makefile,
# riscv/examples/Makefile) export RISCV_BUILD_ALL=1, so that they do not
# overwrite it.

PROGRAM_MK_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(PROGRAM_MK_DIR)../../

# The rules below would otherwise make the first of them the default goal
.DEFAULT_GOAL := all

CC      = riscv32-unknown-elf-gcc
OBJDUMP = riscv32-unknown-elf-objdump
READELF = riscv32-unknown-elf-readelf
NM      = riscv32-unknown-elf-nm

# Python with pyelftools: the environment that tools/activate creates.
# Without PYTHONHOME and PYTHONPATH: the Vitis GUI sets them to its own
# Python 3.8, and the Python of pyEnv would load that standard library
PYTHON := env -u PYTHONHOME -u PYTHONPATH $(ROOT_DIR)pyEnv/bin/python3

ifeq ($(SIMULATION),1)
VARIANT := sim
else
VARIANT := board
endif

OBJ_DIR     = obj/$(VARIANT)
OUT_DIR     = bin/$(VARIANT)
LISTING_DIR = listing/$(VARIANT)
OUT         = $(OUT_DIR)/$(NAME).elf

MAP_FLAGS = -Wl,-Map=$(OUT_DIR)/$(NAME).map
# A .d file next to each object lists the headers it includes, so that a
# changed header rebuilds the objects that use it
DEP_FLAGS = -MMD -MP

LISTINGS = $(addprefix $(LISTING_DIR)/$(NAME),.dump .disas .sections .symbols)
LOADER_HEADER = $(ROOT_DIR)out/riscv/loader/program.h

all: $(LISTINGS)

ifeq ($(VARIANT),board)
ifneq ($(RISCV_BUILD_ALL),1)
all: loader
endif
endif

$(LISTING_DIR)/$(NAME).dump: $(OUT)
	@mkdir -p $(LISTING_DIR)
	$(OBJDUMP) -d $< > $@

$(LISTING_DIR)/$(NAME).disas: $(OUT)
	@mkdir -p $(LISTING_DIR)
	$(OBJDUMP) -D $< > $@

$(LISTING_DIR)/$(NAME).sections: $(OUT)
	@mkdir -p $(LISTING_DIR)
	$(READELF) -S $< > $@

$(LISTING_DIR)/$(NAME).symbols: $(OUT)
	@mkdir -p $(LISTING_DIR)
	$(NM) -n -S $< > $@

# Phony: the header may hold another program, exported later from another
# folder; elfexport.py rewrites it only when the content changes
loader: $(OUT)
	@mkdir -p $(dir $(LOADER_HEADER))
	$(PYTHON) $(ROOT_DIR)tools/elfexport.py $(OUT) --format h --prefix loader_program -o $(LOADER_HEADER)

clean:
	rm -rf obj bin listing

.PHONY: all loader clean
