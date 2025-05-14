----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 09:19:00
-- Design Name: 
-- Module Name: popcounter_tree - Behavioral
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

entity popcounter_tree is
    generic (
        X : integer := 128;

        DEBUG : boolean := false;
        FORCE_DEBUG : boolean := false;
        DEBUG_LAYERS : boolean := false;
        FORCE_DEBUG_LAYERS : boolean := false
    );
    Port ( 
        din : in STD_LOGIC_VECTOR (X-1 downto 0);
        dout : out STD_LOGIC_VECTOR (get_layer_outputs(X, get_popcount_levels(X)) - 1 downto 0)
    );
end popcounter_tree;

architecture Behavioral of popcounter_tree is
    
--    component compressor_layer is
--        generic (
--            X : integer := 128;
--            L : integer := 1;
    
--            -- Definizione costante per la stampa
--            DEBUG : boolean := false;
--            FORCE_DEBUG : boolean := false
--        );
--        port (
--            din  : in  STD_LOGIC_VECTOR (get_layer_inputs(X, L)  - 1 downto 0);
--            dout : out STD_LOGIC_VECTOR (get_layer_outputs(X, L) - 1 downto 0)
--        ) ;
--    end component;

    type stdv_array_t is array (natural range <>) of std_logic_vector(X-1 downto 0);

    signal layer_interconnect : stdv_array_t(1 to get_popcount_levels(X)) := (others => (others => '0'));

begin
    layers_gen : for layer in 1 to get_popcount_levels(X) generate
        first_layer : if layer = 1 generate
            process begin
                if DEBUG then
                    report "Generating layer " & integer'image(layer);
                    report "    connecting din <= din";
                    report "    connecting dout <= layer_interconnect(" & integer'image(layer) & ")(" & integer'image(get_layer_outputs(X, layer)) & " downto 0)"; 
                end if ;
                wait;
            end process ; -- 

            layer_comp : entity work.compressor_layer
            generic map (
                X => X,
                L => layer,
                DEBUG => DEBUG_LAYERS,
                FORCE_DEBUG => FORCE_DEBUG_LAYERS
            )
            port map (
                din  => din,
                dout => layer_interconnect(layer)(get_layer_outputs(X, layer) - 1 downto 0)
            );
        else generate
            others_layer : if layer > 1 and layer /= get_popcount_levels(X) generate 
                process begin
                    if DEBUG then
                        report "Generating layer " & integer'image(layer);
                        report "    connecting din <= layer_interconnect(" & integer'image(layer - 1) & ")(" & integer'image(get_layer_inputs(X, layer)) & " downto 0)";
                        report "    connecting dout <= layer_interconnect(" & integer'image(layer) & ")(" & integer'image(get_layer_outputs(X, layer)) & " downto 0)"; 
                    end if ;
                    wait;
                end process ;

                layer_comp : entity work.compressor_layer
                generic map (
                    X => X,
                    L => layer,
                    DEBUG => DEBUG_LAYERS,
                    FORCE_DEBUG => FORCE_DEBUG_LAYERS
                )
                port map (
                    din  => layer_interconnect(layer - 1)(get_layer_inputs(X, layer) - 1 downto 0),
                    dout => layer_interconnect(layer)(get_layer_outputs(X, layer) - 1 downto 0)
                );
            else generate
                final_layer : if layer = get_popcount_levels(X) generate
                    process begin
                        if DEBUG then
                            report "Generating layer " & integer'image(layer);
                            report "    connecting din <= layer_interconnect(" & integer'image(layer - 1) & ")(" & integer'image(get_layer_inputs(X, layer)) & " downto 0)";
                            report "    connecting dout <= dout"; 
                        end if ;
                        wait;
                    end process ;

                    layer_comp : entity work.compressor_layer
                    generic map (
                        X => X,
                        L => layer,
                        DEBUG => DEBUG_LAYERS,
                        FORCE_DEBUG => FORCE_DEBUG_LAYERS
                    )
                    port map (
                        din  => layer_interconnect(layer - 1)(get_layer_inputs(X, layer) - 1 downto 0),
                        dout => dout
                    );
                else generate
                            
                end generate; -- final_layer;
            end generate; --others_layer; 
        end generate ; -- initial_leyer
    end generate ; -- layers_gen
end Behavioral;