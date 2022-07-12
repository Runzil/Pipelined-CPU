library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ForwardUnit is
Port( EX_MEM_RegWrite:in STD_LOGIC;
		EX_MEM_RegisterRd:in STD_LOGIC_VECTOR(4 downto 0);
		
		ID_EX_RegisterRs:in STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_MUX_RegisterRt_d:in STD_LOGIC_VECTOR(4 downto 0);
		
		MEM_WB_RegWrite:in STD_LOGIC;
		MEM_WB_RegisterRd:in STD_LOGIC_VECTOR(4 downto 0);
		
		
		DataIn1_MuxA : in STD_LOGIC_VECTOR(31 downto 0);
		DataIn2_MuxA : in STD_LOGIC_VECTOR(31 downto 0);
		DataIn3_MuxA : in STD_LOGIC_VECTOR(31 downto 0);
		DataOut_MuxA : out STD_LOGIC_VECTOR(31 downto 0);
		
		DataIn1_MuxB : in STD_LOGIC_VECTOR(31 downto 0);
		DataIn2_MuxB : in STD_LOGIC_VECTOR(31 downto 0);
		DataIn3_MuxB : in STD_LOGIC_VECTOR(31 downto 0);
		DataOut_MuxB : out STD_LOGIC_VECTOR(31 downto 0));
end ForwardUnit;

architecture Behavioral of ForwardUnit is
Signal ForwardA: STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
Signal ForwardB: STD_LOGIC_VECTOR(1 downto 0):= (others => '0');



---------------------COMPONENTS----------------------------
Component MUX3X32Bit is
	Port( DataIn1 : in STD_LOGIC_VECTOR(31 downto 0);
			DataIn2 : in STD_LOGIC_VECTOR(31 downto 0);
			DataIn3 : in STD_LOGIC_VECTOR(31 downto 0);
			DataOut : out STD_LOGIC_VECTOR(31 downto 0);
			Mux3x32bitSel : in STD_LOGIC_VECTOR(1 downto 0)
			);
end Component;
-----------------------------------------------------------
begin

process(EX_MEM_RegWrite,EX_MEM_RegisterRd,ID_EX_RegisterRs,ID_EX_MUX_RegisterRt_d,MEM_WB_RegWrite,MEM_WB_RegisterRd)
	begin
		IF((EX_MEM_RegWrite ='1') AND (EX_MEM_RegisterRd /= "00000") AND (EX_MEM_RegisterRd = ID_EX_RegisterRs) ) THEN --1 instr before
			ForwardA<= "10";
		ELSIF ((MEM_WB_RegWrite='1') AND (MEM_WB_RegisterRd /= "00000") AND (MEM_WB_RegisterRd = ID_EX_RegisterRs)) THEN --2 instr before
			ForwardA<= "01";
		ELSE
			ForwardA<= "00";
		END IF;
	
		IF((EX_MEM_RegWrite ='1') AND (EX_MEM_RegisterRd /= "00000") AND (EX_MEM_RegisterRd = ID_EX_MUX_RegisterRt_d) ) THEN --1 instr before
			ForwardB<= "10";
		ELSIF ((MEM_WB_RegWrite='1') AND (MEM_WB_RegisterRd /= "00000") AND (MEM_WB_RegisterRd = ID_EX_MUX_RegisterRt_d)) THEN --2 instr before
			ForwardB<= "01";
		ELSE
			ForwardB<= "00";
		END IF;
	
	end process;


------------------------------------------------------------------------
MUX3X32Bit_ModuleA:
MUX3X32Bit	Port MAP( DataIn1 => DataIn1_MuxA, --00  RF A
						 	 DataIn2 => DataIn2_MuxA, --01  to be written rf data (from dec aka after mem/wb)
							 DataIn3 => DataIn3_MuxA, --10  alu out (from ex mem)
							 DataOut => DataOut_MuxA,
							 Mux3x32bitSel => ForwardA);
		

MUX3X32Bit_ModuleB:
MUX3X32Bit	Port MAP( DataIn1 => DataIn1_MuxB, --00  RF B
						 	 DataIn2 => DataIn2_MuxB, --01  to be written rf data (from dec aka after mem/wb)
							 DataIn3 => DataIn3_MuxB, --10  alu out (from ex mem)
							 DataOut => DataOut_MuxB,
							 Mux3x32bitSel => ForwardB);	
-------------------------------------------------------------------------





end Behavioral;

