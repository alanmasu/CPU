#include <main.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <BinaryMatMul.h>
#include <UART.h>
#include <GPIO.h>
#include <utilities.h>

#ifndef SIMULATION
    #define PRINTF_DBG(...) printf(__VA_ARGS__)
#else 
    #define PRINTF_DBG(...)
#endif

uint32_t* BTPU0_W_MEMORY_prt = (uint32_t*)BTPU_IO1_MEMORY_BASE;

uint32_t value;
 // Disable optimization for this function
__attribute__((optimize("O0")))
int main(int argc, char const *argv[]){
    *(BTPU0_W_MEMORY_prt) = 0x12345678; // Write a value to the first word of BTPU_W_MEMORY
    // value = BTPU0_W_MEMORY[0][0]; // Read the value back
    value = *(BTPU0_W_MEMORY_prt); // Read the value back
    if (value != 0x12345678) {
        PRINTF_DBG("Test #1: FAILED -> value was 0x%08x, expected 0x12345678\n", value);
    } else {
        PRINTF_DBG("Test #1: OK\n");
    }
    
    PRINTF_DBG("Setting BRAM Port to EXTERNAL...\n");
    BTPU0RegFile->creg.reg.BRAM_PORT_SEL = BTPU_BRAM_PORT_SEL_EXT; // Set BRAM port to external

    while (1);

}