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
#include "xil_io.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_cache.h"
#include <stdint.h>

// Including the headers of programs
#include "test_CPU.h"
#include "test_LoadStore.h"
#include "programs/GPIOProgram.h"
#include "programs/GPIOProgramMy.h"
#include "test_ALU.h"
#include "test_Memory.h"
#include "programs/testMemoryAXI.h"
#include "test_JumpBranch.h"
#include "test_BTPU.h"
#include "programs/test_BTPU_results.h"
#include "test_MatMul.h"
#include "programs/test_MatMul_results.h"

#include "test_SerialCode.h"
#include "test_LoadStoreBTPU.h"
#include "test_TimerContinuous.h"
#include "test_TimerCapture.h"



// Utilities and results of test
#include "programs/test_resoults.h"

#define DELAY_COUNT 10000000

volatile uint32_t* controlRegister 	= (uint32_t*)0x40004000;
uint32_t* programMemory 	= (uint32_t*)0x40000000;
uint32_t* dataMemory 		= (uint32_t*)0x40010000;
uint32_t* dataMemory_MAX 		= (uint32_t*)0x40012000;

// UART Address
uint32_t* uartAddress = (uint32_t*)0xE0001000;

#define PROGMEM_SIZE 4096
#define DATAMEM_SIZE 8192

// Control Register Definitions
#define CPU_RESET 0b00;
#define CPU_STOP  0b10;
#define CPU_RUN   0b11;


bool CleanVerbose = false;
//Test program
//extern const uint32_t testProgram[];
/**! 
 * 
 * @brief Clear Program Memory
 * @details Clear the program memory by setting all values to 0
 * 
 * @param programMemory [in] - The memory to clear
 * @param PROGMEM_SIZE [in] - The size of the memory
*/
void clearProgramMemory(uint32_t* mem, const uint32_t mem_size){
    for(int i = 0; i < mem_size/4; i++){
        if(CleanVerbose){
            printf("Clearing Mem[%p] = 0\n", mem+i);
        }
    	mem[i] = 0;
    }
}

/**!
 * @brief Write a program to the program memory
 * @details Start writing the program to the the address passed as argument until a 0 is found or MAX size is reached
 * 
 * @param program [in] - The program to write
 * @param programMemory [in] - The memory to write the program to
 * @param PROGMEM_SIZE [in] - The size of the memory
 * 
*/
void writeProgramMemory(const uint32_t* program, uint32_t* mem , const uint32_t mem_size){
    int i = 0;
    for(int i = 0; program[i] != 0 && i < mem_size/4; ++i){
    	mem[i] = program[i];
    }
}

void writeDataMemory(const uint8_t* data, uint8_t* mem, const uint32_t mem_size){
	for(int i = 0; i < mem_size; i++){
//		if(WriteVerbose){
//			printf("Writing Mem[%p] = 0x%02x [%c]\n", mem + i, data[i], data[i]);
//		}
		mem[i] = data[i];
	}
}

void doBlink(){
    controlRegister[0] = CPU_RESET;
    printf("Clearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'GPIO' to memory...\n");
    writeProgramMemory(GPIO, programMemory, PROGMEM_SIZE);

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Reset the CPU
    controlRegister[0] = CPU_RESET;

    // Start the CPU
    controlRegister[0] = CPU_RUN;

//    while(1);
}

