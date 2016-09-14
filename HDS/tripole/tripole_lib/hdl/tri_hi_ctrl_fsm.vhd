-- VHDL Entity tripole_lib.tri_hi_ctrl.interface
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 13:57:02 08/09/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY tri_hi_ctrl IS
   PORT( 
      ExpReset   : IN     std_logic;
      PerCount   : IN     std_logic_vector (15 DOWNTO 0);
      Run        : IN     std_logic;
      clk_100MHz : IN     std_logic;
      tri_phase  : IN     std_logic;
      PerRdEn    : OUT    std_ulogic;
      pulse      : OUT    std_logic
   );

-- Declarations

END tri_hi_ctrl ;

--
-- VHDL Architecture tripole_lib.tri_hi_ctrl.fsm
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 16:50:24 08/09/16
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
 
ARCHITECTURE fsm OF tri_hi_ctrl IS

   -- Architecture Declarations
   SIGNAL CntDn : std_logic_vector(15 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      s0,
      s4,
      s3,
      s2,
      s5
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL PerRdEn_cld : std_ulogic ;
   SIGNAL pulse_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk_100MHz
   )
   -----------------------------------------------------------------
   BEGIN
      IF (clk_100MHz'EVENT AND clk_100MHz = '1') THEN
         IF (ExpReset = '1') THEN
            current_state <= s0;
            -- Default Reset Values
            PerRdEn_cld <= '0';
            pulse_cld <= '0';
            CntDn <= (others => '0');
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN s0 => 
                  pulse_cld <= '0';
                  IF (Run = '1') THEN 
                     pulse_cld <= '0';
                     PerRdEn_cld <= '0';
                  END IF;
               WHEN s4 => 
                  pulse_cld <= '0';
                  PerRdEn_cld <= '0';
               WHEN s3 => 
                  CntDn <= CntDn - 1;
                  PerRdEn_cld <= '0';
                  IF (Run /= '1') THEN 
                  ELSIF (CntDn = X"0000" AND
                         tri_phase /= '1') THEN 
                     pulse_cld <= '0';
                     PerRdEn_cld <= '0';
                  ELSIF (CntDn = X"0000" AND
                         tri_phase = '1') THEN 
                     CntDn <= PerCount-1;
                     PerRdEn_cld <= '1';
                  END IF;
               WHEN s2 => 
                  CntDn <= PerCount-1;
                  IF (Run /= '1') THEN 
                  ELSIF (tri_phase = '1' AND
                         PerCount = X"0000") THEN 
                     PerRdEn_cld <= '1';
                  ELSIF (tri_phase = '1') THEN 
                     PerRdEn_cld <= '1';
                     pulse_cld <= '1';
                  END IF;
               WHEN s5 => 
                  CntDn <= CntDn - 1;
                  PerRdEn_cld <= '0';
                  IF (CntDn = X"0000" AND
                      tri_phase /= '1') THEN 
                     pulse_cld <= '0';
                     PerRdEn_cld <= '0';
                  ELSIF (CntDn = X"0000" AND
                         tri_phase = '1') THEN 
                     CntDn <= PerCount-1;
                     PerRdEn_cld <= '1';
                  END IF;
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      CntDn,
      PerCount,
      Run,
      current_state,
      tri_phase
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN s0 => 
            IF (Run = '1') THEN 
               next_state <= s2;
            ELSE
               next_state <= s0;
            END IF;
         WHEN s4 => 
            next_state <= s2;
         WHEN s3 => 
            IF (Run /= '1') THEN 
               next_state <= s0;
            ELSIF (CntDn = X"0000" AND
                   tri_phase /= '1') THEN 
               next_state <= s2;
            ELSIF (CntDn = X"0000" AND
                   tri_phase = '1') THEN 
               next_state <= s5;
            ELSE
               next_state <= s3;
            END IF;
         WHEN s2 => 
            IF (Run /= '1') THEN 
               next_state <= s0;
            ELSIF (tri_phase = '1' AND
                   PerCount = X"0000") THEN 
               next_state <= s4;
            ELSIF (tri_phase = '1') THEN 
               next_state <= s3;
            ELSE
               next_state <= s2;
            END IF;
         WHEN s5 => 
            IF (CntDn = X"0000" AND
                tri_phase /= '1') THEN 
               next_state <= s2;
            ELSIF (CntDn = X"0000" AND
                   tri_phase = '1') THEN 
               next_state <= s5;
            ELSE
               next_state <= s5;
            END IF;
         WHEN OTHERS =>
            next_state <= s0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   PerRdEn <= PerRdEn_cld;
   pulse <= pulse_cld;
END fsm;
