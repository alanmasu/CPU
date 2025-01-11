----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.03.2023 10:33:22
-- Design Name: 
-- Module Name: triple_port_ram - Behavioral
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

library work;
use work.types_pkg.all;
use work.constant_package.all;

entity triple_port_ram is
    Port ( addr_in : in STD_LOGIC_VECTOR (4 downto 0);
           d_in : in STD_LOGIC_VECTOR (31 downto 0);
           we : in STD_LOGIC;
           addr_out1 : in STD_LOGIC_VECTOR (4 downto 0);
           d_out1 : out STD_LOGIC_VECTOR (31 downto 0);
           addr_out2 : in STD_LOGIC_VECTOR (4 downto 0);
           d_out2 : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           res : in STD_LOGIC);
end triple_port_ram;

architecture Behavioral of triple_port_ram is
    signal mem_2: ram_array;
begin
    process(clk, res) is
        variable mem: ram_array;
    begin
        if res = '0' then
--            res_mem : for i in 0 to 30 loop
--                mem(i) := (others => '0');
--            end loop res_mem;
            mem := REG_FILE_RESET_VALUE;
            d_out1 <= (others => '0');
            d_out2 <= (others => '0');
        elsif rising_edge(clk) then
            if we = '1' and addr_in /= (addr_in'range => '0') then
                mem(to_integer(unsigned(addr_in)) - 1) := d_in;
            end if;
            if addr_out1 /= (addr_out1'range => '0') then
                d_out1 <= mem(to_integer(unsigned(addr_out1)) - 1);
            else
                d_out1 <= (others => '0');
            end if;
            if addr_out2 /= (addr_out2'range => '0') then
                d_out2 <= mem(to_integer(unsigned(addr_out2)) - 1);
            else
                d_out2 <= (others => '0');
            end if;
        end if;
        mem_2 <= mem;
    end process;

end architecture Behavioral;


