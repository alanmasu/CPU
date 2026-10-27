# test_Memory

Aligned and misaligned stores (SW, SH, SB) and loads (LW, LH, LHU, LB, LBU) in the data memory; the 32 results are stored from 0x40010000.

## Where it runs

- `TestApp` (`doTestMemory`), against `MEMORY_EXPECTED_VALUES` of `test_resoults.h`

## Build

The program is built from the assembly sources in `src/` (`.S`, through the C preprocessor), with its own `linker_script.ld`, without libraries. From this folder:

```bash
make
make SIMULATION=1
make clean
```

- `make` builds the board version into `bin/board/test_Memory.elf` and also exports it into `out/riscv/loader/program.h`, so `LoaderApp` of `sw/vitis` can load it (entry 0 of its menu).
- `make SIMULATION=1` builds the simulation version into `bin/sim/test_Memory.elf` (`SIMULATION` defined: shorter delays, no prints).
- Next to each ELF goes the map of the linker (`.map`); `listing/board/` and `listing/sim/` get `test_Memory.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/tests` from the root of the repository builds every test and exports the headers for the test suite (`out/riscv/test/vitis/`) and the testbenches (`out/riscv/test/sim/`); see the README of the repository.
