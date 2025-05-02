----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 09:19:00
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.BNN_pkg.all;

entity testUtilities is
end entity;

architecture Behavioral of testUtilities is

begin
    process begin
        report "level: " & integer'image(get_popcount_levels(3));
        report "level: " & integer'image(get_popcount_levels(6));
        report "level: " & integer'image(get_popcount_levels(7));
        report "level: " & integer'image(get_popcount_levels(72));
        report "level: " & integer'image(get_popcount_levels(128));
        wait;
    end process;
end Behavioral;