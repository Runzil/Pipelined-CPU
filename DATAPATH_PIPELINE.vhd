library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DATAPATH_PIPELINE is
Port( Clk: in STD_LOGIC;
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
		InstructionOut: out STD_LOGIC_VECTOR(31 downto 0)

		);
end DATAPATH_PIPELINE;

		
	architecture Behavioral of DATAPATH_PIPELINE is
	

--------------------SIGNALS---------------------------
Signal busA : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal busB : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ALU_out_Sig : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MEM_out_Sig : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');



---neue_signals----------------------------------------------------------------------------------
Signal Extender_out_Sig: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal IF_ID_Adder4_IN_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal IF_ID_Adder4_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal IF_ID_Instr_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');

--ID_EX-SIGNALS---------------------------
Signal IF_IDtoID_EX_OUT_Signal : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ID_EX_ReadData_1_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ID_EX_ReadData_2_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ID_EX_SignExtend_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal ID_EX_MUX5bit_OUT_Signal: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');



--DEC_SIGNALS---------------------------
Signal MUX5bit_OUT_Signal: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
Signal INSTR25_21_Signal : STD_LOGIC_VECTOR(25 downto 21):= (others => '0');
Signal INSTR20_16_Signal : STD_LOGIC_VECTOR(20 downto 16):= (others => '0');
Signal INSTR15_11_Signal : STD_LOGIC_VECTOR(15 downto 11):= (others => '0');
Signal INSTR25_21_OUT_Signal : STD_LOGIC_VECTOR(25 downto 21):= (others => '0');
Signal INSTR20_16_OUT_Signal : STD_LOGIC_VECTOR(20 downto 16):= (others => '0');
Signal INSTR15_11_OUT_Signal : STD_LOGIC_VECTOR(15 downto 11):= (others => '0');

--EXSTAGE-SIGNALS---------------------------
Signal EX_MEM_ALURESULT_IN_SIGNAL: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal EX_MEM_ADDER2VAL_IN_SIGNAL: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');



--Control_Signals--
Signal WB_1bit_RegWrite_Signal: STD_LOGIC := '0';  --WB_1bit_PCSrc_Signal
Signal WB_2bit_MemtoReg_Signal: STD_LOGIC := '0';
Signal M_1bit_Branch_Signal: STD_LOGIC := '0';
Signal M_2bit_MemRead_Signal: STD_LOGIC := '0';
Signal M_3bit_MemWrite_Signal: STD_LOGIC := '0';
Signal EX_1bit_ALUSrc_Signal: STD_LOGIC := '0';
Signal ID_EX_EX_OUT_4bit_Signal: STD_LOGIC_VECTOR(3 downto 0):= (others => '0');

Signal WB_1bit_RegWrite_Signal2: STD_LOGIC := '0'; --WB_1bit_PCSrc_Signal2
Signal WB_2bit_MemtoReg_Signal2: STD_LOGIC := '0';
Signal M_1bit_Branch_Signal2: STD_LOGIC := '0';
Signal M_2bit_MemRead_Signal2: STD_LOGIC := '0';
Signal M_3bit_MemWrite_Signal2: STD_LOGIC := '0';

Signal WB_1bit_RegWrite_Signal3: STD_LOGIC := '0'; --WB_1bit_PCSrc_Signal3
Signal WB_2bit_MemtoReg_Signal3: STD_LOGIC := '0';

--INSTR_Signals--
Signal INSTR20_16_Signal2: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
Signal INSTR20_16_Signal3: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
Signal INSTR20_16_Signal4: STD_LOGIC_VECTOR(4 downto 0):= (others => '0');

--EX_MEM--SIGNALS---------------------------
Signal EX_MEM_Adder2val_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal EX_MEM_ALU_Result_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal EX_MEM_ReadData_2_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal EX_MEM_Zero_IN_Signal : STD_LOGIC:= '0';
Signal EX_MEM_Zero_OUT_Signal : STD_LOGIC:= '0';

--MEM_WB--SIGNALS---------------------------
Signal MEM_WB_ReadData_IN_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MEM_WB_Address_IN_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MEM_WB_ReadData_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
Signal MEM_WB_Address_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');

