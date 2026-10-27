# test_CPU

A mix of instructions whose results stay in the registers. On the board the program also calls `cat_registers` (`debug_utilities.S`), which copies the registers into the data memory for the test suite; with `SIMULATION=1` the testbench reads the registers directly.

## Where it runs

- `TestApp` (`doTestCPU_test`); three checks fail because the expected values in `TestApp` belong to an older version of the program
- the testbench of `CPU_sim`

## Build

The program is built from the assembly sources in `src/` (`.S`, through the C preprocessor), with its own `linker_script.ld`, without libraries. From this folder:

```bash
make
make SIMULATION=1
make clean
```

- `make` builds the board version into `bin/board/test_CPU.elf` and also exports it into `out/riscv/loader/program.h`, so `LoaderApp` of `sw/vitis` can load it (entry 0 of its menu).
- `make SIMULATION=1` builds the simulation version into `bin/sim/test_CPU.elf` (`SIMULATION` defined: shorter delays, no prints).
- Next to each ELF goes the map of the linker (`.map`); `listing/board/` and `listing/sim/` get `test_CPU.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/tests` from the root of the repository builds every test and exports the headers for the test suite (`out/riscv/test/vitis/`) and the testbenches (`out/riscv/test/sim/`); see the README of the repository.
