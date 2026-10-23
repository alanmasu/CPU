#include <Timer.h>

TimerRegFile_t* Timer0RegFile = (TimerRegFile_t*)TIMER_CREG_BASE; ///< Pointer to the Timer 0 register file



void timerSetCounter(TimerRegFile_t* inst, uint64_t value){
    // Set the counter value in the control register
    inst->counter_LSB = (uint32_t)(value & 0xFFFFFFFF);
    inst->counter_MSB = (uint32_t)((value >> 32) & 0xFFFFFFFF);
}

void timerSetCompare(TimerRegFile_t* inst, uint64_t value){
    // Set the compare value in the control register
    inst->compare_LSB = (uint32_t)(value & 0xFFFFFFFF);
    inst->compare_MSB = (uint32_t)((value >> 32) & 0xFFFFFFFF);
}

uint64_t timerGetCounter(TimerRegFile_t* inst){
    uint64_t counterValue = 0;
    counterValue |= (uint64_t)inst->counter_LSB; // Read LSB
    counterValue |= ((uint64_t)inst->counter_MSB << 32); // Read MSB
    return counterValue;
}

uint64_t timerGetCaptureValue(TimerRegFile_t* inst){
    uint64_t captureValue = 0;
    captureValue |= (uint64_t)inst->capture_LSB; // Read LSB
    captureValue |= ((uint64_t)inst->capture_MSB << 32); // Read MSB
    return captureValue;
}

void timerSetMode(TimerRegFile_t* inst, TimerMode_t mode){
    // Set the mode in the control register
    inst->creg.reg.MODE = mode;
}

void timerSetTriggerMode(TimerRegFile_t* inst, TriggerMode_t mode){
    // Set the trigger mode in the control register
    inst->creg.reg.TRIGGER_MODE = mode;
}

void timerSetCaptureMode(TimerRegFile_t* inst, uint8_t mode){
    // Set the capture mode in the control register
    inst->creg.reg.CAPTURE_MODE = mode;
}

void timerSetCaptureSelector(TimerRegFile_t* inst, uint8_t sel){
    // Set the capture selector in the control register
    inst->creg.reg.CAPTURE_SEL = sel;
}

void timerSetPWM(TimerRegFile_t* inst, uint64_t compareValue, uint64_t terminalCount){
    inst->capture_LSB = (uint32_t)(terminalCount & 0xFFFFFFFF);
    inst->capture_MSB = (uint32_t)((terminalCount >> 32) & 0xFFFFFFFF);
    inst->compare_LSB = (uint32_t)(compareValue & 0xFFFFFFFF);
    inst->compare_MSB = (uint32_t)((compareValue >> 32) & 0xFFFFFFFF);
}

bool timerIsBusy(TimerRegFile_t* inst){
    // Check if the timer is busy
    return inst->creg.reg.BUSY;
}

__attribute__((optimize("O0"), naked))
void waitUs(uint64_t us){
    __asm__(
        "li a1, 0\n\t"          // 1
        "li a1, 1\n\t"          // 2
        "li a2, 2\n\t"          // 3
        "bltu a0, a1, fine\n\t" // 4
        "bge a0, a2, \n\t"      // 5
        "nop\n\t"               // 6
        "nop\n\t"               // 7
        "nop\n\t"               // 8    
        "nop\n\t"               // 9
        "ret\n\t"               // 10
        "ge1:\n\t"              
        "addi a0, a0, -1\n\t"   // 6
        "blt a0, a1, fine\n\t"  // 7
        "nop\n\t"               // 8
        "j ge1\n\t"             // 9
        "fine:\n\t"             
        "ret\n\t"               // 10 (5 is 0 us is asked)
    );
}

__attribute__((optimize("O3")))
void waitMs(TimerRegFile_t* inst, uint64_t ms){
    #ifndef TIMER_SUPPORTS_ONESHOT
    ms = (ms << 15) + (ms << 12) + (ms << 11) + (ms << 10) + (ms << 6);
    inst->creg.reg.MODE = CONTINUOUS; // Set the timer to continuous mode
    timerStart(inst); // Start the timer
    uint64_t startTime = timerGetCounter(inst);
    while(timerGetCounter(inst) - startTime < ms){
        // Wait until the timer is busy
    }
    #else
        #warning "NOTE: is necessary to calculate the ms value computation time"
        inst->creg.reg.MODE = ONE_SHOT; // Set the timer to continuous mode
        timerSetCompare(inst, ms);
        timerStart(inst); // Start the timer
        while(timerIsBusy(inst)){
            // Wait until the timer is busy
        }
    #endif
}

__attribute__((optimize("O3")))
bool timerWaitTiks(TimerRegFile_t* inst, uint64_t tiks){
    uint64_t t0 = 0;
    // Set the timer to continuous mode
    if(inst->creg.reg.MODE != CONTINUOUS){
        return false; 
    }
    if(! inst->creg.reg.BUSY){
        timerStart(inst); // Start the timer if not already busy
    }else{
        t0 = timerGetCounter(inst);
    }
        
    while(timerGetCounter(inst) - t0 < tiks){
        // Wait until the timer reaches the specified number of ticks
    }
    return true;
}