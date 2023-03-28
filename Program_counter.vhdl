library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
  port (
    clk, res, le: in std_logic;
    parallel_in : in std_logic_vector(9 downto 0);
    npc, pc : out std_logic_vector(9 downto 0)
  );
end program_counter;

architecture behavioral of program_counter is
    signal val : unsigned(9 downto 0);

begin
    sincrono : process( clk, res )
    begin
        if res = '0' then
            val <= to_unsigned(0, 10);
        elsif rising_edge(clk) then
            if le = '1' then
                val <= unsigned(parallel_in);
            end if ;
        end if ;
    end process ; -- sincrono
    
    pc <= std_logic_vector(val);
    npc <= std_logic_vector(val + 1);

end behavioral ; -- behavioral