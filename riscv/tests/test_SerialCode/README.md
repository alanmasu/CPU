# test_SerialCode

A binary matrix multiplication computed in software with the BinaryMatMul library (serial code), checked against the expected blocks.

## Where it runs

- `TestApp` (`doTestSerialCode`)
- the testbench of `CPU_sim`

## Build

The program is built from the C sources in `src/`, with the SDK of `riscv/sdk` (start-up code, linker script, libraries). From this folder:

```bash
make
make SIMULATION=1
make clean
```

- `make` builds the board version into `bin/board/test_SerialCode.elf` and also exports it into `out/riscv/loader/program.h`, so `LoaderApp` of `sw/vitis` can load it (entry 0 of its menu).
- `make SIMULATION=1` builds the simulation version into `bin/sim/test_SerialCode.elf` (`SIMULATION` defined: shorter delays, no prints).
- Next to each ELF goes the map of the linker (`.map`); `listing/board/` and `listing/sim/` get `test_SerialCode.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/tests` from the root of the repository builds every test and exports the headers for the test suite (`out/riscv/test/vitis/`) and the testbenches (`out/riscv/test/sim/`); see the README of the repository.
