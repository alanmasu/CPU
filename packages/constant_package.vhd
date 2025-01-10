
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
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
end package ;