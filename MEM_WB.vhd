library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity MEM_WB is
Port(Clk 	 :in STD_LOGIC;
		Reset  :in STD_LOGIC;
		MEM_WB_WR :in STD_LOGIC;
		
		
		MEM_WB_ReadData_IN : in STD_LOGIC_VECTOR(31 downto 0);
		MEM_WB_Address_IN : in STD_LOGIC_VECTOR(31 downto 0);


		MEM_WB_ReadData_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		MEM_WB_Address_OUT : out STD_LOGIC_VECTOR(31 downto 0);


		MEM_WB_WB_IN_1bit :in STD_LOGIC;
		MEM_WB_WB_IN_2bit :in STD_LOGIC;

		MEM_WB_WB_OUT_1bit :out STD_LOGIC;
		MEM_WB_WB_OUT_2bit :out STD_LOGIC;

			
		MEM_WB_INSTR20_16_IN :in STD_LOGIC_VECTOR(4 downto 0);
		MEM_WB_INSTR20_16_OUT :out STD_LOGIC_VECTOR(4 downto 0));
end MEM_WB;

architecture Behavioral of MEM_WB is


-------Signals------
Signal MEM_WB_WB_OUT_1bit_Signal :STD_LOGIC:= '0';
Signal MEM_WB_WB_OUT_2bit_Signal :STD_LOGIC:= '0';
Signal MEM_WB_ReadData_OUT_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MEM_WB_Address_OUT_Signal  : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');


Signal MEM_WB_INSTR20_16_OUT_Signal : STD_LOGIC_VECTOR(4 downto 0):= (others => '0');


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

Component Register5bitWide is
Port (       CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
			 Datain : in STD_LOGIC_VECTOR (4 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (4 downto 0));
end Component;
------------------------------------------------------------------------------------
begin

MEM_WB_Readdata_register32bit:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => MEM_WB_ReadData_IN,
									 WE		 => MEM_WB_WR,
									 Dataout => MEM_WB_ReadData_OUT_Signal);
									 
									 
MEM_WB_Address_Register32bit:
    Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => MEM_WB_Address_IN,
									 WE		 => MEM_WB_WR,
									 Dataout => MEM_WB_Address_OUT_Signal);


----------------------------------------------------------------------------------------------------
MEM_WB_WB_reg:
Pipeline_Control_Datapath_3bitRegister	Port MAP(DataIn1 => MEM_WB_WB_IN_1bit,
																 DataIn2 => MEM_WB_WB_IN_2bit,
																 DataIn3 => '0',
																 DataOut1 => MEM_WB_WB_OUT_1bit_Signal,
																 DataOut2 => MEM_WB_WB_OUT_2bit_Signal,
																 DataOut3 => open,
																 Reset => Reset,
																 WrEn => MEM_WB_WR,
																 Clk => Clk);
------------------------------------------------------------------------------------------------------------
MEM_WB_INSTR20_16_reg:
    Register5bitWide Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => MEM_WB_INSTR20_16_IN,
									 WE		 => MEM_WB_WR,
									 Dataout => MEM_WB_INSTR20_16_OUT_Signal);



MEM_WB_WB_OUT_1bit <= MEM_WB_WB_OUT_1bit_Signal;
MEM_WB_WB_OUT_2bit <= MEM_WB_WB_OUT_2bit_Signal;
MEM_WB_ReadData_OUT <= MEM_WB_ReadData_OUT_Signal;
MEM_WB_Address_OUT <= MEM_WB_Address_OUT_Signal;
MEM_WB_INSTR20_16_OUT <= MEM_WB_INSTR20_16_OUT_Signal;

end Behavioral;