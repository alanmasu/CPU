`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 04:30:41 PM
// Design Name: 
// Module Name: test_CPU_AXI_recursive
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define BD_INST_NAME test_design_axi_recursive_i
`define BD_WRAPPER test_design_axi_recursive_wrapper

// import types_pkg::*;
// import constant_package::*;

// Import the AXI VIP Package
import axi_vip_pkg::*;
import test_design_axi_recursive_axi_vip_0_0_pkg::*;
import test_design_axi_recursive_axi_vip_1_0_pkg::*;

module test_CPU_AXI_recursive();
  `include "testUtilities.svh" 

  bit                                     clock = 1;
  bit                                     clock100MHz = 1;
  bit                                     reset;
  bit                                     run = 0;
  wire                                    aliveLed;
  wire [31:0]                             GPIO = 'z;
  logic [31:0]                            GPIO_sig = '0;
  bit  [4:0]                              BTNs = 5'b1;
  bit  [1:0]                              switches = 2'b1;

  wire                                    [2:0] LEDs;
  wire                                    [2:0] state_dbg;
  logic                                   oled_select0 = 1'b0;

  //I2C
  wire SDA;
  wire SCL;

  // AXI VIP
  // Passthrough VIP
  axi_transaction                         rd_transaction;   
  axi_monitor_transaction                 slv_monitor_transaction;  
  axi_monitor_transaction                 slave_moniter_transaction_queue[$];  
  xil_axi_uint                            slave_moniter_transaction_queue_size =0;  
  xil_axi_uint                            slv_agent_verbosity = 0;  
  test_design_axi_recursive_axi_vip_1_0_passthrough_mem_t       slv_agent_1;

  // Master VIP
  axi_transaction                         wr_transaction;   
  xil_axi_uint                            mst_agent_verbosity = 0;  
  xil_axi_uint                            mtestID;  
  xil_axi_ulong                           mtestADDR;  
  xil_axi_len_t                           mtestBurstLength;  
  xil_axi_size_t                          mtestDataSize;   
  xil_axi_burst_t                         mtestBurstType;   
  xil_axi_lock_t                          mtestLOCK;  
  xil_axi_cache_t                         mtestCacheType = 0;  
  xil_axi_prot_t                          mtestProtectionType = 3'b000;  
  xil_axi_region_t                        mtestRegion = 4'b000;  
  xil_axi_qos_t                           mtestQOS = 4'b000; 
  xil_axi_resp_t                          mtestBresp;  
  xil_axi_resp_t[255:0]                   mtestRresp;  
  bit [63:0]                              mtestWDataL; 
  bit [63:0]                              mtestRDataL; 
  test_design_axi_recursive_axi_vip_0_0_mst_t           mst_agent_0;

  `BD_WRAPPER DUT(
    .reset_0(reset),
    .clk_in1_0(clock), 
    .clk_100MHz_0(clock100MHz),
    .run_in_0(run),
    .GPIO_0(GPIO),
    .run_out_0(aliveLed),
    .btn_up_0     (BTNs[0]),
    .btn_down_0   (BTNs[1]),
    .btn_left_0   (BTNs[2]),
    .btn_right_0  (BTNs[3]),
    .btn_center_0 (BTNs[4]),
    .switches_0   (switches),
    .leds_0(LEDs),
    .state_dbg_0(state_dbg),
    .oled_select0_0(oled_select0),
    .SDA_0(SDA),
    .SCL_0(SCL)
  ); 

  always begin
    clock <= 1'b1;
    #5ns;
    clock <= 1'b0;
    #5ns;
  end
  
  // Configure the PassThrough VIP
  initial begin
    slv_agent_1 = new("PassThrough VIP", test_CPU_AXI_recursive.DUT.test_design_axi_recursive_i.axi_vip_1.inst.IF);
    slv_agent_1.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);
    slv_agent_1.set_agent_tag("Slave VIP");
    slv_agent_1.set_verbosity(slv_agent_verbosity);
    slv_agent_1.start_monitor();
  end

  // Configure the Master VIP
  initial begin
    mst_agent_0 = new("Master VIP", test_CPU_AXI_recursive.DUT.test_design_axi_recursive_i.axi_vip_0.inst.IF);
    mst_agent_0.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE); 
    mst_agent_0.set_agent_tag("Master VIP"); 
    mst_agent_0.set_verbosity(mst_agent_verbosity); 
    mst_agent_0.start_master();
    mtestADDR = 32'h40010000;
    @(posedge reset);
    mst_agent_0.AXI4LITE_READ_BURST( 
      mtestADDR, 
      mtestProtectionType, 
      mtestRDataL, 
      mtestRresp 
    );
    $finish;

  end

  initial begin
    reset = 0;
    #200;
    reset = 1;
  end

  task automatic axi4Lite_read(input xil_axi_ulong addr, input xil_axi_prot_t prot, output bit [63:0] data, output xil_axi_resp_t resp);
    begin
      mtestADDR = addr;
      mst_agent_0.AXI4LITE_READ_BURST( 
        addr, 
        prot, 
        data, 
        resp 
      );
    end
  endtask
    

  initial begin
    @(posedge reset);
    #1;
    mtestADDR = 32'h40001000; 
    mtestWDataL[31:0] = 32'b11;   
    mst_agent_0.AXI4LITE_WRITE_BURST( 
      mtestADDR, 
      mtestProtectionType, 
      mtestWDataL, 
      mtestBresp 
    ); 
    #10;
    $finish;
  end


endmodule
