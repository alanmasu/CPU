`ifndef BTPU0_IO0_MEMORY_ADDR
	`define BTPU0_IO0_MEMORY_ADDR 32'h4001000C
`endif

`ifndef BTPU0_W_MEMORY_ADDR
	`define BTPU0_W_MEMORY_ADDR 32'h40010010
`endif

`ifndef results_ADDR
	`define results_ADDR 32'h40010020
`endif

`ifndef BTPU0_IO1_MEMORY_ADDR
	`define BTPU0_IO1_MEMORY_ADDR 32'h40010008
`endif

`ifndef BTPU0RegFile_ADDR
	`define BTPU0RegFile_ADDR 32'h40010014
`endif

`ifndef Timer0RegFile_ADDR
	`define Timer0RegFile_ADDR 32'h40010018
`endif

`define test_TimerCapture_TEXT_ADDR 32'h40000000
`define test_TimerCapture_TEXT_SIZE 652
`define test_TimerCapture_DATA_ADDR 32'h40010008
`define test_TimerCapture_DATA_SIZE 20
`define test_TimerCapture_BSS_ADDR 32'h40010020
`define test_TimerCapture_BSS_SIZE 16
`define GLOBAL_POINTER_VAL 32'h4001001c

logic [31:0] test_TimerCapture_text [] = '{
    32'h00010197,
    32'h01c18193,
    32'h00020117,
    32'hff810113,
    32'h400102b7,
    32'h0002a503,
    32'h0042a583,
    32'h00000097,
    32'h008080e7,
    32'hff010113,
    32'h00112623,
    32'h00812423,
    32'h00912223,
    32'h01212023,
    32'h0e8000ef,
    32'hffc1a503,
    32'h00100593,
    32'h1f4000ef,
    32'hffc1a503,
    32'h00100593,
    32'h204000ef,
    32'hffc1a503,
    32'h00000593,
    32'h00418913,
    32'h210000ef,
    32'hff81a503,
    32'h00100693,
    32'h00000613,
    32'h00000593,
    32'h0f4000ef,
    32'hffc1a703,
    32'h00000613,
    32'h01e00593,
    32'h00072783,
    32'h0017e793,
    32'h00f72023,
    32'hff81a503,
    32'h00100713,
    32'h00070693,
    32'h0dc000ef,
    32'hff81a503,
    32'h160000ef,
    32'hffc1a503,
    32'h17c000ef,
    32'h00a92023,
    32'hff81a503,
    32'h00b92223,
    32'h00100693,
    32'h00000613,
    32'h00000593,
    32'h0a0000ef,
    32'hffc1a703,
    32'h00100693,
    32'h00000613,
    32'h00072783,
    32'h01e00593,
    32'h0017e793,
    32'h00f72023,
    32'hff81a503,
    32'h00000713,
    32'h088000ef,
    32'hff81a503,
    32'h10c000ef,
    32'hffc1a503,
    32'h128000ef,
    32'hff81a703,
    32'h00a92423,
    32'h00b92623,
    32'h00072783,
    32'h0087e793,
    32'h00f72023,
    32'h0000006f,
    32'hff41a883,
    32'hff01a803,
    32'hfec1a503,
    32'h00000713,
    32'h00000793,
    32'h02000613,
    32'h00e885b3,
    32'h00f5a023,
    32'h00078693,
    32'h00e805b3,
    32'h00178793,
    32'h00f5a023,
    32'h00268693,
    32'h00e505b3,
    32'h00d5a023,
    32'h00470713,
    32'hfcc79ce3,
    32'h00008067,
    32'h00b52223,
    32'h00c52423,
    32'h00d52623,
    32'h00008067,
    32'h00050793,
    32'h00052503,
    32'h00155513,
    32'h00157513,
    32'h06051a63,
    32'h0007a803,
    32'h00685813,
    32'h00187813,
    32'h06081463,
    32'h0007a503,
    32'h00167613,
    32'h00561613,
    32'hfdf57513,
    32'h00c56633,
    32'h00c7a023,
    32'h0007a603,
    32'h00177713,
    32'h00271713,
    32'hffb67613,
    32'h00e66733,
    32'h00e7a023,
    32'h02b7a023,
    32'h0007a703,
    32'h0016f693,
    32'h00469693,
    32'hfef77713,
    32'h00d76733,
    32'h00e7a023,
    32'h0007a703,
    32'h00100513,
    32'h00176713,
    32'h00e7a023,
    32'h00008067,
    32'h00000513,
    32'h00008067,
    32'h00052783,
    32'h0017d793,
    32'h0017f793,
    32'hfe079ae3,
    32'h00052503,
    32'h00655513,
    32'h00157513,
    32'h00154513,
    32'h00008067,
    32'h00050793,
    32'h00c52503,
    32'h0107a583,
    32'h00008067,
    32'h00052783,
    32'h0035f593,
    32'h00259593,
    32'hff37f793,
    32'h00b7e7b3,
    32'h00f52023,
    32'h00008067,
    32'h00052783,
    32'h0015f593,
    32'h00959593,
    32'hdff7f793,
    32'h00b7e7b3,
    32'h00f52023,
    32'h00008067,
    32'h00052783,
    32'h01f5f593,
    32'h00459593,
    32'he0f7f793,
    32'h00b7e7b3,
    32'h00f52023,
    32'h00008067,
    32'h00000000
};

// Nessun dato nella sezione const
logic [31:0] test_TimerCapture_data [] = '{
    32'h400c0000,
    32'h400a0000,
    32'h40080000,
    32'h40020030,
    32'h40020060,
    32'h00000000
};

