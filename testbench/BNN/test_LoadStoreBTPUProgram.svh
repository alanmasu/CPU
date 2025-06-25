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
`define test_LoadStoreBTPU_TEXT_SIZE 108
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
    32'hfe010113,
    32'h00112e23,
    32'h00812c23,
    32'h02010413,
    32'hfea42623,
    32'hfeb42423,
    32'hffa1a783,
    32'h12345737,
    32'h67870713,
    32'h00e7a023,
    32'hffa1a783,
    32'h0007a703,
    32'h00e1a123,
    32'hffe1a783,
    32'h0007a703,
    32'h00876713,
    32'h00e7a023,
    32'h0000006f,
    32'h00000000
};

// Nessun dato nella sezione const
logic [31:0] test_LoadStoreBTPU_data [] = '{
    32'h400c0000,
    32'h40020030,
    32'h00000000
};

