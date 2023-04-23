----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2023 16:43:01
-- Design Name: 
-- Module Name: test_execute - Behavioral
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

entity test_execute is
--  Port ( );
end test_execute;

architecture Behavioral of test_execute is
    signal clk, res, jmp, a_pcn, b_immn: std_logic := '0';
    signal rs1, rs2, imm, resoult, res_reg : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_in, npc_in, npc_out : unsigned(31 downto 0) := (others => '0');
    signal alu_opcode : std_logic_vector(3 downto 0) := (others => '0');
    signal cmp_opcode : std_logic_vector(2 downto 0) := (others => '0');
    signal op_class, op_class_reg, rd_in, rd_out : std_logic_vector(4 downto 0) := (others => '0');

begin
    dut: entity work.execute
    port map(
        clk => clk,
        res => res,
        rs1_value => rs1,
        rs2_value => rs2,
        immediate => imm,
        npc_in => npc_in,
        npc_out => npc_out,
        pc_in => pc_in,
        alu_opcode => alu_opcode,
        comparator_opcode => cmp_opcode,
        op_class_in => op_class,
        op_class_out => op_class_reg,
        resoult => resoult,
        resoult_reg => res_reg,
        jmp => jmp,
        a_pcn => a_pcn,
        b_immn => b_immn,
        rd_addr_in => rd_in,
        rd_addr_out => rd_out
    );

    clock_gen : process
    begin
        clk <= '1'; wait for 5 ns;
        clk <= '0'; wait for 5 ns;
    end process ; -- clock_gen

    npc_in <= pc_in + 4;

    test_process : process begin
        res <= '0';

        --Imposto le operazioni:
        alu_opcode <= "0000"; -- ADD
        cmp_opcode <= "110";  -- BLTU
        wait for 9 ns;

        --Ripristino il reset
        res <= '1';

        --Imposto gli operandi:
        rs1 <= (2 => '0', 1 => '1', 0 => '1', others => '0'); --rs1 = 3
        rs2 <= (2 => '0', 1 => '0', 0 => '1', others => '0'); --rs2 = 1
        imm <= (2 => '1', 1 => '0', 0 => '1', others => '0'); --imm = 5
        rd_in <= (1 => '1', others => '0');                   --rd_addr = 1
        pc_in <= (others => '0');

        --Imposto la classe dell'operazione:
        op_class <= (4 => '1', others => '0'); -- Alu OP

        --Imposto i selettori: (a <= rs1, b <= rs2)
        a_pcn <= '1';
        b_immn <= '1';
        wait for 10 ns;

        --Imposto i selettori: (a <= pc , b <= rs2)
        a_pcn <= '0';
        b_immn <= '1';
        wait for 10 ns;

        --Imposto i selettori: (a <= rs1, b <= imm)
        a_pcn <= '1';
        b_immn <= '0';
        wait for 10 ns;
        
        --Imposto i selettori: (a <= pc , b <= imm)
        a_pcn <= '0';
        b_immn <= '0';
        wait for 10 ns;

        --Imposto i selettori: (a <= rs1, b <= rs2)
        a_pcn <= '1';
        b_immn <= '1';
        wait for 10 ns;

        --Imposto operandi:
        rs2 <= (2 => '1', 1 => '0', 0 => '0', others => '0'); --rs2 = 4
        wait for 10 ns;

        --Imposto operandi:
        rs2 <= (others => '0');  --rs2 = 0
        wait for 10 ns;
        
        --Imposto la classe dell'operazione:
        op_class <= (0 => '1', others => '0'); -- JMP (jmp => '1')
        wait for 10 ns;
        
        
        wait;
    end process ; -- test_process

end Behavioral;
