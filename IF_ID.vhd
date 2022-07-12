library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IF_ID is
Port (Clk 	 :in STD_LOGIC;
		Reset  :in STD_LOGIC;
		IF_ID_WR :in STD_LOGIC;
		IF_ID_Instruction_IN: in STD_LOGIC_VECTOR(31 downto 0);
		IF_ID_Adder4out_IN	: in STD_LOGIC_VECTOR(31 downto 0);
		IF_ID_Instruction_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		IF_ID_Adder4out_OUT 	: out STD_LOGIC_VECTOR(31 downto 0)
		);
end IF_ID;

architecture Behavioral of IF_ID is


------------------------COMPONENTS------------------------------------------
Component Register32bit is
		Port ( CLK : in STD_LOGIC;
             RST : in STD_LOGIC;
				 Datain : in STD_LOGIC_VECTOR (31 downto 0);
             WE : in STD_LOGIC;
             Dataout : out STD_LOGIC_VECTOR (31 downto 0));
end Component;
----------------------------------------------------------------------------

begin

IFInstr_register:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => IF_ID_Instruction_IN,
									 WE		 => IF_ID_WR,
									 Dataout => IF_ID_Instruction_OUT);

IFAdder4_register:
	Register32bit Port MAP ( CLK 	 => Clk,
									 RST 	 => Reset,
									 Datain  => IF_ID_Adder4out_IN,
									 WE		 => IF_ID_WR,
									 Dataout => IF_ID_Adder4out_OUT);
----------------------------------------------------------------------------


end Behavioral;

