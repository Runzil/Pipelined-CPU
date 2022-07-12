library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID_EX is
Port( Clk 	 :in STD_LOGIC;
		Reset  :in STD_LOGIC;
		ID_EX_WR :in STD_LOGIC;

		
		IF_IDtoID_EX_IN : in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_1_IN: in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_2_IN: in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_SignExtend_IN: in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_MUX5bit_IN: in STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR25_21_IN : in STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR20_16_IN : in STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR15_11_IN : in STD_LOGIC_VECTOR(4 downto 0);
		
		
		ID_EX_WB_IN_1bit :in STD_LOGIC;
		ID_EX_WB_IN_2bit :in STD_LOGIC;
		
		ID_EX_M_IN_1bit :in STD_LOGIC;
		ID_EX_M_IN_2bit :in STD_LOGIC;
		ID_EX_M_IN_3bit :in STD_LOGIC;
		
		
		ID_EX_EX_IN_1bit :in STD_LOGIC;
		ID_EX_EX_IN_4bit :in STD_LOGIC_VECTOR(3 downto 0); --ID_EX_EX_IN

		
		IF_IDtoID_EX_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_1_OUT: out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_2_OUT: out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_SignExtend_OUT: out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_MUX5bit_OUT: out STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR25_21_OUT : out STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR20_16_OUT : out STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR15_11_OUT : out STD_LOGIC_VECTOR(4 downto 0);
		

		ID_EX_WB_OUT_1bit :out STD_LOGIC;
		ID_EX_WB_OUT_2bit :out STD_LOGIC;
		
		ID_EX_M_OUT_1bit :out STD_LOGIC;
		ID_EX_M_OUT_2bit :out STD_LOGIC;
		ID_EX_M_OUT_3bit :out STD_LOGIC;
		
		
		ID_EX_EX_OUT_1bit :out STD_LOGIC;
		ID_EX_EX_OUT_4bit :out STD_LOGIC_VECTOR(3 downto 0) --ID_EX_EX_OUT

		);
end ID_EX;

architecture Behavioral of ID_EX is

----------------------Signals---------------------
Signal IF_IDtoID_EX_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ID_EX_ReadData_1_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ID_EX_ReadData_2_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ID_EX_SignExtend_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');

Signal ID_EX_MUX5bit_OUT_Signal: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
Signal ID_EX_INSTR25_21_OUT_Signal: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
Signal ID_EX_INSTR20_16_OUT_Signal: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
Signal ID_EX_INSTR15_11_OUT_Signal: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');

Signal ID_EX_WB_OUT_1bit_Signal :STD_LOGIC := '0';
Signal ID_EX_WB_OUT_2bit_Signal :STD_LOGIC := '0';

Signal ID_EX_M_OUT_1bit_Signal :STD_LOGIC := '0';
Signal ID_EX_M_OUT_2bit_Signal :STD_LOGIC := '0';
Signal ID_EX_M_OUT_3bit_Signal :STD_LOGIC := '0';

Signal ID_EX_EX_OUT_1bit_Signal :STD_LOGIC := '0';
Signal ID_EX_EX_OUT_Signal : STD_LOGIC_VECTOR(3 downto 0):= (others => '0');
------------------------COMPONENTS------------------------------------------
Component Register32bit is
		Port ( CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
				 Datain : in STD_LOGIC_VECTOR (31 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (31 downto 0));
end Component;

Component Pipeline_Control_Datapath_3bitRegister is
    Port ( DataIn1 : in  STD_LOGIC;
           DataIn2 : in  STD_LOGIC;
           DataIn3 : in  STD_LOGIC;
           DataOut1 : out  STD_LOGIC;
           DataOut2 : out  STD_LOGIC;
           DataOut3 : out  STD_LOGIC;
           Reset : in  STD_LOGIC;
           WrEn : in  STD_LOGIC;
			  Clk	:in  STD_LOGIC);
end Component;

Component Register4bitWide is
Port (       CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
			 Datain : in STD_LOGIC_VECTOR (3 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (3 downto 0));
end Component;

Component Register5bitWide is
Port (       CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
			 Datain : in STD_LOGIC_VECTOR (4 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (4 downto 0));

end Component;
----------------------------------------------------------------------------



----------------------------------------------------------------------------
begin

ID_EX_register:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => IF_IDtoID_EX_IN,
									 WE		 => ID_EX_WR,
									 Dataout => IF_IDtoID_EX_OUT_Signal);
									 
ID_EX_ReadData1_register:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => ID_EX_ReadData_1_IN,
									 WE		 => ID_EX_WR,
									 Dataout => ID_EX_ReadData_1_OUT_Signal);

ID_EX_ReadData2_register:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => ID_EX_ReadData_2_IN,
									 WE		 => ID_EX_WR,
									 Dataout => ID_EX_ReadData_2_OUT_Signal);

ID_EX_SignExtend_register:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => ID_EX_SignExtend_IN,
									 WE		 => ID_EX_WR,
									 Dataout => ID_EX_SignExtend_OUT_Signal);
									 							 

