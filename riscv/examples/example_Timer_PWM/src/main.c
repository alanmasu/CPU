// example_Timer_PWM: dims the LED LD1 of the ZedBoard with the PWM mode of
// the timer, whose output drives LD1 (pwm => leds(0) in CPU.vhd).
// Two modes, both printed on the UART:
//   BTNL  fade: the duty cycle goes up and down by itself
//   BTNR  manual: BTNU raises the duty cycle by 10%, BTND lowers it
// From the old CPU_testTimer and test_PWM.
//
// In PWM mode the counter of the timer runs from 0 to the terminal count and
// starts again; the output is high until the counter reaches the compare
// value. The timer counts at 40 MHz (TIMER_US_TO_TIKS in Timer.h).

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <Timer.h>
#include <utilities.h>

// Period of the PWM: 1 ms, fast enough that the LED does not flicker
#define PERIOD_TIKS     TIMER_US_TO_TIKS(1000)
#define MANUAL_STEP     10
// Iterations of the delay loop between two steps of the fade, about 10 ms
#define FADE_LOOPS      50000

static void setDuty(uint32_t percent){
    timerStop(Timer0RegFile);
    timerSetPWM(Timer0RegFile, PERIOD_TIKS * percent / 100, PERIOD_TIKS);
    timerStart(Timer0RegFile);
}

static void fadeDelay(void){
    // volatile: with -Os the compiler would remove an empty loop
    for(volatile uint32_t i = 0; i < FADE_LOOPS; i++){
    }
}

int main(void){
    bool fade = true;
    uint32_t percent = 0;
    int32_t direction = 1;

    timerSetMode(Timer0RegFile, PWM);
    setDuty(percent);
    printf("PWM on LD1. BTNL: fade, BTNR: manual, then BTNU/BTND to change the duty cycle\n");
    printf("Mode: fade\n");

    while(1){
        if(controlRegister->IO.btnLEFT && !fade){
            fade = true;
            printf("Mode: fade\n");
        }
        if(controlRegister->IO.btnRIGHT && fade){
            fade = false;
            // Start the manual mode from a multiple of the step
            percent = percent / MANUAL_STEP * MANUAL_STEP;
            setDuty(percent);
            printf("Mode: manual, duty cycle %lu%%, BTNU/BTND to change it\n", (unsigned long)percent);
        }

        if(fade){
            // One step of 1% every FADE_LOOPS, up to 100% and back to 0%
            if(percent == 100){
                direction = -1;
            }else if(percent == 0){
                direction = 1;
            }
            percent += direction;
            setDuty(percent);
            fadeDelay();
        }else{
            if(controlRegister->IO.btnUP && percent < 100){
                percent += MANUAL_STEP;
                setDuty(percent);
                printf("Duty cycle %lu%%\n", (unsigned long)percent);
                // Wait for the release, so one press is one step
                while(controlRegister->IO.btnUP);
            }
            if(controlRegister->IO.btnDOWN && percent > 0){
                percent -= MANUAL_STEP;
                setDuty(percent);
                printf("Duty cycle %lu%%\n", (unsigned long)percent);
                while(controlRegister->IO.btnDOWN);
            }
        }
    }

    return 0;
}
