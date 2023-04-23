----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 17:24:36
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--OP: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA

entity alu is
    Port ( rs1 : in STD_LOGIC_VECTOR (31 downto 0);
           rs2 : in STD_LOGIC_VECTOR (31 downto 0);
           alu_out : out STD_LOGIC_VECTOR (31 downto 0);
           --alu_out : signed(31 downto 0);
           opcode : in STD_LOGIC_VECTOR (3 downto 0));
end alu;

architecture Behavioral of alu is
    signal shamt: std_logic_vector(4 downto 0);
    signal a, b : signed(31 downto 0);
    signal au, bu : unsigned(31 downto 0);
    signal arithm_logicn, right_leftn : std_logic;
    signal barrell_out : std_logic_vector(31 downto 0);
    
begin
    --Cast
    a <= signed(rs1);
    b <= signed(rs2);
    au <= unsigned(rs1);
    bu <= unsigned(rs2);
    
    --Shifter
    shamt <= rs2(4 downto 0);
    arithm_logicn <= opcode(3);
    shifter : entity work.barrell_shifter
    port map(
        data_in => rs1,
        data_out => barrell_out,
        shamt => shamt,
        right_leftn => right_leftn,
        arithm_logicn => arithm_logicn
    );
    
    alu_comb: process(rs1, rs2, opcode, a, b, au, bu, barrell_out)  begin
        case (opcode) is
            when "0000" => --ADD
                alu_out <= std_logic_vector(a + b);
            when "1000" => --SUB
                alu_out <= std_logic_vector(a - b);
            when "0001" => --SLL
                alu_out <= barrell_out;
            when "0010" => --SLT
                if a < b then
                    alu_out <= (1 => '1', others => '0');
                else 
                    alu_out <= (others => '0');
                end if;
            when "0011" => --SLTU
                if au < bu then
                    alu_out <= (1 => '1', others => '0');
                else 
                    alu_out <= (others => '0');
                end if;
            when "0100" => --XOR
                alu_out <= rs1 xor rs2;
            when "0101" => --SRL
                alu_out <= barrell_out;
            when "1101" => --SRA
                alu_out <= barrell_out;
            when "0110" => --OR
                alu_out <= rs1 or rs2;
            when "0111" => --ADD
                alu_out <= rs1 and rs2;
            when others =>
                alu_out <= (others => 'X');            
        end case;
    end process;
    
    right_leftn <= '1' when opcode(2 downto 0) = "101" else '0';
    
end Behavioral;
