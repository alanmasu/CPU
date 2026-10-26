#include <stdbool.h>
#include <stdint.h>

#ifndef __TEST_ALU_RESULTS_H_
#define __TEST_ALU_RESULTS_H_

#define ALU_RESULT_SIZE 21  // Numero di istruzioni testate nel programma assembly
#define MEM_RESULT_SIZE 16  // Numero di istruzioni testate nel programma assembly
#define MEMORY_RESULT_SIZE 32 // Numero di istruzioni testate nel programma assembly
#define JUMP_BRANCH_RESULT_SIZE 8


// Risultati attesi, da confrontare con quelli scritti in memoria
const int32_t ALU_EXPECTED_VALUES[ALU_RESULT_SIZE] = {
    0x12345000, // LUI
    0x4000100c, // AUIPC 
    15,         // ADDI
    1,          // SLTI
    0,          // SLTIU
    0b0110,     // XORI
    0b1111,     // ORI
    0b1000,     // ANDI
    8,          // SLLI
    1,          // SRLI
    -2,         // SRAI
    15,         // ADD
    5,          // SUB
    8,          // SLL
    1,          // SLT
    0,          // SLTU
    0b0110,     // XOR
    0b1111,     // OR
    0b1000,     // AND
    1,          // SRL
    -2          // SRA
};

const uint32_t MEMORY_EXPECTED_VALUES[MEMORY_RESULT_SIZE] = {
    //SW
    0x10B2ACF8,
    0xB2ACF800,
    0xACF80000,
    0xF8000000,
    //SH
    0x0000ACF8,
    0x00ACF800,
    0xACF80000,
    0xF8000000,
    //SB
    0x000000F8,
    0x0000F800,
    0x00F80000,
    0xF8000000,
    //LW
    0x10B2ACF8,
    0xFFB2ACF8,
    0xFFFFACF8,
    0xFFFFFFF8,
    //LH
    0xFFFFACF8,
    0xFFFFACF8,
    0xFFFFACF8,
    0xFFFFFFF8,
    //LHU
    0x0000ACF8,
    0x0000ACF8,
    0x0000ACF8,
    0x000000F8,
    //LB
    0xFFFFFFF8,
    0xFFFFFFF8,
    0xFFFFFFF8,
    0xFFFFFFF8,
    //LBU
    0x000000F8,
    0x000000F8,
    0x000000F8,
    0x000000F8
};

char* JUMP_BRANCH_TEST_NAMES [JUMP_BRANCH_RESULT_SIZE] = {
    "JAL",
    "JALR",
    "BEQ",
    "BNE",
    "BLT",
    "BGE",
    "BLTU",
    "BGEU"
};

bool check_results(const int32_t *results, const int32_t *expected_results ,size_t size) {
    int failed = 0;
    for (int i = 0; i < size; i++) {
        if (results[i] != expected_results[i]) {
            printf("Test #%d: FAILED -> expected: 0x%x, was 0x%x\n",
                   i+1, expected_results[i], results[i]);
            failed++;
        }else{
            printf("Test #%d: OK\n", i+1);
        }
    }
    return failed == 0;
}


#endif // __TEST_ALU_RESULTS_H_
