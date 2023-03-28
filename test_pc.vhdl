library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_pc is
end test_pc;

architecture behavioral of test_pc is

    signal clk, res, le : std_logic := '0';
    signal npc, pc, parallel_in: std_logic_vector(9 downto 0);
    signal sel : std_logic := '0';

begin

    dut: entity work.program_counter
        port map(
            clk, res, le, parallel_in, npc, pc
        );

    clk_gen : process begin
        clk <= not clk;
        wait for 5 ns;        
    end process ; -- clk_gen

    test_process : process begin
        wait for 100 ns;
        res <= '1';
        le <= '1';
        wait for 700 ns;
        le <= '0';
        wait for 40 ns;
        le <= '1';
        wait for 360 ns;
        sel <= '1';
        wait for 10 ns;
        sel <= '0';
        wait;
    end process ; -- test_process

    parallel_in <= npc when sel = '0' else "0010101011";

end behavioral  ; -- behavioral 