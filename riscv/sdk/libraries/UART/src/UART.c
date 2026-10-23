/**!
 * @file    UART.c
 * 
 * @author  Alan Masutti (@alanmasu)
 * @date    30/03/2025
 * 
*/
#include <UART.h>

#include <stdio.h>
#include <stdint.h>
#include <errno.h>

#ifdef DEBUG
    #define PRINTF_DBG(...) printf(__VA_ARGS__)
#else
    #define PRINTF_DBG(...)
#endif

void UARTInit (void){
    volatile uint32_t* ieReg = (uint32_t*)(UART_IE_ADDR);
    volatile uint32_t* imReg = (uint32_t*)(UART_IM_ADDR);
    PRINTF_DBG("UARTInit called: imReg = %p\n", *imReg);
    *ieReg |= UART_RXTO_I;
    PRINTF_DBG("UARTInit set: imReg = %p\n", *imReg);

}

void UARTWrite (const uint8_t* data, uint32_t size){
    volatile uint32_t* statusReg = (uint32_t*)(UART_STATUS_ADDR);
    volatile uint8_t* fifoReg = (uint8_t*)(UART_FIFO_ADDR);
    if (size == 0){
        return;
    }
    if (data == NULL){
        return;
    }
    while(!(*statusReg & UART_TXEMPTY)); // wait until the TX FIFO is empty
    for (uint32_t i = 0; i < size; ++i){
        (*fifoReg) = data[i];
        while((*statusReg & UART_TXFULL)); // wait until the TX FIFO is full
    }
}

__attribute__((naked, optimize("O0")))
static void __waitUs(uint32_t us) {
    __asm__(
        "beqz a0, fine\n\t"
        "addi a0, a0, -1\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "j __waitUs\n\t"
        "fine:\n\t"
        "ret\n\t"
    );
}

__attribute__((optimize("O0")))
uint16_t UARTRead (uint8_t* data, uint32_t size, UARTReadMode_t mode) {
    volatile uint32_t* statusReg    = (uint32_t*)(UART_STATUS_ADDR);
    volatile uint8_t*  fifoReg      = (uint8_t*) (UART_FIFO_ADDR);
    volatile uint8_t*  rtrigReg     = (uint8_t*) (UART_RTRIG_ADDR);
    volatile uint32_t* rxTimeoutReg = (uint32_t*)(UART_RXTO_ADDR);
    volatile uint32_t* iStatusReg   = (uint32_t*)(UART_INT_STS_ADDR);

    PRINTF_DBG("\nUARTRead called with: %d bytes\n", size);

    if (size == 0 || data == NULL) {
        errno = EINVAL;
        PRINTF_DBG("UARTRead returned: EINVAL\n");
        return -1;
    }
    uint32_t totalRead = 0;

    if (mode == UART_READ_WAIT_NONZERO){
        // Attendi i dati e restisci solo se qualcosa è disponibile
        while ((*statusReg & UART_RXEMPTY));
        while (!(*statusReg & UART_RXEMPTY)){
            *(data++) = *fifoReg; // Leggi i dati disponibili
            ++totalRead;
            if (totalRead >= size) {
                break; // Se abbiamo letto abbastanza, esci
            }
            __waitUs(100); // Attendi un po' per essere sicuri che i dati siano pronti
        }
        PRINTF_DBG("UARTRead returned: %d bytes\n", totalRead);
        return totalRead; // ritorna quanto letto fino ad ora
    }

    while (totalRead < size) {
        uint32_t chunkSize = size - totalRead;

        if (chunkSize > 63) {
            chunkSize = 63; // Al massimo 63 byte per volta
        }

        *rtrigReg = (mode == UART_READ_NONBLOCKING) ? 63 : chunkSize;
        *rxTimeoutReg = (mode == UART_READ_NONBLOCKING) ? 255 : 0;

        uint32_t i = 0;
        while (i < chunkSize) {
            while ((*statusReg & UART_RXEMPTY)) {
                if (mode == UART_READ_NONBLOCKING) {
                    // errno = EAGAIN;
                    PRINTF_DBG("UARTRead returned: EAGAIN -> readed: 0 bytes\n");
                    *iStatusReg = 0;
                    return 0; // ritorna quanto letto fino ad ora
                }
            }

            // Ora almeno un byte disponibile
            data[totalRead + i] = *fifoReg;
            i++;
        }

        totalRead += i;

        // Se siamo in modalità non bloccante, leggiamo solo una volta!
        if (mode == UART_READ_NONBLOCKING) {
            break;
        }
    }
    PRINTF_DBG("UARTRead returned: %d bytes\n", totalRead);
    return totalRead;
}

void UARTPrint(const char* str){
    while(*str){
        UARTWrite((uint8_t*)str, 1);
        ++str;
    }
}

