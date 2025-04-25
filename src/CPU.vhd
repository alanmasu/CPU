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
use work.constant_package.all;
use work.types_pkg.all;

entity CPU is
    generic (
		C_M_AXI_ADDR_WIDTH	   : integer	:= 32;
		C_M_AXI_DATA_WIDTH	   : integer	:= 32;
        RUN_BLINK_COUNTER_SIZE : integer    := 26;
        IS_STANDALONE          : boolean    := false
	);
    Port ( 
        clk         : IN std_logic;
        clk_100MHz  : IN std_logic;
        res_in      : IN std_logic;

        --S_AXI_I interface
        s_axi_i_awaddr : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
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
        s_axi_i_araddr : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        s_axi_i_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        s_axi_i_arvalid : IN STD_LOGIC;
        s_axi_i_arready : OUT STD_LOGIC;
        s_axi_i_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_i_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_i_rvalid : OUT STD_LOGIC;
        s_axi_i_rready : IN STD_LOGIC;

        --S_AXI_D interface
        s_axi_d_awaddr : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
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
        s_axi_d_araddr : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
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
		M_AXI_RREADY	: out std_logic;

        -- GPIO
        GPIO            : INOUT STD_LOGIC_VECTOR(31 downto 0);

        -- I2C
        SDA             : INOUT STD_LOGIC;
        SCL             : INOUT STD_LOGIC;

        -- RUN/RES
        run_in          : IN STD_LOGIC;
        run_out         : OUT STD_LOGIC;

        --DEBUG
        run_dbg         : OUT STD_LOGIC;
        run_in_dbg      : OUT STD_LOGIC;
        res_dbg         : OUT STD_LOGIC;
        res_in_dbg      : OUT STD_LOGIC;
        state_dbg       : OUT STD_LOGIC_VECTOR(2 downto 0);
        M_WB_en_dbg     : OUT STD_LOGIC;
        M_WB_we_dbg     : OUT STD_LOGIC;
        mem_we_dbg      : OUT STD_LOGIC_VECTOR(3 downto 0);
        regFile_we_dbg  : OUT STD_LOGIC;
        mem_addr_dbg    : OUT STD_LOGIC_VECTOR(31 downto 0);
        mem_data_dbg    : OUT STD_LOGIC_VECTOR(31 downto 0);
        mem_rdata_dbg   : OUT STD_LOGIC_VECTOR(31 downto 0);
        ram_en_dbg      : OUT STD_LOGIC;
        axi_en_dbg      : OUT STD_LOGIC;
        gpio_en_dbg     : OUT STD_LOGIC;
        axi_stall_dbg   : OUT STD_LOGIC;
        instruction_dbg : OUT STD_LOGIC_VECTOR(31 downto 0);
        CREG_CTR_dbg    : OUT STD_LOGIC_VECTOR(7 downto 0);
        rd_addr_dbg     : OUT STD_LOGIC_VECTOR(4 downto 0);

        gpio_state_dbg  : OUT STD_LOGIC_VECTOR(31 downto 0);
        gpio_dbg        : OUT STD_LOGIC_VECTOR(31 downto 0);

        -- Buttons
        btn_up          : IN STD_LOGIC;
        btn_down        : IN STD_LOGIC;
        btn_left        : IN STD_LOGIC;
        btn_right       : IN STD_LOGIC;
        btn_center      : IN STD_LOGIC;
        switches        : IN STD_LOGIC_VECTOR(1 downto 0);

        -- LEDs
        leds            : OUT STD_LOGIC_VECTOR(2 downto 0);

        -- OLED Display
        oled_select0 : in std_logic;
        oled_sdin   : out std_logic;
        oled_sclk   : out std_logic;
        oled_dc     : out std_logic;
        oled_res    : out std_logic;
        oled_vbat   : out std_logic;
        oled_vdd    : out std_logic
        
    );
end CPU;

