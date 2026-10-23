# GPIO Library for RISC-V RV32I Core by Alan Masutti
This library provides a set of functions to interact with the GPIO module present in the RISC-V RV32I core. The library is implemented in C language and is intended to be used with the RISC-V gnu toolchain.

## Features
 - Control structures for GPIO
 - Functions to initialize GPIO diretions
 - Functions to read and write to GPIO
 - Functions to set and clear GPIO pins
 - Functions to toggle GPIO pins
 - Macros to define GPIO pins

## Usage
The library is implemented in C language and is intended to be used with the RISC-V gnu toolchain. The library is provided as a set of functions that can be called from the user application. The user application should include the header file `GPIO.h` and link the library `GPIO.c` to the project.
