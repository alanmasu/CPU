----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alan Masutti
-- 
-- Create Date: 06/04/2025 05:59:55 PM
-- Design Name: 
-- Module Name: timer - Behavioral
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
use work.types_pkg.all;
use work.constant_package.all;
use work.memory_pkg.all;

entity timer is
    generic(
        TIMER_SIZE : integer := 40
    );
    port ( 
        clk : in STD_LOGIC;
        res : in STD_LOGIC;
        en : in STD_LOGIC;
        wea : in STD_LOGIC_VECTOR (3 downto 0);
        addr : in STD_LOGIC_VECTOR (31 downto 0);
        din : in STD_LOGIC_VECTOR (31 downto 0);
        dout : out STD_LOGIC_VECTOR (31 downto 0);

        cc  : in STD_LOGIC_VECTOR (31 downto 0); -- Capture/Control
        pwm : out STD_LOGIC
    );
end timer;

architecture Behavioral of timer is
    constant COUNTER_MSB_BIT_POS : integer := TIMER_SIZE - 32;
    signal regFile : timer_regFile_t := (others => (others => '0')); -- Registro di stato del timer
    signal timer_state : timer_state_t := timer_idle;

    signal counter          : unsigned(TIMER_SIZE - 1 downto 0) := (others => '0'); -- Usato come contatore vero
    signal compare          : unsigned(TIMER_SIZE - 1 downto 0) := (others => '0'); -- Usato come valore di confronto per il contatore
    signal timer_mode       : std_logic_vector(1 downto 0) := (others => '0');
    signal capture_mode     : std_logic := '0';

    signal timer_mode_reg   : std_logic_vector(1 downto 0) := (others => '0'); -- Registro di stato del timer
    signal compare_reg      : unsigned(TIMER_SIZE - 1 downto 0) := (others => '0'); -- Registro di confronto
    signal capture_mode_reg : std_logic;
    signal capture_reg      : std_logic;

    signal cc_sel : integer := 0;
    signal start : std_logic := '0';
    signal stop : std_logic := '0';
    signal busy : std_logic := '0';
    signal capture : std_logic := '0'; 
    signal pwm_int : std_logic := '0';

    -- DEBUG
    signal regAddr_s : integer := 0; -- Registro di stato per debug

