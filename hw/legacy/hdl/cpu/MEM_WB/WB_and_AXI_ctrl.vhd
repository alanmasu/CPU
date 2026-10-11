----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/09/2023 03:54:55 PM
-- Design Name: 
-- Module Name: WB_and_AXI_ctrl - Behavioral
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

entity WB_and_AXI_ctrl is
    generic (
		-- Users to add parameters here
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		C_M_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		C_M_TRANSACTIONS_NUM	: integer	:= 4
	);
    Port ( 
        clk, res, jmp, we_in, en_in: in STD_LOGIC;
        mem_opcode : in STD_LOGIC_VECTOR(2 downto 0);
        op_class : in STD_LOGIC_VECTOR (4 downto 0);
        npc_in : in UNSIGNED (31 downto 0);
        alu_resoult : in STD_LOGIC_VECTOR (31 downto 0);
        alu_resoult_reg : in STD_LOGIC_VECTOR (31 downto 0);
        rs2_value : in STD_LOGIC_VECTOR (31 downto 0);
        rd_addr_in : in STD_LOGIC_VECTOR (4 downto 0);
        rd_value : out STD_LOGIC_VECTOR (31 downto 0);
        rd_addr_out : out STD_LOGIC_VECTOR (4 downto 0);
        pc_out : out STD_LOGIC_VECTOR (11 downto 0);
        
        --AXI name
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		M_AXI_AWVALID	: out std_logic;
		M_AXI_AWREADY	: in std_logic;
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		M_AXI_WVALID	: out std_logic;
		M_AXI_WREADY	: in std_logic;
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		M_AXI_BVALID	: in std_logic;
		M_AXI_BREADY	: out std_logic;
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		M_AXI_ARVALID	: out std_logic;
		M_AXI_ARREADY	: in std_logic;
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		M_AXI_RVALID	: in std_logic;
		M_AXI_RREADY	: out std_logic;
		
        --BRAM Interface:
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end WB_and_AXI_ctrl;

architecture Behavioral of WB_and_AXI_ctrl is
    signal stall : std_logic := '0';
    signal en_int : std_logic_vector (0 downto 0);
    signal we_int : std_logic_vector(3 downto 0);
    signal addr, data_in,read_data : std_logic_vector(31 downto 0);
    signal mem_wb_data_in : peripheral_data_t;
    
begin
    dut1 : entity work.AXI_memory_controller
    port map(
        en => en_int(0), 
        we => we_int,
        address => addr,
        write_data => data_in,
        read_data => read_data,
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
    
    dut2: entity work.memory_write_back
    port map(
        clk => clk,
        res => res,
        jmp => jmp,
        we_in => we_in,
        en_in => en_in,
        mem_opcode => mem_opcode,
        op_class => op_class,
        rs2_value => rs2_value,
        npc_in => npc_in,
        alu_resoult => alu_resoult,
        alu_resoult_reg => alu_resoult_reg,
        rd_addr_in => rd_addr_in,
        rd_value => rd_value,
        rd_addr_out => rd_addr_out,
        pc_out => pc_out,
        --PERIPHERAL interface
        en_out => en_int,
        we_out => we_int,
		address_out => addr,
		d_out => data_in,

        d_in => mem_wb_data_in,

        --BRAM interface
        clkb => clk,
        enb => enb,
        web => web,
        addrb => addrb,
        dinb => dinb,
		doutb => doutb
    );
    
    
    mem_wb_data_in.AXI_data <= read_data;



end Behavioral;
