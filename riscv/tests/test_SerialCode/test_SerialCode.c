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

#define B_M 2
#define B_N 3
#define B_K 4
#define SIGN_CMP 48

#define M (B_M * BINARY_FRAG_SIZE)
#define N (B_N * BINARY_FRAG_SIZE)
#define K (B_K * BINARY_FRAG_SIZE)

const int A_SIZE =  (M * (N / 32) * 4);
const int W_SIZE = (N * (K / 32) * 4);
const int O_BIN_SIZE = (M * (K / 32) * 4);
const int O_SIZE = (M * K * 4);
const int TOTAL_SIZE = A_SIZE + W_SIZE + 2 * O_BIN_SIZE;

int WMemoryBlocksUsed = 0;
int IO0MemoryBlocksUsed = 0;
int IO1MemoryBlocksUsed = 0;


uint32_t results[30];

BinaryAcc_t acc;

void test_BlockMatMul(int testN){
    WMemoryBlocksUsed += 1;
    IO0MemoryBlocksUsed += 1;
    IO1MemoryBlocksUsed += 3;

    BinaryFragment_t fastSerial;
    BinaryFragment_t serial;
    BinaryFragment_t transposed;

    // Controlla l'allocazione della memoria
    if (IO0MemoryBlocksUsed > BTPU_MAX_BLOCK_COUNT || 
        WMemoryBlocksUsed > BTPU_MAX_BLOCK_COUNT || 
        IO1MemoryBlocksUsed > BTPU_MAX_BLOCK_COUNT) {
        PRINTF_DBG("[ERROR]: Memory allocation error: too many blocks used.\n");
        return;
    }

    //Popola le matrici A e W con valori di test
    for (int i = 0; i < BINARY_FRAG_SIZE; ++i){
        BTPU0_W_MEMORY[0][i] = i;
    }
    
    for (int i = 0; i < BINARY_FRAG_SIZE; ++i){
        BTPU0_IO0_MEMORY[0][i] = i + 1;
    }

    // Popola la matrice di output con zeri
    for (int i = 0; i < BINARY_FRAG_SIZE; ++i){
        BTPU0_IO1_MEMORY[0][i] = 0;
    }

    fillAccWithZero(acc);
    transposeBinaryFragment(BTPU0_W_MEMORY[0], transposed);
    fastBinaryBlockMatrixMul(BTPU0_IO0_MEMORY[0], transposed, acc, fastSerial, 30, true);
    
    fillAccWithZero(acc);
    binaryBlockMatrixMul(BTPU0_IO0_MEMORY[0], transposed, acc);
    binarizeMatrix((Matrix_t)acc, (BinaryMatrix_t)serial, 30, BINARY_FRAG_SIZE, BINARY_FRAG_SIZE);

    // Calcola il risultato con la BTPU
    btpuSetAddrs(BTPU0RegFile, WMemoryBlocksUsed - 1, IO0MemoryBlocksUsed - 1, IO1MemoryBlocksUsed - 1);
    btpuStartBinaryMatrixMul(BTPU0RegFile, 30, false, true, BTPU_USE_MEMORY_0_CONFIG);
    btpuWaitBinaryMatrixMul(BTPU0RegFile);

    int res = 1;
    int count = 0;
    int inTestN = 1;
    // Verifica il risultato fast con la BTPU
    for (int i = 0; i < BINARY_FRAG_SIZE; ++i){
        if (fastSerial[i] != BTPU0_IO1_MEMORY[2][i]){
            if(res) PRINTF_DBG("Test #%d-%d: FAILED -> fastSerial[%d] (fast serial) = 0x%08x, expected 0x%08x (BTPU)\n", testN, inTestN, i, fastSerial[i], BTPU0_IO1_MEMORY[2][i]);
            res = 0;
            count++; 
        }
    }
    if(!res){
        PRINTF_DBG("    %d more like this...\n", count);
    }else{
        PRINTF_DBG("Test #%d-%d: OK\n", testN, inTestN);
    }

    inTestN = 2;
    res = 1;
    count = 0;
    // Verifica il risultato con la BTPU
    for (int i = 0; i < BINARY_FRAG_SIZE; ++i){
        if (serial[i] != BTPU0_IO1_MEMORY[2][i]){
            if(res) PRINTF_DBG("Test #%d-%d: FAILED -> serial[%d] = 0x%08x, expected 0x%08x\n", testN, inTestN, i, serial[i], BTPU0_IO1_MEMORY[2][i]);
            res = 0;
            count++; 
        }
    }
    if(!res){
        PRINTF_DBG("    %d more like this...\n", count);
    }else{
        PRINTF_DBG("Test #%d-%d: OK\n", testN, inTestN);
    }

    uint32_t xnorResult = xnor32(BTPU0_IO0_MEMORY[0][0], BTPU0_W_MEMORY[0][0]);
    uint32_t popcountResult = popcount32(xnorResult);

    inTestN = 3;
    if( xnorResult != 0xFFFFFFFE) {
        PRINTF_DBG("Test #%d-%d: FAILED -> xnor32(0x%08x, 0x%08x) = 0x%08x, expected 0x%08x\n", testN, inTestN, BTPU0_IO0_MEMORY[0][0], BTPU0_W_MEMORY[0][0], xnorResult, 0xFFFFFFFE);
    } else {
        PRINTF_DBG("Test #%d-%d: OK\n", testN, inTestN);
    }

    inTestN = 4;
    if( popcountResult != 31) {
        PRINTF_DBG("Test #%d-%d: FAILED -> popcount32(0x%08x) = %d, expected %d\n", testN, inTestN, xnorResult, popcountResult, 31);
    } else {
        PRINTF_DBG("Test #%d-%d: OK\n", testN, inTestN);
    }

    inTestN = 5;
    if(acc[0][0] != 31) {
        PRINTF_DBG("Test #%d-%d: FAILED -> acc[0][0] = %d, expected %d\n", testN, inTestN, acc[0][0], 31);
    } else {
        PRINTF_DBG("Test #%d-%d: OK\n", testN, inTestN);
    }
}