--EXSTAGE SIGNALS---------------------------
Signal DEC_STAGE_WR_DATA_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0'); 
--Signal ID_EX_MUX5bit_OUT_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0'); 
Signal ID_EX_INSTR25_21_OUT_Signal: STD_LOGIC_VECTOR(4 downto 0):= (others => '0'); 

--FW_SIGNALS------------------------
Signal FW_DataOut_MuxA_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0'); 
Signal FW_DataOut_MuxB_Signal: STD_LOGIC_VECTOR(31 downto 0):= (others => '0'); 

--MUX_CONTROL-SIGNALS---------------------------
 Signal MUX_CTR_nPC_sel_OUT_Signal: STD_LOGIC; 
 Signal MUX_CTR_MemtoReg_OUT_Signal: STD_LOGIC;
 Signal MUX_CTR_RegDst_OUT_Signal: STD_LOGIC; 
 Signal MUX_CTR_RegWr_OUT_Signal: STD_LOGIC;
 Signal MUX_CTR_ExtOp_OUT_Signal: STD_LOGIC_VECTOR(1 downto 0);
 Signal MUX_CTR_ALUsrc_OUT_Signal : STD_LOGIC; 
 Signal MUX_CTR_ALUctr_OUT_Signal: STD_LOGIC_VECTOR(3 downto 0);
 Signal MUX_CTR_MemWr_OUT_Signal: STD_LOGIC;	
 Signal MUX_CTR_ByteOp_OUT_Signal: STD_LOGIC;	

--HAZARD_UNIT-SIGNALS---------------------------
Signal Hazard_IF_ID_Write_Signal: STD_LOGIC; 
Signal Hazard_HazUnit_Sel_Out_Signal: STD_LOGIC; 
Signal Hazarad_PCWrite_Signal: STD_LOGIC; 

------------------------COMPONENTS--------------------------------------
----------------------------IFSTAGE----------------------------------------
Component IF_STAGE_PIPELINE is
	Port(	 PC_Immed 	: in STD_LOGIC_VECTOR(31 downto 0);
			 PC_sel 		: in STD_LOGIC;
			 PC_LdEn 	:in STD_LOGIC;
			 Reset 		:in STD_LOGIC;
			 Clk 			:in STD_LOGIC;
			 PC 			: out STD_LOGIC_VECTOR(31 downto 0);
			 IFAdder4Out: out STD_LOGIC_VECTOR(31 downto 0));
end Component;

----------------------------IF_ID----------------------------------------
Component IF_ID is
	Port(Clk 	 :in STD_LOGIC;
		Reset  :in STD_LOGIC;
		IF_ID_WR :in STD_LOGIC;
		IF_ID_Instruction_IN: in STD_LOGIC_VECTOR(31 downto 0);
		IF_ID_Adder4out_IN	: in STD_LOGIC_VECTOR(31 downto 0);
		IF_ID_Instruction_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		IF_ID_Adder4out_OUT 	: out STD_LOGIC_VECTOR(31 downto 0)	
		);
end Component;
-----------------------------------------------------------------------
-----------------------------DECSTAGE----------------------------------
Component DEC_STAGE_PIPELINE is
	Port( Instr : in STD_LOGIC_VECTOR(31 downto 0);
			RF_WrEn: in STD_LOGIC;
			ALU_out : in STD_LOGIC_VECTOR(31 downto 0);
			MEM_out : in STD_LOGIC_VECTOR(31 downto 0);
			RF_WrData_sel : in STD_LOGIC;
			RF_B_sel :in STD_LOGIC;
			ImmExt :in STD_LOGIC_VECTOR(1 downto 0);
			Clk :in STD_LOGIC;
			Immed: out STD_LOGIC_VECTOR(31 downto 0);
			RF_A: out STD_LOGIC_VECTOR(31 downto 0);
			RF_B: out STD_LOGIC_VECTOR(31 downto 0);
			Reset : in STD_LOGIC;
			RdIn: in STD_LOGIC_VECTOR(4 downto 0);

			
			MUX5bit_OUT: out STD_LOGIC_VECTOR(4 downto 0);
			INSTR25_21 : out STD_LOGIC_VECTOR(25 downto 21);
			INSTR20_16 : out STD_LOGIC_VECTOR(20 downto 16);
			INSTR15_11 : out STD_LOGIC_VECTOR(15 downto 11);
			DEC_STAGE_WR_DATA :out STD_LOGIC_VECTOR(31 downto 0));
