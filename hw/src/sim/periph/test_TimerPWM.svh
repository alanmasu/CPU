`define test_TimerPWM_TEXT_ADDR 32'h40000000
`define test_TimerPWM_TEXT_SIZE 152
`define test_TimerPWM_DATA_ADDR 32'h40010008
`define test_TimerPWM_DATA_SIZE 4
`define GLOBAL_POINTER_VAL 32'h4001000a

logic [31:0] test_TimerPWM_text [] = '{
    32'h00010197,
    32'h00a18193,
    32'h00020117,
    32'hff810113,
    32'h400102b7,
    32'h0002a503,
    32'h0042a583,
    32'h00000097,
    32'h008080e7,
    32'hff010113,
    32'h00812423,
    32'hffe1a503,
    32'h00200593,
    32'h00112623,
    32'h030000ef,
    32'hffe1a503,
    32'h00000713,
    32'h0c800693,
    32'h04200593,
    32'h00000613,
    32'h034000ef,
    32'hffe1a703,
    32'h00072783,
    32'h0017e793,
    32'h00f72023,
    32'h0000006f,
    32'h00052783,
    32'h0035f593,
    32'h00259593,
    32'hff37f793,
    32'h00b7e7b3,
    32'h00f52023,
    32'h00008067,
    32'h00d52623,
    32'h00e52823,
    32'h00b52a23,
    32'h00c52c23,
    32'h00008067,
    32'h00000000
};

// Nessun dato nella sezione const
logic [31:0] test_TimerPWM_data [] = '{
    32'h40020060,
    32'h00000000
};

