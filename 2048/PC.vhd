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

entity PC is
	port(	clk,rst : in std_logic;
		P : in STD_LOGIC;
		buss_data : in STD_LOGIC_VECTOR(15 downto 0);
		FB : in std_logic_vector(2 downto 0);
		PC_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
end PC;

architecture Behavorial of PC is 
	SIGNAL PCounter : STD_LOGIC_VECTOR(7 downto 0) := X"00";
begin
	process(clk,rst) begin
		if rising_edge(clk) then 
			if P = '1' then
				PCounter <= pCounter + 1;
			elsif FB = "011" then
				PCounter <= std_logic_vector(resize(UNSIGNED(buss_data),PCounter'LENGTH));
			end if;
		end if;
	end process;
	
	PC_out <= pCounter;
end Behavorial;
	
