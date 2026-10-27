// example_OLED_Counter: counts on the OLED display of the ZedBoard, in
// hexadecimal, about four times a second.
// The display shows the 32 bits of a register: the select field of the OLED
// control register (OLED0CReg, at 0x40004014) chooses the source, and 1 is
// the OLED data register (OLED0Data, at 0x40004018), written here.
// SW1 must be up: it is the lowest bit of the source of the display
// (oled_select0 in CPU.vhd), and with SW1 down the display shows something
// else. Do not press BTNC: it powers the display off.

#include <stdint.h>
#include <stdio.h>
#include <OLED.h>

// Iterations of the delay loop between two values
#define DELAY_LOOPS 1250000

static void delay(void){
    // volatile: with -Os the compiler would remove an empty loop
    for(volatile uint32_t i = 0; i < DELAY_LOOPS; i++){
    }
}

int main(void){
    uint32_t count = 0;

    printf("Counting on the OLED display: set SW1 up to see it, do not press BTNC\n");
    OLED0CReg->reg.select = 1;

    while(1){
        OLED0Data->value = count;
        count++;
        delay();
    }

    return 0;
}
