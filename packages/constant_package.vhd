
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.types_pkg.all;

package constant_package is

    -- OP CODES
    constant opcode_lui : std_logic_vector(6 downto 0) :=    "0110111"; 
    constant opcode_auipc : std_logic_vector(6 downto 0) :=  "0010111"; 
    constant opcode_jal : std_logic_vector(6 downto 0) :=    "1101111"; 
    constant opcode_jalr : std_logic_vector(6 downto 0) :=   "1100111"; 
    constant opcode_brench : std_logic_vector(6 downto 0) := "1100011"; 
    constant opcode_load : std_logic_vector(6 downto 0) :=   "0000011"; 
    constant opcode_store : std_logic_vector(6 downto 0) :=  "0100011"; 
    constant opcode_alu_imm_op : std_logic_vector(6 downto 0) := "0010011";
    constant opcode_alu_op : std_logic_vector(6 downto 0) := "0110011";

    -- Control Registers
    constant CREG_CTR               : integer := 0;
        constant CREG_RUN_BIT       : integer := 0;
        constant CREG_RES_BIT       : integer := 1;
        constant CREG_RUN_C_BIT     : integer := 2;

    constant CREG_PC                : integer := 1;
    constant CREG_STATE             : integer := 2;
    constant CREG_INST              : integer := 3;

    constant CREG_IO                : integer := 4;
        constant CREG_BTN_UP_BIT    : integer := 0;
        constant CREG_BTN_DOWN_BIT  : integer := 1;
        constant CREG_BTN_LEFT_BIT  : integer := 2;
        constant CREG_BTN_RIGHT_BIT : integer := 3;
        constant CREG_LED0_BIT      : integer := 24;
        constant CREG_LED1_BIT      : integer := 25;
        constant CREG_LED2_BIT      : integer := 26;

    constant CREG_OLED_CTR          : integer := 5;
        constant CREG_OLED_SELECT_BIT1 : integer := 0;
        constant CREG_OLED_SELECT_BIT2 : integer := 1;
        
    constant CREG_OLED_DATA         : integer := 6;

    -- Registers Reset Values
    constant CREG_RESET_VALUE : control_reg_t := (
        0  => x"00000002", -- CREG_CTR [2:0] = run_val [R] | res_val [R|W] | run_c_val [R/W]
        1  => x"00000000", -- CREG_PC
        2  => x"00000000", -- CREG_STATE
        3  => x"00000000", -- CREG_INST
        4  => x"00000000", -- CREG_IO [31:29] = [LEDs] | CREG_IO[3:0] = BTN_R | BTN_L | BTN_D | BTN_U
        5  => x"00000000", -- CREG_OLED_CTR [1:0] = oled_select [2:1] 
        6  => x"00000000", -- CREG_OLED_DATA
        7  => x"00000000", --
        8  => x"00000000", --
        9  => x"00000000", --
        10 => x"00000000", --
        11 => x"00000000", --
        12 => x"00000000", --
        13 => x"00000000", --
        14 => x"00000000", --
        15 => x"00000000", --
        16 => x"00000000", -- 
        17 => x"00000000", -- 
        18 => x"00000000", -- 
        19 => x"00000000", -- 
        20 => x"00000000", -- 
        21 => x"00000000", -- 
        22 => x"00000000", --
        23 => x"00000000", -- 
        24 => x"00000000", --
        25 => x"00000000", -- 
        26 => x"00000000", -- 
        27 => x"00000000", -- 
        28 => x"00000000", -- 
        29 => x"00000000", -- 
        30 => x"00000000",  -- 
        31 => x"00000000"  -- 
    );

    -- Registers Reset Values
    constant REG_FILE_RESET_VALUE : ram_array := (
        0  => x"00000000", -- x1/ra
        1  => x"40011FFC", -- x2/sp
        2  => x"00000000", -- x3/gp
        3  => x"00000000", -- x4/tp
        4  => x"00000000", -- x5/t0
        5  => x"00000000", -- x6/t1
        6  => x"00000000", -- x7/t2
        7  => x"40011FFC", -- x8/s0/fp
        8  => x"00000000", -- x9/s1
        9  => x"00000000", -- x10/a0
        10 => x"00000000", -- x11/a1
        11 => x"00000000", -- x12/a2
        12 => x"00000000", -- x13/a3
        13 => x"00000000", -- x14/a4
        14 => x"00000000", -- x15/a5
        15 => x"00000000", -- x16/a6
        16 => x"00000000", -- x17/a7
        17 => x"00000000", -- x18/s2
        18 => x"00000000", -- x19/s3
        19 => x"00000000", -- x20/s4
        20 => x"00000000", -- x21/s5
        21 => x"00000000", -- x22/s6
        22 => x"00000000", -- x23/s7
        23 => x"00000000", -- x24/s8
        24 => x"00000000", -- x25/s9
        25 => x"00000000", -- x26/s10
        26 => x"00000000", -- x27/s11
        27 => x"00000000", -- x28/t3
        28 => x"00000000", -- x29/t4
        29 => x"00000000", -- x30/t5
        30 => x"00000000"  -- x31/t6
    );
    constant PC_RESET_VALUE : std_logic_vector(31 downto 0) := x"40000000";
end package ;