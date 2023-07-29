----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2023 17:23:28
-- Design Name: 
-- Module Name: test_ID - Behavioral
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

library work;
use work.constant_package.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_ID is
--  Port ( );
end test_ID;

architecture Behavioral of test_ID is
    signal clk, res, we, a_pcn, b_immn : STD_LOGIC := '0';
    signal instruction, rd_value_in, rs1_value, rs2_value, rd_value, immediate_out : std_logic_vector(31 downto 0):= (others => '0') ;
    signal pc_in, npc_in : UNSIGNED(11 downto 0):= (others => '0') ;  
    signal pc_out, npc_out : UNSIGNED (31 downto 0) := (others => '0');
    signal op_class, rd_addr_in, rd_addr_out : std_logic_vector(4 downto 0) := (others => '0'); 
    signal comparator_opcode, mem_opcode : std_logic_vector(2 downto 0):= (others => '0') ;
    signal alu_opcode : std_logic_vector(3 downto 0) := (others => '0');
begin
    dut : entity work.istruction_decode
    port map(
        clk => clk,
        res => res, 
        we => we,
        instruction => instruction,
        pc_in => pc_in,
        pc_out => pc_out,
        rd_value_in => rd_value_in,
        rd_addr_in => rd_addr_in,
        rs1_value => rs1_value,
        rs2_value => rs2_value,
        comparator_opcode => comparator_opcode,
        mem_opcode => mem_opcode,
        op_class => op_class,
        a_pcn => a_pcn,
        b_immn => b_immn,
        npc_in => npc_in,
        npc_out => npc_out
    );

    clk_gen : process begin
        clk <= not clk; 
        wait for 5 ns;        
    end process ; -- clk_gen   

    res_gen : process begin
        res <= '0';
        wait for 10 ns;
        res <= '1';
        wait;
    end process ; -- res_gen

    tes_pro : process
        constant n_instr : natural := 11;
        type array_of_costants is array (0 to n_instr) of std_logic_vector(31 downto 0);
        constant instructions : array_of_costants := (
            x"00a08013",
            x"fe208013",
            x"00001037",
            x"80000037",
            x"00001117",
            x"80000117",
            x"fe2084e3",
            x"00208663",
            x"fe222ea3",
            x"0041a123",
            x"fd9ff0ef",
            x"0040016f"
        );
    begin      
        wait for 9 ns;

        write_loop : for i in 1 to 31 loop
            instruction(6 downto 0) <= opcode_alu_op;
            instruction(19 downto 15) <= std_logic_vector(to_unsigned(i, 5));
            instruction(24 downto 20) <= std_logic_vector(to_unsigned(i + 1, 5));
            rd_addr_in <= std_logic_vector(to_unsigned(i, 5));
            rd_value_in <= std_logic_vector(to_unsigned(i, 32));
            we <= '1';
            wait for 10 ns;
        end loop; -- write_loop
        --Instruction 
--        test_for : for i in 0 to n_instr loop
--            instruction <= instructions(i);
--            wait for 10 ns;
--        end loop ; -- test_for  
        wait for 10 ns;  
        wait;
    end process ; --test_pro
end Behavioral;
