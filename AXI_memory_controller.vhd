library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_memory_controller is
	generic (
		-- Users to add parameters here
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- The master will start generating data from the C_M_START_DATA_VALUE value
		C_M_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		-- The master requires a target slave base address.
    	-- The master will initiate read and write transactions on the slave with base address specified here as a parameter.
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		-- Width of M_AXI address bus. 
    	-- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		-- Width of M_AXI data bus. 
    	-- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		-- Transaction number is the number of write 
    	-- and read transactions the master will perform as a part of this example memory test.
		C_M_TRANSACTIONS_NUM	: integer	:= 4
	);
	port (
		-- Users to add ports here
		en : in std_logic;
		we : in std_logic_vector(3 downto 0);
		address, write_data : in std_logic_vector(31 downto 0);
		read_data : out std_logic_vector(31 downto 0);
		stall : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- AXI clock signal
		M_AXI_ACLK	: in std_logic;
		-- AXI active low reset signal
		M_AXI_ARESETN	: in std_logic;
		-- Master Interface Write Address Channel ports. Write address (issued by master)
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type.
		-- This signal indicates the privilege and security level of the transaction,
		-- and whether the transaction is a data access or an instruction access.
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		-- Write address valid. 
    	-- This signal indicates that the master signaling valid write address and control information.
		M_AXI_AWVALID	: out std_logic;
		-- Write address ready. 
    	-- This signal indicates that the slave is ready to accept an address and associated control signals.
		M_AXI_AWREADY	: in std_logic;
		-- Master Interface Write Data Channel ports. Write data (issued by master)
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. 
    	-- This signal indicates which byte lanes hold valid data.
    	-- There is one write strobe bit for each eight bits of the write data bus.
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		-- Write valid. This signal indicates that valid write data and strobes are available.
		M_AXI_WVALID	: out std_logic;
		-- Write ready. This signal indicates that the slave can accept the write data.
		M_AXI_WREADY	: in std_logic;
		-- Master Interface Write Response Channel ports. 
    	-- This signal indicates the status of the write transaction.
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		-- Write response valid. 
    	-- This signal indicates that the channel is signaling a valid write response
		M_AXI_BVALID	: in std_logic;
		-- Response ready. This signal indicates that the master can accept a write response.
		M_AXI_BREADY	: out std_logic;
		-- Master Interface Read Address Channel ports. Read address (issued by master)
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. 
    	-- This signal indicates the privilege and security level of the transaction, 
    	-- and whether the transaction is a data access or an instruction access.
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		-- Read address valid. 
    	-- This signal indicates that the channel is signaling valid read address and control information.
		M_AXI_ARVALID	: out std_logic;
		-- Read address ready. 
    	-- This signal indicates that the slave is ready to accept an address and associated control signals.
		M_AXI_ARREADY	: in std_logic;
		-- Master Interface Read Data Channel ports. Read data (issued by slave)
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the read transfer.
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is signaling the required read data.
		M_AXI_RVALID	: in std_logic;
		-- Read ready. This signal indicates that the master can accept the read data and response information.
		M_AXI_RREADY	: out std_logic
	);
end AXI_memory_controller;

architecture implementation of AXI_memory_controller is

	-- function called clogb2 that returns an integer which has the
	-- value of the ceiling of the log base 2
	function clogb2 (bit_depth : integer) return integer is            
	 	variable depth  : integer := bit_depth;                               
	 	variable count  : integer := 1;                                       
	begin                                                                   
		for clogb2 in 1 to bit_depth loop  -- Works for up to 32 bit integers
			if (bit_depth <= 2) then                                           
				count := 1;                                                      
			else                                                               
				if(depth <= 1) then                                              
				count := count;                                                
				else                                                             
				depth := depth / 2;                                            
				count := count + 1;                                            
				end if;                                                          
			end if;                                                            
		end loop;                                                             
		return(count);        	                                              
	end;                                                                    

	-- Example user application signals

	-- TRANS_NUM_BITS is the width of the index counter for
	-- number of write or read transaction..
	constant  TRANS_NUM_BITS  : integer := clogb2(C_M_TRANSACTIONS_NUM-1);

	type read_state_t is (idle, write_addr, waiting, writeback, wait_return);
	type write_state_t is(idle, write, wait_end, wait_return);
	signal read_state :	 read_state_t;
	signal awrite_state, dwrite_state : write_state_t;

	-- AXI4LITE signals
	--write address valid
	signal axi_awvalid	: std_logic;
	--write data valid
	signal axi_wvalid	: std_logic;
	--write data byte enables
	signal axi_wstrb	: std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
	--read address valid
	signal axi_arvalid	: std_logic;
	--read data acceptance
	signal axi_rready	: std_logic;
	--write response acceptance
	signal axi_bready	: std_logic;
	--write address
	signal axi_awaddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	--write data
	signal axi_wdata	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
	--read addresss
	signal axi_araddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
	--END AXI4LITE
	
	--Write MFS sync signals
	signal awrite_end, dwrite_end : std_logic;

	signal read_response, write_response: std_logic_vector(1 downto 0);

	signal stall_int : std_logic;

