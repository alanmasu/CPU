#ifndef __UTILITIES_H__
#define __UTILITIES_H__

#include <stdint.h>
#include <stdbool.h>

#define DISPLAY_BASE_ADDR 0x40001018
#define DELAY_COUNT 1250000

int strcmp(const char* str1, const char* str2);

void wait(uint32_t time);



#endif
