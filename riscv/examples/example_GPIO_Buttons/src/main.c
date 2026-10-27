// example_GPIO_Buttons: shows the buttons BTNU, BTND, BTNL and BTNR of the
// ZedBoard on the LEDs LD4-LD7, and prints on the UART every change.
// The buttons are not on the GPIO of the core: they are bits of the IO
// register of the control registers (CREG_IO, at 0x40004010, see
// utilities.h), the same register the ARM reads in LoaderApp. The LEDs are
// pins 0-3 of port A of the GPIO.

#include <stdint.h>
#include <stdio.h>
#include <GPIO.h>
#include <utilities.h>

#define LEDS (PIN0 | PIN1 | PIN2 | PIN3)

int main(void){
    uint8_t* output = (uint8_t*)GPIO0_PORT_A_DATA_ADDR;
    uint8_t last = 0xFF;

    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, LEDS, OUTPUT);
    printf("Press BTNU, BTND, BTNL or BTNR\n");

    while(1){
        // One bit per button: UP, DOWN, LEFT, RIGHT
        uint8_t buttons = controlRegister->IO.btnUP
                        | controlRegister->IO.btnDOWN << 1
                        | controlRegister->IO.btnLEFT << 2
                        | controlRegister->IO.btnRIGHT << 3;

        gpioSetValue(output, LEDS, 0);
        gpioSetValue(output, buttons, 1);

        if(buttons != last){
            printf("UP %d DOWN %d LEFT %d RIGHT %d\n", buttons & 1, (buttons >> 1) & 1, (buttons >> 2) & 1, (buttons >> 3) & 1);
            last = buttons;
        }
    }

    return 0;
}
