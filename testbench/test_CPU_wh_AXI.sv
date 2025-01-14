`timescale 1ns / 1ps

//Configuration current bd names
//`define BD_NAME test_design
`define BD_INST_NAME test_design_i
`define BD_WRAPPER test_design_wrapper

import axi_vip_pkg::*;
import test_design_axi_vip_0_3_pkg::*;
import test_design_axi_vip_1_0_pkg::*;

import types_pkg::*;
// import constant_package::*;

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
  bit                                     run = 1;
  wire                                    aliveLed;
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
    .run_in_0(run),
    .GPIO_0(GPIO),
    .run_out_0(aliveLed)
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
    32'hff5ff2ef,
    32'h00004397,
    32'hfe742c23,
    32'hff840413,
    32'h400204b7,
    32'h00100513,
    32'h00a4a223,
    32'h00a4a423,
    32'h0004a583,
    32'h40000637,
    32'h00c62023,
    32'h00062683
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

  //AXI Check process
  typedef struct{
    integer test_n;
    logic [31:0] addr;
    logic [31:0] assert_data;
    logic [31:0] readed_data;
    logic resoult;
    string name = "";
    string messageOnPass = "OK";
    string messageOnFail;
  }check_record_t;

  check_record_t check_queue[$];
  check_record_t  checked_queue[$];
  integer check_queue_size = 0;
  integer checked_queue_size = 0;

  task checkQueuePush(
    input integer test_n, 
    input logic [31:0] addr,
    input logic [31:0] assert_data, 
    input string msgPass, 
    input string msgFail, 
    input string name = ""
  );
  begin
    check_queue.push_back('{test_n:test_n, addr:addr, assert_data:assert_data, readed_data:0, resoult:0, name:name, messageOnPass:msgPass, messageOnFail:msgFail});
    check_queue_size++;
  end;
  endtask;

  task automatic doQueuedTests;
    logic testPassed = 0;
    string message;
    begin
      if (check_queue_size > 0) begin
        for (int i = 0; i < check_queue_size; i++) begin
          check_record_t check_record = check_queue.pop_front();
          check_queue_size--;
          mtestADDR = check_record.addr;
          mst_agent_0.AXI4LITE_READ_BURST( 
            mtestADDR, 
            mtestProtectionType, 
            mtestRDataL, 
            mtestRresp 
          );
          check_record.readed_data = mtestRDataL[31:0];
          if (check_record.readed_data == check_record.assert_data) begin
            check_record.resoult = 1;
            message = check_record.messageOnPass;
          end else begin
            check_record.resoult = 0;
            message = check_record.messageOnFail;
          end
          addToLog(check_record.test_n, check_record.resoult, message, check_record.readed_data, check_record.name);
          checked_queue.push_back(check_record);
          checked_queue_size++;
        end
      end
    end
  endtask

  //Test Logging
  typedef struct {
    integer test_n;
    string name = "";
    logic passed;
    string message;
    logic [31:0] actual;
  } test_resoult_t;

  test_resoult_t test_resoult_queue[$];
  integer test_resoult_queue_size = 0;

  function automatic void bubbleSort(ref test_resoult_t array[$]);
    automatic int n = array.size();
    for (int i = 0; i < n-1; i++) begin
      for (int j = 0; j < n-i-1; j++) begin
        if (array[j].test_n > array[j+1].test_n) begin
          //Swap
          test_resoult_t tmp = array[j];
          array[j] = array[j+1];
          array[j+1] = tmp;
          // swap(array[j], array[j+1]);
        end
      end
    end
  endfunction

  task automatic addToLog(input integer test_n, input logic passed, input string message, input logic [31:0] actual, input string name = "");
    begin
      test_resoult_queue.push_back('{test_n:test_n, name:name, passed:passed, message:message, actual:actual});
      test_resoult_queue_size++;
    end
  endtask;
    
  test_resoult_t resoult;
  task automatic printLog;
    begin
      bubbleSort(test_resoult_queue);
      if (test_resoult_queue.size() > 0) begin
        for (int i = test_resoult_queue.size(); i > 0; i--) begin
          resoult = test_resoult_queue.pop_front();
          test_resoult_queue_size--;
          if(resoult.name == "") begin
            if (resoult.passed == 1) begin
              $display("Test #%0d: %s", resoult.test_n, resoult.message);
            end else begin
              $display("Test #%0d: %s %h", resoult.test_n, resoult.message, resoult.actual);
            end
          end else begin
            if (resoult.passed == 1) begin
              $display("Test %s: %s", resoult.name, resoult.message);
            end else begin
              $display("Test %s: %s %h", resoult.name, resoult.message, resoult.actual);
            end
          end
        end
      end
    end
  endtask;


  //Testbench
  initial begin
    LOAD_PROGRAM(data_array, BASE_ADDR);
    S_AXI_TEST();
    doQueuedTests();
    printLog();

    #200ns;
    $finish;
  end

  //Load program
  task automatic LOAD_PROGRAM (input logic [31:0] programma[], input [31:0] BASE_ADDR);
        integer i;
        logic testPassed = 0;
        string message;
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
            if (mtestRDataL[31:0] == '0) begin
                testPassed = 1;
                message = "OK";
            end else begin
                testPassed = 0;
                message = "FAILED -> Instruction was";
            end
            addToLog(0, testPassed, message, mtestRDataL[31:0], "READ Instruction Memory");
            #10;
            mtestWDataL[63:32] = 32'h0;
            mtestADDR[63:32] = 32'h0;
            for (int i = 0; i < programma.size(); i++) begin
                mtestWDataL[31:0] = programma[i];
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
  
  // CPU State
  state_type state_tb;
  assign state_tb = DUT.test_design_i.CPU_0.U0.state;
  wire run_tb;
  assign run_tb = DUT.test_design_i.CPU_0.U0.run;
  wire res_tb;
  // assign res_tb = DUT.test_design_i.CPU_0.U0.res;

  //CPU Control Register
  control_reg_t control_reg_tb;
  assign control_reg_tb = DUT.test_design_i.CPU_0.U0.control_reg;

  //GPIO Registes
  logic [31:0] GPIO_dir_tb;
  assign GPIO_dir_tb = DUT.test_design_i.CPU_0.U0.gpio_driver.GPIO_dir;
  logic [31:0] GPIO_reg_tb;
  assign GPIO_reg_tb = DUT.test_design_i.CPU_0.U0.gpio_driver.GPIO_reg;
  logic [31:0] GPIO_state_tb;
  assign GPIO_state_tb = DUT.test_design_i.CPU_0.U0.gpio_driver.GPIO_state;
  wire GPIO1;
  assign GPIO1 = GPIO[0];

  task automatic S_AXI_TEST;  
    integer i;
    logic testPassed = 0;
    string message;
    time t0;
    time t1;
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

      //Imposto la CPU in RUN and NON in RESET
      mtestADDR = 32'h40001000; 
      mtestWDataL[31:0] = 32'b11;   
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
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[1] was";
      end
      addToLog(test_n, testPassed, message, regFile[0]);
      #1;                      
      validating = 1'b0;
      #9;

      test_n = 2;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       ADDI x2, x1, 1
      if(regFile[1] == -32'd15) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[2] was";
      end
      addToLog(test_n, testPassed, message, regFile[1]);
      #1;
      validating = 1'b0;
      #9;
      
      test_n = 3;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       ADD x3, x2, x1
      if(regFile[2] == -32'd31) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[3] was";
      end
      addToLog(test_n, testPassed, message, regFile[2]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 4;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LUI x3, 0x40012
      if(regFile[2] == 32'h40012000) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[3] was";
      end
      addToLog(test_n, testPassed, message, regFile[2]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 5;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       SW x1, -4(x3)
      checkQueuePush(test_n, 32'h40011FFC, -32'd16, "OK", "FAILED -> Mem[0x40011FFC] was");
      #1;
      validating = 1'b0;
      #9;

      test_n = 6;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LW x4, -4(x3)
      if(regFile[3] == -32'd16) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[4] was";
      end
      addToLog(test_n, testPassed, message, regFile[3]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 7;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       BEQ x4, x1, L1
      if(instruction_tb == 32'hff5ff2ef) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> instruction_tb was";
      end
      addToLog(test_n, testPassed, message, instruction_tb);
      #1;
      validating = 1'b0;
      #9;

      test_n = 8;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       JAL x5, L2
      if(regFile[4] == 32'h4000002c) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[5] was";
      end
      addToLog(test_n, testPassed, message, regFile[4], "#8a");
      
      if(instruction_tb == 32'h40001337) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> instruction_tb was";
      end
      addToLog(test_n, testPassed, message, instruction_tb, "#8b");
      #1;
      validating = 1'b0;
      #9;

      test_n = 9;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LUI x6, 0x40001
      if(regFile[5] == 32'h40001000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[6] was";
      end
      addToLog(test_n, testPassed, message, regFile[5]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 10;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      test_n++;
      // Check instruction       SW x0, 0(x6) //Stop the CPU by setting RUN to 0
      #1;
      validating = 1'b0;
      #9;

      test_n = 11;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       jalr x0, 0(x5)
      if(instruction_tb == 32'h00004397) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> instruction_tb was";
      end
      addToLog(test_n, testPassed, message, instruction_tb);
      #1;
      validating = 1'b0;
      #9;

      test_n = 12;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       AUIPC x7, 0x4
      if(regFile[6] == 32'h4000402c) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[7] was";
      end
      addToLog(test_n, testPassed, message, regFile[6]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 13;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       sw x7, -8(x8)
      checkQueuePush(test_n, 32'h40011ff8, 32'h40004030, "OK", "FAILED -> Mem[0x40011FF8] was");
      #1;
      validating = 1'b0;
      #9;

      test_n = 14;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       ADDI x8, x8, -4
      if(regFile[7] == 32'h40011ff4) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[8] was";
      end
      addToLog(test_n, testPassed, message, regFile[7]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 15;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       lui x9, 0x40020
      if(regFile[8] == 32'h40020000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[9] was";
      end
      addToLog(test_n, testPassed, message, regFile[8]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 16;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       addi x10, x0, 1
      if(regFile[9] == 32'h1) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[10] was";
      end
      #1;
      validating = 1'b0;
      #9;

      test_n = 17;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       sw x10, 4(x9)
      // $display("Test #17: SKIPPED");
      if(GPIO_dir_tb[0] == 1) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> GPIO_dir_tb[0] was";
      end
      addToLog(test_n, testPassed, message, GPIO_dir_tb[0]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 18;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       sw x10, 8(x9)
      if(GPIO[0] == 32'h1) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> GPIO[0] was";
      end
      addToLog(test_n, testPassed, message, GPIO[0]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 19;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       lw x11, 0(x9)
      if(regFile[10] & 32'h1 == 32'h1) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[11] was";
      end
      addToLog(test_n, testPassed, message, regFile[10]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 20;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       lui x12, 0x40000
      if(regFile[11] == 32'h40000000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[12] was";
      end
      addToLog(test_n, testPassed, message, regFile[11]);
      #1;
      validating = 1'b0;
      #9;

      test_n = 21;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       sw x12, 0(x12)
      addToLog(test_n, 1, "SKIPPED", 1);
      #1;
      validating = 1'b0;
      #9;

      test_n = 22;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      addToLog(test_n, 1, "SKIPPED", 1);
      //Check instruction       lw x13, 0(x12)
      // if(regFile[12] == 32'h40000000) begin 
      //   $display("Test #22: OK");
      // end else begin
      //   $display("Test #22: FAILED -> regFile[13] was %h", regFile[12]);
      // end

      // $finish;
      test_n = 23;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction;
      run = 0;
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check run signal
      if(run_tb == 0) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> run_tb was";
      end
      #1;
      validating = 1'b0;
      addToLog(test_n, testPassed, message, run_tb);

      //Reset the CPU
      test_n = 24;
      validating = 1'bZ;
      mtestADDR = 32'h40001000;
      mtestWDataL[31:0] = '0;
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );
      validating = 1'b0;
      #10;
      validating = 1'b1;
      #1;
      addToLog(test_n, 1, $sformatf("SKIPPED -> You need to check if a LOW glitch is present on RES sig at %0t", $time), 0);
      // addToLog(test_n, testPassed, message, control_reg_tb[CREG_CTR][CREG_RES_BIT]);
      validating = 1'b0;

      //Sync whit clock
      @(clock);
      wait (clock == 1);

      validating = 1'b1;
      #1;
      test_n = 25;
      if(control_reg_tb[1] == 32'h40000000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> control_reg_tb[1] (aka RISC-V PC) was";
      end
      addToLog(test_n, testPassed, message, control_reg_tb[1]);
      validating = 1'b0;
      #9;
      
      // Start the CPU
      test_n = 26;
      run = 1;
      mtestADDR = 32'h40001000;
      mtestWDataL[31:0] = 32'b11;
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );
      validating = 1'b1;
      if(run_tb == 1) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> run_tb was";
      end
      #1
      validating = 1'b0;
      addToLog(test_n, testPassed, message, run_tb);

      test_n = 27;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check CREG_STATE == memory_writeback (aka stato precedente)
      if(control_reg_tb[2] == memory_writeback) begin // State 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> control_reg_tb was";
      end
      addToLog(test_n, testPassed, message, control_reg_tb[2], $sformatf("#%0da", test_n));

      if(control_reg_tb[3] == 32'h00108113) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> control_reg_tb[3] was";
      end
      addToLog(test_n, testPassed, message, control_reg_tb[3], $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      //chech run out signal
      test_n++;
      @(aliveLed);
      t0 = $time;
      @(aliveLed);
      t1 = $time;
      validating = 1'b1;
      if(t1 - t0 == 40) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> aliveLed period was";
      end
      addToLog(test_n, testPassed, message, t1 - t0);
      #1;
      validating = 1'b0;




      #1;
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
