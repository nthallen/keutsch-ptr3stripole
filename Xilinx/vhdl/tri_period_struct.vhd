-- VHDL Entity tripole_lib.tri_period.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:49:34 03/13/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
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
    Ilock_rtn : IN     std_logic;
    PerEn     : IN     std_logic;
    WData     : IN     std_logic_vector (15 DOWNTO 0);
    WrEn      : IN     std_logic;
    clk       : IN     std_logic;
    rst       : IN     std_logic;
    Count     : OUT    std_logic_vector (15 DOWNTO 0);
    Fail      : OUT    std_logic;
    RunOut    : OUT    std_logic;
    StatRData : OUT    std_logic_vector (15 DOWNTO 0);
    tri_start : OUT    std_logic
  );

-- Declarations

END ENTITY tri_period ;

--
-- VHDL Architecture tripole_lib.tri_period.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:49:34 03/13/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--

-- Generation properties:
--   Component declarations : yes
--   Configurations         : embedded statements
--                          : add pragmas
--                          : exclude view name
--   
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

LIBRARY tripole_lib;

ARCHITECTURE struct OF tri_period IS

  -- Architecture declarations

  -- Internal signal declarations
  SIGNAL RunCmd : std_logic;

  -- Implicit buffer signal declarations
  SIGNAL Count_internal : std_logic_vector (15 DOWNTO 0);


  -- Component Declarations
  COMPONENT dither_wq
  PORT (
    ExpReset : IN     std_logic ;
    PerEn    : IN     std_logic ;
    WData    : IN     std_logic_vector (15 DOWNTO 0);
    WrEn     : IN     std_logic ;
    clk      : IN     std_logic ;
    Count    : OUT    std_logic_vector (15 DOWNTO 0)
  );
  END COMPONENT dither_wq;
  COMPONENT tri_per_ctrl
  PORT (
    Count     : IN     std_logic_vector (15 DOWNTO 0);
    CtrlEn    : IN     std_logic ;
    WData     : IN     std_logic_vector (15 DOWNTO 0);
    WrEn      : IN     std_logic ;
    clk       : IN     std_logic ;
    rst       : IN     std_logic ;
    RunCmd    : OUT    std_logic ;
    tri_start : OUT    std_logic 
  );
  END COMPONENT tri_per_ctrl;
  COMPONENT tri_per_stat
  PORT (
    CtrlEn    : IN     std_logic ;
    RunCmd    : IN     std_logic ;
    clk       : IN     std_logic ;
    rst       : IN     std_logic ;
    Fail      : OUT    std_logic ;
    RunOut    : OUT    std_logic ;
    StatRData : OUT    std_logic_vector (15 DOWNTO 0);
    Ilock_rtn : IN     std_logic 
  );
  END COMPONENT tri_per_stat;

  -- Optional embedded configurations
  -- pragma synthesis_off
  FOR ALL : dither_wq USE ENTITY tripole_lib.dither_wq;
  FOR ALL : tri_per_ctrl USE ENTITY tripole_lib.tri_per_ctrl;
  FOR ALL : tri_per_stat USE ENTITY tripole_lib.tri_per_stat;
  -- pragma synthesis_on


BEGIN

  -- Instance port mappings.
  wq : dither_wq
    PORT MAP (
      ExpReset => rst,
      PerEn    => PerEn,
      WData    => WData,
      WrEn     => WrEn,
      clk      => clk,
      Count    => Count_internal
    );
  per_ctrl : tri_per_ctrl
    PORT MAP (
      Count     => Count_internal,
      CtrlEn    => CtrlEn,
      WData     => WData,
      WrEn      => WrEn,
      clk       => clk,
      rst       => rst,
      RunCmd    => RunCmd,
      tri_start => tri_start
    );
  per_stat : tri_per_stat
    PORT MAP (
      CtrlEn    => CtrlEn,
      RunCmd    => RunCmd,
      clk       => clk,
      rst       => rst,
      Fail      => Fail,
      RunOut    => RunOut,
      StatRData => StatRData,
      Ilock_rtn => Ilock_rtn
    );

  -- Implicit buffered output assignments
  Count <= Count_internal;

END ARCHITECTURE struct;
