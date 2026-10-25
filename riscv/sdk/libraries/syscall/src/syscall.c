#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <stdint.h>
#include <UART.h>

extern uint8_t __heap_start;
static uint8_t *heap_ptr = &__heap_start;

void *_sbrk(int incr) {
    uint32_t __stack_pointer;
    __asm__ volatile (
        "mv %0, sp"
        : "=r"(__stack_pointer)
    );

    uint8_t* prev = heap_ptr;
    if (heap_ptr + incr > (uint8_t*)__stack_pointer) {
        errno = ENOMEM;
        return (void *)-1;
    }
    heap_ptr += incr;
    return (void *)prev;
}

int _write(int fd, const void *buf, size_t count) {
    // Inserisci qui codice per scrivere su UART o simile
    UARTWrite((uint8_t*)buf, count);
    return count;
}

int _read(int fd, void *buf, size_t count) {
    // Inserisci qui codice per leggere da UART o simile
    return UARTRead((uint8_t*)buf, count, UART_READ_WAIT_NONZERO);
    // return UARTRead((uint8_t*)buf, count, UART_READ_NONBLOCKING);
    // return UARTRead((uint8_t*)buf, count, UART_READ_BLOCKING);
}

void _putchar(char character){
    UARTWrite((uint8_t*)&character, 1);
}

int _close(int fd){
    return -1; 
}

int _fstat(int fd, struct stat *st) { 
    st->st_mode = S_IFCHR; 
    return 0; 
}
int _lseek(int fd, int ptr, int dir) { 
    return 0; 
}
int _isatty(int fd){ 
    return 1; 
}
