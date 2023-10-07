----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2023 09:15:10 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port ( 
        clk : IN std_logic;
        res : IN std_logic;

        --S_AXI interface
        -- s_axi_aclk : IN STD_LOGIC;
        -- s_axi_aresetn : IN STD_LOGIC;
        s_axi_awaddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_awvalid : IN STD_LOGIC;
        s_axi_awready : OUT STD_LOGIC;
        s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_wvalid : IN STD_LOGIC;
        s_axi_wready : OUT STD_LOGIC;
        s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bvalid : OUT STD_LOGIC;
        s_axi_bready : IN STD_LOGIC;
        s_axi_araddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_arvalid : IN STD_LOGIC;
        s_axi_arready : OUT STD_LOGIC;
        s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rvalid : OUT STD_LOGIC;
        s_axi_rready : IN STD_LOGIC
    );
end CPU;

architecture Behavioral of CPU is
    type state_type is (idle, fetch, decode, execute, memory_writeback);
    signal state : state_type := fetch;

    COMPONENT axi_bram_ctrl_0
    PORT (
        s_axi_aclk : IN STD_LOGIC;
        s_axi_aresetn : IN STD_LOGIC;
        s_axi_awaddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_awvalid : IN STD_LOGIC;
        s_axi_awready : OUT STD_LOGIC;
        s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_wvalid : IN STD_LOGIC;
        s_axi_wready : OUT STD_LOGIC;
        s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bvalid : OUT STD_LOGIC;
        s_axi_bready : IN STD_LOGIC;
        s_axi_araddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_arvalid : IN STD_LOGIC;
        s_axi_arready : OUT STD_LOGIC;
        s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rvalid : OUT STD_LOGIC;
        s_axi_rready : IN STD_LOGIC;
        bram_rst_a : OUT STD_LOGIC;
        bram_clk_a : OUT STD_LOGIC;
        bram_en_a : OUT STD_LOGIC;
        bram_we_a : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        bram_addr_a : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        bram_wrdata_a : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        bram_rddata_a : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    --Memory - OUT Fetch - IN
    signal pc_in : std_logic_vector(11 downto 0) := (others => '0');
    --BRAM Controller
    signal mem_out: STD_LOGIC_VECTOR(31 downto 0);
    signal bram_rst_a : STD_LOGIC;
    signal bram_clk_a : STD_LOGIC;
    signal bram_en_a : STD_LOGIC;
    signal bram_we_a : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal bram_addr_a : STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal bram_wrdata_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal bram_rddata_a : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Fetch - MSF
    signal pc_load : std_logic := '0';
    
    --Fetch - OUT | Decode - IN
    signal instruction_fetched : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_fetched, npc_fetched : unsigned(11 downto 0) := (others => '0');
    
    --Decode - MSF 
    signal regFile_we : std_logic := '0';
    --Decode - IN | Memory Writeback - OUT
    signal rd_addr_in : std_logic_vector(4 downto 0) := (others => '0');
    signal rd_value_in : std_logic_vector(31 downto 0) := (others => '0');
    --Decode - OUT | Execute - IN
    signal rs1_value, rs2_value, immediate : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_addr_out : std_logic_vector(4 downto 0) := (others => '0');
    signal pc_decoded, npc_decoded : unsigned(31 downto 0) := (others => '0');
    signal alu_opcode : std_logic_vector(3 downto 0) := (others => '0');
    signal comparator_opcode, mem_opcode : std_logic_vector(2 downto 0) := (others => '0');
    signal a_pcn, b_immn : std_logic := '0';
    signal op_class_decoded : std_logic_vector(4 downto 0) := (others => '0');

    --Execute - MSF
    --
    --Execute - OUT | Memory Writeback - IN
    signal result, result_reg : std_logic_vector(31 downto 0) := (others => '0');
    signal npc_executed : unsigned(31 downto 0) := (others => '0');
    signal rd_addr_executed : std_logic_vector(4 downto 0) := (others => '0');
    signal op_class_executed : std_logic_vector(4 downto 0) := (others => '0');
    signal mem_opcode_executed : std_logic_vector(2 downto 0) := (others => '0');
    signal rs2_value_executed : std_logic_vector(31 downto 0) := (others => '0');
    signal jmp_executed : std_logic := '0';

    --Execute - MSF
    signal mem_we : std_logic := '0';
    signal mem_ena : std_logic := '0';
begin
    --Fetch
    axi_bram_instr: axi_bram_ctrl_0
    PORT MAP (
        s_axi_aclk => clk,
        s_axi_aresetn => res,
        s_axi_awaddr => s_axi_awaddr,
        s_axi_awprot => s_axi_awprot,
        s_axi_awvalid => s_axi_awvalid,
        s_axi_awready => s_axi_awready,
        s_axi_wdata => s_axi_wdata,
        s_axi_wstrb => s_axi_wstrb,
        s_axi_wvalid => s_axi_wvalid,
        s_axi_wready => s_axi_wready,
        s_axi_bresp => s_axi_bresp,
        s_axi_bvalid => s_axi_bvalid,
        s_axi_bready => s_axi_bready,
        s_axi_araddr => s_axi_araddr,
        s_axi_arprot => s_axi_arprot,
        s_axi_arvalid => s_axi_arvalid,
        s_axi_arready => s_axi_arready,
        s_axi_rdata => s_axi_rdata,
        s_axi_rresp => s_axi_rresp,
        s_axi_rvalid => s_axi_rvalid,
        s_axi_rready => s_axi_rready,
        --BRAM
        bram_rst_a => bram_rst_a,
        bram_clk_a => bram_clk_a,
        bram_en_a => bram_en_a,
        bram_we_a => bram_we_a,
        bram_addr_a => bram_addr_a,
        bram_wrdata_a => bram_wrdata_a,
        bram_rddata_a => bram_rddata_a
    );
    instr_fetch : entity work.instruction_fetch
    port map(
        clk => clk, 
        res => res,
        pc_load => pc_load,
        pc => pc_fetched,
        npc => npc_fetched,
        pc_in => pc_in,
        instruction => instruction_fetched,

        --BRAM interface
        clkb => bram_clk_a,
        enb => bram_en_a,
        web => bram_we_a,
        addrb => bram_addr_a(11 downto 2),
        dinb => bram_wrdata_a,
        doutb => bram_rddata_a
    );

    --Decode
    instr_decode : entity work.istruction_decode
    port map(
        clk => clk,
        res => res,

        --OUT
        rs1_value => rs1_value,
        rs2_value => rs2_value,
        immediate_out => immediate,
        rd_addr_out => rd_addr_out,
        pc_out => pc_decoded,
        npc_out => npc_decoded,
        alu_opcode => alu_opcode,
        comparator_opcode => comparator_opcode,
        mem_opcode => mem_opcode,
        a_pcn => a_pcn,
        b_immn => b_immn,
        op_class => op_class_decoded,

        --IN
        we => regFile_we,
        instruction => instruction_fetched,
        pc_in => pc_fetched,
        npc_in => npc_fetched,
        rd_value_in => rd_value_in,
        rd_addr_in => rd_addr_in
    );
    
    --Execute
    instr_execute : entity work.execute
    port map(
        clk => clk,
        res => res,

        --OUT
        resoult_reg => result_reg,
        resoult => result,
        npc_out => npc_executed,
        rd_addr_out => rd_addr_executed,
        op_class_out => op_class_executed,
        mem_opcode_out => mem_opcode_executed,
        jmp => jmp_executed,
        rs2_out => rs2_value_executed,

        --IN
        rs1_value => rs1_value,
        rs2_value => rs2_value,
        immediate => immediate,
        npc_in => npc_decoded,
        pc_in => pc_decoded,
        rd_addr_in => rd_addr_out,
        a_pcn => a_pcn,
        b_immn => b_immn,
        alu_opcode => alu_opcode,
        comparator_opcode => comparator_opcode,
        mem_opcode_in => mem_opcode,
        op_class_in => op_class_decoded
    );

    --Memory Writeback 
    instr_memory_writeback : entity work.memory_write_back
    port map(
        clk => clk,
        res => res,

        --OUT
        rd_value => rd_value_in,
        rd_addr_out => rd_addr_in,
        pc_out => pc_in,

        --IN
        jmp => jmp_executed,
        mem_we => mem_we,
        mem_ena => mem_ena,
        mem_opcode => mem_opcode_executed,
        op_class => op_class_executed,
        npc_in => npc_executed,
        alu_resoult => result,
        alu_resoult_reg => result_reg,
        rs2_value => rs2_value_executed,
        rd_addr_in => rd_addr_executed
    );


    process(clk, res)
        
    begin

        if(res = '0') then
            state <= idle;
            regFile_we <= '0';
            pc_load <= '1';
            mem_we <= '0';
        elsif(rising_edge(clk)) then
            regFile_we <= '0';
            pc_load <= '0';
            mem_we <= '0';
            --Next state and control signals for next state
            case state is
                when idle =>
                    state <= fetch;
                    pc_load <= '1';
                when fetch =>
                    state <= decode;
                when decode =>
                    state <= execute;
                when execute =>
                    state <= memory_writeback;
                    pc_load <= '1';
                    case (op_class_decoded) is
                        when "10000" => --OP
                            regFile_we <= '1';
                        when "01000" => --Store
                            mem_we <= '1';
                            mem_ena <= '1';
                        when "00100" => --Load
                            mem_ena <= '1';
                            regFile_we <= '1';
                        when "00001" => --Jump 
                            regFile_we <= '1';   
                        when others =>
                            regFile_we <= '0';
                            mem_we <= '0';
                            mem_ena <= '0';                                   
                    end case;
                    
                when memory_writeback =>
                    state <= fetch;
            end case;
        end if;
    end process;


end Behavioral;
