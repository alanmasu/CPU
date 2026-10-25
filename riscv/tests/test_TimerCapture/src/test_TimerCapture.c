#include <main.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <BinaryMatMul.h>
#include <UART.h>
#include <GPIO.h>
#include <utilities.h>
#include <OLED.h>
#include <Timer.h>

// __attribute__((optimize("O0")))
void initMatrices(){
    for(int i = 0; i < BINARY_FRAG_SIZE; ++i){
        BTPU0_W_MEMORY[0][i] = i;
        BTPU0_IO0_MEMORY[0][i] = i + 1;
        BTPU0_IO1_MEMORY[0][i] = i + 2;
    }
}

uint64_t resultsTestCapture[2] = {0, 0};

int main(int argc, char const *argv[]){
    // Initialize Matrices
    initMatrices();

    // Configure Timer to measure BTPU execution time
    timerSetMode(Timer0RegFile, CAPTURE);
    timerSetTriggerMode(Timer0RegFile, AUTO);
    timerSetCaptureMode(Timer0RegFile, CAPTURE_MODE_FALLING);
    timerSetCaptureSelector(Timer0RegFile, 0);

    //Configure first Binary Matrix Mul 
    btpuSetAddrs(BTPU0RegFile, 0, 0, 1);
    timerStart(Timer0RegFile);
    btpuStartBinaryMatrixMul(BTPU0RegFile, 30, false, true, BTPU_USE_MEMORY_0_CONFIG);
    btpuWaitBinaryMatrixMul(BTPU0RegFile);

    resultsTestCapture[0] = timerGetCaptureValue(Timer0RegFile);

    // //Configure second Binary Matrix Mul
    btpuSetAddrs(BTPU0RegFile, 0, 0, 1);
    timerStart(Timer0RegFile);
    btpuStartBinaryMatrixMul(BTPU0RegFile, 30, false, true, BTPU_USE_MEMORY_1_CONFIG);
    btpuWaitBinaryMatrixMul(BTPU0RegFile);

    resultsTestCapture[1] = timerGetCaptureValue(Timer0RegFile);

    BTPU0RegFile->creg.reg.BRAM_PORT_SEL = BTPU_BRAM_PORT_SEL_EXT;

    // Trap CPU
    while(1);
}
