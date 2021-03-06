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

entity general_reg is
	port(
		clk,rst : in STD_LOGIC;
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSS : in STD_LOGIC_VECTOR(15 downto 0);
		reg_out : out STD_LOGIC_VECTOR(15 downto 0)
	);
end general_reg;

architecture Behavorial of general_reg is 
	SIGNAL reg : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
begin
	process(BUSS)
		begin
		--if rising_edge(clk) then
			if rst='1' then
				reg <= X"0000";
			elsif (FB="001") then
				reg <= BUSS;
			end if;
		--end if;
	end process;
	
	reg_out <= reg;
end Behavorial;
	
