#include <stdint.h>
#include <stdio.h>

// UART Address
uint32_t* uartAddress = (uint32_t*)0xE0001000;

int main(int argc, char const *argv[]){
    /* code */
    uint32_t* registerAddress = uartAddress + 0x30;
    *registerAddress = (uint32_t)'c';
    *registerAddress = (uint32_t)'i';
    *registerAddress = (uint32_t)'a';
    *registerAddress = (uint32_t)'o';
    *registerAddress = (uint32_t)'\n';
    *registerAddress = (uint32_t)'\r';

    while(1);
    
    return 0;
}
