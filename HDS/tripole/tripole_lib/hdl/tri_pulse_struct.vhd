-- VHDL Entity tripole_lib.tri_pulse.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 20:56:56 03/14/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tri_pulse IS
  GENERIC( 
    ADJUSTABLE : std_logic := '1';
    DELAY_BITS : integer   := 7;
    PHASE_RES  : integer   := 280
  );
  PORT( 
    ExpReset  : IN     std_logic;
    HiPerEn   : IN     std_logic;
    PSDONE    : IN     std_logic;
    PhaseEn   : IN     std_logic;
    Run       : IN     std_logic;
    WData     : IN     std_logic_vector (15 DOWNTO 0);
    WrEn      : IN     std_logic;
    clk       : IN     std_logic;
    tri_start : IN     std_logic;
    PSEN      : OUT    std_logic;
    PSINCDEC  : OUT    std_logic;
    PerCount  : OUT    std_logic_vector (15 DOWNTO 0);
    PhsCount  : OUT    std_logic_vector (15 DOWNTO 0);
    clk_phase : OUT    std_logic;
    pulse     : OUT    std_logic
  );

-- Declarations

END ENTITY tri_pulse ;

--
-- VHDL Architecture tripole_lib.tri_pulse.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 20:56:56 03/14/2017
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
USE ieee.numeric_std.all;

LIBRARY tripole_lib;

ARCHITECTURE struct OF tri_pulse IS

  -- Architecture declarations

  -- Internal signal declarations
  SIGNAL Delay     : std_logic_vector(DELAY_BITS-1 DOWNTO 0);
  SIGNAL tri_phase : std_logic;

  -- Implicit buffer signal declarations
  SIGNAL PerCount_internal : std_logic_vector (15 DOWNTO 0);


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
  COMPONENT phase
  GENERIC (
    DELAY_BITS : integer   := 7;
    PHASE_RES  : integer   := 280;
    PHASE_BITS : integer   := 9;
    ADJUSTABLE : std_logic := '1'
  );
  PORT (
    PSDONE    : IN     std_logic;
    PerEn     : IN     std_logic;
    WData     : IN     std_logic_vector (15 DOWNTO 0);
    WrEn      : IN     std_logic;
    clk       : IN     std_logic;
    rst       : IN     std_logic;
    DiOut     : OUT    std_logic_vector (DELAY_BITS-1 DOWNTO 0);
    PSEN      : OUT    std_logic;
    PSINCDEC  : OUT    std_logic;
    PhaseOut  : OUT    std_logic_vector (15 DOWNTO 0);
    clk_phase : OUT    std_logic
  );
  END COMPONENT phase;
  COMPONENT tri_hi_ctrl
  PORT (
    ExpReset  : IN     std_logic ;
    PerCount  : IN     std_logic_vector (15 DOWNTO 0);
    Run       : IN     std_logic ;
    clk       : IN     std_logic ;
    tri_phase : IN     std_logic ;
    pulse     : OUT    std_logic 
  );
  END COMPONENT tri_hi_ctrl;
  COMPONENT tri_ph_ctrl
  GENERIC (
    DELAY_BITS : integer := 7
  );
  PORT (
    Delay     : IN     std_logic_vector (DELAY_BITS-1 DOWNTO 0);
    ExpReset  : IN     std_logic ;
    Run       : IN     std_logic ;
    clk       : IN     std_logic ;
    tri_start : IN     std_logic ;
    tri_phase : OUT    std_logic 
  );
  END COMPONENT tri_ph_ctrl;

  -- Optional embedded configurations
  -- pragma synthesis_off
  FOR ALL : dither_wq USE ENTITY tripole_lib.dither_wq;
  FOR ALL : phase USE ENTITY tripole_lib.phase;
  FOR ALL : tri_hi_ctrl USE ENTITY tripole_lib.tri_hi_ctrl;
  FOR ALL : tri_ph_ctrl USE ENTITY tripole_lib.tri_ph_ctrl;
  -- pragma synthesis_on


BEGIN

  -- Instance port mappings.
  PerSet : dither_wq
    PORT MAP (
      ExpReset => ExpReset,
      PerEn    => HiPerEn,
      WData    => WData,
      WrEn     => WrEn,
      clk      => clk,
      Count    => PerCount_internal
    );
  PhsCtrl : phase
    GENERIC MAP (
      DELAY_BITS => DELAY_BITS,
      PHASE_RES  => PHASE_RES,
      PHASE_BITS => 9,
      ADJUSTABLE => ADJUSTABLE
    )
    PORT MAP (
      PerEn     => PhaseEn,
      WData     => WData,
      WrEn      => WrEn,
      DiOut     => Delay,
      PhaseOut  => PhsCount,
      clk_phase => clk_phase,
      PSEN      => PSEN,
      PSINCDEC  => PSINCDEC,
      PSDONE    => PSDONE,
      clk       => clk,
      rst       => ExpReset
    );
  hi_ctrl : tri_hi_ctrl
    PORT MAP (
      ExpReset  => ExpReset,
      PerCount  => PerCount_internal,
      Run       => Run,
      clk       => clk,
      tri_phase => tri_phase,
      pulse     => pulse
    );
  ph_ctrl : tri_ph_ctrl
    GENERIC MAP (
      DELAY_BITS => DELAY_BITS
    )
    PORT MAP (
      Delay     => Delay,
      ExpReset  => ExpReset,
      Run       => Run,
      clk       => clk,
      tri_start => tri_start,
      tri_phase => tri_phase
    );

  -- Implicit buffered output assignments
  PerCount <= PerCount_internal;

END ARCHITECTURE struct;
