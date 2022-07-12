--added IFAdder4Out output the output of pc+4 adder and removed adder2val (as shown in lecture pdfs)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Mux2to1bit_package.all;

entity IF_STAGE_PIPELINE is
	Port(	 PC_Immed 	: in STD_LOGIC_VECTOR(31 downto 0);
			 PC_sel 		: in STD_LOGIC;
			 PC_LdEn 	:in STD_LOGIC;
			 Reset 		:in STD_LOGIC;
			 Clk 			:in STD_LOGIC;
			 PC 			: out STD_LOGIC_VECTOR(31 downto 0);
			 IFAdder4Out  : out STD_LOGIC_VECTOR(31 downto 0)
			 );
		
end IF_STAGE_PIPELINE;

architecture Behavioral of IF_STAGE_PIPELINE is
signal MUXOUT: STD_LOGIC_VECTOR(31 downto 0);
signal PCOUT: STD_LOGIC_VECTOR(31 downto 0);
signal Adder4Out: STD_LOGIC_VECTOR(31 downto 0);
signal Adder2valOut : STD_LOGIC_VECTOR(31 downto 0);
signal MUXINPUT: MUX2to1bitArray;

------------------------COMPONENTS---------------------------------
Component MUX2to1bit is
	Port( MUX2In : in MUX2to1bitArray;
			Pc_Sel : in STD_LOGIC;
			MUX2Out: out STD_LOGIC_VECTOR(31 downto 0));
end Component;

Component Adder4 is
	Port( Adder4In : in STD_LOGIC_VECTOR(31 downto 0);
			Adder4Out: out STD_LOGIC_VECTOR(31 downto 0));
end Component;

Component Register32bit is
		Port ( CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
				 Datain : in STD_LOGIC_VECTOR (31 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (31 downto 0));
end Component;
----------------------------------------------------------------------------

begin
---------------------------PC----------------------------------------
	PC_register:
		Register32bit Port MAP (  CLK 	 => Clk,
										  RST 	 => Reset,
										  Datain  => MUXOUT,
										  WE		 => PC_LdEn,
										  Dataout => PCOUT);
------------------------Adder4----------------------------------------
	Adder4Bit:
		Adder4 Port MAP( Adder4In  => PCOUT,
							  Adder4Out => Adder4Out);
							  
--------------------------------MUX----------------------------------------
	MUXINPUT(0) <= Adder4Out;
	MUXINPUT(1) <= PC_Immed;
		
	MUX:
		MUX2to1bit Port Map( MUX2In  => MUXINPUT,
									Pc_Sel  => PC_sel,
									MUX2Out => MUXOUT);
----------------------------------------------------------------------------
	PC <= PCOUT;
	IFAdder4Out <= Adder4Out;
end Behavioral;

