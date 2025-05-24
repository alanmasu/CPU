
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;
use work.types_pkg.all;
use work.constant_package.all;
use work.memory_pkg.all;

entity btpu_wrapper is
    port ( 
        clk : in STD_LOGIC;
        res : in STD_LOGIC;

        hs_clk : in STD_LOGIC;

        -- BRAM Port A
        ena     : in STD_LOGIC_VECTOR(3 downto 0);
        wea     : in STD_LOGIC_VECTOR(3 downto 0);
        addra   : in STD_LOGIC_VECTOR(31 downto 0);
        dina    : in STD_LOGIC_VECTOR(31 downto 0);
        douta   : out STD_LOGIC_VECTOR(31 downto 0);

        -- BRAM Port B
        enb     : in STD_LOGIC;
        web     : in STD_LOGIC_VECTOR(3 downto 0);
        addrb   : in STD_LOGIC_VECTOR(31 downto 0);
        dinb    : in STD_LOGIC_VECTOR(31 downto 0);
        doutb   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end btpu_wrapper;

architecture Behavioral of btpu_wrapper is 
    signal ena_int : en_bus_t := (others => '0');
begin

    -- BTPU instantiation
    btpu_inst : entity work.btpu
    generic map (
        SIMULATION => false,
        DEBUG => false
    )
    port map (
        clk => clk,
        res => res,

        hs_clk => hs_clk,

        ena => ena_int,
        wea => wea,
        addra => addra,
        dina => dina,
        douta => douta,

        enb => enb,
        web => web,
        addrb => addrb,
        dinb => dinb,
        doutb => doutb
    );
    
    ena_int.en_BTPU_CREG <= ena(0);
    ena_int.en_BTPU_W_MEM <= ena(1);
    ena_int.en_BTPU_IO0_MEM <= ena(2);
    ena_int.en_BTPU_IO1_MEM <= ena(3);
    
end Behavioral;