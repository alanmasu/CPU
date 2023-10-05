----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 13:01:00
-- Design Name: 
-- Module Name: instruction_fetch - Behavioral
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

entity instruction_fetch is
    Port ( 
        pc_in : in STD_LOGIC_VECTOR (11 downto 0);
        pc_load,  clk, res : in STD_LOGIC;
        instruction_in : in STD_LOGIC_VECTOR(31 downto 0);
        wea : in STD_LOGIC_VECTOR(0 downto 0);
        instruction : out STD_LOGIC_VECTOR(31 downto 0);
        npc : out UNSIGNED(11 downto 0);
        pc: buffer UNSIGNED(11 downto 0);

        --S_AXI interface
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
        s_axi_rready : IN STD_LOGIC
    );
end instruction_fetch;

architecture Behavioral of instruction_fetch is
    COMPONENT instruction_mem
    PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;
    
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

    --BRAM Controller
    signal mem_out: STD_LOGIC_VECTOR(31 downto 0);
    signal bram_rst_a : STD_LOGIC;
    signal bram_clk_a : STD_LOGIC;
    signal bram_en_a : STD_LOGIC;
    signal bram_we_a : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal bram_addr_a : STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal bram_wrdata_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal bram_rddata_a : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- --BRAM
    -- signal clka : STD_LOGIC;
    -- signal ena : STD_LOGIC;
    -- signal wea : STD_LOGIC_VECTOR(3 DOWNTO 0);
    -- signal addra : STD_LOGIC_VECTOR(9 DOWNTO 0);
    -- signal dina : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- signal douta : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- signal clkb : STD_LOGIC;
    -- signal enb : STD_LOGIC;
    -- signal web : STD_LOGIC_VECTOR(3 DOWNTO 0);
    -- signal addrb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    -- signal dinb : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- signal doutb : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
    axi_slave: axi_bram_ctrl_0
    PORT MAP (
        s_axi_aclk => s_axi_aclk,
        s_axi_aresetn => s_axi_aresetn,
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
  
    memoria_istruzioni: instruction_mem
    PORT MAP (
        clka => clk,
        ena => pc_load,
        wea => (others => '0'),
        addra => std_logic_vector(pc_in(11 downto 2)),
        dina => instruction_in,
        douta => mem_out,
        clkb => bram_clk_a,
        enb => bram_en_a,
        web => bram_we_a,
        addrb => bram_addr_a(11 downto 2),
        dinb => bram_wrdata_a,
        doutb => bram_rddata_a
    ); 
    -- memoria_istruzioni : instruction_mem
    -- PORT MAP (
    --     clka => clka,
    --     ena => ena,
    --     wea => wea,
    --     addra => addra,
    --     dina => dina,
    --     douta => douta,
    --     clkb => clkb,
    --     enb => enb,
    --     web => web,
    --     addrb => addrb,
    --     dinb => dinb,
    --     doutb => doutb
    -- );

    counter_process : process(clk, res) begin
        if res = '0' then
            pc  <= (others => '0');
            npc <= (others => '0');
        elsif rising_edge(clk) then
            if pc_load = '1' then
                pc <= unsigned(pc_in);
                npc <= unsigned(pc_in) + 4;
            end if;
        end if;
    end process;
    
    register_process: process( clk, res) begin
        if res = '0' then
            instruction <= (others => '0');
        elsif rising_edge(clk) then
            -- if pc_load = '1' then
            --     instruction <= mem_out;
            -- end if;
            instruction <= mem_out;
        end if;
    end process;
    -- instruction <= mem_out;
end Behavioral;