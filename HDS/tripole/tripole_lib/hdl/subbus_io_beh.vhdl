--
-- VHDL Architecture idx_fpga_lib.DigIO_decode.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:06:21 09/21/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
-- Both RdEn and WrEn are qualified with BdEn
-- WrEn will be one clock pulse long
-- RdEn will be longer
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY subbus_io IS
   GENERIC (
     N_ENABLE : integer := 1;
     USE_BD_WR_EN : std_logic := '0'
   );
   PORT( 
      ExpRd  : IN     std_logic;
      ExpWr  : IN     std_logic;
      ExpAck : OUT    std_logic_vector(N_ENABLE-1 DOWNTO 0);
      F8M    : IN     std_logic;
      RdEn   : OUT    std_logic;
      WrEn   : OUT    std_logic;
      BdEn   : IN     std_logic_vector(N_ENABLE-1 DOWNTO 0);
      BdWrEn : IN     std_logic_vector(N_ENABLE-1 DOWNTO 0)
   );
  -- ExpRd,ExpWr,ExpAck all external.
  -- RdEn, WrEn are our qualified versions
  -- RdEn and WrEn are both qualified with BdEn
  -- WrEn is one clock pulse long.
  -- RdEn is longer
  -- BdEn is 1 when Addr selects an element
  -- If USE_BD_WR_EN = '1', BdWrEn is used instead of BdEn
  --   to produce ExpAck on ExpWr.

END subbus_io ;

--
ARCHITECTURE beh OF subbus_io IS
  SIGNAL Wrote : std_logic;
  SIGNAL RdEn_int : std_logic;
  SIGNAL WrEn_int : std_logic;
  SIGNAL BdWrEn_int : std_logic_vector(N_ENABLE-1 DOWNTO 0);
BEGIN

  BdEnGen : IF USE_BD_WR_EN = '0' GENERATE
    BdWrEn_int <= BdEn;
  END GENERATE;
  
  BdEnGen2 : IF USE_BD_WR_EN = '1' GENERATE
    BdWrEn_int <= BdWrEn;
  END GENERATE;
  
  -- WrEn_int needs to be qualified with BdEn_In
  -- to make sure WrEn occurs during BdEn
  WrEnbl : Process (F8M) Is
    variable ackd : std_logic;
  Begin
    if F8M'Event and F8M = '1' then
      if ExpWr = '1' then
        ackd := '0';
        for i in N_ENABLE-1 DOWNTO 0 loop
          if BdWrEn_int(i) = '1' then
            ackd := '1';
          end if;
        end loop;
        if ackd = '1' then
          if Wrote = '1' then
            WrEn_int <= '0';
          else
            WrEn_int <= '1';
            Wrote <= '1';
          end if;
        end if;
      else
        WrEn_int <= '0';
        Wrote <= '0';
      end if;
    end if;
  End Process;
  
  RdEnbl : process ( F8M ) is
    variable ackd : std_logic;
  begin
    if F8M'event and F8M = '1' then
      if ExpRd = '1' then
        ackd := '0';
        for i in N_ENABLE-1 DOWNTO 0 loop
          if BdEn(i) = '1' then
            ackd := '1';
          end if;
        end loop;
        if ackd = '1' then
          RdEn_int <= '1';
        else
          RdEn_int <= '0';
        end if;
      end if;
    end if;
  end process;
  
  Ack : process (F8M) is
  begin
    if F8M'event and F8M = '1' then
      if ExpRd = '1' then
        ExpAck <= BdEn;
      elsif ExpWr = '1' then
        ExpAck <= BdWrEn_int;
      else
        ExpAck <= (others => '0');
      end if;
    end if;
  end process;

  RdEn <= RdEn_int;
  WrEn <= WrEn_int;

END ARCHITECTURE beh;
