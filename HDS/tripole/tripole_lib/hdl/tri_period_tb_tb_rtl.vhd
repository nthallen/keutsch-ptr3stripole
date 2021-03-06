--
-- VHDL Test Bench tripole_lib.tri_period_tb.tri_period_tester
--
-- Created:
--          by - . (NORT-XPS14)
--          at - 19:00:00 12/31/69
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY tri_period_tb IS
END tri_period_tb;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY tripole_lib;
USE tripole_lib.ALL;


ARCHITECTURE rtl OF tri_period_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL clk       : std_logic;
   SIGNAL CtrlEn    : std_logic;
   SIGNAL PerEn     : std_logic;
   SIGNAL rst       : std_logic;
   SIGNAL RunOut    : std_logic;
   SIGNAL tri_start : std_logic;
   SIGNAL WData     : std_logic_vector(15 DOWNTO 0);
   SIGNAL WrEn      : std_logic;
   SIGNAL Done      : std_logic;
   SIGNAL Average   : std_logic_vector(15 DOWNTO 0);
   SIGNAL N_Trig    : std_logic_vector(15 DOWNTO 0);


   -- Component declarations
   COMPONENT tri_period
      PORT (
         clk       : IN     std_logic;
         CtrlEn    : IN     std_logic;
         PerEn     : IN     std_logic;
         rst       : IN     std_logic;
         RunOut    : OUT    std_logic;
         tri_start : OUT    std_logic;
         WData     : IN     std_logic_vector(15 DOWNTO 0);
         WrEn      : IN     std_logic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR U_0 : tri_period USE ENTITY tripole_lib.tri_period;
   -- pragma synthesis_on

BEGIN

         U_0 : tri_period
            PORT MAP (
               clk       => clk,
               CtrlEn    => CtrlEn,
               PerEn     => PerEn,
               rst       => rst,
               RunOut    => RunOut,
               tri_start => tri_start,
               WData     => WData,
               WrEn      => WrEn
            );
    -- 100 MHz
    clock100 : Process
    Begin
      clk <= '0';
      -- pragma synthesis_off
      wait for 5 ns;
      while Done = '0' loop
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
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
        wait until clk'Event AND clk = '1';
        WrEn <= '1';
        PerEn <= '1';
        wait until clk'Event AND clk = '1';
        -- assert ExpAck = '1' report "No acknowledge on write" severity error;
        WrEn <= '0';
        PerEn <= '0';
        wait for 250 ns;
        -- pragma synthesis_on
        return;
      end procedure wr_period;

      procedure test_period( Data_In : IN std_logic_vector (15 downto 0);
              Check_value : IN integer ) is
      begin
        
        wr_period(Data_In);
        Average <= (others => '0');
        N_Trig <= (others => '0');
        -- pragma synthesis_off
        for j in 1 to 5 loop
          wait until clk'Event AND clk = '1';
        end loop;
        
        WrEn <= '1';
        CtrlEn <= '1';
        WData <= X"0001";
        wait until clk'Event AND clk = '1';
        WrEn <= '0';
        CtrlEn <= '0';
        wait until clk'Event AND clk = '1';
        assert RunOut = '1' report "Late run" severity error;
        wait until clk'Event AND clk = '1';
        assert tri_start = '1' report "Late trigger" severity error;
        while N_Trig <= 10 loop
          Average <= Average + 1;
          if tri_start = '1' then
            N_Trig <= N_Trig+1;
          end if;
          wait until clk'Event AND clk = '1';
        end loop;
        
        Average <= Average - 1;
        WData <= (others => '0');
        WrEn <= '1';
        CtrlEn <= '1';
        wait until clk'Event AND clk = '1';
        WrEn <= '0';
        CtrlEn <= '0';
        wait until clk'Event AND clk = '1';
        wait until clk'Event AND clk = '1';
        assert RunOut = '0' report "Late run stop" severity error;
        
        assert Average = Check_value report "Bad Average" severity error;
        -- pragma synthesis_on
        return;
      end procedure test_period;
      
    begin
        Done <= '0';
        rst <= '1';
        CtrlEn <= '0';
        PerEn <= '0';
        Wren <= '0';
        WData <= (others => '0');
        Average <= (others => '0');
        N_Trig <= (others => '0');
        -- pragma synthesis_off
        wait until clk'Event AND clk = '1';
        wait until clk'Event AND clk = '1';
        rst <= '0';
        wait until clk'Event AND clk = '1';
        wait until clk'Event AND clk = '1';
        
        test_period(X"0051", 51);
        test_period(X"0040", 40);
        test_period(X"0042", 42);
        test_period(X"0049", 49);
        -- test_period(X"0051", 51);
        -- test_period(X"0030", 30);
        -- test_period(X"0029", 29);
        -- test_period(X"0018", 18);
        -- test_period(X"0107", 167);
        -- test_period(X"0116", 176);
        -- test_period(X"0125", 185);
        -- test_period(X"0134", 194);
        -- test_period(X"0203", 323);
        -- test_period(X"0212", 332);
        
        Done <= '1';
        wait;
        -- pragma synthesis_on
    End Process;


END rtl;