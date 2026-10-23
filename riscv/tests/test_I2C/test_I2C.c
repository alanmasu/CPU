#include <I2C.h>
#include <UART.h>

#include <stdio.h>

int main(int argc, char const *argv[]){
    printf("Hello World from test_I2C!\n");
    I2C0RegFile->controlReg.START = 1;
    return 0;
}

