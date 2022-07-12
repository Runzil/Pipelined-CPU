library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity PROCESSOR_PIPELINE_tb is
end;

architecture bench of PROCESSOR_PIPELINE_tb  is

  component PROCESSOR_PIPELINE
  Port( CLK: in STD_LOGIC;
		  RESET: in STD_LOGIC);
  end component;
  
--Inputs
signal CLK : std_logic := '0';
signal RESET : std_logic := '0';

  constant clock_period: time := 100 ns;

  signal stop_the_clock: boolean;
  
begin

  uut: PROCESSOR_PIPELINE port map ( CLK   => CLK,
												RESET => RESET );

  stimulus: process
  begin
  
    -- Put initialisation code here
		RESET<= '1';
		wait for clock_period*2;
		RESET<= '0';
		wait for clock_period*30;
    -- Put test bench stimulus code here
		
		stop_the_clock <= true;
    wait;
  end process;

clocking: process
  begin
    while not stop_the_clock loop
      Clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;