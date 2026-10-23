#include <main.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <Timer.h>
#include <OLED.h>
#include <utilities.h>

#ifndef SIMULATION
    #define PRINTF_DBG(...) printf(__VA_ARGS__)
#else 
    #define PRINTF_DBG(...)
#endif

uint64_t timerValue = 0;

int main(int argc, char const *argv[]){
    // Inizializza il timer in modalità CONTINUOUS
    timerSetMode(Timer0RegFile, CONTINUOUS);

    // Imposta il valore a 0
    timerSetCounter(Timer0RegFile, 0);

    // Avvia il timer
    timerStart(Timer0RegFile);

    while(1){
        OLED0Data->value = TIMER_TIKS_TO_SEC(Timer0RegFile->counter_LSB); // Legge il valore del timer e lo scrive su OLED
        wait(DELAY_COUNT/10);
    }
}
