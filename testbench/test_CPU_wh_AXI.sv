`timescale 1ns / 1ps

//Configuration current bd names
//`define BD_NAME test_design
`define BD_INST_NAME test_design_i
`define BD_WRAPPER test_design_wrapper

import axi_vip_pkg::*;
import test_design_axi_vip_0_3_pkg::*;
import test_design_axi_vip_1_0_pkg::*;

module test_CPU_wh_AXI();
//slave vip agent

  axi_transaction                         rd_transaction;   
  axi_monitor_transaction                 slv_monitor_transaction;  
  axi_monitor_transaction                 slave_moniter_transaction_queue[$];  
  xil_axi_uint                            slave_moniter_transaction_queue_size =0;  
  xil_axi_uint                            slv_agent_verbosity = 0;  
  test_design_axi_vip_1_0_slv_mem_t       slv_agent_0;

  bit                                     clock;
  bit                                     reset;
  wire [31:0]                             GPIO;

   
//Master vip agent
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
  test_design_axi_vip_0_3_mst_t           mst_agent_0;

  `BD_WRAPPER DUT(
    .reset_rtl(reset),
    .sys_clock(clock), 
    .GPIO(GPIO)
  ); 
  
  // Setup VIP agents
  initial begin
    //Slave vip agent initialization
    slv_agent_0 = new("slave vip agent",test_CPU_wh_AXI.DUT.test_design_i.axi_vip_1.inst.IF);
    slv_agent_0.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);
    slv_agent_0.set_agent_tag("Slave VIP");
    slv_agent_0.set_verbosity(slv_agent_verbosity);
    slv_agent_0.start_slave();
    
    //Master vip agent initialization
    mst_agent_0 = new("master vip agent",test_CPU_wh_AXI.DUT.test_design_i.axi_vip_0.inst.IF);//ms  
    mst_agent_0.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE); 
    mst_agent_0.set_agent_tag("Master VIP"); 
    mst_agent_0.set_verbosity(mst_agent_verbosity); 
    mst_agent_0.start_master(); 
    $timeformat (-12, 1, " ps", 1);
  end
  
  //Slave monitor agent
  initial begin
    #1;
    forever begin
      slv_agent_0.monitor.item_collected_port.get(slv_monitor_transaction);
      slave_moniter_transaction_queue.push_back(slv_monitor_transaction);
      slave_moniter_transaction_queue_size++;
    end
  end

  //Reset
  initial begin
    reset <= 1'b0;
    #10ns;
    reset <= 1'b1;
    repeat (5) @(negedge clock); 
  end

  //Clock generation
  always #5 clock <= ~clock;

  //Testbench
  initial begin
    S_AXI_TEST ( );
    #200ns;
    //$finish;
  end

  //Modificare questo task qui per il testbench
  task automatic S_AXI_TEST;  
    integer i;
    begin   
      #1; 
      $display("Init testing of IP, simulating a ZynqPS to write & read memory trougth the IP "); 
      mtestID = 0; 
      mtestBurstLength = 0; 
      mtestDataSize = xil_axi_size_t'(xil_clog2(32/8)); 
      mtestBurstType = XIL_AXI_BURST_TYPE_INCR;  
      mtestLOCK = XIL_AXI_ALOCK_NOLOCK;  
      mtestCacheType = 0;  
      mtestProtectionType = 0;  
      mtestRegion = 0; 
      mtestQOS = 0; 

      //Lettura in memoria
      mtestADDR = 32'h40000000;  
      mst_agent_0.AXI4LITE_READ_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestRDataL, 
        mtestRresp 
      );
      if (mtestRDataL[31:0] == 32'h7ff00113) begin
        $display("Test READ Instruction Memory: OK");
      end else begin
        $display("Test READ Instruction Memory: FAILED");
      end

      //Reading Control Register
      mtestADDR = 32'h40001000; 
      // mtestWDataL[31:0] = 32'd02;    
      mst_agent_0.AXI4LITE_READ_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestRDataL, 
        mtestRresp 
      );
      if (mtestRDataL[31:0] == '0) begin
        $display("Test READ Control Register: OK");
      end else begin
        $display("Test READ Control Register: FAILED");
      end
      
      //Scrittura in memoria
      //Imposto la prima cella della memoria istruzioni
      mtestADDR = 32'h40000000; 
      mtestWDataL[31:0] = '0;   
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );  
      mst_agent_0.AXI4LITE_READ_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestRDataL, 
        mtestRresp 
      );
      if (mtestRDataL[31:0] == '0) begin
        $display("Test WRITE Instruction Memory: OK");
      end else begin
        $display("Test WRITE Instruction Memory: FAILED");
      end
      mtestWDataL[31:0] = 32'h7ff00113;   
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      ); 

      //Imposto la prima cella della memoria istruzioni
      mtestADDR = 32'h40001000; 
      mtestWDataL[31:0] = 32'b1;   
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );  
      mst_agent_0.AXI4LITE_READ_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestRDataL, 
        mtestRresp 
      );
      if (mtestRDataL[31:0] == 32'b1) begin
        $display("Test WRITE Control Register: OK");
      end else begin
        $display("Test WRITE Control Register: FAILED");
      end
      // $display("fine impostazione indirizzo");
      // $display("Imposto i dati nel slv_reg_3");
      // mtestADDR = 32'd12; 
      // mtestWDataL[31:0] = 32'd17;    
      // mst_agent_0.AXI4LITE_WRITE_BURST( 
      //   mtestADDR, 
      //   mtestProtectionType, 
      //   mtestWDataL, 
      //   mtestBresp 
      // );  
      // $display("fine scrittura dati");
      // $display("start writing at 0x1028CC");
      // mtestADDR = 32'd00; 
      // mtestWDataL[31:0] = 32'd01;   
      // mst_agent_0.AXI4LITE_WRITE_BURST( 
      //   mtestADDR, 
      //   mtestProtectionType, 
      //   mtestWDataL, 
      //   mtestBresp 
      // );  

      // $display("Reading BRESP");
      // do begin
      //   mtestADDR = 32'd20; 
      //   mst_agent_0.AXI4LITE_READ_BURST( 
      //     mtestADDR, 
      //     mtestProtectionType, 
      //     mtestRDataL, 
      //     mtestRresp 
      //   );
      // end
      // while (mtestRDataL[2] != 1);

          
      
    end 
  endtask  

endmodule
