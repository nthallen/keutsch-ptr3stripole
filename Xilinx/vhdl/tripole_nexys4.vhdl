-------------------------------------------------------------------------------
-- tripole_nexys4.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity tripole_nexys4 is
  port (
    RS232_TX        : out std_logic;
    RS232_RX        : in std_logic;
    JXADC_I1        : IN  std_logic_vector (1 DOWNTO 0);
    JXADC           : OUT std_logic_vector (2 DOWNTO 2);
    JXADC_I2        : IN  std_logic_vector (7 DOWNTO 3);
    JA_I1           : IN  std_logic_vector (1 DOWNTO 0);
    JA              : OUT std_logic_vector (2 DOWNTO 2);
    JA_I2           : IN  std_logic_vector (7 DOWNTO 3);
    JB_I1           : IN  std_logic_vector (1 DOWNTO 0);
    JB              : OUT std_logic_vector (3 DOWNTO 2);
    JB_I2           : IN  std_logic_vector (7 DOWNTO 4);
    JC              : OUT std_logic_vector (7 DOWNTO 0);
    JD              : OUT std_logic_vector (7 DOWNTO 0);
    Nexys4_LEDs     : out std_logic_vector(15 downto 0);
    Nexys4_Switches : in  std_logic_vector(15 downto 0);
    clk_100MHz_in   : in  std_logic;
    RESET           : in  std_logic
  );
end tripole_nexys4;

architecture STRUCTURE of tripole_nexys4 is
  SIGNAL subbus_addr : std_logic_vector(7 downto 0);
  SIGNAL subbus_ctrl : std_logic_vector(6 downto 0);
  SIGNAL subbus_data_i : std_logic_vector(15 downto 0);
  SIGNAL subbus_data_o : std_logic_vector(15 downto 0);
  SIGNAL subbus_status : std_logic_vector(3 downto 0);
  SIGNAL Clk_100MHz : std_logic;
  SIGNAL tri_pulse_A : std_logic;
  SIGNAL tri_pulse_B : std_logic;
  SIGNAL tri_pulse_C : std_logic;
  SIGNAL Fail_Out : std_logic;
  SIGNAL Run_int : std_logic;
  SIGNAL RunStatus : std_logic;
  SIGNAL LEDs : std_logic_vector(15 downto 0);
  
  component MBlaze is
    port (
      RS232_TX : out std_logic;
      RS232_RX : in std_logic;
      RESET : in std_logic;
      axi_gpio_subbus_addr_pin : out std_logic_vector(7 downto 0);
      axi_gpio_subbus_ctrl_pin : out std_logic_vector(6 downto 0);
      axi_gpio_subbus_data_i_pin : in std_logic_vector(15 downto 0);
      axi_gpio_subbus_data_o_pin : out std_logic_vector(15 downto 0);
      axi_gpio_subbus_status_pin : in std_logic_vector(3 downto 0);
      axi_gpio_subbus_leds_pin : out std_logic_vector(15 downto 0);
      axi_gpio_subbus_switches_pin : in std_logic_vector(15 downto 0);
      clk_100MHz_in_pin : in std_logic;
      CLK_OUT : out std_logic
    );
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of MBlaze : component is "user_black_box";

  component tri_lvl_b IS
     GENERIC( 
        N_INTERRUPTS : integer := 0
     );
     PORT( 
        Addr        : IN  std_logic_vector (7 DOWNTO 0);
        Ctrl        : IN  std_logic_vector (6 DOWNTO 0);
        Data_o      : IN  std_logic_vector (15 DOWNTO 0);
        RunStatus   : IN  std_logic;
        Fail_Out    : OUT std_ulogic;
        Run         : OUT std_logic;
        clk_100MHz  : IN  std_logic;
        Data_i      : OUT std_logic_vector (15 DOWNTO 0);
        Status      : OUT std_logic_vector (3 DOWNTO 0);
        tri_pulse_A : OUT std_logic;
        tri_pulse_B : OUT std_logic;
        tri_pulse_C : OUT std_logic
     );
  end component;

begin

  MBlaze_i : MBlaze
    port map (
      RS232_TX => RS232_TX,
      RS232_RX => RS232_RX,
      RESET => RESET,
      axi_gpio_subbus_addr_pin => subbus_addr,
      axi_gpio_subbus_ctrl_pin => subbus_ctrl,
      axi_gpio_subbus_data_i_pin => subbus_data_i,
      axi_gpio_subbus_data_o_pin => subbus_data_o,
      axi_gpio_subbus_status_pin => subbus_status,
      axi_gpio_subbus_leds_pin => LEDs,
      axi_gpio_subbus_switches_pin => Nexys4_Switches,
      clk_100MHz_in_pin => clk_100MHz_in,
      CLK_OUT => Clk_100MHz
    );

  tripole : tri_lvl_b
    port map (
      Addr => subbus_addr,
      Ctrl => subbus_ctrl,
      Data_o => subbus_data_o,
      Data_i => subbus_data_i,
      Status => subbus_status,
      clk_100MHz => Clk_100MHz,
      tri_pulse_A => tri_pulse_A,
      tri_pulse_B => tri_pulse_B,
      tri_pulse_C => tri_pulse_C,
      Run => Run_int,
      RunStatus => RunStatus,
      Fail_Out => Fail_Out
    );
    
  JXADC(2) <= tri_pulse_A;
  RunStatus <= JXADC_I2(7);
  JA(2) <= tri_pulse_B;
  JB(2) <= tri_pulse_C;
  JB(3) <= Run_int;
  Nexys4_LEDs(0) <= Fail_Out;
  Nexys4_LEDs(1) <= Run_int;
  Nexys4_LEDs(2) <= RunStatus;
  Nexys4_LEDs(15 downto 3) <= LEDs(15 downto 3);
end architecture STRUCTURE;

