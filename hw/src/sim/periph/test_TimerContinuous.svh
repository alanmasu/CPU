`define test_TimerContinuous_TEXT_ADDR 32'h40000000
`define test_TimerContinuous_TEXT_SIZE 216
`define test_TimerContinuous_DATA_ADDR 32'h40010008
`define test_TimerContinuous_DATA_SIZE 4
`define GLOBAL_POINTER_VAL 32'h4001000a

logic [31:0] test_TimerContinuous_text [] = '{
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
    32'h00000593,
    32'h00112623,
    32'h084000ef,
    32'hffe1a503,
    32'h00000593,
    32'h00000613,
    32'h058000ef,
    32'hffe1a703,
    32'h00072783,
    32'h0017e793,
    32'h00f72023,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'h00000013,
    32'hffe1a503,
    32'h00052783,
    32'h0027e793,
    32'h00f52023,
    32'h018000ef,
    32'h00a12023,
    32'h0000006f,
    32'h00b52223,
    32'h00c52423,
    32'h00008067,
    32'h00050793,
    32'h00452503,
    32'h0087a583,
    32'h00008067,
    32'h00052783,
    32'h0035f593,
    32'h00259593,
    32'hff37f793,
    32'h00b7e7b3,
    32'h00f52023,
    32'h00008067,
    32'h00000000
};

// Nessun dato nella sezione const
logic [31:0] test_TimerContinuous_data [] = '{
    32'h40020060,
    32'h00000000
};

