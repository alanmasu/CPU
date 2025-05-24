----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2025 05:36:51 PM
-- Design Name: 
-- Module Name: BTPU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;
use work.types_pkg.all;
use work.constant_package.all;
use work.memory_pkg.all;


entity btpu is
    generic (
        ACC_SIZE : integer := 32;
        GRID_SIZE : integer := 32;
        MEM_B_SIZE : integer := 1024;
        MAC_INST_N : integer := 256;
        SIMULATION : boolean := false;
        DEBUG      : boolean := false
    );
    port ( 
        clk : in STD_LOGIC;
        res : in STD_LOGIC;

        hs_clk : in STD_LOGIC;

        -- BRAM Port A
        ena     : in en_bus_t;
        wea     : in STD_LOGIC_VECTOR(3 downto 0);
        addra   : in STD_LOGIC_VECTOR(31 downto 0);
        dina    : in STD_LOGIC_VECTOR(31 downto 0);
        douta   : out STD_LOGIC_VECTOR(31 downto 0);

        -- BRAM Port B
        enb     : in STD_LOGIC;
        web     : in STD_LOGIC_VECTOR(3 downto 0);
        addrb   : in STD_LOGIC_VECTOR(31 downto 0);
        dinb    : in STD_LOGIC_VECTOR(31 downto 0);
        doutb   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end btpu;

architecture Behavioral of btpu is
    constant W_DIM : integer := (GRID_SIZE * GRID_SIZE);
    constant TILES_N : integer := (GRID_SIZE * GRID_SIZE) / MAC_INST_N;
    constant tiles_n_u : unsigned(clog2(TILES_N) - 1 downto 0) := to_unsigned(TILES_N, clog2(TILES_N));
    signal mem_b_size_u : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := to_unsigned(MEM_B_SIZE - 1, clog2(MEM_B_SIZE));
    constant clog2_mem : natural := clog2(MEM_B_SIZE);
    
    signal res0 : std_logic_vector(255 downto 0) := (others => '0');
    signal res1 : std_logic_vector(255 downto 0) := (others => '0');
    signal res2 : std_logic_vector(255 downto 0) := (others => '0');
    signal res3 : std_logic_vector(255 downto 0) := (others => '0');

    -- Matrix Arrays
    type matrix_t   is array (0 to GRID_SIZE  - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    type popcount_t is array (0 to MAC_INST_N - 1) of std_logic_vector(clog2(GRID_SIZE) - 1 downto 0);
    type acc_t      is array (0 to MAC_INST_N - 1) of std_logic_vector(ACC_SIZE - 1 downto 0);
    type mac_input  is array (0 to MAC_INST_N - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);

    type sign_row_t   is array (0 to (MAC_INST_N / GRID_SIZE) - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    

    type inst_choises_t is array (0 to TILES_N - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    type inst_input_t is array (0 to MAC_INST_N - 1) of inst_choises_t;

    signal activations_matrix : matrix_t;
    signal weights_matrix     : matrix_t; 
    signal result_matrix      : matrix_t;

    signal sign_row : sign_row_t;
    
    signal mac_a_in     : mac_input;
    signal mac_b_in     : mac_input;
    signal mac_size_in  : std_logic_vector(ACC_SIZE - 1 downto 0);
    signal mac_sign_out : std_logic_vector(MAC_INST_N - 1 downto 0);
    signal mac_res_out  : popcount_t;
    signal mac_acc_out  : acc_t;

    signal mac_inst_activations_choises : inst_input_t;
    signal mac_inst_weights_choises     : inst_input_t;

    -- CREG
    signal control_reg : BTPU_regFile_t;
    
    
    -- FSM Signals
    signal state : BTPU_state_t := IDLE;
    signal start : std_logic := '0';
    signal busy  : std_logic := '0';
    signal err   : std_logic := '0';
    signal weigth_word      : STD_LOGIC_VECTOR(W_DIM - 1 downto 0) := (others => '0');
    signal activaction_word : STD_LOGIC_VECTOR(W_DIM - 1 downto 0) := (others => '0');
    signal result_word      : STD_LOGIC_VECTOR(W_DIM - 1 downto 0) := (others => '0');
    signal tile_number      : unsigned(clog2(TILES_N) - 1 downto 0) := (others => '0');
    signal addr_w_base      : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal addr_i_base      : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal addr_o_base      : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal m                : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal n                : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal k                : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal is_batched       : std_logic := '0';
    -- DBG
    signal i_s              : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal c_s              : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
    signal r_s              : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
     -- Memories signals
        signal bram_i_addr  : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
        signal bram_o_addr  : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
        signal bram_i_en    : std_logic := '0';
        signal bram_o_en    : std_logic := '0';
        signal bram_o_we    : std_logic := '0';
     -- CREG + Others signals
        signal addr_w_base_reg : unsigned(clog2(MEM_B_SIZE) - 1 downto 0);
        signal addr_i_base_reg : unsigned(clog2(MEM_B_SIZE) - 1 downto 0);
        signal addr_o_base_reg : unsigned(clog2(MEM_B_SIZE) - 1 downto 0);
        signal m_reg : unsigned(clog2(MEM_B_SIZE) - 1 downto 0);
        signal n_reg : unsigned(clog2(MEM_B_SIZE) - 1 downto 0);
        signal k_reg : unsigned(clog2(MEM_B_SIZE) - 1 downto 0);
        signal o_mem_select : std_logic := '0';
        signal bram_port_sel: std_logic := '0';  
        signal acc_clear    : std_logic := '0';
        signal acc_en       : std_logic := '0';
        signal force_acc_clear : std_logic := '0';

    -- BRAMs      LS Interface signals 
        signal bram_addra : std_logic_vector(14 downto 0) := (others => '0');
        signal bram_dina  : std_logic_vector(31 downto 0) := (others => '0');
        signal bram_wea   : std_logic_vector(0 downto 0) := (others => '0');
        
        signal bram_w_ena   : std_logic := '0';
        signal bram_w_douta : std_logic_vector(31 downto 0) := (others => '0');

        signal bram_IO0_ena   : std_logic := '0';
        signal bram_IO0_douta : std_logic_vector(31 downto 0) := (others => '0');

        signal bram_IO1_ena   : std_logic := '0';
        signal bram_IO1_douta : std_logic_vector(31 downto 0) := (others => '0');

        signal creg_out       : std_logic_vector(31 downto 0) := (others => '0');

    -- BRAM   W   HS Interface signals
        signal bram_w_addrb : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
        signal bram_w_dinb  : std_logic_vector(W_DIM - 1 downto 0) := (others => '0');
        signal bram_w_enb   : std_logic := '0';
        -- Always DISABLED ----- signal bram_w_web   : std_logic_vector(0 downto 0) := (others => '0');
        -- as output we use the weight_word signal    

    -- BRAM I/O 0 HS Interface signals
        signal bram_IO0_addrb : std_logic_vector(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
        signal bram_IO0_dinb  : std_logic_vector(W_DIM - 1 downto 0) := (others => '0');
        signal bram_IO0_enb   : std_logic := '0';
        signal bram_IO0_web   : std_logic_vector(0 downto 0) := (others => '0');
        signal bram_IO0_doutb : std_logic_vector(W_DIM - 1 downto 0) := (others => '0');

    -- BRAM I/O 1 HS Interface signals
        signal bram_IO1_addrb : std_logic_vector(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
        signal bram_IO1_dinb  : std_logic_vector(W_DIM - 1 downto 0) := (others => '0');
        signal bram_IO1_enb   : std_logic := '0';
        signal bram_IO1_web   : std_logic_vector(0 downto 0) := (others => '0');
        signal bram_IO1_doutb : std_logic_vector(W_DIM - 1 downto 0) := (others => '0');

    -- BTPU_memory Component
        COMPONENT BTPU_memory
            PORT (
                clka : IN STD_LOGIC;
                ena : IN STD_LOGIC;
                wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
                dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                clkb : IN STD_LOGIC;
                enb : IN STD_LOGIC;
                web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
                addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
                dinb : IN STD_LOGIC_VECTOR(1023 DOWNTO 0);
                doutb : OUT STD_LOGIC_VECTOR(1023 DOWNTO 0)
            );
        END COMPONENT;
begin

    -- Instantiation of the   W   BRAM
        w_mem_inst : BTPU_memory
            port map (
                clka => clk,
                ena => bram_w_ena,
                wea => bram_wea,
                addra => bram_addra,
                dina => bram_dina,
                douta => bram_w_douta,

                clkb => hs_clk,
                enb => bram_w_enb,
                web => (others => '0'),
                addrb => std_logic_vector(bram_w_addrb),
                dinb => bram_w_dinb,
                doutb => weigth_word
            );

    -- Instantiation of the I/O 0 BRAM
        IO0_mem_inst : BTPU_memory
            port map (
                clka => clk,
                ena => bram_IO0_ena,
                wea => bram_wea,
                addra => bram_addra,
                dina => bram_dina,
                douta => bram_IO0_douta,

                clkb => hs_clk,
                enb => bram_IO0_enb,
                web => bram_IO0_web,
                addrb => bram_IO0_addrb,
                dinb => bram_IO0_dinb,
                doutb => bram_IO0_doutb
            );
    
    -- Instantiation of the I/O 1 BRAM
        IO1_mem_inst : BTPU_memory
            port map (
                clka => clk,
                ena => bram_IO1_ena,
                wea => bram_wea,
                addra => bram_addra,
                dina => bram_dina,
                douta => bram_IO1_douta,

                clkb => hs_clk,
                enb => bram_IO1_enb,
                web => bram_IO1_web,
                addrb => bram_IO1_addrb,
                dinb => bram_IO1_dinb,
                doutb => bram_IO1_doutb
            );

    --------------- Activation Pop ------------------
        mac_activation_pop : for i in 0 to GRID_SIZE - 1 generate
            constant word_to_bit    : integer := i * 32;
            constant word_from_bit  : integer := word_to_bit + 31;
        begin 
            activations_matrix(i) <= activaction_word(word_from_bit downto word_to_bit);
        end generate ; -- mac_activation_pop

    --------------- Weights Pop ---------------------
        mac_weigths_pop : for col in 0 to GRID_SIZE - 1 generate
            bit_pop : for bit in 0 to GRID_SIZE - 1 generate
                constant bit_from_word : integer := bit * 32 + col;
            begin 
                weights_matrix((GRID_SIZE - 1) - col)((GRID_SIZE - 1) - bit) <= weigth_word(bit_from_word);
            end generate ; -- bit_pop
        end generate ; -- mac_weigths_pop

    --------------- Result Matrix Pop ----------------
        mac_result_m_pop : for i in 0 to GRID_SIZE - 1 generate
            constant word_to_bit    : integer := i * 32;
            constant word_from_bit  : integer := word_to_bit + 31;
        begin 
            result_matrix(i) <= result_word(word_from_bit downto word_to_bit);
        end generate ; -- mac_result_m_pop

    --------------- Sign Rows Pop ----------------
        mac_sign_m_pop : for i in 0 to (MAC_INST_N / GRID_SIZE) - 1 generate
            constant word_to_bit    : integer := i * 32;
            constant word_from_bit  : integer := word_to_bit + 31;
        begin 
            sign_row(i) <= mac_sign_out(word_from_bit downto word_to_bit);
        end generate ; -- mac_result_m_pop

    --------------- MAC Instantiation ---------------
        mac_inst_gen : for inst in 0 to MAC_INST_N - 1 generate
            mac_inst : entity work.btpu_mac
                generic map (
                    X => GRID_SIZE,
                    ACC_SIZE => ACC_SIZE,
                    TILES_N => TILES_N,

                    SIMULATION => SIMULATION
                )
                port map (
                    acc_clk  => clk,
                    acc_res  => res,
                    acc_resn => acc_clear,
                    en       => acc_en,
                    a        => mac_a_in(inst),
                    b        => mac_b_in(inst),
                    tile_n   => tile_number,
                    size     => mac_size_in,
                    res_sign => mac_sign_out(inst), 
                    res      => mac_res_out(inst),
                    acc      => mac_acc_out(inst)
                );
        end generate ; -- mac_inst_gen
    --------------- Tile Selection ------------------
        populate_inst_choises : for inst in 0 to MAC_INST_N - 1 generate
            tile_for : for tile in 0 to TILES_N - 1 generate
                constant inst_number : integer := inst + tile * MAC_INST_N;
                constant tile_row    : integer := inst_number / GRID_SIZE;
                constant tile_col    : integer := inst_number mod GRID_SIZE;
            begin
                mac_inst_activations_choises(inst)(tile) <= activations_matrix(tile_row);
                mac_inst_weights_choises(inst)(tile)     <= weights_matrix(tile_col);
                process begin
                    if DEBUG then
                        report "mac_inst_activations_choises(" & integer'image(inst) & ")(" & integer'image(tile) & ") <= activations_matrix(" & integer'image(tile_row) & ")";
                        report "mac_inst_weights_choises    (" & integer'image(inst) & ")(" & integer'image(tile) & ") <= weights_matrix(" & integer'image(tile_col) & ")";
                    end if;
                    wait;
                end process;
            end generate; -- tile_for
        end generate; -- populate_inst_choises

        inst_for : for inst in 0 to MAC_INST_N - 1 generate
            mac_a_in(inst) <= mac_inst_activations_choises(inst)(to_integer(tile_number));
            mac_b_in(inst) <= mac_inst_weights_choises(inst)(to_integer(tile_number));
        end generate; -- inst_for
        
    --------------- Result Pop ----------------------
        result_pop : for inst in 0 to MAC_INST_N - 1 generate
            tile_for : for tile in 0 to TILES_N - 1 generate
                constant inst_number : integer := inst + tile * MAC_INST_N;
                constant tile_row    : integer := inst_number / GRID_SIZE;
                constant tile_col    : integer := inst_number mod GRID_SIZE;
                constant bit_n       : integer := tile_row * GRID_SIZE + (31 - tile_col);
            begin
                result_bit_reg : process( clk, res )
                begin
                    if rising_edge(clk) then
                        result_word(bit_n) <= result_word(bit_n);
                        if res = '0' then
                            result_word(bit_n) <= '0';
                        elsif unsigned(tile_number) = to_unsigned(tile, tile_number'length) then
                            result_word(bit_n) <= mac_sign_out(inst);
                        end if;
                    end if; 
                end process ; -- result_bit_reg
                process begin
                    if DEBUG then
                        report "connected result_word(" & integer'image(bit_n) & ") <= mac_sign_out(" & integer'image(inst) & ") when unsigned(tile_number) = " & integer'image(tile);
                    end if;
                    wait;
                end process;
            end generate; -- tile_for
        end generate; -- result_pop
    --------------- Control Register File -----------
        start           <= control_reg(BTPU_REG_CONTROL)(BTPU_CREG_START_BIT);
        o_mem_select    <= control_reg(BTPU_REG_CONTROL)(BTPU_CREG_OMEM_SEL_BIT);
        bram_port_sel   <= control_reg(BTPU_REG_CONTROL)(BTPU_CREG_BRAM_PORT_SEL_BIT);
        acc_clear       <= (not control_reg(BTPU_REG_CONTROL)(BTPU_CREG_ACC_CLEAR_BIT)) and (not force_acc_clear);
        mac_size_in     <= control_reg(BTPU_SIGN_CMP);
        addr_w_base_reg  <= unsigned(control_reg(BTPU_W_ADDR)(clog2(MEM_B_SIZE) - 1 downto 0));
        addr_i_base_reg  <= unsigned(control_reg(BTPU_I_ADDR)(clog2(MEM_B_SIZE) - 1 downto 0));
        addr_o_base_reg  <= unsigned(control_reg(BTPU_O_ADDR)(clog2(MEM_B_SIZE) - 1 downto 0));
        m_reg <= unsigned(control_reg(BTPU_M_SIZE)(clog2(MEM_B_SIZE) - 1 downto 0));    
        n_reg <= unsigned(control_reg(BTPU_N_SIZE)(clog2(MEM_B_SIZE) - 1 downto 0));
        k_reg <= unsigned(control_reg(BTPU_K_SIZE)(clog2(MEM_B_SIZE) - 1 downto 0));

        -- control_reg(BTPU_REG_CONTROL)(BTPU_CREG_BUSY_BIT) <= busy;
        -- control_reg(BTPU_STATUS) <= std_logic_vector(to_unsigned(BTPU_state_t'POS(state), 32));

        control_reg_file : process( clk, res) is 
            variable reg_addr : integer;
            variable address : unsigned(31 downto 0);
        begin
            if(res = '0') then
                control_reg <= (
                    others => (others => '0')
                );
            elsif(rising_edge(clk)) then
                if(ena.en_BTPU_CREG = '1') then
                    address := unsigned(addra) - BTPU_CREG_OFFSET;
                    reg_addr := to_integer(address(6 downto 2));
                    if (wea(0) = '1') then
                        control_reg(reg_addr)(7 downto 0) <= dina(7 downto 0);
                    end if;
                    if (wea(1) = '1') then
                        control_reg(reg_addr)(15 downto 8) <= dina(15 downto 8);
                    end if;
                    if (wea(2) = '1') then
                        control_reg(reg_addr)(23 downto 16) <= dina(23 downto 16);
                    end if;
                    if (wea(3) = '1') then
                        control_reg(reg_addr)(31 downto 24) <= dina(31 downto 24);
                    end if;
                    case reg_addr is
                        when BTPU_REG_CONTROL =>
                            creg_out <= control_reg(reg_addr);
                            creg_out(BTPU_CREG_BUSY_BIT) <= busy;
                            creg_out(BTPU_CREG_ERROR_BIT) <= err;
                        when BTPU_STATUS =>
                            creg_out <= std_logic_vector(to_unsigned(BTPU_state_t'POS(state), 32));
                        when others =>
                            creg_out <= control_reg(reg_addr);
                    end case;
                end if;
                if start = '1' then
                    control_reg(BTPU_REG_CONTROL)(BTPU_CREG_START_BIT) <= '0';
                end if ;
                
                if control_reg(BTPU_REG_CONTROL)(BTPU_CREG_ACC_CLEAR_BIT) = '1' then
                    control_reg(BTPU_REG_CONTROL)(BTPU_CREG_ACC_CLEAR_BIT) <= '0';
                end if ;

                control_reg(BTPU_REG_CONTROL)(BTPU_CREG_BUSY_BIT)  <= busy;
                control_reg(BTPU_REG_CONTROL)(BTPU_CREG_ERROR_BIT) <= err;
                control_reg(BTPU_STATUS) <= std_logic_vector(to_unsigned(BTPU_state_t'POS(state), 32));
            end if;
        end process;
    
    --------------- BRAM Port Selector --------------
        bram_addra <= addra(16 downto 2)    when bram_port_sel = '0' else addrb(16 downto 2);
        bram_dina  <= dina                  when bram_port_sel = '0' else dinb;
        bram_wea   <= wea(0 downto 0)       when bram_port_sel = '0' else web(0 downto 0);

        bram_w_ena <= ena.en_BTPU_W_MEM     when bram_port_sel = '0' else 
                    '1'                     when is_in_space(addrb, BTPU_W_MEM) = '1' else
                    '0';
        bram_IO0_ena <= ena.en_BTPU_IO0_MEM when bram_port_sel = '0' else 
                    '1'                     when is_in_space(addrb, BTPU_IO0_MEM) = '1' else
                    '0';
        bram_IO1_ena <= ena.en_BTPU_IO1_MEM when bram_port_sel = '0' else
                    '1'                     when is_in_space(addrb, BTPU_IO1_MEM) = '1' else
                    '0';

    --------------- DOUT Selector -------------------
        douta <= bram_w_douta   when ena.en_BTPU_W_MEM  = '1' else
                 bram_IO0_douta when ena.en_BTPU_IO0_MEM = '1' else
                 bram_IO1_douta when ena.en_BTPU_IO1_MEM = '1' else
                 creg_out       when ena.en_BTPU_CREG    = '1' else
                 (others => '0'); 

        doutb <= bram_w_douta     when bram_w_ena    = '1' else
                 bram_IO0_douta   when bram_IO0_ena  = '1' else
                 bram_IO1_douta   when bram_IO1_ena  = '1' else
                 creg_out         when is_in_space(addrb, BTPU_CREG_FILE) = '1' else
                 (others => '0');

    --------------- I/O Memory Selector -------------
        bram_IO0_addrb <= std_logic_vector(bram_i_addr) when o_mem_select = '1' else std_logic_vector(bram_o_addr); 
        bram_IO1_addrb <= std_logic_vector(bram_o_addr) when o_mem_select = '1' else std_logic_vector(bram_i_addr);
        
        bram_IO0_dinb  <= (others => '0') when o_mem_select = '1' else result_word;
        bram_IO1_dinb  <= result_word     when o_mem_select = '1' else (others => '0');

        bram_IO0_enb   <= bram_i_en when o_mem_select = '1' else bram_o_en;
        bram_IO1_enb   <= bram_o_en when o_mem_select = '1' else bram_i_en;

        bram_IO0_web   <= (others => '0')       when o_mem_select = '1' else (others => bram_o_we);
        bram_IO1_web   <= (others => bram_o_we) when o_mem_select = '1' else (others => '0');

        activaction_word <= bram_IO0_doutb when o_mem_select = '1' else bram_IO1_doutb;

    --------------- State Machine -------------------
        state_machine : process( hs_clk, res) is
            variable i : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
            variable c : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
            variable r : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
            variable address_tmp : unsigned((clog2(MEM_B_SIZE) * 2) - 1 downto 0) := (others => '0');
        begin
            if res = '0' then
                state <= IDLE;
                bram_w_enb   <= '0';
                bram_i_en <= '0';
                bram_o_en <= '0';
                bram_o_we <= '0';
            elsif rising_edge(hs_clk) then
                force_acc_clear <= '0';
                bram_w_enb <= '0';
                bram_i_en  <= '0';
                bram_o_en  <= '0';
                bram_o_we  <= '0';
                bram_w_enb <= '0';
                acc_en     <= '0';
                case state is
                    when IDLE =>
                        busy <= '0';
                        if start = '1' then
                            err <= '0';
                            busy <= '1';
                            bram_w_enb <= '1';
                            bram_i_en  <= '1';
                            r := (others => '0');
                            c := (others => '0');
                            i := (others => '0');
                            is_batched   <= control_reg(BTPU_REG_CONTROL)(BTPU_CREG_BATCHED_MUL_BIT);
                            addr_w_base  <= addr_w_base_reg;
                            addr_i_base  <= addr_i_base_reg;
                            addr_o_base  <= addr_o_base_reg;
                            m <= m_reg;
                            n <= n_reg;
                            k <= k_reg;
                            state <= FETCHING;
                            if addr_w_base_reg > mem_b_size_u -1 or addr_i_base_reg > mem_b_size_u -1 or addr_o_base_reg > mem_b_size_u -1 then
                                err <= '1';
                                busy <= '0';
                                state <= IDLE;
                            end if;
                            if m * n > mem_b_size_u or n * k > mem_b_size_u or m * k > mem_b_size_u then
                                err <= '1';
                                busy <= '0';
                                state <= IDLE;
                            end if;
                        end if;
                    when FETCHING =>
                        busy <= '1';
                        bram_o_en  <= '0';
                        tile_number <= (others => '0');
                        acc_en <= '1';
                        state <= EXECUTE;
                    when EXECUTE =>
                        busy <= '1';
                        acc_en <= '1';
                        tile_number <= tile_number + 1;
                        if tile_number = tiles_n_u - 1 then
                            if is_batched = '0' then
                                bram_o_en  <= '1';
                                bram_o_we  <= '1';
                                acc_en <= '0';
                                state <= WRITE_BACK;
                            elsif is_batched = '1' then
                                if i < n - 1 then
                                    i := i + 1;
                                    bram_w_enb <= '1';
                                    bram_i_en  <= '1';
                                    acc_en <= '0';
                                    state <= FETCHING;
                                else 
                                    bram_o_en  <= '1';
                                    bram_o_we  <= '1';
                                    acc_en <= '0';
                                    state <= WRITE_BACK;
                                end if;
                            else 
                                err <= '1';
                                acc_en <= '0';
                                state <= IDLE;
                            end if;
                        end if;
                    when WRITE_BACK =>
                        busy <= '1';
                        if is_batched = '0' then
                            state <= IDLE;
                        elsif is_batched = '1' then
                            force_acc_clear <= '1';
                            state <= CLEAR_ACC;
                            i := (others => '0');
                            if c < k - 1 then
                                c := c + 1;
                                bram_w_enb <= '1';
                                bram_i_en  <= '1';
                            elsif r < m - 1 then
                                r := r + 1;
                                c := (others => '0');
                                bram_w_enb <= '1';
                                bram_i_en  <= '1';
                            else 
                                force_acc_clear <= '0';
                                state <= IDLE;
                            end if;
                        else
                            err <= '1';
                            state <= IDLE;
                        end if;
                    when CLEAR_ACC =>
                        busy <= '1';
                        tile_number <= (others => '0');
                        force_acc_clear <= '0';
                        acc_en <= '1';
                        state <= EXECUTE;               
                    when others =>
                        state <= IDLE;
                end case;
                i_s <= i;
                c_s <= c;
                r_s <= r;
                address_tmp := addr_w_base + i * k + c;
                bram_w_addrb <= address_tmp(clog2(MEM_B_SIZE) - 1 downto 0);

                address_tmp := addr_i_base + r * n + i;
                bram_i_addr  <= address_tmp(clog2(MEM_B_SIZE) - 1 downto 0);

                address_tmp := addr_o_base + r * k + c;
                bram_o_addr  <= address_tmp(clog2(MEM_B_SIZE) - 1 downto 0);
            end if ;
        end process ; -- state_machine

    --------------- Debug Signals -----------------
        res0 <= result_word(255 downto 0);
        res1 <= result_word(511 downto 256);
        res2 <= result_word(767 downto 512);
        res3 <= result_word(1023 downto 768);
end Behavioral;
