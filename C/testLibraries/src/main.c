#include <main.h>
#include <UART.h>
#include <GPIO.h>
#include <utilities.h>

int I = 20;

int main(int argc, char const *argv[]){
    GPIODir_t* myGPIO0Dir = (GPIODir_t*)GPIO0_PORT_DIR_ADDR;
    const char* data = "Hello, World!\n";

    GPIO0Dir->PORT_A_DIR.GPIO0 = OUTPUT;
    // GPIO0Dir->PORT_A_DIR.GPIO1 = OUTPUT;
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN1, OUTPUT);
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN2, OUTPUT);
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN3, OUTPUT);

    GPIO0Dir->PORT_A_DIR.GPIO4 = INPUT;
    GPIO0Dir->PORT_A_DIR.GPIO5 = INPUT;
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN6, INPUT);
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN7, INPUT);

    GPIO0Data->PORT_A_DATA.GPIO0 = 1;
    gpioSetData((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN1, 1);
    gpioToggle((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN2);
    gpioSet((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN3);


    UARTWrite("GPIO Setted\n", 12);

    wait(DELAY_COUNT * 5);

    UARTWrite("Start loop\n", 11);

    char buffer[20];
    while(1){
        // *((uint8_t*)(DISPLAY_BASE_ADDR + 3)) = gpioRead((uint8_t*)GPIO0_PORT_A_ADDR, PIN4);
        // *((uint8_t*)(DISPLAY_BASE_ADDR + 2)) = *((volatile uint8_t*)GPIO0_PORT_A_ADDR) >> 4;
        // *((uint8_t*)(DISPLAY_BASE_ADDR + 1)) = *((volatile uint8_t*)GPIO0_PORT_A_ADDR) & (1<<4);
        // *((uint8_t*)(DISPLAY_BASE_ADDR + 0)) = (*((volatile uint8_t*)GPIO0_PORT_A_ADDR) & (1<<4)) == (1<<4);
        // *((uint32_t*)DISPLAY_BASE_ADDR) = gpioRead((uint8_t*)GPIO0_PORT_A_ADDR, (1 << 4));
        for(int i = 0; i < 4; ++i){
            uint8_t data = gpioRead((uint8_t*)GPIO0_PORT_A_ADDR, 1 << (i + 4));
            gpioSetData((uint8_t*)GPIO0_PORT_A_DATA_ADDR, 1 << i, data);
            *((uint8_t*)(DISPLAY_BASE_ADDR + 3)) = *((uint8_t*)GPIO0_PORT_A_ADDR) >> 4;
            *((uint8_t*)(DISPLAY_BASE_ADDR + 1)) = i;
            *((uint8_t*)(DISPLAY_BASE_ADDR + 0)) = data;
            wait(DELAY_COUNT * 3);
        }
        // *((uint8_t*)(DISPLAY_BASE_ADDR)) = gpioRead((uint8_t*)GPIO0_PORT_A_ADDR, PIN4);

        // GPIO0Data->PORT_A_DATA.GPIO0 = GPIO0Port->PORT_A.GPIO4;
        // // GPIO0Data->PORT_A_DATA.GPIO1 = GPIO0Port->PORT_A.GPIO5;
        // gpioSetData((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN1, GPIO0Port->PORT_A.GPIO5);
    }
    while(1);
    return 0;
}
