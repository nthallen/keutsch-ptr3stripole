--
-- VHDL Architecture tripole_lib.tri_wrap.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:30:39 01/24/2017
--
-- using Mentor Graphics HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tri_wrap IS
    PORT (
      Addr        : IN     std_logic_vector(7 DOWNTO 0);
      Ctrl        : IN     std_logic_vector(6 DOWNTO 0);
      Data_i      : OUT    std_logic_vector(15 DOWNTO 0);
      Data_o      : IN     std_logic_vector(15 DOWNTO 0);
      Status      : OUT    std_logic_vector(3 DOWNTO 0);
      Run         : OUT    std_logic;
      RunStatus   : IN     std_logic;
      leds        : OUT    std_logic_vector(1 DOWNTO 0);
      tri_pulse_A : OUT    std_logic;
      tri_pulse_B : OUT    std_logic;
      tri_pulse_C : OUT    std_logic;
      clk         : IN     std_logic
    );
END ENTITY tri_wrap;

--
ARCHITECTURE beh OF tri_wrap IS
  SIGNAL Switches    : std_logic_vector(0-1 DOWNTO 0);
  SIGNAL Fail_Out    : std_logic_vector(0 TO 0);
  SIGNAL IlckFail    : std_logic;
  COMPONENT tri_lvl_b
    GENERIC (
      N_INTERRUPTS : integer := 1;
      SW_WIDTH     : integer := 16;
      BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"0009"
    );
    PORT (
      Addr        : IN     std_logic_vector(7 DOWNTO 0);
      Ctrl        : IN     std_logic_vector(6 DOWNTO 0);
      Data_o      : IN     std_logic_vector(15 DOWNTO 0);
      RunStatus   : IN     std_logic;
      Switches    : IN     std_logic_vector(SW_WIDTH-1 DOWNTO 0);
      clk_100MHz  : IN     std_logic;
      Data_i      : OUT    std_logic_vector(15 DOWNTO 0);
      Fail_Out    : OUT    std_logic_vector(0 TO 0);
      IlckFail    : OUT    std_logic;
      Run         : OUT    std_logic;
      Status      : OUT    std_logic_vector(3 DOWNTO 0);
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
      BUILD_NUMBER => X"0008"
    )
    PORT MAP (
      Addr        => Addr,
      Ctrl        => Ctrl,
      Data_o      => Data_o,
      RunStatus   => RunStatus,
      Switches    => Switches,
      clk_100MHz  => clk,
      Data_i      => Data_i,
      Fail_Out    => Fail_Out,
      IlckFail    => IlckFail,
      Run         => Run,
      Status      => Status,
      tri_pulse_A => tri_pulse_A,
      tri_pulse_B => tri_pulse_B,
      tri_pulse_C => tri_pulse_C
    );
    
    leds <= Fail_Out & IlckFail;
END ARCHITECTURE beh;

