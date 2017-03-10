--
-- VHDL Architecture tripole_lib.phaseclk.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:48:57 03/10/2017
--
-- using Mentor Graphics HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY phaseclk IS
  PORT( 
    clk_phase : IN     std_logic;
    pulse     : IN     std_logic;
    tri_pulse : OUT    std_logic;
    srcclk    : IN     std_logic;
    phsclk    : IN     std_logic
  );

-- Declarations

END ENTITY phaseclk ;

--
ARCHITECTURE beh OF phaseclk IS
  SIGNAL pulse1 : std_logic;
BEGIN
  phsint: process (srcclk) IS
  BEGIN
    IF srcclk'event AND srcclk = '0' THEN
      pulse1 <= pulse;
    END IF;
  END process;
  
  phsout: process (phsclk) IS
  BEGIN
    IF phsclk'event AND phsclk = '1' THEN
      IF clk_phase = '0' THEN
        tri_pulse <= pulse;
      ELSE
        tri_pulse <= pulse1;
      END IF;
    END IF;
  END process;
END ARCHITECTURE beh;

