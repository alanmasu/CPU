#include <main.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <Timer.h>
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

    // Attendi 10 istruzioni
    __asm__(
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
    );

    // Ferma il timer
    timerStop(Timer0RegFile);

    // Ottieni il valore del timer
    timerValue = timerGetCounter(Timer0RegFile);

    

    while(1);
    
}
