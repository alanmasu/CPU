----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2023 10:46:57
-- Design Name: 
-- Module Name: comparator - Behavioral
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

entity comparator is
    Port ( rs1 : in STD_LOGIC_VECTOR (31 downto 0);
           rs2 : in STD_LOGIC_VECTOR (31 downto 0);
           opcode : in STD_LOGIC_VECTOR (2 downto 0);
           cond : out STD_LOGIC);
end comparator;

architecture Behavioral of comparator is
    signal a, b : signed(31 downto 0);
    signal au, bu : unsigned(31 downto 0);
begin                                       
    --Cast 
    a <= signed(rs1);
    b <= signed(rs2);
    au <= unsigned(rs1);
    bu <= unsigned(rs2);
    
    comb_process: process(a, au, b, bu, opcode) begin
        case(opcode) is
            when "000" => --BEQ
                if a = b then
                    cond <= '1';
                else 
                    cond <= '0';
                end if;
            when "001" => --BNE
                if a /= b then
                    cond <= '1';
                else 
                    cond <= '0';
                end if; 
            when "100" => --BLT
                if a < b then
                    cond <= '1';
                else 
                    cond <= '0';
                end if ;
            when "101" => --BGE
                if a >= b then
                    cond <= '1';
                else 
                    cond <= '0';
                end if ;
            when "110" => --BLTU
                if au < bu then
                    cond <= '1';
                else 
                    cond <= '0';
                end if;
            when "111" => --BGEU
                if au >= bu then
                    cond <= '1';
                else 
                    cond <= '0';
                end if;
            when others => 
                cond <= 'U';               
        end case;
    end process;
    
end Behavioral;











