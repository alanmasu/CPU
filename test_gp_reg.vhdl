library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_gp_reg is
end test_gp_reg;

architecture behavioral of test_gp_reg is

    signal clk, res, le : std_logic := '0';
    signal d_in, d_out : std_logic_vector(31 downto 0) := (others => '0');

begin

    dut: entity work.gp_reg
        port map(
            clk, res, le, d_in, d_out
        );

    clk_gen : process begin
        clk <= not clk;
        wait for 5 ns;        
    end process ; -- clk_gen

    test_process : process begin
        wait for 100 ns;
        res <= '1';
        le <= '1';
        d_in <= "00000000101001010010111110110110";
        wait for 10 ns;
        d_in <= "00000000000001010010111110110110";
        wait for 10 ns;
        le <= '0';
        d_in <= "00000000000001111111111110110110";
        wait for 10 ns;
        le <= '1';
        wait;
    end process ; -- test_process

end behavioral  ; -- behavioral 