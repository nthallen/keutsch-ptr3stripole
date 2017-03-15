--
-- VHDL Architecture tripole_lib.tri_wrap.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:30:39 01/24/2017
--
-- 3/12/2017 Updated for fine phase control, Build 9
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tri_wrap IS
    GENERIC (
      BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"0009";
      PHASE_RES : integer := 280
    );
    PORT (
      Addr        : IN     std_logic_vector(7 DOWNTO 0);
      Ctrl        : IN     std_logic_vector(6 DOWNTO 0);
      Data_i      : OUT    std_logic_vector(15 DOWNTO 0);
      Data_o      : IN     std_logic_vector(15 DOWNTO 0);
      Status      : OUT    std_logic_vector(3 DOWNTO 0);
      Ilock_out   : OUT    std_logic;
      Ilock_rtn   : IN     std_logic;
      leds        : OUT    std_logic_vector(1 DOWNTO 0);
      tri_pulse_A : OUT    std_logic;
      tri_pulse_B : OUT    std_logic;
      tri_pulse_C : OUT    std_logic;
      clk         : IN     std_logic;
      PSDONEB     : IN     std_logic;
      PSDONEC     : IN     std_logic;
      clkB        : IN     std_logic;
      clkC        : IN     std_logic;
      PSENB       : OUT    std_logic;
      PSENC       : OUT    std_logic;
      PSINCDECB   : OUT    std_logic;
      PSINCDECC   : OUT    std_logic
    );
END ENTITY tri_wrap;

--
ARCHITECTURE beh OF tri_wrap IS
  SIGNAL Switches    : std_logic_vector(0-1 DOWNTO 0);
  SIGNAL Fail_Out    : std_logic_vector(0 TO 0);
  SIGNAL Ilock_fail  : std_logic;
  SIGNAL Run         : std_logic;
  COMPONENT tri_lvl_b
    GENERIC (
      N_INTERRUPTS : integer := 1;
      SW_WIDTH     : integer := 16;
      BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"0009";
      N_BOARDS : integer := 8;
      PHASE_RES : integer := 280
    );
    PORT (
      Addr        : IN     std_logic_vector (7 DOWNTO 0);
      Ctrl        : IN     std_logic_vector (6 DOWNTO 0);
      Data_o      : IN     std_logic_vector (15 DOWNTO 0);
      Ilock_rtn   : IN     std_logic;
      PSDONEB     : IN     std_logic;
      PSDONEC     : IN     std_logic;
      Switches    : IN     std_logic_vector (SW_WIDTH-1 DOWNTO 0);
      clk         : IN     std_logic;
      clkB        : IN     std_logic;
      clkC        : IN     std_logic;
      Data_i      : OUT    std_logic_vector (15 DOWNTO 0);
      Fail_Out    : OUT    std_logic_vector (0 TO 0);
      Ilock_fail  : OUT    std_logic;
      PSENB       : OUT    std_logic;
      PSENC       : OUT    std_logic;
      PSINCDECB   : OUT    std_logic;
      PSINCDECC   : OUT    std_logic;
      Status      : OUT    std_logic_vector (3 DOWNTO 0);
      tri_pulse_A : OUT    std_logic;
      tri_pulse_B : OUT    std_logic;
      tri_pulse_C : OUT    std_logic
    );
  END COMPONENT tri_lvl_b;
BEGIN
  --  hds hds_inst
  tripole : tri_lvl_b
    GENERIC MAP (
      N_INTERRUPTS => 0,
      SW_WIDTH     => 0,
      BUILD_NUMBER => BUILD_NUMBER,
      N_BOARDS => 8,
      PHASE_RES => PHASE_RES
    )
    PORT MAP (
      Addr        => Addr,
      Ctrl        => Ctrl,
      Data_o      => Data_o,
      Ilock_rtn   => Ilock_rtn,
      Switches    => Switches,
      clk         => clk,
      Data_i      => Data_i,
      Fail_Out    => Fail_Out,
      Ilock_fail  => Ilock_fail,
      Status      => Status,
      tri_pulse_A => tri_pulse_A,
      tri_pulse_B => tri_pulse_B,
      tri_pulse_C => tri_pulse_C,
      PSDONEB     => PSDONEB,
      PSDONEC     => PSDONEC,
      clkB        => clkB,
      clkC        => clkC,
      PSENB       => PSENB,
      PSENC       => PSENC,
      PSINCDECB   => PSINCDECB,
      PSINCDECC   => PSINCDECC
    );
    
    leds <= Fail_Out & Ilock_fail;
    Ilock_out <= '1';
END ARCHITECTURE beh;

