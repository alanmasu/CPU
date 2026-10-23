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

#define UART_BASE_ADDR      0xE0001000
#define UART_INT_STS_ADDR   0xE0001014
#define UART_FIFO_ADDR      0xE0001030
#define UART_RTRIG_ADDR     0xE0001020
#define UART_STATUS_ADDR    0xE000102C

//* UART TX FIFO full bit
#define UART_TXFULL (1 << 4)
//* UART TX FIFO empty bit
#define UART_TXEMPTY (1 << 3)
//* UART RX FIFO full bit
#define UART_RXFULL (1 << 2)
//* UART RX FIFO empty bit
#define UART_RXEMPTY (1 << 1)

#define UART_INT_STS_RXTIMEOUT (1 << 8)

#ifndef NULL
  #define NULL ((void*)0)
#endif

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
 * 
 * @return none
 */
void UARTRead (uint8_t* data, uint32_t size);

/**!
 * @brief Print a string to the UART
 * 
 * @param[in] str The string to print
 * 
 * @return none
 */
void UARTPrint(const char* str);

#endif // __UART_H__