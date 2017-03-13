--
-- VHDL Architecture tripole_lib.tri_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:43:59 09/14/2016
--
-- using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tri_addr IS
  GENERIC( 
    BASE_ADDR : std_logic_vector (7 DOWNTO 0) := X"20"
  );
  PORT( 
    ExpAddr  : IN     std_logic_vector (7 DOWNTO 0);
    AHiPerEn : OUT    std_logic;
    APhaseEn : OUT    std_logic;
    BHiPerEn : OUT    std_logic;
    BPhaseEn : OUT    std_logic;
    BdEn     : OUT    std_logic_vector (7 DOWNTO 0);
    CHiPerEn : OUT    std_logic;
    CPhaseEn : OUT    std_logic;
    CtrlEn   : OUT    std_logic;
    PerEn    : OUT    std_logic
  );

-- Declarations

END ENTITY tri_addr ;

--
ARCHITECTURE beh OF tri_addr IS
BEGIN
  Addr_Select : Process (ExpAddr) is
  begin
    CtrlEn <= '0';
    PerEn <= '0';
    AHiPerEn <= '0';
    APhaseEn <= '0';
    BHiPerEn <= '0';
    BPhaseEn <= '0';
    CHiPerEn <= '0';
    CPhaseEn <= '0';
    if ExpAddr = BASE_ADDR then
      CtrlEn <= '1';
    elsif ExpAddr = BASE_ADDR + 1 then
      PerEn <= '1';
    elsif ExpAddr = BASE_ADDR + 2 then
      AHiPerEn <= '1';
    elsif ExpAddr = BASE_ADDR + 3 then
      APhaseEn <= '1';
    elsif ExpAddr = BASE_ADDR + 4 then
      BHiPerEn <= '1';
    elsif ExpAddr = BASE_ADDR + 5 then
      BPhaseEn <= '1';
    elsif ExpAddr = BASE_ADDR + 6 then
      CHiPerEn <= '1';
    elsif ExpAddr = BASE_ADDR + 7 then
      CPhaseEn <= '1';
    end if;
  end process;
  
  BdEn <= CPhaseEn & CHiPerEn & BPhaseEn & BHiPerEn &
          APhaseEn & AHiPerEn & PerEn & CtrlEn;
  
END ARCHITECTURE beh;

