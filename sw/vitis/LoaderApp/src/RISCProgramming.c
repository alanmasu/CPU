#include "RISCProgramming.h"
#include <stdio.h>
#include "xil_printf.h"

#include <stdint.h>
#include <stdbool.h>

uint8_t CleanVerbose = 0;
uint8_t WriteVerbose = 0;

uint32_t const* ControlRegister = (uint32_t const*)RISC_CONTROL_REG;

uint32_t* riscvRam = (uint32_t*)RISC_RAM_BASE;

void cleanMemory(uint32_t* mem, const uint32_t mem_size) {
	for (int i = 0; i < mem_size / 4; i++) {
		if (CleanVerbose) {
			printf("Clearing Mem[%p] = 0\n", mem + i);
		}
		mem[i] = 0;
	}
}

void writeProgramMemory(const uint32_t* program, uint32_t* mem, const uint32_t mem_size) {
	for (int i = 0; program[i] != 0 && i < mem_size / 4; ++i) {
		mem[i] = program[i];
	}
}

void writeDataMemory(const uint8_t* data, uint8_t* mem, const uint32_t mem_size){
	for(int i = 0; i < mem_size; i++){
		if(WriteVerbose){
			printf("Writing Mem[%p] = 0x%02x [%c]\n", mem + i, data[i], data[i]);
		}
		mem[i] = data[i];
	}
}

void wait(uint32_t count){
    if(count == 0){
        count = DELAY_COUNT;
    }
    for(uint32_t i = 0; i < count; i++);
}
