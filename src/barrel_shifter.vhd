library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity barrell_shifter is
    port (
        arithm_logicn, right_leftn: in std_logic;
        shamt: in std_logic_vector(4 downto 0);
        data_in:in std_logic_vector (31 downto 0);
        data_out:out std_logic_vector (31 downto 0)
    );
end barrell_shifter;

architecture combinatorio of barrell_shifter is begin
    process (arithm_logicn, right_leftn, data_in, shamt)
        variable d: std_logic_vector (31 downto 0);
    begin
        d := data_in;
        if right_leftn = '0' then
            if shamt(4) = '1' then
                d(31 downto 16) := d(15 downto 0);
                d(15 downto 0) := (others => '0');
            end if;
            if shamt(3) = '1' then
                d(31 downto 8) := d(23 downto 0);
                d(7 downto 0) := (others => '0');
            end if ;
            if shamt(2) = '1' then
                d(31 downto 4) := d(27 downto 0);
                d(3 downto 0) := (others => '0');
            end if ;
            if shamt(1) = '1' then
                d(31 downto 2) := d(29 downto 0);
                d(1 downto 0) := (others => '0');
            end if ;
            if shamt(0) = '1' then
                d(31 downto 1) := d(30 downto 0);
                d(0) := '0';
            end if ;
        elsif right_leftn = '1' then
            if shamt(4) = '1' then
                d(15 downto 0) := d(31 downto 16);
                if arithm_logicn = '0' then
                    d(31 downto 16) := (others => '0');
                elsif arithm_logicn = '1' then
                    d(31 downto 16) := (others => d(15));
                end if ;
            end if;
            if shamt(3) = '1' then
                d(23 downto 0) := d(31 downto 8);
                if arithm_logicn = '0' then
                    d(31 downto 24) := (others => '0');
                elsif arithm_logicn = '1' then
                    d(31 downto 14) := (others => d(23));
               end if ;
            end if ;
            if shamt(2) = '1' then
                d(27 downto 0) := d(31 downto 4);
                if arithm_logicn = '0' then
                    d(31 downto 28) := (others => '0');
                elsif arithm_logicn = '1' then
                    d(31 downto 28) := (others => d(27));
               end if ;
            end if ;
            if shamt(1) = '1' then
                d(29 downto 0) := d(31 downto 2);
                if arithm_logicn = '0' then
                    d(31 downto 30) := (others => '0');
                elsif arithm_logicn = '1' then
                    d(31 downto 30) := (others => d(29));
               end if ;
            end if ;
            if shamt(0) = '1' then
                d(30 downto 0) := d(31 downto 1);
                if arithm_logicn = '0' then
                    d(31) := '0';
                elsif arithm_logicn = '1' then
                    d(31) := d(30);
               end if ;
            end if ;
        end if;
        data_out <= d;
    end process;
end combinatorio;