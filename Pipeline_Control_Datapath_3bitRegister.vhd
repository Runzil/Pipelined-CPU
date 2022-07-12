library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Pipeline_Control_Datapath_3bitRegister is
    Port ( DataIn1 : in  STD_LOGIC;
           DataIn2 : in  STD_LOGIC;
           DataIn3 : in  STD_LOGIC;
           DataOut1 : out  STD_LOGIC;
           DataOut2 : out  STD_LOGIC;
           DataOut3 : out  STD_LOGIC;
           Reset : in  STD_LOGIC;
           WrEn : in  STD_LOGIC;
			  Clk	:in  STD_LOGIC);
end Pipeline_Control_Datapath_3bitRegister;

architecture Behavioral of Pipeline_Control_Datapath_3bitRegister is
signal DataoutSignal1 :STD_LOGIC := '0';
signal DataoutSignal2 :STD_LOGIC := '0';
signal DataoutSignal3 :STD_LOGIC := '0';



begin

    process(CLK,Reset,DataIn1,DataIn2,DataIn3,DataoutSignal1,DataoutSignal2,DataoutSignal3)
    begin

     if(rising_edge(Clk)) then
		 if(Reset = '1') then --reset if Reset  is 1
			DataoutSignal1 <= '0';
			DataoutSignal2 <= '0';
			DataoutSignal3 <= '0';
       elsif(WrEn  = '1') then-- write if WrEn  is 1
           DataoutSignal1 <= DataIn1; 
			  DataoutSignal2 <= DataIn2;
			  DataoutSignal3 <= DataIn3;
        end if;
     end if;
    DataOut1 <= DataoutSignal1 after 10 ns;
	 DataOut2 <= DataoutSignal2 after 10 ns;
	 DataOut3 <= DataoutSignal3 after 10 ns;
    end process;

end Behavioral;

