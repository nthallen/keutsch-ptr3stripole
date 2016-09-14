--
-- VHDL Architecture tripole_lib.tri_pulse_tester.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 13:34:02 08/ 9/2016
--
-- using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tri_pulse_tester IS
   PORT( 
      pulse      : IN     std_logic;
      CtrlEn     : OUT    std_logic;
      ExpReset   : OUT    std_logic;
      HiPerEn    : OUT    std_logic;
      PerEn      : OUT    std_logic;
      PhaseEn    : OUT    std_logic;
      WData      : OUT    std_logic_vector (15 DOWNTO 0);
      WrEn       : OUT    std_logic;
      clk_100MHz : OUT    std_logic
   );

-- Declarations

END tri_pulse_tester ;

--
ARCHITECTURE sim OF tri_pulse_tester IS
  SIGNAL Done: std_logic;
BEGIN
    -- 100 MHz
    clock100 : Process
    Begin
      clk_100MHz <= '0';
      -- pragma synthesis_off
      wait for 5 ns;
      while Done = '0' loop
        clk_100MHz <= '0';
        wait for 5 ns;
        clk_100MHz <= '1';
        wait for 5 ns;
      end loop;
      wait;
      -- pragma synthesis_on
    End Process;
    test_proc : Process Is
      procedure wr_period( Data_In : IN std_logic_vector (15 downto 0) ) is
      begin
        WData <= Data_in;
        -- pragma synthesis_off
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        WrEn <= '1';
        PerEn <= '1';
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        -- assert ExpAck = '1' report "No acknowledge on write" severity error;
        WrEn <= '0';
        PerEn <= '0';
        wait for 250 ns;
        -- pragma synthesis_on
        return;
      end procedure wr_period;

      procedure wr_phase( Data_In : IN std_logic_vector (15 downto 0) ) is
      begin
        WData <= Data_in;
        -- pragma synthesis_off
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        WrEn <= '1';
        PhaseEn <= '1';
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        -- assert ExpAck = '1' report "No acknowledge on write" severity error;
        WrEn <= '0';
        PhaseEn <= '0';
        wait for 250 ns;
        -- pragma synthesis_on
        return;
      end procedure wr_phase;

      procedure wr_hiper( Data_In : IN std_logic_vector (15 downto 0) ) is
      begin
        WData <= Data_in;
        -- pragma synthesis_off
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        WrEn <= '1';
        HiPerEn <= '1';
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        -- assert ExpAck = '1' report "No acknowledge on write" severity error;
        WrEn <= '0';
        HiPerEn <= '0';
        wait for 250 ns;
        -- pragma synthesis_on
        return;
      end procedure wr_hiper;
      
      procedure wr_ctrl(Data_In : IN std_logic_vector (15 downto 0)) is
      begin
         WData <= Data_In;
        -- pragma synthesis_off
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        WrEn <= '1';
        CtrlEn <= '1';
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        WrEn <= '0';
        CtrlEn <= '0';
        wait for 250 ns;
        -- pragma synthesis_on
        return;
      end procedure wr_ctrl;
      
    begin
        Done <= '0';
        ExpReset <= '1';
        CtrlEn <= '0';
        PerEn <= '0';
        PhaseEn <= '0';
        HiPerEn <= '0';
        Wren <= '0';
        WData <= (others => '0');
        -- pragma synthesis_off
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        ExpReset <= '0';
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        wait until clk_100MHz'Event AND clk_100MHz = '1';
        
--        wr_period(X"00A0");
--        wr_phase(X"0000");
--        wr_hiper(X"0032");
--        wr_ctrl(X"0001");
--        wait for 1200 ns;
--        wr_ctrl(X"0000");
--        
--        wr_period(X"00A0");
--        wr_phase(X"0023");
--        wr_hiper(X"0032");
--        wr_ctrl(X"0001");
--        wait for 1200 ns;
--        wr_ctrl(X"0000");
--        
--        wr_period(X"00A0");
--        wr_phase(X"0090");
--        wr_hiper(X"0032");
--        wr_ctrl(X"0001");
--        wait for 1200 ns;
--        wr_ctrl(X"0000");
--        
--        wr_period(X"00A0");
--        wr_phase(X"0092");
--        wr_hiper(X"0032");
--        wr_ctrl(X"0001");
--        wait for 1200 ns;
--        wr_ctrl(X"0000");
        
        wr_period(X"00A0");
        wr_phase(X"0023");
        wr_hiper(X"0000");
        wr_ctrl(X"0001");
        wait for 1200 ns;
        wr_ctrl(X"0000");
        
        wr_period(X"00A0");
        wr_phase(X"0023");
        wr_hiper(X"0005");
        wr_ctrl(X"0001");
        wait for 1200 ns;
        wr_ctrl(X"0000");
        
        wr_period(X"00A0");
        wr_phase(X"0023");
        wr_hiper(X"0015");
        wr_ctrl(X"0001");
        wait for 1200 ns;
        wr_ctrl(X"0000");
        
        wr_period(X"00A0");
        wr_phase(X"0023");
        wr_hiper(X"0045");
        wr_ctrl(X"0001");
        wait for 1200 ns;
        wr_ctrl(X"0000");
        
        wr_period(X"00A0");
        wr_phase(X"0023");
        wr_hiper(X"0090");
        wr_ctrl(X"0001");
        wait for 1200 ns;
        wr_ctrl(X"0000");
        
        wr_period(X"00A0");
        wr_phase(X"0023");
        wr_hiper(X"0092");
        wr_ctrl(X"0001");
        wait for 1200 ns;
        wr_ctrl(X"0000");

        Done <= '1';
        wait;
        -- pragma synthesis_on
    End Process;


END ARCHITECTURE sim;

