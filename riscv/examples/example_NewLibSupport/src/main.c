#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <main.h>
#include <utilities.h>
#include <UART.h>

#define N 100

const char *msg = "Ciao!"; // .rodata
const int costante = 100;  // .rodata
static int statica = 5;    // .data
int glob_init = 42;        // .data
static int statica_uninit; // .bss
int glob_uninit;           // .bss

void test(){
    statica ++;
    statica_uninit ++;
}

int main(int argc, char const *argv[]) {
	setvbuf(stdin, NULL, _IONBF, 0);  // disabilita buffering su stdin

    // Inizializzazione della UART
    UARTInit();

    uint8_t* dynamic_arr = NULL;
    uint8_t arr[N] ={
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
        10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
        30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
        40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
        50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
        70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
        80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
        90, 91, 92, 93, 94, 95, 96, 97, 98, 99
    }; // dati in .const, arr è automatico quindi in stack.

    printf("%d, %d, %s,%d, %d, %d\n", glob_init, glob_uninit, msg, costante, statica, statica_uninit);
    test();
    printf("%d, %d, %s,%d, %d, %d\n", glob_init, glob_uninit, msg, costante, statica, statica_uninit);

    dynamic_arr = (uint8_t*)malloc(N * sizeof(uint8_t));
    memcpy(dynamic_arr, arr, N * sizeof(uint8_t));

    char command = 0;
    char myString[100] = "Test Stringa";

    printf("\n\nVuoi stampare l'array dinamico? (y/n): ");
    fflush(stdin);
    scanf("%c", &command);
    printf("command: %c\n", command);
    while(1){
        if(command == 'y' || command == 'Y') {
            for(int i = 0; i < N; i++) {
                printf("arr[i]:%d, dynamyc_arr[i]:%d\n", arr[i], dynamic_arr[i]);
            }
            break;
        } else if(command == 'n' || command == 'N'){
            printf("Non stampo l'array dinamico.\n");
            for(int i = 0; i < N; i++) {
                printf("arr[i]:%d\n", arr[i]);
            }    
            break;
        }else {
            printf("Comando non valido. Riprova (y/n): ");
            fflush(stdin);
            scanf("%s", myString);
            printf("\nmyString: %s\n", myString);
            command = myString[0];
            printf("command: %c\n", command);
            wait(0);
        }
    }
    while(1);
    return 0;
}
