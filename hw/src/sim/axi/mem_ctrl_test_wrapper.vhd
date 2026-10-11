--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
--Date        : Mon Jul 14 17:17:30 2025
--Host        : zambesi running 64-bit Ubuntu 24.04.2 LTS
--Command     : generate_target mem_ctrl_test_wrapper.bd
--Design      : mem_ctrl_test_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mem_ctrl_test_wrapper is
  port (
    addra_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    addrb_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    address_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    address_1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cc_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    clock_100mhz : in STD_LOGIC;
    dina_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dinb_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    doutb_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    en_0 : in STD_LOGIC;
    en_1 : in STD_LOGIC;
    ena_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    enb_0 : in STD_LOGIC;
    pwm_0 : out STD_LOGIC;
    read_data_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    read_data_1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    reset_rtl : in STD_LOGIC;
    stall_0 : out STD_LOGIC;
    stall_1 : out STD_LOGIC;
    timer_dout_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    timer_en_0 : in STD_LOGIC;
    we_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    we_1 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    wea_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    web_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    write_data_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    write_data_1 : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end mem_ctrl_test_wrapper;

architecture STRUCTURE of mem_ctrl_test_wrapper is
  component mem_ctrl_test is
  port (
    clock_100mhz : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    en_0 : in STD_LOGIC;
    read_data_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    we_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    write_data_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    address_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    stall_0 : out STD_LOGIC;
    read_data_1 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    we_1 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    write_data_1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    address_1 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    en_1 : in STD_LOGIC;
    stall_1 : out STD_LOGIC;
    addra_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    addrb_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dina_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dinb_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    doutb_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ena_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    enb_0 : in STD_LOGIC;
    wea_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    web_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    cc_0 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    pwm_0 : out STD_LOGIC;
    timer_dout_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    timer_en_0 : in STD_LOGIC
  );
  end component mem_ctrl_test;
begin
mem_ctrl_test_i: component mem_ctrl_test
     port map (
      addra_0(31 downto 0) => addra_0(31 downto 0),
      addrb_0(31 downto 0) => addrb_0(31 downto 0),
      address_0(31 downto 0) => address_0(31 downto 0),
      address_1(31 downto 0) => address_1(31 downto 0),
      cc_0(31 downto 0) => cc_0(31 downto 0),
      clock_100mhz => clock_100mhz,
      dina_0(31 downto 0) => dina_0(31 downto 0),
      dinb_0(31 downto 0) => dinb_0(31 downto 0),
      douta_0(31 downto 0) => douta_0(31 downto 0),
      doutb_0(31 downto 0) => doutb_0(31 downto 0),
      en_0 => en_0,
      en_1 => en_1,
      ena_0(3 downto 0) => ena_0(3 downto 0),
      enb_0 => enb_0,
      pwm_0 => pwm_0,
      read_data_0(31 downto 0) => read_data_0(31 downto 0),
      read_data_1(31 downto 0) => read_data_1(31 downto 0),
      reset_rtl => reset_rtl,
      stall_0 => stall_0,
      stall_1 => stall_1,
      timer_dout_0(31 downto 0) => timer_dout_0(31 downto 0),
      timer_en_0 => timer_en_0,
      we_0(3 downto 0) => we_0(3 downto 0),
      we_1(3 downto 0) => we_1(3 downto 0),
      wea_0(3 downto 0) => wea_0(3 downto 0),
      web_0(3 downto 0) => web_0(3 downto 0),
      write_data_0(31 downto 0) => write_data_0(31 downto 0),
      write_data_1(31 downto 0) => write_data_1(31 downto 0)
    );
end STRUCTURE;
