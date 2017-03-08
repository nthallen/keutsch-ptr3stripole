--
-- VHDL Architecture tripole_lib.tri_per_stat.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:10:05 09/14/2016
--
-- using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY tri_per_stat IS
  GENERIC( 
    DELAY_COUNT : integer range 500 downto 1 := 40
  );
  PORT( 
    CtrlEn    : IN     std_logic;
    RunCmd    : IN     std_logic;
    clk       : IN     std_logic;
    rst       : IN     std_logic;
    Fail      : OUT    std_logic;
    RunOut    : OUT    std_logic;
    StatRData : OUT    std_logic_vector (15 DOWNTO 0);
    Ilock_rtn : IN     std_logic
  );

-- Declarations

END ENTITY tri_per_stat ;

--
ARCHITECTURE beh OF tri_per_stat IS
  SIGNAL Failing : std_logic;
  SIGNAL Run_int : std_logic;
BEGIN
  RdStat : Process (clk) IS
  Begin
    if clk'Event AND clk = '1' then
      if rst = '1' then
        StatRData <= (others => '0');
      elsif CtrlEn = '1' then
        StatRData(15 downto 3) <= (others => '0');
        StatRData(2) <= Failing;
        StatRData(1) <= Run_int;
        StatRData(0) <= RunCmd;
      end if;
    end if;
  End Process;
  
  FailChk : Process (clk) IS
  Begin
    if clk'Event AND clk = '1' then
      if rst = '1' then
        Failing <= '0';
      else
        if RunCmd = '0' then
          Failing <= '0';
        elsif Ilock_rtn = '0' then
          Failing <= '1';
        end if;
      end if;
    end if;
  End Process;
  
  Running : Process (clk) IS
  Begin
    if clk'Event AND clk = '1' then
      if rst = '1' then
        Run_int <= '0';
      elsif RunCmd = '1' AND Failing = '0' then
        Run_int <= '1';
      else
        Run_int <= '0';
      end if;
    end if;
  End Process;
  
  RunOut <= Run_int;
  Fail <= Failing;
  
END ARCHITECTURE beh;
