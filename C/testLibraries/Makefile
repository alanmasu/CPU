# Toolchain
CC      = riscv32-unknown-elf-gcc
OBJDUMP = riscv32-unknown-elf-objdump
READELF = riscv32-unknown-elf-readelf

# Linker script
LINKER  = linker_script.ld

# Nome del file ELF da generare
TARGET = bin/main.elf

# Compilatore e flag
# CFLAGS = -Iinclude $(addprefix -I, $(wildcard libraries/*/include)) -ffreestanding -nostdlib -Os 
CFLAGS = -Iinclude $(addprefix -I, $(wildcard libraries/*/include)) -ffreestanding -Os -ffunction-sections -Wl,--gc-sections
LDFLAGS = -T $(LINKER) -e main 
# LDFLAGS = -e main

# Directory principali
SRC_DIR = src
OBJ_DIR = obj
LIBS_DIR = libraries

# Trova tutte le directory src delle librerie
LIBS_SRC_DIRS = $(wildcard $(LIBS_DIR)/*/src)

# Trova tutti i file sorgente (principali e librerie)
SRC_FILES = $(wildcard $(SRC_DIR)/*.c) $(foreach dir, $(LIBS_SRC_DIRS), $(wildcard $(dir)/*.c))

# Mappa i file sorgente ai file oggetto (preserva la struttura della directory)
OBJ_FILES = $(patsubst %.c, $(OBJ_DIR)/%.o, $(SRC_FILES))

# Regola principale
all: $(TARGET)

# Regola per creare il file ELF
$(TARGET): $(OBJ_FILES)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

# Regola generica per compilare i file sorgente in file oggetto
$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Regola per compilare per la simulazione
CFLAGS_SIM = "$(CFLAGS) -DSIMULATION"
sim:
	$(MAKE) -s CFLAGS=$(CFLAGS_SIM) all
# $(MAKE) -s CFLAGS=$(CFLAGS_SIM) TARGET="bin/mainSim.elf" all


RIPES_DIR = ~/RISC-V/RipesFiles
CFLAGS_RIPES = "$(CFLAGS) -DRIPES"
ripes:
	$(MAKE) -s clean
	$(MAKE) -s LDFLAGS="-e main" all
	cp $(TARGET) $(RIPES_DIR)/main.elf


# Regola per eseguire objdump
dump: $(TARGET)
	$(OBJDUMP) -d $(TARGET)

# Regola per leggere le sezioni
sections: $(TARGET)
	$(READELF) -S $(TARGET)

# Regola per estrarre i simboli
symbols: $(TARGET)
	$(READELF) -s $(TARGET)

# Pulizia dei file generati
clean:
	rm -rf $(OBJ_DIR) $(TARGET)

# Pulizia completa
clean-all: clean
	rm -rf bin

# Regole di utilità
.PHONY: all clean clean-all dump sections
