library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HazardUnit is
Port( ID_EX_MemRead : in STD_LOGIC;
		ID_EX_RegisterRt : in STD_LOGIC_VECTOR(4 downto 0); --idex rt/rd
		IF_ID_RegisterRs : in STD_LOGIC_VECTOR(4 downto 0);
		IF_ID_RegisterRt : in STD_LOGIC_VECTOR(4 downto 0);
		
		IF_ID_Write		 : out STD_LOGIC;
		HazUnit_Sel_Out : out STD_LOGIC
		--PCWrite			 : out STD_LOGIC
		);
end HazardUnit;

architecture Behavioral of HazardUnit is

begin


process(ID_EX_MemRead,IF_ID_RegisterRt,IF_ID_RegisterRs,ID_EX_RegisterRt)
begin
	IF((ID_EX_MemRead = '1') AND ((ID_EX_RegisterRt = IF_ID_RegisterRs) OR (ID_EX_RegisterRt = IF_ID_RegisterRt))) THEN
		HazUnit_Sel_Out <= '1';
		IF_ID_Write <= '0';
		--PCWrite <= '0';
	ELSE
		HazUnit_Sel_Out <= '0';
		IF_ID_Write <= '1';
		--PCWrite <= '1';		
	END IF;
	
end process;

 

end Behavioral;

