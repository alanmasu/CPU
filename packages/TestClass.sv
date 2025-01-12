import types_pkg::*;
import axi_vip_pkg::*;
import test_design_axi_vip_0_3_pkg::*;
import test_design_axi_vip_1_0_pkg::*;


package test_pkg;
  class TestClass;

    //FOR AXI VIP
    local xil_axi_uint                            mtestID;  
    local xil_axi_ulong                           mtestADDR;  
    local xil_axi_len_t                           mtestBurstLength;  
    local xil_axi_size_t                          mtestDataSize;   
    local xil_axi_burst_t                         mtestBurstType;   
    local xil_axi_lock_t                          mtestLOCK;  
    local xil_axi_cache_t                         mtestCacheType = 0;  
    local xil_axi_prot_t                          mtestProtectionType = 3'b000;  
    local xil_axi_region_t                        mtestRegion = 4'b000;  
    local xil_axi_qos_t                           mtestQOS = 4'b000; 
    local xil_axi_resp_t                          mtestBresp;  
    local xil_axi_resp_t[255:0]                   mtestRresp;  
    local bit [63:0]                              mtestWDataL; 
    local bit [63:0]                              mtestRDataL; 
    local test_design_axi_vip_0_3_mst_t mst_agent_0;

    function automatic void init(test_design_axi_vip_0_3_mst_t mst_agent_0);
      this.mst_agent_0 = mst_agent_0;
    endfunction
    

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

    task automatic doQueuedTests ();
      logic testPassed = 0;
      string message;
    
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

    //Load program
    task automatic loadProgram(input logic [31:0] programma[], output logic on_programming, input logic [31:0] addr = 32'h40000000);
      integer i;
      logic testPassed = 0;
      string message;
      begin
        #1;
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
          mtestADDR[31:0] = addr + i * 4;
          mst_agent_0.AXI4LITE_WRITE_BURST(
            mtestADDR,
            mtestProtectionType, 
            mtestWDataL, 
            mtestBresp 
          );
          // $display("Wrote data: %h to address: %h", programma[i], BASE_ADDR + i * 4);
        end
        on_programming = 1'b0;
      end
    endtask
  endclass
endpackage