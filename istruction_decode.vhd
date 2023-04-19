----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 16:51:07
-- Design Name: 
-- Module Name: istruction_decode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity istruction_decode is
    Port ( clk, res : in STD_LOGIC;
           we : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (31 downto 0);
           pc, npc : in STD_LOGIC_VECTOR (9 downto 0);
           rd_value : in STD_LOGIC_VECTOR (31 downto 0);
           rd_addr : in STD_LOGIC_VECTOR (4 downto 0);
           rs1_value, rs2_value: out STD_LOGIC_VECTOR (31 downto 0);
           immediate : out STD_LOGIC_VECTOR (31 downto 0);
           alu_opcode : out STD_LOGIC_VECTOR (3 downto 0);
           comparator_opcode : out std_logic_vector(2 downto 0)
     );
end istruction_decode;

architecture Behavioral of istruction_decode is
    signal rs1, rs2: std_logic_vector(31 downto 0);
    signal rs1_addr, rs2_addr : STD_LOGIC_VECTOR (4 downto 0);
begin
    register_file: entity work.triple_port_ram
    port map(
        addr_in => rd_addr,
        d_in => rd_value,
        d_out1 => rs1_value,
        d_out2 => rs2_value,
        addr_out1 => rs1_addr,
        addr_out2 => rs2_addr, 
        clk => clk,
        res => res,
        we => we
    );


end Behavioral;
