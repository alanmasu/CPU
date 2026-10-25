/**
    @file Timer.h 
    @brief Header file for the Timer library.
    @details Contains the structures and function prototypes for the Timer library.
             The library is designed to provide a simple interface for managing timer present in the RISC-V CORE Project

    @author Alan Masutti (@alanmasu)
    @date 08/06/2025
 */
#ifndef __TIMER_H__
#define __TIMER_H__

#include <stdint.h>
#include <stdbool.h>

#define TIMER_CREG_BASE 0x40020060 ///< Base address of the Timer control register

#define TIMER_START_BIT_MASK          (1 << 0)  ///< Start bit mask
#define TIMER_STOP_BIT_MASK           (1 << 1)  ///< Stop bit mask
#define TIMER_MODE_BIT_POS             2        ///< Mode selection bit position 
#define TIMER_MODE_BIT_MASK           (3 << TIMER_MODE_BIT_POS) ///< Mode selection bit mask
#define TIMER_CAPTURE_SEL_BIT_POS      4        ///< Capture selection bit position
#define TIMER_CAPTURE_SEL_BIT_MASK    (0x1F << TIMER_CAPTURE_SEL_BIT_POS) ///< Capture selection bit mask
#define TIMER_CAPTURE_MODE_MASK       (1 << 9)  ///< Capture mode bit mask
#define TIMER_BUSY_BIT_MASK           (1 << 10) ///< Busy bit mask
#define TIMER_TRIGGER_MODE_BIT_MASK   (1 << 11) ///< Trigger mode bit mask

#define TIMER_MODE_CONTINUOUS         0         ///< Continuous mode
#define TIMER_MODE_CAPTURE            1         ///< Capture mode
#define TIMER_MODE_PWM                2         ///< PWM mode

#define CAPTURE_MODE_RISING           0         ///< Capture mode: Rising edge
#define CAPTURE_MODE_FALLING          1         ///< Capture mode: Falling edge

#define TIMER_TRIGGER_MODE_AUTO       0         ///< Trigger mode: Auto
#define TIMER_TRIGGER_MODE_MANUAL     1         ///< Trigger mode: Manual

#define TIMER_MS_TO_TIKS(ms) ((ms) * 40000)
#define TIMER_US_TO_TIKS(us) ((us) * 40)
#define TIMER_KHZ_TO_TIKS(khz) ((int)TIMER_US_TO_TIKS((500/khz)))

#define TIMER_TIKS_TO_US(tiks) ((tiks) / 40)            ///< Convert tiks to microseconds
#define TIMER_TIKS_TO_MS(tiks) ((tiks) / 40000)         ///< Convert tiks to milliseconds
#define TIMER_TIKS_TO_SEC(tiks) ((tiks) / 40000000)     ///< Convert tiks to seconds

typedef struct TimerCRegField_t {
    unsigned START : 1;          ///< Bit 0: Start bit
    unsigned STOP : 1;           ///< Bit 1: Stop bit
    unsigned MODE : 2;           ///< Bit 2-3: Mode selection (0: CONTINUOUS, 1: CAPTURE, 2: PWM)
    unsigned CAPTURE_SEL : 5;    ///< Bit 4-8: Capture selection (0-31)
    unsigned CAPTURE_MODE : 1;   ///< Bit 9: Capture mode (0: RISING, 1: FALLING)
    unsigned BUSY : 1;           ///< Bit 10: Busy bit
    unsigned TRIGGER_MODE : 1;   ///< Bit 11: Trigger mode (0: AUTO, 1: MANUAL)
    unsigned reserved : 20;      ///< Bit 11-31: Reserved bits
} TimerCRegField_t;

typedef union TimerCReg_t {
    volatile uint32_t value;        ///< Raw value of the control register
    volatile TimerCRegField_t reg;  ///< Bit fields of the control register
} TimerCReg_t;

typedef enum TimerMode_t {
    CONTINUOUS = 0, ///< Continuous mode
    CAPTURE    = 1, ///< Capture mode
    PWM        = 2  ///< PWM mode
} TimerMode_t;

typedef enum TriggerMode_t{
    AUTO = 0,    ///< Auto trigger mode
    MANUAL = 1   ///< Manual trigger mode
} TriggerMode_t;

typedef struct TimerRegFile_t {
    volatile TimerCReg_t creg;      ///< Control register
    volatile uint32_t counter_LSB;    ///< Start address of the timer memory
    volatile uint32_t counter_MSB;    ///< Start address of the timer memory
    volatile uint32_t capture_LSB;    ///< Capture value LSB
    volatile uint32_t capture_MSB;    ///< Capture value MSB
    volatile uint32_t compare_LSB;    ///< Compare value LSB
    volatile uint32_t compare_MSB;    ///< Compare value MSB
} TimerRegFile_t;    

extern TimerRegFile_t* Timer0RegFile; ///< Pointer to the Timer 0 register file

/**
    @brief Fa partire il timer.
    @details Scrive il registro di controllo del timer per avviare il timer.

    @param inst Puntatore alla struttura dei registri del timer
    @note La funzione impiega 4 istruzioni per avviare il timer. Quindi leggere il valore del 
          timer dopo aver chiamato questa funzione, restituisce 16 cicli di clock in meno.
          Se usata in combinazione con la funzione @ref timerStop(), il valore del timer
          sara' corretto.
*/
__attribute__((__always_inline__))
inline void timerStart(TimerRegFile_t* inst){
    // Set the START bit in the control register
    inst->creg.reg.START = 1;

}

