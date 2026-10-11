----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2025 06:36:31 PM
-- Design Name: 
-- Module Name: popcounter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.utilities_pkg.all;
use work.BNN_pkg.all;

entity popcounter is
    generic (
        X : integer := 128;
        DEBUG : boolean := false;
        FORCE_DEBUG : boolean := false;
        DEBUG_LAYERS : boolean := false;
        FORCE_DEBUG_LAYERS : boolean := false
    );
    Port ( 
        din : in STD_LOGIC_VECTOR (X - 1 downto 0);
        dout : out STD_LOGIC_VECTOR (clog2(x) - 1 downto 0)
    );
end popcounter;

architecture Behavioral of popcounter is
    signal interconnect : STD_LOGIC_VECTOR (get_layer_outputs(X, get_popcount_levels(X)) - 1 downto 0);
begin

    popcounter_tree_inst : entity work.popcounter_tree
    generic map (
        X => X,
        DEBUG => DEBUG,
        FORCE_DEBUG => FORCE_DEBUG
    )
    port map (
        din => din,
        dout => interconnect
    );

    ternary_adder_inst : entity work.ternary_adder
    generic map (
        X => X,
        DEBUG => DEBUG,
        FORCE_DEBUG => FORCE_DEBUG
    )
    port map (
        din => interconnect,
        dout => dout
    );
end Behavioral;
