#include <GPIO.h>
#include <UART.h>
#include <stdio.h>

int main(int argc, char const *argv[]){
    /* code */
    printf("Hello World from test GPIO!\n");
    return GPIO0Port->PORT_A.GPIO0;
}
