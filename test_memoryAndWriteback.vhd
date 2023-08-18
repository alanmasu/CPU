----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2023 22:19:45
-- Design Name: 
-- Module Name: test_memoryAndWriteback - Behavioral
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
-- To Test for at least for 260ns
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

entity test_memoryAndWriteback is
--  Port ( );
end test_memoryAndWriteback;

architecture Behavioral of test_memoryAndWriteback is
    signal clk, res, jmp, mem_we, mem_en: STD_LOGIC := '0';
    signal mem_opcode : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal op_class : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
    signal pc, npc_in : unsigned (31 downto 0):= (others => '0');
    signal alu_resoult : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
    signal alu_resoult_reg : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
    signal rs2_value : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
    signal rd_addr_in : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
    signal rd_value : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
    signal rd_addr_out : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
    signal pc_out : STD_LOGIC_VECTOR (11 downto 0):= (others => '0');
begin
    dut : entity work.memory_write_back
    port map(
        clk => clk,
        res => res,
        jmp => jmp,
        mem_we => mem_we,
        mem_ena => mem_en,
        mem_opcode => mem_opcode,
        op_class => op_class,
        rs2_value => rs2_value,
        npc_in => npc_in,
        alu_resoult => alu_resoult,
        alu_resoult_reg => alu_resoult_reg,
        rd_addr_in => rd_addr_in,
        rd_value => rd_value,
        rd_addr_out => rd_addr_out,
        pc_out => pc_out
    );

    clk_gen : process begin
        clk <= '1'; wait for 5 ns;
        clk <= '0'; wait for 5 ns;
    end process ; -- clk_gen

    res_gen : process begin
        res <= '0';
        wait for 10 ns;
        res <= '1';
        wait;
    end process ; -- res_gen

    test_process : process begin
        wait for 9 ns; --Waiting reset
        
        --Setto i valori di ingresso:
        jmp <= '0';
        rd_addr_in <= "00101";

        --OP
        op_class <= "10000"; 
        wait for 10 ns;

        --Store
        mem_en <= '1';
        mem_we <= '1';
        op_class <= "01000";
        --Scrive 4 WORD shiftate di un byte ciascuna
        mem_opcode <= "010"; --SW
        rs2_value <= std_logic_vector(to_signed(274877688, 32));
        for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i, 32));
            wait for 10 ns;
        end loop;
        
        --Scrive 4 HALFWORD shiftate di un byte ciascuna
        mem_opcode <= "001"; --SH
        rs2_value <= std_logic_vector(to_unsigned(35535,32));
        for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i + 16, 32));
            wait for 10 ns;
        end loop;

        --Scrive 4 BYTE shiftate di un byte ciascuna
        mem_opcode <= "000"; --SB
        rs2_value <= std_logic_vector(to_unsigned(207, 32));
        for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i + 32, 32));
            wait for 10 ns;
        end loop;

        --Load
        mem_we <= '0';
        op_class <= "00100"; 
        mem_opcode <= "010"; --LW
        mem_read_LW : for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i, 32));  --rd = i
            wait for 10 ns;
        end loop ;

        mem_opcode <= "001"; --LH
        mem_read_LH : for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i + 16, 32));  --rd = i
            wait for 10 ns;
        end loop ;

        mem_opcode <= "101"; --LHU
        mem_read_LHU : for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i + 16, 32));  --rd = i
            wait for 10 ns;
        end loop ;

        mem_opcode <= "000"; --LB
        mem_read_LB : for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i + 32, 32));  --rd = i
            wait for 10 ns;
        end loop ;

        mem_opcode <= "100"; --LBU
        mem_read_LBU : for i in 0 to 3 loop
            alu_resoult <= std_logic_vector(to_unsigned(i * 4 + i + 32, 32));  --rd = i
            wait for 10 ns;
        end loop ;
        mem_en <= '0';

        alu_resoult <= std_logic_vector(to_signed(45,32));
        wait for 10 ns;
        
        op_class <= "00010"; --Brench
        wait for 10 ns;

        op_class <= "00001"; --JAL
        wait for 10 ns;
        
        jmp <= '1';
        op_class <= "00010"; --Brench
        alu_resoult <= std_logic_vector(to_signed(34,32));
        wait for 10 ns;
        
        alu_resoult <= std_logic_vector(to_signed(142,32));
        op_class <= "00001"; --JAL
        wait for 10 ns;
        wait;
    end process ; -- test_process
    
    process (clk, res) begin
        if res = '0' then
            alu_resoult_reg <= (others => '0');
            pc <= (others => '0');
        elsif rising_edge(clk) then
            alu_resoult_reg <= alu_resoult;
            pc <= resize(unsigned(pc_out), 32);
        end if;
    end process;
    
    npc_in <= pc + 4 when res = '1' else (others => '0');   
end Behavioral;