void doTestCPU_test(){
    //Clearing the program memory
    printf("Clearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'testProgram' to memory...\n");
    writeProgramMemory(test_CPU_text, programMemory, PROGMEM_SIZE);
    controlRegister[0] = CPU_RESET; // Reset the CPU
    controlRegister[4] = controlRegister[4] | (0b11 << 24); //Turn ON 2 leds
    controlRegister[0] = CPU_RUN;   // Start the CPU

    // Wait the RISC-V to stop itself
    while(controlRegister[0] != 0b010){

    }
    controlRegister[0] = CPU_RUN;

    // Wait for the CPU to finish
    while(controlRegister[3] != 0x0000006f){

    }

    //Testing 'testProgram' resoults
    printf("Testing 'testProgram'...\n");

    //Reading saved registerFile
    int32_t regFile[33];
    for(int i = 1; i < 33; ++i ){
        int32_t* stackPointer = dataMemory_MAX-i;
        regFile[i] = *stackPointer;
        // printf("Reg[%d]: %0x\n\r", i, *stackPointer);
    }

    int testN = 1;
    if(regFile[testN] == 0x40000064){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, testN, regFile[testN]);
    }

    testN = 2;
    if(regFile[20] == -15){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 20, regFile[20]);
    }

    testN = 3;
    if(regFile[3] == 0x40010000){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 3, regFile[3]);
    }

    testN = 4;
    if(dataMemory[0] == -16){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> dataMemory[0] = 0x%00000000x\n", testN, dataMemory[0]);
    }

    testN = 5;
    if(regFile[4] == -16){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 4, regFile[4]);
    }
        
    testN = 6;      // jal x5, L2
    if(regFile[5] == 0x40000034){      //TO modify after compilation to jal x5, L2 + 4
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 5, regFile[5]);
    }

    testN = 7;      // lui x6, 0x40004
    if(regFile[6] == 0x40004000){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 6, regFile[6]);
    }

    testN = 8;      // li x14, 2
    if(regFile[14] == 2){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 14, regFile[14]);
    }

    testN = 9;      // sw x14, 0(x6)
    if(controlRegister[0] == 2){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: SKIPPED -> AXI controller do not stall the CPU until the WRITE transaction take effect\n", testN);
        // printf("Test #%d: FAILED -> controlRegister[0] = 0x%00000000x\n", testN, controlRegister[0]);
    }

    /*////////////////// TO NOTE ////////////////////
        - Se i test seguenti falliscono e' perche' qui e' necessario ri mettere in RUN la CPU
    */

    testN = 10;      // auipc x7, 4
    if(regFile[7] == 0x40004034){       //TO modify after compilation to auipc x7, 4 + 4
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 7, regFile[7]);
    }

    testN = 11;      // sw x7, -8(x8)
    printf("Test #%d: SKIPPED\n", testN);

    testN = 12;      // addi x8, x8, -8
    if(regFile[8] == 0x40011FF4){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 8, regFile[8]);
    }

    testN = 12;      // lui x9, 0x40020
    if(regFile[9] == 0x40020000){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 9, regFile[9]);
    }

    testN = 13;     // addi x10, x0, 1
    if(regFile[10] ==  1){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 10, regFile[10]);
    }

    testN = 12;     //sw x10, 4(x9) && sw x10 8(x9)
    printf("Test #%d: SKIPPED -> if LED LD4 is turned ON then the test is OK\n", testN);

    testN = 13;
    printf("Test #%d: SKIPPED -> check if 0x%00000000x is the value of Switches[7:4]\n", testN, regFile[11]>>24);

    testN = 14;     //lui x12, 0x40000
    if(regFile[12] == 0x40000000){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 12, regFile[12]);
    }

    testN = 15;     //sw x12, 0(x12)
    if(programMemory[0] == 0x40000000){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> instructionMemory[0] = 0x%00000000x\n", testN, programMemory[0]);
    }
    
    testN = 16;     //lw x13, 0(x12)
    if(regFile[13] == 0x40000000){
        printf("Test #%d: OK\n", testN);
    }else{
        printf("Test #%d: FAILED -> regFile[%d] = 0x%00000000x\n", testN, 13, regFile[13]);
    }
    controlRegister[4] = controlRegister[4] & ~(0b11 << 24); //Turn OFF 2 leds 
    printf("End of 'testProgram' tests\n\n\n");
}

void doTestLOAD_test(){
    printf("Testing 'testLoad'...\n");
    //Clearing the program memory
    printf("Clearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'testLoad' to memory...\n");
    writeProgramMemory(test_LoadStore_text, programMemory, PROGMEM_SIZE);
    // controlRegister[0] = CPU_RESET; // Reset the CPU
    uint32_t* addr = (uint32_t*)0x40011f5c;
    // if(addr == dataMemory_MAX-164){
    //     printf("Address TEST: OK\n");
    // }else{
    //     printf("Address TEST: FAILED -> addr = %p\n", dataMemory_MAX-164);
    // }
    // // printf("Setting dataMemory_MAX[-164] = 25: Mem[%p] = 25", dataMemory_MAX-164);
    // *(dataMemory_MAX-164) = 25;
    *addr = 25;


    controlRegister[4] = controlRegister[4] | (0b11 << 24); //Turn ON 2 leds
    controlRegister[0] = CPU_RESET; // Reset the CPU
    controlRegister[0] = CPU_RUN;   // Start the CPU

    // Wait for the CPU to finish
    while(controlRegister[3] != 0x0000006f){

    }
    //Testing 'testLoad' resoults
    printf("Testing 'testLoad'...\n");
    if(*(addr-1) == 25){ // sw a0, -164(sp)
        printf("Test #1: OK\n");
    }else{
        printf("Test #1: FAILED -> dataMemory_MAX[-8] = 0x%00000000x\n", *(addr-1));
    }

    if(*(addr-2) == -27){ // sw a1, -168(sp)
        printf("Test #2: OK\n");
    }else{
        printf("Test #2: FAILED -> dataMemory_MAX[-12] = 0x%00000000x\n", *(addr-2));
    }

    int32_t regFile[33];
    for(int i = 1; i < 33; ++i ){
        int32_t* stackPointer = dataMemory_MAX-i;
        regFile[i] = *stackPointer;
        // printf("Reg[%d]: %0x\n\r", i, *stackPointer);
    }

    if(regFile[10] == 25){          // lw a0, -160(sp)
        printf("Test #3: OK\n");
    }else{
        printf("Test #3: FAILED -> regFile[10] = 0x%00000000x\n", regFile[10]);
    }

    if(regFile[11] == -27){          // lw a1, -164(sp)
        printf("Test #4: OK\n");
    }else{
        printf("Test #4: FAILED -> regFile[11] = 0x%00000000x\n", regFile[11]);
    }

    if(regFile[12] == 0x40020000){   // lui a2, 0x40020
        printf("Test #5: OK\n");
    }else{
        printf("Test #5: FAILED -> regFile[12] = 0x%00000000x\n", regFile[12]);
    }

    //addi x13, x0, 1
    if(regFile[13] == 1){
        printf("Test #6: OK\n");
    }else{
        printf("Test #6: FAILED -> regFile[13] = 0x%00000000x\n", regFile[13]);
    }

    //lw x14, 0(x12)
    uint32_t gpi = regFile[14];
    gpi &= 0xff;
    if(gpi == 0xF1){          // lw a2, GPIO
        printf("Test #5: OK\n");
    }else{
        printf("Test #5: FAILED -> GPIO = 0x%00000000x\n", gpi);
    }
     

    //Test #6: "endianess"
    uint32_t* word = (uint32_t*)0x40011f50;
    uint32_t* wordByByte = (uint32_t*)0x40011f4c;
    uint32_t* testResoult = (uint32_t*)0x40011f48;

    if(*testResoult == 1){
        printf("Test #6: OK\n");
    }else{
        printf("Test #6: FAILED -> word expected = 0x%00000000x, was 0x%00000000x\n", *word, *wordByByte);
    }


    printf("End of 'testLoad' tests\n");
}

