----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2025 08:54:25 AM
-- Design Name: 
-- Module Name: GPIO - Behavioral
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


-- Address description
-- 0x00000000 : GPIO state register
-- 0x00000004 : GPIO direction register
-- 0x00000008 : GPIO output register

-- GPIO direction register
-- 0 : input
-- 1 : output

-- ENA
-- 0 : disable 
-- 1 : enable (read/write)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GPIO is
    -- Generic (
    --     GPIO_SIZE : integer := 1 -- Number of GPIO banks of 8 bits
    -- );
    Port ( 
        clk     : in STD_LOGIC;
        res     : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR (31 downto 0);
        d_in    : in STD_LOGIC_VECTOR (31 downto 0);
        d_out   : buffer STD_LOGIC_VECTOR (31 downto 0);
        wea     : in STD_LOGIC_VECTOR (3 downto 0);
        ena     : in STD_LOGIC;
        GPIO    : inout STD_LOGIC_VECTOR (31 downto 0)
        -- GPIO_out : inout STD_LOGIC_VECTOR (GPIO_SIZE-1 downto 0)
    );
end GPIO;

architecture Behavioral of GPIO is
    signal GPIO_dir     : STD_LOGIC_VECTOR (31 downto 0);
    signal GPIO_reg     : STD_LOGIC_VECTOR (31 downto 0);
    signal GPIO_state   : STD_LOGIC_VECTOR (31 downto 0);

    -- For Testing
    signal gpio_dir_s   : STD_LOGIC_VECTOR (7 downto 0);
    signal gpio_reg_s   : STD_LOGIC_VECTOR (7 downto 0);
    signal gpio_state_s : STD_LOGIC_VECTOR (7 downto 0);
    signal gpio_out_s   : STD_LOGIC_VECTOR (7 downto 0);
begin
    -- For testing
    gpio_state_s <= GPIO_state(7 downto 0);
    gpio_dir_s <= GPIO_dir(7 downto 0);
    gpio_reg_s <= GPIO_reg(7 downto 0);
    gpio_out_s <= GPIO(7 downto 0);
    
    -- Registro di stato [combinatorio]
    GPIO_state <= GPIO;
    
    -- Processo sequenziale
    sequential_pro : process( clk, res ) begin
        if res = '0' then
            GPIO_dir <= (others => '0');
            GPIO_reg <= (others => '0');
            d_out <= (others => '0');
        elsif rising_edge(clk) then
            d_out <= d_out;         -- latched value

            if ena = '1' then       -- if Enabled
                case(address(3 downto 0)) is
                    when x"0" =>    -- READ
                        d_out <= GPIO_state;
                    when x"4" =>    -- DIR
                        if wea(0) = '1' then
                            GPIO_dir(7 downto 0) <= d_in(7 downto 0);
                        end if;
                        if wea(1) = '1' then
                            GPIO_dir(15 downto 8) <= d_in(15 downto 8);
                        end if;
                        if wea(2) = '1' then
                            GPIO_dir(23 downto 16) <= d_in(23 downto 16);
                        end if;
                        if wea(3) = '1' then
                            GPIO_dir(31 downto 24) <= d_in(31 downto 24);
                        end if;
                        d_out <= GPIO_dir;
                    when x"8" =>    --WRITE     
                        if wea(0) = '1' then
                            GPIO_reg(7 downto 0) <= d_in(7 downto 0);
                        end if;
                        if wea(1) = '1' then
                            GPIO_reg(15 downto 8) <= d_in(15 downto 8);
                        end if;
                        if wea(2) = '1' then
                            GPIO_reg(23 downto 16) <= d_in(23 downto 16);
                        end if;
                        if wea(3) = '1' then
                            GPIO_reg(31 downto 24) <= d_in(31 downto 24);
                        end if;
                        d_out <= GPIO_reg;
                    when others =>
                        -- LATCH Inference
                        d_out <= d_out;
                        GPIO_reg <= GPIO_reg;
                        GPIO_dir <= GPIO_dir;
                end case;
            end if;
        end if;
    end process ; -- sequential_pro
    
    -- Processo combinatorio
    GPIO_pro : process(res, GPIO_dir, GPIO_reg )    
    begin
        if res = '0' then
            GPIO <= (others => 'Z');
        else
            if ena = '1' then
                for i in 0 to 31 loop
                    if GPIO_dir(i) = '1' then
                        GPIO(i) <= gpio_reg(i);
                    else
                        GPIO(i) <= 'Z';
                    end if ;
                end loop ;
            end if ;
        end if ;
    end process ; -- GPIO_pro

end Behavioral;
