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
        if get_popcount_levels(3) /= 0 then
            report "Test #1 FAILED";
        else
            report "Test #1 PASSED";
        end if;

        if get_popcount_levels(6) /= 1 then
            report "Test #2 FAILED";
        else
            report "Test #2 PASSED";
        end if;
        
        if get_popcount_levels(7) /= 1 then
            report "Test #3 FAILED";
        else
            report "Test #3 PASSED";
        end if;
        
        if get_popcount_levels(18) /= 1 then
            report "Test #4 FAILED";
        else
            report "Test #4 PASSED";
        end if;

        if get_popcount_levels(19) /= 2 then
            report "Test #5 FAILED";
        else
            report "Test #5 PASSED";
        end if;
        if get_popcount_levels(36) /= 2 then
            report "Test #6 FAILED";
        else
            report "Test #6 PASSED";
        end if;

        if get_popcount_levels(37) /= 3 then
            report "Test #7 FAILED";
        else
            report "Test #7 PASSED";
        end if;
        if get_popcount_levels(72) /= 3 then
            report "Test #8 FAILED";
        else
            report "Test #8 PASSED";
        end if;

        if get_popcount_levels(73) /= 4 then
            report "Test #9 FAILED";
        else
            report "Test #9 PASSED";
        end if;
        if get_popcount_levels(128) /= 4 then
            report "Test #10 FAILED";
        else
            report "Test #10 PASSED";
        end if;

        -- report "level(3): " & integer'image(get_popcount_levels(3));
        -- report "level(6): " & integer'image(get_popcount_levels(6));
        -- report "level(7): " & integer'image(get_popcount_levels(7));
        -- report "level(18): " & integer'image(get_popcount_levels(18));
        -- report "level(19): " & integer'image(get_popcount_levels(19));
        -- report "level(36): " & integer'image(get_popcount_levels(36));
        -- report "level(37): " & integer'image(get_popcount_levels(37));
        -- report "level(72): " & integer'image(get_popcount_levels(72));
        -- report "level(72): " & integer'image(get_popcount_levels(73));
        -- report "level(128): " & integer'image(get_popcount_levels(128));
        wait;
    end process;
end Behavioral;