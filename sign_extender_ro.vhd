----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2023 14:30:50
-- Design Name: 
-- Module Name: sign_extender_ro - Behavioral
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

entity sign_extender_ro is
    Port ( clk, res : in STD_LOGIC;
           imm_in : in STD_LOGIC_VECTOR (19 downto 0);
           opcode : in STD_LOGIC_VECTOR (6 downto 0);
           imm_out : out STD_LOGIC_VECTOR (31 downto 0));
end sign_extender_ro;

architecture Behavioral of sign_extender_ro is
    signal buff_s : std_logic_vector (31 downto 0) := (others => '0');
begin
    process (imm_in, opcode) is
        variable buf: std_logic_vector (31 downto 0) := (others => '0');
    begin
        if opcode = "1101111" then
            buf := (others => imm_in(19));
            buf := buf(11 downto 0) & imm_in(19 downto 0);
        else
            buf := (others => imm_in(11));
            buf := buf(19 downto 0) & imm_in(11 downto 0);
        end if;
    buff_s <= buf;
    end process;
    
    process (clk, res) begin
        if res = '0' then
            imm_out <= (others => '0');
        elsif rising_edge (clk) then
            imm_out <= buff_s;
        end if;
    end process;
end Behavioral;
