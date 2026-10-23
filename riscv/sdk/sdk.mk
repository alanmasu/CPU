# SDK of the RISC-V core: toolchain, compiler and linker flags, and the rules
# that build the start-up code and the libraries.
#
# A program's Makefile includes this file and links its own objects with
# $(SDK_OBJS), using $(SDK_CFLAGS) and $(SDK_LDFLAGS):
#
#   include ../sdk/sdk.mk
#   prog.elf: prog.o $(SDK_OBJS)
#   	$(CC) $(SDK_CFLAGS) $^ -o $@ $(SDK_LDFLAGS)
#
# SDK_BUILD_DIR is where the objects of the SDK go; set it before the include
# to change it. Every path below starts from the folder of this file, so the
# SDK does not depend on where it is checked out.

SDK_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SDK_BUILD_DIR ?= build/sdk

CC      = riscv32-unknown-elf-gcc
OBJDUMP = riscv32-unknown-elf-objdump
READELF = riscv32-unknown-elf-readelf

# Libraries in the order they are linked
SDK_LIBS := BinaryMatMul GPIO I2C OLED Timer UART syscall utilities

SDK_CFLAGS := -I$(SDK_DIR)include $(foreach lib,$(SDK_LIBS),-I$(SDK_DIR)libraries/$(lib)/include)
SDK_CFLAGS += -ffreestanding -Os --specs=nano.specs -ffunction-sections -fdata-sections -Wl,--gc-sections
SDK_CFLAGS += -DMY_RISCV -Wstack-usage=8000

# -e main only silences the linker: the core always starts from _init in
# start.S, placed at 0x40000000 by the linker script
SDK_LDFLAGS := -T $(SDK_DIR)linker_script.ld -e main

SDK_SRCS := $(foreach lib,$(SDK_LIBS),$(wildcard $(SDK_DIR)libraries/$(lib)/src/*.c))
SDK_OBJS := $(patsubst $(SDK_DIR)%.c,$(SDK_BUILD_DIR)/%.o,$(SDK_SRCS)) $(SDK_BUILD_DIR)/start.o

$(SDK_BUILD_DIR)/%.o: $(SDK_DIR)%.c
	@mkdir -p $(dir $@)
	$(CC) $(SDK_CFLAGS) -c $< -o $@

# Only pattern rules in this file: an explicit target here would become the
# default goal of the Makefile that includes it
$(SDK_BUILD_DIR)/%.o: $(SDK_DIR)%.S
	@mkdir -p $(dir $@)
	$(CC) $(SDK_CFLAGS) -c $< -o $@
