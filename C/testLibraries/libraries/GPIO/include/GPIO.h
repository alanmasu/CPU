/**!
 * @file    GPIO.h
 * @brief   GPIO Library
 * 
 * @details This library is used to control the GPIO pins on the RISC-V,
 *          it uses the GPIO0 peripheral.
 * 
 * @author  Alan Masutti (@alanmasu)
 * @date    30/03/2025
*/

#ifndef __GPIO_H__
#define __GPIO_H__

#include <stdint.h>
#include <stdbool.h>

#define GPIO0_PORT_ADDR          0x40020000
#define GPIO0_PORT_DIR_ADDR      0x40020004
#define GPIO0_PORT_DATA_ADDR     0x40020008

#define GPIO0_PORT_A_ADDR        0x40020000
#define GPIO0_PORT_A_DIR_ADDR    0x40020004
#define GPIO0_PORT_A_DATA_ADDR   0x40020008

#define GPIO0_PORT_B_ADDR        0x40020001
#define GPIO0_PORT_B_DIR_ADDR    0x40020005
#define GPIO0_PORT_B_DATA_ADDR   0x40020009

#define GPIO0_PORT_C_ADDR        0x40020002
#define GPIO0_PORT_C_DIR_ADDR    0x40020006
#define GPIO0_PORT_C_DATA_ADDR   0x4002000A

#define GPIO0_PORT_D_ADDR        0x40020003
#define GPIO0_PORT_D_DIR_ADDR    0x40020007
#define GPIO0_PORT_D_DATA_ADDR   0x4002000B

#define PIN0 0b00000001
#define PIN1 0b00000010
#define PIN2 0b00000100
#define PIN3 0b00001000
#define PIN4 0b00010000
#define PIN5 0b00100000
#define PIN6 0b01000000
#define PIN7 0b10000000

#define INPUT   0
#define OUTPUT  1

typedef struct __attribute__((packed)) GPIOReg_t{
    unsigned int GPIO0 : 1;
    unsigned int GPIO1 : 1;
    unsigned int GPIO2 : 1;
    unsigned int GPIO3 : 1;
    unsigned int GPIO4 : 1;
    unsigned int GPIO5 : 1;
    unsigned int GPIO6 : 1;
    unsigned int GPIO7 : 1;
} GPIOReg_t;

typedef struct __attribute__((packed)) GPIOPort_t{
    GPIOReg_t PORT_A;
    GPIOReg_t PORT_B;
    GPIOReg_t PORT_C;
    GPIOReg_t PORT_D;
} GPIOPort_t;

typedef struct __attribute__((packed)) GPIODir_t{
    GPIOReg_t PORT_A_DIR;
    GPIOReg_t PORT_B_DIR;
    GPIOReg_t PORT_C_DIR;
    GPIOReg_t PORT_D_DIR;
} GPIODir_t;

typedef struct __attribute__((packed)) GPIOData_t{
    GPIOReg_t PORT_A_DATA;
    GPIOReg_t PORT_B_DATA;
    GPIOReg_t PORT_C_DATA;
    GPIOReg_t PORT_D_DATA;
} GPIOData_t;

/**!
 * @brief Read the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pinN The number of the pin in the port
 * 
 * @return The value of the pin
 * 
*/
uint8_t gpioReadByNum(const uint8_t* port, uint8_t pinN);

/**!
 * @brief Read the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * 
 * @return The value of the pin
 * 
*/
uint8_t gpioRead(const uint8_t* port, uint8_t pin);

/**!
 * @brief Set the direction of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * @param[in] dir The direction of the pin
 * 
*/
void gpioSetDir(uint8_t* port, uint8_t pin, bool dir);

/**!
 * @brief Get the direction of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * 
 * @return The direction of the pin
 * 
*/
uint8_t gpioGetDir(const uint8_t* port, uint8_t pin);

/**!
 * @brief Set the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pinN The number of the pin in the port
 * @param[in] data The value of the pin
 * 
 * @return none
*/
void gpioSetValueByNum(uint8_t* port, uint8_t pinN, bool data);

/**!
 * @brief Get the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pinN The number of the pin in the port
 * 
 * @return The value of the pin
 * 
*/
uint8_t gpioGetValueByNum(const uint8_t* port, uint8_t pinN);

/**!
 * @brief Set the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * @param[in] data The value of the pin
 * 
 * @return none
*/
void gpioSetValue(uint8_t* port, uint8_t pin, bool data);

/**!
 * @brief Get the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * 
 * @return The value of the pin
 * 
*/
uint8_t gpioGetValue(const uint8_t* port, uint8_t pin);

/**!
 * @brief Toggle the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * 
 * @return none
*/
void gpioToggle(uint8_t* port, uint8_t pin);

/**!
 * @brief Set the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * 
 * @return none
*/
void gpioSet(uint8_t* port, uint8_t pin);

/**!
 * @brief Clear the value of a pin in a port
 * 
 * @param[in] port The address of the port
 * @param[in] pin The mask of the pin in the port
 * 
 * @return none
*/
void gpioClear(uint8_t* port, uint8_t pin);


extern volatile GPIOPort_t* GPIO0Port;
extern volatile GPIODir_t*  GPIO0Dir;
extern volatile GPIOData_t* GPIO0Data;

#endif // __GPIO_H__