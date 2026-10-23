# Test programs of the RISC-V core.
#
# Each test is a folder with its own Makefile, which only builds that test
# into <test>/bin/<test>.elf. This Makefile builds every test twice, for the
# board and for the simulation, and exports each build in the format its
# users need, with the test name as the prefix of every exported symbol:
#
#   $(OUT_DIR)/vitis/<test>.h    board build, for the Vitis test suite
#   $(OUT_DIR)/sim/<test>.svh    simulation build, for the testbenches
#
#   make          board build and export, then simulation build and export;
#                 stops at the first error
#   make board    board build and .h export only
#   make sim      simulation build and .svh export only
#   make clean    clean every test and delete the exports
#
# A new test is a new folder plus its name in TESTS.

TESTS := test_Base test_BTPU test_BTPUvsSerial test_LoadStoreBTPU test_MatMul test_NewLib
TESTS += test_PWM test_PWMSweep test_SerialCode test_TimerCapture test_TimerContinuous test_TimerContinuousOled

OUT_DIR := ../../out/riscv/test

# Python with pyelftools: the environment that tools/activate creates
PYTHON := ../../pyEnv/bin/python3
TOOLS  := ../../tools

all:
	$(MAKE) board
	$(MAKE) sim

board: $(addprefix board-,$(TESTS))

sim: $(addprefix sim-,$(TESTS))

# Each build starts with "make clean": make cannot see that SIMULATION
# changed, and would keep the objects of the other build
board-%: export SIMULATION = 0
board-%:
	$(MAKE) -C $* clean all
	@mkdir -p $(OUT_DIR)/vitis
	$(PYTHON) $(TOOLS)/elfConverter.py $*/bin/$*.elf $(OUT_DIR)/vitis/$*.h $*
	$(PYTHON) $(TOOLS)/getSymbols.py $*/bin/$*.elf -a -o $(OUT_DIR)/vitis/$*.h

sim-%: export SIMULATION = 1
sim-%:
	$(MAKE) -C $* clean all
	@mkdir -p $(OUT_DIR)/sim
	$(PYTHON) $(TOOLS)/elfConverter.py $*/bin/$*.elf $(OUT_DIR)/sim/$*.svh $* --format sv
	$(PYTHON) $(TOOLS)/getSymbols.py $*/bin/$*.elf --format sv -a -o $(OUT_DIR)/sim/$*.svh

clean: $(addprefix clean-,$(TESTS))
	rm -rf $(OUT_DIR)

clean-%:
	$(MAKE) -C $* clean

.PHONY: all board sim clean
