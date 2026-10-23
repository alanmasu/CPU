#include <main.h>
#include <stdint.h>
#include <stdbool.h>
#include <UART.h>
#include <GPIO.h>
#include <I2C.h>
#include <OLED.h>
#include <utilities.h>
#include <stdio.h>

static char prova = 20;

char intGlobalNI;

#define PB200_221_ADDR 0x4B


void testI2CRead(){
    uint8_t lenReaded = 0;
    lenReaded = I2C0RegFile->lenOut;
            
    OLED0Data->value = I2C0RegFile->rData;
    OLED0Data->data[3] = lenReaded;
}

void printI2CState( I2CStatus_t i2cState, const char* message){
    switch (i2cState){
        case I2C_OK:
            UARTPrint("I2C OK ");
            break;
        case I2C_NOT_FOUND:
            UARTPrint("I2C Not Found ");
            break;
        case I2C_BUSY:
            UARTPrint("I2C Busy ");
            break;
        case I2C_READY:
            UARTPrint("I2C Ready ");
            break;
        case I2C_ERROR: 
            UARTPrint("I2C Error ");
            break;
        case I2C_FULL:
            UARTPrint("I2C Full ");
            break;
        default:
            UARTPrint("I2C Unknown ");
            break;
    }
    UARTPrint(message);
    UARTPrint("\n");
}

int main(int argc, char const *argv[]){
    UARTWrite(&prova, sizeof(int));
    UARTWrite(&intGlobalNI, sizeof(int));

    I2CStatus_t i2cState;
    I2CStatus_t i2cState_testC;
    I2CStatus_t i2cState_testG;

    uint8_t* ptr = (uint8_t*)&i2cState;
    UARTWrite((char*)&i2cState, 4);

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

    //TEST 0a & 0b: Testing Invalid address
    uint32_t test = 0x2034;
    i2cState = i2cSetupWrite(0x20,(uint8_t*) &test, 2);
    printI2CState(i2cState, "@0a");
    if(i2cState == I2C_READY){
        UARTPrint("\tSending 0x2034\n");
        i2cStartTransaction();
    }

    i2cState = i2cWaitTransaction();
    printI2CState(i2cState, "@0b");
    wait(0);
    wait(0);

    //TEST 0c & 0d: Testing Valid address but reading out of the registers range (the first is valid, 2nd, 3rd and 4th are invalid)
    test = 0x2FFF44;
    i2cState = i2cSetupWrite(PB200_221_ADDR, (uint8_t*) &test, 3);
    i2cState_testC = i2cStartTransaction();

    i2cSetupRead(PB200_221_ADDR, 4);
    i2cStartTransaction();
    i2cState = i2cWaitTransaction();
    printI2CState(i2cState_testC, "@0c");
    printI2CState(i2cState, "@0d");

    //TEST 0e & 0f: Testing Valid address and writing out of the registers range (the first is valid, 2nd, 3rd and 4th are invalid)
    test = 0x2FFF55;
    i2cState = i2cSetupWrite(PB200_221_ADDR, (uint8_t*) &test, 3);
    if(i2cState == I2C_READY) *buff = 0x06;
    // printI2CState(i2cState, "@0e");
    i2cStartTransaction();
    i2cState_testG = i2cWaitTransaction();
    

    test = 0xF3F2F1F0;
    i2cSetupWrite(PB200_221_ADDR, (uint8_t*) &test, 4);
    i2cStartTransaction();
    i2cState = i2cWaitTransaction();
    printI2CState(i2cState_testG, "@0f");
    printI2CState(i2cState, "@0g");


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
            // UARTPrint("I2C Ready, sending 0x00\n");
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
            // UARTPrint("I2C Ready, reading 2 bytes\n");
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
        *((uint32_t*)data) = *((uint32_t*)data)/ 128;
        
        OLED0Data->value = *((uint32_t*)data);
        OLED0Data->data[3] = lenReaded;
        ///// END OLD CODE /////

        printf("Temperatura letta: %d C\n", *((uint32_t*)data));
        
        wait(0);
        // wait(0);

        *buff = 0x05;

        wait(0);
        // wait(0);
    }

    return 0;
}
