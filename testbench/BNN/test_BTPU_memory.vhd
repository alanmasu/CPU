----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2025 06:02:23 PM
-- Design Name: 
-- Module Name: test_BTPU_memory - Behavioral
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

library work;
use work.BNN_pkg.all;
use work.utilities_pkg.all;
use work.types_pkg.all;
use work.constant_package.all;
use work.memory_pkg.all;

entity test_BTPU_memory is
--  Port ( );
end test_BTPU_memory;

architecture Behavioral of test_BTPU_memory is
    constant DEBUG : boolean := false;
    constant W_DIM : integer := 1024;
    constant GRID_SIZE : integer := 32;
    constant ACC_SIZE : integer := 32;
    constant MAC_INST_N : integer := 256;
    constant TILES_N : integer := (GRID_SIZE * GRID_SIZE) / MAC_INST_N;
    
    signal tile_number      : unsigned(clog2(TILES_N) - 1 downto 0) := (others => '0');
    -- Matrix Arrays
    type matrix_t   is array (0 to GRID_SIZE  - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    type popcount_t is array (0 to MAC_INST_N - 1) of std_logic_vector(clog2(GRID_SIZE) - 1 downto 0);
    type acc_t      is array (0 to MAC_INST_N - 1) of std_logic_vector(ACC_SIZE - 1 downto 0);
    type mac_input  is array (0 to MAC_INST_N - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);

    signal activaction_word : std_logic_vector(W_DIM - 1 downto 0) := (others => '0');
    signal result_word      : std_logic_vector(W_DIM - 1 downto 0) := (others => '0');

    signal mac_sign_out     : std_logic_vector(MAC_INST_N - 1 downto 0) := (others => '0');

    type inst_choises_t is array (0 to TILES_N - 1) of std_logic_vector(GRID_SIZE - 1 downto 0);
    type inst_input_t is array (0 to MAC_INST_N - 1) of inst_choises_t;

    signal activations_matrix : matrix_t;
    signal weights_matrix     : matrix_t; 
        
    signal mac_a_in     : mac_input;
    signal mac_b_in     : mac_input;
        
    signal mac_inst_activations_choises : inst_input_t;
    signal mac_inst_weights_choises     : inst_input_t;
    
    --------------------------------------------------------------------------
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal ena : std_logic := '0';
    signal enb : std_logic := '0';

    signal addra : std_logic_vector(31 downto 0) := (others => '0');
    signal addrb : std_logic_vector(31 downto 0) := (others => '0');

    signal dina : std_logic_vector(31 downto 0) := (others => '0');
    signal dinb : std_logic_vector(W_DIM-1 downto 0) := (others => '0');

    signal wea : std_logic_vector(0 downto 0) := (others => '0');
    signal web : std_logic_vector(0 downto 0) := (others => '0');

    signal douta : std_logic_vector(31 downto 0) := (others => '0');
    signal doutb : std_logic_vector(W_DIM-1 downto 0) := (others => '0');


    signal test_n : integer := 0;
    signal validating : std_logic := '0';
    signal result : std_logic := '1';

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

    signal res0 : std_logic_vector(255 downto 0) := (others => '0');
    signal res1 : std_logic_vector(255 downto 0) := (others => '0');
    signal res2 : std_logic_vector(255 downto 0) := (others => '0');
    signal res3 : std_logic_vector(255 downto 0) := (others => '0');

    ------------ Testing BTPU_MAC ------------
    signal mac_a        : std_logic_vector(GRID_SIZE - 1 downto 0) := (others => '0');
    signal mac_b        : std_logic_vector(GRID_SIZE - 1 downto 0) := (others => '0');
    signal mac_sign_cmp : std_logic_vector(ACC_SIZE - 1 downto 0) := (others => '0');
    signal mac_sign     : std_logic := '0';
    signal mac_out      : std_logic_vector(clog2(GRID_SIZE) - 1 downto 0) := (others => '0');
    signal mac_acc      : std_logic_vector(ACC_SIZE - 1 downto 0) := (others => '0');
    signal mac_clear    : std_logic := '0';

    function popcount_compute (input : std_logic_vector(GRID_SIZE - 1 downto 0)) return std_logic_vector is
        variable result : unsigned(clog2(GRID_SIZE) - 1 downto 0) := (others => '0');
    begin
        for i in 0 to GRID_SIZE - 1 loop
            if (input(i) = '1') then
                result := result + to_unsigned(1, clog2(GRID_SIZE));
            end if;
        end loop;
        return std_logic_vector(result);
    end function;

begin

    dut : BTPU_memory
        PORT MAP (
            clka => clk,
            ena => ena,
            wea => wea,
            addra => addra(14 downto 0),
            dina => dina,
            douta => douta,
            clkb => clk,
            enb => enb,
            web => web,
            addrb => addrb(9 downto 0),
            dinb => dinb,
            doutb => doutb
        );

    dut2 : entity work.BTPU_MAC
        generic map (
            X => GRID_SIZE,
            ACC_SIZE => ACC_SIZE
        )
        PORT MAP (
            acc_clk => clk,
            acc_resn => mac_clear,
            a => mac_a,
            b => mac_b,
            size => mac_sign_cmp,
            res_sign => mac_sign,
            res => mac_out,
            acc => mac_acc
        );

    --------------- Clock and Reset -----------------
        process begin
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
        end process ; 
        
        process begin
            rst <= '0';
            wait for 9 ns;
            rst <= '1';
            wait;
        end process ; 
    
    --------------- Activation Pop ------------------
        activaction_word <= doutb;
        mac_activation_pop : for i in 0 to GRID_SIZE - 1 generate
            constant word_to_bit    : integer := i * 32;
            constant word_from_bit  : integer := word_to_bit + 31;
        begin 
            activations_matrix(i) <= activaction_word(word_from_bit downto word_to_bit);
        end generate ; -- mac_activation_pop

    --------------- Weights Pop ---------------------
        --    mac_weigths_pop : for col in 0 to GRID_SIZE - 1 generate
        --        bit_pop : for bit in 0 to GRID_SIZE - 1 generate
        --            constant bit_from_word : integer := bit * 32 + col;
        --        begin 
        --            weights_matrix(col)(bit) <= weigth_word(bit_from_word);
        --        end generate ; -- bit_pop
        --    end generate ; -- mac_weigths_pop

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
                result_word(bit_n) <= mac_sign_out(inst) when unsigned(tile_number) = to_unsigned(tile, tile_number'length)
                                    else 
                                    result_word(bit_n);
                process begin
                    if DEBUG then
                        report "connected result_word(" & integer'image(bit_n) & ") <= mac_sign_out(" & integer'image(inst) & ") when unsigned(tile_number) = " & integer'image(tile);
                    end if;
                    wait;
                end process;
            end generate; -- tile_for
        end generate; -- result_pop

    --------------- Debug Signals -------------------
        res0 <= result_word(255 downto 0);
        res1 <= result_word(511 downto 256);
        res2 <= result_word(767 downto 512);
        res3 <= result_word(1023 downto 768);

    --------------- Testing Process -----------------
    process is
        variable thread : integer := 0;
        variable col    : integer := 0;
        variable row    : integer := 0;
    begin
        wait until rst = '1';
        ena <= '1';
        wea <= "1";
        wait until rising_edge(clk);
        wait for 1 ns;

        --- Popola 4 righe da 1024
        for i in 0 to 128 loop
            addra <= std_logic_vector(to_unsigned(i, 32));
            dina <= std_logic_vector(to_unsigned(i, 32));
            wait until rising_edge(clk);
            wait for 1 ns;
        end loop ; -- 
        wea <= "0";
        wait until rising_edge(clk);
        wait for 1 ns;

        --- Checking the BRAM Port A ---
        test_n <= 1;
        
        for i in 0 to 128 loop
            addra <= std_logic_vector(to_unsigned(i, 32));
            wait until rising_edge(clk);
            wait for 1 ns;
            validating <= '1';
            if (douta /= std_logic_vector(to_unsigned(i, 32))) then
                result <= '0';
                report "Test #" & integer'image(test_n) & " FAILED: at address " & integer'image(i) & " with value " & integer'image(i) & " dout was " & integer'image(to_integer(unsigned(douta)));
            end if;
            wait for 1 ns;
            validating <= '0';
        end loop ; --
        wait for 1 ns;
        validating <= '0';
        if result = '1' then
            report "Test #" & integer'image(test_n) & " OK";
        end if;


        --- Checking the BRAM Port B ---
        test_n <= 2;
        enb <= '1';
        web <= "0";
        result <= '1';
        for i in 0 to 3 loop 
            addrb <= std_logic_vector(to_unsigned(i, 32));
            wait until rising_edge(clk);
            wait for 1 ns;
            validating <= '1';
            for j in 0 to 31 loop
                if (doutb( j*32 + 31 downto j * 32) /= std_logic_vector(to_unsigned(i * 32 + j, 32))) then
                    result <= '0';
                    report "Test #" & integer'image(test_n) & " FAILED: at address " & integer'image(i) & " with value " & integer'image(j) & " dout was " & integer'image(to_integer(unsigned(doutb( j*32 + 31 downto j * 32))));
                end if;
            end loop ; --
            wait for 1 ns;
            validating <= '0';
        end loop ; --
        if result = '1' then
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;

        --- Checking selector ---
        test_n <= 3;
        enb <= '1';
        web <= "0";
        result <= '1';
        addrb <= std_logic_vector(to_unsigned(0, 32));
        wait until rising_edge(clk);
        wait for 1 ns;
        validating <= '1';
        for row in 0 to 31 loop 
            if (activations_matrix(row) /= std_logic_vector(to_unsigned(row, 32))) then
                result <= '0';
                report "Test #" & integer'image(test_n) & " FAILED => activation_matrix(" & integer'image(row) & ") was: " & integer'image(to_integer(unsigned(activations_matrix(row))));
            end if; 
        end loop ; --
        wait for 1 ns;
        validating <= '0';
        if result = '1' then
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;

        --- Checking selector ---
        test_n <= 4;
        enb <= '1';
        web <= "0";
        result <= '1';
        addrb <= std_logic_vector(to_unsigned(0, 32));
        wait until rising_edge(clk);
        wait for 1 ns;
        enb <= '0';
        validating <= '1';
        for instance in 0 to MAC_INST_N - 1 loop 
            for tile in 0 to TILES_N - 1 loop 
                thread := tile * MAC_INST_N + instance;
                row := thread / GRID_SIZE;
                col := thread mod GRID_SIZE;
                tile_number <= to_unsigned(tile, clog2(TILES_N));
                wait for 1 ns;
                if (mac_inst_activations_choises(instance)(tile) /= activations_matrix(row)) then
                    result <= '0';
                    report "Test #" & integer'image(test_n) & " FAILED => mac_inst_activations_choises(" & integer'image(instance) & ")(" & integer'image(tile) & ") [th: " & integer'image(thread) & " row: " & integer'image(row) & "] was: " & integer'image(to_integer(unsigned(mac_inst_activations_choises(instance)(tile))));
                end if;
            end loop ; --
        end loop ; --
        wait for 1 ns;
        validating <= '0';
        if result = '1' then
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;

        --- Checking Result Selector ---
        test_n <= 5;
        result <= '1';
        for tile in 0 to TILES_N - 1 loop 
            tile_number <= to_unsigned(tile, clog2(TILES_N));
            wait for 1 ns;
            for mac in 0 to (MAC_INST_N / GRID_SIZE) - 1 loop 
                mac_sign_out(mac * 32 + 31 downto mac * 32) <= std_logic_vector(to_unsigned(tile * (MAC_INST_N / GRID_SIZE) + mac, 32));
            end loop ; --
            wait for 1 ns;                
        end loop ; --
        wait for 1 ns;
        
        validating <= '1';
        for i in 0 to (W_DIM / GRID_SIZE) - 1 loop 
            if (result_word(i * GRID_SIZE + GRID_SIZE - 1 downto i * GRID_SIZE) /= std_logic_vector(to_unsigned(i, 32))) then
                result <= '0';
                report "Test #" & integer'image(test_n) & " FAILED => result_word(" & integer'image(i) & ") was: " & integer'image(to_integer(unsigned(result_word(i * GRID_SIZE + GRID_SIZE - 1 downto i * GRID_SIZE)))) & " expected: " & integer'image(i);
            end if;
        end loop ; --
        wait for 1 ns;
        validating <= '0';
        if result = '1' then
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;

        --- Checking MAC ---
        test_n <= 6;
        result <= '1';
        mac_clear <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        mac_clear <= '1';
        wait for 1 ns;
        
        mac_sign_cmp <= std_logic_vector(to_unsigned(6, ACC_SIZE));
        mac_a <= (5 => '1', 4 => '1', 3 => '1', 2 => '1', 1 => '1', 0 => '1', others => '0'); -- 6 uni
        mac_b <= (others => '1'); -- 6 zero
        wait until rising_edge(clk);
        wait for 1 ns;

        validating <= '1';
        if (mac_out /= popcount_compute(mac_a xnor mac_b)) or mac_acc /= popcount_compute(mac_a xnor mac_b) then
            report "Test #" & integer'image(test_n) & " FAILED => mac_out was: " & integer'image(to_integer(unsigned(mac_out))) & " expected: " & integer'image(to_integer(unsigned(popcount_compute(mac_a xnor mac_b))))
                                                    & " | mac_acc was: " & integer'image(to_integer(unsigned(mac_acc))) & " expected: " & integer'image(to_integer(unsigned(popcount_compute(mac_a xnor mac_b))));
        else 
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;
        validating <= '0';

        test_n <= 7;
        result <= '1';
        wait for 1 ns;

        validating <= '1';
        if mac_sign /= '0' then
            result <= '0';
            report "Test #" & integer'image(test_n) & " FAILED => mac_sign was: 1 expected: 0";
        else 
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;
        validating <= '0';

        test_n <= 8;
        result <= '1';
        mac_a <= (5 => '1', 4 => '0', 3 => '0', 2 => '0', 1 => '0', 0 => '0', others => '0'); -- 1 uno
        mac_b <= (others => '1'); -- 1 zero
        wait until rising_edge(clk);
        wait for 1 ns;
        validating <= '1';
        if (mac_out /= popcount_compute(mac_a xnor mac_b)) or mac_acc /= std_logic_vector(to_unsigned(7, ACC_SIZE)) then
            report "Test #" & integer'image(test_n) & " FAILED => mac_out was: " & integer'image(to_integer(unsigned(mac_out))) & " expected: " & integer'image(to_integer(unsigned(popcount_compute(mac_a xnor mac_b))))
                                                    & " | mac_acc was: " & integer'image(to_integer(unsigned(mac_acc))) & " expected: 7";
        else 
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;
        validating <= '0';

        test_n <= 9;
        result <= '1';
        wait for 1 ns;
        validating <= '1';
        if mac_sign /= '1' then
            result <= '0';
            report "Test #" & integer'image(test_n) & " FAILED => mac_sign was: 0 expected: 1";
        else 
            report "Test #" & integer'image(test_n) & " OK";
        end if;
        wait for 1 ns;
        validating <= '0';





        assert false report "fine" severity failure;
    end process ; -- 

end Behavioral;


