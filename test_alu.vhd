----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.04.2023 09:38:31
-- Design Name: 
-- Module Name: test_alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_alu is
--  Port ( );
end test_alu;

architecture Behavioral of test_alu is
    signal rs1, rs2, resoult : std_logic_vector(31 downto 0) := (others => '0');
    signal opcode : std_logic_vector(3 downto 0) := (others => '0');
begin
    alu1: entity work.alu
    port map(
        rs1 => rs1,
        rs2 => rs2, 
        alu_out => resoult,
        opcode => opcode
    );
    test_process : process begin
        rs1 <= (0 => '1', others => '0');
        rs2 <= (0 => '1', others => '0'); 
        opcode <= "0000";
        wait for 10 ns;
        opcode <= "1000";
        wait for 10 ns;
        opcode <= "0001"; --SLL
        rs1 <= std_logic_vector(TO_UNSIGNED(1, 32));
        rs2 <= std_logic_vector(TO_UNSIGNED(1, 32)); 
        wait for 10 ns;
        --SR[A|L]
        opcode <= "0101"; 
        rs1 <= std_logic_vector(TO_UNSIGNED(-1, 32));
        rs2 <= std_logic_vector(TO_UNSIGNED(1, 32)); 
        wait for 10 ns;
        rs1 <= (31 => '1', others => '0');--std_logic_vector(TO_UNSIGNED(-1, 32));
        rs2 <= std_logic_vector(TO_UNSIGNED(1, 32)); 
        rs2(11) <= '1';   --SRA
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
