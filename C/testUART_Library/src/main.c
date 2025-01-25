#include <main.h>
#include <UART.h>
// #include <string.h>

#define DISPLAY_BASE_ADDR 0x40001018
#define DELAY_COUNT 1250000

int strcmp(const char* str1, const char* str2){
    while(*str1 && *str2){
        if(*str1 != *str2){
            return 0;
        }
        str1++;
        str2++;
    }
    return 1;
}

void wait(uint32_t time){
    if (time == 0){
        time = DELAY_COUNT;
    }
    
    for (uint32_t i = 0; i < time; i++){
        // Do nothing
    }
}

int main(int argc, char const *argv[]){

    const char* data = "Hello, World!\n";

    UARTWrite((uint8_t*)data, 14);

    char buffer[20];

    while(1){
        UARTRead((uint8_t*)buffer, 1);
        // wait(0);
        // UARTWrite((uint8_t*)buffer, 4);
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