void doTestAlu(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    printf("Clearing data memory...\n");
    clearProgramMemory(dataMemory, ALU_RESULT_SIZE * 4);

    // Write the program to the program memory
    printf("Writing 'testAlu' to memory...\n");
    writeProgramMemory(test_ALU_text, programMemory, PROGMEM_SIZE);

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Reset the CPU
    controlRegister[0] = CPU_RESET;

    // Start the CPU
    controlRegister[0] = CPU_RUN;

    while (controlRegister[3] != 0x0000006f){
    
    }

    //Testing 'testAlu' resoults
    printf("Testing 'testAlu'...\n");

    bool res = check_results((int32_t*)dataMemory, ALU_EXPECTED_VALUES, ALU_RESULT_SIZE);

    printf("End of 'testAlu' tests: %s\n", res ? "OK" : "FAILED");
}

void doTestMemory(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    printf("Clearing data memory...\n");
    clearProgramMemory(dataMemory, MEMORY_RESULT_SIZE * 4);

    // Write the program to the program memory
    printf("Writing 'testMemory' to memory...\n");
    writeProgramMemory(test_Memory_text, programMemory, PROGMEM_SIZE);

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Reset the CPU
    controlRegister[0] = CPU_RESET;

    // Start the CPU
    controlRegister[0] = CPU_RUN;

    while (controlRegister[3] != 0x0000006f){

    }

    //Testing 'testMemoryJB' resoults
    printf("Testing 'testMemory'...\n");

    bool res = check_results(dataMemory, (int32_t*)MEMORY_EXPECTED_VALUES, MEMORY_RESULT_SIZE);

    printf("End of 'testMemory' tests: %s\n", res ? "OK" : "FAILED");
}

void doTestMemoryAXI(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    printf("Clearing data memory...\n");
    clearProgramMemory(dataMemory, MEMORY_RESULT_SIZE * 4);

    // Write the program to the program memory
    printf("Writing 'testMemoryAXI' to memory...\n");
    writeProgramMemory(testMemoryAXI, programMemory, PROGMEM_SIZE);

    uint32_t* ptr = NULL;
    ptr = (uint32_t*) malloc(100 * sizeof(uint32_t));

    if(ptr == NULL) {
    	printf("Allocation of DDR memory FAILED\n");
    	return;
    }else{
    	printf("Allocation of DDR memory OK: ptr is 0x%08x\n", ptr);
    }

    for(int i = 0; i < 100; ++i){
    	ptr[i] = 0;
    }

    uint32_t ptrVal = (uint32_t)ptr;
    *dataMemory = ptrVal;
    printf("ptr is 0x%08x\n", *dataMemory);

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Reset the CPU
    controlRegister[0] = CPU_RESET;

    // Start the CPU
    controlRegister[0] = CPU_RUN;

    while (controlRegister[3] != 0x0000006f){

    }

    //Testing 'testMemoryJB' resoults
    printf("Testing 'testMemoryAXI'...\n");

    bool res = check_results(ptr, (int32_t*)MEMORY_EXPECTED_VALUES, MEMORY_RESULT_SIZE);

    printf("End of 'testMemoryAXI' tests: %s\n", res ? "OK" : "FAILED");
    free(ptr);
}

void doTestJumpBranch(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    printf("Clearing data memory...\n");
    clearProgramMemory(dataMemory, JUMP_BRANCH_RESULT_SIZE*4);

    // Write the program to the program memory
    printf("Writing 'testJumpBranch' to memory...\n");
    writeProgramMemory(test_JumpBranch_text, programMemory, PROGMEM_SIZE);

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Reset the CPU
    // controlRegister[0] = CPU_RESET;

    // Start the CPU
    controlRegister[0] = CPU_RUN;

    int i = 0;
    while (controlRegister[3] != 0x0000006f){
    	if (i == (3 * DELAY_COUNT)){
    		printf("WANRN: Program may be in deadh lock, I start testing!\n");
    		break;
    	}
    	++i;
    }
    printf("CPU stopped at PC: 0x%08x\n", controlRegister[1]);
    //Testing 'testMemoryJB' resoults
    printf("Testing 'testJumpBranch'...\n");
    int res = 1;
    uint32_t* results = (uint32_t*)0x40010000;
    for (int i = 0; i < JUMP_BRANCH_RESULT_SIZE; i++) {
        if (results[i] != 1) {
            printf("Test #%d (%s): FAILED -> expected: 0x%x, was 0x%x\n",
                   i+1,JUMP_BRANCH_TEST_NAMES[i], 1, results[i]);
            res = 0;
        }else{
            printf("Test #%d (%s): OK\n", i+1, JUMP_BRANCH_TEST_NAMES[i]);
        }
    }
    if(*(dataMemory_MAX-1) == 0x4000000c){
        printf("Test JAL: OK\n");
    }else{
        printf("Test JAL: FAILED -> expected: 0x%x, was 0x%x\n", 0x4000000c, *(dataMemory));
        res = 0;
    } 

    if(*(dataMemory_MAX-2) == 0x40000020){
        printf("Test JALR: OK\n");
    }else{
        printf("Test JALR: FAILED -> expected: 0x%x, was 0x%x\n", 0x40000020, *(dataMemory-1));
        res = 0;
    }

    printf("End of 'testJumpBranch' tests: %s\n", res ? "OK" : "FAILED");
}


