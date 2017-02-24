-- VHDL Entity tripole_lib.dither_wrap.symbol
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 15:46:53 09/14/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY dither_wrap IS
   PORT( 
      ExpReset : IN     std_logic;
      PerEn    : IN     std_logic;
      RdCnt    : IN     std_ulogic;
      RdEn     : IN     std_ulogic;
      WData    : IN     std_logic_vector (15 DOWNTO 0);
      WrEn     : IN     std_logic;
      clk      : IN     std_logic;
      Count    : OUT    std_logic_vector (15 DOWNTO 0);
      RData    : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END dither_wrap ;

--
-- VHDL Architecture tripole_lib.dither_wrap.struct
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 15:46:52 09/14/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

-- LIBRARY tripole_lib;

ARCHITECTURE struct OF dither_wrap IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Ready  : std_logic;
   SIGNAL WData1 : std_logic_vector(15 DOWNTO 0);
   SIGNAL WrEn1  : std_logic;


   -- Component Declarations
   COMPONENT dither
   PORT (
      RdEn  : IN     std_ulogic ;
      WData : IN     std_logic_vector (15 DOWNTO 0);
      WrEn  : IN     std_logic ;
      clk   : IN     std_logic ;
      rst   : IN     std_logic ;
      Count : OUT    std_logic_vector (15 DOWNTO 0);
      Ready : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT dither_wq
   PORT (
      ExpReset : IN     std_logic ;
      PerEn    : IN     std_logic ;
      RdEn     : IN     std_ulogic ;
      Ready    : IN     std_logic ;
      WData    : IN     std_logic_vector (15 DOWNTO 0);
      WrEn     : IN     std_logic ;
      clk      : IN     std_logic ;
      WData1   : OUT    std_logic_vector (15 DOWNTO 0);
      WrEn1    : OUT    std_logic ;
      RData    : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   -- FOR ALL : dither USE ENTITY tripole_lib.dither;
   -- FOR ALL : dither_wq USE ENTITY tripole_lib.dither_wq;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_1 : dither
      PORT MAP (
         RdEn  => RdCnt,
         WData => WData1,
         WrEn  => WrEn1,
         clk   => clk,
         rst   => ExpReset,
         Count => Count,
         Ready => Ready
      );
   U_0 : dither_wq
      PORT MAP (
         ExpReset => ExpReset,
         PerEn    => PerEn,
         RdEn     => RdEn,
         Ready    => Ready,
         WData    => WData,
         WrEn     => WrEn,
         clk      => clk,
         WData1   => WData1,
         WrEn1    => WrEn1,
         RData    => RData
      );

END struct;
