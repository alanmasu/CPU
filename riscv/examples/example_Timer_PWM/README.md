# example_Timer_PWM

Dims the LED LD1, driven by the output of the timer in PWM mode: BTNL fades it by itself, BTNR switches to manual, where BTNU and BTND change the duty cycle by 10%; the UART tells the mode and the duty cycle. It does not work yet, because the PWM of the timer only toggles its output at the compare value (to be fixed in the RTL).

## Run it on the board

`LoaderApp` of `sw/vitis` lists every example in its menu on the UART. Choose the number of `example_Timer_PWM`, start it with BTN8 (pin MIO50 of the PS), stop it with BTN8 again. Press BTNL or BTNR, then BTNU and BTND, and look at LD1.

## Build

The program is built from the C sources in `src/`, with the SDK of `riscv/sdk` (start-up code, linker script, libraries), for the board only. From this folder:

```bash
make
make clean
```

- `make` builds `bin/board/example_Timer_PWM.elf` and also exports it into `out/riscv/loader/program.h`, entry 0 of the menu of `LoaderApp`.
- Next to the ELF goes the map of the linker (`.map`); `listing/board/` gets `example_Timer_PWM.dump` (address, instruction in hex and in assembly), `.disas`, `.sections` and `.symbols`.

`make -C riscv/examples` from the root of the repository builds every example and exports the headers of the menu (`out/riscv/examples/vitis/`).
