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
    signal dir : std_logic_vector(1 downto 0) := (others => '0');
    signal gpio_reg : std_logic_vector(1 downto 0) := (others => '0');
    signal GPIO : std_logic_vector(1 downto 0) := (others => 'Z');

begin

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
        variable esito : std_logic;    
    begin
        wait until res = '1'; -- wait for reset
        -- TESTING INPUT
        GPIO <= (others => '0');
        wait for 2 ns;

        if(GPIO = "00") then
            esito := '1';
            report "Test 1 OK";
        else
            esito := '0';
            report "Test 1 FAILED";
        end if;

        wait for 8 ns;
        
        GPIO <= (others => '1');
        wait for 2 ns;

        if(GPIO = "11") then
            esito := '1';
            report "Test 2 OK";
        else
            esito := '0';
            report "Test 2 FAILED";
        end if;

        wait for 8 ns;

        -- TESTING OUTPUT
        GPIO <= "Z0";
        dir(1) <= '1';      -- GPIO 1 is output
        gpio_reg(1) <= '0'; -- GPIO 1 is LOW
        wait for 2 ns;

        if(GPIO = "00") then
            esito := '1';
            report "Test 3 OK";
        else
            esito := '0';
            report "Test 3 FAILED";
        end if;

        wait for 8 ns;
        
        gpio_reg(1) <= '1';  -- GPIO 1 is HIGH
        wait for 2 ns;

        if(GPIO = "10") then
            esito := '1';
            report "Test 4 OK";
        else
            esito := '0';
            report "Test 4 FAILED";
        end if;

        -- TESTING MIXED
        wait for 8 ns;

        GPIO(0) <= '1';     -- GPIO 0 is HIGH
        gpio_reg(1) <= '0'; -- GPIO 1 is LOW

        wait for 2 ns;
        if(GPIO = "00") then
            esito := '1';
            report "Test 5 OK";
        else
            esito := '0';
            report "Test 5 FAILED";
        end if;

        wait for 8 ns;

        gpio_reg(1) <= '1';  -- GPIO 1 is HIGH
        wait for 2 ns;

        if(GPIO = "11") then
            esito := '1';
            report "Test 6 OK";
        else
            esito := '0';
            report "Test 6 FAILED";
        end if;

        
        wait;
    end process ; -- test_pr

    sequenziale : process( clk, res )
    begin
        if res = '0' then
            GPIO <= (others => 'Z');
        elsif rising_edge(clk) then
            for i in 0 to 1 loop
                if dir(i) = '1' then
                    GPIO(i) <= gpio_reg(i);
                else
                    GPIO(i) <= 'Z';
                end if ;
            end loop ;
        end if ;
    end process ; -- sequenziale

end Behavioral;
