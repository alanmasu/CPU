----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2018 11:15:57 AM
-- Design Name: 
-- Module Name: delay_module - Behavioral
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

entity delay_module is
  generic (
    -- Size of lower counter. The resolution of the delay is
    -- r = clock period * 2^resolution [s]
    resolution : integer := 17;
    -- The range of the counter. The highest time is equal to
    -- r * 2^scale
    scale : integer := 8
  );
  port (
    -- System clock
    clock : in std_logic;
    -- Global reset (active low)
    reset : in std_logic;
    -- Start delay computation
    start : in std_logic;
    -- Delay amount
    delay_ms : in std_logic_vector( scale - 1 downto 0 );
    -- Done flag
    done : out std_logic
  );
end delay_module;

architecture behavioral of delay_module is

  -- Low counter counts up to 10.5us with 100 MHz clock
  signal low_counter : unsigned( resolution downto 0 );
  -- High counter counts each time low counter terminates
  signal high_counter : unsigned( scale - 1 downto 0 );
  signal count_init, count_en : std_logic;

  signal local_delay : unsigned( scale - 1 downto 0 );
  signal load_en : std_logic;

  type state_t is ( idle, count, timesup );
  signal pstate, nstate : state_t;


begin

  -- State machine
  process ( clock, reset ) begin
    if ( reset = '0' ) then
      pstate <= idle;
    elsif rising_edge( clock ) then
      pstate <= nstate;
    end if;
  end process;

  process ( pstate, start, local_delay, high_counter ) begin
    -- Start with obvious defaults: nothing changes
    nstate <= pstate;
    count_init <= '0';
    count_en <= '0';
    done <= '0';
    load_en <= '0';
    -- Switch on the current state
    case pstate is
      when idle =>
        count_init <= '1';
        if ( start = '1' ) then
          load_en <= '1';
          nstate <= count;
        end if;
      when count =>
        count_en <= '1';
        if ( local_delay = high_counter ) then
          nstate <= timesup;
        end if;
      when timesup =>
        done <= '1';
        nstate <= idle;
    end case;
  end process;

  process ( clock, reset ) begin
    if ( reset = '0' ) then
      local_delay <= to_unsigned( 0, scale );
    elsif rising_edge( clock ) then
      if ( load_en = '1' ) then
        local_delay <= unsigned( delay_ms );
      end if;
    end if;
  end process;

  -- Counter process
  process ( clock, reset ) begin
    if ( reset = '0' ) then
      low_counter <= to_unsigned( 0, resolution + 1 );
      high_counter <= to_unsigned( 0, scale );
    elsif rising_edge( clock ) then
      if ( count_init = '1' ) then
        low_counter <= to_unsigned( 0, resolution + 1 );
        high_counter <= to_unsigned( 0, scale );
      elsif ( count_en = '1' ) then
        if ( low_counter( resolution ) = '1' ) then
          low_counter <= to_unsigned( 0, resolution + 1 );
          high_counter <= high_counter + 1;
        else
          low_counter <= low_counter + 1;
        end if;
      end if;
    end if;
  end process;


end behavioral;
