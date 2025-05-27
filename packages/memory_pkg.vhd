library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.types_pkg.all;

package memory_pkg is
    --MEMORY model
    type memory_space_type_t is (ROM, CREG_FILE, RAM, IO, GPIO, I2C, AXI, BTPU_CREG_FILE, BTPU_W_MEM, BTPU_IO0_MEM, BTPU_IO1_MEM, RESERVED);
    type memory_addr_space_t is record
        lower_bound : unsigned(31 downto 0);
        upper_bound : unsigned(31 downto 0);
        space_type : memory_space_type_t;
    end record memory_addr_space_t;

    -- Memory map
    type memory_model is array (natural range <>) of memory_addr_space_t;
    constant memory_map : memory_model(0 to 25) := (
        (lower_bound => x"00000000", upper_bound => x"3FFFFFFF", space_type => AXI),        --OCM & DDR
        (lower_bound => x"40000000", upper_bound => x"40003FFF", space_type => ROM),        --AXI INSTRUCTION MEMORY
        (lower_bound => x"40004000", upper_bound => x"4000FFFF", space_type => CREG_FILE),  --AXI FSM Control Register
        (lower_bound => x"40010000", upper_bound => x"4001FFFF", space_type => RAM),        --AXI DATA MEMORY (Mem upper bount = 0x40011FFF)
        (lower_bound => x"40020000", upper_bound => x"4002000F", space_type => GPIO),       --RISC-V GPIO
        (lower_bound => x"40020010", upper_bound => x"4002002F", space_type => I2C),        --RISC-V I2C
        (lower_bound => x"40030000", upper_bound => x"4003FFFF", space_type => AXI),        --CDMA
        (lower_bound => x"40020030", upper_bound => x"40020050", space_type => BTPU_CREG_FILE), --BTPU Register File
        (lower_bound => x"40080000", upper_bound => x"4009FFFF", space_type => BTPU_W_MEM),     --BTPU Weights Memory
        (lower_bound => x"400A0000", upper_bound => x"400BFFFF", space_type => BTPU_IO0_MEM),   --BTPU I/O Memory 0
        (lower_bound => x"400C0000", upper_bound => x"400DFFFF", space_type => BTPU_IO1_MEM),   --BTPU I/O Memory 1
        (lower_bound => x"400E0000", upper_bound => x"7FFFFFFF", space_type => IO),         --RISC-V IO
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
    -- Offset for peripherals
    constant GPIO_OFFSET    : unsigned(31 downto 0) := x"0000_0000";
    constant I2C_OFFSET     : unsigned(31 downto 0) := x"0000_0010";
    constant BTPU_CREG_OFFSET : unsigned(31 downto 0) := x"0000_0030";

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
        variable result : std_logic_vector(7 downto 0);
    begin
        result(0) := en_bus.en_mem;
        result(1) := en_bus.en_AXI;
        result(2) := en_bus.en_GPIO;
        result(3) := en_bus.en_I2C;
        result(4) := en_bus.en_BTPU_CREG;
        result(5) := en_bus.en_BTPU_W_MEM;
        result(6) := en_bus.en_BTPU_IO0_MEM;
        result(7) := en_bus.en_BTPU_IO1_MEM;
        return result;
    end function;

end package body;
