# example_GPIO_BlinkAsm: builds bin/<variant>/example_GPIO_BlinkAsm.elf from the assembly sources in src/,
# without libraries, with its own linker script. Build folders, listings and
# the export for the loader: ../../sdk/program.mk.

NAME = example_GPIO_BlinkAsm
include ../../sdk/program.mk

LINKER  = linker_script.ld

CFLAGS  = -nostdlib -nostartfiles -ffreestanding $(DEP_FLAGS)
ifeq ($(SIMULATION),1)
CFLAGS += -DSIMULATION
endif
LDFLAGS = -T $(LINKER) -e main $(MAP_FLAGS)

# Every .S file in src/
SRCS    = $(wildcard src/*.S)
OBJS    = $(patsubst src/%.S,$(OBJ_DIR)/%.o,$(SRCS))

all: $(OUT)

# Link the objects into the executable
$(OUT): $(OBJS) $(LINKER)
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

# Assemble each source file, after the C preprocessor
$(OBJ_DIR)/%.o: src/%.S
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

-include $(OBJS:.o=.d)
