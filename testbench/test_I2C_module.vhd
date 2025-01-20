----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2023 09:20:51 AM
-- Design Name: 
-- Module Name: test_driver - Behavioral
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
use work.types_pkg.all;
use work.constant_package.all;
use work.i2c_utils_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_I2C_module is
--  Port ( );
end test_I2C_module;

architecture Behavioral of test_I2C_module is
    signal clk, res : STD_LOGIC;                            --clock and reset signals

    signal ena      : STD_LOGIC                     := '0';             --i2c enable signal
    signal wea      : STD_LOGIC_VECTOR(3 downto 0)  := (others => '0'); --i2c write enable signal
    signal addra    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); --i2c address signal
    signal dina     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); --i2c write data signal
    signal douta    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); --i2c read data signal

    -- Testing
    signal resoult      : STD_LOGIC := '0';
    signal validating   : STD_LOGIC := '0';
    signal test_n       : integer   := 0;

    signal i2c_finish         : STD_LOGIC := '0';
    signal i2c_address_tb     : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal i2c_data_tb        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal i2c_data_length_tb : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal i2c_rw_n_tb        : STD_LOGIC := '0';

    --Slave
    type i2c_slave_state_t is (idle, start, address, data, ack1, ack2, stop);
    signal i2c_slave_state : i2c_slave_state_t := idle;

    --- Nomi gerarchici se Vivado torna collaborativo
    signal i2c_regFile : I2C_regFile_t;
    -- signal i2c_addr    : STD_LOGIC_VECTOR(6 DOWNTO 0);      --i2c address signal
    -- signal i2c_start   : STD_LOGIC;                         --i2c enable signal
    -- signal i2c_rw_n    : STD_LOGIC;                         --i2c read/write command signal
    -- signal i2c_data_wr : STD_LOGIC_VECTOR(31 downto 0);     --i2c write data
    -- signal i2c_data_rd : STD_LOGIC_VECTOR(31 downto 0);     --i2c read data
    -- signal i2c_data_length      : STD_LOGIC_VECTOR(2 downto 0);  --i2c data length signal
    -- signal i2c_data_length_out  : STD_LOGIC_VECTOR(2 downto 0);  --i2c data length out signal
    -- signal i2c_busy    : STD_LOGIC;                         --i2c busy signal
    -- signal i2c_error   : STD_LOGIC;                         --i2c Error signal


    signal i2c_sda    : STD_LOGIC := 'H';                 --i2c sda and scl signal
    signal i2c_scl    : STD_LOGIC := 'H';                 --i2c sda and scl signal
