--
-- VHDL Test Bench tripole_lib.tri_lvl_b_tester.tri_lvl_b_tester
--
-- Created:
--          by - . (NORT-XPS14)
--          at - 19:00:00 12/31/69
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY tri_lvl_b_tester IS
   PORT (
      Addr        : OUT    std_logic_vector(7 DOWNTO 0);
      clk_100MHz  : OUT    std_logic;
      Ctrl        : OUT    std_logic_vector(6 DOWNTO 0);
      Data_i      : IN     std_logic_vector(15 DOWNTO 0);
      Data_o      : OUT    std_logic_vector(15 DOWNTO 0);
      Status      : IN     std_logic_vector(3 DOWNTO 0);
      Run         : IN     std_logic;
      RunStatus   : OUT    std_logic;
      Fail_Out    : IN     std_logic;
      tri_pulse_A : IN     std_logic;
      tri_pulse_B : IN     std_logic;
      tri_pulse_C : IN     std_logic
   );
END tri_lvl_b_tester;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
-- LIBRARY tripole_lib;

ARCHITECTURE rtl OF tri_lvl_b_tester IS
   -- Architecture declarations
  SIGNAL Ctrl_int : std_logic_vector(6 DOWNTO 0);
  SIGNAL SimDone : std_logic;
  SIGNAL clk : std_logic;
  SIGNAL ReadData : std_logic_vector(15 DOWNTO 0);
  -- pragma synthesis_off
  alias RdEn is Ctrl_int(0);
  alias WrEn is Ctrl_int(1);
  alias CS is Ctrl_int(2);
  alias CE is Ctrl_int(3);
  alias rst is Ctrl_int(4);
  alias arm is Ctrl_int(6);
  alias TickTock is Ctrl_int(5);
  alias Done is Status(0);
  alias Ack is Status(1);
  alias ExpIntr is Status(2);
  alias TwoSecondTO is Status(3);
  -- pragma synthesis_on
BEGIN
  f100m_clk : Process is
  Begin
    clk <= '0';
    -- pragma synthesis_off
    wait for 20 ns;
    while SimDone = '0' loop
      clk <= '1';
      wait for 5 ns;
      clk <= '0';
      wait for 5 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc: Process is
    
    procedure sbwr( Addr_In : IN std_logic_vector (7 downto 0);
                    Data_In : IN std_logic_vector (15 downto 0) ) is
    begin
      Addr <= Addr_In;
      Data_o <= Data_in;
      -- pragma synthesis_off
      wait for 40 ns;
      WrEn <= '1';
      wait for 100 ns;
      assert Ack = '1' report "No acknowledge on write" severity error;
      WrEn <= '0';
      wait for 50 ns;
      -- pragma synthesis_on
      return;
    end procedure sbwr;
    
    procedure sbrd( Addr_In : IN std_logic_vector (7 downto 0) ) is
    begin
      Addr <= Addr_In;
      -- pragma synthesis_off
      wait for 40 ns;
      RdEn <= '1';
      wait for 100 ns;
      assert Ack = '1' report "No acknowledge on read" severity error;
      ReadData <= Data_i;
      RdEn <= '0';
      wait for 50 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;
  Begin
    SimDone <= '0';
    -- pragma synthesis_off
    RdEn <= '0';
    WrEn <= '0';
    CS <= '0';
    CE <= '0';
    rst <= '1';
    arm <= '0';
    TickTock <= '0';
    RunStatus <= '0';
    wait for 50 ns;
    rst <= '0';
    wait until clk'Event and clk = '1';
    wait until clk'Event and clk = '1';
    
    sbwr(X"20", X"0000"); -- Ensure off
    sbwr(X"21", X"00A0"); -- Period 100 ns
    sbwr(X"23", X"0000"); -- Channel A phase 0
    sbwr(X"22", X"0040"); -- Channel A hi period 40 ns
    sbwr(X"25", X"0033"); -- Channel B phase (delay) 33 ns
    sbwr(X"24", X"0040"); -- Channel B hi period 40 ns
    sbwr(X"27", X"0066"); -- Channel C phase delay 66 ns
    sbwr(X"26", X"0040"); -- Channel C hi period 40 ns
    RunStatus <= '1';
    sbwr(X"20", X"0001"); -- Enable
    wait for 1 us;
    RunStatus <= '0';
    wait for 100 ns;
    RunStatus <= '1';
    wait for 100 ns;
    sbwr(X"20", X"0000"); -- Disable
    wait for 200 ns;
    sbwr(X"20", X"0001"); -- Enable
    wait for 100 ns;
    sbrd(X"20");
    sbrd(X"21");
    sbrd(X"22");
    sbrd(X"23");
    sbrd(X"24");
    sbrd(X"25");
    sbrd(X"26");
    sbrd(X"27");
    sbwr(X"20", X"0000"); -- Disable
    wait for 80 ns;
    
    SimDone <= '1';
    wait;
   -- pragma synthesis_on
  End Process;
  
  -- RunStatus <= Run;
  Ctrl <= Ctrl_int;
  clk_100MHz <= clk;
END rtl;
