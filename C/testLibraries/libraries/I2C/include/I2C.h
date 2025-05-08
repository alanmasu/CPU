/**!
 * @file    I2C.h
 * @brief   I2C Library
 * 
 * @details This library is used to communicate with I2C devices on the RISC-V, it uses the I2C0 peripheral.
 * 
 * @author  Alan Masutti (@alanmasu) 
 * @date    30/03/2025
*/
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

/**!
 * @brief Setup the I2C to read from a slave device
 * 
 * @param slaveAddr The address of the slave device
 * @param len The number of bytes to read
 * @return I2CStatus_t The status of the I2C
*/

I2CStatus_t i2cSetupRead(uint8_t slaveAddr, uint8_t len);

/**!
 * @brief Setup the I2C to write to a slave device
 * 
 * @param slaveAddr The address of the slave device
 * @param[in] data The data to write
 * @param len The number of bytes to write
 * @return I2CStatus_t The status of the I2C
*/
I2CStatus_t i2cSetupWrite(uint8_t slaveAddr, const uint8_t* data, uint8_t len);

/**!
 * @brief Start the I2C transaction
 * 
 * @return I2CStatus_t The status of the I2C
*/
I2CStatus_t i2cStartTransaction();

/**!
 * @brief Wait for the I2C transaction to finish
 * 
 * @return The state after the transaction
*/
I2CStatus_t i2cWaitTransaction();

/**!
 * @brief Get the readed data from the I2C
 * 
 * @param[out] data The data readed
 * @param[out] len The number of bytes readed
 * @return I2CStatus_t The status of the I2C
*/
I2CStatus_t i2cGetReaded(uint8_t* data, uint8_t* len);



/**!
 * @brief The I2C register file
*/
extern volatile I2CRegFile_t* I2C0RegFile;


#endif // __I2C_H__