---------------------------------------------------------------------------------------------------------------------
ID_EX_WB_reg:
Pipeline_Control_Datapath_3bitRegister	Port MAP(DataIn1 => ID_EX_WB_IN_1bit,
																 DataIn2 => ID_EX_WB_IN_2bit,
																 DataIn3 => '0',
																 DataOut1 => ID_EX_WB_OUT_1bit_Signal,
																 DataOut2 => ID_EX_WB_OUT_2bit_Signal,
																 DataOut3 => open,
																 Reset => Reset,
																 WrEn => ID_EX_WR,
																 Clk => Clk);
ID_EX_M_reg:
Pipeline_Control_Datapath_3bitRegister	Port MAP(DataIn1 => ID_EX_M_IN_1bit,
																 DataIn2 => ID_EX_M_IN_2bit,
																 DataIn3 => ID_EX_M_IN_3bit,
																 DataOut1 => ID_EX_M_OUT_1bit_Signal,
																 DataOut2 => ID_EX_M_OUT_2bit_Signal,
																 DataOut3 => ID_EX_M_OUT_3bit_Signal,
																 Reset => Reset,
																 WrEn => ID_EX_WR,
																 Clk => Clk);
ID_EX_EX1bit_reg:
Pipeline_Control_Datapath_3bitRegister	Port MAP(DataIn1 => ID_EX_EX_IN_1bit,
																 DataIn2 => '0',
																 DataIn3 => '0',
																 DataOut1 => ID_EX_EX_OUT_1bit_Signal,
																 DataOut2 => open,
																 DataOut3 => open,
																 Reset => Reset,
																 WrEn => ID_EX_WR,
																 Clk => Clk);
																 
 ID_EX4bit_reg: 
 Register4bitWide Port MAP(   CLK => Clk,
										RST => Reset,
										Datain => ID_EX_EX_IN_4bit,
										WE => ID_EX_WR,
										Dataout => ID_EX_EX_OUT_Signal);
------------------------------------------------------------------------------------------------------------------------		 
ID_EX_MUX5bit_register :
Register5bitWide Port MAP ( CLK 	 => Clk,
							RST 	 => Reset,
							Datain  => ID_EX_MUX5bit_IN,
							WE		 => ID_EX_WR,
							Dataout => ID_EX_MUX5bit_OUT_Signal);
				 			 
ID_EX_INSTR25_21_register :
Register5bitWide Port MAP ( CLK 	 => Clk,
							RST 	 => Reset,
							Datain  => ID_EX_INSTR25_21_IN,
							WE		 => ID_EX_WR,
							Dataout => ID_EX_INSTR25_21_OUT_Signal); 
			 
ID_EX_INSTR20_16_register :
Register5bitWide Port MAP ( CLK 	 => Clk,
							RST 	 => Reset,
							Datain  => ID_EX_INSTR20_16_IN,
							WE		 => ID_EX_WR,
							Dataout => ID_EX_INSTR20_16_OUT_Signal);				 
				 		 
ID_EX_INSTR15_11_register :
Register5bitWide Port MAP ( CLK 	 => Clk,
							RST 	 => Reset,
							Datain  => ID_EX_INSTR15_11_IN,
							WE		 => ID_EX_WR,
							Dataout => ID_EX_INSTR15_11_OUT_Signal);				 
				 
				 
				 
				 
				 
				 
				 
IF_IDtoID_EX_OUT <= IF_IDtoID_EX_OUT_Signal;
ID_EX_ReadData_1_OUT<= ID_EX_ReadData_1_OUT_Signal;
ID_EX_ReadData_2_OUT<= ID_EX_ReadData_2_OUT_Signal;
ID_EX_SignExtend_OUT<= ID_EX_SignExtend_OUT_Signal;

ID_EX_MUX5bit_OUT<= ID_EX_MUX5bit_OUT_Signal;
ID_EX_INSTR25_21_OUT <=ID_EX_INSTR25_21_OUT_Signal;
ID_EX_INSTR20_16_OUT<=ID_EX_INSTR20_16_OUT_Signal;
ID_EX_INSTR15_11_OUT<=ID_EX_INSTR15_11_OUT_Signal;



ID_EX_WB_OUT_1bit <= ID_EX_WB_OUT_1bit_Signal;
ID_EX_WB_OUT_2bit <= ID_EX_WB_OUT_2bit_Signal;

ID_EX_M_OUT_1bit <= ID_EX_M_OUT_1bit_Signal;
ID_EX_M_OUT_2bit <= ID_EX_M_OUT_2bit_Signal;
ID_EX_M_OUT_3bit <= ID_EX_M_OUT_3bit_Signal;

ID_EX_EX_OUT_1bit <= ID_EX_EX_OUT_1bit_Signal;		 
ID_EX_EX_OUT_4bit <= ID_EX_EX_OUT_Signal;			 
				 
----------------------------------------------------------------------------


end Behavioral;

