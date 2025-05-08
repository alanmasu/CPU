----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2018 04:56:33 PM
-- Design Name: 
-- Module Name: spi_controller - Behavioral
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

entity spi_controller is
  port (
    -- System clock
    clock : in std_logic;
    -- Global reset (active low)
    reset : in std_logic;
    -- Start transmission
    start : in std_logic;
    -- Data to be transmitted, 8 bits
    data_in : in std_logic_vector( 7 downto 0 );
    -- Serial data out
    sdata : out std_logic;
    -- Serial clock out
    sclk : out std_logic;
    -- Latch flag
    latch : out std_logic;
    -- Done flag
    done : out std_logic
  );
end spi_controller;

architecture behavioral of spi_controller is
  -- Type for the states of the control state machine
  type state_t is ( idle, transmit );
  -- Present and next state
  signal pstate, nstate : state_t;
  -- Present and next value of the SPI clock
  signal psclk, nsclk : std_logic;

  -- Counters
  -- Clock counter. It is used to generate a slower clock for the SPI. With 4
  -- bits, running at 100 MHz, each semi-period of the clock is 100 MHz/16, or
  -- 6.25 MHz. The SPI clock thus goes at 6.25 / 2 = 3.125 MHz. One 8-bit
  -- transmission lasts 2.56 us.
  signal clk_counter : unsigned( 3 downto 0 );
  signal clk_count_en : std_logic;
  signal clk_tc : std_logic;
  -- Bit counter. It is used to count the bits that have been transmitted. We
  -- send 8 bits at a time, so we need 3 bits for the counter.
  signal bit_counter : unsigned( 2 downto 0 );
  signal bit_count_en : std_logic;
  signal bit_tc : std_logic;
  -- Counter initialization is shared by the two counters
  signal count_init : std_logic;

  -- Store the data to be transmitted here
  signal shift_register : std_logic_vector( 7 downto 0 );
  signal load_en : std_logic;
  signal shift_en : std_logic;
  
begin

  sclk <= psclk;

  -- State machine update process
  process ( clock, reset ) begin
    if ( reset = '0' ) then
      pstate <= idle;
      psclk <= '1';
    elsif ( rising_edge( clock ) ) then
      pstate <= nstate;
      psclk <= nsclk;
    end if;
  end process;

  -- Next state and output computation.
  process ( pstate, psclk, start, clk_tc, bit_tc ) begin
    -- Start with obvious defaults: nothing changes
    nstate <= pstate;
    nsclk <= psclk;
    count_init <= '0';
    load_en <= '0';
    latch <= '0';
    done <= '0';
    clk_count_en <= '0';
    bit_count_en <= '0';
    shift_en <= '0';
    -- Switch on the current state
    case pstate is
      when idle =>
        count_init <= '1';
        done <= '0';
        if ( start = '1' ) then
          nstate <= transmit;
          nsclk <= '0';
          load_en <= '1';
          latch <= '1';
          done <= '0';
        end if;
      when transmit =>
        clk_count_en <= '1';
        case psclk is
          when '0' =>
            if ( clk_tc = '1' ) then
              nsclk <= '1';
            end if;
          when '1' =>
            if ( clk_tc = '1' ) then
              shift_en <= '1';
              if ( bit_tc = '0' ) then
                bit_count_en <= '1';
                nsclk <= '0';
              else
                nstate <= idle;
                done <= '1';
              end if;
            end if;
          when others =>
        end case;
    end case;
  end process;

  -- Shift register update
  process ( clock, reset ) begin
    if ( reset = '0' ) then
      shift_register <= ( others => '0' );
    elsif ( rising_edge( clock ) ) then
      if ( load_en = '1' ) then
        shift_register <= data_in;
      elsif ( shift_en = '1' ) then
        shift_register <= shift_register( 6 downto 0 ) & '0';
      end if;
    end if;
  end process;
  -- The serial data output is equal to the most significant bit of the shift
  -- register
  sdata <= shift_register( 7 );

  -- Counters
  process ( clock, reset ) begin
    if ( reset = '0' ) then
      clk_counter <= ( others => '1' );
    elsif ( rising_edge( clock ) ) then
      if ( count_init = '1' ) then
        clk_counter <= ( others => '1' );
      elsif ( clk_count_en = '1' ) then
        clk_counter <= clk_counter - 1;
      end if;
    end if;
  end process;
  clk_tc <= '1' when clk_counter = 0 else '0';

  process ( clock, reset ) begin
    if ( reset = '0' ) then
      bit_counter <= ( others => '1' );
    elsif ( rising_edge( clock ) ) then
      if ( count_init = '1' ) then
        bit_counter <= ( others => '1' );
      elsif ( bit_count_en = '1' ) then
        bit_counter <= bit_counter - 1;
      end if;
    end if;
  end process;
  bit_tc <= '1' when bit_counter = 0 else '0';

end behavioral;
