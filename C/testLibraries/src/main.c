#include <main.h>
#include <UART.h>
#include <GPIO.h>
#include <utilities.h>

extern uint32_t _econst;

int main(int argc, char const *argv[]){

    const char* data = "Hello, World!\n";

    UARTWrite((uint8_t*)data, 14);

    GPIO0Dir->PORT_A_DIR.GPIO0 = OUTPUT;
    GPIO0Dir->PORT_A_DIR.GPIO1 = OUTPUT;
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN2, OUTPUT);
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN3, OUTPUT);

    GPIO0Dir->PORT_A_DIR.GPIO4 = INPUT;
    GPIO0Dir->PORT_A_DIR.GPIO5 = INPUT;
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN6, INPUT);
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, PIN7, INPUT);

    GPIO0Data->PORT_A_DATA.GPIO0 = 1;
    gpioSetData((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN2, 1);
    gpioToggle((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN3);
    gpioSet((uint8_t*)GPIO0_PORT_A_DATA_ADDR, PIN4);

    UARTWrite("GPIO Setted\n", 12);

    wait(DELAY_COUNT * 3);


    char buffer[20];

    while(1){
        UARTRead((uint8_t*)buffer, 1);

        if(buffer[0] == '1'){
            // Display the message
            *((uint32_t*)DISPLAY_BASE_ADDR) = 1;
        }
        if(buffer[0] == '0'){
            // Clear the display
            *((uint32_t*)DISPLAY_BASE_ADDR) = 0;
        }
    }
    while(1);
    return 0;
}
