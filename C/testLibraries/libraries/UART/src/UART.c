#include <UART.h>

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

void UARTRead (uint8_t* data, uint32_t size){
    volatile uint32_t* statusReg    = (uint32_t*)(UART_STATUS_ADDR);
    volatile uint8_t*  fifoReg      = (uint8_t*) (UART_FIFO_ADDR);

    if (size == 0){
        return;
    }
    if (data == NULL){
        return;
    }
    for (uint32_t i = 0; i < size; ++i){
        while ((*statusReg & UART_RXEMPTY) == UART_RXEMPTY);
        data[i] = (*fifoReg);
    }
}