-- VHDL Entity tripole_lib.tri_per_ctrl.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:29:13 03/ 1/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY tri_per_ctrl IS
  PORT( 
    Count     : IN     std_logic_vector (15 DOWNTO 0);
    CtrlEn    : IN     std_logic;
    WData     : IN     std_logic_vector (15 DOWNTO 0);
    WrEn      : IN     std_logic;
    clk       : IN     std_logic;
    rst       : IN     std_logic;
    RunCmd    : OUT    std_logic;
    tri_start : OUT    std_logic
  );

-- Declarations

END ENTITY tri_per_ctrl ;

--
-- VHDL Architecture tripole_lib.tri_per_ctrl.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:49:24 03/13/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
--  Machine             :  "csm", synchronous
--  Encoding            :  none
--  Style               :  case, 3 processes
--  Clock               :  "clk", rising 
--  Synchronous Reset   :  "rst", synchronous, active high
--  State variable type :  [auto]
--  Default state assignment disabled
--  State actions registered on current state
--  
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
 
ARCHITECTURE fsm OF tri_per_ctrl IS

  -- Architecture Declarations
  SIGNAL CntDn : std_logic_vector(15 DOWNTO 0);  

  TYPE STATE_TYPE IS (
    s0,
    s1,
    s2
  );
 
  -- Declare current and next state signals
  SIGNAL current_state : STATE_TYPE;
  SIGNAL next_state : STATE_TYPE;

  -- Declare any pre-registered internal signals
  SIGNAL RunCmd_cld : std_logic ;
  SIGNAL tri_start_cld : std_logic ;

BEGIN

  -----------------------------------------------------------------
  clocked_proc : PROCESS ( 
    clk
  )
  -----------------------------------------------------------------
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      IF (rst = '1') THEN
        current_state <= s0;
        -- Default Reset Values
        RunCmd_cld <= '0';
        tri_start_cld <= '0';
        CntDn <= (others => '0');
      ELSE
        current_state <= next_state;

        -- Combined Actions
        CASE current_state IS
          WHEN s0 => 
            RunCmd_cld <= '0';
            tri_start_cld <= '0';
            IF (Count < 2) THEN 
            ELSIF (WrEn = '1' AND
                   CtrlEn = '1' AND
                   WData(0) = '1') THEN 
              RunCmd_cld <= '1';
            END IF;
          WHEN s1 => 
            CntDn <= Count - 1;
            tri_start_cld <= '1';
          WHEN s2 => 
            CntDn <= CntDn - 1;
            tri_start_cld <= '0';
          WHEN OTHERS =>
            NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS clocked_proc;
 
  -----------------------------------------------------------------
  nextstate_proc : PROCESS ( 
    CntDn,
    Count,
    CtrlEn,
    WData,
    WrEn,
    current_state
  )
  -----------------------------------------------------------------
  BEGIN
    CASE current_state IS
      WHEN s0 => 
        IF (Count < 2) THEN 
          next_state <= s0;
        ELSIF (WrEn = '1' AND
               CtrlEn = '1' AND
               WData(0) = '1') THEN 
          next_state <= s1;
        ELSE
          next_state <= s0;
        END IF;
      WHEN s1 => 
        IF (WrEn = '1' AND
            CtrlEn = '1' AND
            WData(0) /= '1') THEN 
          next_state <= s0;
        ELSE
          next_state <= s2;
        END IF;
      WHEN s2 => 
        IF (Count < 2) THEN 
          next_state <= s0;
        ELSIF (WrEn = '1' AND
               CtrlEn = '1' AND
               WData(0) /= '1') THEN 
          next_state <= s0;
        ELSIF (CntDn = X"0000" OR
               CntDn = X"0001") THEN 
          next_state <= s1;
        ELSE
          next_state <= s2;
        END IF;
      WHEN OTHERS =>
        next_state <= s0;
    END CASE;
  END PROCESS nextstate_proc;
 
  -- Concurrent Statements
  -- Clocked output assignments
  RunCmd <= RunCmd_cld;
  tri_start <= tri_start_cld;
END ARCHITECTURE fsm;