begin
	-- I/O Connections assignments

	--Adding the offset address to the base addr of the slave
	M_AXI_AWADDR	<= std_logic_vector (unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_awaddr));
	--AXI 4 write data
	M_AXI_WDATA		<= axi_wdata;
	M_AXI_AWPROT	<= "000";
	M_AXI_AWVALID	<= axi_awvalid;
	--Write Data(W)
	M_AXI_WVALID	<= axi_wvalid;
	--Set all byte strobes in this example
	M_AXI_WSTRB		<= axi_wstrb;
	--Write Response (B)
	M_AXI_BREADY	<= axi_bready;
	--Read Address (AR)
	M_AXI_ARADDR	<= std_logic_vector(unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_araddr));
	M_AXI_ARVALID	<= axi_arvalid;
	M_AXI_ARPROT	<= "001";
	--Read and Read Response (R)
	M_AXI_RREADY	<= axi_rready;

	stall <= stall_int;
                                    
    --Signal to indicate that the values are not ready                                
    --stall <= '0' when read_state = idle and awrite_state = idle and dwrite_state = idle else '1';
    stall_pro : process( M_AXI_ACLK, M_AXI_ARESETN ) begin
		if M_AXI_ARESETN = '0' then
			stall_int <= '0';
		elsif rising_edge(M_AXI_ACLK) then
			if stall_int = '0' then
				stall_int <= en;
			elsif stall_int = '1' then
				if read_state = idle and awrite_state = idle and dwrite_state = idle then
					stall_int <= '0';
				end if ;
			end if ;
		end if ;
		
	end process ; -- stall_pro
	

	-- Add user logic here
	read_process : process( M_AXI_ACLK )
	begin
		if rising_edge(M_AXI_ACLK) then
			axi_arvalid <= '0';
			axi_rready <= '0';
			read_response <= (others => '0');
			read_data <= (others => '0');

			if M_AXI_ARESETN = '0' then
				read_state <= idle;
			else
				case( read_state ) is
					when IDLE =>
						if en = '1' and we = "0000" and stall_int = '0' then
							read_state <= write_addr;
						end if ;	
					when write_addr => 
						axi_araddr <= address;
						axi_arvalid <= '1';	
						if M_AXI_ARREADY = '1' then
							read_state <= waiting;
						end if ;	
					when waiting =>
						if M_AXI_RVALID = '1' then
							read_state <= writeback;
						end if ;
					when writeback => 
						read_data <= M_AXI_RDATA;
						axi_rready <= '1';
						read_response(1 downto 0) <= M_AXI_RRESP;
						read_state <= idle;
					when wait_return =>  --[DEPRECATED]
						if en = '0' then
							read_state <= idle;
						end if ;
				end case ;
			end if ;
		end if ;
	end process ; -- read_process

	awrite_process : process( M_AXI_ACLK )
	begin
		if rising_edge(M_AXI_ACLK) then
			if M_AXI_ARESETN = '0' then
				axi_awaddr <= (others => '0');
				axi_awvalid <= '0';
				awrite_end <= '0';
				awrite_state <= idle;
			else
				axi_awvalid <= '0';
				awrite_state <= awrite_state;
				awrite_end <= '0';

				case( awrite_state ) is
					when IDLE =>
						if en = '1' and we /= "0000" and stall_int = '0' then
							awrite_state <= write;
						end if ;	
					when write => 
						axi_awaddr <= address;
						axi_awvalid <= '1';
						if(M_AXI_AWREADY = '1')	then
							awrite_state <= wait_end;	
						end if ;
					when wait_end =>
					   	awrite_end <= '1';
						if dwrite_end = '1' then
							awrite_state <= idle;
						end if ;
					when wait_return => --[DEPRECATED]
						if en = '0' then
							awrite_state <= idle;
						end if ;						
				end case ;
			end if ;
		end if ;
		
	end process ; -- awrite_process

	dwrite_process : process( M_AXI_ACLK )
	begin
		if rising_edge(M_AXI_ACLK) then
			if M_AXI_ARESETN = '0' then
				axi_wdata <= (others => '0');
				axi_wvalid <= '0';
				dwrite_end <= '0';
				dwrite_state <= idle;
			else
				axi_wvalid <= '0';
				dwrite_state <= dwrite_state;
				dwrite_end <= '0';

				case( dwrite_state ) is
					when IDLE =>
						if en = '1' and we /= "0000" and stall_int = '0' then
							dwrite_state <= write;
						end if ;	
					when write => 
						axi_wdata <= write_data;
						axi_wvalid <= '1';
						if M_AXI_WREADY = '1' then
							dwrite_state <= wait_end;
						end if ;
					when wait_end =>
					   dwrite_end <= '1';
						if awrite_end = '1' then
							dwrite_state <= idle;
						end if ;
					when wait_return => 	--[DEPRECATED]
						if en = '0' then
							dwrite_state <= idle;
						end if ;						
				end case ;
			end if ;
		end if ;
	end process ; -- dwrite_process
	
	bresp_process : process(M_AXI_ACLK)
	begin
		if rising_edge(M_AXI_ACLK) then
            axi_bready <= '0';
            write_response <= (others => '0');
			if M_AXI_ARESETN = '0' then
				axi_bready <= '0';
				write_response <= (others => '0');
			else
				axi_bready <= '0';
				if M_AXI_BVALID = '1' then
					write_response(1 downto 0) <= M_AXI_BRESP;
					axi_bready <= '1';
				end if ;
			end if ;
		end if ;
	end process ; -- bresp_process
	-- User logic ends

end implementation;
