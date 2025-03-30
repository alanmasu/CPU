#include <main.h>
#include <UART.h>
#include <GPIO.h>
#include <I2C.h>
#include <utilities.h>
//#include <printf.h>

#define PB200_221_ADDR 0x4B

typedef union DisplayData_t{
    uint8_t data[4];
    uint32_t value;
} DisplayData_t;

DisplayData_t* DisplayData = (DisplayData_t*)DISPLAY_BASE_ADDR;

void testI2CRead(){
    uint8_t lenReaded = 0;
    lenReaded = I2C0RegFile->lenOut;
            
    DisplayData->value = I2C0RegFile->rData;
    DisplayData->data[3] = lenReaded;
}


int main(int argc, char const *argv[]){
    I2CStatus_t i2cState;

    // printf("Hello World!\n%d\n", 1234);

    GPIO0Dir->PORT_A_DIR.GPIO0 = OUTPUT;
    GPIO0Data->PORT_A_DATA.GPIO0 = 0;

    GPIO0Dir->PORT_A_DIR.GPIO1 = OUTPUT;
    GPIO0Data->PORT_A_DATA.GPIO1 = 0;

    GPIO0Dir->PORT_A_DIR.GPIO2 = OUTPUT;
    GPIO0Data->PORT_A_DATA.GPIO2 = 0;

    GPIO0Dir->PORT_A_DIR.GPIO3 = OUTPUT;
    GPIO0Data->PORT_A_DATA.GPIO3 = 0;

    uint8_t* buff = (uint8_t*)&(GPIO0Data->PORT_A_DATA);

    UARTPrint("\nStarting the program...[FROM RISC-V]\nPlease SET the second switch to 1 (SWITCH[1]).\n\n");

    wait(0);

    uint32_t test = 0x2034;
    i2cState = i2cSetupWrite(0x20,(uint8_t*) &test, 2);
    if(i2cState == I2C_READY){
        UARTPrint("I2C Ready, sending 0x2034\n");
        i2cState = i2cStartTransaction();
    }else if(i2cState == I2C_BUSY){
        UARTPrint("I2C Busy @0a\n");
    }else if(i2cState == I2C_ERROR){
        UARTPrint("I2C Error @0a\n");
    }else if(i2cState == I2C_FULL){
        UARTPrint("I2C Full @0a\n");
    }
    *buff = 0xFF;
    i2cState = i2cWaitTransaction();

    wait(0);
    wait(0);

    switch (i2cState){
        case I2C_OK:
            UARTPrint("I2C OK @0b\n");
            break;
        case I2C_NOT_FOUND:
            UARTPrint("I2C Not Found @0b\n");
            break;
        case I2C_BUSY:
            UARTPrint("I2C Busy @0b\n");
            break;
        case I2C_READY:
            UARTPrint("I2C Ready @0b\n");
            break;
        case I2C_ERROR: 
            UARTPrint("I2C Error @0b\n");
            break;
        case I2C_FULL:
            UARTPrint("I2C Full @0b\n");
            break;
        default:
            UARTPrint("I2C Unknown @0b\n");
            break;
    }

    //Setting UP the resolution
    wait(0);
    uint8_t data[4];
    *data = 0x03;
    i2cState = i2cSetupWrite(PB200_221_ADDR, data, 1);
    if(i2cState == I2C_READY){
        UARTPrint("I2C Ready, sending 0x03\n");
        i2cState = i2cStartTransaction();
    }else if(i2cState == I2C_BUSY){
        UARTPrint("I2C Busy @1\n");
    }else if(i2cState == I2C_ERROR){
        UARTPrint("I2C Error @1\n");
    }else if(i2cState == I2C_FULL){
        UARTPrint("I2C Full @1\n");
    }
    i2cWaitTransaction();

    *buff = 0x01;

    wait(0);
    // wait(0);

    *data = 0x80;
    i2cState = i2cSetupWrite(PB200_221_ADDR, data, 1);
    if(i2cState == I2C_READY){
        UARTPrint("I2C Ready, sending 0x80\n");
        i2cState = i2cStartTransaction();
    }else if(i2cState == I2C_BUSY){
        UARTPrint("I2C Busy @2\n");
    }else if(i2cState == I2C_ERROR){
        UARTPrint("I2C Error @2\n");
    }else if(i2cState == I2C_FULL){
        UARTPrint("I2C Full @2\n");
    }
    i2cWaitTransaction();

    *buff = 0x02;

    wait(0);
    // wait(0);

    //STARTING THE CONVERSION
    while(1){
        *data = 0x00;
        i2cState = i2cSetupWrite(PB200_221_ADDR, data, 1);
        if(i2cState == I2C_READY){
            UARTPrint("I2C Ready, sending 0x00\n");
            i2cState = i2cStartTransaction();
        }else if(i2cState == I2C_BUSY){
            UARTPrint("I2C Busy @3\n");
        }else if(i2cState == I2C_ERROR){
            UARTPrint("I2C Error @3\n");
        }else if(i2cState == I2C_FULL){
            UARTPrint("I2C Full @3\n");
        }

        i2cWaitTransaction();

        *buff = 0x03;

        wait(0);


        i2cState = i2cSetupRead(PB200_221_ADDR, 2);
        if(i2cState == I2C_READY){
            UARTPrint("I2C Ready, reading 2 bytes\n");
            i2cState = i2cStartTransaction();
        }else if(i2cState == I2C_BUSY){
            UARTPrint("I2C Busy @4\n");
        }else if(i2cState == I2C_ERROR){
            UARTPrint("I2C Error @4\n");
        }else if(i2cState == I2C_FULL){
            UARTPrint("I2C Full @4\n");
        }
        i2cWaitTransaction();

        *buff = 0x04;

        wait(0);
        // wait(0);

        ///// OLD CODE /////
        uint8_t lenReaded = 0;
        i2cState = i2cGetReaded(data, &lenReaded);
        
        DisplayData->value = *((uint32_t*)data);
        DisplayData->data[3] = lenReaded;
        ///// END OLD CODE /////

        // testI2CRead();
        
        wait(0);
        // wait(0);

        *buff = 0x05;

        wait(0);
        // wait(0);
    }

    return 0;
}
