----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:53 03/29/2022 
-- Design Name: 
-- Module Name:    Adder4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Adder4 is
	Port( Adder4In : in STD_LOGIC_VECTOR(31 downto 0);
			Adder4Out: out STD_LOGIC_VECTOR(31 downto 0));
end Adder4;

architecture Behavioral of Adder4 is
signal Adder4OutSignal : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
		Adder4OutSignal <= Adder4In + "00000000000000000000000000000100";
		Adder4Out <= Adder4OutSignal after 10 ns;
		
end Behavioral;

