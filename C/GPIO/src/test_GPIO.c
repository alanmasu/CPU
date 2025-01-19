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


#define GPIO0 0b00000001
#define GPIO1 0b00000010
#define GPIO2 0b00000100
#define GPIO3 0b00001000
#define GPIO4 0b00010000
#define GPIO5 0b00100000
#define GPIO6 0b01000000
#define GPIO7 0b10000000

int main(int, char**){
    int* GPIO_BASE_ADDRESS  = (int*)0x40020000;
    int* GPIO_DIR_REG       = (int*)0x40020004;
    int* GPIO_DATA_REG      = (int*)0x40020008;

    *GPIO_DIR_REG = 1;                          // Set all GPIOs as input
    *GPIO_DATA_REG = 0;                         // Clear all GPIOs 

    // *GPIO_DIR_REG = *GPIO_DIR_REG | GPIO0;      // Set GPIO0 as output
    // *GPIO_DATA_REG = 0;                         // Clear all GPIOs

    while(1){
        // *GPIO_DATA_REG = *GPIO_DATA_REG & ~GPIO0;   // Clear GPIO0
        *GPIO_DATA_REG = 0;                       // Clear all GPIOs

        for (int i = 0; i < 1250000; i++){

        }

        // *GPIO_DATA_REG = *GPIO_DATA_REG | GPIO0;    // Set GPIO0
        *GPIO_DATA_REG = 1;

        for (int i = 0; i < 1250000; i++){

        }
    }

}