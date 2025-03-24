----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2023 10:27:58 AM
-- Design Name: 
-- Module Name: I2C_driver - Behavioral
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
-- [FULLY TESTED]

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library work;
use work.i2c_utils_pkg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2C_driver is
    generic(
        BYTE_BUFF_SIZE  : integer := 4;
        FREQ_KHZ        : integer := 400;
        S_FREQ_KHZ      : integer := 100000
    );
    Port ( clk : in STD_LOGIC;                                                          -- Clock
           res : in STD_LOGIC;                                                          -- Reset asincrono
           en : in STD_LOGIC;                                                           -- Enable: segnale start
           addr_in : in STD_LOGIC_VECTOR (6 downto 0);                                  -- Address: indirizzo I2C a 7 bit 
           rw_n : in STD_LOGIC;                                                         -- Read/Write
           d_in : in STD_LOGIC_VECTOR ((BYTE_BUFF_SIZE * 8) - 1 downto 0);              -- Data in 
           data_length : in STD_LOGIC_VECTOR (clog2(BYTE_BUFF_SIZE) downto 0);          -- Data in length: lunghezza dei dati da inviare
           d_out : out STD_LOGIC_VECTOR ((BYTE_BUFF_SIZE * 8) - 1 downto 0);            -- Data out: dato letto
           data_length_out : out STD_LOGIC_VECTOR (clog2(BYTE_BUFF_SIZE) downto 0);     -- Data length out: lunghezza dei dati letti oppure dei dati scritti prima di un NACK
           busy, error : out STD_LOGIC;                                                 -- Busy/Error
           sda : inout STD_LOGIC;                                                       -- SDA
           scl : inout STD_LOGIC
    );
end I2C_driver;

architecture Behavioral of I2C_driver is

    type stato_t is (idle, start, send_address, read_ack, readed_nack, writing, reading, write_ack, write_nack, stop, wait_slave);
    signal i2c_state, i2c_state_p : stato_t := idle;
    signal sda_int, scl_int : std_logic := '1';
    signal data_sel, addr : std_logic_vector(7 downto 0) := (others => '0');
    signal rw_n_int: std_logic := '0';
    signal ack, nack : std_logic;
    signal data : std_logic_vector((BYTE_BUFF_SIZE * 8) - 1 downto 0);                      -- Registro
    signal scl_count : unsigned (freq2dim(FREQ_KHZ, S_FREQ_KHZ) - 1  downto 0) := (others => '0');
    signal to_start, to_stop : std_logic := '0';
    signal data_count : unsigned (2 downto 0) := (others => '0');                           -- Contatore di bit
    signal byte_count : unsigned (clog2(BYTE_BUFF_SIZE) downto 0) := (others => '0');       -- Contatore di byte
    signal data_length_int : unsigned (clog2(BYTE_BUFF_SIZE) downto 0) := (others => '0');  -- Contatore di scritti in uscita
    constant total_cycle : unsigned (freq2dim(FREQ_KHZ, S_FREQ_KHZ) - 1 downto 0) := freq2count_u(FREQ_KHZ, S_FREQ_KHZ); --250 cicli * 10 ns - 1 ciclo * 10 ns
    constant half_cycle : unsigned (freq2dim(FREQ_KHZ, S_FREQ_KHZ) - 1  downto 0) := total_cycle/2;     --125 cicli * 10 ns - 1 ciclo * 10 ns
    constant quarter_cycle : unsigned (freq2dim(FREQ_KHZ, S_FREQ_KHZ) - 1  downto 0) := total_cycle/4;  --62  cicli * 10 ns - 1 ciclo * 10 ns
    
