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
USE ieee.numeric_std.all;

ENTITY tri_per_stat IS
  GENERIC( 
    DELAY_COUNT : integer range 500 downto 1 := 40
  );
  PORT( 
    CtrlEn    : IN     std_logic;
    RdEn      : IN     std_logic;
    RunCmd    : IN     std_logic;
    RunStatus : IN     std_logic;
    clk       : IN     std_logic;
    rst       : IN     std_logic;
    Fail      : OUT    std_logic;
    RunOut    : OUT    std_logic;
    RData     : INOUT  std_logic_vector (15 DOWNTO 0)
  );

-- Declarations

END ENTITY tri_per_stat ;

--
ARCHITECTURE beh OF tri_per_stat IS
  SIGNAL Failing : std_logic;
  SIGNAL Delay : unsigned(8 DOWNTO 0);
BEGIN
  RdStat : Process (clk) IS
  Begin
    if clk'Event AND clk = '1' then
      if rst = '1' then
        RData <= (others => 'Z');
      elsif RdEn = '1' and CtrlEn = '1' then
        RData(15 downto 3) <= (others => '0');
        RData(2) <= Failing;
        RData(1) <= RunStatus;
        RData(0) <= RunCmd;
      else
        RData <= (others => 'Z');
      end if;
    end if;
  End Process;
  
  FailChk : Process (clk) IS
  Begin
    if clk'Event AND clk = '1' then
      if rst = '1' then
        Delay <= to_unsigned(DELAY_COUNT,9);
        Failing <= '0';
      else
        if RunCmd = '0' then
          Delay <= to_unsigned(DELAY_COUNT,9);
          Failing <= '0';
        elsif RunStatus = '0' then
          if Delay = 0 then
            Failing <= '1';
          else
            Delay <= Delay-1;
          end if;
        end if;
      end if;
    end if;
  End Process;
  
  Running : Process (clk) IS
  Begin
    if clk'Event AND clk = '1' then
      if rst = '1' then
        RunOut <= '0';
      elsif RunCmd = '1' AND Failing = '0' then
        RunOut <= '1';
      else
        RunOut <= '0';
      end if;
    end if;
  End Process;
  
  Fail <= Failing;
  
END ARCHITECTURE beh;

