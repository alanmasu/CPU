#ifndef timerValue_ADDR
	#define timerValue_ADDR 0x40010010
#endif

#ifndef Timer0RegFile_ADDR
	#define Timer0RegFile_ADDR 0x40010008
#endif

#include <stdint.h>

#define test_TimerContinuous_TEXT_ADDR 0x40000000
#define test_TimerContinuous_TEXT_SIZE 220
// .const section non trovata
#define test_TimerContinuous_BSS_ADDR 0x40010010
#define test_TimerContinuous_BSS_SIZE 8
#define test_TimerContinuous_DATA_ADDR 0x40010008
#define test_TimerContinuous_DATA_SIZE 4

const uint32_t test_TimerContinuous_text[] = {
    0x00010197,
    0x01018193,
    0x00020117,
    0xff810113,
    0x400102b7,
    0x0002a503,
    0x0042a583,
    0x00000097,
    0x008080e7,
    0xff010113,
    0x00812423,
    0xff81a503,
    0x00000593,
    0x00112623,
    0x088000ef,
    0xff81a503,
    0x00000593,
    0x00000613,
    0x05c000ef,
    0xff81a703,
    0x00072783,
    0x0017e793,
    0x00f72023,
    0x00000013,
    0x00000013,
    0x00000013,
    0x00000013,
    0x00000013,
    0x00000013,
    0x00000013,
    0x00000013,
    0x00000013,
    0x00000013,
    0xff81a503,
    0x00052783,
    0x0027e793,
    0x00f52023,
    0x01c000ef,
    0x00a1a023,
    0x00b1a223,
    0x0000006f,
    0x00b52223,
    0x00c52423,
    0x00008067,
    0x00050793,
    0x00452503,
    0x0087a583,
    0x00008067,
    0x00052783,
    0x0035f593,
    0x00259593,
    0xff37f793,
    0x00b7e7b3,
    0x00f52023,
    0x00008067,
    0
};

// Nessun dato nella sezione .const

const uint32_t test_TimerContinuous_data[] = {
    0x40020060,
    0
};

