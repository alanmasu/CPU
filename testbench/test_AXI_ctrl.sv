`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 05:04:06 PM
// Design Name: 
// Module Name: test_AXI_ctrl
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
import axi_vip_pkg::*;
import mem_ctrl_test_axi_vip_0_0_pkg::*;

import types_pkg::*;
import memory_pkg::*;

module test_AXI_ctrl( );
    //Type definitions
    typedef struct packed {
        logic en_mem;
        logic en_axi;
        logic en_gpio;
        logic en_i2c;
        logic en_BTPU_CREG;
        logic en_BTPU_W_MEM;
        logic en_BTPU_IO0_MEM;
        logic en_BTPU_IO1_MEM;
    } en_bus_t;

    // typedef struct packed {
    //     bit[31:0] axi_data;
    //     bit[31:0] gpio_data;
    //     bit[31:0] I2C_data;
    // } peripheral_data_t;

    typedef enum {SETUP, ALU, MEMORY, AXI, GPIO, I2C, B_TPU} test_type_t;
        

    bit clock, reset, jmp, we_in, en_in;
    bit[2:0] mem_opcode = 3'b000;
    bit[4:0] op_class = 5'b00000;
    bit[31:0] npc_in;
    bit[31:0] alu_resoult;
    bit[31:0] alu_resoult_reg;
    bit[31:0] rs2_value;
    bit[4:0] rd_addr_in;
    bit[4:0] rd_addr_out;
    bit[31:0] rd_value_out;
    bit[31:0] pc_out;
    en_bus_t en_out = '{en_mem: 1'b0, en_axi: 1'b0, en_gpio: 1'b0, en_i2c: 1'b0, en_BTPU_CREG: 1'b0, en_BTPU_W_MEM: 1'b0, en_BTPU_IO0_MEM: 1'b0, en_BTPU_IO1_MEM: 1'b0};
    bit[3:0] we_out;
    bit[31:0] address_out;
    bit[31:0] d_out;

    bit[31:0] axi_data_out = 32'h00000000;
    bit stall;
    peripheral_data_t d_in; // = '{axi_data: 32'h00000000};
    wire [31:0] gpio_data_out;

    const bit[31:0] address_shift = 32'h40010000;

    logic [31:0] gpio_pins = 32'bZ;
    wire [31:0] gpio_pins_wire;

    //I2C
    wire SCL;
    wire SDA;
    bit [31:0] i2c_data_out;
    logic sda_tb = 1'bz;
    logic scl_tb = 1'bz;
      //for slave interface
    wire [31:0] i2c_data_to_send_tb;
    wire [31:0] i2c_data_tb;
    wire [31:0] i2c_address_tb;
    wire i2c_rw_n_tb;

    //For BTPU
    wire [31:0] btpu_douta;
    
    logic [3:0] btpu_web = 1'b0;
    logic btpu_enb = 1'b0;
    logic [31:0] btpu_addrb = 32'd0;
    logic [31:0] btpu_dinb = 32'd0;
    wire [31:0] btpu_doutb;
    


    //Master vip agent
    axi_transaction                         wr_transaction;   
    axi_transaction                         rd_transaction;   
    axi_monitor_transaction                 slv_monitor_transaction;  
    axi_monitor_transaction                 slave_moniter_transaction_queue[$];  
    xil_axi_uint                            slave_moniter_transaction_queue_size =0;
  
    mem_ctrl_test_axi_vip_0_0_slv_mem_t     slv_mem_t;

    //DUT New signals
    logic en_1 = 1'b0;
    logic[3:0] we_1 = 4'b0;
    logic[31:0] address_1 = 32'h00000000;
    logic[31:0] write_data_1 = 32'h00000000;
    logic[31:0] read_data_1 = 32'h00000000;
    logic stall_1 = 1'b0;

    //For testing
    test_type_t test_type = SETUP;
    memory_write_back mem(
        .clk(clock),
        .res(reset),
        .jmp(jmp),
        .we_in(we_in),
        .en_in(en_in),
        .mem_opcode(mem_opcode),
        .op_class(op_class),
        .npc_in(npc_in),
        .alu_resoult(alu_resoult),
        .alu_resoult_reg(alu_resoult_reg),
        .rs2_value(rs2_value),
        .rd_addr_in(rd_addr_in),
        .rd_addr_out(rd_addr_out),
        .rd_value(rd_value_out),
        .pc_out(pc_out),
        .en_out(en_out),
        .we_out(we_out),
        .address_out(address_out),
        .d_out(d_out),
        .d_in(d_in),

        //BRAM
        .clkb(clock),
        .enb(1'b0),
        .web(4'b0),
        .addrb(11'b0),
        .dinb(32'b0)
    );

    mem_ctrl_test_wrapper DUT(
        .reset_rtl(reset),
        .clock_100mhz(clock),
        .en_0(en_out.en_axi),
        .we_0(we_out),
        .address_0(address_out),
        .write_data_0(d_out),
        .read_data_0(axi_data_out),
        .stall_0(stall),
        .en_1(en_1),
        .we_1(we_1),
        .address_1(address_1),
        .write_data_1(write_data_1),
        .read_data_1(read_data_1),
        .stall_1(stall_1)
    );

    GPIO DUT2(
        .clk(clock),
        .res(reset),
        .address(address_out),
        .d_in(d_out),
        .wea(we_out),
        .ena(en_out.en_gpio),
        .d_out(gpio_data_out),
        .gpio(gpio_pins_wire)
    );
    assign gpio_pins_wire = gpio_pins;

    I2C_module DUT3(
        .clk(clock),
        .res(reset),
        .scl(SCL),
        .sda(SDA),
        .ena(en_out.en_i2c),
        .wea(we_out),
        .addra(address_out),
        .dina(d_out),
        .douta(i2c_data_out)
    );
    pullup(SCL);
    pullup(SDA);       
    assign SCL = scl_tb;
    assign SDA = sda_tb;

    //slave interface
    slave_interface slave_interface_inst(
        .i2c_sda(SDA),
        .i2c_scl(SCL),
        .res(reset),
        .i2c_address_tb(i2c_address_tb),
        .i2c_rw_n_tb(i2c_rw_n_tb),
        .i2c_data_tb(i2c_data_tb),
        .i2c_data_to_send(i2c_data_to_send_tb)
    );

    //BTPU
    BTPU_wrapper DUT4(
        .clk(clock),
        .res(reset),
        .hs_clk(clock),

        .ena(en_out),
        .wea(we_out),
        .addra(address_out),
        .dina(d_out),
        .douta(btpu_douta),

        .enb(btpu_enb),
        .web(btpu_web),
        .addrb(btpu_addrb),
        .dinb(btpu_dinb),
        .doutb(btpu_doutb)
    );


    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin
            pulldown(gpio_pins_wire[j]);  // Pulldown su ogni bit.
        end
    endgenerate
    
    always @(axi_data_out) begin
        d_in.axi_data = axi_data_out;
    end 

    always @(gpio_data_out) begin
        d_in.gpio_data = gpio_data_out;
    end

    always @(btpu_douta) begin
        d_in.btpu_data = btpu_douta;
    end

    always @(posedge clock) begin
        alu_resoult_reg <= alu_resoult;
    end

    always begin
        clock = 1'b1;
        #5;
        clock = 1'b0;
        #5;
    end
    
    initial begin
        reset = 1'b0;
        // #200;
        #160;
        reset = 1'b1;
    end


    initial begin
        slv_mem_t = new( "slv_mem_t", test_AXI_ctrl.DUT.mem_ctrl_test_i.axi_vip_0.inst.IF );
        slv_mem_t.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);
        slv_mem_t.mem_model.set_memory_fill_policy(XIL_AXI_MEMORY_FILL_FIXED);
        slv_mem_t.start_slave();
        $timeformat (-12, 1, " ps", 1);
        #1;
        slv_monitor_transaction = new("slv_monitor_transaction");
        forever begin
          slv_mem_t.monitor.item_collected_port.get(slv_monitor_transaction);
          slave_moniter_transaction_queue.push_back(slv_monitor_transaction);
          slave_moniter_transaction_queue_size++;
        end
    end

    integer testN = 0;
    logic   validating = 1'b0;

    wire [31:0] mem_out_tb;
    assign mem_out_tb = mem.mem_out;
    
    time t0;
    task automatic testMemory;
    begin
            //Setup the memory controller
        jmp = 1'b0;
        rd_addr_in = 5'b00101;
        #10;

        //ALU OP
        test_type = ALU;
        op_class = 5'b10000;
        #10;

        //Store
        //Test 1: Store word allineata
        testN = 1;
        test_type = MEMORY;
        op_class = 5'b01000;
        en_in = 1'b1;
        we_in = 1'b1;
        //Scrive 4 WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b010; //SW
        rs2_value = 32'h10B2ACF8;

        alu_resoult = 32'h40010000; 
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if(mem_out_tb == 32'h10B2ACF8) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b1111) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;


        //Test 2: Store word ad un byte di disallineamento
        testN = 2;
        alu_resoult = alu_resoult + 4 + 1; // + 4(byte) + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'hB2ACF800) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b1110) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        //Test 3: Store word a 2 byte di disallineamento
        testN = 3;
        alu_resoult = alu_resoult + 4 + 1; // + 4(byte) + 2(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'hACF80000) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b1100) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        //Test 4: Store word a 3 byte di disallineamento
        testN = 4;
        alu_resoult = alu_resoult + 4 + 1; // + 4(byte) + 3(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'hF8000000) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b1000) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        //Scrive 4 HALF WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b001; //SH

        // Test 5: Store half word allineata
        testN = 5;
        alu_resoult = alu_resoult + 1; // + 1(byte) di disallineamento (aka prima locazione allineata)
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'h0000ACF8) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b0011) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        // Test 6: Store half word ad un byte di disallineamento
        testN = 6;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'h00ACF800) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b0110 ) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        // Test 7: Store half word a 2 byte di disallineamento
        testN = 7;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'hACF80000) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b1100) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        // Test 8: Store half word a 3 byte di disallineamento
        testN = 8;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'hF8000000) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b1000) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;


        //Scrive 4 BYTE shiftate di un byte ciascuna
        mem_opcode = 3'b000; //SB

        // Test 9: Store byte allineata
        testN = 9;
        alu_resoult = alu_resoult + 1; // + 1(byte) di disallineamento (aka prima locazione allineata)
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'h000000F8) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b0001) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        // Test 10: Store byte ad un byte di disallineamento
        testN = 10;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'h0000F800) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b0010) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        // Test 11: Store byte a 2 byte di disallineamento
        testN = 11;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'h00F80000) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b0100) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        // Test 12: Store byte a 3 byte di disallineamento
        testN = 12;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( mem_out_tb == 32'hF8000000) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> mem_out_tb was %x", testN, mem_out_tb);
        end
        if(we_out == 4'b1000) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> we_out was %b", testN, we_out);
        end
        #1;
        validating = 1'b0;

        //Load
        op_class = 5'b00100;
        en_in = 1'b1;
        we_in = 1'b0;
        //Carica 4 WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b010; //LW
        
        // Test 13: Load word allineata
        testN = 13;
        alu_resoult = 32'h40010000;
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'h10B2ACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 14: Load word ad un byte di disallineamento
        testN = 14;
        alu_resoult = alu_resoult + 4 + 1; // + 4(byte) + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFB2ACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 15: Load word a 2 byte di disallineamento
        testN = 15;
        alu_resoult = alu_resoult + 4 + 1; // + 4(byte) + 2(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 16: Load word a 3 byte di disallineamento
        testN = 16;
        alu_resoult = alu_resoult + 4 + 1; // + 4(byte) + 3(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFFFF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        //Carica 4 HALF WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b001; //LH
        
        // Test 17: Load half word allineata
        testN = 17;
        alu_resoult = alu_resoult + 1; // + 1(byte) di disallineamento (aka prima locazione allineata)
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 18: Load half word ad un byte di disallineamento
        testN = 18;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 19: Load half word a 2 byte di disallineamento
        testN = 19;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 20: Load half word a 3 byte di disallineamento
        testN = 20;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFFFF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        //Carica 4 BYTE shiftate di un byte ciascuna
        mem_opcode = 3'b000; //LB

        // Test 21: Load byte allineata
        testN = 21;
        alu_resoult = alu_resoult + 1; // + 1(byte) di disallineamento (aka prima locazione allineata)
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFFFF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 22: Load byte ad un byte di disallineamento
        testN = 22;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFFFF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;
        
        // Test 23: Load byte a 2 byte di disallineamento
        testN = 23;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFFFF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 24: Load byte a 3 byte di disallineamento
        testN = 24;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hFFFFFFF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        //Load 4 HALF WORDS Unsigned shiftate di un byte ciascuna
        mem_opcode = 3'b101; //LHU

        // Test 25: Load half word allineata
        testN = 25;
        alu_resoult = 32'h40010000 + 16;
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'h0000ACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 26: Load half word ad un byte di disallineamento
        testN = 26;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'h0000ACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 27: Load half word a 2 byte di disallineamento
        testN = 27; 
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'h0000ACF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end 
        #1;
        validating = 1'b0;

        // Test 28: Load half word a 3 byte di disallineamento
        testN = 28;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'h000000F8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end 
        #1;
        validating = 1'b0;

        //Load 4 BYTE Unsigned shiftate di un byte ciascuna
        mem_opcode = 3'b100; //LBU

        // Test 29: Load byte allineata
        testN = 29;
        alu_resoult = alu_resoult + 1; // + 1(byte) di disallineamento (aka prima locazione allineata)
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 30: Load byte ad un byte di disallineamento
        testN = 30;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 31: Load byte a 2 byte di disallineamento
        testN = 31;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;

        // Test 32: Load byte a 3 byte di disallineamento
        testN = 32;
        alu_resoult = alu_resoult + 4 + 1; // + 1(byte) di disallineamento
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if( rd_value_out == 32'hF8) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> rd_value_out was %x", testN, rd_value_out);
        end
        #1;
        validating = 1'b0;
        end 
    endtask

    task automatic testAXI;
    begin
        $display("Testing AXI\n\n");
        testN = 0;
        ///////////////////// AXI TESTS /////////////////////////
        // @ (posedge clock);
        #1;
        //IO test
        test_type = AXI;
        op_class = 5'b01000;
        en_in = 1'b1;
        we_in = 1'b1;

        //Scrivo 4 WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b010; //SW
        rs2_value = 32'd274877688;
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end

        //Scrivo 4 HALF WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b001; //SH
        rs2_value = 32'd35535;
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i + 16; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end

        //Scrivo 4 BYTE shiftate di un byte ciascuna
        mem_opcode = 3'b000; //SB
        rs2_value = 32'd207;
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i + 32; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end

        //Carico 4 WORDS shiftate di un byte ciascuna
        op_class = 5'b00100;
        en_in = 1'b1;
        we_in = 1'b0;
        mem_opcode = 3'b010; //LW
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end
        
        //Carico 4 HALF WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b001; //LH
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i + 16; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end

        mem_opcode = 3'b101; //LHU
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i + 16; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end

        //Carico 4 BYTE shiftate di un byte ciascuna
        mem_opcode = 3'b000; //LB
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i + 32; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end

        mem_opcode = 3'b100; //LBU
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h00000000 + i*4 + i + 32; 
            wait(stall == 1'b1); //Wait transaction starts
            wait(stall == 1'b0); //Wait reatransactiond ends
        end
        en_in = 1'b0;
    end
    endtask

    task automatic testGPIO;
    begin
        ///////////////////// GPIO TESTS /////////////////////////
        @ (posedge clock);
        #1; ; //Sychronize with the clock

        test_type = GPIO;
        op_class = 5'b01000;    //Need a Store opration for using the GPIO
        en_in = 1'b1;           
        we_in = 1'b1;

          //Setto i GPIO in input
        mem_opcode = 3'b010; //SW
        rs2_value = 32'b0;
        alu_resoult = 32'h40020004; //Indirizzo reg. GPIO_dir
        gpio_pins = 32'h00000000;
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if (gpio_pins_wire == 32'h00000000) begin
            $display("GPIO INPUT 1 test: OK");
        end else begin
            $display("GPIO INPUT 1 test: FAILED");
        end
        #1;
        validating = 1'b0;
        
        gpio_pins = 32'hffffffff;
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if (gpio_pins_wire == 32'hffffffff) begin
            $display("GPIO INPUT 2 test: OK");
        end else begin
            $display("GPIO INPUT 2 test: FAILED");
        end
        #1;
        validating = 1'b0;

        //Setto la direzione dei GPIO (ed i GPIO andranno a LOW per default)
        mem_opcode = 3'b010;            //SW
        rs2_value = '1;                 //Tutti a 1
        alu_resoult = 32'h40020004;     //Indirizzo reg. GPIO_dir
        gpio_pins = 'z;                 //Rilascio i GPIO dal testbench (tutti in alta impedenza)
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if (gpio_pins_wire == 32'h00000000) begin
            $display("GPIO OUTPUT 1 test: OK");
        end else begin
            $display("GPIO OUTPUT 1 test: FAILED");
        end
        #1;
        validating = 1'b0;
        

        //Setto tutti GPIO
        mem_opcode = 3'b010;            //SW
        rs2_value = '1;                 //Tutti a 1
        alu_resoult = 32'h40020008;     //Indirizzo reg. GPIO_reg
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if (gpio_pins_wire == 32'hffffffff) begin
            $display("GPIO OUTPUT 2 test: OK");
        end else begin
            $display("GPIO OUTPUT 2 test: FAILED");
        end
        #1;
        validating = 1'b0;


        //Testo le store byte e le load byte sui GPIO
        op_class = 5'b01000;
        mem_opcode = 3'b000;            //SB
        rs2_value = 32'h00000000;       //Setto il primo GPIO a 1
        alu_resoult = 32'h40020005;     //Indirizzo reg. GPIO_dir + 1 (aka PORT_B_DIR)
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if (gpio_pins_wire == 32'hffff00ff) begin
            $display("GPIO OUTPUT 3 test: OK");
        end else begin
            $display("GPIO OUTPUT 3 test: FAILED -> gpio_pins_wire was %x", gpio_pins_wire);
        end
        #1;
        validating = 1'b0;

        // Load a byte from GPIO
        op_class = 5'b00100;
        alu_resoult = 32'h40020001;     //Indirizzo reg. GPIO_status + 1 (aka PORT_B)
        mem_opcode = 3'b100;            //LBU
        gpio_pins[15:8] = 8'hAA;
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if(rd_value_out == 32'hAA) begin
            $display("GPIO INPUT 3 test: OK");
        end else begin
            $display("GPIO INPUT 3 test: FAILED -> rd_value_out was %x", rd_value_out);
        end 
        #1;
        validating = 1'b0;
    end
    endtask

    //Nomi generici per i segnali di I2C
    i2c_regfile_t i2c_regFile_tb;
    assign i2c_regFile_tb = DUT3.regFile;
    task automatic testI2C;
    begin
        ///////////////////// I2C TESTS /////////////////////////
        $display("Starting I2C TESTS...");
        testN = 1;
        @ (posedge clock);
        #1;
        test_type = I2C;
        op_class = 5'b01000;    //Need a Store opration for using the I2C
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h4002_0010 + (1 * 4); // I2C_REG_ADDRESS: I2C_BASE + 1 WORD
        rs2_value = 32'h56; // 0x56 address
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        we_in = 1'b0;
        validating = 1'b1;
        if (i2c_regFile_tb[1] == 32'h56) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> i2c_regFile_tb[1] was %0x", testN, i2c_regFile_tb[1]);
        end
        #1;
        validating = 1'b0;

        testN = 2;
        @ (posedge clock);
        #1;
        alu_resoult = 32'h4002_0010 + (3 * 4); // I2C_REG_WDATA: I2C_BASE + 3 WORDS
        en_in = 1'b1;
        we_in = 1'b1;
        rs2_value = 32'h78; // 0x78 data
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        we_in = 1'b0;
        validating = 1'b1;
        if (i2c_regFile_tb[3] == 32'h78) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> i2c_regFile_tb[3] was %0x", testN, i2c_regFile_tb[3]);
        end
        #1;
        validating = 1'b0;


        testN = 3;
        @ (posedge clock);
        #1;
        alu_resoult = 32'h4002_0010 + (4 * 4); // I2C_REG_LEN: I2C_BASE + 4 WORDS
        en_in = 1'b1;
        we_in = 1'b1;
        rs2_value = 32'h1; // 0x1 byte
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        we_in = 1'b0;
        validating = 1'b1;
        if (i2c_regFile_tb[4] == 32'h1) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> i2c_regFile_tb[4] was %0x", testN, i2c_regFile_tb[4]);
        end
        #1;
        validating = 1'b0;

        testN = 4;
        @ (posedge clock);
        #1;
        alu_resoult = 32'h4002_0010 + (0 * 4); // I2C_REG_CTRL: I2C_BASE + 0 WORD
        en_in = 1'b1;
        we_in = 1'b1;
        rs2_value[0] = 1'b1; // Start
        rs2_value[1] = 1'b0; // Write
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        we_in = 1'b0;
        validating = 1'b1;
        if (i2c_regFile_tb[0] == 32'h1) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> i2c_regFile_tb[0] was %0x", testN, i2c_regFile_tb[0]);
        end
        #1;
        validating = 1'b0;
        wait (i2c_regFile_tb[0][2] == 1'b1); // Wait until the I2C is busy is set (start the transaction)
        wait (i2c_regFile_tb[0][2] == 1'b0); // Wait until the I2C is busy is cleared (end the transaction)
        validating = 1'b1;
        if(i2c_address_tb == 32'h56) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> i2c_address_tb was %0x", testN, i2c_address_tb);
        end
        if(i2c_rw_n_tb == 1'b0) begin
            $display("Test #%0dc: OK", testN);
        end else begin
            $display("Test #%0dc: FAILED -> i2c_rw_n_tb was %0x", testN, i2c_rw_n_tb);
        end
        if(i2c_data_tb == 32'h78) begin
            $display("Test #%0dd: OK", testN);
        end else begin
            $display("Test #%0dd: FAILED -> i2c_data_tb was %0x", testN, i2c_data_tb);
        end
        #1;
        validating = 1'b0;

        testN = 5;
        @ (posedge clock);
        #1;
        alu_resoult = 32'h4002_0010 + (0 * 4); // I2C_REG_CTRL: I2C_BASE + 0 WORD
        en_in = 1'b1;
        we_in = 1'b1;
        rs2_value[0] = 1'b1; // Start
        rs2_value[1] = 1'b1; // Read
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        we_in = 1'b0;
        validating = 1'b1;
        if (i2c_regFile_tb[0] == 32'h3) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> i2c_regFile_tb[0] was %0x", testN, i2c_regFile_tb[0]);
        end
        #1;
        validating = 1'b0;

        op_class <= 5'b00100;   //LOAD
        en_in = 1'b1;
        we_in = 1'b0;
        mem_opcode = 3'b010; //LW
        alu_resoult = 32'h4002_0010 + (2 * 4); // I2C_REG_RDATA: I2C_BASE + 2 WORD
        
        wait (i2c_regFile_tb[0][2] == 1'b1); // Wait until the I2C is busy is set (start the transaction)
        wait (i2c_regFile_tb[0][2] == 1'b0); // Wait until the I2C is busy is cleared (end the transaction)
        validating = 1'b1;
        if(i2c_address_tb == 32'h56) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> i2c_address_tb was %0x", testN, i2c_address_tb);
        end
        if(i2c_rw_n_tb == 1'b1) begin
            $display("Test #%0dc: OK", testN);
        end else begin
            $display("Test #%0dc: FAILED -> i2c_rw_n_tb was %0x", testN, i2c_rw_n_tb);
        end
        if(i2c_data_out == 32'h78) begin
            $display("Test #%0dd: OK", testN);
        end else begin
            $display("Test #%0dd: FAILED -> i2c_data_tb was %0x", testN, i2c_data_tb);
        end
        #1;
        validating = 1'b0;
    end
    endtask

    task automatic testAXI_BRESP;
    begin
        // Test 1: AXI TEST BRESP
        $display("Starting NEW AXI TESTS...");
        testN = 1;
        @ (posedge clock);
        #1;
        test_type = AXI;
        op_class = 5'b01000; //Store
        en_1 = 1'b1;
        we_1 = 4'b1111;
        mem_opcode = 3'b010; //SW
        address_1 = 32'h00000000;
        write_data_1 = 32'h40010000;

        wait(stall_1 == 1'b1); //Wait transaction starts
        we_1 = 4'b0000;
        en_1 = 1'b0;
        t0 = $time;
        wait(stall_1 == 1'b0); //Wait reatransactiond ends
        validating = 1'b1;
        if($time - t0 > 60) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> t0 was %0d", testN, $time - t0);
        end 
        #1;
        validating = 1'b0;
    end
    endtask

    wire [1023:0] BTPU_IO0_out_tb;
    // assign BTPU_IO0_out_tb = DUT4.BTPU_inst.bram_IO0_doutb;

    btpu_regfile_t btpu_creg_tb;
    assign btpu_creg_tb = DUT4.BTPU_inst.control_reg;

    btpu_state_t btpu_state_tb;
    assign btpu_state_tb = DUT4.BTPU_inst.state;

    wire [31:0] btpu_busy_tb;
    assign btpu_busy_tb = DUT4.BTPU_inst.busy;

    task automatic testBTU;
        bit memory_test;
    begin
        $display("\n\nTesting BTPU...\n");
        test_type = B_TPU;
        testN = 0;
        @ (posedge clock);
        #1;

        //////////////// Writing to BTPU BRAMs ////////////////
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        //// BTPU W BRAM ////
        testN = 1;
        for (int i=0; i < 128; ++i) begin
            rs2_value = i;
            alu_resoult = 32'h40030000 + i*4;
            @ (posedge clock);
            #1;
        end
        //// BTPU I/O 0 BRAM ////
        testN = 2;
        for (int i=0; i < 128; ++i) begin
            rs2_value = i + 1;
            alu_resoult = 32'h40040000 + i*4;
            @ (posedge clock);
            #1;
        end
        //// BTPU I/O 1 BRAM ////
        testN = 3;
        for (int i=0; i < 128; ++i) begin
            rs2_value = i + 2;
            alu_resoult = 32'h40050000 + i*4;
            @ (posedge clock);
            #1;
        end


        //////////////// TESTING BTPU BRAMs ////////////////
        op_class = 5'b00100; //Load
        en_in = 1'b1;
        we_in = 1'b0;
        mem_opcode = 3'b010; //LW

        //////////////// TESTING BTPU W BRAM ////////////////
        testN = 1;
        memory_test = 1;
        for (int i=0; i < 128; ++i) begin
            alu_resoult = 32'h40030000 + i*4;
            @ (posedge clock);
            #1;
            validating = 1'b1;
            if(btpu_doutb != i) begin
                $display("Test #%0d-%0d: FAILED -> btpu_doutb was %0x", testN, i, btpu_doutb);
                memory_test = 0;
            end
            #1;
            validating = 1'b0;
        end
        if(memory_test) begin
            $display("Test #%0d: OK", testN);
        end

        //////////////// TESTING BTPU I/O 0 BRAM ////////////////
        testN = 2;
        memory_test = 1;
        for (int i=0; i < 128; ++i) begin
            alu_resoult = 32'h40040000 + i*4;
            @ (posedge clock);
            #1;
            validating = 1'b1;
            if(BTPU_IO0_out_tb != i + 1) begin
                $display("Test #%0d-%0d: FAILED -> BTPU_IO0_out_tb was %0x", testN, i, BTPU_IO0_out_tb);
                memory_test = 0;
            end
            #1;
            validating = 1'b0;
        end
        if(memory_test) begin
            $display("Test #%0d: OK", testN);
        end

        //////////////// TESTING BTPU I/O 1 BRAM ////////////////
        testN = 3;
        memory_test = 1;
        for (int i=0; i < 128; ++i) begin
            alu_resoult = 32'h40050000 + i*4;
            @ (posedge clock);
            #1;
            validating = 1'b1;
            if(BTPU_IO0_out_tb != i + 2) begin
                $display("Test #%0d-%0d: FAILED -> BTPU_IO0_out_tb was %0x", testN, i, BTPU_IO0_out_tb);
                memory_test = 0;
            end
            #1;
            validating = 1'b0;
        end
        if(memory_test) begin
            $display("Test #%0d: OK", testN);
        end

        //////////////// TESTING BTPU PORT B ////////////////
        //// Changing PORT SEL ////
        testN = 4;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030; //BTPU CREG base
        rs2_value = 32'b0;
        rs2_value[3] = 1'b1; //Set the BRAM_PORT_SEL_BIT
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[0][3] == 1'b1) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> btpu_creg_tb[0][3] was %0x", testN, btpu_creg_tb[0][3]);
        end 
        #1;
        validating = 1'b0;

        //// Enabling the BTPU port B ////
        btpu_enb = 1'b1;
        btpu_web = 1'b0;

        //////////////// TESTING BTPU W BRAM ////////////////
        testN = 3;
        memory_test = 1;
        for (int i=0; i < 128; ++i) begin
            btpu_addrb = 32'h40030000 + i*4; //BTPU BRAM base
            @ (posedge clock);
            #1;
            validating = 1'b1;
            if(btpu_doutb != i) begin
                $display("Test #%0d-%d: FAILED -> btpu_doutb was %0x", testN, i, btpu_doutb);
                memory_test = 0;
                break;
            end
            #1;
            validating = 1'b0;
        end
        if(memory_test) begin
            $display("Test #%0d: OK", testN);
        end

        //////////////// TESTING BTPU I/O 0 BRAM ////////////////
        testN = 4;
        memory_test = 1;
        for (int i=0; i < 128; ++i) begin
            btpu_addrb = 32'h40040000 + i*4; //BTPU I/O 0 BRAM base
            @ (posedge clock);
            #1;
            validating = 1'b1;
            if(btpu_doutb != i + 1) begin
                $display("Test #%0d-%d: FAILED -> btpu_doutb was %0x", testN, i, btpu_doutb);
                memory_test = 0;
                break;
            end
            #1;
            validating = 1'b0;
        end
        if(memory_test) begin
            $display("Test #%0d: OK", testN);
        end

        //////////////// TESTING BTPU I/O 1 BRAM ////////////////
        testN = 5;
        memory_test = 1;
        for (int i=0; i < 128; ++i) begin
            btpu_addrb = 32'h40050000 + i*4; //BTPU I/O 1 BRAM base
            @ (posedge clock);
            #1;
            validating = 1'b1;
            if(btpu_doutb != i + 2) begin
                $display("Test #%0d-%0d: FAILED -> btpu_doutb was %0x", testN, i, btpu_doutb);
                memory_test = 0;
                break;
            end
            #1;
            validating = 1'b0;
        end
        if(memory_test) begin
            $display("Test #%0d: OK", testN);
        end
    end
    endtask

    task automatic testBTU_FSM;
    begin
        $display("Testing BTPU FSM...");
        //////////////// TESTING BTPU State Machine ////////////////
        testN = 6;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 0*4; //BTPU CREG base
        rs2_value = 32'b0;
        rs2_value[3] = 1'b0; //Set the BRAM_PORT_SEL_BIT
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[0][3] == 1'b0) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> btpu_creg_tb[0][3] was %0x", testN, btpu_creg_tb[0][3]);
        end
        #1;
        validating = 1'b0;

        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 7*4; //BTPU SIGN_CMP Reg
        rs2_value = 32'd64; 
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[7] == 32'd64) begin
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> btpu_creg_tb[7] was %0x", testN, btpu_creg_tb[7]);
        end
        #1;
        validating = 1'b0;

        testN = 7;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 4*4; //BTPU SIZE Reg
        rs2_value = 32'd2;
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[4] == 32'd2) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> btpu_creg_tb[4] was %0x", testN, btpu_creg_tb[4]);
        end
        #1;
        validating = 1'b0;

        testN = 8;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 5*4; //BTPU ACCUM Number Reg
        rs2_value = 32'd2;
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[5] == 32'd2) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> btpu_creg_tb[5] was %0x", testN, btpu_creg_tb[5]);
        end
        #1;
        validating = 1'b0;
        
        testN = 9;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 1*4; //BTPU W ADDR Reg
        rs2_value = 32'b0;
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[1] == 32'b0) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> btpu_creg_tb[1] was %0x", testN, btpu_creg_tb[1]);
        end
        #1;
        validating = 1'b0;

        testN = 10;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 2*4; //BTPU I/O 0 ADDR Reg
        rs2_value = 32'b0;
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[2] == 32'b0) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> btpu_creg_tb[2] was %0x", testN, btpu_creg_tb[2]);
        end
        #1;
        validating = 1'b0;

        testN = 11;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 3*4; //BTPU I/O 1 ADDR Reg
        rs2_value = 32'd5;
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[3] == 32'd5) begin
            $display("Test #%0d: OK", testN);
        end else begin
            $display("Test #%0d: FAILED -> btpu_creg_tb[3] was %0x", testN, btpu_creg_tb[3]);
        end
        #1;
        validating = 1'b0;

        testN = 12;
        op_class = 5'b01000; //Store
        en_in = 1'b1;
        we_in = 1'b1;
        mem_opcode = 3'b010; //SW
        alu_resoult = 32'h40020030 + 0*4; //BTPU CS Reg
        rs2_value = 32'b0;
        rs2_value[0] = 1'b1; //Start
        rs2_value[2] = 1'b1; //Select the BTPU I/O 1 as the output
        rs2_value[5] = 1'b1; //Enable multiple accumulation
        @ (posedge clock);
        #1;
        en_in = 1'b0;
        validating = 1'b1;
        if (btpu_creg_tb[0][0] == 1'b1) begin
            $display("Test #%0da: OK", testN);
        end else begin
            $display("Test #%0da: FAILED -> btpu_creg_tb[0] was %0x", testN, btpu_creg_tb[0]);
        end
        if (btpu_creg_tb[0][2] == 1'b1) begin 
            $display("Test #%0db: OK", testN);
        end else begin
            $display("Test #%0db: FAILED -> btpu_creg_tb[2] was %0x", testN, btpu_creg_tb[2]);
        end
        if (btpu_creg_tb[0][5] == 1'b1) begin 
            $display("Test #%0dc: OK", testN);
        end else begin
            $display("Test #%0dc: FAILED -> btpu_creg_tb[5] was %0x", testN, btpu_creg_tb[3]);
        end
        #1;
        validating = 1'b0;

        @ (posedge clock);
        #1;
        if (btpu_state_tb == fetching) begin
            $display("Test #%0dd: OK", testN);
        end else begin
            $display("Test #%0dd: FAILED -> btpu_state_tb was %0x", testN, btpu_state_tb);
        end
        if(btpu_busy_tb == 1'b1) begin
            $display("Test #%0de: OK", testN);
        end else begin
            $display("Test #%0de: FAILED -> btpu_busy_tb was %0x", testN, btpu_busy_tb);
        end
        // @ (posedge clock);
        // #1;

        if (btpu_creg_tb[0][1] == 1'b1) begin
            $display("Test #%0df: OK", testN);
        end else begin
            $display("Test #%0df: FAILED -> btpu_creg_tb[1] was %0x", testN, btpu_creg_tb[1]);
        end
        if(btpu_creg_tb[6] == 32'd1) begin
            $display("Test #%0dg: OK", testN);
        end else begin
            $display("Test #%0dg: FAILED -> btpu_creg_tb[6] was %0x", testN, btpu_creg_tb[6]);
        end
        #1;
        validating = 1'b0;

        @(btpu_busy_tb == 1'b0);
        #10;

        
    end
    endtask

    initial begin
        @(posedge reset);
        #1;
        // testMemory();
        // testAXI();
        // testGPIO();
        // testI2C();
        // testAXI_BRESP();
        testBTU();
        testBTU_FSM();
        // #100;
        en_in = 1'b0;
        $finish;
    end


endmodule
