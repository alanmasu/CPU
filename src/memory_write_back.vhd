----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2023 09:57:02
-- Design Name: 
-- Module Name: memory_write_back - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library work;
use work.memory_pkg.all;
use work.types_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_write_back is
    Port ( 
        clk, res, jmp, we_in, en_in: in STD_LOGIC;
        is_axi_load : in STD_LOGIC;
        mem_opcode : in STD_LOGIC_VECTOR(2 downto 0);
        op_class : in STD_LOGIC_VECTOR (4 downto 0);
        npc_in : in UNSIGNED (31 downto 0);
        alu_resoult : in STD_LOGIC_VECTOR (31 downto 0);
        alu_resoult_reg : in STD_LOGIC_VECTOR (31 downto 0);
        rs2_value : in STD_LOGIC_VECTOR (31 downto 0);
        rd_addr_in : in STD_LOGIC_VECTOR (4 downto 0);
        rd_value : out STD_LOGIC_VECTOR (31 downto 0);
        rd_addr_out : out STD_LOGIC_VECTOR (4 downto 0);
        pc_out : out STD_LOGIC_VECTOR (31 downto 0);
        --Estesioni per I/O [combinatori]
        en_out : out en_bus_t;
        we_out : out STD_LOGIC_VECTOR (3 downto 0);
        address_out : out STD_LOGIC_VECTOR (31 downto 0);
        d_out : out STD_LOGIC_VECTOR (31 downto 0);
        d_in : in peripheral_data_t;

        --BRAM interface
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end memory_write_back;

architecture Behavioral of memory_write_back is
    COMPONENT data_memory
        PORT (
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            ena : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            clkb : IN STD_LOGIC;
            enb : IN STD_LOGIC;
            web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    --Signals for memory sign extension
    signal mem_in, mem_out, mem_out_extended : std_logic_vector(31 downto 0) := (others => '0');
    --Signal for byte access
    signal byte_address : std_logic_vector(1 downto 0) := (others => '0');
    --Signal for enable devices: memory, axi or peripherals
    signal en_bus : en_bus_t := (
        en_mem => '0', 
        en_AXI => '0',
        en_GPIO => '0',
        en_I2C => '0',
        others => '0'
    );
    signal en_bus_reg : en_bus_t := (
        en_mem => '0', 
        en_AXI => '0',
        en_GPIO => '0',
        en_I2C => '0',
        others => '0'
    );
    signal we, mem_wea : std_logic_vector(3 downto 0) := (others => '0');
begin
    memory : data_memory
    PORT MAP (
        clka => clk,
        wea => mem_wea,
        ena => en_bus.en_mem,
        addra => alu_resoult(12 downto 2),
        dina => mem_in,
        douta => mem_out,
        clkb => clkb,
        enb => enb,
        web => web,
        addrb => addrb,
        dinb => dinb,
        doutb => doutb
    );
    
    address_decoder : entity work.address_manager
    port map (
        address => alu_resoult,
        en_in => en_in,
        en_out => en_bus
    );

    --Equation
    byte_address <= alu_resoult(1 downto 0);
    -- rd_addr_out <= rd_addr_out when op_class = "00100" else rd_addr_in;
    rd_addr_out <= rd_addr_in;
    address_out <= alu_resoult(31 downto 0);
    d_out <= mem_in;
    
    en_out <= en_bus;
    we_out <= we;
    mem_wea <= we_out ;--when en_bus(0) = '1' else "0000";

    data_in_comb : process( op_class,mem_opcode, rs2_value, byte_address ) is
        variable dato : std_logic_vector(95 downto 0) := (others => '0');
    begin
        dato := (others => '0');
        dato(63 downto 32) := rs2_value;
        if op_class = "01000" then  --STORE
            case( mem_opcode ) is
                when "010" =>   --SW
                    dato := dato sll (to_integer(unsigned(byte_address))) * 8;
                when "001" =>   --SH
                    dato := dato sll (to_integer(unsigned(byte_address))) * 8;
                when "000" =>   --SB
                    dato := dato sll (to_integer(unsigned(byte_address))) * 8;
                when others =>
                    dato := dato;
            end case ;
            mem_in <= dato(63 downto 32);
        end if ;
        
    end process ; -- data_in_combinatory


    we_combinational : process( op_class, mem_opcode, we_in, byte_address ) is 
        variable wea : std_logic_vector(3 downto 0) := "0000";
    begin
        we <= "0000";      
        if we_in = '1' then
            if op_class = "01000" then  --STORE
                case (mem_opcode) is
                    when "010" => --SW (32 bits) "1111"
                        wea := "1111" sll to_integer(unsigned(byte_address)); 
                    when "001" => --SH (16 bits) "0011"
                        wea := "0011" sll to_integer(unsigned(byte_address));
                    when "000" => --SB (8 bits)  "0001"
                        wea := "0001" sll to_integer(unsigned(byte_address));
                    when others => 
                        wea := "0000";
                end case;
                we <= wea;
            end if ;
        end if ;
    end process ; -- mem_wea_combinatory

    ena_reg_pro : process( clk, res ) begin
        if res = '0' then
            en_bus_reg <= (
                en_mem => '0',
                en_AXI => '0',
                en_GPIO => '0',
                en_I2C => '0',
                others => '0'
            );
        elsif rising_edge(clk) then
            en_bus_reg <= en_bus;
            if is_axi_load = '1' then
                en_bus_reg <= en_bus_reg;
            end if ;
        end if ;
        
    end process ; -- ena_reg_pro

    --Source selection and sign extension
    sign_extension : process( en_bus_reg, mem_out, mem_opcode, op_class, byte_address, d_in ) is
        variable dato : unsigned(31 downto 0);
        variable extensionBound : integer;
    begin
        extensionBound := 32 - to_integer(unsigned(byte_address)) * 8;
        --Source seletion
        -- case( en_bus ) is
        --     when "01" => --MEMORY 
        --         dato := unsigned(mem_out);
        --     when "10" => --AXI
        --         dato := unsigned(d_in.axi_data);
        --     when others =>
        --         dato := dato;
        -- end case ;
        dato := unsigned(mem_out);
        if en_bus_reg.en_AXI then
            dato := unsigned(d_in.axi_data);
        elsif en_bus_reg.en_GPIO then
            dato := unsigned(d_in.GPIO_data);
        elsif en_bus_reg.en_I2C then
            dato := unsigned(d_in.I2C_data);
        elsif en_bus_reg.en_BTPU_CREG or en_bus_reg.en_BTPU_W_MEM or en_bus_reg.en_BTPU_IO0_MEM or en_bus_reg.en_BTPU_IO1_MEM then
            dato := unsigned(d_in.BTPU_data);
        end if ;

        --Sign extension
        if op_class = "00100" then   --LOAD
            case( mem_opcode ) is
                when "010" =>   --LW
                    dato := dato srl to_integer(unsigned(byte_address)) * 8;
                    if(extensionBound /= 32) then
                        dato(31 downto extensionBound) := (others => dato(extensionBound - 1));
                    end if;
                when "001" =>   --LH
                    dato := dato srl (to_integer(unsigned(byte_address))) * 8;
                    if(extensionBound < 16) then
                        dato(15 downto extensionBound) := (others => dato(extensionBound - 1));
                    end if;
                    dato(31 downto 16) := (others => dato(15));
                when "101" =>   --LHU
                    dato := dato srl (to_integer(unsigned(byte_address))) * 8;
                    if(extensionBound < 16) then
                        dato(15 downto extensionBound) := (others => '0');
                    end if;
                    dato(31 downto 16) := (others => '0');
                when "000" =>   --LB
                    dato := dato srl (to_integer(unsigned(byte_address))) * 8;
                    dato(31 downto 8) := (others => dato(7));
                when "100" =>   --LBU
                    dato := dato srl (to_integer(unsigned(byte_address))) * 8;
                    dato(31 downto 8) := (others => '0');
                when others =>
                    dato := dato;
            end case ;
        end if ;
        mem_out_extended <= std_logic_vector(dato);
    end process ; -- sign_extension

    pc_out_comb : process( jmp, op_class, alu_resoult_reg, npc_in )
    begin
        pc_out <= std_logic_vector(npc_in);
        if jmp = '1' and (op_class = "00010" or op_class = "00001") then
            pc_out <= alu_resoult_reg;
        end if ;
    end process ; -- pc_out
    
    rd_value_comb: process(op_class, alu_resoult_reg, mem_out_extended, npc_in, res) 
    begin
        rd_value <= alu_resoult_reg;
        if op_class = "00100" then       --LOAD
            rd_value <= mem_out_extended;
        elsif op_class = "00001" then       --JAL
            -- rd_value(11 downto 0 ) <= std_logic_vector(npc_in(11 downto 0));
            -- rd_value(31 downto 12) <= (others => '0'); 
            rd_value <= std_logic_vector(npc_in);               
        end if ;
    end process ; -- rd_value
    
end Behavioral;
