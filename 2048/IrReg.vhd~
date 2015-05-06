library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
--use ieee.numeric_bit;
--use ieee.numeric_std;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IRREG is
	port(
		clk,rst : in STD_LOGIC;
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSSDATA : in STD_LOGIC_VECTOR(15 downto 0);
		IROut : out STD_LOGIC_VECTOR(15 downto 0)
	);
end IRREG;

architecture Behavorial of IRREG is 
	SIGNAL IR : STD_LOGIC_VECTOR(15 downto 0);
	--IR (INSTRUKTIONS REGISTER)
begin
	process(clk,rst)
		begin
		if rising_edge(clk) then
			if rst='1' then
				IR <= X"0000";
			elsif (FB="001") then
				IR <= BUSSDATA;
			end if;
		end if;
	end process;
	
	IROut <= IR;
end Behavorial;
	
