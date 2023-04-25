----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 13:01:00
-- Design Name: 
-- Module Name: instruction_fetch - Behavioral
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

entity instruction_fetch is
    Port ( pc_in : in STD_LOGIC_VECTOR (11 downto 0);
           pc_load,  clk, res : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR(31 downto 0);
           npc : out UNSIGNED(11 downto 0);
           pc: buffer UNSIGNED(11 downto 0)
        );
end instruction_fetch;

architecture Behavioral of instruction_fetch is
    COMPONENT instruction_memory
        PORT (
            a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
        );
    END COMPONENT;
    signal mem_out: STD_LOGIC_VECTOR(31 downto 0);
begin

    instruction_mem : instruction_memory
    PORT MAP (
        a => STD_LOGIC_VECTOR(pc(11 downto 2)),
        spo => mem_out
    );
    
    counter_process : process(clk, res) begin
        if res = '0' then
            pc <= to_unsigned(0, 12);
            npc <= (0 => '1', others => '0');
        elsif rising_edge(clk) then
            if pc_load = '1' then
                pc <= unsigned(pc_in);
                npc <= unsigned(pc_in) + 4;
            end if;
        end if;
    end process;
    
    register_process: process( clk, res) begin
        if res = '0' then
            instruction <= (others => '0');
        elsif rising_edge(clk) then
            if pc_load = '1' then
                instruction <= mem_out;
            end if;
        end if;
    end process;
    
end Behavioral;