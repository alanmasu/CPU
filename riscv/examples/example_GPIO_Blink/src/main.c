// example_GPIO_Blink: blinks the LEDs LD4-LD7 of the ZedBoard, wired to
// GPIO[3:0] of the core (pins 0-3 of port A), with the GPIO library of the SDK.
// The C version of the old riscv/apps/GPIO, which blinked LD4 only.

#include <stdint.h>
#include <GPIO.h>

#define LEDS        (PIN0 | PIN1 | PIN2 | PIN3)
// Iterations of the delay loop between two toggles, as in the old example
#define DELAY_LOOPS 1250000

static void delay(void){
    // volatile: with -Os the compiler would remove an empty loop
    for(volatile uint32_t i = 0; i < DELAY_LOOPS; i++){
    }
}

int main(void){
    gpioSetDir((uint8_t*)GPIO0_PORT_A_DIR_ADDR, LEDS, OUTPUT);

    while(1){
        gpioToggle((uint8_t*)GPIO0_PORT_A_DATA_ADDR, LEDS);
        delay();
    }

    return 0;
}
