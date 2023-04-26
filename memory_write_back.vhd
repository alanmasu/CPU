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
           alu_resoulr_reg : in STD_LOGIC_VECTOR (31 downto 0);
           rs2_value : in STD_LOGIC_VECTOR (31 downto 0);
           rd_addr_in : in STD_LOGIC_VECTOR (4 downto 0);
           rd_value : out STD_LOGIC_VECTOR (31 downto 0);
           rd_addr_out : out STD_LOGIC_VECTOR (4 downto 0);
           pc_out : out STD_LOGIC_VECTOR (11 downto 0));
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
    signal mem_out : std_logic_vector(31 downto 0);
    signal mem_wea : std_logic_vector(3 downto 0);
begin
    memory : data_memory
    PORT MAP (
        clka => clk,
        wea => mem_wea,
        addra => alu_resoult,
        dina => rs2_value,
        douta => mem_out
    );
    
    mem_wea_combinatory : process( op_class, mem_opcode, mem_we )
    begin
        mem_wea <= "0000";      
        if mem_we = '1' then
            if op_class = "01000" then  --STORE
                case (mem_opcode) is
                    when => "010"  --SW
                        mem_wea <= "1111";
                    when => "001"  --SH (16 bits)
                        mem_wea <= "0011";
                    when => "000"  --SB (8 bits)
                        mem_wea <= "0001";
                end case;
            end if ;
        end if ;
    end process ; -- mem_wea_combinatory

    
    
end Behavioral;
