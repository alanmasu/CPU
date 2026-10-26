#ifndef __SIMPLE_UART_H__
#define __SIMPLE_UART_H__

#include <stdint.h>


#define UART_BASE 0xE0001000

const uint32_t simpleUART[] = {
    0xe00012b7,
    0x06300313,
    0x06900393,
    0x06100e13,
    0x06f00e93,
    0x00a00f13,
    0x00d00f93,
    0x0262a823,
    0x03c000ef,
    0x0272aa23,
    0x034000ef,
    0x03c2ac23,
    0x02c000ef,
    0x03d2ae23,
    0x024000ef,
    0x05e2a023,
    0x01c000ef,
    0x05f2a223,
    0x014000ef,
    0x400012b7,
    0x00200313,
    0x0062a023,
    0x0000006f,
    0xfe042e23,
    0x0100006f,
    0xffc42783,
    0x00178793,
    0xfef42e23,
    0xffc42703,
    0x07800793,
    0xfee7d6e3,
    0x00008067,
    0
};



#endif // __SIMPLE_UART_H__
