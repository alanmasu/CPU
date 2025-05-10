
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;
use work.types_pkg.all;
use work.constant_package.all;
use work.memory_pkg.all;

entity BTPU_wrapper is
    port ( 
        clk : in STD_LOGIC;
        res : in STD_LOGIC;

        hs_clk : in STD_LOGIC;

        -- BRAM Port A
        ena     : in en_bus_t;
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
end BTPU_wrapper;

architecture Behavioral of BTPU_wrapper is begin

    -- BTPU instantiation
    BTPU_inst : entity work.BTPU
    generic map (
        SIMULATION => true,
        DEBUG => false
    )
    port map (
        clk => clk,
        res => res,

        hs_clk => hs_clk,

        ena => ena,
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
end Behavioral;