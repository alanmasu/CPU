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

library work;
use work.memory_pkg.all;

entity CPU is
    generic (
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		C_M_AXI_DATA_WIDTH	: integer	:= 32
	);
    Port ( 
        clk : IN std_logic;
        res : IN std_logic;

        --S_AXI_I interface
        s_axi_i_awaddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        s_axi_i_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_i_awvalid : IN STD_LOGIC;
        s_axi_i_awready : OUT STD_LOGIC;
        s_axi_i_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_i_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_i_wvalid : IN STD_LOGIC;
        s_axi_i_wready : OUT STD_LOGIC;
        s_axi_i_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_i_bvalid : OUT STD_LOGIC;
        s_axi_i_bready : IN STD_LOGIC;
        s_axi_i_araddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        s_axi_i_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_i_arvalid : IN STD_LOGIC;
        s_axi_i_arready : OUT STD_LOGIC;
        s_axi_i_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_i_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_i_rvalid : OUT STD_LOGIC;
        s_axi_i_rready : IN STD_LOGIC;

        --S_AXI_D interface
        s_axi_d_awaddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        s_axi_d_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_d_awvalid : IN STD_LOGIC;
        s_axi_d_awready : OUT STD_LOGIC;
        s_axi_d_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_d_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_d_wvalid : IN STD_LOGIC;
        s_axi_d_wready : OUT STD_LOGIC;
        s_axi_d_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_d_bvalid : OUT STD_LOGIC;
        s_axi_d_bready : IN STD_LOGIC;
        s_axi_d_araddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        s_axi_d_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_d_arvalid : IN STD_LOGIC;
        s_axi_d_arready : OUT STD_LOGIC;
        s_axi_d_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_d_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_d_rvalid : OUT STD_LOGIC;
        s_axi_d_rready : IN STD_LOGIC;

        --M_AXI interface
        M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		M_AXI_AWVALID	: out std_logic;
		M_AXI_AWREADY	: in std_logic;
		M_AXI_WDATA	    : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_WSTRB	    : out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		M_AXI_WVALID	: out std_logic;
		M_AXI_WREADY	: in std_logic;
		M_AXI_BRESP	    : in std_logic_vector(1 downto 0);
		M_AXI_BVALID	: in std_logic;
		M_AXI_BREADY	: out std_logic;
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		M_AXI_ARVALID	: out std_logic;
		M_AXI_ARREADY	: in std_logic;
		M_AXI_RDATA	    : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_RRESP	    : in std_logic_vector(1 downto 0);
		M_AXI_RVALID	: in std_logic;
		M_AXI_RREADY	: out std_logic
    );
end CPU;

