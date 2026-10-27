# test_BTPU

Fills the memories of the BTPU and runs a binary matrix multiplication on the BTPU, through the BinaryMatMul library.

## Where it runs

- `TestApp` (`doTestBTPU`), against `test_BTPU_results.h`
- the testbench of `CPU_sim`

## Build

The program is built from the C sources in `src/`, with the SDK of `riscv/sdk` (start-up code, linker script, libraries). From this folder:

```bash
make
make SIMULATION=1
make clean
```

- `make` builds the board version into `bin/board/test_BTPU.elf` and also exports it into `out/riscv/loader/program.h`, so `LoaderApp` of `sw/vitis` can load it (entry 0 of its menu).
- `make SIMULATION=1` builds the simulation version into `bin/sim/test_BTPU.elf` (`SIMULATION` defined: shorter delays, no prints).
- Next to each ELF goes the map of the linker (`.map`); `listing/board/` and `listing/sim/` get `test_BTPU.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/tests` from the root of the repository builds every test and exports the headers for the test suite (`out/riscv/test/vitis/`) and the testbenches (`out/riscv/test/sim/`); see the README of the repository.
