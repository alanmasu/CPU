#include <utilities.h>

#include <stdint.h>
#include <stdbool.h>

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