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
    signal instruction : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal imm_out : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal clk, res : STD_LOGIC;
    signal s1, s2 : std_logic_vector(1 downto 0) := "00";
    signal s3 :std_logic_vector(3 downto 0) := "0000";
begin
    dut : entity work.sign_extender_ro 
    port map (
        clk => clk, 
        res => res,
        imm_out => imm_out, 
        instruction => instruction
    );

    process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;      
    
    res_prcess : process
    begin
        res <= '0';
        wait for 10 ns;
        res <= '1';
        wait;
    end process ; -- res_prcess
    
    process is
        constant n_instr : natural := 11;
        type array_of_costants is array (0 to n_instr) of std_logic_vector(31 downto 0);
        constant instructions : array_of_costants := (
            x"00a08013",
            x"fe208013",
            x"00001037",
            x"80000037",
            x"00001117",
            x"80000117",
            x"fe2084e3",
            x"00208663",
            x"fe222ea3",
            x"0041a123",
            x"fd9ff0ef",
            x"0040016f"
        );
    begin      
        wait for 9 ns;
        test_for : for i in 0 to n_instr loop
            instruction <= instructions(i);
            wait for 10 ns;
        end loop ; -- test_for  
        wait for 10 ns;  
        wait;
    end process;
    s3 <= s1 & s2;
end Behavioral;
