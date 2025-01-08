----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2023 07:29:10 PM
-- Design Name: 
-- Module Name: address_manager - Behavioral
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

library work;
use work.memory_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity address_manager is
    Port ( 
        address : in STD_LOGIC_VECTOR (31 downto 0);
        en_in : in STD_LOGIC;
        en_out : out en_bus_t
    );
end address_manager;

architecture Behavioral of address_manager is
    signal mem_en : STD_LOGIC;
    signal axi_en : STD_LOGIC;
begin

    comb_process : process( address, en_in )
    begin
        if en_in = '1' then
            en_out.en_mem <= is_in_space(address, RAM);
            en_out.en_AXI <= is_in_space(address, AXI) or is_in_space(address, ROM);
        else 
            en_out <= (others => '0');
        end if ;
    end process ; -- comb_process

end Behavioral;
