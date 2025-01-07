----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/04/2023 12:36:50 PM
-- Design Name: 
-- Module Name: test_RAM - Behavioral
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

entity test_RAM is
--  Port ( );
end test_RAM;

architecture Behavioral of test_RAM is
    COMPONENT data_memory
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            clkb : IN STD_LOGIC;
            enb : IN STD_LOGIC;
            web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    signal clk : STD_LOGIC := '0';
    signal res : STD_LOGIC := '0';
    signal we : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    signal en : STD_LOGIC := '0';
    signal addr : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000000";
    signal din : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal dout : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    --signal i : integer := 0;
begin
    dut : data_memory
    PORT MAP (
        clka => clk,
        wea => we,
        ena => en,
        addra => addr,
        dina => din,
        douta => dout, 
        clkb => clk,
        enb => '0',
        web => (others => '0'),
        addrb => (others => '0'),
        dinb => (others => '0')
    );

    clk_gen : process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;

    res_gen : process begin
        res <= '0';
        wait for 9 ns;
        res <= '1';
        wait;
    end process;

    test_process : process begin
        wait until res = '1';
        -- write
        we <= "1111";
        en <= '1';
        for i in 0 to 10 loop
            addr <= std_logic_vector(to_unsigned(i, 11));
            din <= std_logic_vector(to_unsigned(i + 1, 32));
            wait for 10 ns;
        end loop;
        -- read
        we <= "0000";
        en <= '1';
        for i in 0 to 10 loop
            addr <= std_logic_vector(to_unsigned(i, 11));
            wait for 10 ns;
        end loop;
        wait for 1 ns;
        --Read after write
        we <= "0000";
        en <= '1';
        for i in 0 to 10 loop
            addr <= std_logic_vector(to_unsigned(i, 11));
            wait for 10 ns;
        end loop;
        -- Write after read
        we <= "1111";
        for i in 0 to 10 loop
            addr <= std_logic_vector(to_unsigned(i, 11));
            din <= std_logic_vector(to_unsigned(i + 20, 32));
            wait for 10 ns;
        end loop;
        -- Read after write
        we <= "0000";
        en <= '1';
        for i in 0 to 10 loop
            addr <= std_logic_vector(to_unsigned(i, 11));
            wait for 10 ns;
        end loop;
        -- Without enable
        we <= "1111";
        en <= '0';
        for i in 0 to 10 loop
            addr <= std_logic_vector(to_unsigned(i, 11));
            din <= std_logic_vector(to_unsigned(i + 20, 32));
            wait for 10 ns;
        end loop;
        wait;
    end process;
end Behavioral;
