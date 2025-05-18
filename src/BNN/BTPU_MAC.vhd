----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2025 11:14:21 AM
-- Design Name: 
-- Module Name: BTPU_MAC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;

entity btpu_mac is
    generic (
        X : integer := 32;
        ACC_SIZE : integer := 16;
        TILES_N  : integer := 4;
        SIMULATION : boolean := false
    );
    port ( 
        acc_clk     : in STD_LOGIC;
        acc_resn    : in STD_LOGIC;
        en          : in STD_LOGIC;
        a           : in STD_LOGIC_VECTOR (X - 1 downto 0);
        b           : in STD_LOGIC_VECTOR (X - 1 downto 0);
        tile_n      : in unsigned(clog2(TILES_N) - 1 downto 0);
        size        : in STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0);
        res_sign    : out STD_LOGIC;
        res         : out STD_LOGIC_VECTOR (clog2(X) - 1 downto 0);
        acc         : out STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0)
    );
end btpu_mac;

architecture Behavioral of btpu_mac is
    type accumulator_t is array (0 to TILES_N - 1) of STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0);
    -- signal accumulator : STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0) := (others => '0');
    signal accumulator : accumulator_t := (others => (others => '0'));
    signal popcount : STD_LOGIC_VECTOR (clog2(X) - 1 downto 0) := (others => '0');
    signal size_u   : unsigned(ACC_SIZE - 1 downto 0) := (others => '0');
    signal binary_product : STD_LOGIC_VECTOR (X - 1 downto 0) := (others => '0');
begin

    -- Beahavioral implementation of the popcounter
    behavioral_inst : if SIMULATION = false generate
        -- Binary MAC
        binary_mac_inst : entity work.binary_mac
        generic map (
            X => X
        )
        port map (
            a => a,
            b => b,
            dout => popcount
        );
    end generate behavioral_inst;

    -- Simulation implementation of the popcounter
    simulation_inst : if SIMULATION = true generate
        popcounter_pro : process( a, b ) is
            variable binary_product_v : STD_LOGIC_VECTOR (X - 1 downto 0);
            variable popcount_temp : unsigned (clog2(X) - 1 downto 0);
        begin
            binary_product_v := a xnor b;
            popcount_temp := (others => '0');
            for i in 0 to X - 1 loop
                if binary_product_v(i) = '1' then
                    popcount_temp := popcount_temp + 1;
                end if;
            end loop;
            popcount <= std_logic_vector(popcount_temp);
            binary_product <= binary_product_v;
        end process ; -- popcounter_pro
    end generate simulation_inst;
    
    process(acc_clk) is
        variable acc_addr : integer;    
    begin
        if rising_edge(acc_clk) then
            acc_addr := to_integer(tile_n);
            if acc_resn = '0' then
                accumulator(acc_addr) <= (others => '0');
            else
                if en = '1' then
                    accumulator(acc_addr) <= std_logic_vector(unsigned(accumulator(acc_addr)) + unsigned(popcount));
                end if;
            end if;
        end if ;
    end process;
    
    -- Size conversion
    size_u <= unsigned(size(ACC_SIZE - 1 downto 0));

    -- Output assignment
    res <= popcount;
    acc <= accumulator(to_integer(tile_n));
    res_sign <= '0' when (unsigned(accumulator(to_integer(tile_n))) < size_u) else '1';

end Behavioral;
