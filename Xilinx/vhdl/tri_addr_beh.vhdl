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
  SIGNAL AHiPerEni : std_logic;
  SIGNAL APhaseEni : std_logic;
  SIGNAL BHiPerEni : std_logic;
  SIGNAL BPhaseEni : std_logic;
  SIGNAL CHiPerEni : std_logic;
  SIGNAL CPhaseEni : std_logic;
  SIGNAL CtrlEni   : std_logic;
  SIGNAL PerEni    : std_logic;
BEGIN
  Addr_Select : Process (ExpAddr) is
  begin
    CtrlEni <= '0';
    PerEni <= '0';
    AHiPerEni <= '0';
    APhaseEni <= '0';
    BHiPerEni <= '0';
    BPhaseEni <= '0';
    CHiPerEni <= '0';
    CPhaseEni <= '0';
    if ExpAddr = BASE_ADDR then
      CtrlEni <= '1';
    elsif ExpAddr = BASE_ADDR + 1 then
      PerEni <= '1';
    elsif ExpAddr = BASE_ADDR + 2 then
      AHiPerEni <= '1';
    elsif ExpAddr = BASE_ADDR + 3 then
      APhaseEni <= '1';
    elsif ExpAddr = BASE_ADDR + 4 then
      BHiPerEni <= '1';
    elsif ExpAddr = BASE_ADDR + 5 then
      BPhaseEni <= '1';
    elsif ExpAddr = BASE_ADDR + 6 then
      CHiPerEni <= '1';
    elsif ExpAddr = BASE_ADDR + 7 then
      CPhaseEni <= '1';
    end if;
  end process;
  
  AHiPerEn <= AHiPerEni;
  APhaseEn <= APhaseEni;
  BHiPerEn <= BHiPerEni;
  BPhaseEn <= BPhaseEni;
  CHiPerEn <= CHiPerEni;
  CPhaseEn <= CPhaseEni;
  CtrlEn <= CtrlEni;
  PerEn <= PerEni;
  BdEn <= CPhaseEni & CHiPerEni & BPhaseEni & BHiPerEni &
          APhaseEni & AHiPerEni & PerEni & CtrlEni;
  
END ARCHITECTURE beh;

