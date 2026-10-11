----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2025 10:48:35 AM
-- Design Name: 
-- Module Name: binary_mac - Behavioral
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
library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;

entity binary_mac is
    generic (
        X : integer := 32
    );
    Port ( 
        a : in STD_LOGIC_VECTOR (X - 1 downto 0);
        b : in STD_LOGIC_VECTOR (X - 1 downto 0);
        dout : out STD_LOGIC_VECTOR (clog2(X) - 1 downto 0)
    );
end binary_mac;

architecture Behavioral of binary_mac is
    signal binary_product : STD_LOGIC_VECTOR (X - 1 downto 0);
begin

    popcounter_inst : entity work.popcounter
    generic map (
        X => X
    )
    port map (
        din => binary_product,
        dout => dout
    );

    binary_product <= a xnor b;

end Behavioral;
