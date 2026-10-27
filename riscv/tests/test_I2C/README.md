# test_I2C

Writes a byte to the I2C slave 0x56 and reads it back through the I2C module of the core.

## Where it runs

- the testbench of `CPU_sim`, with the slave model `slave_interface.vhd` (its Test #13 fails: the model does not handle reads of more than one byte)

## Build

The program is built from the assembly sources in `src/` (`.S`, through the C preprocessor), with its own `linker_script.ld`, without libraries. From this folder:

```bash
make
make SIMULATION=1
make clean
```

- `make` builds the board version into `bin/board/test_I2C.elf` and also exports it into `out/riscv/loader/program.h`, so `LoaderApp` of `sw/vitis` can load it (entry 0 of its menu).
- `make SIMULATION=1` builds the simulation version into `bin/sim/test_I2C.elf` (`SIMULATION` defined: shorter delays, no prints).
- Next to each ELF goes the map of the linker (`.map`); `listing/board/` and `listing/sim/` get `test_I2C.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/tests` from the root of the repository builds every test and exports the headers for the test suite (`out/riscv/test/vitis/`) and the testbenches (`out/riscv/test/sim/`); see the README of the repository.
