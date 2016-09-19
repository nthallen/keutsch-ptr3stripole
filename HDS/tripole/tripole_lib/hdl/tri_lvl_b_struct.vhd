-- VHDL Entity tripole_lib.tri_lvl_b.symbol
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 13:45:00 09/19/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY tri_lvl_b IS
   GENERIC( 
      N_INTERRUPTS : integer := 0
   );
   PORT( 
      Addr        : IN     std_logic_vector (7 DOWNTO 0);
      Ctrl        : IN     std_logic_vector (6 DOWNTO 0);
      Data_o      : IN     std_logic_vector (15 DOWNTO 0);
      clk_100MHz  : IN     std_logic;
      Data_i      : OUT    std_logic_vector (15 DOWNTO 0);
      Status      : OUT    std_logic_vector (3 DOWNTO 0);
      tri_pulse_A : OUT    std_logic;
      tri_pulse_B : OUT    std_logic;
      tri_pulse_C : OUT    std_logic
   );

-- Declarations

END tri_lvl_b ;

--
-- VHDL Architecture tripole_lib.tri_lvl_b.struct
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 13:45:00 09/19/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

LIBRARY tripole_lib;

ARCHITECTURE struct OF tri_lvl_b IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL AHiPerEn  : std_logic;
   SIGNAL APhaseEn  : std_logic;
   SIGNAL BHiPerEn  : std_logic;
   SIGNAL BPhaseEn  : std_logic;
   SIGNAL BdEn      : std_ulogic;
   SIGNAL BdIntr    : std_ulogic_vector(N_INTERRUPTS-1 DOWNTO 0);
   SIGNAL CHiPerEn  : std_logic;
   SIGNAL CPhaseEn  : std_logic;
   SIGNAL CtrlEn    : std_logic;
   SIGNAL ExpAck    : std_logic_vector(0 TO 0);
   SIGNAL ExpAddr   : std_logic_vector(7 DOWNTO 0);
   SIGNAL ExpRd     : std_logic;
   SIGNAL ExpReset  : std_logic;
   SIGNAL ExpWr     : std_logic;
   SIGNAL Fail_In   : std_ulogic;
   SIGNAL PerEn     : std_logic;
   SIGNAL RData     : std_logic_vector(15 DOWNTO 0);
   SIGNAL RdEn      : std_ulogic;
   SIGNAL Run       : std_logic;
   SIGNAL WData     : std_logic_vector(15 DOWNTO 0);
   SIGNAL WrEn      : std_logic;
   SIGNAL tri_start : std_logic;


   -- Component Declarations
   COMPONENT subbus_io
   PORT (
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      ExpAck : OUT    std_ulogic ;
      F8M    : IN     std_ulogic ;
      RdEn   : OUT    std_ulogic ;
      WrEn   : OUT    std_ulogic ;
      BdEn   : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT syscon
   GENERIC (
      DACS_BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"0007";
      INSTRUMENT_ID     : std_logic_vector(15 DOWNTO 0) := X"0001";
      N_INTERRUPTS      : integer range 15 downto 0     := 1;
      N_BOARDS          : integer range 15 downto 0     := 1
   );
   PORT (
      Addr          : IN     std_logic_vector (7 DOWNTO 0);
      BdIntr        : IN     std_ulogic_vector (N_INTERRUPTS-1 DOWNTO 0);
      Ctrl          : IN     std_logic_vector (6 DOWNTO 0);
      Data_o        : IN     std_logic_vector (15 DOWNTO 0);
      ExpAck        : IN     std_logic_vector (N_BOARDS-1 DOWNTO 0);
      F8M           : IN     std_logic;
      Fail_In       : IN     std_ulogic;
      RData         : IN     std_logic_vector (16*N_BOARDS-1 DOWNTO 0);
      CmdEnbl       : OUT    std_ulogic;
      CmdStrb       : OUT    std_ulogic;
      Collision     : OUT    std_ulogic;
      Data_i        : OUT    std_logic_vector (15 DOWNTO 0);
      ExpAddr       : OUT    std_logic_vector (7 DOWNTO 0);
      ExpRd         : OUT    std_logic;
      ExpReset      : OUT    std_ulogic;
      ExpWr         : OUT    std_logic;
      Fail_Out      : OUT    std_ulogic;
      Flt_CPU_Reset : OUT    std_ulogic;
      INTA          : OUT    std_ulogic;
      Status        : OUT    std_logic_vector (3 DOWNTO 0);
      WData         : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT tri_addr
   GENERIC (
      BASE_ADDR : std_logic_vector (7 DOWNTO 0) := X"20"
   );
   PORT (
      ExpAddr  : IN     std_logic_vector (7 DOWNTO 0);
      AHiPerEn : OUT    std_logic ;
      APhaseEn : OUT    std_logic ;
      BHiPerEn : OUT    std_logic ;
      BPhaseEn : OUT    std_logic ;
      BdEn     : OUT    std_ulogic ;
      CHiPerEn : OUT    std_logic ;
      CPhaseEn : OUT    std_logic ;
      CtrlEn   : OUT    std_logic ;
      Fail_In  : OUT    std_ulogic ;
      PerEn    : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT tri_period
   PORT (
      CtrlEn    : IN     std_logic ;
      PerEn     : IN     std_logic ;
      RdEn      : IN     std_ulogic ;
      WData     : IN     std_logic_vector (15 DOWNTO 0);
      WrEn      : IN     std_logic ;
      clk       : IN     std_logic ;
      rst       : IN     std_logic ;
      RunOut    : OUT    std_logic ;
      tri_start : OUT    std_logic ;
      RData     : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT tri_pulse
   PORT (
      ExpReset   : IN     std_logic ;
      HiPerEn    : IN     std_logic ;
      PhaseEn    : IN     std_logic ;
      RdEn       : IN     std_logic ;
      Run        : IN     std_logic ;
      WData      : IN     std_logic_vector (15 DOWNTO 0);
      WrEn       : IN     std_logic ;
      clk_100MHz : IN     std_logic ;
      tri_start  : IN     std_logic ;
      pulse      : OUT    std_logic ;
      RData      : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : subbus_io USE ENTITY tripole_lib.subbus_io;
   FOR ALL : syscon USE ENTITY tripole_lib.syscon;
   FOR ALL : tri_addr USE ENTITY tripole_lib.tri_addr;
   FOR ALL : tri_period USE ENTITY tripole_lib.tri_period;
   FOR ALL : tri_pulse USE ENTITY tripole_lib.tri_pulse;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_5 : subbus_io
      PORT MAP (
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck(0),
         F8M    => clk_100MHz,
         RdEn   => RdEn,
         WrEn   => WrEn,
         BdEn   => BdEn
      );
   U_2 : syscon
      GENERIC MAP (
         DACS_BUILD_NUMBER => X"0001",
         INSTRUMENT_ID     => X"0006",
         N_INTERRUPTS      => N_INTERRUPTS,
         N_BOARDS          => 1
      )
      PORT MAP (
         F8M           => clk_100MHz,
         Ctrl          => Ctrl,
         Addr          => Addr,
         Data_i        => Data_i,
         Data_o        => Data_o,
         Status        => Status,
         ExpRd         => ExpRd,
         ExpWr         => ExpWr,
         WData         => WData,
         RData         => RData,
         ExpAddr       => ExpAddr,
         ExpAck        => ExpAck,
         BdIntr        => BdIntr,
         Collision     => OPEN,
         INTA          => OPEN,
         CmdEnbl       => OPEN,
         CmdStrb       => OPEN,
         ExpReset      => ExpReset,
         Fail_In       => Fail_In,
         Fail_Out      => OPEN,
         Flt_CPU_Reset => OPEN
      );
   U_3 : tri_addr
      GENERIC MAP (
         BASE_ADDR => X"20"
      )
      PORT MAP (
         ExpAddr  => ExpAddr,
         AHiPerEn => AHiPerEn,
         APhaseEn => APhaseEn,
         BHiPerEn => BHiPerEn,
         BPhaseEn => BPhaseEn,
         BdEn     => BdEn,
         CHiPerEn => CHiPerEn,
         CPhaseEn => CPhaseEn,
         CtrlEn   => CtrlEn,
         Fail_In  => Fail_In,
         PerEn    => PerEn
      );
   U_0 : tri_period
      PORT MAP (
         CtrlEn    => CtrlEn,
         PerEn     => PerEn,
         RdEn      => RdEn,
         WData     => WData,
         WrEn      => WrEn,
         clk       => clk_100MHz,
         rst       => ExpReset,
         RunOut    => Run,
         tri_start => tri_start,
         RData     => RData
      );
   U_1 : tri_pulse
      PORT MAP (
         ExpReset   => ExpReset,
         HiPerEn    => AHiPerEn,
         PhaseEn    => APhaseEn,
         RdEn       => RdEn,
         Run        => Run,
         WData      => WData,
         WrEn       => WrEn,
         clk_100MHz => clk_100MHz,
         tri_start  => tri_start,
         pulse      => tri_pulse_A,
         RData      => RData
      );
   U_4 : tri_pulse
      PORT MAP (
         ExpReset   => ExpReset,
         HiPerEn    => BHiPerEn,
         PhaseEn    => BPhaseEn,
         RdEn       => RdEn,
         Run        => Run,
         WData      => WData,
         WrEn       => WrEn,
         clk_100MHz => clk_100MHz,
         tri_start  => tri_start,
         pulse      => tri_pulse_B,
         RData      => RData
      );
   U_6 : tri_pulse
      PORT MAP (
         ExpReset   => ExpReset,
         HiPerEn    => CHiPerEn,
         PhaseEn    => CPhaseEn,
         RdEn       => RdEn,
         Run        => Run,
         WData      => WData,
         WrEn       => WrEn,
         clk_100MHz => clk_100MHz,
         tri_start  => tri_start,
         pulse      => tri_pulse_C,
         RData      => RData
      );

END struct;
