#include <UART.h>

void UARTWrite (const uint8_t* data, uint32_t size){
    uint32_t* statusReg = (uint32_t*)(UART_STATUS_ADDR);
    uint8_t* fifoReg = (uint8_t*)(UART_FIFO_ADDR);
    if (size == 0){
        return;
    }
    if (data == NULL){
        return;
    }
    for (uint32_t i = 0; i < size; ++i){
        while((*statusReg & UART_TXFULL)); // wait until the TX FIFO is not full
        (*fifoReg) = data[i];
    }
}

void UARTRead (uint8_t* data, uint32_t size){
    uint32_t* statusReg = (uint32_t*)(UART_STATUS_ADDR);
    uint8_t* fifoReg = (uint8_t*)(UART_FIFO_ADDR);
    if (size == 0){
        return;
    }
    if (data == NULL){
        return;
    }
    for (uint32_t i = 0; i < size; ++i){
        while((*statusReg & UART_RXEMPTY)); // wait until the RX FIFO is not empty
        data[i] = (*fifoReg);
    }
}