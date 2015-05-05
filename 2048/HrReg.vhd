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

entity HRREG is
	port(
		clk,rst : in STD_LOGIC;
		FB : in STD_LOGIC_VECTOR(2 downto 0);
		BUSSDATA : in STD_LOGIC_VECTOR(15 downto 0);
		HROut : out STD_LOGIC_VECTOR(15 downto 0)
	);
end HRREG;

architecture Behavorial of HRREG is 
	SIGNAL HR : STD_LOGIC_VECTOR(15 downto 0);
	--HR (HJÄLP REGISTER)
begin
	process(clk,rst)
		begin
		if rising_edge(clk) then
			if rst='1' then
				HR <= X"0000";
			elsif (FB="101") then
				HR <= BUSSDATA;
			end if;
		end if;
	end process;
	
	HROut <= HR;
end Behavorial;
	
