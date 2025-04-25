#include <utilities.h>

#include <stdint.h>
#include <stdbool.h>

#include <UART.h>

extern void main(int argc, char const *argv[]);

__attribute__((optimize("O3"))) __attribute__((section(".init")))
void _init(){
    __asm__("li t0, 0x40010000\n\t"
            "lw gp, 0(t0)\n\t"
            "lw a0, 4(t0)\n\t"
            "lw a1, 8(t0)\n\t"
            "call main\n\t"
    );
}

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

__attribute__((optimize("O0"))) 
void wait(uint32_t time){
#ifndef SIMULATION
    if (time == 0){
        time = DELAY_COUNT;
    }
#else
    #warning "SIMULATION MODE"
    time = 4;
#endif   
    
    for (uint32_t i = 0; i < time; i++){
        // Do nothing
    }
}

void _putchar(char character){
    UARTWrite((uint8_t*)&character, 1);
}