/**
    @brief Ferma il timer.
    @details Scrive il registro di controllo del timer per fermare il timer.

    @param inst Puntatore alla struttura dei registri del timer
    @note La funzione impiega 4 istruzioni per fermare il timer. Quindi leggere il valore del 
          timer dopo aver chiamato questa funzione, restituisce 16 cicli di clock aggiuntivi.
          Se usata in combinazione con la funzione @ref timerStart(), il valore del timer
          sara' corretto.
*/
__attribute__((__always_inline__))
inline void timerStop(TimerRegFile_t* inst){
    // Set the STOP bit in the control register
    inst->creg.reg.STOP = 1;
}

/**
    @brief Imposta il valore del contatore del timer.
    
    @param inst Puntatore alla struttura dei registri del timer
    @param value Valore di confronto da impostare
*/
void timerSetCounter(TimerRegFile_t* inst, uint64_t value);

/**
    @brief Legge il valore del timer.
    @details Legge il valore corrente del timer, restituendo un valore a 64 bit.

    @param inst Puntatore alla struttura dei registri del timer
    @return Valore corrente del timer come un intero a 64 bit.
*/
uint64_t timerGetCounter(TimerRegFile_t* inst);

/**
    @brief Restituisce il valore di cattura del timer.
    @details Restituisce il valore di cattura del timer come un intero a 64 bit.

    @param inst Puntatore alla struttura dei registri del timer
    @return Valore di cattura del timer come un intero a 64 bit.
*/
uint64_t timerGetCaptureValue(TimerRegFile_t* inst);

/**
    @brief Imposta il modo di funzionamento del timer.
    @details Imposta il modo di funzionamento del timer (CONTINUOUS, CAPTURE, PWM).

    @param inst Puntatore alla struttura dei registri del timer
    @param mode Modo di funzionamento da impostare (0: CONTINUOUS, 1: CAPTURE, 2: PWM)
*/
void timerSetMode(TimerRegFile_t* inst, TimerMode_t mode);

/**
    @brief Imposta la modalita' di trigger del timer.
    @details La modalita' di trigger del timer puo' essere AUTO o MANUAL,
              - In mod. AUTO il timer si avvia automaticamente quando CC passa al valore di CAPTURE_MODE
              - In mod. MANUAL il timer si avvia allo start.abort
    
    @param inst Puntatore alla struttura dei registri del timer
    @param mode Modalita' di trigger da impostare (AUTO, MANUAL)
*/
void timerSetTriggerMode(TimerRegFile_t* inst, TriggerMode_t mode);

/**
    @brief Imposta il valore di confronto del timer.
    @details Scrive il valore di confronto del timer.

    @param inst Puntatore alla struttura dei registri del timer
    @param value Valore di confronto da impostare
*/
void timerSetCompare(TimerRegFile_t* inst, uint64_t value);

/**
    @brief Imposta il modo di cattura del timer.
    @details Imposta il modo di cattura del timer (RISING, FALLING).

    @param inst Puntatore alla struttura dei registri del timer
    @param mode Modo di cattura da impostare (0: RISING, 1: FALLING)
*/
void timerSetCaptureMode(TimerRegFile_t* inst, uint8_t mode);

/**
    @brief Imposta il selettore di cattura del timer.
    @details Imposta il selettore di cattura del timer (0-31).

    @param inst Puntatore alla struttura dei registri del timer
    @param sel Selettore di cattura da impostare (0-31)
*/
void timerSetCaptureSelector(TimerRegFile_t* inst, uint8_t sel);

/**
    @brief Set the parameters of the PWM mode.
    @details Writes the terminal count into the capture registers and the compare value into the compare registers, as the PWM mode of the timer expects.

    @param inst Pointer to the register file of the timer
    @param compareValue Counter value at which the output toggles
    @param terminalCount Counter value at which the period restarts
*/
void timerSetPWM(TimerRegFile_t* inst, uint64_t compareValue, uint64_t terminalCount);

/**
    @brief Controlla se il timer è occupato.
    @details Controlla se il timer è occupato, leggendo il bit BUSY del registro di controllo.

    @param inst Puntatore alla struttura dei registri del timer
    @return true se il timer è occupato, false altrimenti
*/
bool timerIsBusy(TimerRegFile_t* inst);

/**
    @brief Attende un certo numero di microsecondi.
    @details Configura il timer in modalità CONTINUOUS e attende il numero di microsecondi specificato.
             

    @param inst Puntatore alla struttura dei registri del timer
    @param us Numero di microsecondi da attendere
*/
void waitUs(uint64_t us);

/**
    @brief Attende un certo numero di millisecondi.
    @details Configura il timer in modalità CONTINUOUS e attende il numero di millisecondi specificato.

    @param inst Puntatore alla struttura dei registri del timer
    @param ms Numero di millisecondi da attendere
*/
void waitMs(TimerRegFile_t* inst, uint64_t ms);

/**
    @brief Attende un certo numero di tiks.
    @details Controlla se il timer e' impostato in modalità CONTINUOUS, se non è partito lo 
             avvia e attende il numero di tiks specificato. Se il timer è in modalità CAPTURE o PWM,
             la funzione restituisce false.
    @param inst Puntatore alla struttura dei registri del timer
    @param tiks Numero di tiks da attendere
    @return true se il timer è in modalità CONTINUOUS e ha atteso il numero di tiks specificato, 
            false altrimenti (ad esempio se il timer è in modalità CAPTURE o PWM).
*/
bool timerWaitTiks(TimerRegFile_t* inst, uint64_t tiks);


#endif // __TIMER_H__
