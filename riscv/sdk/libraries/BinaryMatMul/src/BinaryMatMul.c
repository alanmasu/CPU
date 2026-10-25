#include "BinaryMatMul.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

BTPURegFile_t* BTPU0RegFile = (BTPURegFile_t*)BTPU_CREG_BASE;
BinaryFragment_t*   BTPU0_W_MEMORY = (BinaryFragment_t*)  BTPU_W_MEMORY_BASE;
BinaryFragment_t* BTPU0_IO0_MEMORY = (BinaryFragment_t*)BTPU_IO0_MEMORY_BASE;
BinaryFragment_t* BTPU0_IO1_MEMORY = (BinaryFragment_t*)BTPU_IO1_MEMORY_BASE;

uint8_t getBit(const BinaryMatrix_t mat, uint32_t row, uint32_t col, uint32_t N) {
    int bitIndex = row * N + col;
    int wordIndex = bitIndex / 32;
    int bitPos = bitIndex % 32;
    int bitShift = 31 - bitPos;
    uint8_t val = (mat[wordIndex] >> bitShift) & 1;
    return val;
}


void setBit(BinaryMatrix_t mat, uint32_t row, uint32_t col, uint8_t value, uint32_t N) {
    int bitIndex = row * N + col;
    int wordIndex = bitIndex / 32;
    int bitPos = bitIndex % 32;
    int bitShift = 31 - bitPos;
    if (value){
        mat[wordIndex] |= (1u << bitShift);
    }else{
        mat[wordIndex] &= ~(1u << bitShift);
    }
}

void transposeBinaryMatrix(const BinaryMatrix_t input, BinaryMatrix_t output, const uint32_t M, const uint32_t N) {
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            int bit = getBit(input, i, j, N);
            setBit(output, j, i, bit, N);  // Trasposizione logica
        }
    }
}

void transposeBinaryFragment(BinaryFragment_t input, BinaryFragment_t output) {
    for (int i = 0; i < BINARY_FRAG_SIZE; i++) {
        for (int j = 0; j < BINARY_FRAG_SIZE; j++) {
            int bit = getBit(input, i, j, BINARY_FRAG_SIZE);
            setBit(output, j, i, bit, BINARY_FRAG_SIZE);  // Trasposizione logica
        }
    }
}

int popcount32(uint32_t x) {
    x = x - ((x >> 1) & 0x55555555);                    // put count of each 2 bits into those 2 bits
    x = (x & 0x33333333) + ((x >> 2) & 0x33333333);     // put count of each 4 bits into those 4 bits
    x = (x + (x >> 4)) & 0x0F0F0F0F;                    // put count of each 8 bits into those 8 bits
    x = x + (x >> 8);                                   // put count of each 16 bits into their lowest 8 bits
    x = x + (x >> 16);                                  // put count of each 32 bits into lowest 8 bits
    return x & 0x0000003F;
}

uint32_t xnor32(const uint32_t a, const uint32_t b) {
    return ~(a ^ b);
}

uint32_t binaryMul(const uint32_t a, const uint32_t b) {
    uint32_t result;
    result = xnor32(a, b);
    result = popcount32(result);
    return result; 
}

void binaryBlockMatrixMul(const BinaryFragment_t a, const BinaryFragment_t b, BinaryAcc_t acc) {
    for (int row = 0; row < BINARY_FRAG_SIZE; ++row) {
        for (int col = 0; col < BINARY_FRAG_SIZE; ++col) {
            acc[row][col] += binaryMul(a[row], b[col]);
        }
    }
}

void fastBinaryBlockMatrixMul(const BinaryFragment_t a, const BinaryFragment_t b, BinaryAcc_t acc, BinaryFragment_t c, uint32_t signCmp, bool store) {
    for (int row = 0; row < BINARY_FRAG_SIZE; ++row) {
        for (int col = 0; col < BINARY_FRAG_SIZE; ++col) {
        #ifndef BTPU_SKIP_MATH
            acc[row][col] += binaryMul(a[row], b[col]);
            if (store){
                // Binarizza il risultato e lo memorizza in c
                if (acc[row][col] > signCmp) {
                    setBit(c, row, col, 1, BINARY_FRAG_SIZE);
                } else {
                    setBit(c, row, col, 0, BINARY_FRAG_SIZE);
                }
            }
        #else
            // Profiling only: keep the loop, skip the computation
            __asm__("nop");
        #endif
        }
    }
}


