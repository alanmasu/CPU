#include <stdlib.h>
#include <stdio.h>
#include <UART.h>
#include <Timer.h>
#include <utilities.h>


int main(int argc, char const *argv[]){
    printf("Hello, World From Timer!\n");

    timerSetMode(Timer0RegFile, PWM);
    timerSetCompare(Timer0RegFile, TIMER_KHZ_TO_TIKS(10));
    timerStart(Timer0RegFile);

    while(1){
        // Attendi 1 ms
        for (int i = 0; i < 1000; i++) {
            timerSetCompare(Timer0RegFile, Timer0RegFile->compare_LSB + TIMER_KHZ_TO_TIKS(1));
            timerStart(Timer0RegFile);
            wait(0);
            wait(0);
            timerStop(Timer0RegFile);
        }
        for (int i = 0; i < 1000; i++) {
            timerSetCompare(Timer0RegFile, Timer0RegFile->compare_LSB - TIMER_KHZ_TO_TIKS(1));
            timerStart(Timer0RegFile);
            wait(0);
            wait(0);
            timerStop(Timer0RegFile);
        }
    }

    while(1);

    return 0;
}
