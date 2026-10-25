/**!
 * @file    UART.h
 * @brief   UART Library
 *
 * @details This library is used to communicate with UART devices on the RISC-V,
 *          it uses the UART0 peripheral of the PL.
 *
 * @author  Alan Masutti (@alanmasu)
 * @date    30/03/2025
 *
*/

#ifndef __UART_H__
#define __UART_H__

#include <stdint.h>
#include <stdbool.h>

//* UART peripheral base address
#define UART_BASE_ADDR      0xE0001000
//* UART Interrupt Enable Register for enabling interrupts (WRITE only)
#define UART_IE_ADDR        0xE0001008
//* UART Interrupt Mask Register for check interrupt enabled (READ only)
#define UART_IM_ADDR        0xE0001010
//* UART Interrupt Status Register for check interrupt status (READ only)
#define UART_INT_STS_ADDR   0xE0001014
//* UART RX FIFO Timeout Register for setting the timeout value (WRITE only)
#define UART_RXTO_ADDR      0xE000101C
//* UART TX FIFO Register
#define UART_FIFO_ADDR      0xE0001030
//* UART RX FIFO Trigger Register for setting the RX FIFO trigger level (WRITE only)
#define UART_RTRIG_ADDR     0xE0001020
//* UART STATUS Register
#define UART_STATUS_ADDR    0xE000102C

//* UART RX FIFO TRIG Interrupt bit
#define UART_RXTRIG_I (1 << 0)
//* UART RX FIFO EMPTY Interrupt bit
#define UART_RXEMPTY_I (1 << 1)
//* UART RX FIFO FULL Interrupt bit
#define UART_RXFULL_I (1 << 2)
//* UART RX FIFO OVR Interrupt bit
#define UART_RXOVR_I (1 << 5)
//* UART RX FIFO TO Interrupt bit
#define UART_RXTO_I (1 << 8)


//* UART TX FIFO full bit
#define UART_TXFULL (1 << 4)
//* UART TX FIFO empty bit
#define UART_TXEMPTY (1 << 3)
//* UART RX FIFO full bit
#define UART_RXFULL (1 << 2)
//* UART RX FIFO empty bit
#define UART_RXEMPTY (1 << 1)
//* UART RX FIFO over RTRIG value
#define UART_RXOVR (1 << 0)

#define UART_INT_STS_RXTIMEOUT (1 << 8)

#ifndef NULL
  #define NULL ((void*)0)
#endif


typedef enum UARTReadMode_t{
  UART_READ_BLOCKING,
  UART_READ_WAIT_NONZERO,
  UART_READ_NONBLOCKING
} UARTReadMode_t;

/**!
 * @brief Initialize the UART
 *
 * @details This function initializes the UART peripheral,
 *          it sets the interrupts enable.
 *
 * @return none
 */
void UARTInit (void);

/**!
 * @brief Write row data to the UART
 *
 * @details This function checks if the TX FIFO is full,
 *          if it is, the function wait until it is not full and then write the data until the size is reached.
 *
 * @param[in] data The data to write
 * @param size The size of the data
 *
 * @return none
 */
void UARTWrite (const uint8_t* data, uint32_t size);

/**!
 * @brief Read row data from the UART
 *
 * @details This function checks if the RX FIFO is empty,
 *          if it is, the function wait until it is not empty and then read the data until the size is reached.
 *
 * @param[out] data The data to read
 * @param size The size of the data
 * @param mode The read mode (blocking or non-blocking)
 *
 * @return The number of bytes read
 */
uint16_t UARTRead (uint8_t* data, uint32_t size, UARTReadMode_t mode);

/**!
 * @brief Print a string to the UART
 *
 * @param[in] str The string to print
 *
 * @return none
 */
void UARTPrint(const char* str);

#endif // __UART_H__
