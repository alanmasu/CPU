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
    signal esito : std_logic := '0';    
    signal GPIO_s : std_logic_vector(7 downto 0);
    signal test_N : integer := 0;
begin
    GPIO_s <= GPIO(7 downto 0);

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
        test_N <= 1;
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

        test_N <= 2;
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
        test_N <= 3;
        ena <= '1';
        wea <= "0001";
        address <= x"00000004";
            -- Setting GPIO 1 as output (and releasing it from controll of the Testbench)
        d_in(31 downto 24) <= "10101010";
        d_in(23 downto 8) <= (others => '0');
        d_in(7 downto 0) <= (1 => '1', others => '0');
        GPIO(1) <= 'Z';       -- Releasing GPIO 1 from the control of the Testbench
        wait for 10 ns;
            -- Driving GPIO 1 to LOW (and also GPIO 0 to LOW but it's now configured as input)
        address <= x"00000008";
        wea <= "0001";
        d_in(1) <= '0';
        d_in(0) <= '0';
        wait for 2 ns;
        if GPIO = x"fffffffd" then
            esito <= '1';
            report "Test 3 OK";
        else
            esito <= '0';
            report "Test 3 FAILED";
        end if;
        wait for 8 ns;
        
            -- Setting GPIO 0 as output (and releasing it from controll of the Testbench)
        test_N <= 4;
        address <= x"00000004";
        wea <= "0001";
        d_in <= (1 => '1', 0 => '1', others => '0');
        GPIO(0) <= 'Z';       -- Releasing GPIO 0 from the control of the Testbench
        wait for 2 ns;
        if GPIO = x"fffffffc" then
            esito <= '1';
            report "Test 4 OK";
        else
            esito <= '0';
            report "Test 4 FAILED";
        end if; 
        wait for 8 ns;
        
            -- Testing READING the driver
            --   Reading state register
        test_N <= 5;
        address <= x"00000000";
        wea <= "0000";
        wait for 2 ns;
        wait for 10 ns;
        if d_out = x"fffffffc" then
            esito <= '1';
            report "Test 5 OK";
        else
            esito <= '0';
            report "Test 5 FAILED";
        end if;
        wait for 8 ns;
            
            --  Reading direction register
        test_N <= 6;
        address <= x"00000004";
        wait for 2 ns;
        if d_out = x"00000003" then
            esito <= '1';
            report "Test 6 OK";
        else
            esito <= '0';
            report "Test 6 FAILED";
        end if;
        wait for 8 ns;

            --  Reading output register
        test_N <= 7;
        address <= x"00000008";
        wait for 2 ns;
        if d_out(1 downto 0) = "00" then
            esito <= '1';
            report "Test 7 OK";
        else
            esito <= '0';
            report "Test 7 FAILED";
        end if;
        wait for 8 ns;

            -- TESTING ena functionality
        test_N <= 8;
        ena <= '0';
        address <= x"00000000";
        wait for 2 ns;

        if GPIO = x"fffffffc" then
            esito <= '1';
            report "Test 8 OK";
        else
            esito <= '0';
            report "Test 8 FAILED";
        end if;
        wait for 8 ns;

        test_N <= 9;
        GPIO(2) <= '0';
        wait for 2 ns;
        if GPIO = x"fffffff8" and d_out(2) = '0' then
            esito <= '1';
            report "Test 9 OK";
        else
            esito <= '0';
            report "Test 9 FAILED";
        end if;
        
        wait;
    end process ; -- test_pr
end Behavioral;
