# Toolchain
CC      = riscv32-unknown-elf-gcc
OBJDUMP = riscv32-unknown-elf-objdump
READELF = riscv32-unknown-elf-readelf

# File
#SRC     = asm/test_GPIO.s
SRC     = src/test_GPIO.c
OUT     = bin/test_GPIO_from_C.elf
LINKER  = linker_script.ld

# Flags di compilazione e linking
CFLAGS  = -nostdlib -nostartfiles -ffreestanding
LDFLAGS = -T $(LINKER) -e main
# LDFLAGS = -e main

# Regole
all: $(OUT)

# $(OUT): $(SRC)
$(OUT): $(SRC) $(LINKER)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

dump: $(OUT)
	$(OBJDUMP) -d $(OUT)

sections: $(OUT)
	$(READELF) -S $(OUT)

clean:
	rm -f $(OUT)
