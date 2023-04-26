----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 16:51:07
-- Design Name: 
-- Module Name: istruction_decode - Behavioral
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

entity istruction_decode is
    Port ( clk, res : in STD_LOGIC;
           we : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (31 downto 0);
           pc_in, npc_in : in UNSIGNED (11 downto 0);
           rd_value : in STD_LOGIC_VECTOR (31 downto 0);            --Reg Destination val
           rd_addr : in STD_LOGIC_VECTOR (4 downto 0);              --Reg Destination addr
           rs1_value, rs2_value: out STD_LOGIC_VECTOR (31 downto 0);
           immediate : out STD_LOGIC_VECTOR (31 downto 0);
           rd_addr_out: out std_logic_vector(4 downto 0);
           pc_out, npc_out : out UNSIGNED (11 downto 0);
           alu_opcode : out STD_LOGIC_VECTOR (3 downto 0);
           comparator_opcode : out STD_LOGIC_VECTOR(2 downto 0);
           op_class : out STD_LOGIC_VECTOR(4 downto 0)
     );
end istruction_decode;

architecture Behavioral of istruction_decode is
    signal rs1, rs2: std_logic_vector(31 downto 0);
    signal rs1_addr, rs2_addr, rd_addr: STD_LOGIC_VECTOR (4 downto 0);
    signal func3 : std_logic_vector(2 downto 0);
    signal opcode, func7 : std_logic_vector(6 downto 0);
    signal op, store, load, branch, jump : STD_LOGIC;
begin
    register_file: entity work.triple_port_ram
    port map(
        addr_in => rd_addr,
        d_in => rd_value,
        d_out1 => rs1_value,
        d_out2 => rs2_value,
        addr_out1 => rs1_addr,
        addr_out2 => rs2_addr, 
        clk => clk,
        res => res,
        we => we
    );
    

    register_process : process( clk, res )
    begin
        if res = '0' then
            npc_out <= (others => '0');
            pc_out <= (others => '0');
            op_class <= (others => '0');
        elsif rising_edge(clk) then
            npc_out <= resize(npc_in, 32);
            pc_out <= resize(pc_in, 32);
            op_class <= (4 => op, 3 => store, 2 => load, 1 => branch, 0 => jump);
            rd_addr_out <= rd_addr;
            
        end if ;
        
    end process ; -- register_process
    
    --Equations
    opcode <= instruction(6 downto 0);
    rd_addr <= instruction(11 downto 7);
    func3 <= instruction(14 downto 12);
    rs1_addr <= instruction(19 downto 15);
    rs2_addr <= instruction(24 downto 20);
    -- imm <= instruction(31 downto 20)  --Da rivedere
    func7 <= instruction(31 downto 25);

end Behavioral;
