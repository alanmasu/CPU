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
  bit [31:0]                              data_readed;
  bit [31:0]                              data_to_write;
  bit [3:0]                               strobe_to_write = 4'hF; //All strobes are set to 1

  bit                                     clock = 1;
  bit                                     clock100MHz = 1;
  bit                                     reset;
  bit                                     run = 1;
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
  wire [31:0] i2c_address_tb;
  wire i2c_rw_n_tb;
  wire [31:0] i2c_data_tb;
  wire [31:0] i2c_data_to_send_tb;

  logic on_programming = 1'b1;
  int istruction_count = 0;
   
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

  pullup(SDA);
  pullup(SCL);

  `BD_WRAPPER DUT(
    .reset_rtl(reset),
    .sys_clock(clock), 
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
    // .state_dbg_0(state_dbg),
    .oled_select0_0(oled_select0),
    .SDA_0(SDA),
    .SCL_0(SCL)
  ); 
  
  //I2C Slave
  slave_interface slave_tb (
    .i2c_scl(SCL),
    .i2c_sda(SDA),
    .res(reset),
    .i2c_address_tb(i2c_address_tb),
    .i2c_rw_n_tb(i2c_rw_n_tb),
    .i2c_data_tb(i2c_data_tb),
    .i2c_data_to_send(i2c_data_to_send_tb)
  );


  //Programm
  localparam logic [31:0] BASE_ADDR = 32'h40000000;
  // Data to be written
  logic [31:0] data_array [] = '{
    32'hff000093,
    32'h00108a13,
    32'h001a01b3,
    32'h400101b7,
    32'h0011a023,
    32'h0001a203,
    32'h00120a63,
    32'h40004337,
    32'h00200713,
    32'h00e32023,
    32'h00028067,
    32'hff1ff2ef,
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
    32'h00062683,
    32'h0000006f,
    32'h00112023,
    32'hfe212e23,
    32'hfe312c23,
    32'hfe412a23,
    32'hfe512823,
    32'hfe612623,
    32'hfe712423,
    32'hfe812223,
    32'hfe912023,
    32'hfca12e23,
    32'hfcb12c23,
    32'hfcc12a23,
    32'hfcd12823,
    32'hfce12623,
    32'hfcf12423,
    32'hfd012223,
    32'hfd112023,
    32'hfb212e23,
    32'hfb312c23,
    32'hfb412a23,
    32'hfb512823,
    32'hfb612623,
    32'hfb712423,
    32'hfb812223,
    32'hfb912023,
    32'hf9a12e23,
    32'hf9b12c23,
    32'hf9c12a23,
    32'hf9d12823,
    32'hf9e12623,
    32'hf9f12423,
    32'h00008067
  };

  logic [31:0] and_array [] = '{
    32'h40020337,
    32'h00032803,
    32'h03e87813,
    32'h0000006f
  };

logic [31:0] testI2C [] = '{
    32'h400202b7,
    32'h01028293,
    32'h05600313,
    32'h07600393,
    32'h00100e13,
    32'h00100e93,
    32'h400104b7,
    32'h19448493,
    32'h00628223,
    32'h00728623,
    32'h01c28823,
    32'h01d28023,
    32'h074000ef,
    32'h00300e93,
    32'h01d28023,
    32'h068000ef,
    32'h0082ae83,
    32'h01d12023,
    32'h01428e83,
    32'h01ce8463,
    32'h00000e93,
    32'hffd12e23,
    32'h00839393,
    32'h0c43e393,
    32'h00200e13,
    32'h00100e93,
    32'h00628223,
    32'h00729623,
    32'h01c28823,
    32'h01d28023,
    32'h02c000ef,
    32'h00300e93,
    32'h01d28023,
    32'h020000ef,
    32'h0082ae83,
    32'hffd12c23,
    32'h01428e83,
    32'h01ce8463,
    32'h00000e93,
    32'hffd12a23,
    32'h0000006f,
    32'h40010f37,
    32'h194f2f03,
    32'h000f4f03,
    32'h0fff7f13,
    32'h004f7f13,
    32'hfe0f16e3,
    32'h00008067
};

logic [31:0] testAxiProgram [] = '{
    32'h00000013,
    32'h40000537,
    32'h0f050513,
    32'h00a52023,
    32'h00052583,
    32'h00b12023,
    32'he0001337,
    32'h02c30313,
    32'h00632023,
    32'h00000493,
    32'h00032e83,
    32'h002efe93,
    32'h0000006f
};

  `include "testBTPUProgram.svh"
  `include "testBlockMatrixMul.svh"

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
    #200ns;
    reset <= 1'b1;
    // repeat (5) @(negedge clock); 
  end

  //Clock generation
  // always #5 clock <= ~clock;ù
  localparam int CLOCK_PERIOD = 10;
  always begin
    clock <= 1'b1;
    #5ns;
    clock <= 1'b0;
    #5ns;
  end

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
    wait(reset == 1);

    // LOAD_PROGRAM(data_array, BASE_ADDR);
    // S_AXI_TEST();
    // doQueuedTests();
    // printLog();

    // writeCREG(32'b00); //Reset CPU
    // LOAD_PROGRAM(and_array, BASE_ADDR);
    // istruction_count = 0;
    // doAndiTest();
    // printLog();

    // writeCREG(32'b00); //Reset CPU
    // LOAD_PROGRAM(testI2C, BASE_ADDR);
    // istruction_count = 0;
    // doI2CTest();
    // printLog();

    // writeCREG(32'b00); //Reset CPU
    // LOAD_PROGRAM(testAxiProgram, BASE_ADDR);
    // istruction_count = 0;
    // doAXITest();
    // printLog();

    writeCREG(32'b00); //Reset CPU
    istruction_count = 0;
    doBTPUTest();
    printLog();

    
    #200ns;
    $finish;
  end

  task backdoor_mem_write(
      input xil_axi_ulong     addr, 
      input bit [32-1:0]      wr_data,
      input bit [(32/8)-1:0]  wr_strb ={(32/8){4'b1111}}
    );
    slv_agent_0.mem_model.backdoor_memory_write(addr, wr_data, wr_strb);

  endtask

  task backdoor_mem_read(
      input xil_axi_ulong mem_rd_addr,
      output bit [32-1:0] mem_rd_data
    );
    mem_rd_data= slv_agent_0.mem_model.backdoor_memory_read(mem_rd_addr);

  endtask

  task read_memory(input xil_axi_ulong mem_rd_addr, output bit [32-1:0] mem_rd_data);
  begin
    mst_agent_0.AXI4LITE_READ_BURST(
      mem_rd_addr, 
      mtestProtectionType, 
      mem_rd_data, 
      mtestRresp
    );
  end
  endtask

  task write_memory(
      input xil_axi_ulong mem_wr_addr, 
      input bit [32-1:0] mem_wr_data, 
      input bit [(32/8)-1:0] mem_wr_strb = {(32/8){4'b1111}}
    );
    mst_agent_0.AXI4LITE_WRITE_BURST(
      mem_wr_addr, 
      mtestProtectionType, 
      mem_wr_data, 
      mtestBresp
    );
  endtask

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
            #10;
            mtestWDataL[63:32] = 32'h0;
            mtestADDR[63:32] = 32'h0;
            on_programming = 1'b1;
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
  assign state_tb = DUT.test_design_i.CPU_0.U0.state_dbg_sig;

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
  wire GPIO1;
  assign GPIO1 = GPIO[0];

  assign GPIO = GPIO_sig;

  //OLED
  wire [31:0] display_in_tb;
  assign display_in_tb = DUT.test_design_i.CPU_0.U0.display_in;

  wire stall_tb;
  assign stall_tb = DUT.test_design_i.CPU_0.U0.axi_stall;


  task automatic writeCREG(input logic [31:0] data);
    begin
      mtestID = 0; 
      mtestBurstLength = 0; 
      mtestDataSize = xil_axi_size_t'(xil_clog2(32/8)); 
      mtestBurstType = XIL_AXI_BURST_TYPE_INCR;  
      mtestLOCK = XIL_AXI_ALOCK_NOLOCK;  
      mtestCacheType = 0;  
      mtestProtectionType = 0;  
      mtestRegion = 0; 
      mtestQOS = 0; 


      mtestADDR = 32'h40004000; 
      mtestWDataL[31:0] = data;   
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );  
    end
  endtask

  logic testPassed = 0;
  task automatic S_AXI_TEST;  
    integer i;
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
      run <= 1'b0; 
      writeCREG(32'b11);
      run <= 1'b1; //Set RUN to 1 to start the CPU

      //Istruzione no. 1 
      test_n = 1;

      wait (state_tb == fetch);
      @(state_tb);
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
      @(posedge clock);
      #1;

      test_n = 2;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       ADDI x20, x1, 1
      if(regFile[19] == -32'd15) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[2] was";
      end
      addToLog(test_n, testPassed, message, regFile[1]);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;
      
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
      @(posedge clock);
      #1;

      test_n = 4;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LUI x3, 0x40010
      if(regFile[2] == 32'h40010000) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[3] was";
      end
      addToLog(test_n, testPassed, message, regFile[2]);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 5;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       SW x1, 0(x3)
      checkQueuePush(test_n, 32'h40010000, -32'd16, "OK", "FAILED -> Mem[0x40010000] was");
      // addToLog(test_n, 1, "Further more analiys on TEST SUITE are needed: If next test is OK, this test is OK too", 0);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 6;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LW x4, 0(x3)
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
      @(posedge clock);
      #1;

      test_n = 7;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       BEQ x4, x1, L1
      if(instruction_tb == 32'hff1ff2ef) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> instruction_tb was";
      end
      addToLog(test_n, testPassed, message, instruction_tb);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 8;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       JAL x5, L2 
      if(regFile[4] == 32'h40000030) begin // Modify this after compiling the code whit addr(JAL x5, L2) + 4
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[5] was";
      end
      addToLog(test_n, testPassed, message, regFile[4], "#8a");
      
      if(instruction_tb == 32'h40004337) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> instruction_tb was";
      end
      addToLog(test_n, testPassed, message, instruction_tb, "#8b");
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 9;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       LUI x6, 0x40004
      if(regFile[5] == 32'h40004000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[6] was";
      end
      addToLog(test_n, testPassed, message, regFile[5]);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 32;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       li x14, 2
      if(regFile[13] == 32'h2) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[14] was";
      end
      addToLog(test_n, testPassed, message, regFile[13]);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;
    


      test_n = 10;
      // wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      wait (stall_tb == 1);
      wait (stall_tb == 0);
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      // Check instruction       SW x0, 0(x6) //Stop the CPU by setting RUN to 0
      @(posedge clock);
      #1; //wait to be after the rising edge of the clock
      validating = 1'b1;
      if(run_tb == 0) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> CPU is still running";
      end
      addToLog(test_n, testPassed, message, regFile[6], "#10a");
      #1;
      validating = 1'b0;
      #1;

      run <= 1'b0; //Set RUN to 0 to stop the CPU
      writeCREG(32'b11); //Set RUN to 1 to continue the CPU
      run <= 1'b1; //Set RUN to 1 to start the CPU again


      // addToLog(test_n, 1, $sformatf("SKIPPED -> You need to check it: if a WRITE AXI transaction is done at %0t on CPU_0.M_AXI interface at Address: 0x%x and value: 2 -> TEST OK", $time, regFile[5]), 0);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 11;
      wait (state_tb == fetch); //wait until the CPU fetched the next instruction
      @(state_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       jalr x0, 0(x5)
      if(instruction_tb == 32'h00004397) begin  //Modi
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> instruction_tb was";
      end
      addToLog(test_n, testPassed, message, instruction_tb);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 12;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       AUIPC x7, 0x4
      if(regFile[6] == 32'h40004030) begin   // TO MODIFY whit addr(AUIPC x7, 0x4) + (4 << 12) (3 cifre esadeciamli)
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[7] was";
      end
      addToLog(test_n, testPassed, message, regFile[6]);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 13;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       sw x7, -8(x8)
      checkQueuePush(test_n, 32'h40011ff4, 32'h40004030, "OK", "FAILED -> Mem[0x40011FF8] was");
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

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
      @(posedge clock);
      #1;

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
      @(posedge clock);
      #1;

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
      @(posedge clock);
      #1;

      test_n = 17;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      GPIO_sig[0] = 1'bz;
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       sw x10, 4(x9)
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
      @(posedge clock);
      #1;

      test_n = 18;
      GPIO_sig[1] = 1;
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
      @(posedge clock);
      #1;

      test_n = 19;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       lw x11, 0(x9)
      if(regFile[10] & 32'h2 == 32'h2) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[11] was";
      end
      addToLog(test_n, testPassed, message, regFile[10] & 32'h2);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

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
      @(posedge clock);
      #1;

      test_n = 21;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      //Check instruction       sw x12, 0(x12)
      // addToLog(test_n, 1, "SKIPPED", 1);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 22;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;                       //wait to be after the rising edge of the clock
      validating = 1'b1;
      // addToLog(test_n, 1, "SKIPPED", 1);
      //Check instruction       lw x13, 0(x12)
      if(regFile[12] == 32'h40000000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[13] was";
      end
      if(testPassed == 1) begin
        addToLog(test_n-1, 1, "OK", 1);
      end else begin
        addToLog(test_n-1, 1, "UNKNOWN -> reading memory at the address get:", regFile[12]);
      end
      addToLog(test_n, testPassed, message, regFile[12]);

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
      mtestADDR = 32'h40004000;
      mtestWDataL[31:0] = '0;
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );
      GPIO_sig[0] = 0;
      validating = 1'b0;
      #10;
      validating = 1'b1;
      #1;
      addToLog(test_n, 1, $sformatf("SKIPPED -> You need to check it: if a LOW glitch is present on RES sig at %0t", $time), 0);
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
      @(posedge clock);
      #1;
      
      // Start the CPU
      test_n = 26;
      run = 1;
      mtestADDR = 32'h40004000;
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

      //Check state_dbg == fetch (aka stato ATTUALE)
      if(state_tb == fetch) begin // State 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> state_tb was";
      end
      addToLog(test_n, testPassed, message, state_tb, $sformatf("#%0db", test_n));

      if(control_reg_tb[3] == 32'h40000000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> control_reg_tb[3] was";
      end
      addToLog(test_n, testPassed, message, control_reg_tb[3], $sformatf("#%0dc", test_n));
      #1;
      validating = 1'b0;

      //chech run out signal
      test_n = 28;
      @(aliveLed);
      t0 = $time;
      @(aliveLed);
      t1 = $time;
      validating = 1'b1;
      if(t1 - t0 == 4 * CLOCK_PERIOD) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> aliveLed period was";
      end
      addToLog(test_n, testPassed, message, t1 - t0);
      #1;
      validating = 1'b0;

      //Writing to PS-PL GPIO registers
      test_n = 29;
      run = 0; //Set RUN to 0 to stop the CPU
      mtestADDR = 32'h40004010;
      mst_agent_0.AXI4LITE_READ_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestRDataL, 
        mtestRresp 
      );
      validating = 1'b1;   
      if(mtestRDataL[31:6] == 32'h0 && mtestRDataL[3:0] == 1) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> mtestRDataL was";
      end
      addToLog(test_n, testPassed, message, mtestRDataL, $sformatf("#%0da", test_n));
      
      if(control_reg_tb[4] == 32'h00000011) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> control_reg_tb[4] was";
      end
      addToLog(test_n, testPassed, message, control_reg_tb[4], $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      //Writing to PS-PL GPIO registers
      test_n = 30;
      mtestADDR = 32'h40004010;
      mtestWDataL[31:24] = 8'b00000111;
      mtestWDataL[23:0] = 24'b0;
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );
      validating = 1'b1;
      if(LEDs == 3'b111) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> LEDs was";
      end
      addToLog(test_n, testPassed, message, LEDs, $sformatf("#%0da", test_n));

      if(control_reg_tb[4][26:24] == 3'b111) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> control_reg_tb[4] was";
      end
      addToLog(test_n, testPassed, message, control_reg_tb[4], $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      //Change OLED value
      test_n = 31;
      oled_select0 = 1;
      #1;
      validating = 1'b1;
      if(display_in_tb == 32'h40000000) begin 
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> display_in_tb was";
      end
      addToLog(test_n, testPassed, message, display_in_tb, $sformatf("#%0da", test_n));
      #1;
      validating = 1'b0;

      ///////////// TEST 32 UP, between Test #10 and Test #11
    end 
  endtask  

  task automatic doAndiTest;
    string message;
    
    begin
      $display("Testing ANDI instruction");
      run = 1'b0; //Set RUN to 0 to stop the CPU
      writeCREG(32'b11); //Set CPU in RUN 
      run = 1'b1; //Set RUN to 1 to start the CPU

      wait (state_tb == fetch);
      @(state_tb);
      wait (state_tb == fetch);
      #1;
      test_n = 1;
      validating = 1'b1;
      //Check instruction   lui     t1, 0x40020
      if(regFile[5] == 32'h40020000) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[6] was";
      end
      addToLog(test_n, testPassed, message, regFile[5]);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 2;
      GPIO_sig[7:0] = 8'b0001_0001;
      wait (state_tb == fetch);
      #1; 
      validating = 1'b1;
      //Check instruction   lw  a6, 0(t1)
      if (regFile[15][7:0] == 8'b0001_0001) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[16] was";
      end
      addToLog(test_n, testPassed, message, regFile[15]);
      #1;
      validating = 1'b0;
      @(posedge clock);
      #1;

      test_n = 3;
      wait (state_tb == fetch);
      #1;
      validating = 1'b1;
      //Check instruction   andi    a6, a6, 0b111110
      if (regFile[15][7:0] == 8'b0001_0000) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[16] was";
      end
      addToLog(test_n, testPassed, message, regFile[15]);
      #1;
      validating = 1'b0;     

    end  
  endtask    

  wire i2c_busy_tb;
  assign i2c_busy_tb = DUT.test_design_i.CPU_0.U0.i2c_driver.busy;

  wire i2c_rw_n_driver_tb;
  assign i2c_rw_n_driver_tb = DUT.test_design_i.CPU_0.U0.i2c_driver.rw_n;

  task automatic doI2CTest;
    string message;
    begin
      $display("Testing I2C module");
      mtestWDataL[31:0] = 32'h40020010;
      mtestADDR[31:0] = 32'h40010194;
      mst_agent_0.AXI4LITE_WRITE_BURST(
          mtestADDR,
          mtestProtectionType, 
          mtestWDataL, 
          mtestBresp 
      );
      writeCREG(32'b11); //Set CPU in RUN 

      test_n = 1;     
      wait (instruction_tb ==  32'h01d28023); // Instruction: sb t4, 0(t0) (AKA I2C_START)
      @(instruction_tb);
      #1;
      validating = 1'b1;
      if (i2c_busy_tb == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_busy_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_busy_tb, $sformatf("#%0da", test_n));
      if(i2c_rw_n_driver_tb == 0) begin     //IF is WRITE
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_rw_n_driver_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_rw_n_driver_tb, $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      test_n = 2;
      wait (instruction_tb ==  32'h000f4f03); // Instruction: lbu t5, 0(t5) (AKA Read i2c CREG)
      @(instruction_tb);
      #1;
      validating = 1'b1;
      if (regFile[29][2] == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[30] was";
      end
      addToLog(test_n, testPassed, message, regFile[29][2]);
      #1;
      validating = 1'b0;

      test_n = 3;       //andi   t5, t5, 0b100
      @(instruction_tb);
      #1;
      validating = 1'b1;
      if (regFile[29][2] == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[30] was";
      end
      #1;
      validating = 1'b0;
      addToLog(test_n, testPassed, message, regFile[29][2]);
      wait (instruction_tb ==  32'h00008067); // Instruction: ret   (AKA i2c transaction done)
      #1;

      test_n = 4;
      validating = 1'b1;
      if(i2c_data_tb == 32'h76) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_data_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_data_tb, $sformatf("#%0da", test_n));
      if(i2c_address_tb == 32'h56) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_address_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_address_tb, $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      test_n = 5;
      wait(instruction_tb == 32'h01d28023); // Instruction: sb t4, 0(t0) (AKA I2C_START)
      @(instruction_tb);
      #1;
      validating = 1'b1;
      if(i2c_busy_tb == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_busy_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_busy_tb, $sformatf("#%0da", test_n));
      if(i2c_rw_n_driver_tb == 1) begin     //IF is READ
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_rw_n_driver_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_rw_n_driver_tb, $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      test_n = 6;
      wait(instruction_tb == 32'h000f4f03); // Instruction: lbu t5, 0(t5) (AKA Read i2c CREG) (on function wait_busy)
      @(instruction_tb);
      #1;
      validating = 1'b1;
      if (regFile[29][2] == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[30] was";
      end
      addToLog(test_n, testPassed, message, regFile[29][2]);
      #1;

      test_n = 7;       //andi   t5, t5, 0b100
      @(instruction_tb);
      #1;
      validating = 1'b1;
      if (regFile[29][2] == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[30] was";
      end
      #1;
      validating = 1'b0;
      addToLog(test_n, testPassed, message, regFile[29][2]);

      wait(instruction_tb == 32'h00008067); // Instruction: ret   (AKA i2c transaction done)
      #1;

      test_n = 8;       //lw t4, 8(t5) (Load I2C data)
      wait(instruction_tb == 32'h0082ae83);
      @(instruction_tb);
      validating = 1'b1;
      if (regFile[28] == 32'h76) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[28] was";
      end
      #1;
      validating = 1'b0;
      addToLog(test_n, testPassed, message, regFile[27]);

      test_n = 9;       //lb t4, 20(t0) (Load I2C data length)
      wait(instruction_tb == 32'h01428e83);
      @(instruction_tb);
      validating = 1'b1;
      if (regFile[28] == 32'h1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[28] was";
      end
      #1;
      validating = 1'b0;
      addToLog(test_n, testPassed, message, regFile[27]);

      test_n = 10;       //sb t1, 4(t0) (Write I2C slave address) -> check if t1 = 0x56, t2 = 0x76C4, t3 = 2, t4 = 0b01
      wait(instruction_tb == 32'h00628223);
      @(instruction_tb);
      validating = 1'b1;
      if (regFile[5] == 32'h56) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[6] was";
      end
      addToLog(test_n, testPassed, message, regFile[5], $sformatf("#%0da", test_n));

      if (regFile[6] == 32'h76C4) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[7] was";
      end
      addToLog(test_n, testPassed, message, regFile[6], $sformatf("#%0db", test_n));

      if (regFile[27] == 32'h2) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[8] was";
      end
      addToLog(test_n, testPassed, message, regFile[7], $sformatf("#%0dc", test_n));

      if (regFile[28] == 32'h1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[9] was";
      end
      addToLog(test_n, testPassed, message, regFile[8], $sformatf("#%0dd", test_n));

      #1;
      validating = 1'b0;

      test_n = 11;       //Wait for I2C transaction to start
      wait(instruction_tb == 32'h01d28023); // Instruction: sb t4, 0(t0) (AKA I2C_START)
      @(instruction_tb);
      if(i2c_busy_tb == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_busy_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_busy_tb, $sformatf("#%0da", test_n));

      if(i2c_rw_n_driver_tb == 0) begin     //IF is WRITE
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_rw_n_driver_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_rw_n_driver_tb, $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;
      

      test_n = 12;       //sb t4, 0(t0) (AKA I2C_START)
      wait(instruction_tb == 32'h01d28023); // Instruction: sb t4, 0(t0) (AKA I2C_START)
      @(instruction_tb);
      validating = 1'b1;
      if(i2c_busy_tb == 1) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_busy_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_busy_tb, $sformatf("#%0da", test_n));

      if(i2c_rw_n_driver_tb == 1) begin     //IF is READ
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> i2c_rw_n_driver_tb was";
      end
      addToLog(test_n, testPassed, message, i2c_rw_n_driver_tb, $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      test_n = 13;       //lw t4, 8(t0) (Load I2C data)
      wait(instruction_tb == 32'h0082ae83); 
      @(instruction_tb);
      validating = 1'b1;
      if (regFile[28] == 32'h76C4) begin
        testPassed = 1;
        message = "OK";
      end else if (regFile[28] == 32'hC476) begin
        testPassed = 0;
        message = "WARNING -> The endianness is wrong: regFile[29] was";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[29] was";
      end
      addToLog(test_n, testPassed, message, regFile[28]);
      #1;
      validating = 1'b0;

      test_n = 14;       //lb t4, 20(t0) (Load I2C data length)
      wait(instruction_tb == 32'h01428e83);
      @(instruction_tb);
      validating = 1'b1;
      if (regFile[28] == 32'h2) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[28] was";
      end
      addToLog(test_n, testPassed, message, regFile[27]);
      #1;
      validating = 1'b0;

    

    end
  endtask

  task automatic doAXITest;
    string message;
    begin
      test_n = 0;
      $display("Testing AXI Store after Load");
      run = 1'b0; //Set RUN to 0 to stop the CPU
      writeCREG(32'b11); //Set CPU in RUN 
      run = 1'b1; //Set RUN to 1 to start the CPU
      
      test_n = 1;
      @(instruction_tb);        //wait nop instruction
      @(instruction_tb);        //wait nop instruction
      @(instruction_tb);        //wait until the CPU has executed the next instruction
      wait (state_tb == fetch); 
      #1;
      validating = 1'b1;
      //Check instruction   lui     a0, 0x40000
      if(regFile[9] == 32'h40000000) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[10] was";
      end
      addToLog(test_n, testPassed, message, regFile[9]);
      #1;
      validating = 1'b0;      

      test_n = 2;
      @(instruction_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   addi   a0, a0, 0xf0
      if (regFile[9] == 32'h400000f0) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[10] was";
      end
      addToLog(test_n, testPassed, message, regFile[9]);
      #1;
      validating = 1'b0;

      test_n = 0;
      @(instruction_tb);
      //SKIP instruction   sw    a0, 0(a0)
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;

      test_n = 3;
      @(instruction_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   lw    a1, 0(a0)
      if (regFile[10] == 32'h400000f0) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[11] was";
      end
      addToLog(test_n, testPassed, message, regFile[10]);
      #1;
      validating = 1'b0;
      @(instruction_tb);

      //SKIP instruction   sw   a1, 0(sp)
      test_n = 0;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;


      ///////// UART test /////////
      test_n = 4;
      @(instruction_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   lui  t1, 0xE0001
      if (regFile[5] == 32'hE0001000) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[10] was";
      end
      addToLog(test_n, testPassed, message, regFile[5]);
      #1;
      validating = 1'b0;

      test_n = 5;
      @(instruction_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   addi t1, a0, 0x2C
      if (regFile[5] == 32'hE000102C) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[10] was";
      end
      addToLog(test_n, testPassed, message, regFile[5]);
      #1;
      validating = 1'b0;
      @(instruction_tb);

      test_n = 6;
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   sw    t1, 0(t1)
      backdoor_mem_read(32'hE000102C, data_readed);
      if (data_readed == 32'hE000102C) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> Memory[0xE000102C] was";
      end
      addToLog(test_n, testPassed, message, data_readed);
      #1;
      validating = 1'b0;

      test_n = 7;
      @(instruction_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   li  s1, 0
      if (regFile[8] == 32'h0) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[12] was";
      end  
      addToLog(test_n, testPassed, message, regFile[8]);
      #1;
      validating = 1'b0;


      test_n = 8;
      @(instruction_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   lw    t4, 0(t1)
      if (regFile[28] == 32'hE000102C) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[11] was";
      end
      addToLog(test_n, testPassed, message, regFile[28]);
      #1;
      validating = 1'b0;

      test_n = 9;
      @(instruction_tb);
      wait (state_tb == fetch); //wait until the CPU has executed the next instruction
      #1;
      validating = 1'b1;
      //Check instruction   andi t4, t4, 2
      if (regFile[28] == 32'h0) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> regFile[11] was";
      end
      addToLog(test_n, testPassed, message, regFile[28]);
      #1;
      validating = 1'b0;
      // @(instruction_tb);

      test_n = 6;
      data_readed = 0;
      backdoor_mem_read(32'hE000102C, data_readed);
      validating = 1'b1;
      if (data_readed == 32'hE000102C) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> Memory[0xE000102C] was";
      end
      addToLog(test_n, testPassed, message, data_readed, $sformatf("#%0db", test_n));
      #1;
      validating = 1'b0;

      mtestADDR = 32'hE000102C;
      mtestWDataL = 32'hE000102C;
      mst_agent_0.AXI4LITE_WRITE_BURST( 
        mtestADDR, 
        mtestProtectionType, 
        mtestWDataL, 
        mtestBresp 
      );
      backdoor_mem_read(32'hE000102C, data_readed);
      validating = 1'b1;
      if (data_readed == 32'hE000102C) begin
        testPassed = 1;
        message = "OK";
      end else begin
        testPassed = 0;
        message = "FAILED -> Memory[0xE000102C] was";
      end
      addToLog(test_n, testPassed, message, data_readed, $sformatf("#%0dc", test_n));
      #1;
      validating = 1'b0;




    end
  endtask 


  logic [31:0] data_readed;
  int btpu_test_size = 32;
  logic [31:0] res1_addr_base = 32'h400A0000 + 32 * 4;
  logic [31:0] res2_addr_base = 32'h400C0000 + 32 * 4;

  task automatic doBTPUTest;
    integer i;
    logic testPassed = 0;
    string message;
    begin
      $display("\nTesting BTPU module");
      `ifdef testBTPU_TEXT_ADDR
        LOAD_PROGRAM(testBTPU_text, `testBTPU_TEXT_ADDR);
      `endif
      `ifdef testBTPU_DATA_ADDR
        LOAD_PROGRAM(testBTPU_data, `testBTPU_DATA_ADDR);
      `endif
      `ifdef testBTPU_CONST_ADDR
        LOAD_PROGRAM(testBTPU_const, `testBTPU_CONST_ADDR);
      `endif
      run = 1'b0; //Set RUN to 0 to stop the CPU
      writeCREG(32'b11); //Set CPU in RUN
      run = 1'b1; //Set RUN to 1 to start the CPU

      wait (instruction_tb == 32'h0000006f); // Wait for CPU traps

      test_n = 0;
      for (i = 0; i < btpu_test_size; ++i) begin
        read_memory(res1_addr_base + i * 4, data_readed);
        validating = 1'b1;
        if (data_readed == btpu_res1[i]) begin
          testPassed = 1;
          message = "OK";
        end else begin
          testPassed = 0;
          message = $sformatf("FAILED -> res1[%0d] was", i);
        end
        addToLog(test_n + i + 1, testPassed, message, data_readed, $sformatf("#%0da", i + 1));
        #1;
        validating = 1'b0;

        read_memory(res2_addr_base + i * 4, data_readed);
        validating = 1'b1;
        if (data_readed == btpu_res2[i]) begin
          testPassed = 1;
          message = "OK";
        end else begin
          testPassed = 0;
          message = $sformatf("FAILED -> res2[%0d] was", i);
        end
        addToLog(test_n + i + 1, testPassed, message, data_readed, $sformatf("#%0db", i + 1));
        #1;
        validating = 1'b0;
      end
    end
  endtask


  always @(instruction_tb or negedge reset) begin
    if (!reset) begin
      istruction_count = 0;
    end else begin
      istruction_count ++;
    end
  end

endmodule

// Program assembly code:
// main:
//     addi   x1, x0,-16       # x1 <- -16
//     addi   x20, x1, 1        # x20 <- x1 + 1  // x20 = -15
//     add    x3, x20, x1      # x3 <- x20 + x1 // x3 = -31
//     lui    x3, 0x40010      # x3 <- 0x40010000 // x3 = RAM_START
//     sw     x1, 0(x3)        # Mem[x3] <- -16 // Mem[0x40010000] = -16   //PENSARE SE c'è un modo per testare questa istruzione
//     lw     x4, 0(x3)        # x4 <- Mem[x3] // x4 = -16
//     nop    #mv     x4, x1           # LOADS do not wowk for now; to continue whit testing, we need to set x4 = x1
//     beq    x4, x1, L1       # if x4 == x1, goto L1 // instr=0xff9ff06f
// L2:
//     lui    x6, 0x40004      # x6 <- 0x40004
//     li     x14, 2           # x14 <- 2
//     sw     x14, 0(x6)       # Mem[x6] <- 2 //res = 1 && run = 0 
//     jalr   x0, 0(x5)        # goto L3 (aka ret x5)
// L1:
//     jal    x5, L2           # else, goto L2 // instr=400042b7 // x5 = PC + 4 = 0x40000028
// L3:
//     auipc  x7, 4            # x7 <- PC + 4 // x7 = 0x40004030
//     sw     x7, -8(x8)       # Mem[x8] <- x7 // Mem[0x40011ff8] = 0x40004030
//     addi   x8, x8, -8       # x8 <- x8 - 4 // x8 = 0x40011ff4
//     lui    x9, 0x40020      # x9 <- 0x40020 // x9 = 0x40020000 (GPIO START) GPIO_VALUE
//     addi   x10, x0, 1       # x10 <- 1 // x10 = 1
//     sw     x10, 4(x9)       # Mem[x9 + 4] <- x10 // GPIO[0x40020004] = 1    // GPIO_DIR_REG
//     sw     x10, 8(x9)       # Mem[x9 + 8] <- x10 // GPIO[0x40020008] = 1    // GPIO_OUT_REG
//     lw     x11, 0(x9)       # x11 <- Mem[x9] // x11 = 1                     // GPIO_VALUE
//     lui    x12, 0x40000     # x12 <- 0x40000 // x12 = 0x40000000
//     sw     x12, 0(x12)      # Mem[x12] <- x12 // Mem[0x40000000] = 0x40000000        // AXI WRITE
//     lw     x13, 0(x12)      # x13 <- Mem[x12] // x13 = 0x40000000                    // AXI READ
//     call   cat_registers    # call cat_registers
// L4:
//     j      L4               # trap CPU