/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "RISCProgramming.h"
#include <inttypes.h>

// The program to load: out/riscv/loader/program.h, an include directory of
// this application, written by make run in the folder of a RISC-V program
// (see riscv/sdk/program.mk). Every name starts with loader_program.
#include "program.h"

typedef struct __attribute__((packed)) GPIOReg_t{
    unsigned int GPIO0 : 1;
    unsigned int GPIO1 : 1;
    unsigned int GPIO2 : 1;
    unsigned int GPIO3 : 1;
    unsigned int GPIO4 : 1;
    unsigned int GPIO5 : 1;
    unsigned int GPIO6 : 1;
    unsigned int GPIO7 : 1;
} GPIOReg_t;

typedef struct __attribute__((packed)) GPIOPort_t{
    GPIOReg_t PORT_A;
    GPIOReg_t PORT_B;
    GPIOReg_t PORT_C;
    GPIOReg_t PORT_D;
} GPIOPort_t;

typedef struct __attribute__((packed)) GPIODir_t{
    GPIOReg_t PORT_A_DIR;
    GPIOReg_t PORT_B_DIR;
    GPIOReg_t PORT_C_DIR;
    GPIOReg_t PORT_D_DIR;
} GPIODir_t;

typedef struct __attribute__((packed)) GPIOData_t{
    GPIOReg_t PORT_A_DATA;
    GPIOReg_t PORT_B_DATA;
    GPIOReg_t PORT_C_DATA;
    GPIOReg_t PORT_D_DATA;
} GPIOData_t;


#define UART_STATUS_ADDR    0xE000102C
#define UART_RXEMPTY   		(1 << 1)

typedef union SmartPtr_t{
	uint32_t value;
	uint8_t data[4];
}SmartPtr_t;