void loadFragment(BinaryFragment_t frag, const BinaryMatrix_t mat, uint32_t blockRow, uint32_t blockCol, uint32_t n) {
    const int cols = n / 32;
    int blockRowOffset = blockRow * cols * BINARY_FRAG_SIZE;
    int blockColOffset = blockCol;
    int wordRow = blockRowOffset + blockColOffset;
    for (int i = 0; i < BINARY_FRAG_SIZE; ++i) {
        frag[i] = mat[wordRow];
        wordRow += cols;
    }
    // printf("\n");
}    

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

void storeAcc(const BinaryAcc_t acc, Matrix_t mat, uint32_t blockRow, uint32_t blockCol, uint32_t n) {
    int blockRowOffset = blockRow * BINARY_FRAG_SIZE * n;
    int blockColOffset = blockCol * BINARY_FRAG_SIZE;
    for (int row = 0; row < BINARY_FRAG_SIZE; ++row) {
        for (int col = 0; col < BINARY_FRAG_SIZE; ++col) {
            mat[blockRowOffset + row * n + blockColOffset + col] = acc[row][col];
        }
    }
}

void fillAccWithZero(BinaryAcc_t acc) {
    for(int row = 0; row < BINARY_FRAG_SIZE; ++row){
        for(int col = 0; col < BINARY_FRAG_SIZE; ++col){
            acc[row][col] = 0;
        }
    }
}

void binaryMatrixMul(const BinaryMatrix_t a, const BinaryMatrix_t b, Matrix_t result, const int m, const int n, const int k) {
    uint32_t blockM = m / BINARY_FRAG_SIZE;
    uint32_t blockN = n / BINARY_FRAG_SIZE;
    uint32_t blockK = k / BINARY_FRAG_SIZE;
    BinaryFragment_t a_frag;
    BinaryFragment_t b_frag;
    BinaryFragment_t b_transposed;
    BinaryAcc_t acc;
    for(int blockRow = 0; blockRow < blockM; ++blockRow){
        for (int blockCol = 0; blockCol < blockK; ++blockCol) {
            fillAccWithZero(acc);  
            for (int i = 0; i < blockN; ++i) {
                loadFragment(a_frag, a, blockRow, i, n);
                loadFragment(b_frag, b, i, blockCol, k);
                transposeBinaryFragment(b_frag, b_transposed);
                binaryBlockMatrixMul(a_frag, b_transposed, acc);
            }
            storeAcc(acc, result, blockRow, blockCol, k);
        }
    }
}

void fastBinaryMatrixMul(const BinaryMatrix_t a, const BinaryMatrix_t b, BinaryMatrix_t c, uint32_t signCmp, const int m, const int n, const int k){
    uint32_t blockM = m / BINARY_FRAG_SIZE;
    uint32_t blockN = n / BINARY_FRAG_SIZE;
    uint32_t blockK = k / BINARY_FRAG_SIZE;
    BinaryFragment_t a_frag;
    BinaryFragment_t b_frag;
    BinaryFragment_t b_transposed;
    BinaryFragment_t c_frag;
    BinaryAcc_t acc;
    for(int blockRow = 0; blockRow < blockM; ++blockRow){
        for (int blockCol = 0; blockCol < blockK; ++blockCol) {
            fillAccWithZero(acc);  
            for (int i = 0; i < blockN; ++i) {
                loadFragment(a_frag, a, blockRow, i, n);
                loadFragment(b_frag, b, i, blockCol, k);
            #ifndef BTPU_SKIP_TRANSPOSE
                transposeBinaryFragment(b_frag, b_transposed);
            #endif
                fastBinaryBlockMatrixMul(a_frag, b_transposed, acc, c_frag, signCmp, i == blockN - 1);
            }
            storeFragment(c_frag, c, blockRow, blockCol, k);
        }
    }
}

void binarizeMatrix(Matrix_t mat, BinaryMatrix_t bMat, uint32_t signCmp, uint32_t m, uint32_t n){
    for (int i = 0; i < m; ++i){
        for (int j = 0; j < n; ++j){
            setBit(bMat, i, j, mat[i * n + j] > signCmp, n);
        }
    }
}

