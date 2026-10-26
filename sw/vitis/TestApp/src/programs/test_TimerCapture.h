#ifndef BTPU0_IO0_MEMORY_ADDR
	#define BTPU0_IO0_MEMORY_ADDR 0x4001000C
#endif

#ifndef BTPU0_W_MEMORY_ADDR
	#define BTPU0_W_MEMORY_ADDR 0x40010010
#endif

#ifndef BTPU0_IO1_MEMORY_ADDR
	#define BTPU0_IO1_MEMORY_ADDR 0x40010008
#endif

#ifndef BTPU0RegFile_ADDR
	#define BTPU0RegFile_ADDR 0x40010014
#endif

#ifndef resultsTestCapture_ADDR
	#define resultsTestCapture_ADDR 0x40010020
#endif

#ifndef Timer0RegFile_ADDR
	#define Timer0RegFile_ADDR 0x40010018
#endif

#include <stdint.h>

#define test_TimerCapture_TEXT_ADDR 0x40000000
#define test_TimerCapture_TEXT_SIZE 700
// .const section non trovata
#define test_TimerCapture_BSS_ADDR 0x40010020
#define test_TimerCapture_BSS_SIZE 16
#define test_TimerCapture_DATA_ADDR 0x40010008
#define test_TimerCapture_DATA_SIZE 20

const uint32_t test_TimerCapture_text[] = {
    0x00010197,
    0x01c18193,
    0x00020117,
    0xff810113,
    0x400102b7,
    0x0002a503,
    0x0042a583,
    0x00000097,
    0x008080e7,
    0xff010113,
    0x00112623,
    0x00812423,
    0x00912223,
    0x01212023,
    0x0f4000ef,
    0xffc1a503,
    0x00100593,
    0x200000ef,
    0xffc1a503,
    0x00000593,
    0x210000ef,
    0xffc1a503,
    0x00100593,
    0x00418913,
    0x224000ef,
    0xffc1a503,
    0x00000593,
    0x234000ef,
    0xff81a503,
    0x00100693,
    0x00000613,
    0x00000593,
    0x0f4000ef,
    0xffc1a703,
    0x00000613,
    0x01e00593,
    0x00072783,
    0x0017e793,
    0x00f72023,
    0xff81a503,
    0x00100713,
    0x00070693,
    0x0dc000ef,
    0xff81a503,
    0x160000ef,
    0xffc1a503,
    0x17c000ef,
    0x00a92023,
    0xff81a503,
    0x00b92223,
    0x00100693,
    0x00000613,
    0x00000593,
    0x0a0000ef,
    0xffc1a703,
    0x00100693,
    0x00000613,
    0x00072783,
    0x01e00593,
    0x0017e793,
    0x00f72023,
    0xff81a503,
    0x00000713,
    0x088000ef,
    0xff81a503,
    0x10c000ef,
    0xffc1a503,
    0x128000ef,
    0xff81a703,
    0x00a92423,
    0x00b92623,
    0x00072783,
    0x0087e793,
    0x00f72023,
    0x0000006f,
    0xff41a883,
    0xff01a803,
    0xfec1a503,
    0x00000713,
    0x00000793,
    0x02000613,
    0x00e885b3,
    0x00f5a023,
    0x00078693,
    0x00e805b3,
    0x00178793,
    0x00f5a023,
    0x00268693,
    0x00e505b3,
    0x00d5a023,
    0x00470713,
    0xfcc79ce3,
    0x00008067,
    0x00b52223,
    0x00c52423,
    0x00d52623,
    0x00008067,
    0x00050793,
    0x00052503,
    0x00155513,
    0x00157513,
    0x06051a63,
    0x0007a803,
    0x00685813,
    0x00187813,
    0x06081463,
    0x0007a503,
    0x00167613,
    0x00561613,
    0xfdf57513,
    0x00c56633,
    0x00c7a023,
    0x0007a603,
    0x00177713,
    0x00271713,
    0xffb67613,
    0x00e66733,
    0x00e7a023,
    0x02b7a023,
    0x0007a703,
    0x0016f693,
    0x00469693,
    0xfef77713,
    0x00d76733,
    0x00e7a023,
    0x0007a703,
    0x00100513,
    0x00176713,
    0x00e7a023,
    0x00008067,
    0x00000513,
    0x00008067,
    0x00052783,
    0x0017d793,
    0x0017f793,
    0xfe079ae3,
    0x00052503,
    0x00655513,
    0x00157513,
    0x00154513,
    0x00008067,
    0x00050793,
    0x00c52503,
    0x0107a583,
    0x00008067,
    0x00052783,
    0x0035f593,
    0x00259593,
    0xff37f793,
    0x00b7e7b3,
    0x00f52023,
    0x00008067,
    0x00052783,
    0xfffff737,
    0x0015f593,
    0x7ff70713,
    0x00b59593,
    0x00e7f7b3,
    0x00b7e7b3,
    0x00f52023,
    0x00008067,
    0x00052783,
    0x0015f593,
    0x00959593,
    0xdff7f793,
    0x00b7e7b3,
    0x00f52023,
    0x00008067,
    0x00052783,
    0x01f5f593,
    0x00459593,
    0xe0f7f793,
    0x00b7e7b3,
    0x00f52023,
    0x00008067,
    0
};

// Nessun dato nella sezione .const

const uint32_t test_TimerCapture_data[] = {
    0x400c0000,
    0x400a0000,
    0x40080000,
    0x40020030,
    0x40020060,
    0
};

