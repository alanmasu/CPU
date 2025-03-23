#ifndef __I2C_H__
#define __I2C_H__

#include <stdint.h>
#include <stdbool.h>

#define I2C0_BASE_ADDR 0x40020010

typedef struct __attribute__((packed))I2CCReg_t{
    unsigned int START : 1;
    unsigned int RW_N  : 1;
    unsigned int BUSY  : 1;
    unsigned int ERROR : 1;
    unsigned int reserved : 28;
} I2CCreg_t;

typedef struct __attribute__((packed))I2CRegFile_t{
    I2CCreg_t controlReg;
    uint32_t  slaveAddr;
    uint32_t  rData;
    uint32_t  wData;
    uint32_t  lenIn;
    uint32_t  lenOut;
}I2CRegFile_t;

typedef enum I2CStatus_t{
    I2C_OK,
    I2C_READY,
    I2C_BUSY,
    I2C_ERROR, 
    I2C_FULL,
    I2C_NOT_FOUND
}I2CStatus_t;


I2CStatus_t i2cSetupRead(uint8_t slaveAddr, uint8_t len);
I2CStatus_t i2cSetupWrite(uint8_t slaveAddr, uint8_t* data, uint8_t len);
I2CStatus_t i2cStartTransaction();
void i2cWaitTransaction();
I2CStatus_t i2cGetReaded(uint8_t* data, uint8_t* len);




extern volatile I2CRegFile_t* I2C0RegFile;


#endif // __I2C_H__