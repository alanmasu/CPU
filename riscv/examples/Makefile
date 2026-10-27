# Example programs of the RISC-V core.
#
# Each example is a folder with its own Makefile, which builds it into
# <example>/bin/board/<example>.elf (see ../sdk/program.mk): the examples in C
# with the SDK, the ones in assembly with their own linker script. The
# examples run on the board only, so this Makefile builds every example for
# the board and exports each build with tools/elfexport.py as a C header for
# the Vitis applications, with the example name as the prefix of every name:
#
#   $(OUT_DIR)/vitis/<example>.h
#
#   make          build and export every example; stops at the first error
#   make clean    clean every example and delete the exports
#
# To run one example with LoaderApp of sw/vitis, run make in its folder.
#
# A new example is a new folder plus its name in EXAMPLES.

# Examples in C
EXAMPLES := example_HelloWorld example_GPIO_Blink example_NewLibSupport example_I2C_PB200
# Examples in assembly
EXAMPLES += example_GPIO_BlinkAsm

OUT_DIR := ../../out/riscv/examples

# Python with pyelftools: the environment that tools/activate creates.
# Without PYTHONHOME and PYTHONPATH: the Vitis GUI sets them to its own
# Python 3.8, and the Python of pyEnv would load that standard library
PYTHON := env -u PYTHONHOME -u PYTHONPATH ../../pyEnv/bin/python3
TOOLS  := ../../tools

# Building the examples from here does not export them for the loader of
# sw/vitis: only make run from the folder of one program does
export RISCV_BUILD_ALL = 1

all: $(addprefix board-,$(EXAMPLES))

board-%: export SIMULATION = 0
board-%:
	$(MAKE) -C $* all
	@mkdir -p $(OUT_DIR)/vitis
	$(PYTHON) $(TOOLS)/elfexport.py $*/bin/board/$*.elf --format h -o $(OUT_DIR)/vitis/$*.h

clean: $(addprefix clean-,$(EXAMPLES))
	rm -rf $(OUT_DIR)

clean-%:
	$(MAKE) -C $* clean

.PHONY: all clean
