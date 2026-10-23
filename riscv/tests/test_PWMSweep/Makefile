# test_PWMSweep: builds bin/test_PWMSweep.elf with the SDK of ../../sdk.
# SIMULATION=1, exported by riscv/tests/Makefile, builds it for the simulation:
# run "make clean" before switching between the two builds.

# Directory
SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj
OUT_DIR = bin

# Toolchain, flags, linker script and SDK objects, built into obj/sdk
SDK_BUILD_DIR = $(OBJ_DIR)/sdk
include ../../sdk/sdk.mk

# File
OUT     = $(OUT_DIR)/test_PWMSweep.elf
SRCS    = $(wildcard $(SRC_DIR)/*.c)
OBJS    = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

# Rules
all: $(OUT)

# Link the test with the SDK objects
$(OUT): $(OBJS) $(SDK_OBJS)
	@mkdir -p $(OUT_DIR)
	$(CC) $(SDK_CFLAGS) -o $@ $^ $(SDK_LDFLAGS)

# Compile each C file of src/
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(SDK_CFLAGS) -I$(INC_DIR) -c -o $@ $<

dump: all
	$(OBJDUMP) -d $(OUT)

sections: all
	$(READELF) -S $(OUT)

clean:
	rm -rf $(OBJ_DIR) $(OUT_DIR)

.PHONY: all clean dump sections
