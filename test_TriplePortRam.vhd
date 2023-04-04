
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_TriplePortRam is
end test_TriplePortRam;

architecture Behavioral of test_TriplePortRam is
    component triple_port_ram is
        Port ( 
           addr_in : in STD_LOGIC_VECTOR (4 downto 0);
           d_in : in STD_LOGIC_VECTOR (31 downto 0);
           we : in STD_LOGIC;
           addr_out1 : in STD_LOGIC_VECTOR (4 downto 0);
           d_out1 : out STD_LOGIC_VECTOR (31 downto 0);
           addr_out2 : in STD_LOGIC_VECTOR (4 downto 0);
           d_out2 : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           res : in STD_LOGIC
        );
    end component triple_port_ram;
    signal addr_in : STD_LOGIC_VECTOR (4 downto 0);
    signal d_in : STD_LOGIC_VECTOR (31 downto 0);
    signal we : STD_LOGIC;
    signal addr_out1 : STD_LOGIC_VECTOR (4 downto 0);
    signal d_out1 : STD_LOGIC_VECTOR (31 downto 0);
    signal addr_out2 : STD_LOGIC_VECTOR (4 downto 0);
    signal d_out2 : STD_LOGIC_VECTOR (31 downto 0);
    signal clk : STD_LOGIC;
    signal res : STD_LOGIC;
begin
    dut : triple_port_ram port map (
        clk => clk, res => res, addr_in => addr_in, 
        d_in => d_in, we => we, addr_out1 => addr_out1, 
        d_out1 => d_out1, addr_out2 => addr_out2,
        d_out2 => d_out2);

process begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
end process;      

process is
    variable test_data_1 : std_logic_vector (31 downto 0) := (0 => '1', others => '0');
    variable test_data_2 : std_logic_vector (31 downto 0) := (0 => '0', others => '1');
begin
    res <= '0';
    wait for 105 ns;
    res <= '1';
    addr_out1 <= (others => '0');
    addr_out2 <= (others => '0');
    addr_in <= (others => '0');
    we <= '1';
    d_in <= test_data_1;
    
    wait for 20 ns;
    we <= '0';
    wait for 20 ns;
    
    addr_out1 <= (1 => '1', others => '0');
    wait for 1 ns;
    addr_in <= (1 => '1', others => '0');
    wait for 1 ns;
    d_in <= (others => '1');
    wait for 1 ns;
    we <= '1';
    wait for 1 ns;
    
    
    
    wait;
    
--    addr_out1 <= (0 => '1', others => '0');
--    addr_out2 <= (1 => '1', others => '0');
    
--    addr_in <= (0 => '1', others => '0');
--    we <= '1';
--    d_in <= test_data_2;
    
--    wait for 25 ns;
--    we <= '0';
--    wait for 10 ns;
    
--    addr_in <= (1 => '1', others => '0');
--    we <= '1';
--    d_in <= (0 => '0', others => '1');
    
--    wait for 25 ns;
--    we <= '0';
--    wait for 10 ns;
    
--    addr_in <= (1 => '1', others => '0');
--    we <= '1';
--    d_in <= (others => '0');
    
--    wait for 25 ns;
--    we <= '0';
--    wait for 10 ns;
    
--    addr_in <= (0 => '1', others => '0');
--    we <= '0';
--    d_in <= (others => '1');
    
--    wait for 25 ns;
--    we <= '0';
--    wait for 10 ns;
--    wait;
    
end process;

--process is
--		variable ex_data : std_logic_vector (31 downto 0);
--	begin
--	    ex_data := (0 => '1', others => '0');
--        first_for : for y in 0 to 31 loop
--            addr_in <= std_logic_vector(to_unsigned(y, 5));
--            we <= '1';
--            wait for 20 ns;
--            second_for : for x in 0 to 31 loop
--                ex_data := ex_data(30 downto 0) & '0';
--                d_in <= ex_data;
--                wait for 50 ns;
--            end loop second_for;
--            we <= '0';
--            wait for 20 ns;
--            addr_out1 <= addr_in;
--            ex_data := (0 => '1', others => '0');
--            wait for 50 ns;
--        end loop first_for;
--        third_for : for y in 0 to 31 loop
--            addr_out2 <= std_logic_vector(to_unsigned(y, 5));
--            we <= '1';
--            wait for 20 ns;
--            fourth_for : for x in 31 downto 0 loop
--                ex_data := ex_data(30 downto 0) & '0';
--                d_in <= ex_data and d_out2;
--                wait for 50 ns;
--            end loop fourth_for;
--        end loop third_for;
--        we <= '0';
--        wait;
--	end process;


end Behavioral;
