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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_write_back is
    Port ( clk, res, jmp, mem_we, mem_ena: in STD_LOGIC;
           mem_opcode : in STD_LOGIC_VECTOR(2 downto 0);
           op_class : in STD_LOGIC_VECTOR (4 downto 0);
           npc_in : in UNSIGNED (31 downto 0);
           alu_resoult : in STD_LOGIC_VECTOR (31 downto 0);
           alu_resoult_reg : in STD_LOGIC_VECTOR (31 downto 0);
           rs2_value : in STD_LOGIC_VECTOR (31 downto 0);
           rd_addr_in : in STD_LOGIC_VECTOR (4 downto 0);
           rd_value : out STD_LOGIC_VECTOR (31 downto 0);
           rd_addr_out : out STD_LOGIC_VECTOR (4 downto 0);
           pc_out : out STD_LOGIC_VECTOR (11 downto 0)
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
            douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
        );
    END COMPONENT;
    signal mem_in, mem_out, mem_out_extended : std_logic_vector(31 downto 0);
    signal mem_wea : std_logic_vector(3 downto 0);
    signal byte_address : std_logic_vector(1 downto 0);
begin
    memory : data_memory
    PORT MAP (
        clka => clk,
        wea => mem_wea,
        ena => mem_ena,
        addra => alu_resoult(12 downto 2),
        dina => mem_in,
        douta => mem_out
    );
    
    --Equation
    byte_address <= alu_resoult(1 downto 0);

    data_in_comb : process( op_class,mem_opcode, rs2_value) is
        variable dato : unsigned(31 downto 0);
    begin
        dato := unsigned(rs2_value);
        if mem_we = '1' then
            if op_class = "01000" then  --STORE
                case( mem_opcode ) is
                    when "001" =>   --LH
                        dato := dato sll to_integer((2 - unsigned(byte_address)) * 8);
                    when "101" =>   --LHU
                        dato := dato sll to_integer((2 - unsigned(byte_address)) * 8);
                    when "000" =>   --LB
                        dato := dato sll to_integer((3 - unsigned(byte_address)) * 8);
                    when "100" =>   --LBU
                        dato := dato sll to_integer((3 - unsigned(byte_address)) * 8);
                end case ;
                mem_in <= std_logic_vector(dato);
            end if ;
        end if ;
        
    end process ; -- data_in_combinatory


    mem_wea_combinational : process( op_class, mem_opcode, mem_we )
    begin
        mem_wea <= "0000";      
        if mem_we = '1' then
            if op_class = "01000" then  --STORE
                case (mem_opcode) is
                    when "010" => --SW (32 bits)
                        mem_wea <= unsigned("1111") sll to_integer(unsigned(byte_address)); 
                    when "001" => --SH (16 bits)
                        mem_wea <= unsigned("1100") sll to_integer(unsigned(byte_address));
                    when "000" => --SB (8 bits)
                        mem_wea <= unsigned("1000") sll to_integer(unsigned(byte_address));
                end case;
            end if ;
        end if ;
    end process ; -- mem_wea_combinatory

    sign_extension : process( mem_out, mem_opcode, op_class) is
        variable dato : unsigned(31 downto 0);
    begin
        dato := unsigned(mem_out);
        --mem_out_extended <= mem_out;
        if op_class = "00100" then   --LOAD
            case( mem_opcode ) is
                when "001" =>   --LH
                    dato := dato sra to_integer((2 - unsigned(byte_address)) * 8);
                when "101" =>   --LHU
                    dato := dato srl to_integer((2 - unsigned(byte_address)) * 8);
                when "000" =>   --LB
                    dato := dato sra to_integer((3 - unsigned(byte_address)) * 8);
                when "100" =>   --LBU
                    dato := dato srl to_integer((3 - unsigned(byte_address)) * 8);
            end case ;
            mem_out_extended <= std_logic_vector(dato);
        end if ;
        
    end process ; -- sign_extension
    
    -- register_process : process( clk, res )
    -- begin
    --     if res = '0' then
    --         --pc_out <= (others => '0');
    --         --rd_value <= (others => '0');
    --         --rd_addr_out <= (others => '0');
    --     elsif rising_edge(clk) then
    --         --Rd_addr
            

    --         --pc_out
    --         -- pc_out <= npc_in;
    --         -- if jmp = '1' and (op_class = "00010" or op_class = "00001") then
    --         --     pc_out <= alu_resoult_reg(11 downto 0);
    --         -- end if ;

    --         -- --rd_value
    --         -- if op_class = "10000" then          --ALU_OP
    --         --     rd_value <= alu_resoult_reg;
    --         -- elsif op_class = "00100" then       --LOAD
    --         --     rd_value <= mem_out_extended;
    --         -- elsif op_class = "00001" then       --JAL
    --         --     rd_value(11 downto 0 ) <= npc_in;
    --         --     rd_value(31 downto 12) <= (others => '0');
    --         -- end if ;
    --     end if ;
    -- end process ; -- register_process

    pc_out_comb : process( jmp, op_class, alu_resoult_reg, npc_in )
    begin
        pc_out <= std_logic_vector(npc_in(11 downto 0));
        if jmp = '1' and (op_class = "00010" or op_class = "00001") then
            pc_out <= alu_resoult_reg(11 downto 0);
        end if ;
    end process ; -- pc_out

    rd_value_comb: process(op_class, alu_resoult_reg, mem_out_extended, npc_in, res) 
    begin
        rd_value <= (others => '0');
        if res = '1' then                   
            if op_class = "10000" then          --ALU_OP
                rd_value <= alu_resoult_reg;
            elsif op_class = "00100" then       --LOAD
                rd_value <= mem_out_extended;
            elsif op_class = "00001" then       --JAL
                rd_value(11 downto 0 ) <= std_logic_vector(npc_in(11 downto 0));
                rd_value(31 downto 12) <= (others => '0');
            end if ;
        end if ;
    end process ; -- rd_value
    rd_addr_out <= rd_addr_in;
end Behavioral;
