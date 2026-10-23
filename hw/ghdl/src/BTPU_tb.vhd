library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;
use work.types_pkg.all;
use work.constant_package.all;
use work.memory_pkg.all;

entity BTPU_tb is
end BTPU_tb;

architecture Behavioral of BTPU_tb is
    signal clk : STD_LOGIC;
    signal res : STD_LOGIC;

    signal hs_clk : STD_LOGIC;

    -- BRAM Port A
    signal ena     : en_bus_t;
    signal wea     : STD_LOGIC_VECTOR(3 downto 0);
    signal addra   : STD_LOGIC_VECTOR(31 downto 0);
    signal dina    : STD_LOGIC_VECTOR(31 downto 0);
    signal douta   : STD_LOGIC_VECTOR(31 downto 0);

    -- BRAM Port B
    signal enb     : STD_LOGIC;
    signal web     : STD_LOGIC_VECTOR(3 downto 0);
    signal addrb   : STD_LOGIC_VECTOR(31 downto 0);
    signal dinb    : STD_LOGIC_VECTOR(31 downto 0);
    signal doutb   : STD_LOGIC_VECTOR(31 downto 0);
begin
    dut : entity work.BTPU
    generic map (
        SIMULATION => true,
        DEBUG => true
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
