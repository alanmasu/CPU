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
// Every example of riscv/examples, for the menu: out/riscv/examples/vitis/,
// an include directory of this application, written by riscv/examples/Makefile
#include "examples.h"
#include "xgpiops.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include <stdbool.h>

// The button of the loader: BTN8 of the ZedBoard, on pin MIO50 of the PS, read
// through the GPIO of the PS. The five buttons of the PL belong to the RISC-V
// programs (control registers of the core), so the loader never stops them.
#define START_BUTTON_MIO 50

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

static XGpioPs psGpio;

static void initStartButton(void){
    XGpioPs_Config* config = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
    XGpioPs_CfgInitialize(&psGpio, config, config->BaseAddr);
    XGpioPs_SetDirectionPin(&psGpio, START_BUTTON_MIO, 0);
}

static bool startButtonPressed(void){
    return XGpioPs_ReadPin(&psGpio, START_BUTTON_MIO) == 1;
}

// A whole press, down and up, so that one press is one action
static void waitStartButton(void){
    while(!startButtonPressed());
    while(startButtonPressed());
    wait(0);    // the bounces of the release
}

// The programs of the menu: 0 is the one exported by make in the folder of a
// program (program.h), then every example
static const RiscvProgram_t exportedProgram = loader_program_PROGRAM;
static const RiscvProgram_t examples[] = EXAMPLES_TABLE;
#define EXAMPLES_COUNT (sizeof(examples) / sizeof(examples[0]))

// Reads a number from the UART, with echo, until Enter. The RISC-V core is
// stopped while the menu waits, so no program reads the same UART.
static const RiscvProgram_t* chooseProgram(void){
    while(1){
        printf("\nPrograms:\n");
        printf("  %2u  %s (exported by make in its folder)\n", 0u, exportedProgram.name);
        for(unsigned i = 0; i < EXAMPLES_COUNT; i++){
            printf("  %2u  %s\n", i + 1, examples[i].name);
        }
        printf("Number, then Enter: ");
        fflush(stdout);

        unsigned choice = 0;
        bool digits = false;
        char c = inbyte();
        while(c != '\r' && c != '\n'){
            if(c >= '0' && c <= '9'){
                outbyte(c);
                choice = choice * 10 + (c - '0');
                digits = true;
            }
            c = inbyte();
        }
        printf("\n");

        if(digits && choice == 0){
            return &exportedProgram;
        }
        if(digits && choice <= EXAMPLES_COUNT){
            return &examples[choice - 1];
        }
        printf("No program %u\n", choice);
    }
}

int main(){
	volatile ControlRegister_t* cregFile = (ControlRegister_t*) (RISC_CONTROL_REG + 0);
	volatile CREG_t*  	cregPtr   = (CREG_t*)   (RISC_CONTROL_REG) + 0;
	volatile CREG_IO_t* cregIOPtr = (CREG_IO_t*)(RISC_CONTROL_REG) + 4;
	volatile uint32_t*  oledCTR   = (uint32_t*) (RISC_CONTROL_REG) + 5;

    init_platform();
    Xil_DCacheDisable();
    initStartButton();

    printf("\n\r\n\r===========================");
    printf("\n\rRunning program at: %s\n\r\n\r", __TIME__);

    const uint32_t risc_v_heap_size = 1024*8;
    uint8_t risc_v_heap[risc_v_heap_size];
	*((uint32_t**)(riscvRam + 1)) = (uint32_t*)risc_v_heap;
    riscvRam[0] = risc_v_heap_size;
    printf("Heap of the RISC-V programs in DDR: %p, %lu bytes\n", risc_v_heap, (unsigned long)risc_v_heap_size);

    while(1){
        const RiscvProgram_t* program = chooseProgram();

        // Stop the core before writing its memories
        cregPtr->reset = 0;
        cregPtr->run = 0;
        wait(0);
        loadProgram(program);

        // The heap words are the first two of the data memory: a program may
        // have changed them, write them again
        *((uint32_t**)(riscvRam + 1)) = (uint32_t*)risc_v_heap;
        riscvRam[0] = risc_v_heap_size;

        printf("\nPress BTN8 (MIO50) to start %s\n", program->name);
        *oledCTR = 0b01;
        *(oledCTR + 1) = 0xAABBCCDD;
        cregIOPtr->led0 = 1;
        waitStartButton();
        cregIOPtr->led0 = 0;

        printf("%s running: press BTN8 (MIO50) to stop it and go back to the menu\n\n", program->name);
        cregPtr->reset = 1;
        cregPtr->run = 1;
        cregIOPtr->led1 = 1;

        // The end of a program is the jump on itself (jal x0, 0); an
        // application may never get there
        bool endReported = false;
        while(!startButtonPressed()){
            if(cregFile->instruction == 0x0000006f && !endReported){
                printf("\nProgram ended (jal x0, 0) at PC 0x%08lx\n", (unsigned long)cregFile->programCounter);
                endReported = true;
            }
        }
        while(startButtonPressed());
        wait(0);

        cregPtr->run = 0;
        cregPtr->reset = 0;
        cregIOPtr->led1 = 0;
        printf("\nCPU stopped\n");
    }

    cleanup_platform();
    return 0;
}
