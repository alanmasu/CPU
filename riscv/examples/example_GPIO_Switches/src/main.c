// example_GPIO_Switches: copies the switches SW4-SW7 of the ZedBoard onto the
// LEDs LD4-LD7, both wired to port A of the GPIO of the core: SW4-SW7 to
// pins 4-7 (GPIO[7:4]), inputs, and LD4-LD7 to pins 0-3 (GPIO[3:0]),
// outputs. SW4 drives LD4, SW5 LD5, and so on.

#include <stdint.h>
#include <stdio.h>
#include <GPIO.h>

#define LEDS        (PIN0 | PIN1 | PIN2 | PIN3)
#define SWITCHES    (PIN4 | PIN5 | PIN6 | PIN7)
// Pin of port A of the first switch, SW4
#define FIRST_SWITCH 4

int main(void){
    uint8_t* direction = (uint8_t*)GPIO0_PORT_A_DIR_ADDR;
    uint8_t* input = (uint8_t*)GPIO0_PORT_A_ADDR;
    uint8_t* output = (uint8_t*)GPIO0_PORT_A_DATA_ADDR;

    gpioSetDir(direction, LEDS, OUTPUT);
    gpioSetDir(direction, SWITCHES, INPUT);
    printf("Move the switches SW4-SW7: each one turns on its LED, LD4-LD7\n");

    while(1){
        for(uint8_t led = 0; led < 4; led++){
            uint8_t on = gpioReadByNum(input, FIRST_SWITCH + led);
            gpioSetValueByNum(output, led, on);
        }
    }

    return 0;
}
