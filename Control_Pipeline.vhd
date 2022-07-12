--Removed the value settings for branch instructions (branch is not our concern) and added 3 outputs (ID_EX_WR,EX_MEM_WR,MEM_WB_WR) for the write enable of the
--datapath register modueles

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Pipeline is
Port (Instruction : in  STD_LOGIC_VECTOR (31 downto 0);
		Zero : in STD_LOGIC;
		
		nPC_sel: out STD_LOGIC; 
		
		MemtoReg: out STD_LOGIC; 
		RegDst: out STD_LOGIC; 
		RegWr: out STD_LOGIC; 	
		ExtOp: out STD_LOGIC_VECTOR(1 downto 0);
		
		ALUsrc:out STD_LOGIC; 
		ALUctr:out STD_LOGIC_VECTOR(3 downto 0);
		
		MemWr:out STD_LOGIC;	
		ByteOp:out STD_LOGIC;
		
		ID_EX_WR: out STD_LOGIC;
		EX_MEM_WR: out STD_LOGIC;
		MEM_WB_WR: out STD_LOGIC); 
		
end Control_Pipeline;

architecture Behavioral of Control_Pipeline is
Signal OPCode_signal : STD_LOGIC_VECTOR(5 downto 0):= (others => '0');
Signal FUNC_singal : STD_LOGIC_VECTOR(5 downto 0):= (others => '0');

begin

FUNC_singal<= Instruction(5 downto 0);
OPCode_signal<= Instruction(31 downto 26);


-- IF PC_Sel
--0  +4
--1  4+Pc_Immed
--ALUctr<="110001";
--ALUsrc<='0';
nPC_sel <= --'1' when OPCode_signal="111111" else -- b

			  --'1' when (OPCode_signal="000000" AND Zero ='1') else 			--beq 4+Pc_Immed
			  --'0' when (OPCode_signal="000000" AND Zero ='0') else 			--beq
			  
			 -- '0' when (OPCode_signal="000001" AND Zero ='1') else 			--bne 
			 -- '1' when (OPCode_signal="000001" AND Zero ='0') else 			--bne 4+Pc_Immed
			  '0';



--EX - ALU_Bin_sel
--0 RF_B
--1 immed
ALUsrc <= '0' when OPCode_signal="100000" else --func
			 --'0' when OPCode_signal="000000" else	--for beq
			 --'0' when OPCode_signal="000001" else	--for bne
			 '1';






-- DEC RF_WrData_sel
--0 ALU
--1 MEM
MemtoReg<= '1' when OPCode_signal="000011" else --lb
			  '1' when OPCode_signal="001111" else --lw
			  '0';	


-- DEC RF_B_Sel
--0 Instr(15-11)
--1 Instr(20-16)
RegDst <= '0' when OPCode_signal="100000" else --func
			-- '0' when OPCode_signal="000000" else	--for beq
			-- '0' when OPCode_signal="000001" else	--for bne
			 '1';
			 
-- DEC RF_WrEn
--0 WE disabled
--1 WE enabled
RegWr <= --'0' when OPCode_signal="111111" else --b
			--'0' when OPCode_signal="000000" else --beq
			--'0' when OPCode_signal="000001" else --bne
			'0' when OPCode_signal="000111" else --sb
			'0' when OPCode_signal="011111" else --sw
			'1';

--EX - ALU_func
ALUctr <= --"0001" when OPCode_signal="000000" else --for beq
			 --"0001" when OPCode_signal="000001" else --for bne
			 
			 Instruction(3 downto 0) when OPCode_signal="100000" else
			 
			 "0000" when OPCode_signal= "110000" else --addi
			 "0101" when OPCode_signal= "110010" else --nandi
			 "0011" when OPCode_signal= "110011" else --ori

			 "0000";
			 

--MEM - MemWr
--0 WE disabled
--1 WE enabled
MemWr <= '1' when OPCode_signal = "000111" else	 --sb
			'1' when OPCode_signal = "011111" else	 --sw
			'0';

--MEM - ByteOp			 
ByteOp <= '0' when OPCode_signal = "001111" else	--lw 
			 '0' when OPCode_signal = "011111" else	--sw
			 '1' when OPCode_signal = "000111" else	--sb
			 '1' when OPCode_signal = "000011" else	--lb
			 '0';
	
--DEC - ImmExt	
--00 zero Fill
--01 sign extension
--10 zero fill after 16 shift to left
--11 sign extension and 2 shift to left
ExtOp	<= "00" when OPCode_signal = "110010" else --nandi
			"00" when OPCode_signal = "110011" else --ori
			
			"01" when OPCode_signal = "111000" else --li
			"01" when OPCode_signal = "110000" else --addi
			"01" when OPCode_signal = "001111" else --lw
			"01" when OPCode_signal = "011111" else --sw
			"01" when OPCode_signal = "000011" else --lb
			"01" when OPCode_signal = "000111" else --sb
			
			"10" when OPCode_signal = "111001" else --lui
			
			--"11" when OPCode_signal = "111111" else --b
			--"11" when OPCode_signal = "000000" else --beq
			--"11" when OPCode_signal = "000001" else --bne
			"00";
			
			
ID_EX_WR <= '1';
EX_MEM_WR <= '1';
MEM_WB_WR <= '1';	 		
			
			
			
			
			
			
end Behavioral;



