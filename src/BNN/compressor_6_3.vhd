----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 09:19:00
-- Design Name: 
-- Module Name: compressor_6_3 - Behavioral
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

entity compressor_6_3 is
    Port ( 
        din : in STD_LOGIC_VECTOR (5 downto 0);
        dout : out STD_LOGIC_VECTOR (2 downto 0)
    );
end compressor_6_3;

architecture Behavioral of compressor_6_3 is

begin
    process(din)
        variable sum : unsigned(2 downto 0);
    begin
        sum := (others => '0');
        for i in 0 to 5 loop
            if din(i) = '1' then
                sum := sum + 1;
            end if;
        end loop;
        
        dout <= std_logic_vector(sum);
    end process;
end Behavioral;