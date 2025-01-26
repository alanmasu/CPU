#ifndef __MAIN_H__
#define __MAIN_H__

#include <stdint.h>
#include <stdbool.h>

extern volatile uint32_t _edata;
extern volatile uint32_t _ebss;
extern volatile uint32_t _econst;

int main(int argc, char const *argv[]) __attribute__((section(".text.main")));


#endif