----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 09:19:00
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity testUtilities is
end entity;

architecture Behavioral of testUtilities is
    type h_type is array (natural range <>) of integer_array_t(0 to clog2(72));
    constant h : h_type(0 to get_popcount_levels(72)) := (
        --     0   1   2   3   4   5   6   7
        0 => (72,  0,  0,  0,  0,  0,  0,  0),
        1 => (12, 12, 12,  0,  0,  0,  0,  0),
        2 => ( 2,  4,  6,  4,  2,  0,  0,  0),
        3 => ( 2,  1,  2,  3,  4,  1,  0,  0),
        4 => ( 2,  1,  2,  3,  1,  2,  1,  0)
    );
    constant c : h_type(0 to get_popcount_levels(72)) := (
        --     0   1   2   3   4   5   6   7
        1 => (12,  0,  0,  0,  0,  0,  0,  0),
        2 => ( 2,  2,  2,  0,  0,  0,  0,  0),
        3 => ( 0,  1,  1,  1,  0,  0,  0,  0),
        4 => ( 0,  0,  0,  0,  1,  0,  0,  0),
        0 => ( 0,  0,  0,  0,  0,  0,  0,  0)
    );
    function int_array_to_string(arr: integer_array_t) return string is
        variable L : line;
        variable S : string(1 to 512);  -- dimensione massima della stringa
        variable len : natural;
      begin
        write(L, string'("["));
        for i in arr'range loop
          write(L, integer'image(arr(i)));
          if i /= arr'high then
            write(L, string'(", "));
          end if;
        end loop;
        write(L, string'("]"));
    
        -- Copia la line in una stringa statica
        len := L'length;
        if len > S'length then
          len := S'length;  -- tronca se troppo lunga
        end if;
    
        for i in 1 to len loop
          S(i) := L.all(i);
        end loop;
    
        return S(1 to len);  -- ritorna solo la parte usata
      end function;
begin
    process is
        variable weights : integer_array_t(0 to clog2(72));
    begin
        if get_popcount_levels(3) /= 0 then
            report "Test #1 FAILED";
        else
            report "Test #1 OK";
        end if;

        if get_popcount_levels(6) /= 1 then
            report "Test #2 FAILED";
        else
            report "Test #2 OK";
        end if;
        
        if get_popcount_levels(7) /= 1 then
            report "Test #3 FAILED";
        else
            report "Test #3 OK";
        end if;
        
        if get_popcount_levels(18) /= 1 then
            report "Test #4 FAILED";
        else
            report "Test #4 OK";
        end if;

        if get_popcount_levels(19) /= 2 then
            report "Test #5 FAILED";
        else
            report "Test #5 OK";
        end if;
        if get_popcount_levels(36) /= 2 then
            report "Test #6 FAILED";
        else
            report "Test #6 OK";
        end if;

        if get_popcount_levels(37) /= 4 then
            report "Test #7 FAILED";
        else
            report "Test #7 OK";
        end if;
        if get_popcount_levels(72) /= 4 then
            report "Test #8 FAILED";
        else
            report "Test #8 OK";
        end if;

        if get_popcount_levels(73) /= 4 then
            report "Test #9 FAILED";
        else
            report "Test #9 OK";
        end if;
        if get_popcount_levels(128) /= 5 then
            report "Test #10 FAILED";
        else
            report "Test #10 OK";
        end if;
        -- report "level(3): " & integer'image(get_popcount_levels(3));
        -- report "level(6): " & integer'image(get_popcount_levels(6));
        -- report "level(7): " & integer'image(get_popcount_levels(7));
        -- report "level(18): " & integer'image(get_popcount_levels(18));
        -- report "level(19): " & integer'image(get_popcount_levels(19));
        -- report "level(36): " & integer'image(get_popcount_levels(36));
        -- report "level(37): " & integer'image(get_popcount_levels(37));
        -- report "level(72): " & integer'image(get_popcount_levels(72));
        -- report "level(72): " & integer'image(get_popcount_levels(73));
        -- report "level(128): " & integer'image(get_popcount_levels(128));

        ---------------- TESTING get_weights ----------------
        report "";
        report "";
        report "Testing get_layer_info function (on weights)";
        report "";
        for level in 0 to get_popcount_levels(72) loop
            -- report "level(" & integer'image(level) & "): ";
            weights := get_info(get_layer_info(72, level), 0);
            if weights /= h(level) then
                report "Test #" & integer'image(level) & " FAILED: weights was " & int_array_to_string(weights);
            else
                report "Test #" & integer'image(level) & " OK";
            end if;
        end loop ; -- level_loop
        
        ---------------- TESTING get_layer_info ----------------
        report "";
        report "";
        report "Testing get_layer_info function (on compressors)";
        report "";
        for level in 0 to get_popcount_levels(72) loop
            -- report "level(" & integer'image(level) & "): ";
            weights := get_info(get_layer_info(72, level), 1);
            if weights /= c(level) then
                report "Test #" & integer'image(level) & " FAILED: compressors was " & int_array_to_string(weights);
            else
                report "Test #" & integer'image(level) & " OK";
            end if;
        end loop ; -- level_loop

        report "";
        report "";
        report "Testing utility functions";
        report "";
        if get_layer_outputs(72, 3) /= 13 then
            report "Test get_layer_outputs FAILED; was " & integer'image(get_layer_outputs(72, 3));
        else
            report "Test get_layer_outputs OK";
        end if;

        if get_layer_inputs(72, 3) /= 18 then
            report "Test get_layer_inputs FAILED; was " & integer'image(get_layer_inputs(72, 3));
        else
            report "Test get_layer_inputs OK";
        end if;

        if get_layer_compressors(72, 3) /= 3 then
            report "Test get_layer_compressors FAILED; was " & integer'image(get_layer_compressors(72, 3));
        else
            report "Test get_layer_compressors OK";
        end if;

        if get_layer_weight_size(72, 3, 0) /= 2 then
            report "Test get_layer_weight_size (A) FAILED; was " & integer'image(get_layer_weight_size(72, 3, 0));
        else
            report "Test get_layer_weight_size (A) OK";
        end if;

        if get_layer_weight_size(72, 3, 31) /= 0 then
            report "Test get_layer_weight_size (B) FAILED; was " & integer'image(get_layer_weight_size(72, 3, 31));
        else
            report "Test get_layer_weight_size (B) OK";
        end if;

        if get_layer_compressors_n(72, 4, 4) /= 1 then
            report "Test get_layer_compressor_n (A) FAILED; was " & integer'image(get_layer_compressorS_n(72, 3, 4));
        else
            report "Test get_layer_compressor_n (A) OK";
        end if;

        if get_layer_compressors_n(72, 4, 31) /= 0 then
            report "Test get_layer_compressor_n (B) FAILED; was " & integer'image(get_layer_compressorS_n(72, 3, 31));
        else
            report "Test get_layer_compressor_n (B) OK";
        end if;

        wait;
    end process;
end Behavioral;