architecture Behavioral of CPU is
    type state_type is (idle, fetch, decode, execute, memory_writeback);
    signal state : state_type := fetch;

    COMPONENT axi_bram_ctrl_0
    PORT (
        s_axi_aclk : IN STD_LOGIC;
        s_axi_aresetn : IN STD_LOGIC;
        s_axi_awaddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
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
        s_axi_araddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
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
        bram_addr_a : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        bram_wrdata_a : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        bram_rddata_a : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    --Memory - OUT Fetch - IN
    signal pc_in : std_logic_vector(11 downto 0) := (others => '0');
    --BRAM Controller
    signal mem_out: STD_LOGIC_VECTOR(31 downto 0);
    signal bram_rst_a_i : STD_LOGIC;
    signal bram_clk_a_i : STD_LOGIC;
    signal bram_en_a_i : STD_LOGIC;
    signal bram_we_a_i : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal bram_addr_a_i : STD_LOGIC_VECTOR(12 DOWNTO 0);
    signal bram_wrdata_a_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal bram_rddata_a_i : STD_LOGIC_VECTOR(31 DOWNTO 0);

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

    --Memory Writeback - IN
    signal d_bus_in : peripheral_data_t;

    --Memory Writeback - OUT | Peripheral - IN
    signal mem_wb_en_out : std_logic_vector(0 downto 0) := (others => '0');
    signal mem_wb_we_out : std_logic_vector(3 downto 0) := (others => '0');
    signal mem_wb_addr_out : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_wb_data_out : std_logic_vector(31 downto 0) := (others => '0');

    --BRAM 
    signal bram_rst_a_d : STD_LOGIC;
    signal bram_clk_a_d : STD_LOGIC;
    signal bram_en_a_d : STD_LOGIC;
    signal bram_we_a_d : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal bram_addr_a_d : STD_LOGIC_VECTOR(12 DOWNTO 0);
    signal bram_wrdata_a_d : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal bram_rddata_a_d : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --Execute - MSF
    signal mem_we : std_logic := '0';
    signal mem_ena : std_logic := '0';

    --AXI Memory Controller
    signal AXI_read_data : std_logic_vector(31 downto 0) := (others => '0');
    signal AXI_stall : std_logic := '0';
begin
    --Fetch
    axi_bram_instr_i: axi_bram_ctrl_0
    PORT MAP (
        s_axi_aclk      => clk,
        s_axi_aresetn   => res,
        s_axi_awaddr    => s_axi_i_awaddr,
        s_axi_awprot    => s_axi_i_awprot,
        s_axi_awvalid   => s_axi_i_awvalid,
        s_axi_awready   => s_axi_i_awready,
        s_axi_wdata     => s_axi_i_wdata,
        s_axi_wstrb     => s_axi_i_wstrb,
        s_axi_wvalid    => s_axi_i_wvalid,
        s_axi_wready    => s_axi_i_wready,
        s_axi_bresp     => s_axi_i_bresp,
        s_axi_bvalid    => s_axi_i_bvalid,
        s_axi_bready    => s_axi_i_bready,
        s_axi_araddr    => s_axi_i_araddr,
        s_axi_arprot    => s_axi_i_arprot,
        s_axi_arvalid   => s_axi_i_arvalid,
        s_axi_arready   => s_axi_i_arready,
        s_axi_rdata     => s_axi_i_rdata,
        s_axi_rresp     => s_axi_i_rresp,
        s_axi_rvalid    => s_axi_i_rvalid,
        s_axi_rready    => s_axi_i_rready,
        --BRAM
        bram_rst_a      => bram_rst_a_i,
        bram_clk_a      => bram_clk_a_i,
        bram_en_a       => bram_en_a_i,
        bram_we_a       => bram_we_a_i,
        bram_addr_a     => bram_addr_a_i,
        bram_wrdata_a   => bram_wrdata_a_i,
        bram_rddata_a   => bram_rddata_a_i
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
        clkb => bram_clk_a_i,
        enb => bram_en_a_i,
        web => bram_we_a_i,
        addrb => bram_addr_a_i(11 downto 2),
        dinb => bram_wrdata_a_i,
        doutb => bram_rddata_a_i
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
    axi_bram_instr_d: axi_bram_ctrl_0
    PORT MAP (
        s_axi_aclk      => clk,
        s_axi_aresetn   => res,
        s_axi_awaddr    => s_axi_d_awaddr,
        s_axi_awprot    => s_axi_d_awprot,
        s_axi_awvalid   => s_axi_d_awvalid,
        s_axi_awready   => s_axi_d_awready,
        s_axi_wdata     => s_axi_d_wdata,
        s_axi_wstrb     => s_axi_d_wstrb,
        s_axi_wvalid    => s_axi_d_wvalid,
        s_axi_wready    => s_axi_d_wready,
        s_axi_bresp     => s_axi_d_bresp,
        s_axi_bvalid    => s_axi_d_bvalid,
        s_axi_bready    => s_axi_d_bready,
        s_axi_araddr    => s_axi_d_araddr,
        s_axi_arprot    => s_axi_d_arprot,
        s_axi_arvalid   => s_axi_d_arvalid,
        s_axi_arready   => s_axi_d_arready,
        s_axi_rdata     => s_axi_d_rdata,
        s_axi_rresp     => s_axi_d_rresp,
        s_axi_rvalid    => s_axi_d_rvalid,
        s_axi_rready    => s_axi_d_rready,
        --BRAM
        bram_rst_a      => bram_rst_a_d,
        bram_clk_a      => bram_clk_a_d,
        bram_en_a       => bram_en_a_d,
        bram_we_a       => bram_we_a_d,
        bram_addr_a     => bram_addr_a_d,
        bram_wrdata_a   => bram_wrdata_a_d,
        bram_rddata_a   => bram_rddata_a_d
    );

    memory_writeback : entity work.memory_write_back
    port map(
        clk => clk,
        res => res,

        --OUT
        rd_value => rd_value_in,
        rd_addr_out => rd_addr_in,
        pc_out => pc_in,

        --IN
        jmp => jmp_executed,
        we_in => mem_we,
        en_in => mem_ena,
        mem_opcode => mem_opcode_executed,
        op_class => op_class_executed,
        npc_in => npc_executed,
        alu_resoult => result,
        alu_resoult_reg => result_reg,
        rs2_value => rs2_value_executed,
        rd_addr_in => rd_addr_executed,

        --Peripheral
        en_out => mem_wb_en_out,
        we_out => mem_wb_we_out,
        address_out => mem_wb_addr_out,
        d_out => mem_wb_data_out,
        d_in => d_bus_in,

        --BRAM interface
        clkb => bram_clk_a_d,
        enb => bram_en_a_d,
        web => bram_we_a_d,
        addrb => bram_addr_a_d(12 downto 2),
        dinb => bram_wrdata_a_d,
        doutb => bram_rddata_a_d
    );

    d_bus_in.AXI_data <= AXI_read_data;

    axi_mem_ctrl : entity work.AXI_memory_controller
    port map(
        en => mem_wb_en_out(0), 
        we => mem_wb_we_out,
        address => mem_wb_addr_out,
        write_data => mem_wb_data_out,
        read_data => AXI_read_data,
        stall => AXI_stall,
        M_AXI_ACLK => clk,
        M_AXI_ARESETN => res,
        M_AXI_AWADDR => M_AXI_AWADDR,
		M_AXI_AWPROT => M_AXI_AWPROT,
		M_AXI_AWVALID => M_AXI_AWVALID,
		M_AXI_AWREADY => M_AXI_AWREADY,
		M_AXI_WDATA => M_AXI_WDATA,
		M_AXI_WSTRB	 => M_AXI_WSTRB,
		M_AXI_WVALID => M_AXI_WVALID,
		M_AXI_WREADY => M_AXI_WREADY,
		M_AXI_BRESP => M_AXI_BRESP,
		M_AXI_BVALID => M_AXI_BVALID,
		M_AXI_BREADY => M_AXI_BREADY,
		M_AXI_ARADDR => M_AXI_ARADDR,
		M_AXI_ARPROT => M_AXI_ARPROT,
		M_AXI_ARVALID => M_AXI_ARVALID,
		M_AXI_ARREADY => M_AXI_ARREADY,
		M_AXI_RDATA => M_AXI_RDATA,
		M_AXI_RRESP => M_AXI_RRESP,
		M_AXI_RVALID => M_AXI_RVALID,
		M_AXI_RREADY => M_AXI_RREADY
    );

    process(clk, res) begin

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
