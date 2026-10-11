// #include <inttypes.h>


// char* PORT_A = (char*)0x40020003;
// char* PORT_A_DIR = (char*)0x40020007;
// char* PORT_A_DATA = (char*)0x4002000B;

// char* PORT_B = (char*)0x40020002;
// char* PORT_B_DIR = (char*)0x40020006;
// char* PORT_B_DATA = (char*)0x4002000A;

// char* PORT_C = (char*)0x40020001;
// char* PORT_C_DIR = (char*)0x40020005;
// char* PORT_C_DATA = (char*)0x40020009;

// char* PORT_D = (char*)0x40020000;
// char* PORT_D_DIR = (char*)0x40020004;
// char* PORT_D_DATA = (char*)0x40020008;

#include <stdint.h>

#define GPIO0 0b00000001
#define GPIO1 0b00000010
#define GPIO2 0b00000100
#define GPIO3 0b00001000
#define GPIO4 0b00010000
#define GPIO5 0b00100000
#define GPIO6 0b01000000
#define GPIO7 0b10000000

int main(int, char**){
    uint8_t* PORT_A = (uint8_t*)0x40020000;
    uint8_t* PORT_A_DIR = (uint8_t*)0x40020004;
    uint8_t* PORT_A_DATA = (uint8_t*)0x40020008;

    // *PORT_A_DATA = 0;                         // Clear all GPIOs
    // *PORT_A_DIR = 0;

    *PORT_A_DIR = *PORT_A_DIR | GPIO1 | GPIO0;      // Set GPIO0 and GPIO1 as output

    uint32_t* GPIO_state = (uint32_t*)0x40010000;
    while(1){
        *PORT_A_DATA = *PORT_A | GPIO0;    // Set GPIO0

        // uint8_t tmp = *PORT_A_DATA;
        // tmp = tmp >> 4;
        // tmp |= GPIO0;
        // (*PORT_A_DATA) &= tmp;
        
        GPIO_state[0] = *PORT_A;

        for (int i = 0; i < 1250000; i++){

        }

        *PORT_A_DATA = *PORT_A_DATA & ~GPIO0;   // Clear GPIO0

        for (int i = 0; i < 1250000; i++){

        }
    }

}