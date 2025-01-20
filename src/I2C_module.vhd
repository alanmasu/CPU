----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19/01/2025 10:08:50 PM
-- Design Name: 
-- Module Name: I2C_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library work;
use work.i2c_utils_pkg.all;
use work.types_pkg.all;
use work.constant_package.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity I2C_module is
    generic (
        FREQUENCY : integer := 400;
        CLOCK_FREQUENCY : integer := 100000
    );
    Port ( 
        clk     : in STD_LOGIC;
        res     : in STD_LOGIC;
        scl     : inout STD_LOGIC;
        sda     : inout STD_LOGIC;
        ena     : in STD_LOGIC;
        wea     : in STD_LOGIC_VECTOR(3 downto 0);
        addra   : in STD_LOGIC_VECTOR(31 downto 0);
        dina    : in STD_LOGIC_VECTOR(31 downto 0);
        douta   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end I2C_module;

architecture Behavioral of I2C_module is
    signal regFile : I2C_regFile_t := (others => (others => '0'));
    signal driver_in    : std_logic_vector(31 downto 0);
    signal addr_in      : std_logic_vector(6 downto 0);
    signal driver_out   : std_logic_vector(31 downto 0);
    signal data_len     : std_logic_vector(2 downto 0);
    signal data_len_out : std_logic_vector(2 downto 0);

    signal start, rw_n, busy, err: std_logic := '0';
begin
    driver : entity work.I2C_driver
    generic map(
        FREQ_KHZ => FREQUENCY,
        S_FREQ_KHZ => CLOCK_FREQUENCY
    )
    Port map(
        clk => clk,
        res => res,
        addr_in => addr_in,
        rw_n => rw_n,
        d_in => driver_in,
        data_length => data_len,
        d_out => driver_out,
        data_length_out => data_len_out,
        en => start,
        busy => busy,
        error => err,
        sda => sda,
        scl => scl
    );

    regFile_proc : process(clk, res)
        variable regAddress : integer;
    begin
        if res = '0' then
            regFile <= (others => (others => '0'));
            douta <= (others => '0');
        elsif rising_edge(clk) then
            regAddress := to_integer(unsigned(addra(5 downto 2)));
            if(ena = '1') then
                if(wea(0) = '1') then
                    regFile(regAddress)(7 downto 0) <= dina(7 downto 0);
                end if;
                if(wea(1) = '1') then
                    regFile(regAddress)(15 downto 8) <= dina(15 downto 8);
                end if;
                if(wea(2) = '1') then
                    regFile(regAddress)(23 downto 16) <= dina(23 downto 16);
                end if;
                if(wea(3) = '1') then
                    regFile(regAddress)(31 downto 24) <= dina(31 downto 24);
                end if;
                douta <= regFile(regAddress);
            end if;
            regFile(I2C_REG_RDATA) <= driver_out;

            regFile(I2C_REG_LEN_O)(31 downto 3) <= (others => '0');
            regFile(I2C_REG_LEN_O)(2 downto 0)  <= data_len_out;
            regFile(I2C_REG_CONTROL)(I2C_CREG_BUSY_BIT)  <= busy;
            regFile(I2C_REG_CONTROL)(I2C_CREG_ERROR_BIT) <= err;
        end if;
    end process;   
            
    
    start <= regFile(I2C_REG_CONTROL)(I2C_CREG_START_BIT);
    rw_n  <= regFile(I2C_REG_CONTROL)(I2C_CREG_RW_N_BIT);
    addr_in <= regFile(I2C_REG_ADDRESS)(6 downto 0);
    driver_in <= regFile(I2C_REG_WDATA);
    data_len <= regFile(I2C_REG_LEN)(2 downto 0);
    
end Behavioral;