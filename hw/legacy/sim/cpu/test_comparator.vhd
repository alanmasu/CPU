----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2023 11:55:19
-- Design Name: 
-- Module Name: test_comparator - Behavioral
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

entity test_comparator is
--  Port ( );
end test_comparator;

architecture Behavioral of test_comparator is
    signal a, b : std_logic_vector(31 downto 0);
    signal opcode, opcode2: std_logic_vector(2 downto 0);
    signal jal: std_logic := '0';
    signal cond, cond2: std_logic;
begin
    dut: entity work.comparator
    port map(
        rs1 => a, 
        rs2 => b,
        cond => cond,
        opcode => opcode,
        jal => jal
    );
    dut2: entity work.comparator
    port map(
        rs1 => a, 
        rs2 => b,
        cond => cond2,
        jal => jal,
        opcode => opcode2
    );
    
    process begin
        opcode2 <= "000";
        opcode <= "000";    --BEQ
        a <= (0 => '1', others => '0'); -- 1 
        b <= (1 => '1', others => '0'); -- 2
        wait for 10 ns;
        a <= (1 => '1', others => '0');
        wait for 10 ns;
        
        opcode <= "001";    --BNE
        opcode2 <= "001";
        wait for 10 ns;
        a <= (0 => '1', others => '0');
        wait for 10 ns;
        
        
        a <= (31 => '1', 1 => '1', 0 => '1', others => '0');   
        opcode <= "100";    --BLT                   -- (A)3 <  (B)2
        opcode2<= "110";    --BLTU                  
        wait for 10 ns;
        a <= (1 => '1', others => '0');             -- (A)2 <  (B)2
        wait for 10 ns;
        a <= (1 => '0', 0 => '1', others => '0');   -- (A)1 <  (B)2
        wait for 10 ns;
        
        a <= (31 => '1', 1 => '1', 0 => '1', others => '0'); 
        opcode <= "101";    --BGE                   -- (A)1 >= (B)2
        opcode2<= "111";    --BGEU                  -- (A)1 >= (B)2
        wait for 10 ns;
        a <= (1 => '1', others => '0');             -- (A)2 <  (B)2
        wait for 10 ns;
        a <= (1 => '0', 0 => '1', others => '0');   -- (A)1 <  (B)2
        wait for 10 ns;
        
        ----------------------------------
        
        a <= ( others => '1');   
        opcode <= "100";    --BLT                   -- (A)3 <  (B)2
        opcode2<= "110";    --BLTU                  
        wait for 10 ns;
        a <= (1 => '1', others => '0');             -- (A)2 <  (B)2
        wait for 10 ns;
        a <= (1 => '0', 0 => '1', others => '0');   -- (A)1 <  (B)2
        wait for 10 ns;
        
        a <= (others => '1'); 
        opcode <= "101";    --BGE                   -- (A)1 >= (B)2
        opcode2<= "111";    --BGEU                  -- (A)1 >= (B)2
        wait for 10 ns;
        a <= (1 => '1', others => '0');             -- (A)2 <  (B)2
        wait for 10 ns;
        a <= (1 => '0', 0 => '1', others => '0');   -- (A)1 <  (B)2
        wait for 10 ns;
        
        --if jal == 1 then cont <= 1;
        jal <= '1';
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;