begin
    msf : process( clk, res) begin
        if res = '0' then
            i2c_state <= idle;
            sda_int <= '1';
            scl_int <= '1';
            d_out <= (others => '0');
            scl_count <= (others => '0');
            data_count <= (others => '0');
            data_length_out <= (others => '0');
            addr <= (others => '0');
            ack <= '0';
            nack <= '0';
            busy <= '0';
            error <= '0';
            to_start <= '0';
            to_stop  <= '0';
        elsif rising_edge(clk) then
            if i2c_state = wait_slave then
                if To_X01(scl) = '1' then
                    i2c_state <= i2c_state_p;
                end if ;
            elsif scl_int /= To_X01(scl) then
                i2c_state_p <= i2c_state;
                i2c_state <= wait_slave;
            else
                --Defaults
                busy <= '1';
                scl_count <= scl_count + 1;
                ack <= ack;
                nack <= nack;
                to_start <= to_start;
                to_stop  <= to_stop;

                --SCL gen
                if scl_count < half_cycle then
                    scl_int <= '0';
                elsif scl_count >= half_cycle and scl_count <= total_cycle then
                    scl_int <= '1';
                end if;
                if scl_count = total_cycle then
                    scl_count <= (others => '0');
                end if ;

                case( i2c_state ) is
                    when idle =>
                        scl_int <= '1';
                        sda_int <= '1';
                        busy <= '0';
                        nack <= '0';
                        ack <= '0';
                        scl_count <= scl_count;
                        if en = '1' and unsigned(data_length) > 0 then
                            error <= '0';
                            busy <= '1';
                            sda_int <= '0';
                            data <= d_in;
                            rw_n_int <= rw_n;
                            data_length_int <= unsigned(data_length);
                            addr(7 downto 1) <= addr_in;
                            addr(0) <= rw_n;
                            i2c_state <= start;
                            scl_count <= (others => '0');
                        end if;
                    when start =>
                        if scl_count < quarter_cycle then
                            sda_int <= '0';
                            scl_int <= '1';
                        elsif scl_count >= quarter_cycle and scl_count < half_cycle then
                            sda_int <= '0';
                            scl_int <= '0';
                        elsif scl_count >= half_cycle then
                            sda_int <= '0';
                            scl_int <= '0';
                            i2c_state <= send_address;
                            scl_count <= quarter_cycle + 1;
                            data_count <= (others => '1');
                            byte_count <= (others => '0');
                            data_length_out <= (others => '0');
                        end if ;
                    when send_address =>
                        --SDA gen
                        sda_int <= sda_int;
                        if scl_count < half_cycle then
                            if scl_count = quarter_cycle then
                                data_count <= data_count - 1;
                            elsif scl_count > quarter_cycle then
                                sda_int <= addr(to_integer(data_count));
                            end if ;
                        elsif scl_count >= half_cycle then
                            if scl_count = total_cycle and data_count = 0 then
                                sda_int <= '1';
                                i2c_state <= read_ack;
                            end if ;
                        end if ;
                    when read_ack => 
                        sda_int <= '1';
                        if scl_count = half_cycle + quarter_cycle then
                            if to_X01(sda) = '0' then
                                ack <= '1';
                            elsif to_X01(sda) = '1' then
                                nack <= '1';
                            end if ;
                        elsif scl_count = total_cycle then
                            --scl_count <= (others => '0');
                            if nack = '1' and byte_count = 0 then                       -- ERROR: address not found
                                error <= '1';
                                i2c_state <= stop;
                            elsif nack = '1' or byte_count = data_length_int then       -- END of Transmission
                                i2c_state <= stop;
                                data_length_out <= std_logic_vector(byte_count + 1);
                            elsif ack = '1' and byte_count /= data_length_int then      -- ACK
                                if rw_n_int = '1' then
                                    i2c_state <= reading;
                                elsif rw_n_int = '0' then
                                    i2c_state <= writing;
                                end if ;
                            end if ;
                        end if ;
                    -- when readed_nack => 
                    --     scl_int <= '1';
                    --     sda_int <= '1';
                    --     busy <= '0';
                    --     error <= '1';
                    --     scl_count <= scl_count;
                    --     nack <= '0';
                    --     ack <= '0';
                    --     if en = '1' then
                    --         data <= d_in;
                    --         addr(7 downto 1) <= addr_in;
                    --         addr(0) <= rw_n;
                    --         i2c_state <= start;
                    --         scl_count <= (others => '0');
                    --     end if;
                    when reading =>
                        ack <= '0';
                        nack <= '0';
                        if scl_count = quarter_cycle then
                            data_count <= data_count - 1;
                        elsif scl_count = half_cycle + quarter_cycle then
                            d_out(to_integer(data_count) + 8 * to_integer(byte_count)) <= to_X01(sda); --LITTLE ENDIAN
                        elsif scl_count = total_cycle and data_count = 0 then
                            if byte_count < data_length_int -1 then
                                i2c_state <= write_ack;
                                byte_count <= byte_count + 1;
                            else
                                i2c_state <= write_nack;
                            end if ;
                        end if ;
                    when write_ack => 
                        if scl_count > quarter_cycle and scl_count < total_cycle then
                            sda_int <= '0';
                        elsif scl_count = total_cycle then
                            sda_int <= '1';
                            i2c_state <= reading;
                        end if ;
                    when write_nack => 
                        if scl_count > half_cycle and scl_count < total_cycle then
                            sda_int <= '1';
                        elsif scl_count = total_cycle then
                            data_length_out <= std_logic_vector(byte_count + 1);
                            i2c_state <= stop;
                        end if ;
                    when writing =>
                        ack <= '0';
                        nack <= '0';
                        if scl_count = quarter_cycle then
                            data_count <= data_count - 1;
                        elsif scl_count > quarter_cycle and scl_count < half_cycle then
                            sda_int <= data_sel(to_integer(data_count));
                        elsif scl_count = total_cycle and data_count = 0 then
                            i2c_state <= read_ack;
                            byte_count <= byte_count + 1;
                        end if ;
                    when stop => 
                        if scl_count > quarter_cycle and scl_count < half_cycle + quarter_cycle then
                            sda_int <= '0';
                        elsif scl_count >= half_cycle + quarter_cycle and scl_count < total_cycle then
                            sda_int <= '1';
                        elsif scl_count = total_cycle then
                            i2c_state <= idle;
                        end if ;
                    when others => 
                        i2c_state <= idle;
                end case ;
            end if ;
        end if ;
    end process ; -- msf
    --Equazioni
    sda <= 'Z' when sda_int = '1' else '0';
    scl <= 'Z' when scl_int = '1' else '0';
    data_sel <= data(7 + to_integer(byte_count) * 8 downto to_integer(byte_count) * 8); --LITTLE ENDIAN
end Behavioral;
