#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include <stdint.h>
#include <stdbool.h>

#define DELAY_COUNT 1250000

#define CREG_BASE_ADDR 0x40004000

typedef struct  __attribute__((packed)) CREG_t{
    uint32_t run : 1;
    uint32_t reset : 1;
    uint32_t alive : 1;
    uint32_t reserved : 29;
} CREG_t;

typedef struct  __attribute__((packed)) CREG_IO_t{
    unsigned btnUP : 1;
    unsigned btnDOWN : 1;
    unsigned btnLEFT : 1;
    unsigned btnRIGHT : 1;
    unsigned sw0 : 1;
    unsigned sw1 : 1;
    unsigned reserved : 18;
    unsigned led0 : 1;
    unsigned led1 : 1;
    unsigned led2 : 1;
    unsigned reserved2 : 4;
}CREG_IO_t;

typedef struct  __attribute__((packed)) ControlRegister_t{
    CREG_t creg;
    uint32_t programCounter;
    uint32_t state;
    uint32_t instruction;
    CREG_IO_t IO;
    uint32_t oledCRT;
    uint32_t oledData;
} ControlRegister_t;

extern volatile ControlRegister_t* controlRegister;

#ifdef MY_RISCV
// int strcmp(const char* str1, const char* str2);

void wait(uint32_t time);
#endif



#endif
