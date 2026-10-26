#ifndef __RISC_PROGRAMMING_H__
#define __RISC_PROGRAMMING_H__

#include <stdint.h>

#define RISC_RAM_BASE 		0x40010000
#define RISC_RAM_END  		0x4001FFFF

#define RISC_INSTR_BASE 	0x40000000
#define RISC_INSTR_END		0X40003FFF

#define RISC_CONTROL_REG    0x40004000

#define PROGMEM_SIZE 16384
#define DATAMEM_SIZE 8192

// Control Register Definitions
#define CPU_RESET 0b00;
#define CPU_STOP  0b10;
#define CPU_RUN   0b11;

#define DELAY_COUNT 10000000

extern uint32_t* riscvRam;

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
    unsigned reserved : 20;
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

extern uint8_t WriteVerbose;

/**!
 *
 * @brief Clear Program Memory
 * @details Clear the program memory by setting all values to 0
 *
 * @param programMemory [in] - The memory to clear
 * @param PROGMEM_SIZE [in] - The size of the memory
*/
void cleanMemory(uint32_t* mem, const uint32_t mem_size);

/**!
 * @brief Write a program to the program memory
 * @details Copy mem_size bytes of the program, as 32-bit words, to the address passed as argument
 *
 * @param program [in] - The program to write
 * @param mem [in] - The memory to write the program to
 * @param mem_size [in] - The size of the program in bytes (<prefix>_TEXT_SIZE of the exported header)
 *
*/
void writeProgramMemory(const uint32_t* program, uint32_t* mem , const uint32_t mem_size);


/**!
 * @brief Write data to the data memory
 * @details Write the data to the memory passed as argument
 *
 * @param data [in] - The data to write
 * @param mem [in] - The memory to write the data to
 * @param mem_size [in] - The size of the memory
*/
void writeDataMemory(const uint8_t* data, uint8_t* mem, const uint32_t mem_size);

/**!
 * @brief Wait a certain amount of time with a busy loop
 *
 * @param count [in] - The amount of time to wait - If 0, wait for a DELAY_COUNT cycles
 * @return void
*/

void wait(uint32_t count);

#endif // __RISC_PROGRAMMING_H__
