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

library work;
use work.memory_pkg.all;
use work.types_pkg.all;
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
    signal en_out : en_bus_t;
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

        if(en_bus_t_to_slv(en_out) = "00000010") then
            report "Test 1 OK";
        else
            report "Test 1 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --AXI Address Space with en_in = 0
        addr <= x"3FFFFFD1";
        en_in <= '0'; 
        wait for 10 ns;

        if(en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 2 OK";
        else
            report "Test 2 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --ROM Address Space
        addr <= x"4000FFFE";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000010") then
            report "Test 3 OK";
        else
            report "Test 3 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --ROM Address Space with en_in = 0
        addr <= x"4000FFFF";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 4 OK";
        else
            report "Test 4 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --RAM Address Space
        addr <= x"40010000";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000001") then
            report "Test 5 OK";
        else
            report "Test 5 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --RAM Address Space with en_in = 0
        addr <= x"40010001";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 6 OK";
        else
            report "Test 6 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --GPIO Address Space
        addr <= x"40020000";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000100") then
            report "Test 7 OK";
        else
            report "Test 7 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --GPIO Address Space with en_in = 0
        addr <= x"40020001";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 8 OK";
        else
            report "Test 8 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --BTPU CREG Address Space
        addr <= x"4002_0030";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00010000") then
            report "Test 9a OK";
        else
            report "Test 9a FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;
        addr <= x"4002_004F";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00010000") then
            report "Test 9b OK";
        else
            report "Test 9b FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --BTPU CREG Address Space with en_in = 0
        addr <= x"4002_0030";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 10a OK";
        else
            report "Test 10a FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;
        addr <= x"4002_004F";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 10b OK";
        else
            report "Test 10b FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --BTPU W_MEM Address Space
        addr <= x"4003_0000";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00100000") then
            report "Test 11 OK";
        else
            report "Test 11 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --BTPU W_MEM Address Space with en_in = 0
        addr <= x"4003_0001";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 12 OK";
        else
            report "Test 12 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --BTPU IO0_MEM Address Space
        addr <= x"4004_0000";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "01000000") then
            report "Test 13 OK";
        else
            report "Test 13 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;
        --BTPU IO0_MEM Address Space with en_in = 0
        addr <= x"4004_0001";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 14 OK";
        else
            report "Test 14 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;

        --BTPU IO1_MEM Address Space
        addr <= x"4005_0000";
        en_in <= '1';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "10000000") then
            report "Test 15 OK";
        else
            report "Test 15 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;
        --BTPU IO1_MEM Address Space with en_in = 0
        addr <= x"4005_0001";
        en_in <= '0';
        wait for 10 ns;
        if (en_bus_t_to_slv(en_out) = "00000000") then
            report "Test 16 OK";
        else
            report "Test 16 FAILED : " & integer'image(to_integer(unsigned(en_bus_t_to_slv(en_out))));
        end if;





        wait;
    end process ; -- test_pro
end Behavioral;
