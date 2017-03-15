--
-- VHDL Architecture tripole_lib.phase.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:29:50 03/ 9/2017
--
-- using Mentor Graphics HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY phase IS
  GENERIC (
    DELAY_BITS : integer := 7;
    PHASE_RES : integer := 280;
    PHASE_BITS : integer := 9;
    ADJUSTABLE : std_logic := '1'
  );
  PORT (
    PerEn     : IN  std_logic;
    WData     : IN  std_logic_vector (15 DOWNTO 0);
    WrEn      : IN  std_logic;
    DiOut     : OUT std_logic_vector(DELAY_BITS-1 DOWNTO 0);
    PhaseOut  : OUT std_logic_vector(15 DOWNTO 0);
    clk_phase : OUT std_logic;
    PSEN      : OUT std_logic;
    PSINCDEC  : OUT std_logic;
    PSDONE    : IN  std_logic;
    clk       : IN  std_logic;
    rst       : IN  std_logic
  );
END ENTITY phase;

--
ARCHITECTURE beh OF phase IS
  TYPE State_type IS (
    S_INIT, S_IDLE, S_STEP, S_INC, S_DEC, S_OUTPUT, S_WAIT
  );
  TYPE State_type0 IS (
    S_INIT, S_IDLE, S_STEP, S_OUTPUT
  );

  SIGNAL cur_state : State_type;
  SIGNAL cur_state0 : State_type0;
  SIGNAL nxt_dir : std_logic;
  SIGNAL cur_dir : std_logic;
  SIGNAL is_set : std_logic;
  SIGNAL Di_in : unsigned(DELAY_BITS-1 DOWNTO 0);
  SIGNAL Di_int : unsigned(DELAY_BITS-1 DOWNTO 0);
  SIGNAL Phase_in : unsigned(PHASE_BITS-1 DOWNTO 0);
  SIGNAL Phase_int : unsigned(PHASE_BITS-1 DOWNTO 0);