int main(){
	volatile ControlRegister_t* cregFile = (ControlRegister_t*) (RISC_CONTROL_REG + 0);
	volatile CREG_t*  	cregPtr   = (CREG_t*)   (RISC_CONTROL_REG) + 0;
	volatile CREG_IO_t* cregIOPtr = (CREG_IO_t*)(RISC_CONTROL_REG) + 4;
	volatile uint32_t*  oledCTR   = (uint32_t*) (RISC_CONTROL_REG) + 5;

	volatile SmartPtr_t*  UARTSTReg = (SmartPtr_t*) (UART_STATUS_ADDR);
	volatile SmartPtr_t*  oledData  = (SmartPtr_t*) (RISC_CONTROL_REG) + 6;

	volatile uint32_t* BTPU_W_BASE = (uint32_t*) 0x40080000;
	volatile uint32_t* BTPU_IO0_BASE = (uint32_t*) 0x400A0000;
	volatile uint32_t* BTPU_IO1_BASE = (uint32_t*) 0x400C0000;

    init_platform();
    Xil_DCacheDisable();

    const uint32_t risc_v_heap_size = 1024*8;
//    uint32_t* risc_v_heap = (uint32_t*) malloc(risc_v_heap_size);
    uint8_t risc_v_heap[risc_v_heap_size];
	*((uint32_t**)(riscvRam + 1)) = risc_v_heap;
    if (risc_v_heap != NULL){
		riscvRam[0] = risc_v_heap_size;
		printf("Allocation of heap in DDR OK: heapPtr: %p\n", risc_v_heap);
    }else{
    	riscvRam[0] = 0;
    	printf("Allocation of heap in DDR FAILED\n");
    }

    /*Command for loop
     *  0: stop
     *  1: continue
    */
    uint8_t cmd = 0; //
    do{
    	cregPtr->reset = 0;
    	cregPtr->run = 0;


        xil_printf("Cleaning PROGMEM...\n");
        cleanMemory((uint32_t*)RISC_INSTR_BASE, PROGMEM_SIZE);

        wait(0);

        printf("Writing .text section...\n");
        writeProgramMemory(loader_program_text, (uint32_t*)loader_program_TEXT_ADDR, loader_program_TEXT_SIZE);

        wait(0);
        #if defined(loader_program_CONST_SIZE) && loader_program_CONST_SIZE > 0
            printf("Writing .const section...\n");
            writeDataMemory((uint8_t*)loader_program_const, (uint8_t*)loader_program_CONST_ADDR, loader_program_CONST_SIZE);
        #endif

        #ifdef loader_program_BSS_SIZE
            printf("Cleaning .bss section...\n");
            cleanMemory((uint32_t*)loader_program_BSS_ADDR, loader_program_BSS_SIZE);
        #endif

        #if defined(loader_program_DATA_SIZE) && loader_program_DATA_SIZE > 0
            printf("Writing .data section...\n");
            writeDataMemory((uint8_t*)loader_program_data, (uint8_t*)loader_program_DATA_ADDR, loader_program_DATA_SIZE);
        #endif

        // The global pointer is not written: the start-up code of the program
        // loads it into gp by itself, and the first two words of the data
        // memory hold the size and the address of the heap (written above)

        
        printf("\nWaiting BTN UP to be pressed for startup the CPU...\n");

        // *oledCTR = 0b01;
        // cregPtr->reset = 1;
        // cregPtr->run = 1;
		// while(1){
		// 	oledData->data[0] = *((uint32_t*)cregIOPtr) & 0xF;
		// 	oledData->data[3] = cregIOPtr->btnUP | cregIOPtr->btnDOWN << 1 | cregIOPtr->btnRIGHT << 3 | cregIOPtr->btnLEFT << 2;
		// 	*((uint32_t*)cregIOPtr) = *((uint32_t*)cregIOPtr) << 24;
		// 	oledData->data[2] = *((uint8_t*)cregPtr);
		// }

       *oledCTR = 0b01;
        cregIOPtr->led0 = 1;
       *oledCTR = 0b01;
       *(oledCTR + 1) = 0xAABBCCDD;
        
        while (cregIOPtr->btnUP == 0);

        printf("After programm execution you can press:\n  BTN UP to continue\n  Others to stop...\n");
        cregIOPtr->led0 = 0;

        wait(0);
        cregPtr->reset = 1;
        cregPtr->run = 1;
        cregIOPtr->led1 = 1;
        
        // No wait for a fixed address: the program may never end (an
        // application) or end before any given address (a short test). The
        // end of a program, the jump on itself (jal x0, 0), is reported in
        // the loop below.
        wait(0);

        uint32_t cregIOState = *(uint32_t*)cregIOPtr;
        cregIOState &= 0xF; //Zero extended
        uint32_t cregIO = 0;
        oledData->value = 0;
        uint8_t printedResults = 0;
        uint64_t* timeResults = (uint64_t*)risc_v_heap;
        uint8_t endReported = 0;
        do{
            cregIO = *(uint32_t*)cregIOPtr;
            cregIO &= 0xF; //Zero extended
            if(cregFile->instruction == 0x0000006f && !endReported){
                printf("Program ended (jal x0, 0) at PC 0x%08lx\n", (unsigned long)cregFile->programCounter);
                endReported = 1;
            }
            // oledData->data[0] = UARTSTReg->data[0];
            // oledData->data[3] = (UARTSTReg->data[0] & UART_RXEMPTY) >> 1;

//			if(cregFile->instruction == 0x0000006f && !printedResults){
//				printf("Times\n");
//				for(int i = 0; i < riscvRam[0]; ++i){
//					printf("%" PRIu64 ",\n", timeResults[i]);
//				}
//				printedResults = 1;
//			}
        }while(cregIOState == cregIO);
        cmd = cregIOPtr->btnUP;
        printf("\n\n");
    }while(cmd);

    cregPtr->run = 0;
    printf("CPU stopped\n");

    cleanup_platform();
    return 0;
}
