#include <main.h>
#include <UART.h>
#include <GPIO.h>
#include <I2C.h>
#include <utilities.h>
#include <printf.h>

int main(int argc, char const *argv[]){

    printf("Hello World!\n%d\n", 1234);\
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN0 | PIN1 | PIN2 | PIN3, OUTPUT);

    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN4 | PIN5 | PIN6 | PIN7, INPUT);

    while(1){
        uint8_t val = *(uint8_t*)GPIO0_PORT_A_ADDR;
        printf("GPIOs: %02x\n", val);
        wait(0);
        gpioToggle((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN0 | PIN1 | PIN2 | PIN3);
    }

    return 0;
}
