#include <main.h>
#include <UART.h>
// #include <string.h>

#define DISPLAY_BASE_ADDR 0x40001018

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


int main(int argc, char const *argv[]){

    char* data = "Hello, World!\n";

    UARTWrite((uint8_t*)data, 14);

    char buffer[20];

    while(1){
        UARTRead((uint8_t*)buffer, 4);

        if(strcmp(buffer, "on\n") == 1){
            // Display the message
            *((uint32_t*)DISPLAY_BASE_ADDR) = 1;
        }
        if(strcmp(buffer, "off\n") == 1){
            // Clear the display
            *((uint32_t*)DISPLAY_BASE_ADDR) = 0;
        }
    }
    return 0;
}
