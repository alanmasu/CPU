----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2023 15:41:32
-- Design Name: 
-- Module Name: test_sign_extender_ro - Behavioral
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

entity test_sign_extender_ro is
end test_sign_extender_ro;

architecture Behavioral of test_sign_extender_ro is
    component sign_extender_ro is
        Port ( clk, res : in STD_LOGIC;
           imm_in : in STD_LOGIC_VECTOR (19 downto 0);
           opcode : in STD_LOGIC_VECTOR (6 downto 0);
           imm_out : out STD_LOGIC_VECTOR (31 downto 0));
    end component sign_extender_ro;
    
    signal imm_in : STD_LOGIC_VECTOR (19 downto 0);
    signal opcode : STD_LOGIC_VECTOR (6 downto 0);
    signal imm_out : STD_LOGIC_VECTOR (31 downto 0);
    signal clk, res : STD_LOGIC;
    
begin
    dut : sign_extender_ro port map (
        clk => clk, res => res, imm_in => imm_in, 
        imm_out => imm_out, opcode => opcode);

process begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
end process;      

process is
    constant jal_instr : std_logic_vector (6 downto 0) := "1101111";
    constant generic_imm_instr : std_logic_vector (6 downto 0) := "1101001";
    constant sign_extending_12bit : std_logic_vector (11 downto 0) := x"3BB";
    constant sign_extending_20bit : std_logic_vector (19 downto 0) := x"B89E9";
begin
    imm_in <= (others => '0');
    res <= '0';
    wait for 105 ns;
    res <= '1';
    
    opcode <= jal_instr;
    wait for 5 ns;
    imm_in <= sign_extending_20bit;
    wait for 3 ns;
    wait for 100 ns;
    
    opcode <= generic_imm_instr;
    wait for 5 ns;
    imm_in <= imm_in(19 downto 12) & sign_extending_12bit;
    wait for 3 ns;
    
    wait;
end process;

end Behavioral;
