/*!
    @file       main.h
    @brief      Main header file for the project.
    @details    This file contains the main function and initializes the system.

*/

#ifndef __MAIN_H__
#define __MAIN_H__

#include <stdint.h>
#include <stdbool.h>

#ifdef MY_RISCV
int main(int argc, char const *argv[]) __attribute__((section(".text.main")));
#endif

#endif