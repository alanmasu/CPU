library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package types_pkg is
    -- Register File Memory type
    type ram_array is array (30 downto 0) of std_logic_vector (31 downto 0);
    
    -- CPU State type
    type state_type is (idle, fetch, decode, execute, memory_writeback);

    -- Control Register type
    type control_reg_t is array (0 to 31) of std_logic_vector(31 downto 0);

    -- Peripheral Data type
    type peripheral_data_t is record
        AXI_data : std_logic_vector(31 downto 0);
        GPIO_data : std_logic_vector(31 downto 0);
        I2C_data : std_logic_vector(31 downto 0);
        BTPU_data : std_logic_vector(31 downto 0);
    end record peripheral_data_t;
    type en_bus_t is record
        en_mem : std_logic;
        en_AXI : std_logic;
        en_GPIO : std_logic;
        en_I2C : std_logic;
        en_BTPU_CREG : std_logic;
        en_BTPU_W_MEM : std_logic;
        en_BTPU_IO0_MEM : std_logic;
        en_BTPU_IO1_MEM : std_logic;
    end record en_bus_t;
    
    -- I2C Register File type
    type I2C_regFile_t is array(0 to 31) of std_logic_vector(31 downto 0);


    ------------ BTPU --------------
    -- BTPU Register File type
    type BTPU_regFile_t is array(0 to 31) of std_logic_vector(31 downto 0);
    -- BTPU State type
    type BTPU_state_t is (IDLE, FETCHING, EXECUTE, COUNTING, WRITE_BACK, CLEAR_ACC);
    -- BTPU Arrays
    type acc_t_dbg is array (0 to 256 - 1) of std_logic_vector(32 - 1 downto 0);
    
    
end package ;
