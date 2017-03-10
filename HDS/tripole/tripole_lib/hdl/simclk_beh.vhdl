--
-- VHDL Architecture tripole_lib.simclk.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 13:55:38 03/10/2017
--
-- using Mentor Graphics HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY simclk IS
  GENERIC (
    CLK_PERIOD : integer := 5000; -- ps
    PHASE_RES : integer := 280
  );
  PORT (
    PSEN : IN std_logic;
    PSINCDEC : IN std_logic;
    PSDONE : OUT std_logic;
    clk : IN std_logic;
    dlyclk : OUT std_logic;
    rst : IN std_logic
  );
END ENTITY simclk;

--
ARCHITECTURE beh OF simclk IS
  SIGNAL delay_count : integer range 0 to 279;
  SIGNAL delay_start : std_logic;
  SIGNAL done_count : unsigned(3 DOWNTO 0);
  CONSTANT HALF_PERIOD : integer := CLK_PERIOD/(PHASE_RES*2);
BEGIN
  dly : process is
  BEGIN
    if rst = '0' then
      wait until clk'event AND clk = '1';
      -- wait for (delay_count*CLK_PERIOD/PHASE_RES) ps;
      for i in 1 to delay_count loop
        wait for 17 ps;
      end loop;
      delay_start <= '1';
      wait for 9 ps;
      delay_start <= '0';
    else
      delay_start <= '0';
      wait for 10 ns;
    end if;
  END process;
  
  dlyclkproc : process is
  BEGIN
    IF rst = '0' THEN
      wait until delay_start'event AND delay_start = '1';
      dlyclk <= '1';
      wait for 2500 ps;
      dlyclk <= '0';
    ELSE
      dlyclk <= '0';
      wait for 10 ns;
    END IF;
  END process;
  
  adjphase: process (clk) IS
  BEGIN
    IF rst = '1' THEN
      delay_count <= 0;
      PSDONE <= '0';
      -- dlyclk <= '0';
      -- delay_start <= '0';
      done_count <= to_unsigned(0,4);
    ELSE
      IF clk'event AND clk = '1' THEN
        IF PSEN = '1' THEN
          done_count <= to_unsigned(13,4);
          IF PSINCDEC = '1' THEN
            IF delay_count = PHASE_RES-2 THEN
              delay_count <= 0;
            ELSE
              delay_count <= delay_count+1;
            END IF;
          ELSE
            IF delay_count = 0 THEN
              delay_count <= PHASE_RES-1;
            ELSE
              delay_count <= delay_count - 1;
            END IF;
          END IF;
        ELSIF done_count = to_unsigned(1,4) THEN
          PSDONE <= '1';
          done_count <= to_unsigned(0,4);
        ELSIF done_count = 0 THEN
          PSDONE <= '0';
        ELSE
          PSDONE <= '0';
          done_count <= done_count-1;
        END IF;
      END IF;
    END IF;
  END process;
END ARCHITECTURE beh;

