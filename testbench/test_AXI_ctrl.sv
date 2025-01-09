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
        test_type = MEMORY;
        op_class = 5'b01000;
        en_in = 1'b1;
        we_in = 1'b1;
        //Scrive 4 WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b010; //SW
        rs2_value = 32'd274877688;
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i; 
            #10;
        end

        //Scrive 4 HALF WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b001; //SH
        rs2_value = 32'd35535;
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i + 16; 
            #10;
        end

        //Scrive 4 BYTE shiftate di un byte ciascuna
        mem_opcode = 3'b000; //SB
        rs2_value = 32'd207;
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i + 32; 
            #10;
        end

        //Load
        op_class = 5'b00100;
        en_in = 1'b1;
        we_in = 1'b0;
        //Carica 4 WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b010; //LW
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i; 
            #10;
        end

        //Carica 4 HALF WORDS shiftate di un byte ciascuna
        mem_opcode = 3'b001; //LH
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i + 16; 
            #10;
        end

        mem_opcode = 3'b101; //LHU
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i + 16; 
            #10;
        end

        //Carica 4 BYTE shiftate di un byte ciascuna
        mem_opcode = 3'b000; //LB
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i + 32; 
            #10;
        end

        mem_opcode = 3'b100; //LBU
        for(int i = 0; i <= 3; i++) begin
            alu_resoult = 32'h40010000 + i*4 + i + 32; 
            #10;
        end

        #10;

        ///////////////////// AXI TESTS /////////////////////////
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
        wait (clock == 1'b0) wait (clock == 1'b1) ; //Sychronize with the clock
        #9;

        test_type = GPIO;
        op_class = 5'b01000;    //Need a Store opration for using the GPIO
        en_in = 1'b1;           
        we_in = 1'b1;

          //Setto i GPIO in input
        mem_opcode = 3'b010; //SW
        rs2_value = 32'b0;
        alu_resoult = 32'h40020004; //Indirizzo reg. GPIO_dir
        gpio_pins = 32'h00000000;
        if (gpio_pins_wire == 32'h00000000) begin
            $display("GPIO INPUT 1 test OK");
        end else begin
            $display("GPIO INPUT 1 test FAILED");
        end
        #10;
        
        gpio_pins = 32'hffffffff;
        #2;
        if (gpio_pins_wire == 32'hffffffff) begin
            $display("GPIO INPUT 2 test OK");
        end else begin
            $display("GPIO INPUT 2 test FAILED");
        end
        #8;

        //Setto la direzione dei GPIO (ed i GPIO andranno a LOW per default)
        mem_opcode = 3'b010;            //SW
        rs2_value = '1;                 //Tutti a 1
        alu_resoult = 32'h40020004;     //Indirizzo reg. GPIO_dir
        gpio_pins = 'z;                 //Rilascio i GPIO dal testbench (tutti in alta impedenza)
        #10;
        if (gpio_pins_wire == 32'h00000000) begin
            $display("GPIO OUTPUT 1 test OK");
        end else begin
            $display("GPIO OUTPUT 1 test FAILED");
        end

        //Setto tutti GPIO
        mem_opcode = 3'b010;            //SW
        rs2_value = '1;                 //Tutti a 1
        alu_resoult = 32'h40020008;     //Indirizzo reg. GPIO_reg
        #10;
        if (gpio_pins_wire == 32'hffffffff) begin
            $display("GPIO OUTPUT 2 test OK");
        end else begin
            $display("GPIO OUTPUT 2 test FAILED");
        end

        #100;
        en_in = 1'b0;



        $finish;

    end


endmodule