end Component;

------------------------------ID_EX-----------------------------------
Component ID_EX is
Port( Clk 	 :in STD_LOGIC;
		Reset  :in STD_LOGIC;
		ID_EX_WR :in STD_LOGIC;

		
		IF_IDtoID_EX_IN : in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_1_IN: in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_2_IN: in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_SignExtend_IN: in STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_MUX5bit_IN: in STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR25_21_IN : in STD_LOGIC_VECTOR(25 downto 21);
		ID_EX_INSTR20_16_IN : in STD_LOGIC_VECTOR(20 downto 16);
		ID_EX_INSTR15_11_IN : in STD_LOGIC_VECTOR(15 downto 11);
		
		
		ID_EX_WB_IN_1bit :in STD_LOGIC;
		ID_EX_WB_IN_2bit :in STD_LOGIC;
		
		ID_EX_M_IN_1bit :in STD_LOGIC;
		ID_EX_M_IN_2bit :in STD_LOGIC;
		ID_EX_M_IN_3bit :in STD_LOGIC;
		
		
		ID_EX_EX_IN_1bit :in STD_LOGIC;
		ID_EX_EX_IN_4bit :in STD_LOGIC_VECTOR(3 downto 0);
		
		
		IF_IDtoID_EX_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_1_OUT: out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_ReadData_2_OUT: out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_SignExtend_OUT: out STD_LOGIC_VECTOR(31 downto 0);
		ID_EX_MUX5bit_OUT: out STD_LOGIC_VECTOR(4 downto 0);
		ID_EX_INSTR25_21_OUT : out STD_LOGIC_VECTOR(25 downto 21);
		ID_EX_INSTR20_16_OUT : out STD_LOGIC_VECTOR(20 downto 16);
		ID_EX_INSTR15_11_OUT : out STD_LOGIC_VECTOR(15 downto 11);		
		

		ID_EX_WB_OUT_1bit :out STD_LOGIC;
		ID_EX_WB_OUT_2bit :out STD_LOGIC;
		
		ID_EX_M_OUT_1bit :out STD_LOGIC;
		ID_EX_M_OUT_2bit :out STD_LOGIC;
		ID_EX_M_OUT_3bit :out STD_LOGIC;
		
		
		ID_EX_EX_OUT_1bit :out STD_LOGIC;
		ID_EX_EX_OUT_4bit :out STD_LOGIC_VECTOR(3 downto 0)
		);
end Component;
--------------------------------------------------------------------------
------------------------EXSTAGE-------------------------------------------
Component EX_STAGE_PIPELINE is
	Port(RF_A : in STD_LOGIC_VECTOR(31 downto 0);
		  RF_B : in STD_LOGIC_VECTOR(31 downto 0);
		  Immed: in STD_LOGIC_VECTOR(31 downto 0);
		  ALU_Bin_sel: in STD_LOGIC;
		  ALU_func: in STD_LOGIC_VECTOR(3 downto 0);
		  ALU_out: out STD_LOGIC_VECTOR(31 downto 0);
		  ALU_zero: out STD_LOGIC;
		  Ex_Ovf:out STD_LOGIC;
		  Ex_Cout: out STD_LOGIC;
		  
		  
		  Adder4out: in STD_LOGIC_VECTOR(31 downto 0);
		  Adder2ValuesOut: out STD_LOGIC_VECTOR(31 downto 0));
end Component;

