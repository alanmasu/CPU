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
end package ;