bool test_xnor32(int testN){
    uint32_t a = 0; 
    uint32_t b = 0;
    uint32_t result;
    result = xnor32(a, b);
    results[testN - 1] = result;
    if( result != 0xFFFFFFFF){
        PRINTF_DBG("Test #%d: FAILED -> xnor32(%08X, %08X) = %08X, expected %08X\n", testN, a, b, result, 0xFFFFFFFF);
        return false;
    } else {
        PRINTF_DBG("Test #%d: OK\n", testN);
        return true;
    }
}

bool test_popcount(int testN){
    uint32_t x = 0xFFFFFFFF;
    int result = popcount32(x);
    results[testN - 1] = result;
    if(result != 32){
        PRINTF_DBG("Test #%d: FAILED -> popcount32(%08X) = %d, expected %d\n", testN, x, result, 32);
        return false;
    } else {
        PRINTF_DBG("Test #%d: OK\n", testN);
        return true;
    }
}

bool test_binaryMul(int testN){
    uint32_t a = 0;
    uint32_t b = 0;
    uint32_t result = binaryMul(a, b);
    results[testN - 1] = result;
    if(result != 32){
        PRINTF_DBG("Test #%d: FAILED -> binaryMul(%08X, %08X) = %08X, expected %08X\n", testN, a, b, result, 32);
        return false;
    } else {
        PRINTF_DBG("Test #%d: OK\n", testN);
        return true;
    }
}

