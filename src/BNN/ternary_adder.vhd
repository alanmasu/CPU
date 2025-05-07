----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2025 06:36:31 PM
-- Design Name: 
-- Module Name: ternary_adder - Behavioral
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

entity ternary_adder is
    generic (
        X : integer := 128;
        DEBUG : boolean := false;
        FORCE_DEBUG : boolean := false
    );
    Port ( 
        din : in STD_LOGIC_VECTOR (get_layer_outputs(X, get_popcount_levels(X)) - 1 downto 0);
        dout : out STD_LOGIC_VECTOR (clog2(x) - 1 downto 0)
    );
end ternary_adder;

architecture Behavioral of ternary_adder is

    constant ACT_MAX : integer := 2;


    type column_t is array (0 to get_layer_weights(X, get_popcount_levels(X))) of std_logic_vector(2 downto 0);
    signal colonne_s : column_t;

    -- type compressors_in_t is array (0 to get_layer_weights(X, get_popcount_levels(X))) of std_logic_vector(2 downto 0);
    -- type compressors_out_t is array (0 to get_layer_weights(X, get_popcount_levels(X))) of std_logic_vector(1 downto 0);

    -- signal compressors_in  : compressors_in_t  := (others => (others => '0'));
    -- signal compressors_out : compressors_out_t := (others => (others => '0'));
    function sum_std_vector( v : std_logic_vector ) return unsigned is
        variable sum : unsigned(clog2(X) - 1 downto 0) := (others => '0');
    begin
        for i in v'range loop
            if v(i) = '1' then
                sum := sum + 1;
            end if;
        end loop;
        return sum;
    end function;
begin

    

    process(din) is 
        variable colonne : column_t := (others => (others => '0'));
        variable in_bit_used : integer := 0;

        variable activation : integer := 0;

        variable sum : unsigned(clog2(X) - 1 downto 0) := (others => '0');

        variable power2 : integer := 1;
    begin

        in_bit_used := 0;
        sum := (others => '0');
        power2 := 1;

        for peso in 0 to get_layer_weights(X, get_popcount_levels(X)) loop
            for bit_n in 0 to 2 loop
                if bit_n < get_weight_input_n(X, get_popcount_levels(X) + 1, peso) then
                    colonne(peso)(bit_n) := din(in_bit_used);
                    if (DEBUG and activation < ACT_MAX) or FORCE_DEBUG then
                        report "colonne(" & integer'image(peso) & ")(" & integer'image(bit_n) & ") <= din(" & integer'image(in_bit_used) & ")";
                    end if;
                    in_bit_used := in_bit_used + 1;
                else
                    colonne(peso)(bit_n) := '0';
                    if (DEBUG and activation < ACT_MAX) or FORCE_DEBUG then
                        report "colonne(" & integer'image(peso) & ")(" & integer'image(bit_n) & ") <= '0'";
                    end if;
                end if;
            end loop;
            colonne_s <= colonne;
        end loop;   
        
        sum_for : for peso in 0 to get_layer_weights(X, get_popcount_levels(X)) loop
            sum := sum + (sum_std_vector(colonne(peso)) sll peso);
        end loop ; -- sum_for

        dout <= std_logic_vector(sum);
        activation := activation + 1;
    end process;

    
    

end Behavioral;
