library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gp_reg is
    generic( dim : integer := 32 );
    port (
        clk, res, le : in std_logic;
        d_in: in std_logic_vector(dim-1 downto 0);
        d_out: out std_logic_vector(dim-1 downto 0)
    ) ;
end gp_reg;

architecture behavioral of gp_reg is begin
    sincrono : process( clk, res )
    begin
        if res = '0' then
            d_out <= (others => '0');
        elsif rising_edge(clk) then
            if le = '1' then
                d_out <= d_in;
            end if ;
        end if ;
    end process ; -- sincrono
end behavioral ; -- behavioral