begin
    assert TIMER_SIZE > 32 and TIMER_SIZE <= 64 
        report "TIMER_SIZE must be greater than 32 and less than or equal to 64" 
        severity failure;

    cc_sel <= to_integer(unsigned(regFile(TIMER_REG_CONTROL)(TIMER_CAPTURE_SEL_MSB_BIT downto TIMER_CAPTURE_SEL_LSB_BIT)));
    capture <= cc(cc_sel);
    compare(31 downto 0) <= unsigned(regFile(TIMER_REG_COMPARE_LSB));
    compare(COUNTER_MSB_BIT_POS + 31 downto 32) <= unsigned(regFile(TIMER_REG_COMPARE_MSB)(COUNTER_MSB_BIT_POS - 1 downto 0));
    timer_mode <= regFile(TIMER_REG_CONTROL)(TIMER_MODE_MSB_BIT downto TIMER_MODE_LSB_BIT);
    capture_mode <= regFile(TIMER_REG_CONTROL)(TIMER_CAPTURE_MODE_BIT);
    start <= regFile(TIMER_REG_CONTROL)(TIMER_CREG_RUN_BIT);
    stop <= regFile(TIMER_REG_CONTROL)(TIMER_CREG_STOP_BIT);

    process(clk, res) is 
        variable regAddr_u : unsigned(31 downto 0);
        variable regAddr : integer;
        variable dataToWrite : std_logic_vector(31 downto 0);
    begin
        if res = '0' then
            counter <= (others => '0');
            timer_state <= timer_idle;
            regFile <= (others => (others => '0'));
            dataToWrite := (others => '0');
            dout <= (others => '0');
            timer_mode_reg <= (others => '0');
            compare_reg <= (others => '0');
            capture_mode_reg <= '0';
            capture_reg <= '0';
            pwm_int <= '0';
        elsif rising_edge(clk) then

            regAddr_u := unsigned(addr) - TIMER_OFFSET;
            regAddr := to_integer(regAddr_u(6 downto 2));
            regAddr_s <= regAddr; -- Registro di stato per debug
            if en = '1' then
                dataToWrite := regFile(regAddr);
                if wea(0) = '1' then
                    dataToWrite(7 downto 0) := din(7 downto 0);
                end if;
                if(wea(1) = '1') then
                    dataToWrite(15 downto 8) := din(15 downto 8);
                end if;
                if(wea(2) = '1') then
                    dataToWrite(23 downto 16) := din(23 downto 16);
                end if;
                if(wea(3) = '1') then
                    dataToWrite(31 downto 24) := din(31 downto 24);
                end if;
                if regAddr = TIMER_REG_CONTROL then
                    regFile(regAddr) <= dataToWrite;
                    regFile(TIMER_REG_CONTROL)(TIMER_CREG_BUSY_BIT) <= busy; -- Aggiorna il bit busy nel registro di controllo
                    dout <= regFile(regAddr);
                    dout(TIMER_CREG_BUSY_BIT) <= busy; -- Aggiorna il bit busy nell'output
                elsif(regAddr = TIMER_REG_COUNTER_LSB) then
                    counter(31 downto 0) <= unsigned(dataToWrite);
                    dout <= std_logic_vector(counter(31 downto 0));
                elsif(regAddr = TIMER_REG_COUNTER_MSB) then
                    counter(COUNTER_MSB_BIT_POS + 31 downto 32) <= unsigned(dataToWrite(COUNTER_MSB_BIT_POS - 1 downto 0));
                    dout(COUNTER_MSB_BIT_POS - 1 downto 0) <= std_logic_vector(counter(COUNTER_MSB_BIT_POS + 31 downto 32));
                    dout(31 downto COUNTER_MSB_BIT_POS) <= (others => '0');
                else
                    regFile(regAddr) <= dataToWrite;
                    dout <= regFile(regAddr);
                end if;
            end if;
            if regFile(TIMER_REG_CONTROL)(TIMER_CREG_RUN_BIT) = '1' then
                regFile(TIMER_REG_CONTROL)(TIMER_CREG_RUN_BIT) <= '0';
            end if;
            if regFile(TIMER_REG_CONTROL)(TIMER_CREG_STOP_BIT) = '1' then
                regFile(TIMER_REG_CONTROL)(TIMER_CREG_STOP_BIT) <= '0';
            end if;
            regFile(TIMER_REG_CONTROL)(TIMER_CREG_BUSY_BIT) <= busy; -- Aggiorna il bit busy nel registro di controllo

            ------------------ MACCHINA A STATI ------------------
            case timer_state is
                when timer_idle =>
                    -- counter <= counter;
                    busy <= '0';
                    pwm_int <= '0';
                    if start = '1' then
                        busy <= '1';
                        timer_mode_reg <= timer_mode;
                        case( timer_mode ) is
                            when "00" => -- COUNTING
                                timer_state <= timer_counting;
                            when "01" => -- CAPTURE                 
                                capture_mode_reg <= capture_mode; 
                                compare_reg <= compare;
                                timer_state <= timer_capture;
                                counter <= (others => '0'); -- Reset the counter when entering capture mode
                            when "10" => -- PWM
                                compare_reg <= compare;
                                timer_state <= timer_pwm;
                                counter <= (others => '0'); -- Reset the counter when entering PWM mode
                            when others =>
                                timer_state <= timer_idle; -- Default case                        
                        end case ;
                    end if;
                when timer_counting =>
                    counter <= counter + 1;
                    if stop = '1' then
                        timer_state <= timer_idle;
                        busy <= '0';
                    end if;
                when timer_capture => 
                    counter <= counter + 1;
                    capture_reg <= capture;
                    if stop = '1' then
                        timer_state <= timer_idle;
                    else
                        if capture /= capture_reg then
                            if capture_mode_reg = '0' then -- RISING EDGE
                                if capture = '1' then
                                    regFile(TIMER_REG_CAPTURE_LSB) <= std_logic_vector(counter(31 downto 0));
                                    regFile(TIMER_REG_CAPTURE_MSB)(COUNTER_MSB_BIT_POS - 1 downto 0) <= std_logic_vector(counter(COUNTER_MSB_BIT_POS + 31 downto 32));
                                    regFile(TIMER_REG_CAPTURE_MSB)(31 downto COUNTER_MSB_BIT_POS) <= (others => '0');
                                    timer_state <= timer_idle; -- Torna allo stato idle dopo la cattura
                                    busy <= '0';
                                end if;
                            else -- FALLING EDGE
                                if capture = '0' then
                                    regFile(TIMER_REG_CAPTURE_LSB) <= std_logic_vector(counter(31 downto 0));
                                    regFile(TIMER_REG_CAPTURE_MSB)(COUNTER_MSB_BIT_POS - 1 downto 0) <= std_logic_vector(counter(COUNTER_MSB_BIT_POS + 31 downto 32));
                                    regFile(TIMER_REG_CAPTURE_MSB)(31 downto COUNTER_MSB_BIT_POS) <= (others => '0');
                                    timer_state <= timer_idle; -- Torna allo stato idle dopo la cattura
                                    busy <= '0';
                                end if;
                            end if;
                        end if;
                    end if;
                when timer_pwm =>
                    counter <= counter + 1;
                    if stop = '1' then
                        timer_state <= timer_idle;
                        busy <= '0';
                    elsif counter = compare_reg then
                        counter <= (others => '0'); -- Resetta il contatore quando raggiunge il valore di confronto
                        pwm_int <= not pwm_int; -- Inverte il segnale PWM quando il contatore supera il valore di confronto
                    end if;
                when others =>
                    timer_state <= timer_idle; -- Default case
            end case;
        end if;
    end process;
    
    pwm <= pwm_int; -- Assegna il segnale PWM all'output


end Behavioral;
