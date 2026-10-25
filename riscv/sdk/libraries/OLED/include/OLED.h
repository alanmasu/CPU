#ifndef __OLED_H__
#define __OLED_H__

#include <stdint.h>
#include <stdbool.h>

#define OLED_CREG_BASE 0x40004014
#define OLED_DATA_BASE 0x40004018

typedef struct __attribute__((packed)) OLEDRegField_t {
    unsigned select : 2;    
    unsigned reserved : 30;
} OLEDRegField_t;

typedef union {
    volatile uint32_t value;        ///< Raw value of the control register
    volatile OLEDRegField_t reg;    ///< Bit fields of the control register
} OLEDReg_t;

typedef union {
    volatile uint32_t value;         ///< Data register for OLED
    volatile uint8_t data[4];        ///< Data bytes for OLED
} OLEDData_t;

extern OLEDReg_t* OLED0CReg;
extern OLEDData_t* OLED0Data;

#endif // __OLED_H__
