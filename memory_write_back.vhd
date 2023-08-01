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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_write_back is
    Port ( clk, res, jmp, mem_we: in STD_LOGIC;
           mem_opcode : in STD_LOGIC_VECTOR(2 downto 0);
           op_class : in STD_LOGIC_VECTOR (4 downto 0);
           npc_in : in STD_LOGIC_VECTOR (11 downto 0);
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
            addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
        );
    END COMPONENT;
    signal mem_out, mem_out_extended : std_logic_vector(31 downto 0);
    signal mem_wea : std_logic_vector(3 downto 0);
begin
    memory : data_memory
    PORT MAP (
        clka => clk,
        wea => mem_wea,
        addra => alu_resoult(10 downto 0),
        dina => rs2_value,
        douta => mem_out
    );
    
    mem_wea_combinational : process( op_class, mem_opcode, mem_we )
    begin
        mem_wea <= "0000";      
        if mem_we = '1' then
            if op_class = "01000" then  --STORE
                case (mem_opcode) is
                    when "010" => --SW
                        mem_wea <= "1111";
                    when "001" => --SH (16 bits)
                        mem_wea <= "0011";
                    when "000" => --SB (8 bits)
                        mem_wea <= "0001";
                    when others =>
                        mem_wea <= "0000";
                end case;
            end if ;
        end if ;
    end process ; -- mem_wea_combinatory

    sign_extension : process( mem_out, mem_opcode, op_class)
    begin
        mem_out_extended <= mem_out;
        if op_class = "00100" then   --LOAD
            case( mem_opcode ) is
                when "001" =>   --LH
                    mem_out_extended(31 downto 16) <= (others => mem_out(15));
                    mem_out_extended(15 downto 0)  <= mem_out(15 downto 0);
                when "101" =>   --LHU
                    mem_out_extended(31 downto 16) <= (others => '0');
                    mem_out_extended(15 downto 0)  <= mem_out(15 downto 0);
                when "000" =>   --LB
                    mem_out_extended(31 downto 8) <= (others => mem_out(7));
                    mem_out_extended(7 downto 0)  <= mem_out(7 downto 0);
                when "100" =>   --LBU
                    mem_out_extended(31 downto 8) <= (others => '0');
                    mem_out_extended(7 downto 0)  <= mem_out(7 downto 0);
                when others =>
                    mem_out_extended <= mem_out;
            end case ;
        end if ;
        
    end process ; -- sign_extension
    
    register_process : process( clk, res )
    begin
        if res = '0' then
            pc_out <= (others => '0');
            rd_value <= (others => '0');
            rd_addr_out <= (others => '0');
        elsif rising_edge(clk) then
            --Rd_addr
            rd_addr_out <= rd_addr_in;

            --pc_out
            pc_out <= npc_in;
            if jmp = '1' and (op_class = "00010" or op_class = "00001") then
                pc_out <= alu_resoult_reg(11 downto 0);
            end if ;

            --rd_value
            if op_class = "10000" then          --ALU_OP
                rd_value <= alu_resoult_reg;
            elsif op_class = "00100" then       --LOAD
                rd_value <= mem_out_extended;
            elsif op_class = "00001" then       --JAL
                rd_value(11 downto 0 ) <= npc_in;
                rd_value(31 downto 12) <= (others => '0');
            end if ;
        end if ;
    end process ; -- register_process
    
end Behavioral;
