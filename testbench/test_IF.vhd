----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2023 14:53:41
-- Design Name: 
-- Module Name: test_IF - Behavioral
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

entity test_IF is
end test_IF;

architecture Behavioral of test_IF is
    signal clk, res, pc_load : std_logic := '0';
    signal pc_in : std_logic_vector(31 downto 0) := (others => '0');
    signal npc_out : unsigned(31 downto 0) := (others => '0');
    signal instruction : std_logic_vector(31 downto 0):= (others => '0');
    signal wea : std_logic_vector(0 downto 0) := "0";

    -- Test signals
    signal sel: std_logic :='0';
    signal val : std_logic_vector(31 downto 0); -- := "000001000000"; --"InstrMem[16] = 3e800093"
begin
    dut: entity work.instruction_fetch
    port map(
        clk => clk,
        res => res,
        pc_in => pc_in,
        pc_load => pc_load,
        npc => npc_out,
        instruction => instruction,
        --For programming
        clkb => clk,
        enb => '0',
        web => (others => '0'),
        addrb => (others => '0'),
        dinb => (others => '0')
    );
    
    clk_gen: process begin
        clk <= '1'; wait for 5 ns;
        clk <= '0'; wait for 5 ns;
    end process;
    val <= (6 => '1', others => '0');  --"InstrMem[16] = 3e800093"
    -- test_process : process begin
    --     res <= '0';
    --     wait for 19 ns;
    --     pc_load <= '1';
    --     res <= '1';
    --     wait for 180 ns;
    --     sel <= '1';
    --     wait for 10 ns;
    --     sel <= '0';
    --     wait for 40 ns;
    --     --Scrittura
    --       -- reimposto PC
    --     sel <= '1';
    --     val <= "000000000000";
    --     wait for 10 ns;
    --       -- scrivo
    --     sel <= '0';
    --     wea <= "1";
    --     wait for 70 ns;
    --     --Lettura
    --       -- reimposto PC
    --     wea <= "0";
    --     sel <= '1';
    --     val <= "000000000000";
    --     wait for 10 ns;
    --       -- leggo
    --     sel <= '0';
    --     wait for 70 ns;
    --     wait;
    -- end process;
    test_process : process begin
        res <= '0';
        wait for 10 ns;
        res <= '1';
        pc_load <= '1';
        wait for 10 ns;
        pc_load <= '0';
        wait for 30 ns;
        wait;
    end process;
    pc_in <= std_logic_vector(npc_out) when sel = '0' else val;
end Behavioral;
