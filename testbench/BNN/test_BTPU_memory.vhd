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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_BTPU_memory is
--  Port ( );
end test_BTPU_memory;

architecture Behavioral of test_BTPU_memory is
    constant W_DIM : integer := 1024;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal ena : std_logic := '0';
    signal enb : std_logic := '0';

    signal addra : std_logic_vector(31 downto 0) := (others => '0');
    signal addrb : std_logic_vector(31 downto 0);

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

    process begin
        wait until rst = '1';
        ena <= '1';
        wea <= "1";
        wait until rising_edge(clk);
        wait for 1 ns;

        for i in 0 to 10 loop
            addra <= std_logic_vector(to_unsigned(i, 32));
            dina <= std_logic_vector(to_unsigned(i, 32));
            wait until rising_edge(clk);
            wait for 1 ns;
        end loop ; -- 

        for i in 0 to 10 loop
            addra <= std_logic_vector(to_unsigned(i + 32, 32));
            dina <= std_logic_vector(to_unsigned(i, 32));
            wait until rising_edge(clk);
            wait for 1 ns;
        end loop ; --
        wea <= "0";
        ena <= '0';



        --- Checking the BRAM Port B ---
        test_n <= 1;
        enb <= '1';
        web <= "0";
        result <= '1';
        for i in 0 to 1 loop 
            addrb <= std_logic_vector(to_unsigned(i, 32));
            wait until rising_edge(clk);
            wait for 1 ns;
            validating <= '1';
            for j in 0 to 10 loop
                if (doutb( j*32 + 31 downto j * 32) /= std_logic_vector(to_unsigned(j, 32))) then
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
        
        assert false report "fine" severity failure;
    end process ; -- 

end Behavioral;


