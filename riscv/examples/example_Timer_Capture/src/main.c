// example_Timer_Capture: measures how long the BTPU takes for a binary matrix
// multiplication, with the capture mode of the timer, and prints it on the
// UART. From test_TimerCapture, which checks the same measure in TestApp.
//
// In capture mode the timer counts from its start until an edge of one of its
// 32 capture inputs, chosen by the capture selector, and saves the counter.
// Only input 0 is wired today, to the busy signal of the BTPU (CPU.vhd), so
// the falling edge of input 0 is the end of the computation. The timer
// counts at 40 MHz, 25 ns per tick (TIMER_US_TO_TIKS in Timer.h): the
// computation takes a few microseconds, so the time is printed in ns.

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <BinaryMatMul.h>
#include <Timer.h>

// Nanoseconds per tick of the timer, at 40 MHz
#define NS_PER_TICK 25

// Some data in the memories of the BTPU: the content does not change the time
static void initMatrices(void){
    for(int i = 0; i < BINARY_FRAG_SIZE; ++i){
        BTPU0_W_MEMORY[0][i] = i;
        BTPU0_IO0_MEMORY[0][i] = i + 1;
        BTPU0_IO1_MEMORY[0][i] = i + 2;
    }
}

static uint64_t measure(uint32_t memoryConfig){
    btpuSetAddrs(BTPU0RegFile, 0, 0, 1);
    timerStart(Timer0RegFile);
    btpuStartBinaryMatrixMul(BTPU0RegFile, 30, false, true, memoryConfig);
    btpuWaitBinaryMatrixMul(BTPU0RegFile);
    return timerGetCaptureValue(Timer0RegFile);
}

int main(void){
    initMatrices();

    // Capture on the falling edge of input 0, the busy signal of the BTPU;
    // AUTO: the count starts with timerStart, without waiting for an edge
    timerSetMode(Timer0RegFile, CAPTURE);
    timerSetTriggerMode(Timer0RegFile, AUTO);
    timerSetCaptureMode(Timer0RegFile, CAPTURE_MODE_FALLING);
    timerSetCaptureSelector(Timer0RegFile, 0);

    uint64_t memory0 = measure(BTPU_USE_MEMORY_0_CONFIG);
    uint64_t memory1 = measure(BTPU_USE_MEMORY_1_CONFIG);

    printf("Time of a binary matrix multiplication of the BTPU, measured by the timer in capture mode\n");
    printf("BTPU with memory 0: %lu ticks, %lu ns\n", (unsigned long)memory0, (unsigned long)(memory0 * NS_PER_TICK));
    printf("BTPU with memory 1: %lu ticks, %lu ns\n", (unsigned long)memory1, (unsigned long)(memory1 * NS_PER_TICK));

    // Give the memories of the BTPU back to the AXI port, as test_TimerCapture
    BTPU0RegFile->creg.reg.BRAM_PORT_SEL = BTPU_BRAM_PORT_SEL_EXT;

    while(1);

    return 0;
}
