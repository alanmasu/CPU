#include <GPIO.h>

#include <stdint.h>
#include <stdbool.h>

uint8_t gpioRead(const uint8_t* port, uint8_t pin){
    return *port & pin == pin;
}

void gpioSetDir(uint8_t* port, uint8_t pin, bool dir){
    if(dir == OUTPUT){
        *port = *port | pin;
    }else if(dir == INPUT){
        *port = *port & ~pin;
    }
}
uint8_t gpioGetDir(const uint8_t* port, uint8_t pin);

void gpioSetData(uint8_t* port, uint8_t pin, bool data){
    if(data == 1){
        *port = *port | pin;
    }else if(data == 0){
        *port = *port & ~pin;
    }
}
uint8_t gpioGetData(const uint8_t* port, uint8_t pin){
    return *port & pin;
}

void gpioToggle(uint8_t* port, uint8_t pin){
    *port = *port ^ pin;
}

void gpioSet(uint8_t* port, uint8_t pin){
    *port = *port | pin;
}

void gpioClear(uint8_t* port, uint8_t pin){
    *port = *port & ~pin;
}

GPIOPort_t* GPIO0Port = (GPIOPort_t*)GPIO0_PORT_ADDR;
GPIODir_t*  GPIO0Dir  = (GPIODir_t*) GPIO0_PORT_DIR_ADDR;
GPIOData_t* GPIO0Data = (GPIOData_t*)GPIO0_PORT_DATA_ADDR;