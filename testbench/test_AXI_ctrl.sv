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

import memory_pkg::*;

module test_AXI_ctrl( );
    //Type definitions
    typedef struct packed {
        logic en_mem;
        logic en_AXI;
        logic en_GPIO;
    } en_bus_t;

    typedef struct packed {
        bit[31:0] axi_data;
        bit[31:0] GPIO_data;
    } peripheral_data_t;

    typedef enum {SETUP, ALU, MEMORY, AXI, GPIO } test_type_t;
        

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
    en_bus_t en_out = '{en_mem: 1'b0, en_AXI: 1'b0, en_GPIO: 1'b0};
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

    //Master vip agent
    axi_transaction                         wr_transaction;   
    axi_transaction                         rd_transaction;   
    axi_monitor_transaction                 slv_monitor_transaction;  
    axi_monitor_transaction                 slave_moniter_transaction_queue[$];  
    xil_axi_uint                            slave_moniter_transaction_queue_size =0;
  
    mem_ctrl_test_axi_vip_0_0_slv_mem_t     slv_mem_t;

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
        .en_0(en_out.en_AXI),
        .we_0(we_out),
        .address_0(address_out),
        .write_data_0(d_out),
        .read_data_0(axi_data_out),
        .stall_0(stall)
    );

    GPIO DUT2(
        .clk(clock),
        .res(reset),
        .address(address_out),
        .d_in(d_out),
        .wea(we_out),
        .ena(en_out.en_GPIO),
        .d_out(gpio_data_out),
        .gpio(gpio_pins_wire)
    );

    assign gpio_pins_wire = gpio_pins;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            pulldown(gpio_pins_wire[i]);  // Pulldown su ogni bit.
        end
    endgenerate
    
    always @(axi_data_out) begin
        d_in.axi_data = axi_data_out;
    end 

    always @(gpio_data_out) begin
        d_in.GPIO_data = gpio_data_out;
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
        #18;
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
    
    initial begin

        #19;

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


        ///////////////////// AXI TESTS /////////////////////////
        @ (posedge clock);
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
            $display("GPIO INPUT 1 test OK");
        end else begin
            $display("GPIO INPUT 1 test FAILED");
        end
        #1;
        validating = 1'b0;
        
        gpio_pins = 32'hffffffff;
        @ (posedge clock);
        #1;
        validating = 1'b1;
        if (gpio_pins_wire == 32'hffffffff) begin
            $display("GPIO INPUT 2 test OK");
        end else begin
            $display("GPIO INPUT 2 test FAILED");
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
            $display("GPIO OUTPUT 1 test OK");
        end else begin
            $display("GPIO OUTPUT 1 test FAILED");
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
            $display("GPIO OUTPUT 2 test OK");
        end else begin
            $display("GPIO OUTPUT 2 test FAILED");
        end
        #1;
        validating = 1'b0;
        #100;
        en_in = 1'b0;



        $finish;

    end


endmodule
