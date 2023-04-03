library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  generic( modulo : integer := 3 );
  port (
    clock, reset, count_en, count_init : in std_logic;
    u : out unsigned(modulo-1 downto 0);
    tc : out std_logic
  ) ;
end counter;

architecture comportamentale of counter is
  signal tc_num : unsigned(modulo-1 downto 0) := (others => '1');
  signal val : unsigned(modulo-1 downto 0) := to_unsigned(0, modulo);
begin
  msf : process( clock, reset )
  begin
    if reset = '0' then
      val <= to_unsigned(0, modulo);--(others => '0');
    elsif rising_edge(clock) then
      if count_init = '1' then
        val <= to_unsigned(0, modulo);
      elsif count_en = '1' then
        val <= val + 1;
      end if ;
    end if ;
  end process ; -- msf
  u <= val;
  tc <= '1' when val = tc_num else '0';
end comportamentale ; -- comportamentale