`timescale 1ns / 1ps

//Configuration current bd names
//`define BD_NAME test_design
`define BD_INST_NAME test_design_i
`define BD_WRAPPER test_design_wrapper

import axi_vip_pkg::*;
import test_design_axi_vip_0_3_pkg::*;
import test_design_axi_vip_1_0_pkg::*;

import types_pkg::*;

module test_CPU_wh_AXI();
//slave vip agent

  axi_transaction                         rd_transaction;   
  axi_monitor_transaction                 slv_monitor_transaction;  
  axi_monitor_transaction                 slave_moniter_transaction_queue[$];  
  xil_axi_uint                            slave_moniter_transaction_queue_size =0;  
  xil_axi_uint                            slv_agent_verbosity = 0;  
  test_design_axi_vip_1_0_slv_mem_t       slv_agent_0;

  bit                                     clock = 1;
  bit                                     reset;
  wire [31:0]                             GPIO;

  logic on_programming = 1'b1;
   
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
  
  //Programm
  localparam logic [31:0] BASE_ADDR = 32'h40000000;
  // Data to be written
logic [31:0] data_array [] = '{
    32'hff000093,
    32'h00108113,
    32'h001101b3,
    32'h400121b7,
    32'hfe11ae23,
    32'hffc1a203,
    32'h00120863,
    32'h40001337,
    32'h00032023,
    32'h00028067,
    32'hff5ff2ef
};

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
    LOAD_PROGRAM();
    S_AXI_TEST();
    #200ns;
    //$finish;
  end

  //Load program
  task automatic LOAD_PROGRAM;
        integer i;
        begin
            #1
            mtestID = 0; 
            mtestBurstLength = 0; 
            mtestDataSize = xil_axi_size_t'(xil_clog2(32/8)); 
            mtestBurstType = XIL_AXI_BURST_TYPE_INCR;  
            mtestLOCK = XIL_AXI_ALOCK_NOLOCK;  
            mtestCacheType = 0;  
            mtestProtectionType = 0;  
            mtestRegion = 0; 
            mtestQOS = 0; 

            //Leggiamo la memoria
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

            #10;
            mtestWDataL[63:32] = 32'h0;
            mtestADDR[63:32] = 32'h0;
            for (int i = 0; i < data_array.size(); i++) begin
                mtestWDataL[31:0] = data_array[i];
                mtestADDR[31:0] = BASE_ADDR + i * 4;
                mst_agent_0.AXI4LITE_WRITE_BURST(
                    mtestADDR,
                    mtestProtectionType, 
                    mtestWDataL, 
                    mtestBresp 
                );
                // $display("Wrote data: %h to address: %h", data_array[i], BASE_ADDR + i * 4);
            end
            on_programming = 1'b0;
        end
    endtask

  //Signal for testing
  logic validating = 1'b0;
  integer test_n = 0;

  //Modificare questo task qui per il testbench
  //Segnali gerarchici
  ram_array regFile; 
  assign regFile = DUT.test_design_i.CPU_0.U0.instr_decode.register_file.mem_2;

  logic [31:0] instruction_tb;
  assign instruction_tb = DUT.test_design_i.CPU_0.U0.instr_fetch.instruction;
  
  wire run;
  assign run = DUT.test_design_i.CPU_0.U0.run;

  state_type state_tb;
  assign state_tb = DUT.test_design_i.CPU_0.U0.state;

  logic cpu_run;
  assign cpu_run = DUT.test_design_i.CPU_0.U0.run;

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

      //Imposto la CPU in RUN
      mtestADDR = 32'h40001000; 
      mtestWDataL[31:0] = 32'b1;   
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );  

      //Istruzione no. 1 
      test_n = 1;

      wait (state_tb == fetch);
      wait (state_tb == fetch); //wait until the CPU has executed the first instruction
      #1;                       //wait to be after the rising edge of the clock
      
      validating = 1'b1;
      //Check instruction   ADDI x1, x0, -16
      if(regFile[0] == -32'd16) begin
        $display("Test #1: OK");
      end else begin
        $display("Test #1: FAILED");
      end
      #1;                      
      validating = 1'b0;
      #9;

      test_n = 2;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       ADDI x2, x1, 1
      if(regFile[1] == -32'd15) begin 
        $display("Test #2: OK");
      end else begin
        $display("Test #2: FAILED -> regFile[2] was %h", regFile[1]);
      end
      #1;
      validating = 1'b0;
      #9;
      
      test_n = 3;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       ADD x3, x2, x1
      if(regFile[2] == -32'd31) begin 
        $display("Test #3: OK");
      end else begin
        $display("Test #3: FAILED -> regFile[3] was %h", regFile[2]);
      end
      #1;
      validating = 1'b0;
      #9;

      test_n = 4;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LUI x3, 0x40012
      if(regFile[2] == 32'h40012000) begin 
        $display("Test #4: OK");
      end else begin
        $display("Test #4: FAILED -> regFile[3] was %h", regFile[2]);
      end
      #1;
      #9;
      validating = 1'b0;

      test_n = 5;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      // validating = 1'b1;
      // //Check instruction       SW x1, -4(x3)
      // mtestADDR = 32'h40012000 - 4;
      // mst_agent_0.AXI4LITE_READ_BURST( 
      //   mtestADDR, 
      //   mtestProtectionType, 
      //   mtestRDataL, 
      //   mtestRresp 
      // );
      // if(mtestRDataL[31:0] == -32'd16) begin 
      //   $display("Test #5: OK");
      // end else begin
      //   $display("Test #5: FAILED");
      // end
      #1;
      validating = 1'b0;
      #9;

      test_n = 6;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LW x4, -4(x3)
      if(regFile[3] == -32'd16) begin 
        $display("Test #6: OK");
      end else begin
        $display("Test #6: FAILED -> regFile[4] was %h", regFile[3]);
      end
      #1;
      validating = 1'b0;
      #9;

      test_n = 7;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       BEQ x4, x1, L1
      if(instruction_tb == 32'hff5ff2ef) begin 
        $display("Test #7: OK");
      end else begin
        $display("Test #7: FAILED -> instruction_tb was %h", instruction_tb);
      end
      #1;
      validating = 1'b0;
      #9;

      test_n = 8;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       JAL x5, L2
      if(regFile[4] == 32'h4000002c) begin 
        $display("Test #8a: OK");
      end else begin
        $display("Test #8a: FAILED -> regFile[5] was %h", regFile[4]);
      end
      
      if(instruction_tb == 32'h40001337) begin 
        $display("Test #8b: OK");
      end else begin
        $display("Test #8b: FAILED -> instruction_tb was %h", instruction_tb);
      end
      #1;
      validating = 1'b0;
      #9;

      test_n = 9;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LUI x6, 0x40001
      if(regFile[5] == 32'h40001000) begin 
        $display("Test #9: OK");
      end else begin
        $display("Test #9: FAILED -> regFile[6] was %h", regFile[6]);
      end
      #1;
      validating = 1'b0;
      #9;

      // wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      // #1;                       //wait to be after the rising edge of the clock
      // validating = 1'b1;
      // test_n++;
      // // Check instruction       SW x0, 0(x6) //Stop the CPU by setting RUN to 0




    end 
  endtask  

//  always @(instruction_tb) begin
//    $display("%h", instruction_tb);
//  end
  int istruction_count = 0;

  always @(state_tb, reset) begin
    if (reset == 0) begin
      istruction_count = 0;
    end else if (state_tb == fetch) begin
      istruction_count ++;
    end
  end

endmodule
