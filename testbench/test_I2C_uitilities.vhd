library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.i2c_utils_pkg.all;

entity test_I2C_utilities is
end test_I2C_utilities;

architecture Behavioral of test_I2C_utilities is
    signal s_f : integer := 100000; --Source freq 100MHz
    signal s_f2: integer := 40000; --Source freq2 40MHz
    signal w_f : integer := 400; --Wanted freq 400KHz
    signal w_f_u : unsigned(31 downto 0);
    
    signal f_count : integer;
    signal f_count_u : unsigned(6 downto 0);
    signal dim : integer;

begin

    process begin
        f_count <= freq2count(w_f, s_f);
        -- f_count_u <= freq2count_u(w_f, s_f);
        wait for 1 ns;
        if f_count = 250 then
            report "Test #1: OK";
        else
            assert false report "Test #1: FAIL -> f_count was " & integer'image(f_count);
        end if;
        

        dim <= freq2dim(w_f, s_f);
        wait for 1 ns;
        if(dim = 8) then
            report "Test #2: OK";
        else
            assert false report "Test #2: FAIL -> dim was " & integer'image(dim);
        end if;


        f_count_u <= freq2count_u(w_f, s_f2);
        wait for 1 ns;
        if f_count_u = to_unsigned(100, 32) then
            report "Test #3: OK";
        else
            report "Test #3: FAIL";
        end if;

        
        wait;
    end process ; 

end Behavioral;