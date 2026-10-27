# example_HelloWorld: builds bin/<variant>/example_HelloWorld.elf with the SDK of ../../sdk.
# Build folders, listings and the export for the loader: ../../sdk/program.mk.

NAME = example_HelloWorld
include ../../sdk/program.mk

# Compiler and linker flags, linker script and SDK objects, built into
# obj/<variant>/sdk
SDK_BUILD_DIR = $(OBJ_DIR)/sdk
include ../../sdk/sdk.mk

SRCS    = $(wildcard src/*.c)
OBJS    = $(patsubst src/%.c,$(OBJ_DIR)/%.o,$(SRCS))

all: $(OUT)

# Link the program with the SDK objects
$(OUT): $(OBJS) $(SDK_OBJS)
	@mkdir -p $(OUT_DIR)
	$(CC) $(SDK_CFLAGS) -o $@ $^ $(SDK_LDFLAGS) $(MAP_FLAGS)

# Compile each C file of src/
$(OBJ_DIR)/%.o: src/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(SDK_CFLAGS) $(DEP_FLAGS) -Iinclude -c -o $@ $<

-include $(OBJS:.o=.d) $(SDK_OBJS:.o=.d)
