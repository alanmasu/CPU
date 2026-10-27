# CPU

A 5-stage RISC-V soft core (RV32I) written in VHDL, with a binary neural network accelerator (BTPU), timer, GPIO and I2C peripherals, connected to the Zynq-7000 processing system of a ZedBoard. The project targets **Vivado 2021.2** and is organised with the `vivado_project_template`: the Vivado project is not committed, it is rebuilt from a Tcl snapshot.

## Contents

- [Repository layout](#repository-layout)
- [Requirements](#requirements)
- [Getting started](#getting-started)
- [Everyday commands](#everyday-commands)
- [Architecture](#architecture)
- [Simulation](#simulation)
- [RISC-V software](#risc-v-software)
- [Vitis applications](#vitis-applications)
- [Branches](#branches)
- [Known issues](#known-issues)

## Repository layout

```
.
├── hw/
│   ├── src/
│   │   ├── hdl/                  VHDL sources
│   │   │   ├── cpu/              the core, one folder per stage: IF, ID, IE, MEM_WB
│   │   │   ├── bnn/              BTPU and its building blocks
│   │   │   ├── axi/              AXI memory controller
│   │   │   ├── periph/           GPIO, I2C, timer, OLED driver
│   │   │   ├── packages/         shared VHDL packages (memory map, constants, types)
│   │   │   └── coe/              memory initialisation files
│   │   ├── sim/                  testbenches and waveform configurations (wcfg/)
│   │   ├── ip/                   configuration (.xci) of the catalog IPs used by the RTL
│   │   ├── constr/               constraints
│   │   └── vivado_project.tcl    snapshot of the Vivado project, rebuilt by "make project"
│   ├── legacy/                   sources and testbenches no longer in the project, kept for reference
│   ├── ghdl/                     GHDL simulations of the BNN datapath, with Python helpers
│   ├── scripts/                  prj:: commands of the template
│   ├── project.tcl               project settings (name, part, top)
│   └── vivado/                   GENERATED: the Vivado project
├── riscv/
│   ├── sdk/                      linker script, start-up code and libraries shared by every program
│   ├── tests/                    test programs, one folder per test (see RISC-V software)
│   ├── examples/                 example programs, one folder per example (see RISC-V software)
│   └── asm/                      older assembly programs, not yet moved to the new layout
├── sw/                           software of the Zynq ARM cores (Vitis, Linux), from the template
├── tools/                        elfexport.py, which exports an ELF for Vitis, the testbenches or a .coe,
│                                 and activate, which creates the Python environment pyEnv/
├── hooks/                        git hooks of the template
├── out/                          GENERATED: bitstream, .xsa, build products
├── local.mk                      rules of this product, read at the end of the template's Makefile
└── Makefile                      entry point for every command
```

## Requirements

- Vivado 2021.2 (and Vitis 2021.2 for the `sw/` part), with their settings sourced in the shell.
- The RISC-V GNU toolchain, built for RV32I with newlib, so that `riscv32-unknown-elf-gcc` is in the `PATH`. Install the prerequisites listed in [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain), then in its checkout:

  ```bash
  ./configure --prefix=<install path> --with-arch=rv32i --with-abi=ilp32
  make
  ```

  and add `<install path>/bin` to the `PATH`, for example in `~/.bashrc`:

  ```bash
  export PATH=$PATH:<install path>/bin
  ```
- Python 3 with `pyelftools`, for the export of the RISC-V programs: `source tools/activate` creates `pyEnv/` and installs it.

## Getting started

After a clone, create the Vivado project and build the hardware:

```bash
make hooks
make project
make xsa
```

`make hooks` installs the git hooks of the template, which check that the snapshot is consistent before every commit; `make project` rebuilds `hw/vivado/` from `hw/src/vivado_project.tcl`; `make xsa` produces `out/hw/CPU.bit` and `out/hw/CPU.xsa`.

## Everyday commands

| Command | What it does |
|---|---|
| `make vivado` | open the project in the GUI, with the `prj::` commands loaded (`prj::help` in the Tcl console) |
| `make export` | save the project into `hw/src/vivado_project.tcl`: run it before committing any change made in Vivado |
| `make xsa` | build bitstream and `.xsa` in `out/hw/` |
| `make sim SIMSET=<name>` | build the RISC-V tests, then run a simulation set in batch (see [Simulation](#simulation)) |
| `make -C riscv/tests` | build every RISC-V test for the board and for the simulation, and export them (see [RISC-V software](#risc-v-software)) |
| `make sim_all [RESULTS=<dir>]` | run every simulation set in one session, with a summary of the outcomes in `out/sim_all/summary.txt` (see [Simulation](#simulation)) |
| `make regen_pkg SIMSET=<name>` | compile the VHDL packages of a simulation set (see [Simulation](#simulation)) |
| `make vitis` | open the Vitis workspace `sw/vitis/` in the GUI, after building the RISC-V programs it includes (see [Vitis applications](#vitis-applications)) |
| `make update_xsa` | hand the `.xsa` of `out/hw/` over to the software, in `sw/hw/` (committed) |
| `make check` | the checks run before a commit |
| `make clean` | delete everything generated; refuses if the project has not been exported |

`make help` lists all the targets, including the Linux and Vitis ones.

## Architecture

The core is a 5-stage pipeline, one folder per stage in `hw/src/hdl/cpu/`:

- **Instruction fetch** (`IF/`) outputs the 32-bit instruction, the program counter and the next program counter, byte addressed. It contains the instruction memory. The core starts at `0x40000000`.
- **Instruction decode** (`ID/`) turns the instruction into the control word used by the next stage (operand selection, register values, immediate), sign-extends the immediate and contains the register file.
- **Execute** (`IE/`) contains the ALU and the comparator: it performs arithmetic, computes load/store addresses and the next program counter for branches and jumps, and the comparator evaluates the branch condition (for a jump it always sets `cond`).
- **Memory and write back** (`MEM_WB/`) contains the data memory, the address decoder that routes accesses to memories and peripherals, and the selection of the next program counter. Memory is byte addressed.

Memories are Block Memory Generator IPs in true dual port mode. Instruction and data memory are also reachable from the Zynq over AXI, which is how the ARM cores load programs and read results:

| Memory | IP | Size |
|---|---|---|
| Instruction memory | `instruction_mem` | 4096 × 32 bit (16 KB), byte write enable |
| Data memory | `data_memory` | 16384 × 32 bit (64 KB), byte write enable |
| BTPU weights and I/O memories | `BTPU_memory` | 32768 × 32 bit (128 KB) each |

The memory map of the core is defined in one place on the hardware side, `hw/src/hdl/packages/memory_pkg.vhd`; the software side reads it from the headers of the RISC-V libraries and from the linker script (see [RISC-V software](#risc-v-software)). Bit positions of the control registers are in `hw/src/hdl/packages/constant_package.vhd`.

## Simulation

`make sim SIMSET=<name>` runs a simulation set of the project in batch, and `make sim SIMSET=<name> GUI=1` opens the GUI and runs it there; the same sets can also be run from the GUI (`make vivado`, then select the set and *Run Simulation*). The sets that compile and run are `AXI_mem_ctrl`, `CPU_sim`, `address_manager`, `compressor_6_3_sim`, `compressor_level_sim`, `decode`, `fetch_sim`, `popcount_sim`, `test_GPIO`, `test_I2C_module`, `test_register_file`.

`CPU_sim` runs RISC-V programs on the core. The testbench (`hw/src/sim/cpu/test_CPU_wh_AXI.sv`) includes them as `<test>.svh` headers, which are not committed: they are generated into `out/riscv/test/sim/` from the sources in `riscv/tests/`, and `local.mk` makes `make sim` build them first. The folder is in the include directories of `CPU_sim`. Vivado reads that property, and the simulation time, from the **active** simulation set and not from the one it simulates: `make sim` makes the set active first, while from the GUI `CPU_sim` has to be made active by hand before *Run Simulation*, otherwise the compilation stops with `cannot open include file` (see [Known issues](#known-issues)).

In a project just created from the snapshot the catalog IPs used inside the core (`instruction_mem`, `data_memory`, `BTPU_memory`, `axi_bram_ctrl_0`, `axi_btpu_ctrl`) have no simulation models yet. `make sim` (and `prj::sim` in the Tcl console) generates them before simulating; *Run Simulation* in the GUI does not, and then `CPU_sim` stops with `Index -1 out of bound` and `AXI_mem_ctrl` reads the BTPU memories as zero: run `make sim` once, or *Generate Output Products* on those IPs.

Some SystemVerilog testbenches import VHDL packages. The simulation script generated by Vivado compiles SystemVerilog before VHDL, so on an empty simulation library the compilation stops on the missing package (`'<package>' is not declared`). `make sim` and `make sim_all` see that error, compile the VHDL packages of the set with `prj::regen_pkg` and launch the simulation again; from the GUI run `make regen_pkg SIMSET=<name>` once (or `prj::regen_pkg <name>` in the Tcl console) before *Run Simulation*.

`make sim_all` runs every simulation set in one Vivado session and writes into `out/sim_all/` (or `RESULTS`) the whole log of each set, a summary with `PASSED`, `FAILED`, `FINISHED` or `DID NOT RUN` for each set, and, through `sim_result_lines` in `hw/project.tcl`, a `<set>.txt` with only the lines of the tests, so two runs can be compared with `diff -r`.

Testbenches that no longer match the RTL are in `hw/legacy/sim/`, out of the project, until they are updated (see [Known issues](#known-issues)).

## RISC-V software

- `riscv/sdk/` is shared by every program: libraries of the peripherals (`GPIO`, `UART`, `I2C`, `Timer`, `OLED`, `BinaryMatMul` for the BTPU), `syscall` for newlib, the start-up code `start.S`, the linker script, `sdk.mk`, which a program's Makefile includes to get flags and SDK objects, and `program.mk`, the common part of every program's Makefile (toolchain, build folders, listings, export for the loader). `SIMULATION=1` builds the simulation variant (shorter delays, no debug prints).
- `riscv/tests/<test>/` holds one test program, with its own `Makefile` that builds it into `bin/board/<test>.elf`, or `bin/sim/<test>.elf` with `SIMULATION=1`: the tests in C with the SDK, the tests in assembly (`.S`, through the C preprocessor) with their own linker script. The two builds have their own folders, so switching needs no clean. Next to the ELF goes the map of the linker (`<test>.map`), and `listing/<board|sim>/` gets `<test>.dump` (`objdump -d`: address, instruction in hex and in assembly on one line), `<test>.disas` (`objdump -D`, data sections too), `<test>.sections` (`readelf -S`) and `<test>.symbols` (`nm -n -S`).
- `riscv/examples/<example>/` holds one example program, built the same way, for the board only: `example_HelloWorld`, `example_GPIO_Blink` and `example_GPIO_BlinkAsm` (the LEDs LD4-LD7, in C and in assembly), `example_NewLibSupport` (the sections and `malloc` of newlib, input from the UART), `example_I2C_PB200` (a temperature sensor on I2C, shown on the OLED). `riscv/examples/Makefile` builds them all and exports a `.h` into `out/riscv/examples/vitis/`; `TestApp` takes `example_GPIO_BlinkAsm` from there.
- `make` in the folder of a test or an example, for the board, also exports it into `out/riscv/loader/program.h`, the program `LoaderApp` of `sw/vitis/` loads (every name starts with `loader_program`); the builds of every program from `riscv/tests/Makefile` and `riscv/examples/Makefile` do not.
- `riscv/tests/Makefile` builds every test for the board and exports a `.h` into `out/riscv/test/vitis/`, then builds it for the simulation and exports a `.svh` into `out/riscv/test/sim/`, stopping at the first error. Every exported name starts with the test name (`test_BTPU_text`, `test_SerialCode_results_ADDR`). `make board` and `make sim` run one of the two halves. The builds are incremental and a header is rewritten only when it changes, so the Vitis applications and the testbenches compile again only for the tests that changed.
- `tools/elfexport.py` writes those files (`--format h`, `svh` or `coe`); it needs `pyelftools`, which `tools/activate` installs into `pyEnv/`.

To add a test, create its folder with a `Makefile` (copy the one of a test in the same language) and add its name to `TESTS` in `riscv/tests/Makefile`; an example the same way, in `EXAMPLES` of `riscv/examples/Makefile`.

`riscv/asm/` still holds older assembly programs, each with its own `Makefile` and linker script, out of date with respect to the memory sizes above. Applications with a life of their own live in their own repositories and include this one as a submodule, pinned to a tagged version, so that each application records the exact hardware and `sdk` it runs on.

## Vitis applications

`sw/vitis/` is the workspace of the classic Vitis 2021.2, with the platform `CPU_Platform` on the hardware in `sw/hw/CPU.xsa` (`make xsa`, then `make update_xsa`) and two standalone applications for the Cortex-A9, each with its system project:

- `TestApp` loads every RISC-V test of `riscv/tests/` into the core, runs it and checks the results, printing `Test #n: OK` or `FAILED` on the UART. It includes the board build of the tests from `out/riscv/test/vitis/`; a pre-build step runs `make riscv_tests_board`, so that a build from the GUI also picks up the tests changed while the GUI was open.
- `LoaderApp` loads one program, the one in `out/riscv/loader/program.h`, starts it with BTN UP and reports when it ends; BTN UP loads it again, any other button stops. To choose the program, run `make` in its folder (for example `make -C riscv/tests/test_ALU`), then build `LoaderApp`. After a clone the default program is `example_GPIO_Blink`.

`make vitis` opens the GUI and `make vitis_build` builds everything without it; both build the RISC-V programs first. With the GUI open, build from the GUI: `make vitis_build` refuses to run while the GUI holds the workspace.

Two things to know when building from the GUI:
- Eclipse ignores the errors of the pre-build step: if a test does not compile, the build of `TestApp` still ends, with the headers of the last good build. The error is at the top of the console of `TestApp`, or run `make riscv_tests_board` in a terminal.
- An include directory outside the workspace goes in relative to it, as `${workspace_loc}/../../out/...`: an absolute path would not work on another machine, and the git hook refuses it.

## Branches

- `main`: stable versions only, each one tagged.
- `develop`: integration branch.
- Work branches start from `develop`, one per topic, and are merged back into `develop` as soon as the topic works, then deleted. A branch is never started from another work branch.

## Known issues

- Unaligned memory accesses are not fully supported and can give wrong results.
- Critical warnings already present in the original design:
  - in `top_level`, the 32-bit `GPIO` of `CPU_0` is connected to the 16-bit port `GPIO_0`;
  - in `top_level_dbg`, the probes of the `system_ila` are unconnected, because the `*_dbg` ports no longer exist in the RTL;
  - in `test_design_axi_recursive`, `CPU_0/cdma_interrupt` is unconnected.
- Testbenches in `hw/legacy/sim/` to be updated to the current RTL: `test_BTPU_memory.vhd`, `test_RAM.vhd`, `test_memoryAndWriteback.vhd`, and `test_CPU_AXI_recursive.sv`, which also needs the block design `test_design_axi_recursive` enabled for simulation.
- In `memory_pkg.vhd` the comment on the data memory still says that it ends at `0x40011FFF`, and in `constant_package.vhd` the reset value of `sp` and `s0` is `0x40011FFC`: both date from the 8 KB data memory. The start-up code sets `sp` anyway.
- `address_manager` runs to the end but all its 18 checks print `FAILED`: the testbench is behind the RTL.
- `CPU_sim`, I2C test 13 fails (`0xF6C4` read instead of `0x76C4`): the I2C slave model of the testbench, `hw/src/sim/common/slave_interface.vhd`, cannot read more than one byte.
- Vivado reads the include directories and the simulation time only from the active simulation set, not from the one passed to `launch_simulation`; a project created from the snapshot has `sim_1` active, so in the GUI the set to simulate has to be made active by hand (`make sim` does it, see [Simulation](#simulation)).
- `AXI_mem_ctrl`: 7 timer checks fail (counts one lower than expected, `19` instead of `20`, and the PWM output one cycle off); `test_I2C_module`: test 12 fails and test 11 warns about the byte order. They became visible on 24/10/2026, when the simulations started to run for their full time.
- After `make project` the catalog IPs have no simulation models until `make sim` or `make xsa` generates them; *Run Simulation* in the GUI alone does not (see [Simulation](#simulation)).
- The wrapper of the simulation block design `mem_ctrl_test` is a copy in `hw/src/sim/axi/`, so it must be regenerated by hand if the ports of the block design change; it can be replaced by a wrapper managed by Vivado.
- Open items from the previous to-do list:
  - check how `pc_enable` and the instruction register affect the fetch stage;
  - simulate the data memory when the address arrives in one clock cycle and the data on the next edge.
