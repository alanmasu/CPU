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
    Port ( 
        pc_in : in STD_LOGIC_VECTOR (11 downto 0);
        pc_load,  clk, res : in STD_LOGIC;
        instruction : out STD_LOGIC_VECTOR(31 downto 0);
        npc : out UNSIGNED(11 downto 0);
        pc: buffer UNSIGNED(11 downto 0);

        --BRAM interface
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end instruction_fetch;

architecture Behavioral of instruction_fetch is
    COMPONENT instruction_mem
    PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;
    
    -- BRAM
    signal mem_out : STD_LOGIC_VECTOR(31 downto 0);

begin
    memoria_istruzioni: instruction_mem
    PORT MAP (
        clka => clk,
        ena => pc_load,
        wea => (others => '0'),
        addra => std_logic_vector(pc_in(11 downto 2)),
        dina => (others => '0'),
        douta => mem_out,
        clkb => clkb,
        enb => enb,
        web => web,
        addrb => addrb,
        dinb => dinb,
        doutb => doutb
    ); 
    
    counter_process : process(clk, res) begin
        if res = '0' then
            pc  <= (others => '0');
            npc <= (others => '0');
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
            -- if pc_load = '1' then
            --     instruction <= mem_out;
            -- end if;
            instruction <= mem_out;
        end if;
    end process;
    -- instruction <= mem_out;
end Behavioral;