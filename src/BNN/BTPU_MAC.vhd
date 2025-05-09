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

entity BTPU_MAC is
    generic (
        X : integer := 32;
        ACC_SIZE : integer := 16;
        SIMULATION : boolean := false
    );
    port ( 
        acc_clk : in STD_LOGIC;
        acc_resn : in STD_LOGIC;
        a : in STD_LOGIC_VECTOR (X - 1 downto 0);
        b : in STD_LOGIC_VECTOR (X - 1 downto 0);
        size : in STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0);
        res_sign : out STD_LOGIC;
        res : out STD_LOGIC_VECTOR (clog2(X) - 1 downto 0);
        acc : out STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0)
    );
end BTPU_MAC;

architecture Behavioral of BTPU_MAC is
    signal accumulator : STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0) := (others => '0');
    signal popcount : STD_LOGIC_VECTOR (clog2(X) - 1 downto 0) := (others => '0');
    signal size_u   : unsigned(ACC_SIZE - 1 downto 0) := (others => '0');
begin

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
    
    process(acc_clk) begin
        if rising_edge(acc_clk) then
            if acc_resn = '0' then
                accumulator <= (others => '0');
            else
                accumulator <= std_logic_vector(unsigned(accumulator) + unsigned(popcount));
            end if;
        end if ;
    end process;
    
    -- Size conversion
    size_u <= unsigned(size(ACC_SIZE - 1 downto 0));

    -- Output assignment
    res <= popcount;
    acc <= accumulator;
    res_sign <= '0' when (unsigned(accumulator) < size_u) else '1';

end Behavioral;


architecture SimulationArch of BTPU_MAC is
    signal accumulator : STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0) := (others => '0');
    signal popcount : STD_LOGIC_VECTOR (clog2(X) - 1 downto 0) := (others => '0');
    signal size_u   : unsigned(ACC_SIZE - 1 downto 0) := (others => '0');
begin

    popcounter_pro : process( a, b ) is
        variable binary_product : STD_LOGIC_VECTOR (X - 1 downto 0);
        variable popcount_temp : unsigned (clog2(X) - 1 downto 0);
    begin
        binary_product := a xnor b;
        popcount_temp := (others => '0');
        for i in 0 to X - 1 loop
            if binary_product(i) = '1' then
                popcount_temp := popcount_temp + 1;
            end if;
        end loop;
        popcount <= std_logic_vector(popcount_temp);
        
    end process ; -- popcounter_pro

    
    process(acc_clk) begin
        if rising_edge(acc_clk) then
            if acc_resn = '0' then
                accumulator <= (others => '0');
            else
                accumulator <= std_logic_vector(unsigned(accumulator) + unsigned(popcount));
            end if;
        end if ;
    end process;
    
    -- Size conversion
    size_u <= unsigned(size(ACC_SIZE - 1 downto 0));

    -- Output assignment
    res <= popcount;
    acc <= accumulator;
    res_sign <= '0' when (unsigned(accumulator) < size_u) else '1';
end SimulationArch ; -- SimulationArch