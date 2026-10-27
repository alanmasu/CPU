# example_OLED_Counter

Counts on the OLED display, in hexadecimal: the source of the display is the OLED data register of the control registers, written by the program.

## Run it on the board

`LoaderApp` of `sw/vitis` lists every example in its menu on the UART. Choose the number of `example_OLED_Counter`, start it with BTN8 (pin MIO50 of the PS), stop it with BTN8 again. Set SW1 up (it is the lowest bit of the source of the display), and do not press BTNC, which powers the display off.

## Build

The program is built from the C sources in `src/`, with the SDK of `riscv/sdk` (start-up code, linker script, libraries), for the board only. From this folder:

```bash
make
make clean
```

- `make` builds `bin/board/example_OLED_Counter.elf` and also exports it into `out/riscv/loader/program.h`, entry 0 of the menu of `LoaderApp`.
- Next to the ELF goes the map of the linker (`.map`); `listing/board/` gets `example_OLED_Counter.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/examples` from the root of the repository builds every example and exports the headers of the menu (`out/riscv/examples/vitis/`).
