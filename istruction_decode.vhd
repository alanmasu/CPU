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

library work;
use work.constant_package.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity istruction_decode is
    Port ( clk, res : in STD_LOGIC;
           we : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (31 downto 0);
           pc_in, npc_in : in UNSIGNED (11 downto 0);
           rd_value_in : in STD_LOGIC_VECTOR (31 downto 0);         --Reg Destination val
           rd_addr_in : in STD_LOGIC_VECTOR (4 downto 0);           --Reg Destination addr
           rs1_value, rs2_value: out STD_LOGIC_VECTOR (31 downto 0);
           immediate_out : out STD_LOGIC_VECTOR (31 downto 0);
           rd_addr_out: out std_logic_vector(4 downto 0);
           pc_out, npc_out : out UNSIGNED (31 downto 0);
           alu_opcode : out STD_LOGIC_VECTOR (3 downto 0);
           comparator_opcode, mem_opcode : out STD_LOGIC_VECTOR(2 downto 0);
           a_pcn, b_immn : out STD_LOGIC;
           op_class : out STD_LOGIC_VECTOR(4 downto 0)
     );
end istruction_decode;

architecture Behavioral of istruction_decode is
    signal rs1, rs2: std_logic_vector(31 downto 0);
    signal rs1_addr, rs2_addr, rd_addr: STD_LOGIC_VECTOR (4 downto 0);
    signal func3 : std_logic_vector(2 downto 0);
    signal opcode, func7 : std_logic_vector(6 downto 0);
    --signal alu_opcode_in : STD_LOGIC_VECTOR (3 downto 0);
    signal op, store, load, branch, jump : STD_LOGIC;
begin
    register_file: entity work.triple_port_ram
    port map(
        addr_in => rd_addr_in,
        d_in => rd_value_in,
        d_out1 => rs1,
        d_out2 => rs2,
        addr_out1 => rs1_addr,
        addr_out2 => rs2_addr, 
        clk => clk,
        res => res,
        we => we
    );
    sign_extender: entity work.sign_extender_ro
    port map(
        clk => clk,
        res => res,
        instruction => instruction,
        imm_out => immediate_out
    );

    register_process : process( clk, res )
    begin
        if res = '0' then
            npc_out <= (others => '0');
            pc_out <= (others => '0');
            --op_class <= (others => '0');
            alu_opcode <= (others => '0');
            mem_opcode <= (others => '0');
            comparator_opcode <= (others => '0');
            -- rs1_value <= (others =>'0');
            -- rs2_value <= (others =>'0');
            rd_addr_out <= (others => '0');
            a_pcn <= '1';
            b_immn <= '1';
            op <= '0';
            store <= '0';
            load <= '0';
            branch <= '0';
            jump <= '0';
        elsif rising_edge(clk) then
            --Registri semplici
            npc_out <= resize(npc_in, 32);
            pc_out <= resize(pc_in, 32);
            --op_class <= (4 => op, 3 => store, 2 => load, 1 => branch, 0 => jump);
            rd_addr_out <= rd_addr;
            mem_opcode <= func3;
            comparator_opcode <= func3;
            
            
            --Decodifica
            if func7 = "0000000" or func7 = "0100000" then
                alu_opcode(3) <= func7(5);
                alu_opcode(2 downto 0) <= func3; 
            else 
                alu_opcode <= (others => '0');     --ADD
            end if ;
            --Calcolo della control word
            --Defaults
            op <= '0';
            store <= '0';
            load <= '0';
            branch <= '0';
            jump <= '0';
            a_pcn <= '1';
            b_immn <= '1';
            case( opcode ) is
                when opcode_alu_op => 
                    op <= '1';
                when opcode_alu_imm_op => 
                    op <= '1';
                    b_immn <= '0';
                when opcode_store => 
                    store <= '1';
                    b_immn <= '0';
                when opcode_load =>
                    load <= '1';
                    b_immn <= '0';
                when opcode_brench =>
                    branch <= '1';
                    a_pcn <= '0';
                    b_immn <= '0';
                when opcode_jalr =>
                    jump <= '1';
                    a_pcn <= '0';
                when opcode_jal =>
                    jump <= '1';
                    a_pcn <= '0';
                    b_immn <= '0';
                when opcode_auipc => 
                    op <= '1';
                    a_pcn <= '0';
                    b_immn <= '0';
                when opcode_lui => 
                    op <= '1';
                    b_immn <= '0';
                    --rs1_value <= (others => '0');
                when others =>
                    op <= op;
                    store <= store;
                    load <= load;
                    branch <= branch;
                    jump <= jump;
            end case ;
        end if ;
    end process ; -- register_process

    -- op_class_process : process(opcode)
    -- begin
    -- end process ; -- op_class_process
    
    --Equations
    rs1_value <= (others => '0') when opcode = opcode_lui else rs1;
    rs2_value <= rs2;
    opcode <= instruction(6 downto 0);
    rd_addr <= instruction(11 downto 7);
    func3 <= instruction(14 downto 12);
    rs1_addr <= instruction(19 downto 15);
    rs2_addr <= instruction(24 downto 20);
    func7 <= instruction(31 downto 25);
    op_class <= (4 => op, 3 => store, 2 => load, 1 => branch, 0 => jump);

end Behavioral;
