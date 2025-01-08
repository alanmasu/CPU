----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2025 10:08:50 AM
-- Design Name: 
-- Module Name: test_GPIO - Behavioral
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

entity test_GPIO is
--  Port ( );
end test_GPIO;

architecture Behavioral of test_GPIO is 
    signal clk : std_logic := '0';
    signal res : std_logic := '0';
    signal GPIO : std_logic_vector(31 downto 0) := (others => 'Z');
    signal ena : std_logic := '0';
    signal wea : std_logic_vector(3 downto 0) := (others => '0');
    signal address : std_logic_vector(31 downto 0) := (others => '0');
    signal d_in    : std_logic_vector(31 downto 0) := (others => '0');
    signal d_out   : std_logic_vector(31 downto 0) := (others => '0');
    
    --TESTING
    signal esito : std_logic;    
begin

    DUT : entity work.GPIO
        port map(
            clk => clk,
            res => res,
            address => address,
            d_in => d_in,
            d_out => d_out,
            wea => wea,
            ena => ena,
            GPIO => GPIO
        );

    reset_pro : process begin
        wait for 9 ns;
        res <= '1';
        wait;
    end process ; -- reset_pro

    clk_pro : process begin
        clk <= not clk;
        wait for 5 ns;
    end process ; -- clk_pro

    test_pro : process is
    begin
        wait until res = '1'; -- wait for reset
        -- TESTING INPUT
        GPIO <= (others => '0');
        wait for 2 ns;

        if(GPIO = x"00000000") then
            esito <= '1';
            report "Test 1 OK";
        else
            esito <= '0';
            report "Test 1 FAILED";
        end if;

        wait for 8 ns;
        
        GPIO <= (others => '1');
        wait for 2 ns;

        if(GPIO = x"ffffffff") then
            esito <= '1';
            report "Test 2 OK";
        else
            esito <= '0';
            report "Test 2 FAILED";
        end if;
        wait for 8 ns;

        -- -- TESTING OUTPUT
        ena <= '1';
        wea <= "0001"; -- READ
        address <= x"00000004";
        d_in(31 downto 24) <= "10101010";
        d_in(23 downto 8) <= (others => '0');
        d_in(7 downto 0) <= (1 => '1', others => '0');
        GPIO(1) <= 'Z';
        wait for 10 ns;
        wait;

        -- GPIO <= "Z0";
        -- dir(1) <= '1';      -- GPIO 1 is output
        -- gpio_reg(1) <= '0'; -- GPIO 1 is LOW
        -- wait for 2 ns;

        -- if(GPIO = "00") then
        --     esito <= '1';
        --     report "Test 3 OK";
        -- else
        --     esito <= '0';
        --     report "Test 3 FAILED";
        -- end if;

        -- wait for 8 ns;
        
        -- gpio_reg(1) <= '1';  -- GPIO 1 is HIGH
        -- wait for 2 ns;

        -- if(GPIO = "10") then
        --     esito <= '1';
        --     report "Test 4 OK";
        -- else
        --     esito <= '0';
        --     report "Test 4 FAILED";
        -- end if;

        -- -- TESTING MIXED
        -- wait for 8 ns;

        -- GPIO(0) <= '1';     -- GPIO 0 is HIGH
        -- gpio_reg(1) <= '0'; -- GPIO 1 is LOW

        -- wait for 2 ns;
        -- if(GPIO = "00") then
        --     esito <= '1';
        --     report "Test 5 OK";
        -- else
        --     esito <= '0';
        --     report "Test 5 FAILED";
        -- end if;

        -- wait for 8 ns;

        -- gpio_reg(1) <= '1';  -- GPIO 1 is HIGH
        -- wait for 2 ns;

        -- if(GPIO = "11") then
        --     esito <= '1';
        --     report "Test 6 OK";
        -- else
        --     esito <= '0';
        --     report "Test 6 FAILED";
        -- end if;

        
        wait;
    end process ; -- test_pr

end Behavioral;
