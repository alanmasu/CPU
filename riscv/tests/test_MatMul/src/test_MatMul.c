#include <main.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <BinaryMatMul.h>
#include <UART.h>
#include <GPIO.h>
#include <utilities.h>

#include "testHeader.h"

#ifndef SIMULATION
    #define PRINTF_DBG(...) printf(__VA_ARGS__)
#else 
    #define PRINTF_DBG(...)
#endif
void setBusy(){
    gpioSetValueByNum((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN0, BTPU0RegFile->creg.reg.BUSY); // Toggle LED0 based on BTPU busy status
}

void printCreg(BTPURegFile_t* inst){
#ifndef SIMULATION
    printf("\n/////////////////////////////////////////\n");
    printf("BTPU CREG:\n");
    printf("     start: %d\n", inst->creg.reg.START);
    printf("     busy: %d\n", inst->creg.reg.BUSY);
    printf("     omem_sel: %d\n", inst->creg.reg.OMEM_SEL);
    printf("     bram_port_sel: %d\n", inst->creg.reg.BRAM_PORT_SEL);
    printf("     acc_clear: %d\n", inst->creg.reg.ACC_CLEAR);
    printf("     batched_mul: %d\n", inst->creg.reg.BATCHED_MUL);
    printf("     error: %d\n", inst->creg.reg.ERROR);
    printf("\n");
    printf("BTPU W Addr: %d\n", inst->wMemStartAddr);
    printf("BTPU I Addr: %d\n", inst->iMemStartAddr);
    printf("BTPU O Addr: %d\n", inst->oMemStartAddr);
    printf("M: %d, N: %d, K: %d\n", inst->mSize, inst->nSize, inst->kSize);
    printf("BTPU signCmp: %d\n", inst->signCmp);
    printf("\n/////////////////////////////////////////\n");
#endif
}

int main(int argc, char const *argv[]){
    
    // Initialize GPIOs
    GPIO0Dir->PORT_A_DIR.GPIO0 = OUTPUT; // GPIO0_PIN0 (LED0)


    int test_n = 0;
    const int B_M = 2;
    const int B_N = 3;
    const int B_K = 4;
    const uint32_t signCmp = 48;

    const int M = B_M * BINARY_FRAG_SIZE;
    const int N = B_N * BINARY_FRAG_SIZE;
    const int K = B_K * BINARY_FRAG_SIZE;


    BinaryMatrix_t A = (BinaryMatrix_t)malloc(M * (N / 32) * sizeof(uint32_t));
    BinaryMatrix_t W = (BinaryMatrix_t)malloc(N * (K / 32) * sizeof(uint32_t));
    BinaryMatrix_t O0;
    BinaryMatrix_t O1;

    // O0 = (BinaryMatrix_t)malloc(M * (K / 32) * sizeof(uint32_t));
    // O1 = (BinaryMatrix_t)malloc(M * (K / 32) * sizeof(uint32_t));
     if(argc >= M * (K / 32) * 4){
        O0 = (BinaryMatrix_t)argv;
    }else{
        O0 = NULL;
    }

    if(argc >= (M * (K / 32) * 4) * 2){
        O1 = (BinaryMatrix_t)(argv + M * (K / 32));
    }else{
        O1 = NULL;
    }


    Matrix_t result0;
    Matrix_t result1;

    if(argc >= M * K * 32 * 4){
        result0 = (Matrix_t)argv;
    }else{
        result0 = NULL;
    }

    if(argc >= (M * K * 32 * 4) * 2){
        result1 = (Matrix_t)(argv + M * K);
    }else{
        result1 = NULL;
    }
    // result = (Matrix_t)malloc(M * K * sizeof(uint32_t));
    // result = (Matrix_t) 1;

    // if(!A || !W || !O || !result){
    // if(!A || !W || !O0 || !O1 || !result0 || !result1){
    if(!A || !W ) {
        PRINTF_DBG("Memory allocation failed!\n");
        PRINTF_DBG("A = %p, W = %p, O0 = %p, O1 = %p, result0 = %p, result1 = %p\n", A, W, O0, O1, result0, result1);
        PRINTF_DBG("argv = %p\n", argv);
        while(1);
    }else{
        // PRINTF_DBG("Memory allocation successful!\n");
        // PRINTF_DBG("A = %p, W = %p, O0 = %p, O1 = %p, result0 = %p, result1 = %p\n", A, W, O0, O1, result0, result1);
    }


    for(int i = 0; i < M * (N / 32); ++i){
        A[i] = i + 1;
    }
    for(int i = 0; i < N * (K / 32); ++i){
        W[i] = i;
    }


    test_n = 1;
    // PRINTF_DBG("\nLoading BTPU fragments...\n");
    loadBinaryMatrixToFragments(A, BTPU0_IO0_MEMORY, M, N);
    loadBinaryMatrixToFragments(W, BTPU0_W_MEMORY, N, K);
    btpuSetBlocks(BTPU0RegFile, B_M, B_N, B_K);
    btpuSetAddrs(BTPU0RegFile, 0, 0, B_M * B_N);
    // PRINTF_DBG("\nStarting first multiplication...\n");
    btpuStartBinaryMatrixMul(BTPU0RegFile, signCmp, true, true, BTPU_USE_MEMORY_0_CONFIG);
    // printCreg(BTPU0RegFile);

    // PRINTF_DBG("Waiting for BTPU to finish...\n");
    btpuWaitBinaryMatrixMulWithCb(BTPU0RegFile, setBusy);
    // PRINTF_DBG("Storing results from BTPU...\n");
    storeFramentsToBinaryMatrix(BTPU0_IO1_MEMORY, O0, M, K);
    // PRINTF_DBG("BTPU finished!\n");

    // PRINTF_DBG("Loading new data to A...\n");
    //Loading new data to A
    for(int i = 0; i < M * (N / 32); ++i){
        A[i] = i + 2;
    }
    loadBinaryMatrixToFragments(A, BTPU0_IO1_MEMORY, M, N);
    // PRINTF_DBG("\nStarting second multiplication...\n");
    btpuSetAddrs(BTPU0RegFile, 0, 0, B_M * B_N);
    btpuStartBinaryMatrixMul(BTPU0RegFile, signCmp, true, true, BTPU_USE_MEMORY_1_CONFIG);
    // printCreg(BTPU0RegFile);

    // PRINTF_DBG("Waiting for BTPU to finish...\n");
    btpuWaitBinaryMatrixMulWithCb(BTPU0RegFile, setBusy);
    // PRINTF_DBG("Storing results from BTPU...\n");
    storeFramentsToBinaryMatrix(BTPU0_IO0_MEMORY, O1, M, K);
    // PRINTF_DBG("BTPU finished!\n");

    BTPU0RegFile->creg.reg.BRAM_PORT_SEL = BTPU_BRAM_PORT_SEL_EXT;


    free(A);
    free(W);
    // free(O0);
    // free(O1);


    while(1){
        // gpioToggle((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN0); // Toggle LED0
    }

}
