# example_GPIO_Buttons

Shows the buttons BTNU, BTND, BTNL and BTNR on the LEDs LD4-LD7 and prints a line on the UART at every change. The buttons are bits of the IO register of the control registers of the core (`CREG_IO`, see `utilities.h`), the LEDs are pins of the GPIO.

## Run it on the board

`LoaderApp` of `sw/vitis` lists every example in its menu on the UART. Choose the number of `example_GPIO_Buttons`, start it with BTN8 (pin MIO50 of the PS), stop it with BTN8 again. Press BTNU, BTND, BTNL and BTNR. The loader uses BTN8, so these buttons belong to the program.

## Build

The program is built from the C sources in `src/`, with the SDK of `riscv/sdk` (start-up code, linker script, libraries), for the board only. From this folder:

```bash
make
make clean
```

- `make` builds `bin/board/example_GPIO_Buttons.elf` and also exports it into `out/riscv/loader/program.h`, entry 0 of the menu of `LoaderApp`.
- Next to the ELF goes the map of the linker (`.map`); `listing/board/` gets `example_GPIO_Buttons.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/examples` from the root of the repository builds every example and exports the headers of the menu (`out/riscv/examples/vitis/`).
