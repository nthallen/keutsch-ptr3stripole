-- VHDL Entity tripole_lib.tri_pulse.symbol
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 15:38:55 08/09/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tri_pulse IS
   PORT( 
      ExpReset   : IN     std_logic;
      HiPerEn    : IN     std_logic;
      PhaseEn    : IN     std_logic;
      Run        : IN     std_logic;
      WData      : IN     std_logic_vector (15 DOWNTO 0);
      WrEn       : IN     std_logic;
      clk_100MHz : IN     std_logic;
      tri_start  : IN     std_logic;
      pulse      : OUT    std_logic
   );

-- Declarations

END tri_pulse ;

--
-- VHDL Architecture tripole_lib.tri_pulse.struct
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 15:38:55 08/09/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

LIBRARY tripole_lib;

ARCHITECTURE struct OF tri_pulse IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL PerCount  : std_logic_vector(15 DOWNTO 0);
   SIGNAL PerRdEn   : std_ulogic;
   SIGNAL PhsCount  : std_logic_vector(15 DOWNTO 0);
   SIGNAL tri_phase : std_logic;


   -- Component Declarations
   COMPONENT dither_wrap
   PORT (
      ExpReset : IN     std_logic ;
      PerEn    : IN     std_logic ;
      RdEn     : IN     std_ulogic ;
      WData    : IN     std_logic_vector (15 DOWNTO 0);
      WrEn     : IN     std_logic ;
      clk      : IN     std_logic ;
      Count    : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT tri_hi_ctrl
   PORT (
      ExpReset   : IN     std_logic ;
      PerCount   : IN     std_logic_vector (15 DOWNTO 0);
      Run        : IN     std_logic ;
      clk_100MHz : IN     std_logic ;
      tri_phase  : IN     std_logic ;
      PerRdEn    : OUT    std_ulogic ;
      pulse      : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT tri_ph_ctrl
   PORT (
      ExpReset   : IN     std_logic ;
      PhsCount   : IN     std_logic_vector (15 DOWNTO 0);
      Run        : IN     std_logic ;
      clk_100MHz : IN     std_logic ;
      tri_start  : IN     std_logic ;
      tri_phase  : OUT    std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : dither_wrap USE ENTITY tripole_lib.dither_wrap;
   FOR ALL : tri_hi_ctrl USE ENTITY tripole_lib.tri_hi_ctrl;
   FOR ALL : tri_ph_ctrl USE ENTITY tripole_lib.tri_ph_ctrl;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_0 : dither_wrap
      PORT MAP (
         ExpReset => ExpReset,
         PerEn    => PhaseEn,
         RdEn     => tri_start,
         WData    => WData,
         WrEn     => WrEn,
         clk      => clk_100MHz,
         Count    => PhsCount
      );
   U_1 : dither_wrap
      PORT MAP (
         ExpReset => ExpReset,
         PerEn    => HiPerEn,
         RdEn     => PerRdEn,
         WData    => WData,
         WrEn     => WrEn,
         clk      => clk_100MHz,
         Count    => PerCount
      );
   U_3 : tri_hi_ctrl
      PORT MAP (
         ExpReset   => ExpReset,
         PerCount   => PerCount,
         Run        => Run,
         clk_100MHz => clk_100MHz,
         tri_phase  => tri_phase,
         PerRdEn    => PerRdEn,
         pulse      => pulse
      );
   U_2 : tri_ph_ctrl
      PORT MAP (
         ExpReset   => ExpReset,
         PhsCount   => PhsCount,
         Run        => Run,
         clk_100MHz => clk_100MHz,
         tri_start  => tri_start,
         tri_phase  => tri_phase
      );

END struct;
