-- VHDL Entity tripole_lib.tri_period.symbol
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 11:43:38 10/04/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tri_period IS
   PORT( 
      CtrlEn    : IN     std_logic;
      PerEn     : IN     std_logic;
      RdEn      : IN     std_ulogic;
      RunStatus : IN     std_logic;
      WData     : IN     std_logic_vector (15 DOWNTO 0);
      WrEn      : IN     std_logic;
      clk       : IN     std_logic;
      rst       : IN     std_logic;
      Fail      : OUT    std_ulogic;
      RunOut    : OUT    std_logic;
      tri_start : OUT    std_logic;
      RData     : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END tri_period ;

--
-- VHDL Architecture tripole_lib.tri_period.struct
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 11:43:38 10/04/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

LIBRARY tripole_lib;

ARCHITECTURE struct OF tri_period IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Count  : std_logic_vector(15 DOWNTO 0);
   SIGNAL RdCnt  : std_logic;
   SIGNAL RunCmd : std_logic;


   -- Component Declarations
   COMPONENT dither_wrap
   PORT (
      ExpReset : IN     std_logic ;
      PerEn    : IN     std_logic ;
      RdCnt    : IN     std_ulogic ;
      RdEn     : IN     std_ulogic ;
      WData    : IN     std_logic_vector (15 DOWNTO 0);
      WrEn     : IN     std_logic ;
      clk      : IN     std_logic ;
      Count    : OUT    std_logic_vector (15 DOWNTO 0);
      RData    : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT tri_per_ctrl
   PORT (
      Count     : IN     std_logic_vector (15 DOWNTO 0);
      CtrlEn    : IN     std_logic ;
      WData     : IN     std_logic_vector (15 DOWNTO 0);
      WrEn      : IN     std_logic ;
      clk       : IN     std_logic ;
      rst       : IN     std_logic ;
      RdCnt     : OUT    std_logic ;
      RunCmd    : OUT    std_logic ;
      tri_start : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT tri_per_stat
   GENERIC (
      DELAY_BITS : integer range 8 downto 1 := 3
   );
   PORT (
      CtrlEn    : IN     std_logic ;
      RdEn      : IN     std_ulogic ;
      RunCmd    : IN     std_logic ;
      RunStatus : IN     std_logic ;
      clk       : IN     std_logic ;
      rst       : IN     std_logic ;
      Fail      : OUT    std_ulogic ;
      RunOut    : OUT    std_logic ;
      RData     : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : dither_wrap USE ENTITY tripole_lib.dither_wrap;
   FOR ALL : tri_per_ctrl USE ENTITY tripole_lib.tri_per_ctrl;
   FOR ALL : tri_per_stat USE ENTITY tripole_lib.tri_per_stat;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_2 : dither_wrap
      PORT MAP (
         ExpReset => rst,
         PerEn    => PerEn,
         RdCnt    => RdCnt,
         RdEn     => RdEn,
         WData    => WData,
         WrEn     => WrEn,
         clk      => clk,
         Count    => Count,
         RData    => RData
      );
   U_0 : tri_per_ctrl
      PORT MAP (
         Count     => Count,
         CtrlEn    => CtrlEn,
         WData     => WData,
         WrEn      => WrEn,
         clk       => clk,
         rst       => rst,
         RdCnt     => RdCnt,
         RunCmd    => RunCmd,
         tri_start => tri_start
      );
   U_1 : tri_per_stat
      GENERIC MAP (
         DELAY_BITS => 3
      )
      PORT MAP (
         CtrlEn    => CtrlEn,
         RdEn      => RdEn,
         RunCmd    => RunCmd,
         RunStatus => RunStatus,
         clk       => clk,
         rst       => rst,
         Fail      => Fail,
         RunOut    => RunOut,
         RData     => RData
      );

END struct;
