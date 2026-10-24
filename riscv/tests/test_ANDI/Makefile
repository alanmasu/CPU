# test_ANDI: builds bin/test_ANDI.elf from the assembly sources in src/, without
# libraries, with its own linker script.

# Toolchain
CC      = riscv32-unknown-elf-gcc
OBJDUMP = riscv32-unknown-elf-objdump
READELF = riscv32-unknown-elf-readelf

# Directory
SRC_DIR = src
OBJ_DIR = obj
OUT_DIR = bin

# File
OUT     = $(OUT_DIR)/test_ANDI.elf
LINKER  = linker_script.ld

# Compiler and linker flags
CFLAGS  = -nostdlib -nostartfiles -ffreestanding

# SIMULATION=1, exported by riscv/tests/Makefile, selects the simulation
# variant of the sources (#ifdef SIMULATION)
ifeq ($(SIMULATION),1)
CFLAGS += -DSIMULATION
endif
LDFLAGS = -T $(LINKER) -e main

# Every .S file in src/
SRCS    = $(wildcard $(SRC_DIR)/*.S)
OBJS    = $(patsubst $(SRC_DIR)/%.S, $(OBJ_DIR)/%.o, $(SRCS))

# Rules
all: $(OUT)

# Link the objects into the executable
$(OUT): $(OBJS) $(LINKER)
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

# Assemble each source file, after the C preprocessor
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

dump: all
	$(OBJDUMP) -d $(OUT)

sections: all
	$(READELF) -S $(OUT)

clean:
	rm -rf $(OBJ_DIR) $(OUT_DIR)

.PHONY: all clean dump sections
