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

    -- FOR DEBUG
    constant DEBUG : boolean := false;
    constant FORCE_DEBUG : boolean := false;
    constant ACT_MAX : integer := 10;

    signal reset : std_logic := '0';
    signal input_data  : STD_LOGIC_VECTOR (get_layer_inputs(X, L) - 1 downto 0) := (others => '0');
    signal output_data : STD_LOGIC_VECTOR (get_layer_outputs(X, L) - 1 downto 0) := (others => '0');
    
    signal validating : std_logic := '0';
    signal test_n     : integer := 0;

    type array_t is array (0 to get_layer_weights(X, L)) of integer;
    signal weights : array_t := (others => 0);

    type stdv_array_t is array (0 to get_layer_weights(X, L)) of std_logic_vector(get_h_max(X, L) - 1 downto 0);
    signal stdv_array : stdv_array_t := (others => (others => '0'));

    signal sum_s : integer := 0;
    signal power2_s : integer := 1;

    function sum_std_vector( v : std_logic_vector ) return integer is
        variable sum : integer := 0;
    begin
        for i in v'range loop
            if v(i) = '1' then
                sum := sum + 1;
            end if;
        end loop;
        return sum;
    end function;

    -- Function to convert std_logic_vector to integer
    function stdv_to_integer( v : std_logic_vector ) return integer is
        variable result : integer := 0;
    begin
        result := to_integer(unsigned(v));
        return result;
    end function;

begin

    -- Instantiate the compressor_layer
    uut: entity work.compressor_layer
        generic map (
            X => X,
            L => L,
            DEBUG => DEBUG,
            FORCE_DEBUG => FORCE_DEBUG
        )
        port map (
            din  => input_data,
            dout => output_data
        );

    -- Test process
    process is
        variable stdv : std_logic_vector(31 downto 0) := (others => '1');
    begin
        wait for 10 ns;
        reset <= '1';
        report "Test process started";
        report "";

        test_n <= 1;
        input_data <= ( 4 => '1', 3 => '1', 2 => '1', others => '0');
        report "Input data Change 1";
        wait for 10 ns;
        validating <= '1';
        if sum_s = 6 then
            report "Test " & integer'image(test_n) & " OK";
        else
            report "Test " & integer'image(test_n) & " FAILED => sum_s was " & integer'image(sum_s);
        end if;
        wait for 1 ns;
        validating <= '0';


        test_n <= 2;
        input_data <= (17 => '1', 7 => '1', 5 => '1', others => '0');
        report "Input data Change 2";
        wait for 9 ns;
        validating <= '1';
        if sum_s = 22 then
            report "Test " & integer'image(test_n) & " OK";
        else
            report "Test " & integer'image(test_n) & " FAILED => sum_s was " & integer'image(sum_s);
        end if;
        wait for 1 ns;
        validating <= '0';

        test_n <= 3;
        input_data <= ( 14 => '1', 1 => '1', others => '0');
        report "Input data Change 3";
        wait for 9 ns;
        validating <= '1';
        if sum_s = 9 then
            report "Test " & integer'image(test_n) & " OK";
        else
            report "Test " & integer'image(test_n) & " FAILED => sum_s was " & integer'image(sum_s);
        end if;
        wait for 1 ns;
        validating <= '0';


        wait for 10 ns;
        wait;
    end process;

    combinational_pro : process( output_data ) is
        variable output_bit : integer := 0;    
        variable out_from   : integer := 0;
        variable out_to     : integer := 0;

        variable activation : integer := 0;
    begin
        output_bit := 0;    
        out_from   := 0;
        out_to     := 0;

        if (DEBUG and activation < ACT_MAX) or FORCE_DEBUG then
            report "";
            -- report 
        end if;

        weights_for : for weight in 0 to get_layer_weights(X, L) loop
            out_to   := output_bit;
            out_from := output_bit + get_layer_weight_size(X, L, weight) - 1;

            weights(weight) <= sum_std_vector(output_data(out_from downto out_to));
            stdv_array(weight) (get_layer_weight_size(X, L, weight) - 1 downto 0) <= output_data(out_from downto out_to);
            
            if (DEBUG and activation < ACT_MAX) or FORCE_DEBUG then
                report "Weight(" & integer'image(weight) & ") := sum_std_vector(output_data(" & integer'image(out_from) & " downto " & integer'image(out_to) & ")) = " & integer'image(weights(weight)); 
                report "stdv_array(" & integer'image(weight) & ")(" & integer'image(get_layer_weight_size(X, L, weight) - 1) & " downto 0) <= output_data(" & integer'image(out_from) & " downto " & integer'image(out_to) & ")";
            end if;

            output_bit := out_from + 1;
        end loop ; -- weights_for

        

        activation := activation + 1;
    end process ; -- combinational_pro

    sum_pro : process( weights ) is
        variable sum : integer := 0;
        variable power2 : integer := 1;
    begin
        sum := 0;
        power2 := 1;

        sum_for : for i in weights'range loop
            sum := sum + weights(i) * power2;
            if (DEBUG) or FORCE_DEBUG then
                report "Sum(" & integer'image(i) & ") := " & integer'image(weights(i)) & " * " & integer'image(power2) & " = " & integer'image(sum);
            end if;
            power2 := power2 * 2;
        end loop ; -- sum_for
        sum_s <= sum;
        power2_s <= power2;
    end process ; -- sum_pro

    
end Behavioral ; -- Behavioral