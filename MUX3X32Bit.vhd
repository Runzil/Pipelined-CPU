library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX3X32Bit is
	Port( DataIn1 : in STD_LOGIC_VECTOR(31 downto 0);
			DataIn2 : in STD_LOGIC_VECTOR(31 downto 0);
			DataIn3 : in STD_LOGIC_VECTOR(31 downto 0);
			DataOut : out STD_LOGIC_VECTOR(31 downto 0);
			Mux3x32bitSel : in STD_LOGIC_VECTOR(1 downto 0)
			);

end MUX3X32Bit;

architecture Behavioral of MUX3X32Bit is
signal MuxoutSignal : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
MuxoutSignal <= DataIn1 when Mux3x32bitSel = "00" else
					 DataIn2 when Mux3x32bitSel = "01" else
					 DataIn3 when Mux3x32bitSel = "10";

DataOut <= MuxoutSignal after 10ns;
end Behavioral;