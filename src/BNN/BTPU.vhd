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


entity BTPU is
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
end BTPU;

architecture Behavioral of BTPU is
    constant W_DIM : integer := (GRID_SIZE * GRID_SIZE);
    constant TILES_N : integer := (GRID_SIZE * GRID_SIZE) / MAC_INST_N;
    constant tiles_n_u : unsigned(clog2(TILES_N) - 1 downto 0) := to_unsigned(TILES_N, clog2(TILES_N));

    signal res0 : std_logic_vector(255 downto 0) := (others => '0');
    signal res1 : std_logic_vector(255 downto 0) := (others => '0');
    signal res2 : std_logic_vector(255 downto 0) := (others => '0');
    signal res3 : std_logic_vector(255 downto 0) := (others => '0');

    -- Matrix Arrays
    type matrix_t   is array (0 to GRID_SIZE  - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    type popcount_t is array (0 to MAC_INST_N - 1) of std_logic_vector(clog2(GRID_SIZE) - 1 downto 0);
    type acc_t      is array (0 to MAC_INST_N - 1) of std_logic_vector(ACC_SIZE - 1 downto 0);
    type mac_input  is array (0 to MAC_INST_N - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);

    type inst_choises_t is array (0 to TILES_N - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    type inst_input_t is array (0 to MAC_INST_N - 1) of inst_choises_t;

    signal activations_matrix : matrix_t;
    signal weights_matrix     : matrix_t; 
    
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
    signal weigth_word      : STD_LOGIC_VECTOR(W_DIM - 1 downto 0) := (others => '0');
    signal activaction_word : STD_LOGIC_VECTOR(W_DIM - 1 downto 0) := (others => '0');
    signal result_word      : STD_LOGIC_VECTOR(W_DIM - 1 downto 0) := (others => '0');
    signal tile_number      : unsigned(clog2(TILES_N) - 1 downto 0) := (others => '0');
     -- Memories signals
        signal bram_i_addr  : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
        signal bram_o_addr  : unsigned(clog2(MEM_B_SIZE) - 1 downto 0) := (others => '0');
        signal bram_i_en    : std_logic := '0';
        signal bram_o_en    : std_logic := '0';
        signal bram_o_we    : std_logic := '0';
     -- Status signals
        signal start        : std_logic := '0';
        signal busy         : std_logic := '0';
        signal o_mem_select : std_logic := '0';
        signal bram_port_sel: std_logic := '0';  
        signal acc_clear    : std_logic := '0';
        signal multiple_acc : std_logic := '0';
        signal acc_number   : unsigned(31 downto 0) := (others => '0');
        signal compute_size : unsigned(31 downto 0) := (others => '0');
        signal compute_iteration : unsigned(31 downto 0) := (others => '0');
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
        
        component BTPU_MAC is
            generic (
                X : integer := 32;
                ACC_SIZE : integer := 16;
                SIMULATION : boolean := false
            );
            port ( 
                acc_clk : in STD_LOGIC;
                acc_resn : in STD_LOGIC;
                a : in STD_LOGIC_VECTOR (X - 1 downto 0);
                b : in STD_LOGIC_VECTOR (X - 1 downto 0);
                size : in STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0);
                res_sign : out STD_LOGIC;
                res : out STD_LOGIC_VECTOR (clog2(X) - 1 downto 0);
                acc : out STD_LOGIC_VECTOR (ACC_SIZE - 1 downto 0)
            );
        end component;
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
                weights_matrix(col)(bit) <= weigth_word(bit_from_word);
            end generate ; -- bit_pop
        end generate ; -- mac_weigths_pop

    --------------- MAC Instantiation ---------------
        mac_inst_gen : for inst in 0 to MAC_INST_N - 1 generate
--            behav_gen : if SIMULATION = false generate
                mac_inst : BTPU_MAC
                    generic map (
                        X => GRID_SIZE,
                        ACC_SIZE => ACC_SIZE
                    )
                    port map (
                        acc_clk  => clk,
                        acc_resn => acc_clear,
                        a        => mac_a_in(inst),
                        b        => mac_b_in(inst),
                        size     => mac_size_in,
                        res_sign => mac_sign_out(inst), 
                        res      => mac_res_out(inst),
                        acc      => mac_acc_out(inst)
                    );
--            end generate; -- behav_gen

            -- sim_gen : if SIMULATION = true generate
            --     mac_inst : entity work.BTPU_MAC(SimulationArch)
            --         generic map (
            --             X => GRID_SIZE,
            --             ACC_SIZE => ACC_SIZE
            --         )
            --         port map (
            --             acc_clk  => clk,
            --             acc_resn => acc_clear,
            --             a        => mac_a_in(inst),
            --             b        => mac_b_in(inst),
            --             size     => mac_size_in,
            --             res_sign => mac_sign_out(inst), 
            --             res      => mac_res_out(inst),
            --             acc      => mac_acc_out(inst)
            --         );
            -- end generate; -- sim_gen

        end generate ; -- mac_inst_gen
    --------------- Tile Selection ------------------
        -- tile_selection : process( activations_matrix, weights_matrix, tile_number) is
        --     variable inst_number : integer;
        --     variable tile_row : integer;
        --     variable tile_col : integer;
        -- begin
        --     tile_selector : for inst in 0 to MAC_INST_N - 1 loop
        --         inst_number := inst + to_integer(tile_number) * MAC_INST_N;
        --         tile_row := inst_number / GRID_SIZE;
        --         tile_col := inst_number mod GRID_SIZE;
        --         mac_a_in(inst) <= activations_matrix(tile_row);
        --         mac_b_in(inst) <= weights_matrix(tile_col);
        --     end loop ; -- tile_select
        -- end process ; -- tile_selection

        -- inst_for : for inst in 0 to MAC_INST_N - 1 generate
        --     tile_for : for tile in 0 to TILES_N - 1 generate
        --         constant inst_number : integer := inst + tile * MAC_INST_N;
        --         constant tile_row    : integer := inst_number / GRID_SIZE;
        --         constant tile_col    : integer := inst_number mod GRID_SIZE;
        --     begin
        --         tile_check : if tile = to_integer(tile_number) generate
        --             mac_a_in(inst) <= activations_matrix(tile_row);
        --             mac_b_in(inst) <= weights_matrix(tile_col);
        --         end generate;
        --     end generate; -- tile_for
        -- end generate; -- inst_for

        -- inst_for : for inst in 0 to MAC_INST_N - 1 generate
        --     multiplexer_inst : process( activations_matrix, weights_matrix, tile_number) is
        --         variable inst_number : integer;
        --         variable tile_row : integer;
        --         variable tile_col : integer;
        --     begin
        --         inst_number := inst + to_integer(tile_number) * MAC_INST_N;
        --         tile_row := inst_number / GRID_SIZE;
        --         tile_col := inst_number mod GRID_SIZE;
        --         mac_a_in(inst) <= activations_matrix(tile_row);
        --         mac_b_in(inst) <= weights_matrix(tile_col);
        --     end process ; -- multiplexer_inst
        -- end generate; -- inst_for

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
            multiplexer_inst : process( mac_inst_activations_choises(inst), mac_inst_weights_choises(inst), tile_number) begin
                mac_a_in(inst) <= mac_inst_activations_choises(inst)(to_integer(tile_number));
                mac_b_in(inst) <= mac_inst_weights_choises(inst)(to_integer(tile_number));
            end process ; -- multiplexer_inst
        end generate; -- inst_for
        
    --------------- Result Pop ----------------------
        result_pop : for inst in 0 to MAC_INST_N - 1 generate
            tile_for : for tile in 0 to TILES_N - 1 generate
                constant inst_number : integer := inst + tile * MAC_INST_N;
                constant tile_row    : integer := inst_number / GRID_SIZE;
                constant tile_col    : integer := inst_number mod GRID_SIZE;
                constant bit_n       : integer := tile_row * GRID_SIZE + tile_col;
            begin
                -- result_word(bit_n) <= mac_sign_out(inst) when unsigned(tile_number) = to_unsigned(tile, tile_number'length)
                --                     else 
                --                       result_word(bit_n);

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
        multiple_acc    <= control_reg(BTPU_REG_CONTROL)(BTPU_CREG_MULTIPLE_ACCUM_BIT);
        mac_size_in     <= control_reg(BTPU_SIGN_CMP);

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
                        when BTPU_STATUS =>
                            creg_out <= std_logic_vector(to_unsigned(BTPU_state_t'POS(state), 32));
                        when others =>
                            creg_out <= control_reg(reg_addr);
                    end case;
                end if;
                if start = '1' then
                    control_reg(BTPU_REG_CONTROL)(BTPU_CREG_START_BIT) <= '0';
                end if ;
                control_reg(BTPU_REG_CONTROL)(BTPU_CREG_BUSY_BIT) <= busy;
                control_reg(BTPU_STATUS) <= std_logic_vector(to_unsigned(BTPU_state_t'POS(state), 32));
            end if;
        end process;
    
    --------------- BRAM Port Selector --------------
        bram_addra <= addra(14 downto 0)    when bram_port_sel = '0' else addrb(14 downto 0);
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
        state_machine : process( hs_clk, res) begin
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
                bram_w_enb <= '0';
                case state is
                    when IDLE =>
                        busy <= '0';
                        if start = '1' then
                            busy <= '1';
                            bram_w_enb <= '1';
                            bram_i_en  <= '1';
                            compute_size <= unsigned(control_reg(BTPU_SIZE)) - 1;
                            compute_iteration <= (others => '0');
                            acc_number   <= unsigned(control_reg(BTPU_ACCUM)) - 1;
                            bram_w_addrb <= unsigned(control_reg(BTPU_W_ADDR)(clog2(MEM_B_SIZE) - 1 downto 0));
                            bram_i_addr  <= unsigned(control_reg(BTPU_I_ADDR)(clog2(MEM_B_SIZE) - 1 downto 0));
                            bram_o_addr  <= unsigned(control_reg(BTPU_O_ADDR)(clog2(MEM_B_SIZE) - 1 downto 0));
                            state <= FETCHING;
                        end if;
                    when FETCHING =>
                        busy <= '1';
                        -- bram_w_enb <= '1';
                        -- bram_i_en  <= '1';
                        bram_o_en  <= '0';
                        tile_number <= (others => '0');
                        state <= EXECUTE;
                    when EXECUTE =>
                        busy <= '1';
                        tile_number <= tile_number + 1;
                        if tile_number = tiles_n_u - 1 then
                            bram_w_enb <= '1';
                            bram_i_en  <= '1';
                            tile_number <= (others => '0');
                            bram_w_addrb <= bram_w_addrb + 1;
                            bram_i_addr  <= bram_i_addr  + 1;
                            compute_iteration <= compute_iteration + 1;
                            state <= FETCHING;
                            if compute_iteration = compute_size then
                                bram_o_en  <= '1'; 
                                bram_o_we  <= '1';
                                state <= WRITE_BACK; 
                            end if;
                        end if;
                    when COUNTING =>
                        state <= IDLE;
                    when WRITE_BACK =>
                        busy <= '1';
                        bram_o_addr <= bram_o_addr + 1;
                        if multiple_acc = '1' then
                            acc_number <= acc_number - 1;
                            compute_iteration <= (others => '0');
                            force_acc_clear <= '1';
                            state <= CLEAR_ACC;
                        end if ;
                        if acc_number = 0 or multiple_acc = '0' then
                            busy <= '0';
                            state <= IDLE;
                        end if;
                    when CLEAR_ACC =>
                        busy <= '1';
                        force_acc_clear <= '0';
                        state <= EXECUTE;                        
                end case;
            end if ;
        end process ; -- state_machine

    --------------- Debug Signals -----------------
        res0 <= result_word(255 downto 0);
        res1 <= result_word(511 downto 256);
        res2 <= result_word(767 downto 512);
        res3 <= result_word(1023 downto 768);
end Behavioral;
