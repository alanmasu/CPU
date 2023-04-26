----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 17:19:54
-- Design Name: 
-- Module Name: execute - Behavioral
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

entity execute is
    Port ( clk, res: in STD_LOGIC;
           rs1_value : in STD_LOGIC_VECTOR (31 downto 0);
           rs2_value : in STD_LOGIC_VECTOR (31 downto 0);
           immediate : in STD_LOGIC_VECTOR (31 downto 0);
           npc_in : in UNSIGNED(31 downto 0);
           pc_in : in UNSIGNED(31 downto 0);
           rd_addr_in : in std_logic_vector(4 downto 0);
           a_pcn, b_immn : in STD_LOGIC;
           alu_opcode : in STD_LOGIC_VECTOR(3 downto 0);
           comparator_opcode, mem_opcode_in: in STD_LOGIC_VECTOR(2 downto 0);
           op_class_in : in STD_LOGIC_VECTOR(4 downto 0);
           resoult_reg, resoult: out STD_LOGIC_VECTOR (31 downto 0);
           npc_out : out UNSIGNED(31 downto 0);
           rd_addr_out : out std_logic_vector(4 downto 0);
           op_class_out : out STD_LOGIC_VECTOR(4 downto 0);
           mem_opcode_out : out std_logic_vector(2 downto 0);
           jmp : out std_logic
    );
end execute;

architecture Behavioral of execute is
    signal val1, val2, alu_resoult : std_logic_vector(31 downto 0);
    signal cond, jal: std_logic;
begin
    --ALU
    alu : entity work.alu
    port map(
        rs1 => val1,
        rs2 => val2, 
        alu_out => alu_resoult,
        opcode => alu_opcode
    );  
    --Comparator:
    cmp : entity work.comparator
    port map(
        rs1 => rs1_value,
        rs2 => rs2_value,
        opcode => comparator_opcode,
        cond => cond,
        jal => jal
    );
    
    registers : process (clk, res) begin
        if res = '0' then
            resoult_reg <= (others => '0');
            jmp <= '0';
            npc_out <= (others => '0');
            op_class_out <= (others => '0');
            rd_addr_out <= (others => '0');
            mem_opcode_out <= (others => '0');
        elsif rising_edge(clk) then
            resoult_reg <= alu_resoult;
            jmp <= cond;
            npc_out <= npc_in;
            op_class_out <= op_class_in;
            rd_addr_out <= rd_addr_in;
            mem_opcode_out <= mem_opcode_in;
        end if;
    end process;

    --Equation
    resoult <= alu_resoult;
    jal <= op_class_in(0);
    -- MUXs
    val1 <= std_logic_vector(pc_in) when a_pcn = '0' else 
            rs1_value;
    val2 <= immediate when b_immn = '0' else
            rs2_value;
end Behavioral;
