----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2025 14:25:00
-- Design Name: 
-- Module Name: test_compressor_layer - Behavioral
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
use std.textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;



entity test_compressor_layer is
end test_compressor_layer;

architecture Behavioral of test_compressor_layer is
    constant X : integer := 72;
    constant L : integer := 3;

    signal input_data  : STD_LOGIC_VECTOR (get_layer_inputs(X, L) - 1 downto 0);
    signal output_data : STD_LOGIC_VECTOR (get_layer_outputs(X, L) - 1 downto 0);
    
--    type array_t is array (natural range <>) of integer_array_t;

begin

    -- Instantiate the compressor_layer
    uut: entity work.compressor_layer
        generic map (
            X => X,
            L => L
        )
        port map (
            din  => input_data,
            dout => output_data
        );

    -- Test process
    process begin
        input_data <= (2 => '1', 3 => '1', 4 => '1', others => '0');
        wait for 10 ns;
        input_data <= (17 => '1', 5 => '1', 7 => '1', others => '0');
        wait for 10 ns;
        wait;
    end process;


    
end Behavioral ; -- Behavioral