begin
    dut : entity work.I2C_module
    port map(
        clk => clk, 
        res => res, 
        ena => ena,
        wea => wea,
        addra => addra,
        dina => dina,
        douta => douta,
        scl => i2c_scl,
        sda => i2c_sda
    );

    clk_gen : process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process ; -- clk_gen

    res_gen : process begin
        res <= '0';
        wait for 9 ns;
        res <= '1';
        wait;
    end process ; -- res_gen

    --Pull up i2c signals
    i2c_sda <= 'H';
    i2c_scl <= 'H';


    -- Nomi gerarchici
    i2c_regFile <= <<signal dut.regFile : I2C_regFile_t>>;

    test_pro : process begin
        wait until res = '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        
        -- Test 1
        test_n <= 1;
        ena   <= '1';           -- Enable I2C
        wea   <= "0001";        -- Write only first byte
        
        addra <= x"00000004";   -- Writing to I2C_REG_ADDRESS
        dina  <= x"0F000056";   -- Writing 0x56 as Address

        wait until rising_edge(clk);
        wait for 1 ns;
        ena  <= '0';           -- Disable I2C
        wea <= "0000";         -- Read only first byte
        validating <= '1';
        if i2c_regFile(I2C_REG_ADDRESS) = x"00000056" then
            resoult <= '1';
            report "Test #" & integer'image(test_n) & ": OK";
        else
            resoult <= '0';
            report "Test #" & integer'image(test_n) & ": FAILED -> i2c_regFile(I2C_REG_ADDRESS) was " & integer'image(stdv2int(i2c_regFile(I2C_REG_ADDRESS)));
        end if;
        wait for 1 ns;
        validating <= '0';

        -- Test 2
        test_n <= 2;
        addra <= x"0000000C";   -- Writing to I2C_REG_WDATA
        dina  <= x"0F0000AA";
        ena   <= '1';           -- Enable I2C
        wea   <= "0001";        -- Write only first byte
        wait until rising_edge(clk);
        wait for 1 ns;
        ena  <= '0';           -- Disable I2C
        wea <= "0000";         -- Read only first byte
        validating <= '1';
        if i2c_regFile(I2C_REG_WDATA) = x"000000AA" then
            resoult <= '1';
            report "Test #" & integer'image(test_n) & ": OK";
        else
            resoult <= '0';
            report "Test #" & integer'image(test_n) & ": FAILED -> i2c_regFile(I2C_REG_WDATA) was " & integer'image(stdv2int(i2c_regFile(I2C_REG_WDATA)));
        end if;
        wait for 1 ns;
        validating <= '0';

        -- Test 3
        test_n <= 3;
        ena <= '1';           -- Enable I2C
        wea <= "0001";        -- Write only first byte
        addra <= x"0000_0010";
        dina  <= x"0F00_0001";
        wait until rising_edge(clk);
        wait for 1 ns;
        ena  <= '0';           -- Disable I2C
        wea <= "0000";         -- Read only first byte
        validating <= '1';
        if i2c_regFile(I2C_REG_LEN) = x"0000_0001" then
            resoult <= '1';
            report "Test #" & integer'image(test_n) & ": OK";
        else
            resoult <= '0';
            report "Test #" & integer'image(test_n) & ": FAILED -> i2c_regFile(I2C_REG_LEN) was " & integer'image(stdv2int(i2c_regFile(I2C_REG_LEN)));
        end if;
        wait for 1 ns;
        validating <= '0';

        -- Test 4
        test_n <= 4;
        ena <= '1';           -- Enable I2C
        wea <= "0001";        -- Write only first byte
        addra <= x"00000000";
        dina  <= x"0F000000";
        dina(I2C_CREG_RW_N_BIT)  <= '0'; -- Set RW_N bit
        dina(I2C_CREG_START_BIT) <= '1'; -- Set START bit
        wait until rising_edge(clk);
        wait for 1 ns;
        ena <= '0';           -- Disable I2C
        wea <= "0000";        -- Read only first byte

       
        wait until i2c_regFile(I2C_REG_CONTROL)(I2C_CREG_BUSY_BIT) = '1';
        wait until i2c_regFile(I2C_REG_CONTROL)(I2C_CREG_BUSY_BIT) = '0';
        validating <= '1';
        if i2c_data_tb = x"000000aa" then
            resoult <= '1';
            report "Test #" & integer'image(test_n) & ": OK";
        else
            resoult <= '0';
            report "Test #" & integer'image(test_n) & ": FAILED -> i2c_data_tb was " & integer'image(stdv2int(i2c_data_tb));
        end if; 
        wait for 1 ns;
        validating <= '0';

        -- wait;
        assert false report "End of test" severity failure;
    end process ; -- test_pro

    i2c_slave_pro : process( i2c_scl, i2c_sda, res ) is
        variable i2c_data_count : integer := 0;
        variable i2c_next_state : i2c_slave_state_t := idle;
        variable temp_address : std_logic_vector(6 downto 0) := (others => '0');
    begin
        if res = '0' then
            i2c_slave_state <= idle;
            i2c_data_count := 0;
        elsif falling_edge(i2c_sda) and i2c_slave_state = idle then
            i2c_slave_state <= start;
        elsif falling_edge(i2c_scl) and i2c_slave_state = start then
            i2c_slave_state <= address;
        elsif rising_edge(i2c_scl) then
            if i2c_slave_state = address then
                i2c_data_count := i2c_data_count + 1;
                if(i2c_data_count = 8) then
                    i2c_rw_n_tb <= to_X01(i2c_sda);
                    i2c_slave_state <= ack1;
                    i2c_next_state := data;
                    i2c_data_count := 0;
                else 
                    i2c_address_tb <= (i2c_address_tb sll 1);
                    i2c_address_tb(0) <= to_X01(i2c_sda);
                end if;
            elsif i2c_slave_state = data then
                if i2c_rw_n_tb = '0' then               -- Incoming WRITE
                    i2c_data_tb <= (i2c_data_tb sll 1);
                    i2c_data_tb(0) <= to_X01(i2c_sda);
                elsif i2c_rw_n_tb = '1' then            -- Incoming READ
                    i2c_sda <= i2c_data_tb(31);
                    i2c_data_tb <= i2c_data_tb sll 1;
                end if;
                i2c_data_count := i2c_data_count + 1;
                if(i2c_data_count = 8) then
                    i2c_slave_state <= ack1;
                    i2c_next_state := stop;
                end if;
            end if;
        elsif i2c_slave_state = ack1 and falling_edge(i2c_scl) then
            i2c_sda <= '0';
            i2c_slave_state <= ack2;
        elsif i2c_slave_state = ack2 and falling_edge(i2c_scl) then
            i2c_sda <= 'H';
            i2c_slave_state <= i2c_next_state;
        elsif i2c_slave_state = stop and to_X01(i2c_scl) = '1' and rising_edge(i2c_sda) then
            i2c_slave_state <= idle;
        end if;
            
        
    end process ; -- i2c_slave_pro

end Behavioral;
