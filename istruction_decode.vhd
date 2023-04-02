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
    Port ( re : in STD_LOGIC;
           we : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (31 downto 0);
           npc : in STD_LOGIC_VECTOR (9 downto 0);
           write_data : in STD_LOGIC_VECTOR (31 downto 0);
           write_add : in STD_LOGIC_VECTOR (4 downto 0);
           rs1_value : out STD_LOGIC_VECTOR (31 downto 0);
           rs2_value : out STD_LOGIC_VECTOR (31 downto 0);
           immediate : out STD_LOGIC_VECTOR (31 downto 0);
           alu_opcode : out STD_LOGIC_VECTOR (0 downto 0)
     );
end istruction_decode;

architecture Behavioral of istruction_decode is



begin


end Behavioral;