void doTestBTPU(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'BTPUProgram' to memory...\n");
    writeProgramMemory(test_BTPU_text, test_BTPU_TEXT_ADDR, test_BTPU_TEXT_SIZE);

    // Write .const data to memory
    #ifdef test_BTPU_CONST_SIZE  
        printf("Writing '.const' data to memory...\n");
        writeDataMemory((uint8_t*)test_BTPU_const, (uint8_t*)test_BTPU_CONST_ADDR, test_BTPU_CONST_SIZE);
    #endif

    // Write .bss data to memory
    #ifdef test_BTPU_BSS_SIZE  
        printf("Writing '.bss' data to memory...\n");
        uint8_t* bssMem = (uint8_t*)test_BTPU_BSS_ADDR;
        for(int i = 0; i < test_BTPU_BSS_SIZE; ++i){
            bssMem[i] = 0; // Clear the BSS memory
        }
    #endif

    #ifdef test_BTPU_DATA_SIZE  
        printf("Writing '.data' data to memory...\n");
        writeDataMemory((uint8_t*)test_BTPU_data, (uint8_t*)test_BTPU_DATA_ADDR, test_BTPU_DATA_SIZE);
    #endif  
    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Put CPU on RUN
    controlRegister[0] = CPU_RUN;

    // Wait for the CPU to finish
    while (controlRegister[3] != 0x0000006f);
//    while (controlRegister[1] <= 0x400001ec);
//    while(1);

    uint32_t* wMem = (uint32_t*)0x40080000;
    uint32_t* a1Mem = (uint32_t*)0x400C0000;
    uint32_t* aMem = (uint32_t*)0x400A0000;
    uint32_t* oMem = a1Mem + 32;

    //Testing 'BTPUProgram' resoults
    int res = 1;
    int count = 0;

    for(int i = 0; i < 32; ++i){
        if(aMem[i] != i +1){
            if(res) printf("Test aMem-%d: FAILED -> aMem[%d] was 0x%08x, expected 0x%08x\n", i, i, aMem[i], i + 1);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test aMem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test aMem: FAILED\n");
    }

    res = 1;
    count = 0;
    for(int i = 0; i < 32; ++i){
        if(a1Mem[i] != i + 2){
            if(res) printf("Test a1Mem-%d: FAILED -> a1Mem[%d] was 0x%08x, expected 0x%08x\n", i, i, a1Mem[i], i + 1);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test a1Mem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test a1Mem: FAILED\n");
    }


    res = 1;
    count = 0;
    for(int i = 0; i < 32; ++i){
        if(wMem[i] != i){
            if(res) printf("Test wMem-%d: FAILED -> wMem[%d] was 0x%08x, expected 0x%08x\n", i, i, wMem[i], test_BTPUResult[i]);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test wMem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test wMem: FAILED\n");
    }

    res = 1;
    count = 0;
    for(int i = 0; i < 32; ++i){
        if(oMem[i] != test_BTPUResult[i]){
            if(res) printf("Test BTPU-%d: FAILED -> oMem[%d] was 0x%08x, expected 0x%08x\n", i, i, oMem[i], test_BTPUResult[i]);
			res = 0;
			++count;
        }
    }
    if(res){
        printf("Test BTPU: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test BTPU: FAILED\n");
    }

    printf("End of 'BTPUProgram' tests\n");

}

void doTestMatMul(){
    const uint32_t B_M = 2;
    const uint32_t B_N = 3;
    const uint32_t B_K = 4;

    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'test_MatMul' to memory...\n");
    
    writeProgramMemory(test_MatMul_text, test_MatMul_TEXT_ADDR, test_MatMul_TEXT_SIZE);
    // Write .const data to memory
    #ifdef test_MatMul_CONST_SIZE  
        printf("Writing '.const' data to memory...\n");
        writeDataMemory((uint8_t*)test_MatMul_const, (uint8_t*)test_MatMul_CONST_ADDR, test_MatMul_CONST_SIZE);
    #endif

    #ifdef test_MatMul_BSS_SIZE  
        printf("Writing '.bss' data to memory...\n");
        uint8_t* bssMem = (uint8_t*)test_MatMul_BSS_ADDR;
        for(int i = 0; i < test_MatMul_BSS_SIZE; ++i){
            bssMem[i] = 0; // Clear the BSS memory
        }
    #endif 

    #ifdef test_MatMul_DATA_SIZE  
        printf("Writing '.data' data to memory...\n");
        writeDataMemory((uint8_t*)test_MatMul_data, (uint8_t*)test_MatMul_DATA_ADDR, test_MatMul_DATA_SIZE);
    #endif

    const uint32_t heapSize = 1024 * 16;
    uint8_t heapMem[heapSize]; 

    dataMemory[0] = heapSize;
    dataMemory[1] = (uint32_t)heapMem; // Set the heap memory address in the data memory

    printf("Allocated heap memory at: 0x%08x with size: %d bytes\n", (uint32_t)heapMem, heapSize);

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Put CPU on RUN
    controlRegister[0] = CPU_RUN;

    // Wait for the CPU to finish
    while (controlRegister[3] != 0x0000006f);
//    while (controlRegister[1] <= 0x400001ec);
//    while(1);
//
    uint32_t* wMem = (uint32_t*)0x40080000;
    uint32_t* a0Mem = (uint32_t*)0x400A0000;
    uint32_t* a1Mem = (uint32_t*)0x400C0000;

    uint32_t* o0Mem = a1Mem + (B_M * B_N * 32);
    uint32_t* o1Mem = a0Mem + (B_M * B_N * 32);

    //Testing 'BTPUProgram' resoults
    int res = 1;
    int count = 0;

    int bound = test_MatMul_blocksA0_ROWS * test_MatMul_blocksA0_COLS;
    for(int i = 0; i < bound; ++i){
        if(a0Mem[i] != test_MatMul_blocksA0[i]){
            if(res) printf("Test a0Mem-%d: FAILED -> a0Mem[%d] was 0x%08x, expected 0x%08x\n", i, i, a0Mem[i], test_MatMul_blocksA0[i]);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test a0Mem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test a0Mem: FAILED\n");
    }

    res = 1;
    count = 0;
    bound = test_MatMul_blocksA1_ROWS * test_MatMul_blocksA1_COLS;
    for(int i = 0; i < bound; ++i){
        if(a1Mem[i] != test_MatMul_blocksA1[i]){
            if(res) printf("Test a1Mem-%d: FAILED -> a1Mem[%d] was 0x%08x, expected 0x%08x\n", i, i, a1Mem[i], test_MatMul_blocksA1[i]);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test a1Mem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test a1Mem: FAILED\n");
    }
    

    res = 1;
    count = 0;
    bound = test_MatMul_blocksW_ROWS * test_MatMul_blocksW_COLS;
    for(int i = 0; i < bound; ++i){
        if(wMem[i] != test_MatMul_blocksW[i]){
            if(res) printf("Test wMem-%d: FAILED -> wMem[%d] was 0x%08x, expected 0x%08x\n", i, i, wMem[i], test_MatMul_blocksW[i]);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test wMem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test wMem: FAILED\n");
    }

    res = 1;
    count = 0;
    bound = test_MatMul_blocksO0_ROWS * test_MatMul_blocksO0_COLS;
    for(int i = 0; i < bound; ++i){
        if(o0Mem[i] != test_MatMul_blocksO0[i]){
            if(res) printf("Test o0Mem-%d: FAILED -> o0Mem[%d] was 0x%08x, expected 0x%08x\n", i, i, o0Mem[i], test_MatMul_blocksO0[i]);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test o0Mem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test o0Mem: FAILED\n");
    }

    res = 1;
    count = 0;
    bound = test_MatMul_blocksO1_ROWS * test_MatMul_blocksO1_COLS;
    for(int i = 0; i < bound; ++i){
        if(o1Mem[i] != test_MatMul_blocksO1[i]){
            if(res) printf("Test o1Mem-%d: FAILED -> o1Mem[%d] was 0x%08x, expected 0x%08x\n", i, i, o1Mem[i], test_MatMul_blocksO1[i]);
            res = 0;
            ++count;
        }
    }
    if(res){
        printf("Test o1Mem: OK\n");
    }else{
        printf("   %d more like this\n", count);
        printf("Test o1Mem: FAILED\n");
    }

    printf("End of 'BTPUProgram' tests\n");

}

#define BINARY_FRAG_SIZE 32

typedef uint32_t  BinaryFragment_t[BINARY_FRAG_SIZE];
typedef uint32_t* BinaryMatrix_t;
typedef uint32_t* Matrix_t;

typedef uint32_t  BinaryAcc_t[BINARY_FRAG_SIZE][BINARY_FRAG_SIZE];

void storeFragment(const BinaryFragment_t frag, BinaryMatrix_t mat, uint32_t blockRow, uint32_t blockCol, uint32_t n) {
    const int cols = n / 32;
    int blockRowOffset = blockRow * cols * BINARY_FRAG_SIZE;
    int blockColOffset = blockCol;
    int wordRow = blockRowOffset + blockColOffset;
    for (int i = 0; i < BINARY_FRAG_SIZE; ++i) {
        mat[wordRow] = frag[i];
        wordRow += cols;
    }
}

void storeFramentsToBinaryMatrix(const BinaryFragment_t src[], BinaryMatrix_t mat, const uint32_t M, const uint32_t N){
    int blockRows  = M / BINARY_FRAG_SIZE;
    int blockCols  = N / BINARY_FRAG_SIZE;
    int fragmentN = 0;
    for (int blockRow = 0; blockRow < blockRows; ++blockRow) {
        for (int blockCol = 0; blockCol < blockCols; ++blockCol) {
            storeFragment(src[fragmentN++], mat, blockRow, blockCol, N);
        }
    }
}

void doTestSerialCode(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'testSerialCode' to memory...\n");
    writeProgramMemory(test_SerialCode_text, test_SerialCode_TEXT_ADDR, test_SerialCode_TEXT_SIZE);

    // Write .const data to memory
    #ifdef test_SerialCode_CONST_SIZE  
        printf("Writing '.const' data to memory...\n");
        writeDataMemory((uint8_t*)test_SerialCode_const, (uint8_t*)test_SerialCode_CONST_ADDR, test_SerialCode_CONST_SIZE);
    #endif

    #ifdef test_SerialCode_BSS_SIZE  
        printf("Writing '.bss' data to memory...\n");
        uint8_t* bssMem = (uint8_t*)test_SerialCode_BSS_ADDR;
        for(int i = 0; i < test_SerialCode_BSS_SIZE; ++i){
            bssMem[i] = 0; // Clear the BSS memory
        }
    #endif

    #ifdef test_SerialCode_DATA_SIZE  
        printf("Writing '.data' data to memory...\n");
        writeDataMemory((uint8_t*)test_SerialCode_data, (uint8_t*)test_SerialCode_DATA_ADDR, test_SerialCode_DATA_SIZE);
    #endif

    uint8_t oMatrix[2][1024] = {0};
    *dataMemory = 2 * 1024;
    *(dataMemory + 1) = (uint32_t)oMatrix;

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Put CPU on RUN
    controlRegister[0] = CPU_RUN;

    // Wait for the CPU to finish
    while (controlRegister[3] != 0x0000006f);

    BinaryFragment_t* ouptutMem = (BinaryFragment_t*)0x400C0000;
    uint32_t* BTPU_IO1_MEM = (uint32_t*)0x400C0000;
    BinaryMatrix_t oBTPU = (BinaryMatrix_t)malloc(1024);
    if (oBTPU == NULL) {
        printf("Allocation of BTPU memory FAILED\n");
        return;
    } else {
        // printf("Allocation of BTPU memory OK: oBTPU is 0x%08x\n", oBTPU);
    }
    storeFramentsToBinaryMatrix(ouptutMem, oBTPU, 2 * 32, 1024);

    // Starting test
    int res_blocks = 1;
    int count_blocks = 0;

    int res_oBTPU = 1;
    int count_oBTPU = 0;

    int res_oMatrixSerial = 1;
    int count_oMatrixSerial = 0;

    int res_oMatrixBTPU = 1;
    int count_oMatrixBTPU = 0;

    // Check blocks on BTPU Memory
    const int O_ELEMENTS = test_MatMul_blocksO0_ROWS * test_MatMul_blocksO0_COLS;
    for (int i = 0; i < O_ELEMENTS; ++i){
        if(BTPU_IO1_MEM[i] != test_MatMul_blocksO0[i]){
            if(res_blocks) printf("Test blocks-%d: FAILED -> ouptutMem[%d] was 0x%08x, expected 0x%08x\n", i, i, BTPU_IO1_MEM[i], test_MatMul_blocksO0[i]);
            res_blocks = 0;
            ++count_blocks;
        }
    }
    if(res_blocks){
        printf("Test blocks: OK\n");
    }else{
        printf("   %d more like this\n", count_blocks);
        printf("Test blocks: FAILED\n");
    }

    // // Check oBTPU
    // for(int r = 0; r < test_MatMul_O0_ROWS; ++r) {
    //     for(int c = 0; c < test_MatMul_O0_COLS; ++c){
    //         if(oBTPU[r * test_MatMul_O0_COLS + c] != test_MatMul_O0[r * test_MatMul_O0_COLS + c]){
    //             if(res_oBTPU) printf("Test oBTPU: FAILED -> oBTPU[%d] was 0x%08x, expected 0x%08x\n", r * test_MatMul_O0_COLS + c, oBTPU[r * test_MatMul_O0_COLS + c], test_MatMul_O0[r * test_MatMul_O0_COLS + c]);
    //             res_oBTPU = 0;
    //             ++count_oBTPU;
    //         }
    //     }
    // }
    // if(res_oBTPU){
    //     printf("Test oBTPU: OK\n");
    // }else{  
    //     printf("   %d more like this\n", count_oBTPU);
    //     printf("Test oBTPU: FAILED\n");
    // }

    // // Check oMatrixSerial
    // for(int r = 0; r < test_MatMul_O0_ROWS; ++r) {
    //     for(int c = 0; c < test_MatMul_O0_COLS; ++c){
    //         if(oMatrix[0][r * test_MatMul_O0_COLS + c] != test_MatMul_O0[r * test_MatMul_O0_COLS + c]){
    //             if(res_oMatrixSerial) printf("Test oMatrixSerial-%d: FAILED -> oMatrix[0][%d] was 0x%08x, expected 0x%08x\n", r * test_MatMul_O0_COLS + c, r * test_MatMul_O0_COLS + c, oMatrix[0][r * test_MatMul_O0_COLS + c], test_MatMul_O0[r * test_MatMul_O0_COLS + c]);
    //             res_oMatrixSerial = 0;
    //             ++count_oMatrixSerial;
    //         }
    //     }
    // }            
    // if(res_oMatrixSerial){
    //     printf("Test oMatrixSerial: OK\n");
    // }else{
    //     printf("   %d more like this\n", count_oMatrixSerial);
    //     printf("Test oMatrixSerial: FAILED\n");
    // }

    // // Check oMatrixBTPU
    // for(int r = 0; r < test_MatMul_O1_ROWS; ++r) {
    //     for(int c = 0; c < test_MatMul_O1_COLS; ++c){
    //         if(oMatrix[1][r * test_MatMul_O0_COLS + c] != test_MatMul_O0[r * test_MatMul_O0_COLS + c]){
    //             if(res_oMatrixBTPU) printf("Test oMatrixBTPU-%d: FAILED -> oMatrix[1][%d] was 0x%08x, expected 0x%08x\n", r * test_MatMul_O0_COLS + c, r * test_MatMul_O0_COLS + c, oMatrix[1][r * test_MatMul_O0_COLS + c], test_MatMul_O0[r * test_MatMul_O0_COLS + c]);
    //             res_oMatrixBTPU = 0;
    //             ++count_oMatrixBTPU;
    //         }
    //     }
    // }
    // if(res_oMatrixBTPU){
    //     printf("Test oMatrixBTPU: OK\n");
    // }else{
    //     printf("   %d more like this\n", count_oMatrixBTPU);
    //     printf("Test oMatrixBTPU: FAILED\n");
    // }
    printf("End of 'testSerialCode' tests\n");
}

void doLoadStoreBTPUTest(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'testLoadStoreBTPU' to memory...\n");
    writeProgramMemory(test_LoadStoreBTPU_text, test_LoadStoreBTPU_TEXT_ADDR, test_LoadStoreBTPU_TEXT_SIZE);

    // Write .const data to memory
    #ifdef test_LoadStoreBTPU_CONST_SIZE  
        printf("Writing '.const' data to memory...\n");
        writeDataMemory((uint8_t*)test_LoadStoreBTPU_const, (uint8_t*)test_LoadStoreBTPU_CONST_ADDR, test_LoadStoreBTPU_CONST_SIZE);
    #endif

    #ifdef test_LoadStoreBTPU_BSS_SIZE  
        printf("Writing '.bss' data to memory...\n");
        uint8_t* bssMem = (uint8_t*)test_LoadStoreBTPU_BSS_ADDR;
        for(int i = 0; i < test_LoadStoreBTPU_BSS_SIZE; ++i){
            bssMem[i] = 0; // Clear the BSS memory
        }
    #endif

    #ifdef test_LoadStoreBTPU_DATA_SIZE  
        printf("Writing '.data' data to memory...\n");
        writeDataMemory((uint8_t*)test_LoadStoreBTPU_data, (uint8_t*)test_LoadStoreBTPU_DATA_ADDR, test_LoadStoreBTPU_DATA_SIZE);
    #endif

    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Put CPU on RUN
    controlRegister[0] = CPU_RUN;

    // Wait for the CPU to finish
    while (controlRegister[3] != 0x0000006f);

    uint32_t* memPtr = (uint32_t*)0x400C0000;
    if (*memPtr == 0x12345678) {
        printf("Test Store BTPU: OK\n");
    } else {
        printf("Test Store BTPU: FAILED -> expected 0x12345678, was 0x%08x\n", *memPtr);
    }
}

void doTimerContinuousTest(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'testTimerContinuous' to memory...\n");
    writeProgramMemory(test_TimerContinuous_text, test_TimerContinuous_TEXT_ADDR, test_TimerContinuous_TEXT_SIZE);

    #ifdef test_TimerContinuous_CONST_SIZE  
        printf("Writing '.const' data to memory...\n");
        writeDataMemory((uint8_t*)test_TimerContinuous_const, (uint8_t*)test_TimerContinuous_CONST_ADDR, test_TimerContinuous_CONST_SIZE);
    #endif
    
    #ifdef test_TimerContinuous_BSS_SIZE  
        printf("Writing '.bss' data to memory...\n");
        uint8_t* bssMem = (uint8_t*)test_TimerContinuous_BSS_ADDR;
        for(int i = 0; i < test_TimerContinuous_BSS_SIZE; ++i){
            bssMem[i] = 0; // Clear the BSS memory
        }
    #endif
    #ifdef test_TimerContinuous_DATA_SIZE  
        printf("Writing '.data' data to memory...\n");
        writeDataMemory((uint8_t*)test_TimerContinuous_data, (uint8_t*)test_TimerContinuous_DATA_ADDR, test_TimerContinuous_DATA_SIZE);
    #endif
    
    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Put CPU on RUN
    controlRegister[0] = CPU_RUN;

    // Wait for the CPU to finish
    while (controlRegister[3] != 0x0000006f);

    #ifdef test_TimerContinuous_timerValue_ADDR  
        uint64_t* timerMem = (uint64_t*)test_TimerContinuous_timerValue_ADDR;
        if(timerMem[0] == 10 * 4 + 4 * 4){
            printf("Test continuous mode: OK\n");
        }else{
            printf("Test continuous mode: FAILED -> timerMem = 0x%d\n", timerMem[0]);
        }
    #else
        printf("Test continuous mode: SKIPPED -> test_TimerContinuous_timerValue_ADDR is not defined\n");
    #endif
    printf("End of 'testTimerContinuous' tests\n");

}

void doTimerCaptureTest(){
    controlRegister[0] = CPU_RESET;
    printf("\n\n\nClearing program memory...\n");
    clearProgramMemory(programMemory, PROGMEM_SIZE);

    // Write the program to the program memory
    printf("Writing 'testTimerCapture' to memory...\n");
    writeProgramMemory(test_TimerCapture_text, test_TimerCapture_TEXT_ADDR, test_TimerCapture_TEXT_SIZE);

    #ifdef test_TimerCapture_CONST_SIZE  
        printf("Writing '.const' data to memory...\n");
        writeDataMemory((uint8_t*)test_TimerCapture_const, (uint8_t*)test_TimerCapture_CONST_ADDR, test_TimerCapture_CONST_SIZE);
    #endif
    
    #ifdef test_TimerCapture_BSS_SIZE  
        printf("Writing '.bss' data to memory...\n");
        uint8_t* bssMem = (uint8_t*)test_TimerCapture_BSS_ADDR;
        for(int i = 0; i < test_TimerCapture_BSS_SIZE; ++i){
            bssMem[i] = 0; // Clear the BSS memory
        }
    #endif
    #ifdef test_TimerCapture_DATA_SIZE  
        printf("Writing '.data' data to memory...\n");
        writeDataMemory((uint8_t*)test_TimerCapture_data, (uint8_t*)test_TimerCapture_DATA_ADDR, test_TimerCapture_DATA_SIZE);
    #endif
    
    //DELAY after the program is written
    for(int i = 0; i < DELAY_COUNT; ++i){
    }

    // Put CPU on RUN
    controlRegister[0] = CPU_RUN;

    // Wait for the CPU to finish
    while (controlRegister[3] != 0x0000006f);

    #ifdef test_TimerCapture_resultsTestCapture_ADDR  
        uint64_t* timerMem = (uint64_t*)test_TimerCapture_resultsTestCapture_ADDR;
        if(timerMem[0] == 6){
            printf("Test capture mode 1: OK\n");
        }else{
            printf("Test capture mode 1: FAILED -> timerMem = 0x%08x\n", timerMem[0]);
        }
        if(timerMem[1] == 6){
            printf("Test capture mode 2: OK\n");
        }else{
            printf("Test capture mode 2: FAILED -> timerMem = 0x%08x\n", timerMem[1]);
        }
    #else
        printf("Test capture mode: SKIPPED -> test_TimerCapture_resultsTestCapture_ADDR is not defined\n");
    #endif
}


int main(){
    int finish = 0;
	init_platform();
	Xil_DCacheDisable( );

    printf("\n\rRunning program at: %s\n\r", __TIME__);

	printf("Testing PS-PL GPIO...\n\tIf you set the SW1 and you press Buttons you see on LEDs and OLED the state\n\t[DO NOT USE CENTRAL BUTTON that is OLED POWEROFF]\n\n");
	controlRegister[5] = 1;                         // Set the CREG[5] LSB for getting CREG[6] as source for OLED
	for(int i = 0; i < DELAY_COUNT/3; ++i){
		uint32_t gpioState = controlRegister[4];
		// printf("%d\n", gpioState &  1);
		controlRegister[6] = gpioState &  1;        // Read the button, and write it to the OLED
		controlRegister[4] = gpioState << 23;       // Write the button state to the LEDs
	}
	printf("\nPAY ATTENTION: To test correctly the CPU is necessary to SET all 4 switches[7:4] to 1\n");

    do{
        init_platform();
        Xil_DCacheDisable( );

        printf("Waiting USER to connect via Vivado to the ILA...\n");
        printf("Press BTN Up to continue...\n");
        while((controlRegister[4] & 0x1) == 0){
            // Wait for the user to press the button
        }
        while((controlRegister[4] & 0x1) == 1){
        	// Wait for the user to release the button
        }

        doTestJumpBranch(); //Furder more investigation is needed to understand why the CPU
                            // does not pass this test if in a different order
        doTestCPU_test();
        doTestLOAD_test();
        doTestAlu();
        doTestMemory();
        // doTestMemoryAXI();
		doTestBTPU();
        doTestMatMul();
        doTestSerialCode(); 
        doLoadStoreBTPUTest();
        doTimerContinuousTest();
        doTimerCaptureTest();
        doBlink();

        printf("\nPress BTN Up to continue...\n");
        printf("Press BTN Down to exit...\n");
        // printf("0x%00000000x\n", (controlRegister[4] & 0x3));
        do{
            // for(int i = 0; i < DELAY_COUNT/3; ++i){}

            if((controlRegister[4] & 0x1) == 1){
                finish = 0;
                printf("Restarting...\n");
            }else if((controlRegister[4] & 0x2) == 2){
                finish = 1;
                printf("Exiting...\n");
            }
        }while((controlRegister[4] & 0x3) == 0);

        cleanup_platform();
    }while(!finish);

    return 0;
}
