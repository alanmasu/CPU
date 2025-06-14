`ifndef BTPU0_W_MEMORY_prt_ADDR
	`define BTPU0_W_MEMORY_prt_ADDR 32'h40010008
`endif

`ifndef BTPU0RegFile_ADDR
	`define BTPU0RegFile_ADDR 32'h4001000C
`endif

`ifndef value_ADDR
	`define value_ADDR 32'h40010010
`endif

`define test_LoadStoreBTPU_TEXT_ADDR 32'h40000000
`define test_LoadStoreBTPU_TEXT_SIZE 76
`define test_LoadStoreBTPU_DATA_ADDR 32'h40010008
`define test_LoadStoreBTPU_DATA_SIZE 8
`define test_LoadStoreBTPU_BSS_ADDR 32'h40010010
`define test_LoadStoreBTPU_BSS_SIZE 4
`define GLOBAL_POINTER_VAL 32'h4001000e

logic [31:0] test_LoadStoreBTPU_text [] = '{
    32'h00010197,
    32'h00e18193,
    32'h00020117,
    32'hff810113,
    32'h400102b7,
    32'h0002a503,
    32'h0042a583,
    32'h00000097,
    32'h008080e7,
    32'hffa1a703,
    32'h123457b7,
    32'h67878793,
    32'h00f72023,
    32'h00f1a123,
    32'hffe1a703,
    32'h00072783,
    32'h0087e793,
    32'h00f72023,
    32'h0000006f,
    32'h00000000
};

// Nessun dato nella sezione const
logic [31:0] test_LoadStoreBTPU_data [] = '{
    32'h400c0000,
    32'h40020030,
    32'h00000000
};