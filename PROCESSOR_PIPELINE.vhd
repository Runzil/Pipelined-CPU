library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PROCESSOR_PIPELINE is
Port( CLK: in STD_LOGIC;
		RESET: in STD_LOGIC);
end PROCESSOR_PIPELINE;

architecture Behavioral of PROCESSOR_PIPELINE is

------------------------COMPONENTS-----------------------------------------
Component DATAPATH_PIPELINE is 
Port(Clk: in STD_LOGIC;
		Reset : in STD_LOGIC;
		--IFSTAGE
		nPC_sel : in STD_LOGIC;
		Instruction: in STD_LOGIC_VECTOR(31 downto 0);
		PC_out:out STD_LOGIC_VECTOR(31 downto 0);
		--DECSTAGE
		MemtoReg: in STD_LOGIC;
		RegDst : in STD_LOGIC;
		RegWr: in STD_LOGIC;
		ExtOp : in STD_LOGIC_VECTOR(1 downto 0);
		--EXSTAGE
		ALUsrc:in STD_LOGIC;
		ALUctr:in STD_LOGIC_VECTOR(3 downto 0);
		ALU_ovf:out STD_LOGIC;
		ALU_cout:out STD_LOGIC;
		--ALU_zero:out STD_LOGIC;
		--MEMSTAGE
		MemWr: in STD_LOGIC;
		ByteOp: in STD_LOGIC;
		--MEMSTAGE ->RAM
		MM_WrEn   :out STD_LOGIC;
		MM_Addr   :out STD_LOGIC_VECTOR(31 downto 0);
		MM_WrData :out STD_LOGIC_VECTOR(31 downto 0);
		MM_RdData :in STD_LOGIC_VECTOR(31 downto 0);
		--WR
		ID_EX_WR: in STD_LOGIC;
		EX_MEM_WR: in STD_LOGIC;
		MEM_WB_WR: in STD_LOGIC;
		--TO/FROM_CONTROL
		Zero_control   :out STD_LOGIC;
		InstructionOut: out STD_LOGIC_VECTOR(31 downto 0));
end Component;


Component CONTROL_PIPELINE is 
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
end Component;

Component RAM
	port (
		clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0));
end Component;
----------------------------------------------------------------------------

Signal nPC_sel_Signal : STD_LOGIC:='0';
Signal Instruction_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal PC_out_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MemtoReg_Signal : STD_LOGIC:='0';
Signal RegDst_Signal : STD_LOGIC:='0';
Signal RegWr_Signal : STD_LOGIC:='0';
Signal ExtOp_Signal : STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
Signal ALUsrc_Signal : STD_LOGIC:='0';
Signal ALUctr_Signal : STD_LOGIC_VECTOR(3 downto 0):= (others => '0');
Signal MemWr_Signal : STD_LOGIC:='0';
Signal ByteOp_Signal : STD_LOGIC:='0';
Signal ALU_zero_Signal: STD_LOGIC:='0';

Signal MM_WrEn_Signal : STD_LOGIC:='0';
Signal MM_Addr_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MM_WrData_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MM_RdData_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');


Signal ID_EX_WR_Signal : STD_LOGIC:='0';
Signal EX_MEM_WR_Signal : STD_LOGIC:='0';
Signal MEM_WB_WR_Signal : STD_LOGIC:='0';

--
Signal Instruction_Signal2 : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
begin
-----------------------------DATAPATH-------------------------------------------
DATAPATH_MODULE:
 DATAPATH_PIPELINE Port MAP( Clk => CLK,
							Reset=> RESET, 
							--IFSTAGE
							nPC_sel=> nPC_sel_Signal, 
							Instruction=> Instruction_Signal,
							PC_out=> PC_out_Signal, -- add to ram
							--DECSTAGE
							MemtoReg => MemtoReg_Signal,
							RegDst => RegDst_Signal,
							RegWr => RegWr_Signal,
							ExtOp => ExtOp_Signal,
							--EXSTAGE
							ALUsrc => ALUsrc_Signal,
							ALUctr => ALUctr_Signal,
							ALU_ovf => open,	--open
							ALU_cout => open, --open
							--ALU_zero => ALU_zero_Signal,
							--MEMSTAGE
							MemWr=> MemWr_Signal,
							ByteOp=> ByteOp_Signal,
							--MEMSTAGE ->RAM
							MM_WrEn => MM_WrEn_Signal,
							MM_Addr => MM_Addr_Signal,
							MM_WrData => MM_WrData_Signal,
							MM_RdData => MM_RdData_Signal,
							--WR
							ID_EX_WR => ID_EX_WR_Signal,
							EX_MEM_WR => EX_MEM_WR_Signal,
							MEM_WB_WR => MEM_WB_WR_Signal,
							--TO/FROM_CONTROL
							Zero_control => ALU_zero_Signal,
							InstructionOut => Instruction_Signal2);

-----------------------------CONTROL-------------------------------------------

 CONTROL_MODULE:
  CONTROL_PIPELINE Port MAP(Instruction=> Instruction_Signal2, 
						 Zero => ALU_zero_Signal,
						 nPC_sel=> nPC_sel_Signal,
						 MemtoReg=> MemtoReg_Signal,
						 RegDst=> RegDst_Signal,
					 	 RegWr=> RegWr_Signal,
						 ExtOp=> ExtOp_Signal,
					 	 ALUsrc=> ALUsrc_Signal,
					 	 ALUctr=> ALUctr_Signal,
					 	 MemWr=> MemWr_Signal,
					 	 ByteOp=> ByteOp_Signal,
						 ID_EX_WR => ID_EX_WR_Signal,
						 EX_MEM_WR => EX_MEM_WR_Signal,
						 MEM_WB_WR => MEM_WB_WR_Signal);
 				 
				 
-----------------------------RAM-------------------------------------------
 RAM_MODULE:
	RAM Port MAP(clk => CLK,
					 inst_addr=> PC_out_Signal(12 downto 2),
					 inst_dout => Instruction_Signal,
					 data_we =>MM_WrEn_Signal,
					 data_addr => MM_Addr_Signal(10 downto 0),
					 data_din => MM_WrData_Signal,
					 data_dout => MM_RdData_Signal);
 

end Behavioral;

