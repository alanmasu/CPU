----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2023 09:04:22 AM
-- Design Name: 
-- Module Name: clog2_pkg - Behavioral
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

package i2c_utils_pkg is
    function clog2(x : positive) return natural;
    function freq2count(f : integer; f_source : integer := 100000) return integer;
    function freq2count_u(f : integer; f_source : integer := 100000) return unsigned;
    function freq2dim(f : integer; f_source : integer := 100000) return integer;
    function stdv2int(x : std_logic_vector) return integer;
end package i2c_utils_pkg;

package body i2c_utils_pkg is
    function clog2(x : positive) return natural is
        variable r  : natural := 0;
        variable rp : natural := 1; -- rp tracks the value 2**r
    begin 
        while rp < x loop -- Termination condition T: x <= 2**r
            -- Loop invariant L: 2**(r-1) < x
            r := r + 1;
            if rp > integer'high - rp then exit; end if;  -- If doubling rp overflows
            -- the integer range, the doubled value would exceed x, so safe to exit.
            rp := rp + rp;
        end loop;
        -- L and T  <->  2**(r-1) < x <= 2**r  <->  (r-1) < log2(x) <= r
        return r; --
    end clog2;

    --! @brief Frequency to cycle counter
    --! @param f Frequency wanted in KHz
    --! @param f_source Frequency source in KHz (default 100MHz)
    --! @return [integer] Counter value 
    function freq2count(f : integer; f_source : integer := 100000) return integer is
        variable counter : integer := 0;
    begin 
        counter := f_source/f;
        return counter;
    end function;

    --! @brief Frequency to cycle counter
    --! @param f Frequency wanted in KHz
    --! @param f_source Frequency source in KHz (default 100MHz)
    --! @return [unsigned] Counter value 
    function freq2count_u(f : integer; f_source : integer := 100000) return unsigned is
        variable counter : integer := 0;
        variable counter_u : unsigned (freq2dim(f, f_source)-1 downto 0) := (others => '0');
    begin 
        counter := freq2count(f, f_source);
        counter_u := to_unsigned(counter, freq2dim(f, f_source));
        report integer'image(to_integer(counter_u));
        return counter_u;
    end function;

    --@brief Frequency to dim std_logic_vector dimension
    --@param f Frequency wanted in KHz
    --@param f_source Frequency source in KHz (default 100MHz)
    --@return [integer] Dimension value
    function freq2dim(f : integer; f_source : integer := 100000) return integer is
        variable dim : integer := 0;
    begin
        dim := clog2(freq2count(f, f_source));
        return dim;
    end function;

    function stdv2int(x : std_logic_vector) return integer is
    begin
        return to_integer(unsigned(x));
    end function;
end package body i2c_utils_pkg;
