----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 17:19:54
-- Design Name: 
-- Module Name: execute - Behavioral
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

entity execute is
    Port ( rs1_value : in STD_LOGIC_VECTOR (31 downto 0);
           rs2_value : in STD_LOGIC_VECTOR (31 downto 0);
           immediate : in STD_LOGIC_VECTOR (31 downto 0);
           npc : in STD_LOGIC_VECTOR(9 downto 0);
           instruction : in STD_LOGIC_VECTOR (21 downto 0)
    );
end execute;

architecture Behavioral of execute is
    signal val1, val2, alu_resoult : std_logic_vector(31 downto 0);
    signal alu_opcode : std_logic_vector(3 downto 0);
    signal opcode : std_logic_vector(6 downto 0);
begin
    --ALU
    alu_opcode <= instruction(30) & instruction(14 downto 12);
    alu : entity work.alu
    port map(
        rs1 => val1,
        rs2 => val2, 
        alu_out => alu_resoult,
        opcode => alu_opcode
    );
    
    --Opcode
    opcode <= instruction(6 downto 0);


end Behavioral;