BEGIN

  wrctrl: process (clk) is
    VARIABLE Phase_cmd : unsigned(PHASE_BITS-1 DOWNTO 0);
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF rst = '1' THEN
        Di_in <= (others => '0');
        Phase_in <= (others => '0');
      ELSE
        IF WrEn = '1' AND PerEn = '1' THEN
          IF ADJUSTABLE = '1' THEN
            Phase_cmd := unsigned(WData(PHASE_BITS-1 DOWNTO 0));
            IF Phase_cmd < PHASE_RES THEN
              Phase_in <= Phase_cmd;
            ELSE
              Phase_in <= to_unsigned(PHASE_RES,PHASE_BITS);
            END IF;
          END IF;
          Di_in <= unsigned(WData(PHASE_BITS+DELAY_BITS-1 DOWNTO PHASE_BITS));
        END IF;
      END IF;
    END IF;
  END process;
  
  phase_dir: process (Phase_in, Phase_int, Di_in, Di_int) is
  BEGIN
    IF Phase_in = Phase_int AND Di_in = Di_int THEN
      is_set <= '1';
      nxt_dir <= '1';
    ELSE
      is_set <= '0';
      IF Di_in > Di_int OR (Di_in = Di_int AND Phase_in > Phase_int) THEN
        nxt_dir <= '1';
      ELSE
        nxt_dir <= '0';
      end if;
    end if;
  END process;
  
  CDef1: IF ADJUSTABLE = '1' GENERATE
    clocked: process (clk) is
    BEGIN
      IF clk'event AND clk = '1' THEN
        IF rst = '1' THEN
          Phase_int <= (others => '0');
          Di_int <= to_unsigned(0,DELAY_BITS);
          DiOut <= (others => '0');
          clk_phase <= '1';
          cur_dir <= '1';
          PSEN <= '0';
          cur_state <= S_INIT;
          cur_state0 <= S_INIT;
        ELSE
          CASE cur_state IS
            WHEN S_INIT =>
              Phase_int <= (others => '0');
              Di_int <= to_unsigned(0,DELAY_BITS);
              DiOut <= (others => '0');
              clk_phase <= '1';
              PSEN <= '0';
              cur_state <= S_IDLE;
            WHEN S_IDLE =>
              IF is_set = '0' THEN
                cur_state <= S_STEP;
              ELSE
                cur_state <= S_IDLE;
              END IF;
            WHEN S_STEP =>
              cur_dir <= nxt_dir;
              PSEN <= '1';
              IF nxt_dir = '1' THEN
                cur_state <= S_INC;
              ELSE
                cur_state <= S_DEC;
              END IF;
           WHEN S_INC =>
              PSEN <= '0';
              IF Phase_int = PHASE_RES-1 THEN
                Phase_int <= to_unsigned(0,PHASE_BITS);
                Di_int <= Di_int + 1;
              ELSE
                Phase_int <= Phase_int + 1;
              END IF;
              cur_state <= S_OUTPUT;
            WHEN S_DEC =>
              PSEN <= '0';
              IF Phase_int = to_unsigned(0,PHASE_BITS) THEN
                Phase_int <= to_unsigned(PHASE_RES-1,PHASE_BITS);
                Di_int <= Di_int - 1;
              ELSE
                Phase_int <= Phase_int - 1;
              END IF;
              cur_state <= S_OUTPUT;
            WHEN S_OUTPUT =>
              IF Phase_int < (PHASE_RES*2)/5 THEN
                DiOut <= std_logic_vector(Di_int);
                clk_phase <= '1';
              ELSIF Phase_int > (PHASE_RES*4)/5 THEN
                DiOut <= std_logic_vector(Di_int+1);
                clk_phase <= '1';
              ELSE
                DiOut <= std_logic_vector(Di_int+1);
                clk_phase <= '0';
              END IF;
              cur_state <= S_WAIT;
            WHEN S_WAIT =>
              IF PSDONE = '0' THEN
                cur_state <= S_WAIT;
              ELSIF is_set = '1' THEN
                cur_state <= S_IDLE;
              ELSE
                cur_state <= S_STEP;
              END IF;
            WHEN others =>
              cur_state <= S_IDLE;
          END CASE;
        END IF;
      END IF;
    END process;
  END GENERATE;
  
  CDef0: IF ADJUSTABLE = '0' GENERATE
    clocked: process (clk) is
    BEGIN
      IF clk'event AND clk = '1' THEN
        IF rst = '1' THEN
          Phase_int <= (others => '0');
          Di_int <= to_unsigned(0,DELAY_BITS);
          DiOut <= (others => '0');
          clk_phase <= '1';
          cur_dir <= '1';
          PSEN <= '0';
          cur_state <= S_INIT;
          cur_state0 <= S_INIT;
        ELSE
          CASE cur_state0 IS
            WHEN S_INIT =>
              Phase_int <= (others => '0');
              Di_int <= to_unsigned(0,DELAY_BITS);
              DiOut <= (others => '0');
              clk_phase <= '1';
              PSEN <= '0';
              cur_state0 <= S_IDLE;
            WHEN S_IDLE =>
              IF is_set = '0' THEN
                cur_state0 <= S_STEP;
              ELSE
                cur_state0 <= S_IDLE;
              END IF;
            WHEN S_STEP =>
              Di_int <= Di_in;
              cur_state0 <= S_OUTPUT;
            WHEN S_OUTPUT =>
              DiOut <= std_logic_vector(Di_int);
              clk_phase <= '0';
              cur_state0 <= S_IDLE;
            WHEN others =>
              cur_state0 <= S_IDLE;
          END CASE;
        END IF;
      END IF;
    END process;
  END GENERATE;

  PhaseOut <= std_logic_vector(Di_int & Phase_int);
  PSINCDEC <= cur_dir;
END ARCHITECTURE beh;

