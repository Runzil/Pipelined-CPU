library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_MEM is
Port( Clk 	 :in STD_LOGIC;
		Reset  :in STD_LOGIC;
		EX_MEM_WR :in STD_LOGIC;

EX_MEM_Adder2val_IN : in STD_LOGIC_VECTOR(31 downto 0);
EX_MEM_Zero_IN :in STD_LOGIC;
EX_MEM_ALU_Result_IN: in STD_LOGIC_VECTOR(31 downto 0);
EX_MEM_ReadData_2_IN :in STD_LOGIC_VECTOR(31 downto 0);



EX_MEM_Adder2val_OUT : out STD_LOGIC_VECTOR(31 downto 0);
EX_MEM_Zero_OUT : out STD_LOGIC;
EX_MEM_ALU_Result_OUT: out STD_LOGIC_VECTOR(31 downto 0);
EX_MEM_ReadData_2_OUT :out STD_LOGIC_VECTOR(31 downto 0);



EX_MEM_WB_IN_1bit :in STD_LOGIC;
EX_MEM_WB_IN_2bit :in STD_LOGIC;
		
EX_MEM_M_IN_1bit :in STD_LOGIC;
EX_MEM_M_IN_2bit :in STD_LOGIC;
EX_MEM_M_IN_3bit :in STD_LOGIC;

EX_MEM_WB_OUT_1bit :out STD_LOGIC;
EX_MEM_WB_OUT_2bit :out STD_LOGIC;
		
EX_MEM_M_OUT_1bit :out STD_LOGIC;
EX_MEM_M_OUT_2bit :out STD_LOGIC;
EX_MEM_M_OUT_3bit :out STD_LOGIC;


EX_MEM_INSTR20_16_IN :in STD_LOGIC_VECTOR(4 downto 0);
EX_MEM_INSTR20_16_OUT :out STD_LOGIC_VECTOR(4 downto 0));

end EX_MEM;

architecture Behavioral of EX_MEM is

---Signals--------
Signal EX_MEM_Adder2val_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal EX_MEM_Zero_OUT_Signal : STD_LOGIC := '0';
Signal EX_MEM_ALU_Result_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal EX_MEM_ReadData_2_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');

Signal EX_MEM_WB_OUT_1bit_Signal: STD_LOGIC := '0';
Signal EX_MEM_WB_OUT_2bit_Signal: STD_LOGIC := '0';

Signal EX_MEM_M_OUT_1bit_Signal: STD_LOGIC := '0';
Signal EX_MEM_M_OUT_2bit_Signal: STD_LOGIC := '0';
Signal EX_MEM_M_OUT_3bit_Signal: STD_LOGIC := '0';

Signal EX_MEM_INSTR20_16_OUT_Signal : STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
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

Component Register1bit is
Port( CLK : in STD_LOGIC;
      RST : in STD_LOGIC;
	  Datain : in STD_LOGIC;
      WE : in STD_LOGIC;
      Dataout : out STD_LOGIC);
end Component;

Component Register5bitWide is
Port (       CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
			 Datain : in STD_LOGIC_VECTOR (4 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (4 downto 0));
end Component;
----------------------------------------------------------------------------
begin

EX_MEM_Adder2val_register32bit:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => EX_MEM_Adder2val_IN,
									 WE		 => EX_MEM_WR,
									 Dataout => EX_MEM_Adder2val_OUT_Signal);
									 
									 
EX_MEM_Zero_Register1bit:
    Register1bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => EX_MEM_Zero_IN,
									 WE		 => EX_MEM_WR,
									 Dataout => EX_MEM_Zero_OUT_Signal);
									 
									 
EX_MEM_ALU_register32bit:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => EX_MEM_ALU_Result_IN,
									 WE		 => EX_MEM_WR,
									 Dataout => EX_MEM_ALU_Result_OUT_Signal);


EX_MEM_ReadData2_register32bit:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => EX_MEM_ReadData_2_IN,
									 WE		 => EX_MEM_WR,
									 Dataout => EX_MEM_ReadData_2_OUT_Signal);


---------------------------------------------------------------------------------------------------------------------
EX_MEM_WB_reg:
Pipeline_Control_Datapath_3bitRegister	Port MAP(DataIn1 => EX_MEM_WB_IN_1bit,
																 DataIn2 => EX_MEM_WB_IN_2bit,
																 DataIn3 => '0',
																 DataOut1 => EX_MEM_WB_OUT_1bit_Signal,
																 DataOut2 => EX_MEM_WB_OUT_2bit_Signal,
																 DataOut3 => open,
																 Reset => Reset,
																 WrEn => EX_MEM_WR,
																 Clk => Clk);
EX_MEM_M_reg:
Pipeline_Control_Datapath_3bitRegister	Port MAP(DataIn1 => EX_MEM_M_IN_1bit,
																 DataIn2 => EX_MEM_M_IN_2bit,
																 DataIn3 => EX_MEM_M_IN_3bit,
																 DataOut1 => EX_MEM_M_OUT_1bit_Signal,
																 DataOut2 => EX_MEM_M_OUT_2bit_Signal,
																 DataOut3 => EX_MEM_M_OUT_3bit_Signal,
																 Reset => Reset,
																 WrEn => EX_MEM_WR,
																 Clk => Clk);
-------------------------------------------------------------------------------------------------------------------------
EX_MEM_INSTR20_16_reg :
Register5bitWide  Port MAP( CLK  => Clk,
									 RST  => Reset,
									 Datain  => EX_MEM_INSTR20_16_IN,
									 WE  => EX_MEM_WR,
									 Dataout  => EX_MEM_INSTR20_16_OUT_Signal);




EX_MEM_Adder2val_OUT <= EX_MEM_Adder2val_OUT_Signal;
EX_MEM_Zero_OUT  <= EX_MEM_Zero_OUT_Signal;
EX_MEM_ALU_Result_OUT <= EX_MEM_ALU_Result_OUT_Signal;
EX_MEM_ReadData_2_OUT <= EX_MEM_ReadData_2_OUT_Signal;

EX_MEM_WB_OUT_1bit <= EX_MEM_WB_OUT_1bit_Signal;
EX_MEM_WB_OUT_2bit <= EX_MEM_WB_OUT_2bit_Signal;

EX_MEM_M_OUT_1bit <= EX_MEM_M_OUT_1bit_Signal;
EX_MEM_M_OUT_2bit <= EX_MEM_M_OUT_2bit_Signal;
EX_MEM_M_OUT_3bit <= EX_MEM_M_OUT_3bit_Signal;

EX_MEM_INSTR20_16_OUT <= EX_MEM_INSTR20_16_OUT_Signal;

end Behavioral;

