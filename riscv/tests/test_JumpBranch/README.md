# test_JumpBranch

Runs JAL, JALR and every conditional branch, writing 1 in the data memory for each jump taken where expected.

## Where it runs

- `TestApp` (`doTestJumpBranch`, run first)

## Build

The program is built from the assembly sources in `src/` (`.S`, through the C preprocessor), with its own `linker_script.ld`, without libraries. From this folder:

```bash
make
make SIMULATION=1
make clean
```

- `make` builds the board version into `bin/board/test_JumpBranch.elf` and also exports it into `out/riscv/loader/program.h`, so `LoaderApp` of `sw/vitis` can load it (entry 0 of its menu).
- `make SIMULATION=1` builds the simulation version into `bin/sim/test_JumpBranch.elf` (`SIMULATION` defined: shorter delays, no prints).
- Next to each ELF goes the map of the linker (`.map`); `listing/board/` and `listing/sim/` get `test_JumpBranch.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/tests` from the root of the repository builds every test and exports the headers for the test suite (`out/riscv/test/vitis/`) and the testbenches (`out/riscv/test/sim/`); see the README of the repository.
