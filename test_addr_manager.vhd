----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2023 10:42:19 PM
-- Design Name: 
-- Module Name: test_addr_manager - Behavioral
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

entity test_addr_manager is
--  Port ( );
end test_addr_manager;

architecture Behavioral of test_addr_manager is
    signal addr : std_logic_vector(31 downto 0);
    signal en_in : std_logic;
    signal en_out : std_logic_vector(1 downto 0);
begin

    dut : entity work.address_manager
        port map (
            address => addr,
            en_in => en_in,
            en_out => en_out
        );

    test_pro : process   begin
        --AXI Address Space
        addr <= x"3FFFFFD0";
        en_in <= '1';
        wait for 10 ns;
        --AXI Address Space with en_in = 0
        addr <= x"3FFFFFD1";
        en_in <= '0'; 
        wait for 10 ns;

        --ROM Address Space
        addr <= x"4000FFFE";
        en_in <= '1';
        wait for 10 ns;
        addr <= x"4000FFFF";
        en_in <= '1';
        wait for 10 ns;

        --RAM Address Space
        addr <= x"40010000";
        en_in <= '1';
        wait for 10 ns;
        --RAM Address Space with en_in = 0
        addr <= x"40010001";
        en_in <= '0';
        wait for 10 ns;

        wait;
    end process ; -- test_pro
end Behavioral;