void test_MatrixMul(int testN, uint32_t argc, uint8_t* argv) {
    BinaryMatrix_t aSerial = (BinaryMatrix_t)malloc(A_SIZE);
    BinaryMatrix_t wSerial = (BinaryMatrix_t)malloc(W_SIZE);
    BinaryMatrix_t oSerial = (BinaryMatrix_t)malloc(O_BIN_SIZE);
    BinaryMatrix_t oBTPU   = (BinaryMatrix_t)malloc(O_BIN_SIZE);

    if (!aSerial || !wSerial || !oSerial || !oBTPU) {
        PRINTF_DBG("Memory allocation failed.\n");
        while (1);
    }

    // Inizializza le matrici A e W con valori di test
    for (int i = 0; i < M * (N / 32); ++i){
        aSerial[i] = i + 1;
    }
    for (int i = 0; i < N * (K / 32); ++i){
        wSerial[i] = i;
    }
    // Inizializza la matrice di output con zeri
    for (int i = 0; i < M * (K / 32); ++i){
        oSerial[i] = 0;
        oBTPU  [i] = 0;
    }


    fastBinaryMatrixMul(aSerial, wSerial, oSerial, SIGN_CMP, M, N, K);

    // Calcola il risultato con la BTPU
    // Carica le matrici A e W nella memoria della BTPU
    loadBinaryMatrixToFragments(aSerial, BTPU0_IO0_MEMORY, M, N);
    loadBinaryMatrixToFragments(wSerial, BTPU0_W_MEMORY, N, K);
    // Configura la BTPU per la moltiplicazione di matrici
    btpuSetAddrs(BTPU0RegFile, 0, 0, 0);
    btpuSetBlocks(BTPU0RegFile, B_M, B_N, B_K);
    btpuStartBinaryMatrixMul(BTPU0RegFile, SIGN_CMP, true, true, BTPU_USE_MEMORY_0_CONFIG);
    // Attende il completamento della moltiplicazione
    btpuWaitBinaryMatrixMul(BTPU0RegFile);
    // Memorizza il risultato della BTPU nella matrice di output
    storeFramentsToBinaryMatrix(BTPU0_IO1_MEMORY, oBTPU, M, K);

    int res = 1;
    int count = 0;
    // Verifica il risultato fast con la BTPU
    for (int i = 0; i < M * (K / 32); ++i){
        if (oSerial[i] != oBTPU[i]){
            // if(res) PRINTF_DBG("Test #%d: FAILED -> oSerial[%d] = 0x%08x, expected 0x%08x\n", testN, i, oSerial[i], oBTPU[i]);
            if(res) PRINTF_DBG("Test #%d: FAILED -> oSerial[%d] = 0x%08x, expected 0x%08x\n", testN, i, oSerial[i], oBTPU[i]);
            res = 0;
            count++; 
        }
    }
    if(!res){
        PRINTF_DBG("    %d more like this...\n", count);
    }else{
        PRINTF_DBG("Test #%d: OK\n", testN);
    }
    
    testN++;
    if(oBTPU[4] == BTPU0_IO1_MEMORY[0][1]){
        PRINTF_DBG("Test #%d: OK\n", testN);
    } else {
        PRINTF_DBG("Test #%d: FAILED -> oBTPU[4] = 0x%08x, expected 0x%08x\n", testN, oBTPU[4], BTPU0_IO1_MEMORY[0][1]);
    }

    testN++;
    if(oSerial[4] == BTPU0_IO1_MEMORY[0][1]){
        PRINTF_DBG("Test #%d: OK\n", testN);
    } else {
        PRINTF_DBG("Test #%d: FAILED -> oSerial[4] = 0x%08x, expected 0x%08x\n", testN, oSerial[4], BTPU0_IO1_MEMORY[0][1]);
    }

    // Stampa le matrici per il debug
    #if !defined(SIMULATION) && defined(DEBUG)
        PRINTF_DBG("A matrix:\n");
        printIntBMatrixN(aSerial, 2, 2, M, N);
        PRINTF_DBG("W matrix:\n");
        printIntBMatrixN(wSerial, 2, 2, N, K);
        PRINTF_DBG("O matrix (Serial):\n");
        printIntBMatrixN(oSerial, 2, 2, M, K);
        PRINTF_DBG("O matrix (BTPU):\n");
        printIntBMatrixN(oBTPU, 2, 2, M, K);
    #endif
    memcpy(argv, oSerial, O_BIN_SIZE);
    memcpy(argv + O_BIN_SIZE, oBTPU, O_BIN_SIZE);
}


int main(int argc, char const *argv[]){

    int testN = 1;
    test_xnor32(testN);

    testN = 2;
    test_popcount(testN);

    testN = 3;
    test_binaryMul(testN);    

    #ifndef SIMULATION
        testN = 4;
        test_BlockMatMul(testN);

        testN = 5;
        test_MatrixMul(testN, argc, (uint8_t*)argv);

        BTPU0RegFile->creg.reg.BRAM_PORT_SEL = BTPU_BRAM_PORT_SEL_EXT; // Set BRAM port to external
    #endif

    while(1);

}
