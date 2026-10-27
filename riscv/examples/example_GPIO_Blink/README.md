# example_GPIO_Blink

Blinks the LEDs LD4-LD7, pins 0-3 of port A of the GPIO of the core, with the GPIO library.

## Run it on the board

`LoaderApp` of `sw/vitis` lists every example in its menu on the UART. Choose the number of `example_GPIO_Blink`, start it with BTN8 (pin MIO50 of the PS), stop it with BTN8 again. Look at LD4-LD7.

## Build

The program is built from the C sources in `src/`, with the SDK of `riscv/sdk` (start-up code, linker script, libraries), for the board only. From this folder:

```bash
make
make clean
```

- `make` builds `bin/board/example_GPIO_Blink.elf` and also exports it into `out/riscv/loader/program.h`, entry 0 of the menu of `LoaderApp`.
- Next to the ELF goes the map of the linker (`.map`); `listing/board/` gets `example_GPIO_Blink.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/examples` from the root of the repository builds every example and exports the headers of the menu (`out/riscv/examples/vitis/`).