------------------------EX_MEM-------------------------------------------
Component EX_MEM is
Port(   Clk 	:in STD_LOGIC;
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
end Component;
--------------------------------------------------------------------------
-----------------------MEMSTAGE-----------------------------------------------
Component MEM_STAGE_PIPELINE is
	Port(	ByteOp : in STD_LOGIC;
			Mem_WrEn: in STD_LOGIC;
			ALU_MEM_Addr: in STD_LOGIC_VECTOR(31 downto 0);
			MEM_DataIn: in STD_LOGIC_VECTOR(31 downto 0);
			MEM_DataOut: out STD_LOGIC_VECTOR(31 downto 0);
			MM_WrEn: out STD_LOGIC;
			MM_Addr: out STD_LOGIC_VECTOR(31 downto 0);
			MM_WrData: out STD_LOGIC_VECTOR(31 downto 0);
			MM_RdData: in STD_LOGIC_VECTOR(31 downto 0));
end Component;
-----------------------MEM_WB-----------------------------------------------
Component MEM_WB is
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
end Component;

Component ForwardUnit is
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
end Component;


Component Control_Mux is
Port( nPC_sel_IN: in STD_LOGIC; 
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
end Component;


Component HazardUnit is
Port( ID_EX_MemRead : in STD_LOGIC;
		ID_EX_RegisterRt : in STD_LOGIC_VECTOR(4 downto 0);
		IF_ID_RegisterRs : in STD_LOGIC_VECTOR(4 downto 0);
		IF_ID_RegisterRt : in STD_LOGIC_VECTOR(4 downto 0);
		
		IF_ID_Write		 : out STD_LOGIC;
		HazUnit_Sel_Out : out STD_LOGIC
		--PCWrite			 : out STD_LOGIC
		);
end Component;

--==========================================================================
--==========================================================================
--==========================================================================
--==========================================================================
begin
----------------------------IFSTAGE----------------------------------------
IF_STAGE_PIPELINE_Module:
	IF_STAGE_PIPELINE Port MAP (PC_Immed  => EX_MEM_Adder2val_OUT_Signal, --adder2value
										 PC_sel 	 => M_1bit_Branch_Signal2,	
										 PC_LdEn   => Hazard_IF_ID_Write_Signal,	
										 Reset 	 => Reset,	
										 Clk 		 => Clk,	
										 PC 		 => PC_out,
										 IFAdder4Out => IF_ID_Adder4_IN_Signal
										 );
									 
----------------------------IF_ID----------------------------------------
IF_ID_Module:
	IF_ID		 Port MAP(Clk 	   => Clk,
							 Reset   => Reset,
							 IF_ID_WR  => Hazard_IF_ID_Write_Signal, --IF_ID_WR, --
							 IF_ID_Instruction_IN => Instruction,
							 IF_ID_Adder4out_IN	=> IF_ID_Adder4_IN_Signal,
							 IF_ID_Instruction_OUT =>IF_ID_Adder4_OUT_Signal,
							 IF_ID_Adder4out_OUT => IF_ID_Instr_OUT_Signal
							 );
----------------------------------------------------------------------------
				InstructionOut <= IF_ID_Adder4_OUT_Signal;						 
----------------------------DECSTAGE----------------------------------------
DEC_STAGE_PIPELINE_Module:
DEC_STAGE_PIPELINE	Port MAP( Instr => IF_ID_Adder4_OUT_Signal, --TODO AGAIN
						 RF_WrEn=> WB_1bit_RegWrite_Signal3,
						 ALU_out => MEM_WB_Address_OUT_Signal,--
						 MEM_out => MEM_WB_ReadData_OUT_Signal,--
						 RF_WrData_sel => WB_2bit_MemtoReg_Signal3,
						 RF_B_sel => MUX_CTR_RegDst_OUT_Signal, --from control_mux
						 ImmExt => MUX_CTR_ExtOp_OUT_Signal,--from control_mux
						 Clk => Clk,
						 Immed => Extender_out_Sig,
						 RF_A=> busA,
						 RF_B=> busB,
						 Reset => Reset,
						 RdIn => INSTR20_16_Signal4,
						 

						 MUX5bit_OUT=> MUX5bit_OUT_Signal,
						 INSTR25_21 => INSTR25_21_Signal,  --rs
						 INSTR20_16 => INSTR20_16_Signal,  --rd 
						 INSTR15_11 => INSTR15_11_Signal,  --rt
						 DEC_STAGE_WR_DATA => DEC_STAGE_WR_DATA_Signal);
------------------------------ID_EX-----------------------------------

ID_EX_Module: 
ID_EX	 Port MAP( Clk 	 => Clk,
							  Reset  => Reset,
							  ID_EX_WR => ID_EX_WR,
							  
							  IF_IDtoID_EX_IN => IF_ID_Instr_OUT_Signal,
							  ID_EX_ReadData_1_IN=> busA,
							  ID_EX_ReadData_2_IN=> busB,
							  ID_EX_SignExtend_IN=> Extender_out_Sig,
							  ID_EX_MUX5bit_IN=> MUX5bit_OUT_Signal, --rd / rt
							  ID_EX_INSTR25_21_IN => INSTR25_21_Signal,
							  ID_EX_INSTR20_16_IN => INSTR20_16_Signal,
							  ID_EX_INSTR15_11_IN => INSTR15_11_Signal,
	

							  ID_EX_WB_IN_1bit => MUX_CTR_RegWr_OUT_Signal, --from control_mux
							  ID_EX_WB_IN_2bit => MUX_CTR_MemtoReg_OUT_Signal,--from control_mux
		
							  ID_EX_M_IN_1bit => MUX_CTR_nPC_sel_OUT_Signal,--from control_mux
							  ID_EX_M_IN_2bit => MUX_CTR_ByteOp_OUT_Signal,--from control_mux
							  ID_EX_M_IN_3bit => MUX_CTR_MemWr_OUT_Signal,--from control_mux
		
		
							  ID_EX_EX_IN_1bit => MUX_CTR_ALUsrc_OUT_Signal,--from control_mux
							  ID_EX_EX_IN_4bit  => MUX_CTR_ALUctr_OUT_Signal,--from control_mux
							  
							  
							  IF_IDtoID_EX_OUT => IF_IDtoID_EX_OUT_Signal,
					 		  ID_EX_ReadData_1_OUT=> ID_EX_ReadData_1_OUT_Signal,
						 	  ID_EX_ReadData_2_OUT=> ID_EX_ReadData_2_OUT_Signal,
							  ID_EX_SignExtend_OUT=> ID_EX_SignExtend_OUT_Signal,
							  ID_EX_MUX5bit_OUT=> ID_EX_MUX5bit_OUT_Signal ,--ID_EX_MUX5bit_OUT_Signal,
							  ID_EX_INSTR25_21_OUT => ID_EX_INSTR25_21_OUT_Signal ,--INSTR25_21_OUT_Signal,
							  ID_EX_INSTR20_16_OUT => INSTR20_16_Signal2 ,--INSTR20_16_OUT_Signal, --TODO AGAIN
							  ID_EX_INSTR15_11_OUT => INSTR15_11_OUT_Signal ,--INSTR15_11_OUT_Signal,
							  
							  
							  ID_EX_WB_OUT_1bit => WB_1bit_RegWrite_Signal,
							  ID_EX_WB_OUT_2bit => WB_2bit_MemtoReg_Signal,
		
							  ID_EX_M_OUT_1bit => M_1bit_Branch_Signal,
							  ID_EX_M_OUT_2bit => M_2bit_MemRead_Signal,
							  ID_EX_M_OUT_3bit => M_3bit_MemWrite_Signal,
		
		
							  ID_EX_EX_OUT_1bit => EX_1bit_ALUSrc_Signal,
							  ID_EX_EX_OUT_4bit => ID_EX_EX_OUT_4bit_Signal);
						 
----------------------------------------------------------------------------						 
----------------------------EXSTAGE-----------------------------------------
EX_STAGE_PIPELINE_Module:
EX_STAGE_PIPELINE	Port MAP(RF_A => FW_DataOut_MuxA_Signal,
							RF_B => FW_DataOut_MuxB_Signal,
							Immed => ID_EX_SignExtend_OUT_Signal,
							ALU_Bin_sel => EX_1bit_ALUSrc_Signal,
							ALU_func => ID_EX_EX_OUT_4bit_Signal,
							ALU_out => EX_MEM_ALURESULT_IN_SIGNAL,
							ALU_zero => EX_MEM_Zero_IN_Signal,
							Ex_Ovf => open,
							Ex_Cout => open,
							
							Adder4out => IF_IDtoID_EX_OUT_Signal,
							Adder2ValuesOut=> EX_MEM_ADDER2VAL_IN_SIGNAL);

-----------------------------EX_MEM-------------------------------------------
EX_MEM_Module:
EX_MEM 	Port MAP( Clk 	 => Clk,
				  Reset  => Reset,
				  EX_MEM_WR=> EX_MEM_WR,

				  EX_MEM_Adder2val_IN => EX_MEM_ADDER2VAL_IN_SIGNAL,
				  EX_MEM_Zero_IN => EX_MEM_Zero_IN_Signal, --TODO AGAIN
				  EX_MEM_ALU_Result_IN => EX_MEM_ALURESULT_IN_SIGNAL,
				  EX_MEM_ReadData_2_IN => FW_DataOut_MuxB_Signal,


				  EX_MEM_Adder2val_OUT => EX_MEM_Adder2val_OUT_Signal,
				  EX_MEM_Zero_OUT => Zero_control,
				  EX_MEM_ALU_Result_OUT=> EX_MEM_ALU_Result_OUT_Signal,
				  EX_MEM_ReadData_2_OUT=> EX_MEM_ReadData_2_OUT_Signal,



				  EX_MEM_WB_IN_1bit => WB_1bit_RegWrite_Signal,
				  EX_MEM_WB_IN_2bit => WB_2bit_MemtoReg_Signal,
		
				  EX_MEM_M_IN_1bit => M_1bit_Branch_Signal,
				  EX_MEM_M_IN_2bit => M_2bit_MemRead_Signal,
				  EX_MEM_M_IN_3bit => M_3bit_MemWrite_Signal,

				  EX_MEM_WB_OUT_1bit => WB_1bit_RegWrite_Signal2,
				  EX_MEM_WB_OUT_2bit => WB_2bit_MemtoReg_Signal2,
		
				  EX_MEM_M_OUT_1bit => M_1bit_Branch_Signal2,
				  EX_MEM_M_OUT_2bit => M_2bit_MemRead_Signal2,
				  EX_MEM_M_OUT_3bit => M_3bit_MemWrite_Signal2,
				  
				  EX_MEM_INSTR20_16_IN => INSTR20_16_Signal2,
				  EX_MEM_INSTR20_16_OUT =>INSTR20_16_Signal3);


-----------------------------------------------------------------------------						 
----------------------------MEMSTAGE-----------------------------------------
MEM_STAGE_PIPELINE_Module :
MEM_STAGE_PIPELINE	Port MAP(	ByteOp => M_2bit_MemRead_Signal2, 
											Mem_WrEn=> M_3bit_MemWrite_Signal2,
											ALU_MEM_Addr=> EX_MEM_ALU_Result_OUT_Signal, --in
											MEM_DataIn=> EX_MEM_ReadData_2_OUT_Signal,
											MEM_DataOut=> MEM_WB_ReadData_IN_Signal,
											MM_WrEn=> MM_WrEn,
											MM_Addr=> MM_Addr,
											MM_WrData=> MM_WrData,
											MM_RdData=> MM_RdData);
											
----------------------------MEM_WB-----------------------------------------
MEM_WB_Module :
MEM_WB Port MAP(	Clk 	 => Clk,
						Reset  => Reset,
						MEM_WB_WR => MEM_WB_WR,
				
						MEM_WB_ReadData_IN => MEM_WB_ReadData_IN_Signal,
						MEM_WB_Address_IN => EX_MEM_ALU_Result_OUT_Signal, --TODO AGAIN

						MEM_WB_ReadData_OUT => MEM_WB_ReadData_OUT_Signal,
						MEM_WB_Address_OUT => MEM_WB_Address_OUT_Signal,

						MEM_WB_WB_IN_1bit => WB_1bit_RegWrite_Signal2,--in
						MEM_WB_WB_IN_2bit => WB_2bit_MemtoReg_Signal2,--in

						MEM_WB_WB_OUT_1bit => WB_1bit_RegWrite_Signal3,
						MEM_WB_WB_OUT_2bit => WB_2bit_MemtoReg_Signal3,
						
						
						MEM_WB_INSTR20_16_IN => INSTR20_16_Signal3,
						MEM_WB_INSTR20_16_OUT=> INSTR20_16_Signal4);
											
-----------------------------FORWARD_UNIT-------------------------------------------------
ForwardUnit_Module:
ForwardUnit Port MAP( EX_MEM_RegWrite => WB_1bit_RegWrite_Signal2,
					  EX_MEM_RegisterRd => INSTR20_16_Signal3,
		
					  ID_EX_RegisterRs => ID_EX_INSTR25_21_OUT_Signal,
					  ID_EX_MUX_RegisterRt_d => ID_EX_MUX5bit_OUT_Signal,
			
					  MEM_WB_RegWrite => WB_1bit_RegWrite_Signal3,
					  MEM_WB_RegisterRd => INSTR20_16_Signal4,
		
		
					  DataIn1_MuxA  => ID_EX_ReadData_1_OUT_Signal,
					  DataIn2_MuxA  => DEC_STAGE_WR_DATA_Signal,
					  DataIn3_MuxA  => EX_MEM_ALU_Result_OUT_Signal,
					  DataOut_MuxA  => FW_DataOut_MuxA_Signal,
		
					  DataIn1_MuxB  => ID_EX_ReadData_2_OUT_Signal,
					  DataIn2_MuxB  => DEC_STAGE_WR_DATA_Signal,
					  DataIn3_MuxB  => EX_MEM_ALU_Result_OUT_Signal,
					  DataOut_MuxB  => FW_DataOut_MuxB_Signal);


-----------------------------CONTROL_MUX-------------------------------------------------
Control_Mux_Module:
Control_Mux Port MAP( 	nPC_sel_IN => nPC_sel,
							 MemtoReg_IN => MemtoReg,
							 RegDst_IN => RegDst,
							 RegWr_IN => RegWr,
							 ExtOp_IN => ExtOp,
							 ALUsrc_IN => ALUsrc,
							 ALUctr_IN => ALUctr,
							 MemWr_IN => MemWr,
							 ByteOp_IN => ByteOp,
		
							 Sel => Hazard_HazUnit_Sel_Out_Signal,
		
							 nPC_sel_OUT => MUX_CTR_nPC_sel_OUT_Signal,
							 MemtoReg_OUT =>  MUX_CTR_MemtoReg_OUT_Signal,
							 RegDst_OUT =>  MUX_CTR_RegDst_OUT_Signal,
							 RegWr_OUT =>  MUX_CTR_RegWr_OUT_Signal,
							 ExtOp_OUT =>  MUX_CTR_ExtOp_OUT_Signal,
							 ALUsrc_OUT =>  MUX_CTR_ALUsrc_OUT_Signal,
							 ALUctr_OUT =>  MUX_CTR_ALUctr_OUT_Signal,
							 MemWr_OUT =>  MUX_CTR_MemWr_OUT_Signal,
							 ByteOp_OUT =>  MUX_CTR_ByteOp_OUT_Signal);
							 
-----------------------------Hazard_Unit-------------------------------------------------
HazardUnit_Module:
HazardUnit Port MAP( ID_EX_MemRead => WB_2bit_MemtoReg_Signal,
					 ID_EX_RegisterRt => ID_EX_MUX5bit_OUT_Signal, --mux_out rd/rt
					 IF_ID_RegisterRs => IF_ID_Adder4_OUT_Signal(25 downto 21),
					 IF_ID_RegisterRt => IF_ID_Adder4_OUT_Signal(15 downto 11),
		
					 IF_ID_Write	 => Hazard_IF_ID_Write_Signal,
					 HazUnit_Sel_Out => Hazard_HazUnit_Sel_Out_Signal
					 --PCWrite	     => Hazarad_PCWrite_Signal
					 );
				 
				 
end Behavioral;

