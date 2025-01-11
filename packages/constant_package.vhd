
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
    constant CREG_RUN : integer := 0;
    constant CREG_RUN_BIT : integer := 0;

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