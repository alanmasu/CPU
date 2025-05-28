----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 09:19:00
-- Design Name: 
-- Module Name: test_compressor - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_compressor is
end test_compressor;

architecture Behavioral of test_compressor is

    signal din : unsigned(5 downto 0) := (others => '0');
    signal dout : std_logic_vector(2 downto 0);
    signal dout_u : unsigned(2 downto 0);

    signal dout2 : std_logic_vector(1 downto 0);
    signal dout2_u : unsigned(1 downto 0);


    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal error : std_logic := '0';

    -- Funzione per contare gli '1'
    function count_ones(v : std_logic_vector) return unsigned is
        variable count : unsigned (2 downto 0) := (others => '0');
    begin
        for i in v'range loop
            if v(i) = '1' then
                count := count + 1;
            end if;
        end loop;
        return count;
    end function;
    
begin 

    dut : entity work.compressor_6_3
    port map (
        din => std_logic_vector(din),
        dout => dout
    );
    
    dut2 : entity work.compressor_3_2
    port map (
        din => std_logic_vector(din(2 downto 0)),
        dout => dout2
    );

    dout_u <= unsigned(dout);
    dout2_u <= unsigned(dout2);

    test_pro : process begin
        error <= '0';
        test_for : for i in 0 to 63 loop
            din <= to_unsigned(i, 6);
            wait for 1 ns;
            if dout_u /= count_ones(std_logic_vector(din)) then
                error <= '1';
            end if ;
        end loop test_for; -- test_for       
        if error = '0' then
            report "Test compressor 6:3 PASSED";
        else
            report "Test compressor 6:3 FAILED";
        end if;

        error <= '0';
        test_for2 : for i in 0 to 2 loop
            din <= to_unsigned(i, 6);
            wait for 1 ns;
            if dout2_u /= count_ones(std_logic_vector(din(2 downto 0))) then
                error <= '1';
            end if ;
        end loop test_for2; -- test_for
        if error = '0' then
            report "Test compressor 3:2 PASSED";
        else
            report "Test compressor 3:2 FAILED";
        end if; 

        wait;
    end process ; -- test_pro
   
end Behavioral;

    