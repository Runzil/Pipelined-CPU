library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Mux is
Port(	
		nPC_sel_IN: in STD_LOGIC; 
		MemtoReg_IN: in STD_LOGIC; 
		RegDst_IN: in STD_LOGIC; 
		RegWr_IN: in STD_LOGIC; 	
		ExtOp_IN: in STD_LOGIC_VECTOR(1 downto 0);
		ALUsrc_IN:in STD_LOGIC; 
		ALUctr_IN:in STD_LOGIC_VECTOR(3 downto 0);
		MemWr_IN:in STD_LOGIC;	
		ByteOp_IN:in STD_LOGIC;
		
		Sel : in STD_LOGIC;
		
		nPC_sel_OUT: out STD_LOGIC; 
		MemtoReg_OUT: out STD_LOGIC; 
		RegDst_OUT: out STD_LOGIC; 
		RegWr_OUT: out STD_LOGIC; 	
		ExtOp_OUT: out STD_LOGIC_VECTOR(1 downto 0);
		ALUsrc_OUT:out STD_LOGIC; 
		ALUctr_OUT:out STD_LOGIC_VECTOR(3 downto 0);
		MemWr_OUT:out STD_LOGIC;	
		ByteOp_OUT:out STD_LOGIC);
end Control_Mux;

architecture Behavioral of Control_Mux is
Signal nPC_sel_Signal: STD_LOGIC; 
Signal MemtoReg_Signal: STD_LOGIC; 
Signal RegDst_Signal: STD_LOGIC; 
Signal RegWr_Signal: STD_LOGIC; 	
Signal ExtOp_Signal: STD_LOGIC_VECTOR(1 downto 0);
Signal ALUsrc_Signal : STD_LOGIC; 
Signal ALUctr_Signal : STD_LOGIC_VECTOR(3 downto 0);
Signal MemWr_Signal : STD_LOGIC;	
Signal ByteOp_Signal : STD_LOGIC;


begin
nPC_sel_Signal <= nPC_sel_IN when Sel='0' else
						'0';
						
MemtoReg_Signal <= MemtoReg_IN when Sel='0' else
						'0';

RegDst_Signal <= RegDst_IN when Sel='0' else
					  '0';

RegWr_Signal <= RegWr_IN when Sel='0' else
					  '0';
					  
ExtOp_Signal <= ExtOp_IN when Sel='0' else
					  "00";	 				  

ALUsrc_Signal <= ALUsrc_IN when Sel='0' else
					 '0';

ALUctr_Signal <= ALUctr_IN when Sel='0' else
					  "0000";	
					  
MemWr_Signal <= MemWr_IN when Sel='0' else
					 '0';

ByteOp_Signal <= ByteOp_IN when Sel='0' else
					 '0';




nPC_sel_OUT<= nPC_sel_Signal after 10 ns;
MemtoReg_OUT<= MemtoReg_Signal after 10 ns;
RegDst_OUT<= RegDst_Signal after 10 ns;
RegWr_OUT<= RegWr_Signal after 10 ns;	
ExtOp_OUT<= ExtOp_Signal after 10 ns;
ALUsrc_OUT<= ALUsrc_Signal after 10 ns;
ALUctr_OUT<= ALUctr_Signal after 10 ns;
MemWr_OUT<= MemWr_Signal after 10 ns;	
ByteOp_OUT<= ByteOp_Signal after 10 ns;





end Behavioral;

