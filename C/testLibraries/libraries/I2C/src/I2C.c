#include <I2C.h>

#include <stdint.h>
#include <stdbool.h>

volatile I2CRegFile_t* I2C0RegFile = (I2CRegFile_t*)I2C0_BASE_ADDR;

I2CStatus_t i2cSetupRead(uint8_t slaveAddr, uint8_t len){
    if(len > 4){
        return I2C_FULL;
    }
    if(I2C0RegFile->controlReg.BUSY){
        return I2C_BUSY;
    }
    I2C0RegFile->slaveAddr = slaveAddr;
    I2C0RegFile->lenIn = len;
    I2C0RegFile->controlReg.RW_N = 1;
    return I2C_READY;
}

I2CStatus_t i2cSetupWrite(uint8_t slaveAddr, uint8_t* data, uint8_t len){
    if(len > 4){
        return I2C_FULL;
    }
    if(I2C0RegFile->controlReg.BUSY == 1){
        return I2C_BUSY;
    }
    I2C0RegFile->slaveAddr = slaveAddr;
    I2C0RegFile->lenIn = len;
    I2C0RegFile->controlReg.RW_N = 0;
    for(int i = 0; i < len; ++i){
        I2C0RegFile->wData = data[i];
    }

    return I2C_READY;
}

I2CStatus_t i2cStartTransaction(){
    if(I2C0RegFile->controlReg.BUSY){
        return I2C_BUSY;
    }
    I2C0RegFile->controlReg.START = 1;
    return I2C_OK;
}

__attribute__((optimize("O0")))
void i2cWaitTransaction(){
    while(I2C0RegFile->controlReg.BUSY){
        // Do nothing
    }
}


I2CStatus_t i2cGetReaded(uint8_t* data, uint8_t* len){
    if(I2C0RegFile->controlReg.BUSY){
        return I2C_BUSY;
    }
    if(I2C0RegFile->controlReg.ERROR){
        return I2C_ERROR;
    }
    if(I2C0RegFile->lenOut == 1){ // Only address
        return I2C_NOT_FOUND;
    }

    *len = I2C0RegFile->lenOut;
    uint8_t* tmp = (uint8_t*)&I2C0RegFile->rData + I2C0RegFile->lenOut - 1;
    for(int i = 0; i < *len; ++i){
        *data = *tmp;
        tmp--;
        data++;
    }
    return I2C_OK;
}