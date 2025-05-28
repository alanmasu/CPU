----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2025 18:45:00
-- Design Name: 
-- Module Name: compressor_3_2 - Behavioral
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

entity compressor_3_2 is
    Port ( 
        din : in STD_LOGIC_VECTOR (2 downto 0);
        dout : out STD_LOGIC_VECTOR (1 downto 0)
    );
end compressor_3_2;

architecture Behavioral of compressor_3_2 is

begin
    process(din)
        variable sum : unsigned(1 downto 0);
    begin
        sum := (others => '0');
        for i in 0 to 2 loop
            if din(i) = '1' then
                sum := sum + 1;
            end if;
        end loop;
        
        dout <= std_logic_vector(sum);
    end process;
end Behavioral;