architecture Behavioral of CPU is
    
    -- MACCHINA A STATI
    signal state : state_type := fetch;
    signal is_axi_load : std_logic := '0';
    signal rd_addr_out_reg : std_logic_vector(4 downto 0) := (others => '0');
    signal op_class_reg : std_logic_vector(4 downto 0) := (others => '0');
    signal mem_opcode_reg : std_logic_vector(2 downto 0) := (others => '0');

    -- RUN/RES
    signal res          : std_logic := '0';
    signal res_tmp      : std_logic := '0';
    signal run          : std_logic := '0';

    -- BLINK
    signal blink_counter : unsigned(RUN_BLINK_COUNTER_SIZE-1 downto 0) := (others => '0');
    signal alive_led : std_logic := '0';

    COMPONENT axi_bram_ctrl_0
    PORT (
        s_axi_aclk : IN STD_LOGIC;
        s_axi_aresetn : IN STD_LOGIC;
        s_axi_awaddr : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
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
        s_axi_araddr : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
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
        bram_addr_a : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
        bram_wrdata_a : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        bram_rddata_a : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    --Memory - OUT Fetch - IN
    signal pc_in : std_logic_vector(31 downto 0) := (others => '0');
    --BRAM Controller
    signal mem_out: STD_LOGIC_VECTOR(31 downto 0);
    signal bram_rst_a_i : STD_LOGIC;
    signal bram_clk_a_i : STD_LOGIC;
    signal bram_en_a_i : STD_LOGIC;
    signal bram_we_a_i : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal bram_addr_a_i : STD_LOGIC_VECTOR(19 DOWNTO 0);
    signal bram_wrdata_a_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal bram_rddata_a_i : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

    --Fetch - MSF
    signal pc_load      : STD_LOGIC := '0';
    signal instr_doutb  : STD_LOGIC_VECTOR(31 downto 0);
    signal instr_enb    : STD_LOGIC := '0';
    
    --Fetch - OUT | Decode - IN
    signal instruction_fetched : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_fetched, npc_fetched : unsigned(31 downto 0) := (others => '0');
    
    --Decode - MSF 
    signal regFile_we : std_logic := '0';
    --Decode - IN | Memory Writeback - OUT
    signal rd_addr_in : std_logic_vector(4 downto 0) := (others => '0');    -- Memory Writeback - OUT
    signal rd_addr_in_decode : std_logic_vector(4 downto 0) := (others => '0'); -- Decode - IN
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
    signal mem_wb_op_class : std_logic_vector(4 downto 0) := (others => '0');
    signal mem_wb_mem_opcode : std_logic_vector(2 downto 0) := (others => '0');

    --Memory Writeback - OUT | Peripheral - IN
    signal mem_wb_en_out : en_bus_t := (
        en_mem => '0',
        en_AXI => '0',
        en_GPIO => '0',
        en_I2C => '0'
    );
    signal mem_wb_we_out : std_logic_vector(3 downto 0) := (others => '0');
    signal mem_wb_addr_out : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_wb_data_out : std_logic_vector(31 downto 0) := (others => '0');

        --BRAM 
    signal bram_rst_a_d : STD_LOGIC;
    signal bram_clk_a_d : STD_LOGIC;
    signal bram_en_a_d : STD_LOGIC;
    signal bram_we_a_d : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal bram_addr_a_d : STD_LOGIC_VECTOR(19 DOWNTO 0);
    signal bram_wrdata_a_d : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal bram_rddata_a_d : STD_LOGIC_VECTOR(31 DOWNTO 0);
        --Execute - MSF
    signal mem_we : std_logic := '0';
    signal mem_ena : std_logic := '0';

        --AXI Memory Controller
    signal AXI_read_data : std_logic_vector(31 downto 0) := (others => '0');
    signal AXI_stall : std_logic := '0';

    --Control Register File
    signal control_reg_ena : std_logic := '0';
    signal control_reg : control_reg_t := (others => (others => '0'));

    --OLED
    signal display_in : std_logic_vector(31 downto 0) := (others => '0');
    signal oled_select : std_logic_vector(2 downto 0) := (others => '0');

    --DEBUG
    signal state_dbg_sig : std_logic_vector(2 downto 0);
begin
    --Fetch
    axi_bram_controller_i: axi_bram_ctrl_0
    PORT MAP (
        s_axi_aclk      => clk,
        s_axi_aresetn   => res_in,
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
        enb => instr_enb,
        web => bram_we_a_i,
        addrb => bram_addr_a_i(13 downto 2),
        dinb => bram_wrdata_a_i,
        doutb => instr_doutb
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
        rd_addr_in => rd_addr_in_decode
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
    axi_bram_controller_d: axi_bram_ctrl_0
    PORT MAP (
        s_axi_aclk      => clk,
        s_axi_aresetn   => res_in,
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

    mem_writeback : entity work.memory_write_back
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
        mem_opcode => mem_wb_mem_opcode,
        op_class => mem_wb_op_class,
        npc_in => npc_executed,
        alu_resoult => result,
        alu_resoult_reg => result_reg,
        rs2_value => rs2_value_executed,
        rd_addr_in => rd_addr_executed,
        is_axi_load => is_axi_load,

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
        en => mem_wb_en_out.en_AXI, 
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

    -- GPIO
    gpio_driver : entity work.GPIO
    port map(
        clk => clk,
        res => res,
        ena => mem_wb_en_out.en_GPIO,
        address => mem_wb_addr_out,
        wea => mem_wb_we_out,
        d_in => mem_wb_data_out,
        d_out => d_bus_in.GPIO_data,
        GPIO => GPIO,
        gpio_state_dbg => gpio_state_dbg
    );

    -- I2C
    i2c_driver : entity work.I2C_module
    generic map(
        CLOCK_FREQUENCY => 40_000
    )
    port map(
        clk => clk,
        res => res,
        ena => mem_wb_en_out.en_I2C,
        wea => mem_wb_we_out,
        addra => mem_wb_addr_out,
        dina => mem_wb_data_out,
        douta => d_bus_in.I2C_data,
        scl => SCL,
        sda => SDA
    );

    -- OLED Display
    oled_display : entity work.oled_driver
    port map(
        clock => clk_100MHz,
        reset => res_in,
        poweroff => btn_center,
        display_in => display_in,
        oled_sdin => oled_sdin,
        oled_sclk => oled_sclk,
        oled_dc => oled_dc,
        oled_res => oled_res,
        oled_vbat => oled_vbat,
        oled_vdd => oled_vdd
    );

    ----------------------------------- DEBUG -----------------------------------
    run_dbg <= run;
    run_in_dbg <= run_in;
    res_dbg <= res;
    res_in_dbg <= res_in;
        -- Memory Writeback
    M_WB_en_dbg     <= mem_ena;
    M_WB_we_dbg     <= mem_we;
    mem_we_dbg      <= mem_wb_we_out;
    regFile_we_dbg  <= regFile_we;
    mem_addr_dbg    <= mem_wb_addr_out;
    mem_data_dbg    <= mem_wb_data_out;
    mem_rdata_dbg   <= rd_value_in;
    ram_en_dbg      <= mem_wb_en_out.en_mem;
    axi_en_dbg      <= mem_wb_en_out.en_AXI;
    gpio_en_dbg     <= mem_wb_en_out.en_GPIO;
    axi_stall_dbg   <= AXI_stall;
    instruction_dbg <= instruction_fetched;
    CREG_CTR_dbg    <= control_reg(CREG_CTR)(7 downto 0);
    rd_addr_dbg     <= rd_addr_in_decode;
    
    gpio_for_loop: for i in 0 to 31 generate
        -- gpio_state_dbg(i) <= '1' when to_X01(GPIO(i)) = '1' else '0';
        gpio_dbg(i) <= '1' when to_X01(GPIO(i)) = '1' else '0';
    end generate;
    -- gpio_dbg        <= GPIO;
    

    state_dbg_comb : process( state ) is 
        variable state_integer : integer := 0;
    begin
        state_integer := state_type'POS(state);
        state_dbg_sig <= std_logic_vector(to_unsigned(state_integer,3));
    end process ; -- control_reg_file
    state_dbg <= state_dbg_sig;
    ----------------------------------- END DEBUG -----------------------------------


    --Control Register File
        --Enable signals for Instruction Memory PortB and Control Register File
    ena_comb : process( bram_addr_a_i, bram_en_a_i) begin
        instr_enb <= check_bram_address(bram_addr_a_i, ROM) and bram_en_a_i;
        control_reg_ena <= check_bram_address(bram_addr_a_i, CREG_FILE) and bram_en_a_i;
    end process ; -- ena_comb

        -- Bram Controller In value selector
    bram_i_dina_comb : process( bram_addr_a_i, instr_doutb, control_reg) is
        variable reg_addr : integer;
    begin
        bram_rddata_a_i <= bram_rddata_a_i;     -- Latch inference
        if(check_bram_address(bram_addr_a_i, ROM) = '1') then
            bram_rddata_a_i <= instr_doutb;
        elsif(check_bram_address(bram_addr_a_i, CREG_FILE) = '1') then
            reg_addr := to_integer(unsigned(bram_addr_a_i(6 downto 2)));
            bram_rddata_a_i <= control_reg(reg_addr);
        end if;
        
    end process ; -- bram_i_dina_comb

        --Control Register File Implementation
    control_reg_file : process( clk, res) is 
        variable reg_addr : integer;
        variable state_integer : integer := 0;
    begin
        if(res = '0') then
            control_reg <= CREG_RESET_VALUE;
        elsif(rising_edge(clk)) then
            if(control_reg_ena = '1') then
                reg_addr := to_integer(unsigned(bram_addr_a_i(6 downto 2)));
                if (bram_we_a_i(0) = '1') then
                    control_reg(reg_addr)(7 downto 0) <= bram_wrdata_a_i(7 downto 0);
                end if;
                if (bram_we_a_i(1) = '1') then
                    control_reg(reg_addr)(15 downto 8) <= bram_wrdata_a_i(15 downto 8);
                end if;
                if (bram_we_a_i(2) = '1') then
                    control_reg(reg_addr)(23 downto 16) <= bram_wrdata_a_i(23 downto 16);
                end if;
                if (bram_we_a_i(3) = '1') then
                    control_reg(reg_addr)(31 downto 24) <= bram_wrdata_a_i(31 downto 24);
                end if;
            end if;
            state_integer := state_type'POS(state);
            control_reg(CREG_CTR)(CREG_RUN_C_BIT) <= run;
            control_reg(CREG_PC) <= std_logic_vector(pc_fetched);
            control_reg(CREG_STATE) <= std_logic_vector(to_unsigned(state_integer,32));
            control_reg(CREG_INST) <= instruction_fetched;
            --IO
            control_reg(CREG_IO)(CREG_BTN_UP_BIT) <= btn_up;
            control_reg(CREG_IO)(CREG_BTN_DOWN_BIT) <= btn_down;
            control_reg(CREG_IO)(CREG_BTN_LEFT_BIT) <= btn_left;
            control_reg(CREG_IO)(CREG_BTN_RIGHT_BIT) <= btn_right;
            control_reg(CREG_IO)(CREG_SWITCH0_BIT) <= switches(0);
            control_reg(CREG_IO)(CREG_SWITCH1_BIT) <= switches(1);

        end if;
    end process ; -- control_reg_file
    
    -- Control Register File Signals
      -- Run
    run <=  control_reg(CREG_CTR)(CREG_RUN_BIT) and run_in when IS_STANDALONE = false else
            control_reg(CREG_CTR)(CREG_RUN_BIT) or  run_in when IS_STANDALONE = true else
            '0';
      -- Reset
    res <= res_tmp and res_in;
    reset_pro : process( clk ) begin
        if(rising_edge(clk)) then
            if(control_reg(CREG_CTR)(CREG_RES_BIT) = '0') then
                res_tmp <= '0';
                -- control_reg(CREG_CTR)(CREG_RES_BIT) <= '1';
            else 
                res_tmp <= '1';
            end if; 
        end if;
    end process ; -- reset_pro

    -- PS-PL GPIO
    leds(0) <= control_reg(CREG_IO)(CREG_LED0_BIT);
    leds(1) <= control_reg(CREG_IO)(CREG_LED1_BIT);
    leds(2) <= control_reg(CREG_IO)(CREG_LED2_BIT);

    -- OLED Display
    oled_select(2 downto 1) <= control_reg(CREG_OLED_CTR)(1 downto 0);
    oled_select(0) <= oled_select0;

    display_in_comb : process( 
        oled_select,
        pc_fetched, 
        instruction_fetched,
        control_reg(CREG_OLED_DATA),
        state_dbg_sig
    ) is 
        variable index : integer;
    begin
        index := to_integer(unsigned(oled_select));
        case( index ) is
            when 0 =>
                display_in <= std_logic_vector(pc_fetched);
            when 1 =>
                display_in <= instruction_fetched;
            when 2 =>
                display_in(2 downto 0) <= state_dbg_sig;
                display_in(31 downto 3) <= (others => '0');
            when 3 =>
                display_in <= control_reg(CREG_OLED_DATA);
            when others =>
                display_in <= (others => '0');
        end case ;
    end process ; -- display_in_comb

    ------------------- Control Unit -------------------
    process(clk, res, run) begin
        if(res = '0') then
            state <= idle;
        elsif(rising_edge(clk)) then
            --Next state and control signals for next state
            if(run = '1') then
                case state is
                    when idle =>
                        state <= fetch;
                    when fetch =>
                        state <= decode;
                    when decode =>
                        state <= execute;
                    when execute =>
                        state <= memory_writeback;               
                    when memory_writeback =>
                        if AXI_stall = '0' then
                            state <= fetch;
                        end if ;
                end case;
            else
                state <= state;
            end if;
        end if;
    end process;

    rd_addr_pro : process( clk, res ) begin
        if(res = '0') then
            rd_addr_out_reg <= (others => '0');
            op_class_reg <= (others => '0');
            mem_opcode_reg <= (others => '0');
        elsif(rising_edge(clk)) then 
            case( is_axi_load ) is
                when '0' =>
                    if state = execute and op_class_executed = "00100" and mem_wb_en_out.en_AXI = '1' then 
                        rd_addr_out_reg <= rd_addr_executed;
                        op_class_reg <= op_class_executed;
                        mem_opcode_reg <= mem_opcode_executed;
                        is_axi_load <= '1';
                    end if ;
                when '1' =>
                    if AXI_stall = '0' then
                        is_axi_load <= '0';
                    end if ;
                when others =>
                    is_axi_load <= '0';
            end case ;
        end if;
    end process ; -- rd_addr_pro

    rd_addr_in_decode   <= rd_addr_in           when is_axi_load = '0' else rd_addr_out_reg;
    mem_wb_op_class     <= op_class_executed    when is_axi_load = '0' else op_class_reg;
    mem_wb_mem_opcode   <= mem_opcode_executed  when is_axi_load = '0' else mem_opcode_reg;

    ena_mealy : process( state, AXI_stall, run, op_class_decoded ) begin
        if run = '1' then
            case state is
                when idle =>
                    pc_load <= '1';
                    mem_we <= '0';
                    mem_ena <= '0';
                    regFile_we <= '0';
                when execute =>
                    pc_load <= '1';
                    case (op_class_decoded) is
                        when "10000" => --OP
                            regFile_we <= '1';
                        when "01000" => --Store
                            mem_we <= '1';
                            mem_ena <= '1';
                        when "00100" => --Load
                            mem_ena <= '1';
                            regFile_we <= '0';
                        when "00001" => --Jump 
                            regFile_we <= '1';   
                        when others =>
                            regFile_we <= '0';
                            mem_we <= '0';
                            mem_ena <= '0';                                   
                    end case;
                when memory_writeback => 
                    if AXI_stall = '0' then
                        case (op_class_decoded) is
                            when "10000" => --OP
                                regFile_we <= '1';
                            when "01000" => --Store
                                mem_we <= '1';
                                mem_ena <= '1';
                            when "00100" => --Load
                                mem_ena <= '0';
                                regFile_we <= '1';
                            when "00001" => --Jump 
                                regFile_we <= '1';   
                            when others =>
                                regFile_we <= '0';
                                mem_we <= '0';
                                mem_ena <= '0';                                   
                        end case;
                        if is_axi_load = '1' then
                            regFile_we <= '1';
                        end if;
                    elsif AXI_stall = '1' then
                        pc_load <= '0';
                        regFile_we <= '0';
                        mem_we <= '0';
                        mem_ena <= '0';                        
                    end if ;
                when others => 
                    pc_load <= '0';
                    regFile_we <= '0';
                    mem_we <= '0';  
                    mem_ena <= '0';
            end case ;
        else
            pc_load <= '0';
            regFile_we <= '0';
            mem_we <= '0';  
            mem_ena <= '0';
        end if ;
    end process ; -- ena_mealy

    -- Alive LED / run_out
    blink_counter_pro : process( clk, res) is
        constant MAX : unsigned(RUN_BLINK_COUNTER_SIZE-1 downto 0) := (others => '1');
    begin
        if(res = '0') then
            blink_counter <= (others => '0');
            alive_led <= '0';
        elsif rising_edge(clk) then
            if  run = '1' then
                if blink_counter = MAX then
                    blink_counter <= (others => '0');
                else
                    blink_counter <= blink_counter + 1;
                end if;
                if(blink_counter = MAX) then
                    alive_led <= not alive_led;
                end if;
            else 
                blink_counter <= (others => '0');
                alive_led <= '0';
            end if;
        end if;            
    end process ; -- blink_counter_pro

    run_out <= alive_led;

end Behavioral;
