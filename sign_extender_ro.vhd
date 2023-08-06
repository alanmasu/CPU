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
--                  Sign. extenction
-- Alu op                   signed
-- Brench                   signed
-- JAL/JALR                 signed
-- LUI                    unsigned
-- AUIPC                  unsigned 
-- Store                    signed
-- Load                     signed
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.constant_package.all;

entity sign_extender_ro is
    Port ( clk, res : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (31 downto 0);
           imm_out : out STD_LOGIC_VECTOR (31 downto 0));
end sign_extender_ro;

architecture Behavioral of sign_extender_ro is
    signal opcode : std_logic_vector (6 downto 0);
    signal imm : std_logic_vector (31 downto 0) := (others => '0');
begin
    opcode(6 downto 0) <= instruction(6 downto 0);
    process (instruction, opcode) 
        variable imm12 : std_logic_vector(11 downto 0);
        variable imm20 : std_logic_vector(19 downto 0);
    begin
        imm12 := (others => '0');
        imm20 := (others => '0');
        imm <= (others => '0');
        if opcode = opcode_jal then
            imm20(19) := instruction(31);
            imm20(18 downto 11) := instruction(19 downto 12);
            imm20(10 downto 1) := instruction(30 downto 21);
            imm20(0) := '0';
            imm12 := (others => imm20(19));
            imm(31 downto 20) <= imm12(11 downto 0);
            imm(19 downto 0) <= imm20;
        elsif opcode = opcode_store then
            imm20 := (others => instruction(31));
            imm12(11 downto 5) := instruction(31 downto 25);
            imm12(4 downto 0) := instruction(11 downto 7);            
            imm <= imm20 & imm12;
        elsif (opcode = opcode_jalr) or (opcode = opcode_alu_imm_op) or (opcode = opcode_load) then   -- sign ext a 12 bit
            imm20 := (others => instruction(31));
            imm12 := instruction(31 downto 20);
            imm <= imm20 & imm12;
			--imm <= imm12 & imm20;
		elsif (opcode = opcode_lui) or (opcode = opcode_auipc) then
			imm20 := instruction(31 downto 12);
			imm12 := (others => '0');
			imm <= imm20 & imm12;
		elsif opcode = opcode_brench then
		    imm20 := (others => instruction(31));
            imm12(11) := instruction(7);
			imm12(10 downto 5) := instruction(30 downto 25);
            imm12(4 downto 1) := instruction(11 downto 8);
            imm12(0) := '0';
			imm <= imm20 & imm12;
        end if;
    end process;
    
    process (clk, res) begin
        if res = '0' then
            imm_out <= (others => '0');
        elsif rising_edge (clk) then
            imm_out <= imm;
        end if;
    end process;
end Behavioral;
