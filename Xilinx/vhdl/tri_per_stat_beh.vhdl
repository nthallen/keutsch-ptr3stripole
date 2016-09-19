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

ENTITY tri_per_stat IS
   PORT( 
      CtrlEn : IN     std_logic;
      RdEn   : IN     std_ulogic;
      RunOut : IN     std_logic;
      clk    : IN     std_logic;
      rst    : IN     std_logic;
      RData  : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END tri_per_stat ;

--
ARCHITECTURE beh OF tri_per_stat IS
BEGIN
  RdStat : Process (clk) IS
  Begin
    if clk'Event AND clk = '1' then
      if rst = '1' then
        RData <= (others => 'Z');
      elsif RdEn = '1' and CtrlEn = '1' then
        RData(15 downto 1) <= (others => '0');
        RData(0) <= RunOut;
      else
        RData <= (others => 'Z');
      end if;
    end if;
  End Process;
END ARCHITECTURE beh;

