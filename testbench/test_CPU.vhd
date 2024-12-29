----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2023 10:35:44 PM
-- Design Name: 
-- Module Name: test_CPU - Behavioral
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

entity test_CPU is
--  Port ( );
end test_CPU;

architecture Behavioral of test_CPU is
    signal clk : std_logic := '0';
    signal res : std_logic := '0';

begin
    cpu : entity work.CPU
        port map (
            clk => clk,
            res => res
        );
    clk_gen: process begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    res_gen: process begin
        wait for 9 ns;
        res <= '1';
        wait;
    end process;

end Behavioral;
