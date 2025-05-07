----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2025 03:23:31 PM
-- Design Name: 
-- Module Name: test_popcounter - Behavioral
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
use work.BNN_pkg.all;
use work.utilities_pkg.all;

entity test_popcounter is
--  Port ( );
end test_popcounter;

architecture Behavioral of test_popcounter is
    constant X : integer := 72;

    constant DEBUG : boolean := false;
    constant DEBUG_TB : boolean := false;
    constant FORCE_DEBUG : boolean := false;
    constant DEBUG_LAYERS : boolean := false;
    constant FORCE_DEBUG_LAYERS : boolean := false;
    constant ACT_MAX : integer := 10;

    signal reset : std_logic := '0';
    signal clk   : std_logic := '0';


    signal input_data  : STD_LOGIC_VECTOR (X - 1 downto 0) := (others => '0');
    signal output_data : STD_LOGIC_VECTOR (get_layer_outputs(X, get_popcount_levels(X)) - 1 downto 0) := (others => '0');
    signal my_sum : STD_LOGIC_VECTOR (clog2(X) - 1 downto 0) := (others => '0');
    signal my_sum_p : STD_LOGIC_VECTOR (clog2(X) - 1 downto 0) := (others => '0');  -- Uscita dal popcounter

    signal test_n    : integer := 0;
    signal validating : std_logic := '0';

    --------------------- FOR SUM ---------------------
    constant L: integer := get_popcount_levels(X);
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

    dut: entity work.popcounter_tree
    generic map (
        X => X,

        DEBUG => DEBUG,
        FORCE_DEBUG => FORCE_DEBUG,
        DEBUG_LAYERS => DEBUG_LAYERS,
        FORCE_DEBUG_LAYERS => FORCE_DEBUG_LAYERS
    )
    port map (
        din => input_data,
        dout => output_data
    );
    
    dut2: entity work.ternary_adder
    generic map (
        X => X,

        DEBUG => DEBUG,
        FORCE_DEBUG => FORCE_DEBUG
    )
    port map (
        din => output_data,
        dout => my_sum
    );

    dut3: entity work.popcounter
    generic map (
        X => X,

        DEBUG => DEBUG,
        FORCE_DEBUG => FORCE_DEBUG,
        DEBUG_LAYERS => DEBUG_LAYERS,
        FORCE_DEBUG_LAYERS => FORCE_DEBUG_LAYERS
    )
    port map (
        din => input_data,
        dout => my_sum_p
    );

    clk_process : process begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    res_process: process begin
        reset <= '0';
        wait for 10 ns;
        reset <= '1';
        wait;
    end process;

    process begin
        wait until reset = '1';

        test_n <= 1;
        input_data <= (5 => '1', 4 => '1', 3 => '1', 2 => '1', 1 => '1', 0 => '1', others => '0');
        wait until rising_edge(clk);
        validating <= '1';
        if sum_s = 6 then
            report "Test " & integer'image(test_n) & " OK";
        else
            report "Test " & integer'image(test_n) & " FAILED => sum_s was " & integer'image(sum_s);
        end if;
        wait for 1 ns;
        validating <= '0';

        test_n <= 2;
        input_data <= (5 => '1', 4 => '1', 3 => '1', 2 => '1', 1 => '0', 0 => '0', others => '0');
        wait until rising_edge(clk);
        validating <= '1';
        if sum_s = 4 then
            report "Test " & integer'image(test_n) & " OK";
        else
            report "Test " & integer'image(test_n) & " FAILED => sum_s was " & integer'image(sum_s);
        end if;
        wait for 1 ns;
        validating <= '0';

        test_n <= 3;
        input_data <= (others => '1');
        wait until rising_edge(clk);
        validating <= '1';
        if sum_s = 72 then
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

        if (DEBUG_TB and activation < ACT_MAX) or FORCE_DEBUG then
            report "";
            -- report 
        end if;

        weights_for : for weight in 0 to get_layer_weights(X, L) loop
            out_to   := output_bit;
            out_from := output_bit + get_layer_weight_size(X, L, weight) - 1;

            weights(weight) <= sum_std_vector(output_data(out_from downto out_to));
            stdv_array(weight) (get_layer_weight_size(X, L, weight) - 1 downto 0) <= output_data(out_from downto out_to);
            
            if (DEBUG_TB and activation < ACT_MAX) or FORCE_DEBUG then
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
            if (DEBUG_TB) or FORCE_DEBUG then
                report "Sum(" & integer'image(i) & ") := " & integer'image(weights(i)) & " * " & integer'image(power2) & " = " & integer'image(sum);
            end if;
            power2 := power2 * 2;
        end loop ; -- sum_for
        sum_s <= sum;
        power2_s <= power2;
    end process ; -- sum_pro

    process is 
        variable my_sum_int : integer := 0;
        variable my_sum_p_int : integer := 0;
    begin
        wait on my_sum;
        wait for 1 ns;
        my_sum_int := stdv_to_integer(my_sum);
        my_sum_p_int := stdv_to_integer(my_sum_p);
        -- report "my_sum_int = " & integer'image(my_sum_int);
        if my_sum_int /= sum_s then
            assert false report "Test ternary adder FAILED => my_sum was " & integer'image(my_sum_int) & " != " & integer'image(sum_s) severity error;
        end if;

        if my_sum_p_int /= sum_s then
            assert false report "Test popcounter FAILED => my_sum_p was " & integer'image(my_sum_p_int) & " != " & integer'image(sum_s) severity error;
        end if;
    end process;

end Behavioral;
