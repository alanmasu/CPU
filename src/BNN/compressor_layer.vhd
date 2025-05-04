----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 09:19:00
-- Design Name: 
-- Module Name: compressor_layer - Behavioral
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
library work;
use work.utilities_pkg.all;
use work.BNN_pkg.all;

entity compressor_layer is
    generic (
        X : integer := 128;
        L : integer := 1;

        -- Definizione costante per la stampa
        DEBUG : boolean := true;
        FORCE_DEBUG : boolean := true
    );
    port (
        din  : in  STD_LOGIC_VECTOR (get_layer_inputs(X, L)  - 1 downto 0);
        dout : out STD_LOGIC_VECTOR (get_layer_outputs(X, L) - 1 downto 0)
    ) ;
end compressor_layer;

architecture Behavioral of compressor_layer is
    type compressor_in_t is array (natural range <>) of STD_LOGIC_VECTOR (5 downto 0);
    type compressor_out_t is array (natural range <>) of STD_LOGIC_VECTOR (2 downto 0);

    type compressors_weights_t is array (natural range <>) of STD_LOGIC_VECTOR (get_h_max(X, L) - 1 downto 0);

    signal compressor_in  : compressor_in_t(1 to get_layer_compressors(X, L))  := (others => (others => '0'));
    signal compressor_out : compressor_out_t(1 to get_layer_compressors(X, L)) := (others => (others => '0'));

    component compressor_6_3 is
        Port ( 
            din : in STD_LOGIC_VECTOR (5 downto 0);
            dout : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;
begin
    gen_weights_cmp : for k in 0 to clog2(x) generate
        -- variable compressor_n : integer := 0;
    begin
        if_gen : if get_layer_compressors_n(X, L, k) /= 0 generate
            process begin 
                if (DEBUG) then
                    report "Generating compressors for weight " & integer'image(k);
                end if;
                wait;
            end process;
            k_compressors : for c in 1 to get_layer_compressors_n(X, L, k) generate
                constant comp_n : integer := acc_layers_compressors(X, L, k) + c;
            begin
                process begin 
                    if(DEBUG) then
                        report "    Generating compressor " & integer'image(c) & " for weight " & integer'image(k);
                        report "      comp_n = " & integer'image(comp_n);
                    end if;
                    wait;
                end process;    
                
                compressor : compressor_6_3
                port map (
                    din  => compressor_in(comp_n),
                    dout => compressor_out(comp_n)
                );

                -- compressor_n := compressor_n + 1;
            end generate ; -- k_compressors
        end generate ; -- if-genertate
    end generate ; -- gen_weights_cmp

    process (compressor_out, din) is
        type bit_count_t is array (0 to get_layer_weights(X, L)) of integer;

        -- Variabile per tenere traccia del numero di compressori connessi
        variable comp_n : integer := 0;

        --Tiene traccia di quanti bit sono stati usati del vettore output_weights per ogni livello
        variable bit_count_array : bit_count_t := (others => 0); 

        -- Unisce tutti i bit dello stesso peso in un array di std_logic_vector
        variable output_weights : compressors_weights_t(0 to get_layer_weights(X, L)) := (others => (others => '0')); 

        variable execution : integer := 0;

        -- Indice per tenere traccia dei bit usati nel vettore di output finale
        variable index_of_output : integer := 0;
        -- Indice per tenere traccia dei bit usati nel vettore di input iniziale
        variable index_of_input : integer := 0;

        variable pos_from_out : integer := 0;
        variable pos_to_out : integer := 0;
        variable pos_from_in : integer := 0;
        variable pos_to_in : integer := 0;

        -- For input loop
        variable in_bit_used : integer := 0;
        variable compressor_n : integer := 0;
    begin   
        comp_n := 1;
        bit_count_array := (others => 0);
        output_weights := (others => (others => '0'));
        index_of_output := 0;
        index_of_input := 0;

        if (DEBUG and execution = 0) or FORCE_DEBUG then
            report "";
            
        end if;

        -- if DEBUG then
        --     report " Activation : " & integer'image(execution);
        -- end if;
        
        ------------- CONNECTING COMPRESSORS OUT ----------------
        for weight in 0 to get_layer_weights(X, L - 1) loop
            if (DEBUG and execution = 0) or FORCE_DEBUG then
                report "Connecting " & integer'image(get_layer_compressors_n(X, L, weight)) & " compressors of weight " & integer'image(weight);
            end if;
            if get_layer_compressors_n(X, L, weight) /= 0 then
                for comp in 1 to get_layer_compressors_n(X, L, weight) loop
                    -- -- LSB
                    output_weights(weight)(bit_count_array(weight)) := compressor_out(comp_n)(0);
                    
                    output_weights(weight + 1)(bit_count_array(weight + 1)) := compressor_out(comp_n)(1);
                    
                    -- MSB
                    output_weights(weight + 2)(bit_count_array(weight + 2)) := compressor_out(comp_n)(2);
                    
                    -- Report the output weights
                    if (DEBUG and execution = 0) or FORCE_DEBUG then
                        report "    output_weights(" & integer'image(weight) & ")(" & integer'image(bit_count_array(weight)) & ") <= compressor_out(" & integer'image(comp_n) & ")(0)";
                        report "    output_weights(" & integer'image(weight + 1) & ")(" & integer'image(bit_count_array(weight + 1)) & ") <= compressor_out(" & integer'image(comp_n) & ")(1)";
                        report "    output_weights(" & integer'image(weight + 2) & ")(" & integer'image(bit_count_array(weight + 2)) & ") <= compressor_out(" & integer'image(comp_n) & ")(2)"; 
                    end if;
                    -- Update the bit count array
                    bit_count_array(weight) := bit_count_array(weight) + 1;
                    bit_count_array(weight + 1) := bit_count_array(weight + 1) + 1;
                    bit_count_array(weight + 2) := bit_count_array(weight + 2) + 1;
                    
                    -- Update the compressor number
                    comp_n := comp_n + 1;
                end loop;
            elsif get_weight_input_n(X, L, weight) /= 0 then
                pos_from_out := get_weight_input_n(X, L, weight) + bit_count_array(weight) - 1;
                pos_to_out := bit_count_array(weight);
                pos_from_in := acc_in_position(X, L, weight) + get_weight_input_n(X, L, weight) - 1;
                pos_to_in := acc_in_position(X, L, weight);
                output_weights(weight)(pos_from_out downto pos_to_out) := din(pos_from_in downto pos_to_in);
                if (DEBUG and execution = 0) or FORCE_DEBUG then
                    report "    output_weights(" & integer'image(weight) & ")(" & integer'image(pos_from_out) & " downto " & integer'image(pos_to_out) & ") <= din(" & integer'image(pos_from_in) & " downto " & integer'image(pos_to_in) & ")";
                end if;
                bit_count_array(weight) := bit_count_array(weight) + get_weight_input_n(X, L, weight);
            end if;
        end loop;

        if (DEBUG and execution = 0) or FORCE_DEBUG then
            report "";
            report "Connecting OUPUTS";
        end if;

        ------------- CONNECTING dout ----------------
        output_for : for weight in 0 to get_layer_weights(X, L) loop
            dout(index_of_output + get_layer_weight_size(X, L, weight) - 1 downto index_of_output) <= output_weights(weight)(get_layer_weight_size(X, L, weight) - 1 downto 0);
            if (DEBUG and execution = 0) or FORCE_DEBUG then
                report "    dout(" & integer'image(index_of_output + get_layer_weight_size(X, L, weight) - 1) & " downto " & integer'image(index_of_output) & ") <= output_weights(" & integer'image(weight) & ")(" & integer'image(get_layer_weight_size(X, L, weight) - 1) & " downto 0)";
            end if;
            
            index_of_output := index_of_output + get_layer_weight_size(X, L, weight);
        end loop ; -- output_for

        if (DEBUG and execution = 0) or FORCE_DEBUG then
            report "";
            report "Connecting INPUTS";
        end if;
        
        ------------- CONNECTING INPUTS ----------------
        -- Reset the compressor number
        compressor_n := 1;
        for weight in 0 to get_layer_weights(X, L) loop
            if(get_layer_compressors_n(X, L, weight) /= 0) then
                in_bit_used := get_layer_weight_size(X, L - 1, weight);
                if (DEBUG and execution = 0) or FORCE_DEBUG then
                    report "    Connecting compressors of weight " & integer'image(weight);
                end if; 

                for compressor in 1 to get_layer_compressors_n(X, L, weight) loop
                    index_of_input := acc_in_position(X, L, weight);
                    for bit_n in 0 to 5 loop
                        if in_bit_used > 0 then
                            compressor_in(compressor_n)(bit_n) <= din(index_of_input);
                            if (DEBUG and execution = 0) or FORCE_DEBUG then
                                report "    compressor_in(" & integer'image(compressor_n) & ")(" & integer'image(bit_n) & ") <= din(" & integer'image(index_of_input) & ") that was " & integer'image(to_integer(unsigned(din(index_of_input downto index_of_input))));
                                -- report "    index_of_input = " & integer'image(index_of_input);
                            end if;
                            in_bit_used := in_bit_used - 1;
                            index_of_input := index_of_input + 1;
                        else 
                            compressor_in(compressor_n)(bit_n) <= '0';
                            if (DEBUG and execution = 0) or FORCE_DEBUG then
                                report "    compressor_in(" & integer'image(compressor_n) & ")(" & integer'image(bit_n) & ") <= '0'";
                            end if;
                        end if;
                    end loop;
                    compressor_n := compressor_n + 1;
                end loop;  
            else 
                index_of_input := index_of_input + get_weight_input_n(X, L, weight);
            end if;
        end loop;

        if DEBUG then
            execution := execution + 1;
        end if;
    end process;

end Behavioral ; -- Behavioral