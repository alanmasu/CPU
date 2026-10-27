// example_HelloWorld: prints a line on the UART of the core with printf,
// through newlib and the syscall library of the SDK, then stops.

#include <stdio.h>

int main(void){
    printf("Hello, World!\n");

    // A bare-metal program has nowhere to return to: stay here
    while(1);

    return 0;
}
