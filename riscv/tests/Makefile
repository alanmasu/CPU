# Test programs of the RISC-V core, built with the SDK in ../sdk.
#
# Each test is a folder with a source of the same name, test_X/test_X.c or
# test_X/test_X.S, and becomes build/<target>/test_X/test_X.elf.
#
#   make          build every test for the board, into build/board/
#   make SIM=1    build every test for the simulation (-DSIMULATION), into build/sim/
#   make dump     also write the disassembly next to each ELF (.dis)
#   make clean    delete build/
#
# A new test is a new folder plus its name in TESTS.

TESTS := test_Base test_BTPU test_GPIO test_I2C test_LoadStoreBTPU test_MatMul test_NewLib
TESTS += test_PWM test_PWMSweep test_SerialCode test_TimerCapture test_TimerContinuous test_TimerContinuousOled

ifeq ($(SIM),1)
BUILD_DIR := build/sim
else
BUILD_DIR := build/board
endif

SDK_BUILD_DIR := $(BUILD_DIR)/sdk
include ../sdk/sdk.mk

ifeq ($(SIM),1)
SDK_CFLAGS += -DSIMULATION
endif

ELFS := $(foreach test,$(TESTS),$(BUILD_DIR)/$(test)/$(test).elf)

all: $(ELFS)

dump: $(ELFS:.elf=.dis)

$(BUILD_DIR)/%.elf: $(BUILD_DIR)/%.o $(SDK_OBJS)
	$(CC) $(SDK_CFLAGS) $^ -o $@ $(SDK_LDFLAGS)

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(SDK_CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) $(SDK_CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.dis: $(BUILD_DIR)/%.elf
	$(OBJDUMP) -d $< > $@

clean:
	rm -rf build

.PHONY: all dump clean
