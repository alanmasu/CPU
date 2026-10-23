# Toolchain
CC      = riscv32-unknown-elf-gcc
OBJDUMP = riscv32-unknown-elf-objdump
READELF = riscv32-unknown-elf-readelf

# Directory
SRC_DIR = src
OBJ_DIR = obj
OUT_DIR = bin

# File
OUT     = $(OUT_DIR)/main.elf
LINKER  = linker_script.ld

# Flags di compilazione e linking
CFLAGS  = -nostdlib -nostartfiles -ffreestanding
LDFLAGS = -T $(LINKER) -e main

# Trova tutti i file .s nella directory src/
SRCS    = $(wildcard $(SRC_DIR)/*.s)
OBJS    = $(patsubst $(SRC_DIR)/%.s, $(OBJ_DIR)/%.o, $(SRCS))

# Regole
all: $(OUT)

# Compila l'eseguibile unendo tutti gli oggetti
$(OUT): $(OBJS) $(LINKER)
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)

# Compila ogni file Assembly in un oggetto
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

# Analisi del binario
dump: $(OUT)
	$(OBJDUMP) -d $(OUT)

sections: $(OUT)
	$(READELF) -S $(OUT)

clean:
	rm -rf $(OBJ_DIR) $(OUT_DIR)