void printIntBMatrixN(BinaryMatrix_t mat, uint32_t r, uint32_t c, const uint32_t M, const uint32_t N){
    int cols = N / 32;
    if (c > cols){
        c = cols;
    }
    if (r > M){
        r = M;
    }

    for (int i = 0; i < r; ++i){
        for (int j = 0; j < c; ++j){
            printf("%03d ", *(mat + i * cols + j));
        }
        printf("\n");
    }
}

void printBMatrixN(BinaryMatrix_t mat, uint32_t r, uint32_t c, const uint32_t M, const uint32_t N){
    if (c > N){
        c = N;
    }
    if (r > M){
        r = M;
    }
    for(int row = 0; row < r; ++row){
        for(int col = 0; col < c; ++col){
            uint8_t bit = getBit(mat, row, col, N);
            printf("%d ", bit);
        }
        printf("\n");
    }
}

void printIntFragmentN(BinaryFragment_t frag, uint32_t rows){
    if (rows > BINARY_FRAG_SIZE){
        rows = BINARY_FRAG_SIZE;
    }
    for (int i = 0; i < rows; ++i){
        printf("%03d\n", frag[i]);
    }
    printf("\n");
}

void printIntMatrixN(Matrix_t mat, uint32_t r, uint32_t c, const uint32_t M, const uint32_t N){
    if (c > N){
        c = N;
    }
    if (r > M){
        r = N;
    }

    for (int i = 0; i < r; ++i){
        for (int j = 0; j < c; ++j){
            printf("%03d ", *(mat + i * N + j));
        }
        printf("\n");
    }
}

void loadBinaryMatrixToFragments(const BinaryMatrix_t mat, BinaryFragment_t dest[], const uint32_t M, const uint32_t N){
    int blockRows  = M / BINARY_FRAG_SIZE;
    int blockCols  = N / BINARY_FRAG_SIZE;
    int fragmentN = 0;
    for (int blockRow = 0; blockRow < blockRows; ++blockRow) {
        for (int blockCol = 0; blockCol < blockCols; ++blockCol) {
            loadFragment(dest[fragmentN++], mat, blockRow, blockCol, N);
        }
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

void btpuSetBlocks(BTPURegFile_t* inst, const uint32_t m, const uint32_t n, const uint32_t k){
    // inst->mSize = m;
    // inst->nSize = n;
    // inst->kSize = k;
    __asm__(
        "sw a1, 16(a0)\n\t"
        "sw a2, 20(a0)\n\t"
        "sw a3, 24(a0)\n\t"
    );
    // printf("[DEBUG] btpuSetBlocks called whit: M = %d, N = %d, K = %d\n", m, n, k);
    // printf("[DEBUG] inst:\n");
    // printf("     mSize: %d\n", inst->mSize);
    // printf("     nSize: %d\n", inst->nSize);
    // printf("     kSize: %d\n", inst->kSize);
    
}

void btpuSetAddrs(BTPURegFile_t* inst, const uint32_t wMemStartAddr, const uint32_t iMemStartAddr, const uint32_t oMemStartAddr){
    inst->wMemStartAddr = wMemStartAddr;
    inst->iMemStartAddr = iMemStartAddr;
    inst->oMemStartAddr = oMemStartAddr;
}

bool btpuStartBinaryMatrixMul(BTPURegFile_t* inst, const uint32_t signCmp, bool isBatched, bool clearAcc, uint8_t outputMemorySelect){
    if(inst->creg.reg.BUSY || inst->creg.reg.ERROR){
        return false; // BTPU is busy
    }
    inst->creg.reg.BATCHED_MUL = isBatched; // Set the batched mode
    inst->creg.reg.OMEM_SEL = outputMemorySelect; // Set the output memory select
    inst->signCmp = signCmp; // Set the sign comparison value
    inst->creg.reg.ACC_CLEAR = clearAcc; // Set the accumulator clear bit
    inst->creg.reg.START = 1; // Start the BTPU
    return true; // BTPU started successfully

}

__attribute__((optimize("O3")))
bool btpuWaitBinaryMatrixMul(BTPURegFile_t* inst){
    while(inst->creg.reg.BUSY){
        // Wait for the BTPU to finish
    }
    return !inst->creg.reg.ERROR; 
}

bool btpuWaitBinaryMatrixMulWithCb(BTPURegFile_t* inst, BTPUCallBackFunct_t funct){
    while(inst->creg.reg.BUSY){
        if(funct != NULL){
            funct(); // Call the callback function if provided
        }
    }
    return !inst->creg.reg.ERROR;
}