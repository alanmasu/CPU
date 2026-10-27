# example_GPIO_BlinkAsm

The same blink as `example_GPIO_Blink`, in assembly, without libraries and without a stack. `TestApp` runs it at the end of the tests (`doBlink`).

## Run it on the board

`LoaderApp` of `sw/vitis` lists every example in its menu on the UART. Choose the number of `example_GPIO_BlinkAsm`, start it with BTN8 (pin MIO50 of the PS), stop it with BTN8 again. Look at LD4-LD7.

## Build

The program is built from the assembly sources in `src/` (`.S`, through the C preprocessor), with its own `linker_script.ld`, without libraries, for the board only. From this folder:

```bash
make
make clean
```

- `make` builds `bin/board/example_GPIO_BlinkAsm.elf` and also exports it into `out/riscv/loader/program.h`, entry 0 of the menu of `LoaderApp`.
- Next to the ELF goes the map of the linker (`.map`); `listing/board/` gets `example_GPIO_BlinkAsm.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/examples` from the root of the repository builds every example and exports the headers of the menu (`out/riscv/examples/vitis/`).
