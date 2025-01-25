
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity slave_interface is
    Port ( 
        i2c_scl : inout STD_LOGIC;
        i2c_sda : inout STD_LOGIC;
        res : in STD_LOGIC;
        i2c_address_tb : buffer STD_LOGIC_VECTOR(31 downto 0);
        i2c_rw_n_tb : buffer STD_LOGIC;
        i2c_data_tb : buffer STD_LOGIC_VECTOR(31 downto 0);
        i2c_data_to_send : buffer STD_LOGIC_VECTOR(31 downto 0)
    );
end slave_interface;


architecture Behavioral of slave_interface is
    type i2c_slave_state_t is (idle, start, address, data, ack1, ack2, stop);
    signal i2c_slave_state : i2c_slave_state_t := idle;
    signal byte_count : integer := 0; --unsigned(31 downto 0);
    signal shamt : integer := 0;
begin

    shamt <= 32 - (byte_count * 8);
    
    i2c_slave_pro : process( i2c_scl, i2c_sda, res ) is
        variable i2c_data_count : integer := 0;
        variable i2c_next_state : i2c_slave_state_t := idle;
        variable temp_address : std_logic_vector(6 downto 0) := (others => '0');
        variable temp_data : std_logic := '0';
        variable data_to_send : std_logic_vector(31 downto 0) := (others => '0');
    begin
        if res = '0' then
            i2c_slave_state <= idle;
            i2c_data_count := 0;
            i2c_data_to_send <= (others => '0');
            byte_count <= 0;
            i2c_sda <= 'Z';
            i2c_scl <= 'Z';
            i2c_address_tb <= (others => '0');
            i2c_data_tb <= (others => '0');
            i2c_rw_n_tb <= '0';
            i2c_data_to_send <= (others => '0');
        elsif falling_edge(i2c_sda) and i2c_slave_state = idle then
            i2c_slave_state <= start;
            byte_count <= 0;
        elsif falling_edge(i2c_scl) and i2c_slave_state = start then
            i2c_slave_state <= address;
            i2c_address_tb <= (others => '0');
            i2c_rw_n_tb <= '0';
        elsif rising_edge(i2c_scl) then
            if i2c_slave_state = address then
                i2c_data_count := i2c_data_count + 1;
                if(i2c_data_count = 8) then
                    i2c_data_tb <= (others => '0');
                    i2c_rw_n_tb <= to_X01(i2c_sda);
                    i2c_slave_state <= ack1;
                    i2c_next_state := data;
                    byte_count <= byte_count + 1;
                    i2c_data_count := 0;
                else 
                    i2c_address_tb <= (i2c_address_tb sll 1);
                    i2c_address_tb(0) <= to_X01(i2c_sda);
                end if;
            elsif i2c_slave_state = data then
                i2c_data_count := i2c_data_count + 1;
                if i2c_rw_n_tb = '0' then               -- Incoming WRITE
                    i2c_data_tb <= (i2c_data_tb sll 1);
                    i2c_data_tb(0) <= to_X01(i2c_sda);
                elsif i2c_rw_n_tb = '1' then            -- Incoming READ
                    i2c_sda <= data_to_send(32 - i2c_data_count -((byte_count-1) * 8));
                    -- i2c_data_tb <= i2c_data_tb sll 1;
                    -- data_to_send := data_to_send sll 1;
                end if;
                if(i2c_data_count = 8) then
                    i2c_slave_state <= ack1;
                    i2c_next_state := stop;
                end if;
            elsif i2c_slave_state = stop then
                temp_data := to_X01(i2c_sda);
            end if;
        elsif i2c_slave_state = ack1 and falling_edge(i2c_scl) then
            i2c_sda <= '0';
            i2c_slave_state <= ack2;
        elsif i2c_slave_state = ack2 and falling_edge(i2c_scl) then
            i2c_sda <= 'Z';
            i2c_slave_state <= i2c_next_state;
            -- Prepare for next byte if needed
--            if i2c_rw_n_tb = '1' then
--                i2c_sda <= 'Z' when data_to_send(31) = '1' else '0';
--                -- i2c_data_tb <= i2c_data_tb sll 1;
--            end if;
        elsif i2c_slave_state = stop and to_X01(i2c_scl) = '1' and rising_edge(i2c_sda) then
            if i2c_rw_n_tb = '0' then
                -- i2c_data_to_send <= i2c_data_tb sll shamt;                
                i2c_data_to_send <= i2c_data_tb sll 32 - (byte_count * 8);                
                data_to_send(31 downto 32-i2c_data_count) := i2c_data_tb(i2c_data_count-1 downto 0);
            end if;
            i2c_slave_state <= idle;
            i2c_sda <= 'Z';
            i2c_scl <= 'Z';
            i2c_data_count := 0;
            -- i2c_data_to_send <= data_to_send;
        elsif i2c_slave_state = stop and falling_edge(i2c_scl) then
            byte_count <= byte_count + 1;
            if i2c_rw_n_tb = '0' then -- Incoming WRITE
                i2c_data_tb <= (i2c_data_tb sll 1);
                i2c_data_tb(0) <= temp_data;
            else
                i2c_data_tb <= (i2c_data_tb sll 1);
            end if;
            i2c_data_count := 1;
            i2c_slave_state <= data;            
        end if;
    end process; -- i2c_slave_pro
end Behavioral ; -- Behavioral