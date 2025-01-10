library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package memory_pkg is
    --MEMORY model
    type memory_space_type_t is (ROM, CREG_FILE, RAM, IO, GPIO, AXI, RESERVED);
    type memory_addr_space_t is record
        lower_bound : unsigned(31 downto 0);
        upper_bound : unsigned(31 downto 0);
        space_type : memory_space_type_t;
    end record memory_addr_space_t;

    type memory_model is array (natural range <>) of memory_addr_space_t;

    constant memory_map : memory_model(0 to 19) := (
        (lower_bound => x"00000000", upper_bound => x"3FFFFFFF", space_type => AXI),        --OCM & DDR
        (lower_bound => x"40000000", upper_bound => x"40000FFF", space_type => ROM),        --AXI INSTRUCTION MEMORY
        (lower_bound => x"40001000", upper_bound => x"4000FFFF", space_type => CREG_FILE),  --AXI FSM Control Register
        (lower_bound => x"40010000", upper_bound => x"4001FFFF", space_type => RAM),        --AXI DATA MEMORY
        (lower_bound => x"40020000", upper_bound => x"4002000F", space_type => GPIO),       --RISC-V GPIO
        (lower_bound => x"40020010", upper_bound => x"7FFFFFFF", space_type => IO),         --RISC-V IO
        (lower_bound => x"80000000", upper_bound => x"DFFFFFFF", space_type => RESERVED),   
        (lower_bound => x"E0000000", upper_bound => x"E02FFFFF", space_type => AXI),        --PS IO
        (lower_bound => x"E0300000", upper_bound => x"E0FFFFFF", space_type => RESERVED),
        (lower_bound => x"E1000000", upper_bound => x"E5FFFFFF", space_type => AXI),        --PS SMC
        (lower_bound => x"E6000000", upper_bound => x"E7FFFFFF", space_type => RESERVED),
        (lower_bound => x"E8000000", upper_bound => x"F8000BFF", space_type => AXI),        --PS SLCR
        (lower_bound => x"F8000C00", upper_bound => x"F8000FFF", space_type => RESERVED),   
        (lower_bound => x"F8001000", upper_bound => x"F880FFFF", space_type => AXI),        --PS REGISTERS
        (lower_bound => x"F8810000", upper_bound => x"F8890FFF", space_type => RESERVED),
        (lower_bound => x"F8900000", upper_bound => x"F8F02FFF", space_type => RESERVED),   --CPU
        (lower_bound => x"F8F03000", upper_bound => x"FBFFFFFF", space_type => RESERVED),
        (lower_bound => x"FC000000", upper_bound => x"FDFFFFFF", space_type => AXI),        --PS QSPI
        (lower_bound => x"FE000000", upper_bound => x"FFFBFFFF", space_type => RESERVED),   
        (lower_bound => x"FFFC0000", upper_bound => x"FFFFFFFF", space_type => AXI)         --PS OCM
    );

    --PERIPHERALS 
    type peripheral_data_t is record
        AXI_data : std_logic_vector(31 downto 0);
        GPIO_data : std_logic_vector(31 downto 0);
    end record peripheral_data_t;
    type en_bus_t is record
        en_mem : std_logic;
        en_AXI : std_logic;
        en_GPIO : std_logic;
    end record en_bus_t;

    --FUNCTIONS
    function is_in_space(addr : std_logic_vector(31 downto 0); space_type: memory_space_type_t) return std_logic;
    function check_bram_address(address : std_logic_vector(19 downto 0); space_type : memory_space_type_t) return std_logic;
    function en_bus_t_to_slv(en_bus : en_bus_t) return std_logic_vector;
end package ;

package body memory_pkg is
    function is_in_space(addr : std_logic_vector(31 downto 0); space_type: memory_space_type_t) return std_logic is
        variable result : std_logic := '0';
        variable lower_bound : unsigned(31 downto 0);
        variable upper_bound : unsigned(31 downto 0);

    begin
        for i in memory_map'range loop
            if (memory_map(i).space_type = space_type) then
                lower_bound := memory_map(i).lower_bound;
                upper_bound := memory_map(i).upper_bound;
                if (unsigned (addr) >= lower_bound and unsigned(addr) <= upper_bound) then
                    result := '1';
                end if;
            end if;
        end loop;
        return result;
    end function;

    --Function to check if the address is in the memory space specific for the BRAM controller output address
    function check_bram_address(address : std_logic_vector(19 downto 0); space_type : memory_space_type_t) return std_logic is
        variable result : std_logic := '0';
        variable lower_bound : unsigned(19 downto 0);
        variable upper_bound : unsigned(19 downto 0);
    begin
        for i in memory_map'range loop
            if (memory_map(i).space_type = space_type) then
                lower_bound := memory_map(i).lower_bound(19 downto 0);
                upper_bound := memory_map(i).upper_bound(19 downto 0);
                if (unsigned (address) >= lower_bound and unsigned(address) <= upper_bound) then
                    result := '1';
                end if;
            end if;
        end loop;
        return result;
    end function;

    function en_bus_t_to_slv(en_bus : en_bus_t) return std_logic_vector is
        variable result : std_logic_vector(2 downto 0);
    begin
        result(0) := en_bus.en_mem;
        result(1) := en_bus.en_AXI;
        result(2) := en_bus.en_GPIO;
        return result;
    end function;

end package body;
