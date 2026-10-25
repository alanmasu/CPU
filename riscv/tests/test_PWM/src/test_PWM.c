#include <stdlib.h>
#include <stdio.h>
#include <UART.h>
#include <Timer.h>
#include <utilities.h>


int main(int argc, char const *argv[]){

    timerSetMode(Timer0RegFile, PWM);
    timerSetPWM(Timer0RegFile, 66, 200);
    timerStart(Timer0RegFile);

    while(1);

    return 0;
}
