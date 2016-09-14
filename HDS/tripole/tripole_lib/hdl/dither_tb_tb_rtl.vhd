--
-- VHDL Test Bench tripole_lib.dither_tb.dither_tester
--
-- Created:
--          by - . (NORT-XPS14)
--          at - 19:00:00 12/31/69
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY dither_tb IS
END dither_tb;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY tripole_lib;
USE tripole_lib.ALL;


ARCHITECTURE rtl OF dither_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL clk      : std_logic;
   SIGNAL Count    : std_logic_vector(15 DOWNTO 0);
   SIGNAL ExpReset : std_logic;
   SIGNAL PerEn    : std_logic;
   SIGNAL RdEn     : std_ulogic;
   SIGNAL WData    : std_logic_vector(15 DOWNTO 0);
   SIGNAL WrEn     : std_logic;
   SIGNAL Done     : std_logic;
   SIGNAL Average  : std_logic_vector(15 DOWNTO 0);


   -- Component declarations
   COMPONENT dither_wrap
      PORT (
         clk      : IN     std_logic;
         Count    : OUT    std_logic_vector(15 DOWNTO 0);
         ExpReset : IN     std_logic;
         PerEn    : IN     std_logic;
         RdEn     : IN     std_ulogic;
         WData    : IN     std_logic_vector(15 DOWNTO 0);
         WrEn     : IN     std_logic
      );
   END COMPONENT;

   -- embedded configurations
      -- pragma synthesis_off
   FOR U_0 : dither_wrap USE ENTITY tripole_lib.dither_wrap;
      -- pragma synthesis_on

BEGIN

         U_0 : dither_wrap
            PORT MAP (
               clk      => clk,
               Count    => Count,
               ExpReset => ExpReset,
               PerEn    => PerEn,
               RdEn     => RdEn,
               WData    => WData,
               WrEn     => WrEn
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
        -- pragma synthesis_off
        for j in 1 to 5 loop
          wait until clk'Event AND clk = '1';
        end loop;
        -- RdEn <= '1';
        -- wait until clk'Event AND clk = '1';
        -- RdEn <= '0';
        for i in 1 to 20 loop
          for j in 1 to 5 loop
            wait until clk'Event AND clk = '1';
          end loop;
          Average <= Average + Count;
          RdEn <= '1';
          wait until clk'Event AND clk = '1';
          RdEn <= '0';
        end loop;
        assert Average = Check_value*2 report "Bad Average" severity error;
        for j in 1 to 5 loop
          wait until clk'Event AND clk = '1';
        end loop;
        -- pragma synthesis_on
      end procedure test_period;
      
    begin
        Done <= '0';
        ExpReset <= '1';
        PerEn <= '0';
        RdEn <= '0';
        Wren <= '0';
        WData <= (others => '0');
        -- pragma synthesis_off
        wait until clk'Event AND clk = '1';
        wait until clk'Event AND clk = '1';
        ExpReset <= '0';
        wait until clk'Event AND clk = '1';
        wait until clk'Event AND clk = '1';
        
        test_period(X"0073", 73);
        test_period(X"0051", 51);
        test_period(X"0030", 30);
        test_period(X"0029", 29);
        test_period(X"0018", 18);
        test_period(X"0107", 167);
        test_period(X"0116", 176);
        test_period(X"0125", 185);
        test_period(X"0134", 194);
        test_period(X"0203", 323);
        test_period(X"0212", 332);
        
        Done <= '1';
        wait;
        -- pragma synthesis_on
    End Process;

END rtl;