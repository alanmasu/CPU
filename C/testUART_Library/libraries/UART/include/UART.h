#ifndef __UART_H__
#define __UART_H__

#include <stdint.h>
#include <stdbool.h>

#define UART_BASE_ADDR 0xE0001000
#define UART_FIFO_ADDR 0xE0001030
#define UART_STATUS_ADDR 0xE000102C

//* UART TX FIFO full bit
#define UART_TXFULL (1 << 4)
//* UART TX FIFO empty bit
#define UART_TXEMPTY (1 << 3)
//* UART RX FIFO full bit
#define UART_RXFULL (1 << 2)
//* UART RX FIFO empty bit
#define UART_RXEMPTY (1 << 1)

#ifndef NULL
  #define NULL ((void*)0)
#endif


void UARTWrite (const uint8_t* data, uint32_t size);

void UARTRead (uint8_t* data, uint32_t size);


#endif // __UART_H__